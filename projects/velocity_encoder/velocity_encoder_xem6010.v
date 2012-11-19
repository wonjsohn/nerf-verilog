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
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module velocity_encoder_xem6010(
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
    output wire spike_out1,  // corss-board spike output
    input wire  spike_in1  // cross-board spike input
	 );
//	input wire SCK_r,	    //pin_jp1_41    SCK_r
//   input wire SSEL_r,	    //pin_jp1_42    SSEL_r
//   input wire DATA_0_r,  //pin_jp1_43    Data_bic_r
//	//input wire DATA_1_r,  //pin_jp1_44    Data_tri_r
//   output wire  SCK_s,	    //pin_jp2_41    SCK_s
//   output wire  SSEL_s, 	     //pin_jp2_42	  SSEL_s
//   output wire  DATA_0_s 	//pin_jp2_43   DATA_bic_s
//   //output wire  DATA_1_s	   //pin_jp2_43 DATA_tri_s
//   );
//   
//    
//	 // Mapping to UCF files
//	 wire DATA_tricepsfr_Ia_r,DATA_triforce_r, DATA_trilen_s, DATA_biclen_s;
//	 assign DATA_tricepsfr_Ia_r = DATA_0_r;
//	 //assign DATA_triforce_r = DATA_1_r;
//	 assign DATA_0_s = DATA_trilen_s;
//	 //assign DATA_1_s = DATA_biclen_s;
//		
    parameter NN = 6;
    // *** Dump all the declarations here:
    wire         ti_clk;
    wire [30:0]  ok1;
    wire [16:0]  ok2;   
    wire [15:0]  ep00wire, ep01wire, ep02wire, ep03wire, ep04wire, ep05wire, ep06wire, ep07wire, ep08wire, ep50trig, ep20wire, ep21wire, ep22wire, ep23wire;
    wire [15:0]  ep24wire, ep25wire, ep26wire, ep27wire, ep28wire, ep29wire, ep30wire, ep31wire;
    wire reset_global, reset_sim;
    wire        is_pipe_being_written, is_lce_valid;
    
    wire [15:0] hex_from_py;
    
    reg [31:0] delay_cnt_max;
    
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
    always @(posedge ep50trig[0] or posedge reset_global)
    begin
        if (reset_global)
            delay_cnt_max <= 18'd9;
        else
            delay_cnt_max <= {ep02wire, ep01wire};  //firing rate
    end
    
    
    reg [31:0] f_pps_coef_Ia;
    always @(posedge ep50trig[1] or posedge reset_global)
    begin
        if (reset_global)
            f_pps_coef_Ia <= 32'h3F66_6666;
        else
            f_pps_coef_Ia <= {ep02wire, ep01wire};  //firing rate
    end       
//    
//    reg [31:0] f_pps_coef_II;
//    always @(posedge ep50trig[2] or posedge reset_global)
//    begin
//        if (reset_global)
//            f_pps_coef_II <= 32'h3F66_6666;
//        else
//            f_pps_coef_II <= {ep02wire, ep01wire};  //firing rate
//    end           
//    



    reg [31:0] tau;
    always @(posedge ep50trig[2] or posedge reset_global)
    begin
        if (reset_global)
            tau <= 32'h3CF5_C28F; // 0.03 second
        else
            tau <= {ep02wire, ep01wire};  
    end      
    
//
//    reg [31:0] gain;
//    always @(posedge ep50trig[3] or posedge reset_global)
//    begin
//        if (reset_global)
//            gain <= 32'd0;
//        else
//            gain <= {ep02wire, ep01wire};  //firing rate
//    end        
    
             
    /***  Cortical synapse gain  ***/
    reg signed [31:0] i_gain_syn_CN_to_MN; 
    always @(posedge ep50trig[3] or posedge reset_global)
    begin
        if (reset_global)
            i_gain_syn_CN_to_MN <= 32'd1; // gamma_sta reset to 80
        else
            i_gain_syn_CN_to_MN <= {ep02wire, ep01wire};  
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
    
    reg [31:0] i_gain_syn_SN_to_MN;
    always @(posedge ep50trig[6] or posedge reset_global)
    begin
        if (reset_global)
            i_gain_syn_SN_to_MN <= 32'd1; // gamma_sta reset to 80
        else
            i_gain_syn_SN_to_MN <= {ep02wire, ep01wire};  
    end
	 
//    reg signed [31:0] i_gain_mu2_MN;
//    always @(posedge ep50trig[7] or posedge reset_global)
//    begin
//        if (reset_global)
//            i_gain_mu2_MN <= 32'd1; // gamma_sta reset to 80
//        else
//            i_gain_mu2_MN <= {ep02wire, ep01wire};  
//    end  
//	 
	 reg signed [31:0] trigger_input;
    always @(posedge ep50trig[7] or posedge reset_global)
    begin
        if (reset_global)
            trigger_input <= 32'd1; // gamma_sta reset to 80
        else
            trigger_input <= {ep02wire, ep01wire};  
    end  
    
//    /***  MotorCortex direct drive ***/
//    reg [31:0] i_M1_CN2_drive; 
//    always @(posedge ep50trig[8] or posedge reset_global)
//    begin
//        if (reset_global)
//            i_M1_CN2_drive <= 32'h0000_0000; //0.0
//        else
//            i_M1_CN2_drive <= {ep02wire, ep01wire}; 
//    end   
    
    reg [31:0] i_gain_syn_CN2_to_MN;
    always @(posedge ep50trig[9] or posedge reset_global)
    begin
        if (reset_global)
            i_gain_syn_CN2_to_MN <= 32'd1; 
        else
            i_gain_syn_CN2_to_MN <= {ep02wire, ep01wire};  
    end
    
//    reg signed [31:0] i_gain_mu3_MN;
//    always @(posedge ep50trig[8] or posedge reset_global)
//    begin
//        if (reset_global)
//            i_gain_mu3_MN <= 32'd1; // gamma_sta reset to 80
//        else
//            i_gain_mu3_MN <= {ep02wire, ep01wire};  
//    end  
//
//    reg [31:0] f_len_bic_pxi_F0; // _pxi = from PXI system in BBDL
//    always @(posedge ep50trig[8] or posedge reset_global)
//    begin
//        if (reset_global)
//            f_len_bic_pxi_F0 <= 32'h3F66_6666; //0.9
//        else
//            f_len_bic_pxi_F0 <= {ep02wire, ep01wire}; 
//    end   
//
//    reg [31:0] f_velocity; // _pxi = from PXI system in BBDL
//    always @(posedge ep50trig[9] or posedge reset_global)
//    begin
//        if (reset_global)
//            f_velocity <= 32'h0000_0000; //0.0
//        else
//            f_velocity <= {ep02wire, ep01wire}; 
//    end   



//    /***  MotorCortex direct drive ***/
//    reg [31:0] i_M1_CN_drive; 
//    always @(posedge ep50trig[11] or posedge reset_global)
//    begin
//        if (reset_global)
//            i_M1_CN_drive <= 32'h0000_0000; //0.0
//        else
//            i_M1_CN_drive <= {ep02wire, ep01wire}; 
//    end   
     
    /***  MotorCortex synapse gain  ***/
    reg signed [31:0] i_gain_syn_SN_to_CN; 
    always @(posedge ep50trig[12] or posedge reset_global)
    begin
        if (reset_global)
            i_gain_syn_SN_to_CN <= 32'd1; // gamma_sta reset to 80
        else
            i_gain_syn_SN_to_CN <= {ep02wire, ep01wire};  
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
//    wire [NN+2:0] neuronCounter;
    wire [31:0] i_neuronCounter; 

    gen_clk #(.NN(NN)) useful_clocks
    (   .rawclk(clk1), 
        .half_cnt(delay_cnt_max), 
        .clk_out1(neuron_clk), 
        .clk_out2(sim_clk), 
        .clk_out3(spindle_clk),
        .int_neuron_cnt_out(i_neuronCounter) );
                
    
    // *** Generating waveform to stimulate the spindle
    wire    [31:0] f_pos_elbow, f_rawfr_Ia;
    wire    [31:0] f_len_bic, f_len_tri;
    waveform_from_pipe_bram_2s    generator(
                                .reset(reset_sim),
                                .pipe_clk(ti_clk),
                                .pipe_in_write(is_pipe_being_written),
                                .pipe_in_data(hex_from_py),
                                .pop_clk(sim_clk),
                                .wave(f_len_bic)
    );  
    


	wire    [31:0] i_vel_spkcnt;
	wire    dummy_slow;  
	spikecnt	spike_cnt_SN 
	(		.spike(spike_in1),
			.int_cnt_out(i_vel_spkcnt),
			.slow_clk(sim_clk),
			.fast_clk(clk1),
			.reset(reset_sim),
			.clear_out(dummy_slow));
			
	 
 // ** LEDs
    assign led[0] = ~reset_global;
    assign led[1] = ~reset_sim;
    assign led[2] = ~spike_in1;
    assign led[3] = ~0;
    assign led[4] = ~0;
	assign led[5] = ~0;  // SN_bic_spk + spike_in1
//    assign led[5] = ~MN_tri_spike;
    assign led[6] = ~0; // slow clock
    //assign led[5] = ~spike;
    //assign led[5] = ~button1_response;
    //assign led[6] = ~button2_response;
    //assign led[6] = ~reset_sim;
    assign led[7] = ~sim_clk; //fast clock
    //assign led[6] = ~execute; // When execute==1, led lits      
    // *** Buttons, physical on XEM3010, software on XEM3050 & XEM6010
    assign reset_global = ep00wire[0];
    assign reset_sim = ep00wire[1];
    
    // *** Endpoint connections:
    assign pin0 = clk1;   
    assign pin1 = sim_clk;
    assign pin2 = neuron_clk;
	 
    assign spike_out1 = spike_in1;
    //assign spike_longlatency = spike_in1;

  // Instantiate the okHost and connect endpoints.
    // Host interface
    // *** Endpoint connections:
  
    okHost okHI(
        .hi_in(hi_in), .hi_out(hi_out), .hi_inout   (hi_inout), .hi_aa(hi_aa), .ti_clk(ti_clk),
        .ok1(ok1), .ok2(ok2));
        
    parameter NUM_OK_IO = 20;

    wire [NUM_OK_IO*17 - 1: 0]  ok2x;
    okWireOR # (.N(NUM_OK_IO)) wireOR (ok2, ok2x);
    okWireIn     wi00 (.ok1(ok1),                           .ep_addr(8'h00), .ep_dataout(ep00wire));
    okWireIn     wi01 (.ok1(ok1),                           .ep_addr(8'h01), .ep_dataout(ep01wire));
    okWireIn     wi02 (.ok1(ok1),                           .ep_addr(8'h02), .ep_dataout(ep02wire));
    okWireIn     wi03 (.ok1(ok1),                           .ep_addr(8'h03), .ep_dataout(ep03wire));
    okWireIn     wi04 (.ok1(ok1),                           .ep_addr(8'h04), .ep_dataout(ep04wire));
    okWireIn     wi05 (.ok1(ok1),                           .ep_addr(8'h05), .ep_dataout(ep05wire));
    okWireIn     wi06 (.ok1(ok1),                           .ep_addr(8'h06), .ep_dataout(ep06wire));
    okWireIn     wi07 (.ok1(ok1),                           .ep_addr(8'h07), .ep_dataout(ep07wire));
    okWireIn     wi08 (.ok1(ok1),                           .ep_addr(8'h08), .ep_dataout(ep08wire));


    okWireOut    wo20 (.ep_datain(i_vel_spkcnt[15:0]), .ok1(ok1), .ok2(ok2x[  0*17 +: 17 ]), .ep_addr(8'h20) );
    okWireOut    wo21 (.ep_datain(i_vel_spkcnt[31:16]), .ok1(ok1), .ok2(ok2x[  1*17 +: 17 ]), .ep_addr(8'h21) );
//    okWireOut    wo22 (.ep_datain(f_fr_Ia[15:0]), .ok1(ok1), .ok2(ok2x[  2*17 +: 17 ]), .ep_addr(8'h22) );
//    okWireOut    wo23 (.ep_datain(f_fr_Ia[31:16]), .ok1(ok1), .ok2(ok2x[  3*17 +: 17 ]), .ep_addr(8'h23) );
//    okWireOut    wo24 (.ep_datain(i_SN_spkcnt[15:0]), .ok1(ok1), .ok2(ok2x[  4*17 +: 17 ]), .ep_addr(8'h24) );
//    okWireOut    wo25 (.ep_datain(i_SN_spkcnt[31:16]), .ok1(ok1), .ok2(ok2x[  5*17 +: 17 ]), .ep_addr(8'h25) );
//    okWireOut    wo26 (.ep_datain(i_MN_spkcnt[15:0]), .ok1(ok1), .ok2(ok2x[  6*17 +: 17 ]), .ep_addr(8'h26) );
//    okWireOut    wo26 (.ep_datain(i_MN_spkcnt[15:0]), .ok1(ok1), .ok2(ok2x[  6*17 +: 17 ]), .ep_addr(8'h26) );
//    okWireOut    wo27 (.ep_datain(i_MN_spkcnt[31:16]), .ok1(ok1), .ok2(ok2x[  7*17 +: 17 ]), .ep_addr(8'h27) );
//    okWireOut    wo28 (.ep_datain(i_EPSC_CN_to_MN[15:0]),  .ok1(ok1), .ok2(ok2x[ 8*17 +: 17 ]), .ep_addr(8'h28) );
//    okWireOut    wo29 (.ep_datain(i_EPSC_CN_to_MN[31:16]), .ok1(ok1), .ok2(ok2x[ 9*17 +: 17 ]), .ep_addr(8'h29) );
//    okWireOut    wo30 (.ep_datain(f_force[15:0]),  .ok1(ok1), .ok2(ok2x[ 10*17 +: 17 ]), .ep_addr(8'h30) );
//    okWireOut    wo31 (.ep_datain(f_force[31:16]), .ok1(ok1), .ok2(ok2x[ 11*17 +: 17 ]), .ep_addr(8'h31) );
//    okWireOut    wo32 (.ep_datain(i_emg[15:0]),  .ok1(ok1), .ok2(ok2x[ 12*17 +: 17 ]), .ep_addr(8'h32) );
//    okWireOut    wo33 (.ep_datain(i_emg[31:16]), .ok1(ok1), .ok2(ok2x[ 13*17 +: 17 ]), .ep_addr(8'h33) );   
    //ep_ready = 1 (always ready to receive)
    okBTPipeIn   ep80 (.ok1(ok1), .ok2(ok2x[ 14*17 +: 17 ]), .ep_addr(8'h80), .ep_write(is_pipe_being_written), .ep_blockstrobe(), .ep_dataout(hex_from_py), .ep_ready(1'b1));
    //okBTPipeOut  epA0 (.ok1(ok1), .ok2(ok2x[ 5*17 +: 17 ]), .ep_addr(8'ha0), .ep_read(pipe_out_read),  .ep_blockstrobe(), .ep_datain(response_nerf), .ep_ready(pipe_out_valid));
    //okBTPipeOut  epA0 (.ok1(ok1), .ok2(ok2x[ 11*17 +: 17 ]), .ep_addr(8'ha1), .ep_read(pipe_out_read),  .ep_blockstrobe(), .ep_datain(rawspikes), .ep_ready(1'b1));

    okTriggerIn ep50 (.ok1(ok1),  .ep_addr(8'h50), .ep_clk(clk1), .ep_trigger(ep50trig));
endmodule




module unsigned_mult32 (out, a, b);
	output 	[31:0]	out;
	input 	[31:0] 	a;
	input 	[31:0] 	b;
    wire    [63:0]   temp_out; 

	assign temp_out = a * b;
	assign out = temp_out[31:0];
endmodule

