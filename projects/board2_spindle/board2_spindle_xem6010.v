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
module board2_spindle_xem6010(
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
//    wire [15:0]  ep00wire, ep01wire, ep02wire, ep20wire, ep21wire, ep22wire, ep23wire;
//    wire [15:0]  ep24wire, ep25wire, ep26wire, ep27wire, ep28wire, ep29wire, ep30wire, ep31wire;
    wire reset_global, reset_sim;
    wire        is_pipe_being_written, is_lce_valid;

    wire [15:0] hex_from_py;
 
    // *** Target interface bus:
    assign i2c_sda = 1'bz;
    assign i2c_scl = 1'bz;
    assign hi_muxsel = 1'b0;

    // *** Triggered input from Python
   
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
    
    reg [31:0] delay_cnt_max;
    always @(posedge ep50trig[7] or posedge reset_global)
    begin
        if (reset_global)
            delay_cnt_max <= delay_cnt_max;
        else
            delay_cnt_max <= {ep02wire, ep01wire};  //firing rate
    end        
    
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

//    reg [2:0] SSELr;
//    always @ (negedge clk1)
//		begin
//			//keep track of SPI signals
//			SSELr <= {SSELr[1:0], XLXN_6};   //XLXN_6 is SSEL
//		end
//    
//    wire SSEL_startmessage;
//	assign SSEL_startmessage = (SSELr[2:0] == 3'b100);

//    gen_SPI_slave_clk #(.NN(NN)) useful_clocks
//    (   .rawclk(clk1), 
//        .half_cnt(delay_cnt_max), 
//        .SSEL_startmessage(SSEL_startmessage),
//        .clk_out1(neuron_clk), 
//        //.clk_out2(sim_clk_old), 
//        .clk_out3(spindle_clk),
//        .int_neuron_cnt_out(neuronCounter) );



//                
//    
    // *** Generating waveform to stimulate the spindle
    // THIS MODULE SHOULD PROBABLY BE TRIMMED
    wire [31:0] f_muscle_len_pipe;
	waveform_from_pipe gen(	
        .ti_clk(ti_clk),
        .reset(reset_global),
        .repop(reset_sim),
        .feed_data_valid(is_pipe_being_written),
        .feed_data(hex_from_py),
        .current_element(f_muscle_len_pipe),
        .test_clk(sim_clk),
        .done_feeding(is_lce_valid)
    );        


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
    wire MISO_s;  //mosi
    wire SSEL_s;   //ssel
    wire SCK_s;  //sck
    wire DATA_s; //miso
    
    //slave receiving in
    wire MOSI_r;  //mosi
    wire SSEL_r;   //ssel
    wire SCK_r;  //sck
    wire DATA_r; //miso
   
    //more wires for slave to master
    wire XLXN_9;  //mosi
    wire XLXN_10;   //ssel
    wire XLXN_11;  //sck
    wire XLXN_12; //miso
    
    //wire XLXN_13;  //mosi
    //wire XLXN_14;   //ssel
    //wire XLXN_15;  //sck
    //wire XLXN_16; //miso
    

    
     wire MISO_data, endmsg;
         // *** Spindle: f_muscle_len => f_rawfr_Ia
    wire [31:0] f_rawfr_Ia, x_0, x_1, f_rawfr_II;

    
    //slave module
    wire [31:0] f_data_from_spi;
    spi_slave  board2_receiver (.clk(clk1), 
                     .en(1'b1), 
                     .reset(reset_global), 
                     .SCK(SCK_r), 
                     .SSEL(SSEL_r), 
                     .DATA_IN(DATA_r), 
                     .rdy(rdy), 
                     //.data32(f_rawfr_Ia),   //input 
                     .rx_out(f_data_from_spi));
                     
    reg [31:0] f_muscle_len, f_safe_data_spi;
    always @(negedge spindle_clk or posedge reset_global) begin
        if (reset_global) begin
            f_safe_data_spi <= 32'd0;
        end
        else begin
            f_safe_data_spi <= f_data_from_spi;
        end
    end
    always @(posedge sim_clk or posedge reset_global) begin
        if (reset_global) begin
            f_muscle_len <= 32'd0;
        end
        else begin
            f_muscle_len <= f_safe_data_spi;
        end
    end

//
//    //board2 sender 
    spi_master  board2_sender (.clk(clk1), 
                      .clkdiv(clkdiv[23:0]),  
                      .data32(f_rawfr_Ia),  
                      .en(1'b1), 
                      .reset(reset_global), 
                      .SIMCK(sim_clk), 
                      .DATA_OUT(DATA_s), 
                      .rx_data(master_out[31:0]), 
                      .SCK(SCK_s), 
                      .SSEL(SSEL_s));


    //input SPI pins (1)
    assign SCK_r = pin_jp1_41;  //SCK
    assign DATA_r = pin_jp1_42;   //MOSI
    assign SSEL_r = pin_jp1_43;   //SSEL
    
   
//    //input SPI pins (2)
//    assign XLXN_11 = pin_jp2_51;  //SCK
//    assign XLXN_9 = pin_jp2_52;   //MOSI
//    assign pin_jp2_60 = XLXN_12;    //MISO
//    assign XLXN_10 = pin_jp2_59;   //SSEL


    //output SPI pins  (1)
    assign pin_jp1_44 = SCK_s;  //SCK
    assign pin_jp1_45 = DATA_s;     //MISO
    assign pin_jp1_46 = SSEL_s;   //SSEL  


//    //output SPI pins (2)
//    assign pin_jp1_51 = XLXN_15;  //SCK
//    assign pin_jp1_52 = XLXN_13;   //MOSI
//    assign XLXN_16 = pin_jp1_60;    //MISO
//    assign pin_jp1_59 = XLXN_14;   //SSEL
//    
    //sim_clk 
    //assign sim_clk = pin_jp2_sim_clk; 
    //assign pin_jp1_sim_clk = sim_clk;
    



//**  end of spi communication
    // GET f_muscle_len FROM BOARD1!!!

    spindle bag1_bag2_chain
    (	.gamma_dyn(f_gamma_dyn), // 32'h42A0_0000
        .gamma_sta(f_gamma_sta),
        .lce((gain==32'd0) ? f_muscle_len : f_muscle_len_pipe),
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

//    reg [31:0] f_i_length;
//    wire [31:0] f_i_length_F0;
//	integrator lce_integrator (	.x(f_muscle_len), .int_x(f_i_length), .out(f_i_length_F0) );
//
//    always @(posedge sim_clk or posedge reset_sim) begin
//        if (reset_sim) begin
//            f_i_length <= 32'd0;
//        end
//        else begin
//            f_i_length <= f_i_length_F0;
//        end 
//    end


    // ** LEDs 0 = ON    
    assign led[4:2] = 3'b111;
    assign led[0] = 1'b1;
    assign led[1] = 1'b1;
    assign led[5] = 1'b1;
    assign led[6] = ~sim_clk;
    assign led[7] = ~reset_global;
    
      
    // *** Buttons, physical on XEM3010, software on XEM3050 & XEM6010
    assign reset_global = ep00wire[0];
    assign reset_sim = ep00wire[1];
    
    // *** Endpoint connections:
    assign pin0 = clk1;
    assign pin1 = sim_clk;
    assign pin2 = spindle_clk;

    // *** OpalKelly XEM interface
    okHost okHI(
        .hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .hi_aa(hi_aa), .ti_clk(ti_clk),
        .ok1(ok1), .ok2(ok2));

    wire [17*18-1:0]  ok2x;
    okWireOR # (.N(18)) wireOR (ok2, ok2x);
    wire [15:0]  ep00wire, ep01wire, ep02wire;
    okWireIn     wi00 (.ok1(ok1),                           .ep_addr(8'h00), .ep_dataout(ep00wire));
    okWireIn     wi01 (.ok1(ok1),                           .ep_addr(8'h01), .ep_dataout(ep01wire));
    okWireIn     wi02 (.ok1(ok1),                           .ep_addr(8'h02), .ep_dataout(ep02wire));
    
    okWireOut    wo20 (.ep_datain(f_muscle_len[15:0]), .ok1(ok1), .ok2(ok2x[  0*17 +: 17 ]), .ep_addr(8'h20) );
    okWireOut    wo21 (.ep_datain(f_muscle_len[31:16]), .ok1(ok1), .ok2(ok2x[  1*17 +: 17 ]), .ep_addr(8'h21) );
    okWireOut    wo22 (.ep_datain(f_rawfr_Ia[15:0]), .ok1(ok1), .ok2(ok2x[  2*17 +: 17 ]), .ep_addr(8'h22) );
    okWireOut    wo23 (.ep_datain(f_rawfr_Ia[31:16]), .ok1(ok1), .ok2(ok2x[  3*17 +: 17 ]), .ep_addr(8'h23) );
    okWireOut    wo24 (.ep_datain(f_rawfr_II[15:0]), .ok1(ok1), .ok2(ok2x[  4*17 +: 17 ]), .ep_addr(8'h24) );
    okWireOut    wo25 (.ep_datain(f_rawfr_II[31:16]), .ok1(ok1), .ok2(ok2x[  5*17 +: 17 ]), .ep_addr(8'h25) );
    okWireOut    wo26 (.ep_datain(f_muscle_len_pipe[15:0]), .ok1(ok1), .ok2(ok2x[  6*17 +: 17 ]), .ep_addr(8'h26) );
    okWireOut    wo27 (.ep_datain(f_muscle_len_pipe[31:16]), .ok1(ok1), .ok2(ok2x[  7*17 +: 17 ]), .ep_addr(8'h27) );
//    okWireOut    wo28 (.ep_datain(i_MN_spk_cnt[15:0]), .ok1(ok1), .ok2(ok2x[  8*17 +: 17 ]), .ep_addr(8'h28) );
//    okWireOut    wo29 (.ep_datain(i_MN_spk_cnt[31:16]), .ok1(ok1), .ok2(ok2x[  9*17 +: 17 ]), .ep_addr(8'h29) );
//    okWireOut    wo30 (.ep_datain(raw_MN_spikes[15:0]), .ok1(ok1), .ok2(ok2x[ 10*17 +: 17 ]), .ep_addr(8'h30) );
//    okWireOut    wo31 (.ep_datain(raw_MN_spikes[31:16]), .ok1(ok1), .ok2(ok2x[ 11*17 +: 17 ]), .ep_addr(8'h31) );
//    okWireOut    wo32 (.ep_datain(f_total_force[15:0]), .ok1(ok1), .ok2(ok2x[ 12*17 +: 17 ]), .ep_addr(8'h32) );
//    okWireOut    wo33 (.ep_datain(f_total_force[31:16]), .ok1(ok1), .ok2(ok2x[ 13*17 +: 17 ]), .ep_addr(8'h33) );

    //ep_ready = 1 (always ready to receive)
    wire pipe_out_read0, pipe_out_read1, pipe_out_read2;
    okBTPipeIn   ep80 (.ep_dataout(hex_from_py), .ok1(ok1), .ok2(ok2x[ 14*17 +: 17 ]), .ep_addr(8'h80), .ep_write(is_pipe_being_written), .ep_blockstrobe(), .ep_ready(1'b1));
    okBTPipeOut  epA0 (.ep_datain(raw_Ia_spikes), .ok1(ok1), .ok2(ok2x[ 15*17 +: 17 ]), .ep_addr(8'ha0), .ep_read(pipe_out_read0),  .ep_blockstrobe(), .ep_ready(1'b1));
    okBTPipeOut  epA1 (.ep_datain(raw_II_spikes), .ok1(ok1), .ok2(ok2x[ 16*17 +: 17 ]), .ep_addr(8'ha1), .ep_read(pipe_out_read1),  .ep_blockstrobe(), .ep_ready(1'b1));
    okBTPipeOut  epA2 (.ep_datain(raw_MN_spikes), .ok1(ok1), .ok2(ok2x[ 17*17 +: 17 ]), .ep_addr(8'ha2), .ep_read(pipe_out_read2),  .ep_blockstrobe(), .ep_ready(1'b1));

    wire [15:0] ep50trig;
    okTriggerIn ep50 (.ok1(ok1),  .ep_addr(8'h50), .ep_clk(clk1), .ep_trigger(ep50trig));
endmodule

