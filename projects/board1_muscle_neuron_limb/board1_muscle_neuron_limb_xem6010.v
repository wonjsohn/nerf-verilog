`timescale 1ns / 1ps
`default_nettype none
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
    input wire pin_jp1_41,  //
    input wire pin_jp1_42, 
    input wire pin_jp1_43,
  
    output wire pin_jp1_44,
    output wire pin_jp1_45,
    output wire pin_jp1_46
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
    wire [31:0] slave_out;
     
    //master sending out     
    wire DATA_s;  //mosi
    wire SSEL_s;   //ssel
    wire SCK_s;  //sck
    //wire XLXN_4; //miso
    
    //slave receiving in
    //wire XLXN_5;  //mosi


    
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
    
    wire rdy;
    wire SSEL_r;   //ssel
    wire SCK_r;  //sck
    wire DATA_r; //miso   
     //input SPI pins (2)
    assign SCK_r = pin_jp1_41;  //SCK
    assign DATA_r = pin_jp1_42;   //MOSI
    assign SSEL_r = pin_jp1_43;   //SSEL

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
    assign pin_jp1_44 = SCK_s;  //SCK
    assign pin_jp1_45 = DATA_s;   //MOSI
    assign pin_jp1_46 = SSEL_s;   //SSEL
        

	
    //assign XLXN_4 = pin_jp1_50;    //MISO
    //sim_clk 
    //assign sim_clk = pin_jp2_sim_clk; 
    //assign pin_jp1_sim_clk = sim_clk;
    
    
//**  end of spi communication

    //instantiate motor unit 
    
//    wire    [31:0]  f_bicep_force;
//    
//    motorunit  #(.NN(NN)) biceps(.f_muscle_length(f_muscle_len), 
//                                //.vel(),
//                                .f_rawfr_Ia(f_rawfr_Ia),
//                                .f_pps_coef_Ia(f_pps_coef_Ia),
//                                .half_cnt(delay_cnt_max), 
//                                .clk(clk1),   // raw clk
//                                //.sim_clk(sim_clk),                
//                                //.neuron_clk(neuron_clk),
//                                .ti_clk(ti_clk),
//                                .reset_sim(reset_sim),
//                                .gain(gain),
//                                .i_gain_MN(i_gain_MN),
//                                .f_total_force(f_bicep_force)   // output
//                                );
//        
    
    wire MN_spike;

    neuron_pool #(.NN(NN)) np1
    (   .f_rawfr_Ia(f_rawfr_Ia),     //
        .f_pps_coef_Ia(f_pps_coef_Ia), //
        .half_cnt(delay_cnt_max),
        .rawclk(clk1),
        .ti_clk(ti_clk),
        .reset_sim(reset_sim),
        .i_gain_MN(i_gain_MN),
        .neuronCounter(neuronCounter),
        .MN_spike(MN_spike)
    );   
     
    // *** spike counter 
    wire    [31:0] i_MN_spk_cnt;
    wire    clear_out;
    spike_counter count_rawspikes
    (   .spike(MN_spike), 
        .slow_clk(sim_clk), 
        .reset(reset_sim),
        .int_cnt_out(i_MN_spk_cnt),
        .clear_out(clear_out) );
            
    // *** Shadmehr muscle: spike_count_out => f_active_state => f_total_force
    wire    [31:0]  f_active_state, f_MN_spk_cnt; 
    wire    [31:0]  f_bicep_force, f_tricep_force;
    shadmehr_muscle biceps
    (   .spike_cnt(i_MN_spk_cnt*gain),
        .pos(f_muscle_len),  // muscle length
        //.vel(current_vel),
        .vel(32'd0),
        .clk(sim_clk),
        .reset(reset_sim),
        .total_force_out(f_bicep_force),
        .current_A(f_active_state),
        .current_fp_spikes(f_MN_spk_cnt)
    );       
    shadmehr_muscle triceps
    (   .spike_cnt(i_MN_spk_cnt*gain),
        .pos(f_muscle_len),  // muscle length
        //.vel(current_vel),
        .vel(32'd0),
        .clk(sim_clk),
        .reset(reset_sim),
        .total_force_out(f_tricep_force),
        .current_A(f_active_state),
        .current_fp_spikes(f_MN_spk_cnt)
    );       




        

    // *** EMG
//    wire [17:0] si_emg;
//    emg #(.NN(NN)) muscle_emg
//    (   .emg_out(si_emg), 
//        .i_spk_cnt(i_MN_spk_cnt[NN:0]), 
//        .clk(sim_clk), 
//        .reset(reset_sim) );
//    */


    
 // ** LEDs
    assign led[0] = ~reset_global;
    assign led[1] = ~reset_sim;
    assign led[2] = ~clk1;
    assign led[3] = ~rdy;
    assign led[4] = ~MN_spike;
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
  
    okHost okHI(
        .hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .hi_aa(hi_aa), .ti_clk(ti_clk),
        .ok1(ok1), .ok2(ok2));

    wire [17*11-1:0]  ok2x;
    okWireOR # (.N(11)) wireOR (ok2, ok2x);
    okWireIn     wi00 (.ok1(ok1),                           .ep_addr(8'h00), .ep_dataout(ep00wire));
    okWireIn     wi01 (.ok1(ok1),                           .ep_addr(8'h01), .ep_dataout(ep01wire));
    okWireIn     wi02 (.ok1(ok1),                           .ep_addr(8'h02), .ep_dataout(ep02wire));
    //okWireIn     wi03 (.ok1(ok1),                           .ep_addr(8'h03), .ep_dataout(ep001wire));


    okWireOut    wo20 (.ep_datain(f_muscle_len[15:0]), .ok1(ok1), .ok2(ok2x[  0*17 +: 17 ]), .ep_addr(8'h20) );
    okWireOut    wo21 (.ep_datain(f_muscle_len[31:16]), .ok1(ok1), .ok2(ok2x[  1*17 +: 17 ]), .ep_addr(8'h21) );
    okWireOut    wo22 (.ep_datain(f_rawfr_Ia[15:0]), .ok1(ok1), .ok2(ok2x[  2*17 +: 17 ]), .ep_addr(8'h22) );
    okWireOut    wo23 (.ep_datain(f_rawfr_Ia[31:16]), .ok1(ok1), .ok2(ok2x[  3*17 +: 17 ]), .ep_addr(8'h23) );
    okWireOut    wo24 (.ep_datain(f_bicep_force[15:0]), .ok1(ok1), .ok2(ok2x[  4*17 +: 17 ]), .ep_addr(8'h24) );
    okWireOut    wo25 (.ep_datain(f_bicep_force[31:16]), .ok1(ok1), .ok2(ok2x[  5*17 +: 17 ]), .ep_addr(8'h25) );
    okWireOut    wo26 (.ep_datain(f_tricep_force[15:0]), .ok1(ok1), .ok2(ok2x[  6*17 +: 17 ]), .ep_addr(8'h26) );
    okWireOut    wo27 (.ep_datain(f_tricep_force[31:16]), .ok1(ok1), .ok2(ok2x[  7*17 +: 17 ]), .ep_addr(8'h27) );
    okWireOut    wo28 (.ep_datain(i_MN_spk_cnt[15:0]),  .ok1(ok1), .ok2(ok2x[ 8*17 +: 17 ]), .ep_addr(8'h28) );
    okWireOut    wo29 (.ep_datain(i_MN_spk_cnt[31:16]), .ok1(ok1), .ok2(ok2x[ 9*17 +: 17 ]), .ep_addr(8'h29) );
     //ep_ready = 1 (always ready to receive)
    okBTPipeIn   ep80 (.ok1(ok1), .ok2(ok2x[ 10*17 +: 17 ]), .ep_addr(8'h80), .ep_write(is_pipe_being_written), .ep_blockstrobe(), .ep_dataout(hex_from_py), .ep_ready(1'b1));
    okBTPipeOut  epA0 (.ok1(ok1), .ok2(ok2x[ 11*17 +: 17 ]), .ep_addr(8'ha1), .ep_read(pipe_out_read),  .ep_blockstrobe(), .ep_datain(rawspikes), .ep_ready(1'b1));
    //okBTPipeOut  epA0 (.ok1(ok1), .ok2(ok2x[ 5*17 +: 17 ]), .ep_addr(8'ha0), .ep_read(pipe_out_read),  .ep_blockstrobe(), .ep_datain(response_nerf), .ep_ready(pipe_out_valid));

    okTriggerIn ep50 (.ok1(ok1),  .ep_addr(8'h50), .ep_clk(clk1), .ep_trigger(ep50trig));
endmodule



