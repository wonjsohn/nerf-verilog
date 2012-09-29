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
module one_joint_robot2_xem6010(
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
    output wire spike_out1,   // cross-board spike
    input wire spike_in1    // cross-board spike
	 );
//	 output wire SCK_s,	    //JP1 pin 38 GCLK pin
//    output wire SSEL_s,	    //pin_jp1_42    SSEL_s
//    output wire DATA_0_s, //pin_jp1_43    Data_bic_s
//	// output wire DATA_1_s, //pin_jp1_44    Data_tri_s
//    input wire  SCK_r,	   	//pin_jp2_41   SCK_r
//    input wire  SSEL_r, 	  //pin_jp2_42	   SSEL_r
//    input wire  DATA_0_r 	//pin_jp2_43   DATA_bic_r
//   // input wire  DATA_1_r 	//pin_jp2_44   DATA_tri_r
//   );
//   
//    
//	 // Mapping to UCF files
//	 wire DATA_trilen_r, DATA_biclen_r, DATA_tricepsfr_Ia_s, DATA_triforce_s;
//	 assign DATA_trilen_r = DATA_0_r;
//	// assign DATA_biclen_r = DATA_1_r;
//	 assign DATA_0_s = DATA_tricepsfr_Ia_s;
//	// assign DATA_1_s = DATA_triforce_s;

	parameter NN = 6;
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
    always @(posedge ep50trig[0] or posedge reset_global)
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



//    reg [31:0] tau;
//    always @(posedge ep50trig[2] or posedge reset_global)
//    begin
//        if (reset_global)
//            tau <= 32'd1; // gamma_sta reset to 80
//        else
//            tau <= {ep02wire, ep01wire};  
//    end      
////    
//
    reg [31:0] blk_size;
    always @(posedge ep50trig[2] or posedge reset_global)
    begin
        if (reset_global)
            blk_size <= 32'd800000; // default memory allocation.
        else
            blk_size <= {ep02wire, ep01wire};  
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
    
    reg signed [31:0] i_gain_syn;
    always @(posedge ep50trig[6] or posedge reset_global)
    begin
        if (reset_global)
            i_gain_syn <= 32'd1; // gamma_sta reset to 80
        else
            i_gain_syn <= {ep02wire, ep01wire};  
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
//    reg signed [31:0] i_gain_mu3_MN;
//    always @(posedge ep50trig[8] or posedge reset_global)
//    begin
//        if (reset_global)
//            i_gain_mu3_MN <= 32'd1; // gamma_sta reset to 80
//        else
//            i_gain_mu3_MN <= {ep02wire, ep01wire};  
//    end  
	 
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

    gen_clk #(.NN(NN)) useful_clocks_2
    (   .rawclk(clk1), 
        .half_cnt(delay_cnt_max), 
        .clk_out1(neuron_clk), 
        .clk_out2(sim_clk), 
        .clk_out3(spindle_clk),
        .int_neuron_cnt_out(neuronCounter) );
                
    
//    // *** Generating waveform to stimulate the spindle
//     wire    [31:0] f_elbow_pos;
//	waveform_from_pipe gen(	
//        .ti_clk(ti_clk),
//        .reset(reset_global),
//        .repop(reset_sim),
//        .feed_data_valid(is_pipe_being_written),
//        .feed_data(hex_from_py),
//        .current_element(f_elbow_pos),
//        .test_clk(sim_clk),
//        .done_feeding(is_lce_valid)
//    );    
    // *** Generating waveform to stimulate the spindle
    wire    [31:0] f_pos_elbow;
    wire    [31:0] f_rawfr_Ia;
    waveform_from_pipe_bram_2s    generator_2(
                                .reset(reset_sim),
                                .pipe_clk(ti_clk),
                                .pipe_in_write(is_pipe_being_written),
                                .pipe_in_data(hex_from_py),
                                .pop_clk(sim_clk),
                                .wave(f_rawfr_Ia)
    );  
    


//	wire    [31:0] i_SN_bic_spkcnt;
//	wire    dummy_slow;  
//	spikecnt	spike_cnt_SN_bic 
//	(		.spike(spike_in1),
//			.int_cnt_out(i_SN_bic_spkcnt),
//			.slow_clk(sim_clk),
//			.fast_clk(clk1),
//			.reset(reset_sim),
//			.clear_out(dummy_slow));
//		


	//******** CN1 Synapse **********/
	//** input: spikes
    //** output: current (each_I_synapse: updates at neuron_clk)
    
    wire [31:0] I_synapse_CN1;
    wire [31:0] each_I_synapse_CN1;
    wire each_spike;
    
    synapse synapse_CORTICAL1(
                .clk(neuron_clk),
                .reset(reset_sim),
                .spike_in(spike_in1),
                .postsynaptic_spike_in(each_spike),
                .I_out(I_synapse_CN1),  // updates once per population (scaling factor 1024) 
                .each_I(each_I_synapse_CN1) // updates on each synapse
    );
	//wire [31:0] thirty5k, f_scaled_len;
	//assign thirty5k = 32'h455AC000;
	//div div1(.x(f_rawfr_Ia), .y(thirty5k), .out(f_scaled_len));
	

    //****** CN1 Synapse gain ********//
    wire signed [63:0] I_synapse_CN1_gainAdjusted64;
    wire signed [31:0] I_synapse_CN1_gainAdjusted32;
    assign I_synapse_CN1_gainAdjusted64 = each_I_synapse_CN1 * i_gain_syn;
    assign I_synapse_CN1_gainAdjusted32 = I_synapse_CN1_gainAdjusted64[31:0];
	
   //********* CN1 izneuron *************//
	wire CN1_bic_spk;
	
    izneuron neuron_pool_CN1_bic(
                .clk(neuron_clk),
                .reset(reset_sim),
                .I_in(I_synapse_CN1_gainAdjusted32),
                .spike(),
                .each_spike(CN1_bic_spk)
    );
	
//	wire    [31:0] i_CN1_bic_spkcnt;
//	wire    dummy_slow_CN1;  
//	spikecnt	spike_cnt_MN_bic 
//	(		.spike(CN1_bic_spk),
//			.int_cnt_out(i_CN1_bic_spkcnt),
//			.slow_clk(sim_clk),
//			.fast_clk(clk1),
//			.reset(reset_sim),
//			.clear_out(dummy_slow_CN1));
//			

	

	//******** CN2 Synapse **********/
	//** input: spikes
    //** output: current (each_I_synapse: updates at neuron_clk)
    
    wire [31:0] I_synapse_CN2;
    wire [31:0] each_I_synapse_CN2;
    wire each_spike2;
    
    synapse synapse_CORTICAL2(
                .clk(neuron_clk),
                .reset(reset_sim),
                .spike_in(CN1_bic_spk),
                .postsynaptic_spike_in(each_spike2),
                .I_out(I_synapse_CN2),  // updates once per population (scaling factor 1024) 
                .each_I(each_I_synapse_CN2) // updates on each synapse
    );



    //****** CN2 Synapse gain ********//
    wire signed [63:0] I_synapse_CN2_gainAdjusted64;
    wire signed [31:0] I_synapse_CN2_gainAdjusted32;
    assign I_synapse_CN2_gainAdjusted64 = each_I_synapse_CN2 * i_gain_syn;
    assign I_synapse_CN2_gainAdjusted32 = I_synapse_CN2_gainAdjusted64[31:0];

     //********* CN1 izneuron *************//
	wire CN2_bic_spk;
	
    izneuron neuron_pool_CN2_bic(
                .clk(neuron_clk),
                .reset(reset_sim),
                .I_in(I_synapse_CN2_gainAdjusted32),
                .spike(),
                .each_spike(CN2_bic_spk)
    );
	
    

    
    
 // ** LEDs
    assign led[0] = ~reset_global;
    assign led[1] = ~reset_sim;
    assign led[2] = ~each_spike;
    assign led[3] = ~spike_in1;
//    assign led[4] = ~MN_bic_spike;
	 assign led[4] = ~CN1_bic_spk;
    assign led[5] =  ~CN2_bic_spk;
    assign led[6]  = ~0; // slow clock
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
    assign pin2 = spindle_clk;
    
    assign spike_out1 = CN2_bic_spk;


  // Instantiate the okHost and connect endpoints.
    // Host interface
    // *** Endpoint connections:
  
    okHost okHI(
        .hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .hi_aa(hi_aa), .ti_clk(ti_clk),
        .ok1(ok1), .ok2(ok2));
        
    parameter NUM_OK_IO = 14;

    wire [NUM_OK_IO*17 - 1: 0]  ok2x;
    okWireOR # (.N(NUM_OK_IO)) wireOR (ok2, ok2x);
    okWireIn     wi00 (.ok1(ok1),                           .ep_addr(8'h00), .ep_dataout(ep00wire));
    okWireIn     wi01 (.ok1(ok1),                           .ep_addr(8'h01), .ep_dataout(ep01wire));
    okWireIn     wi02 (.ok1(ok1),                           .ep_addr(8'h02), .ep_dataout(ep02wire));
    //okWireIn     wi03 (.ok1(ok1),                           .ep_addr(8'h03), .ep_dataout(ep001wire));


    okWireOut    wo20 (.ep_datain(I_synapse_CN1[15:0]), .ok1(ok1), .ok2(ok2x[  0*17 +: 17 ]), .ep_addr(8'h20) );
    okWireOut    wo21 (.ep_datain(I_synapse_CN1[31:16]), .ok1(ok1), .ok2(ok2x[  1*17 +: 17 ]), .ep_addr(8'h21) );
    okWireOut    wo22 (.ep_datain(I_synapse_CN1_gainAdjusted32[15:0]), .ok1(ok1), .ok2(ok2x[  2*17 +: 17 ]), .ep_addr(8'h22) );
    okWireOut    wo23 (.ep_datain(I_synapse_CN1_gainAdjusted32[31:16]), .ok1(ok1), .ok2(ok2x[  3*17 +: 17 ]), .ep_addr(8'h23) );
    okWireOut    wo24 (.ep_datain(I_synapse_CN2_gainAdjusted32[15:0]), .ok1(ok1), .ok2(ok2x[  4*17 +: 17 ]), .ep_addr(8'h24) );
    okWireOut    wo25 (.ep_datain(I_synapse_CN2_gainAdjusted32[31:16]), .ok1(ok1), .ok2(ok2x[  5*17 +: 17 ]), .ep_addr(8'h25) );
    okWireOut    wo26 (.ep_datain(i_gain_syn[15:0]), .ok1(ok1), .ok2(ok2x[  6*17 +: 17 ]), .ep_addr(8'h26) );
    okWireOut    wo27 (.ep_datain(i_gain_syn[31:16]), .ok1(ok1), .ok2(ok2x[  7*17 +: 17 ]), .ep_addr(8'h27) );
//    okWireOut    wo28 (.ep_datain({15'd0,spike_in1_delayed}),  .ok1(ok1), .ok2(ok2x[ 8*17 +: 17 ]), .ep_addr(8'h28) );
//    okWireOut    wo29 (.ep_datain(16'd0), .ok1(ok1), .ok2(ok2x[ 9*17 +: 17 ]), .ep_addr(8'h29) );
//    okWireOut    wo30 (.ep_datain(f_tri_len[15:0]),  .ok1(ok1), .ok2(ok2x[ 10*17 +: 17 ]), .ep_addr(8'h30) );
//    okWireOut    wo31 (.ep_datain(f_tri_len[31:16]), .ok1(ok1), .ok2(ok2x[ 11*17 +: 17 ]), .ep_addr(8'h31) );
    //ep_ready = 1 (always ready to receive)
    okBTPipeIn   ep80 (.ok1(ok1), .ok2(ok2x[ 12*17 +: 17 ]), .ep_addr(8'h80), .ep_write(is_pipe_being_written), .ep_blockstrobe(), .ep_dataout(hex_from_py), .ep_ready(1'b1));
    //okBTPipeOut  epA0 (.ok1(ok1), .ok2(ok2x[ 5*17 +: 17 ]), .ep_addr(8'ha0), .ep_read(pipe_out_read),  .ep_blockstrobe(), .ep_datain(response_nerf), .ep_ready(pipe_out_valid));
    //okBTPipeOut  epA0 (.ok1(ok1), .ok2(ok2x[ 11*17 +: 17 ]), .ep_addr(8'ha1), .ep_read(pipe_out_read),  .ep_blockstrobe(), .ep_datain(rawspikes), .ep_ready(1'b1));

    okTriggerIn ep50 (.ok1(ok1),  .ep_addr(8'h50), .ep_clk(clk1), .ep_trigger(ep50trig));
endmodule



