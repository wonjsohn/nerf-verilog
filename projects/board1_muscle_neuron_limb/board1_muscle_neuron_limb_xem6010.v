`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Creator: C. Minos Niu
// 
// Module Name:    
// Project Name: 
// Target Devices: XEM6010 - OpalKelly
// Design properties: xc6slx150-2fgg484
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module board1_muscle_neuron_limb_xem6010(
	input  wire [7:0]  hi_in,
	output wire [1:0]  hi_out,
	inout  wire [15:0] hi_inout,
	inout  wire        hi_aa,

	output wire        i2c_sda,
	output wire        i2c_scl,
	output wire        hi_muxsel,
	input  wire        clk1,
	input  wire        clk2,
	
	output wire [7:0]  led,
    output wire pin0,
    output wire pin1,
    output wire pin2,
    output wire pin_jp1_41, //SPI pins
    output wire pin_jp1_42, 
//    input wire pin_jp1_50, 
    output wire pin_jp1_49,
//    output wire pin_jp1_51,  // SPI pins
//    output wire pin_jp1_52, 
//    input wire pin_jp1_60, 
//    output wire pin_jp1_59,
    
    input wire pin_jp2_41,
    input wire pin_jp2_42,
//    output wire pin_jp2_50,
    input wire pin_jp2_49
//    input wire pin_jp2_51,
//    input wire pin_jp2_52,
//    output wire pin_jp2_60,
//    input wire pin_jp2_59,
    
    //sim_clk
    //output wire pin_jp1_sim_clk
    //input wire pin_jp2_sim_clk
   );
   
    parameter NN = 8;
		
    // *** Dump all the declarations here:
    wire         ti_clk;
    wire [30:0]  ok1;
    wire [16:0]  ok2;   
    wire [15:0]  ep00wire, ep01wire, ep02wire, ep50trig, ep20wire, ep21wire, ep22wire, ep23wire;
    wire [15:0]  ep24wire, ep25wire, ep26wire, ep27wire, ep28wire, ep29wire, ep30wire, ep31wire;
    wire reset_global, reset_sim;
    wire        is_pipe_being_written, is_lce_valid;
    
    wire [15:0] hex_from_py;
    
    reg [17:0] delay_cnt, delay_cnt_max;
    
    reg [15:0] rawspikes;
    wire pipe_out_read;
 
    // *** Target interface bus:
    assign i2c_sda = 1'bz;
    assign i2c_scl = 1'bz;
    assign hi_muxsel = 1'b0;

  // *** Buttons, physical on XEM3010, software on XEM3050 & XEM6010
    // *** Reset & Enable signals
    assign reset_global = ep00wire[0];
    assign reset_sim = ep00wire[1];
    assign button1 = ep00wire[2];  // testing sensitivity list
    assign button2 = ep00wire[3];
    //assign enable_sim = is_waveform_valid;
    wire    [31:0]  IEEE_1, IEEE_0;
	assign IEEE_1 = 32'h3F800000;
	assign IEEE_0 = 32'd0;

    // *** Triggered input from Python
       // *** Triggered input from Python
    always @(posedge ep50trig[7] or posedge reset_global)
    begin
        if (reset_global)
            delay_cnt_max <= delay_cnt_max;
        else
            delay_cnt_max <= {2'b00, ep01wire};  //firing rate
    end
    
    
    reg [31:0] f_pps_coef_Ia;
    always @(posedge ep50trig[1] or posedge reset_global)
    begin
        if (reset_global)
            f_pps_coef_Ia <= 32'h3F66_6666;
        else
            f_pps_coef_Ia <= {ep02wire, ep01wire};  //firing rate
    end       
    
    reg [31:0] f_pps_coef_II;
    always @(posedge ep50trig[2] or posedge reset_global)
    begin
        if (reset_global)
            f_pps_coef_II <= 32'h3F66_6666;
        else
            f_pps_coef_II <= {ep02wire, ep01wire};  //firing rate
    end           
    
    reg [31:0] gain;
    always @(posedge ep50trig[3] or posedge reset_global)
    begin
        if (reset_global)
            gain <= 32'd0;
        else
            gain <= {ep02wire, ep01wire};  //firing rate
    end        
    
    reg [31:0] f_gamma_dyn;
    always @(posedge ep50trig[4] or posedge reset_global)
    begin
        if (reset_global)
            f_gamma_dyn <= 32'h42A0_0000; // gamma_dyn reset to 80
        else
            f_gamma_dyn <= {ep02wire, ep01wire};  
    end  
    
    reg [31:0] f_gamma_sta;
    always @(posedge ep50trig[5] or posedge reset_global)
    begin
        if (reset_global)
            f_gamma_sta <= 32'h42A0_0000; // gamma_sta reset to 80
        else
            f_gamma_sta <= {ep02wire, ep01wire};  
    end  
    
    reg [31:0] i_gain_MN;
    always @(posedge ep50trig[6] or posedge reset_global)
    begin
        if (reset_global)
            i_gain_MN <= 32'd1; // gamma_sta reset to 80
        else
            i_gain_MN <= {ep02wire, ep01wire};  
    end      
//    
//    reg [31:0] delay_cnt_max;
//    always @(posedge ep50trig[7] or posedge reset_global)
//    begin
//        if (reset_global)
//            delay_cnt_max <= delay_cnt_max;
//        else
//            delay_cnt_max <= {ep02wire, ep01wire};  //firing rate
//    end        
//    
    reg [31:0] BDAMP_1, BDAMP_2, BDAMP_chain, GI, GII;
    always @(posedge ep50trig[15] or posedge reset_global)
    begin
        if (reset_global)
            BDAMP_1 <= 32'h3E71_4120; // bag 1 BDAMP reset to 0.2356
        else
            BDAMP_1 <= {ep02wire, ep01wire};  //firing rate
    end
    always @(posedge ep50trig[14] or posedge reset_global)
    begin
        if (reset_global)
            BDAMP_2 <= 32'h3D14_4674; // bag 2 BDAMP reset to 0.0362
        else
            BDAMP_2 <= {ep02wire, ep01wire};  //firing rate
    end    
    always @(posedge ep50trig[13] or posedge reset_global)
    begin
        if (reset_global)
            BDAMP_chain <= 32'h3C58_44D0; // chain BDAMP reset to 0.0132 
        else
            BDAMP_chain <= {ep02wire, ep01wire};  //firing rate
    end
    
    // *** Deriving clocks from on-board clk1:
    wire neuron_clk, sim_clk, spindle_clk;
    wire [NN+2:0] neuronCounter;

    gen_clk #(.NN(NN)) useful_clocks
    (   .rawclk(clk1), 
        .half_cnt(delay_cnt_max), 
        .clk_out1(neuron_clk), 
        .clk_out2(sim_clk), 
        .clk_out3(spindle_clk),
        .int_neuron_cnt_out(neuronCounter) );
                
    
    // *** Generating waveform to stimulate the spindle
     wire    [31:0] f_muscle_len;
	waveform_from_pipe gen(	
        .ti_clk(ti_clk),
        .reset(reset_global),
        .repop(reset_sim),
        .feed_data_valid(is_pipe_being_written),
        .feed_data(hex_from_py),
        .current_element(f_muscle_len),
        .test_clk(sim_clk),
        .done_feeding(is_lce_valid)
    );    

    // *** Spindle: f_muscle_len => f_rawfr_Ia
    wire [31:0] x_0, x_1, f_rawfr_II;
    

//** SPI communication (soon to be modularized after initial test)

    //reg   [23:0] clkdiv; 
    wire [23:0] clkdiv;
    assign clkdiv = 24'hD;  //13

    reg   [31:0] data32;
     
    wire   en;


    wire [31:0] master_out;
    wire rdy;
    wire [31:0] slave_out;
     
    //master sending out     
    wire DATA_s;  //mosi
    wire SSEL_s;   //ssel
    wire SCK_s;  //sck
    //wire XLXN_4; //miso
    
    //slave receiving in
    //wire XLXN_5;  //mosi
    wire SSEL_r;   //ssel
    wire SCK_r;  //sck
    wire DATA_r; //miso
   
//    //more wires for multi transfer
//    wire XLXN_9;  //mosi
//    wire XLXN_10;   //ssel
//    wire XLXN_11;  //sck
//    wire XLXN_12; //miso
//    
//    wire XLXN_13;  //mosi
//    wire XLXN_14;   //ssel
//    wire XLXN_15;  //sck
//    wire XLXN_16; //miso
    

    
     wire MISO_data, endmsg;
    //Master module
    spi_master  bodymaster (.clk(clk1), 
                      .clkdiv(clkdiv[23:0]), 
                      .data32(f_muscle_len), 
                      .en(1'b1), 
                      .reset(reset_global), 
                      .SIMCK(sim_clk), 
                      .DATA_OUT(DATA_s), 
                      .rx_data(master_out[31:0]), 
                      .SCK(SCK_s), 
                      .SSEL(SSEL_s));

//
    //slave module
	wire [31:0] f_rawfr_Ia_spi;
    spi_slave  bodyslave (.clk(clk1), 
                     .en(1'b1), 
                     .reset(reset_global), 
                     .SCK(SCK_r), 
                     .SSEL(SSEL_r), 
                     .DATA_IN(DATA_r), 
                     .rdy(rdy), 
                     .rx_out(f_rawfr_Ia_spi));
                    
    reg [31:0] f_rawfr_Ia, f_rawfr_Ia_safe_spi;
    always @(negedge spindle_clk or posedge reset_global) begin
        if (reset_global) begin
            f_rawfr_Ia_safe_spi <= 32'd0;
        end
        else begin
            f_rawfr_Ia_safe_spi <= f_rawfr_Ia_spi;
        end
    end
    always @(posedge sim_clk or posedge reset_global) begin
        if (reset_global) begin
            f_rawfr_Ia <= 32'd0;
        end
        else begin
            f_rawfr_Ia <= f_rawfr_Ia_safe_spi;
        end
    end



  //output SPI pins
    assign pin_jp1_41 = SCK_s;  //SCK
    assign pin_jp1_42 = DATA_s;   //MOSI
    assign pin_jp1_49 = SSEL_s;   //SSEL
    
//    assign pin_jp1_51 = XLXN_15;
//    assign pin_jp1_52 = XLXN_13;
//    assign XLXN_16 = pin_jp1_60;
//    assign pin_jp1_59 = XLXN_14;

////    //input SPI pins (1)  
//    assign XLXN_7 = pin_jp2_51;  //SCK
//    assign XLXN_5 = pin_jp2_52;   //MOSI
//    assign pin_jp2_60 = XLXN_8;   //MISO
//    assign XLXN_6 = pin_jp2_59;   //SSEL
    
     //input SPI pins (2)
    assign SCK_r = pin_jp2_41;  //SCK
    assign DATA_r = pin_jp2_42;   //MOSI
    //assign pin_jp2_50 = XLXN_12;    //MISO
    assign SSEL_r = pin_jp2_49;   //SSEL
	
    //assign XLXN_4 = pin_jp1_50;    //MISO
    //sim_clk 
    //assign sim_clk = pin_jp2_sim_clk; 
    //assign pin_jp1_sim_clk = sim_clk;
    
    
//**  end of spi communication



    //// *** Spindle: f_muscle_len => f_rawfr_Ia
   //wire [31:0] f_rawfr_Ia, x_0, x_1, f_rawfr_II;


    // SPINDLE NOT AVAILABLE ON THIS CHIP!!!
    // GET f_rawfr_Ia AND f_rawfr_II FROM BOARD2!!!

/*
    spindle bag1_bag2_chain
    (	.gamma_dyn(f_gamma_dyn), // 32'h42A0_0000
        .gamma_sta(f_gamma_sta),
        .lce(f_muscle_len),
        .clk(spindle_clk),
        .reset(reset_sim),
        .out0(x_0),
        .out1(x_1),
        .out2(f_rawfr_II),
        .out3(f_rawfr_Ia),
        .BDAMP_1(BDAMP_1),
        .BDAMP_2(BDAMP_2),
        .BDAMP_chain(BDAMP_chain)
		);

*/

    // *** Izhikevich: f_fr_Ia => spikes
        // *** Convert float_fr to int_I1
	/*
    wire [31:0] f_fr_Ia;
    wire [31:0] i_synI_Ia;
	mult scale_pps_Ia( .x(f_rawfr_Ia), .y(f_pps_coef_Ia), .out(f_fr_Ia));
    floor float_to_int_Ia( .in(f_fr_Ia), .out(i_synI_Ia) );
    
    wire Ia_spike, s_Ia;
    wire signed [17:0] v_Ia;   // cell potentials
    Iz_neuron #(.NN(NN),.DELAY(10)) Ia_neuron
    (v_Ia,s_Ia, a,b,c,d, i_synI_Ia, neuron_clk, reset_sim, neuronIndex, neuronWriteEnable, readClock, 4'h2, Ia_spike);

    wire [31:0] f_fr_II;
    wire [31:0] i_synI_II;
    mult scale_pps_II( .x(f_rawfr_II), .y(f_pps_coef_II), .out(f_fr_II));
    floor float_to_int_II( .in(f_fr_II), .out(i_synI_II) );
    wire II_spike, s_II;
    wire signed [17:0] v_II;   // cell potentials
    Iz_neuron #(.NN(NN),.DELAY(10)) II_neuron
    (v_II,s_II, a,b,c,d, i_synI_II, neuron_clk, reset_sim, neuronIndex, neuronWriteEnable, readClock, 4'h2, II_spike);

    //*** Synapse:: spike -> I   
	wire [17:0]  I_out;
	wire [17:0]	w1, w2, w3;
	wire spk1, spk2, spk3;
    wire [31:0] i_postsyn_I;
    
//	synapse_int syn1(
//			.I_out(I_out),
//			.spk1(1'b0),
//			.w1(18'd1),
//			.spk2(Ia_spike),
//			.w2(18'd1),
//			.spk3(1'b0),
//			.w3(18'd1),
//			.clk(sim_clk),
//			.reset(reset_sim)
//	);
	wire signed [17:0] Ia_w1, Ia_w2;  //learned synaptic weights

	synapse   #(.NN(NN)) synIa(I_out, 	Ia_spike, 18'sh01000, 	1'b0, 	18'h0, 			1'b0, 	18'h0, 1'b0, 
								neuron_clk, reset_sim, neuronIndex, neuronWriteEnable, readClock, 0, 0, Ia_w1, Ia_w2, 
								0, 0);    
    
	assign i_postsyn_I = {14'h0, I_out};
    
    // *** izh-Motoneuron :: i_postsyn_I -> (MN_spike, rawspike)
    
	wire [3:0] a, b, tau;
	wire [17:0] c, d, v1, u1, s1;
	assign a = 3 ;  // bits for shifting, a = 0.125
	assign b =  2 ;  // bits for shifting, b = 0.25
	assign c =  18'sh3_599A ; // -0.65  = dec2hex(1+bitcmp(ceil(0.65 * hex2dec('ffff')),18)) = 3599A
	assign d =  18'sh0_147A ; // 0.08 = dec2hex(floor(0.08 * hex2dec('ffff'))) = 147A
	assign tau = 4'h2;
    
	wire [1:0] state;
	assign state = neuronCounter[1:0];
    
	wire [NN:0] neuronIndex;
	assign neuronIndex = neuronCounter[NN+2:2];
	
	wire state1, state2, state3, state4;
	assign state1 = (state == 2'h0);
	assign state2 = (state == 2'h1);
	assign state3 = (state == 2'h2);
	assign state4 = (state == 2'h3);
	
	wire neuronWriteCount, readClock, neuronWriteEnable, dataValid;
	assign neuronWriteCount = state1;	//increment neuronID (ram address)
	assign readClock = state2;				//read RAM
	assign neuronWriteEnable = state4; //(state3 | state4);	//write RAM
	assign dataValid = (neuronCounter == 32'd0);  //(neuronIndex ==0) & state2; //(neuronIndex == 1);   //slight delay of positive edge to allow latch set-up times
		
    wire MN_spike;

	Iz_neuron #(.NN(NN),.DELAY(10)) neuMN(v1,s1, a,b,c,d, i_postsyn_I[17:0] * i_gain_MN[17:0], neuron_clk, reset_sim, neuronIndex, neuronWriteEnable, readClock, tau, MN_spike);
    
    reg [15:0] raw_Ia_spikes, raw_II_spikes, raw_MN_spikes;
	always @(negedge ti_clk) raw_MN_spikes <= {1'b0, neuronIndex[NN:2], MN_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
	always @(negedge ti_clk) raw_Ia_spikes <= {1'b0, neuronIndex[NN:2], 1'b0, Ia_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
    always @(negedge ti_clk) raw_II_spikes <= {1'b0, neuronIndex[NN:2], 1'b0, 1'b0, II_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};

//
//    assign raw_MN_spikes = {1'b0, neuronIndex[NN:2], MN_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
//	assign raw_Ia_spikes = {1'b0, neuronIndex[NN:2], 1'b0, Ia_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
//	assign raw_II_spikes = {1'b0, neuronIndex[NN:2], 1'b0, 1'b0, II_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
    
    // *** Count the spikes: rawspikes -> spike -> spike_count_out
	wire    [31:0] i_MN_spk_cnt;
    wire    clear_out;
//    spikecnt count_rawspikes
//	 (		.spike(MN_spike), 
//			.slow_clk(sim_clk), 
//			.fast_clk(neuron_clk),
//            .int_cnt_out(i_MN_spk_cnt),
//			.reset(reset_sim),
//            .clear_out(clear_out) );   

    spike_counter count_rawspikes
    (   .spike(MN_spike), 
        .slow_clk(sim_clk), 
        .reset(reset_sim),
        .int_cnt_out(i_MN_spk_cnt),
        .clear_out(clear_out) );
            
    // *** Shadmehr muscle: spike_count_out => f_active_state => f_total_force
    wire    [31:0]  f_total_force, f_active_state, f_MN_spk_cnt;
    shadmehr_muscle muscle_for_test
    (   .spike_cnt(i_MN_spk_cnt*gain),
        .pos(f_muscle_len),  // muscle length
        //.vel(current_vel),
        .vel(32'd0),
        .clk(sim_clk),
        .reset(reset_sim),
        .total_force_out(f_total_force),
        .current_A(f_active_state),
        .current_fp_spikes(f_MN_spk_cnt)
    );       

    // *** EMG
    wire [17:0] si_emg;
    emg #(.NN(NN)) muscle_emg
    (   .emg_out(si_emg), 
        .i_spk_cnt(i_MN_spk_cnt[NN:0]), 
        .clk(sim_clk), 
        .reset(reset_sim) );
    */


    
 // ** LEDs
    assign led[0] = ~reset_global;
    assign led[1] = ~reset_sim;
    assign led[2] = ~clk1;
    assign led[3] = ~rdy;
    assign led[4] = 1'b1;
    assign spike  = 1'b1;
    assign led[5] = ~sim_clk; //fast clock
    assign led[6] = ~spindle_clk; // slow clock
    //assign led[5] = ~spike;
    //assign led[5] = ~button1_response;
    //assign led[6] = ~button2_response;
    //assign led[6] = ~reset_sim;
    assign led[7] = 1'b1;
    //assign led[6] = ~execute; // When execute==1, led lits      
    // *** Buttons, physical on XEM3010, software on XEM3050 & XEM6010
    assign reset_global = ep00wire[0];
    assign reset_sim = ep00wire[1];
    
    // *** Endpoint connections:
    assign pin0 = clk1;   
    assign pin1 = sim_clk;
    assign pin2 = spindle_clk;
    


  // Instantiate the okHost and connect endpoints.
    // Host interface
    // *** Endpoint connections:
    assign ep20wire = master_out[15:0];
    assign ep21wire = master_out[31:16];
    assign ep22wire = f_rawfr_Ia[15:0]; 
    assign ep23wire = f_rawfr_Ia[31:16];
    assign ep24wire = f_muscle_len[15:0];
    assign ep25wire = f_muscle_len[31:16];
    assign ep26wire = clkdiv[15:0];
    assign ep27wire = clkdiv[31:16];
    //assign ep28wire = gain[15:0];
    //assign ep29wire = gain[31:16];;    
    okHost okHI(
        .hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .hi_aa(hi_aa), .ti_clk(ti_clk),
        .ok1(ok1), .ok2(ok2));

    wire [17*11-1:0]  ok2x;
    okWireOR # (.N(11)) wireOR (ok2, ok2x);
    okWireIn     wi00 (.ok1(ok1),                           .ep_addr(8'h00), .ep_dataout(ep00wire));
    okWireIn     wi01 (.ok1(ok1),                           .ep_addr(8'h01), .ep_dataout(ep01wire));
    okWireIn     wi02 (.ok1(ok1),                           .ep_addr(8'h02), .ep_dataout(ep02wire));
    //okWireIn     wi03 (.ok1(ok1),                           .ep_addr(8'h03), .ep_dataout(ep001wire));

    okWireOut    wo20 (.ok1(ok1), .ok2(ok2x[ 0*17 +: 17 ]), .ep_addr(8'h20), .ep_datain(ep20wire));
    okWireOut    wo21 (.ok1(ok1), .ok2(ok2x[ 1*17 +: 17 ]), .ep_addr(8'h21), .ep_datain(ep21wire));
    okWireOut    wo22 (.ok1(ok1), .ok2(ok2x[ 2*17 +: 17 ]), .ep_addr(8'h22), .ep_datain(ep22wire));
    okWireOut    wo23 (.ok1(ok1), .ok2(ok2x[ 3*17 +: 17 ]), .ep_addr(8'h23), .ep_datain(ep23wire));
    okWireOut    wo24 (.ok1(ok1), .ok2(ok2x[ 4*17 +: 17 ]), .ep_addr(8'h24), .ep_datain(ep24wire));
    okWireOut    wo25 (.ok1(ok1), .ok2(ok2x[ 5*17 +: 17 ]), .ep_addr(8'h25), .ep_datain(ep25wire));
    okWireOut    wo26 (.ok1(ok1), .ok2(ok2x[ 6*17 +: 17 ]), .ep_addr(8'h26), .ep_datain(ep26wire));
    okWireOut    wo27 (.ok1(ok1), .ok2(ok2x[ 7*17 +: 17 ]), .ep_addr(8'h27), .ep_datain(ep27wire));
    okWireOut    wo28 (.ok1(ok1), .ok2(ok2x[ 8*17 +: 17 ]), .ep_addr(8'h28), .ep_datain(ep28wire));
    okWireOut    wo29 (.ok1(ok1), .ok2(ok2x[ 9*17 +: 17 ]), .ep_addr(8'h29), .ep_datain(ep29wire));
     //ep_ready = 1 (always ready to receive)
    okBTPipeIn   ep80 (.ok1(ok1), .ok2(ok2x[ 10*17 +: 17 ]), .ep_addr(8'h80), .ep_write(is_pipe_being_written), .ep_blockstrobe(), .ep_dataout(hex_from_py), .ep_ready(1'b1));
    okBTPipeOut  epA0 (.ok1(ok1), .ok2(ok2x[ 11*17 +: 17 ]), .ep_addr(8'ha1), .ep_read(pipe_out_read),  .ep_blockstrobe(), .ep_datain(rawspikes), .ep_ready(1'b1));
    //okBTPipeOut  epA0 (.ok1(ok1), .ok2(ok2x[ 5*17 +: 17 ]), .ep_addr(8'ha0), .ep_read(pipe_out_read),  .ep_blockstrobe(), .ep_datain(response_nerf), .ep_ready(pipe_out_valid));

    okTriggerIn ep50 (.ok1(ok1),  .ep_addr(8'h50), .ep_clk(clk1), .ep_trigger(ep50trig));
endmodule



