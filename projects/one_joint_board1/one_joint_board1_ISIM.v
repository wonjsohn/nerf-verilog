`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Creator: Eric W. Sohn (test bench[tb] written by) 

// 
// Module Name:    
// Project Name: 
// Target Devices:    ISIM test bench
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
module one_joint_board1_xem6010(
	 );

    parameter NN = 8;
    // *** Dump all the declarations here:
    wire         ti_clk;
    wire [30:0]  ok1;
    wire [16:0]  ok2;   
    wire [15:0]  ep00wire, ep01wire, ep02wire, ep50trig, ep20wire, ep21wire, ep22wire, ep23wire;
    wire [15:0]  ep24wire, ep25wire, ep26wire, ep27wire, ep28wire, ep29wire, ep30wire, ep31wire;
    // reset_global, reset_sim;
    wire        is_pipe_being_written, is_lce_valid;
    
    wire [15:0] hex_from_py;
    
    reg [17:0] delay_cnt, delay_cnt_max;
    
    reg reset_global, reset_sim;

    //assign enable_sim = is_waveform_valid;
    wire    [31:0]  IEEE_1, IEEE_0;
	assign IEEE_1 = 32'h3F800000;
	assign IEEE_0 = 32'd0;

 
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
            tau <= 32'd1; // 
        else
            tau <= {ep02wire, ep01wire};  
    end       

    reg [31:0] gain;
    always @(posedge ep50trig[3] or posedge reset_global)
    begin
        if (reset_global)
            gain <= 32'd0;
        else
            gain <= {ep02wire, ep01wire};  //firing rate
    end        
    
//    reg [31:0] f_gamma_dyn;
//    always @(posedge ep50trig[4] or posedge reset_global)
//    begin
//        if (reset_global)
//            f_gamma_dyn <= 32'h42A0_0000; // gamma_dyn reset to 80
//        else
//            f_gamma_dyn <= {ep02wire, ep01wire};  
//    end  
    
//    reg [31:0] f_gamma_sta;
//    always @(posedge ep50trig[5] or posedge reset_global)
//    begin
//        if (reset_global)
//            f_gamma_sta <= 32'h42A0_0000; // gamma_sta reset to 80
//        else
//            f_gamma_sta <= {ep02wire, ep01wire};  
//    end  
    
    reg signed [31:0] i_gain_mu1_MN;
    always @(posedge ep50trig[6] or posedge reset_global)
    begin
        if (reset_global)
            i_gain_mu1_MN <= 32'd1; // gamma_sta reset to 80
        else
            i_gain_mu1_MN <= {ep02wire, ep01wire};  
    end
	 
    reg signed [31:0] i_gain_mu2_MN;
    always @(posedge ep50trig[7] or posedge reset_global)
    begin
        if (reset_global)
            i_gain_mu2_MN <= 32'd1; // gamma_sta reset to 80
        else
            i_gain_mu2_MN <= {ep02wire, ep01wire};  
    end  

    reg signed [31:0] i_gain_mu3_MN;
    always @(posedge ep50trig[8] or posedge reset_global)
    begin
        if (reset_global)
            i_gain_mu3_MN <= 32'd1; // gamma_sta reset to 80
        else
            i_gain_mu3_MN <= {ep02wire, ep01wire};  
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
    
    parameter DATALINES = 1024;
	 
    // For test bench 
    // clk1 generation
    reg clk1;
    reg [31:0] data [DATALINES-1:0];
    //reg [31:0] data_output [5:0];
	 reg [31:0] data_input;
	 reg [31:0] data_output;
    reg [31:0] k, outfile;
	 reg reading;
     
	  // reset tb
     initial begin 
          #140 reset_global = 0; 
          #40 reset_sim = 0; 
     end
	 
	  // tb time profile
     initial
         begin 
         $readmemh("stimulus.txt", data);  // read input file once.
         $timeformat(-9, 1, " ns", 6);
		   #100;
         clk1 = 1'b0;  reset_global = 1; reset_sim = 1; k = 0; reading = 0; 
		   delay_cnt_max = 197;   // calculated from the equation in NIPS paper. (F_fpga = 200Mhz, C = 4, F_emul = 1Khz ....) 
		   #10 reset_sim = 0;
		   #10 reset_sim = 1;
		   #10 reset_sim = 0;	 // reset for one more time.   
		   reading=1;          // to control reading.       
		   outfile = $fopen ("response.txt", "w");   // output file to write.  
		   #100000; //for reading.
		  
		   #40000000;   // 4ms
			$fclose (outfile);    // CLOSE THE OUTPUT FILE			 
         $finish; // to shut down the simulation
    end

	 // writing multiple variables to file. Only write as much data points in the input file. 
	 always @(posedge sim_clk or posedge reset_sim) begin
		  if (reset_sim) begin
				data_input <= 32'd0;
		  end 
		  if (reading & (k < DATALINES)) begin
				data_input <= data[k]; 
				$fdisplay(outfile, "%x	%x   %x",  data_input, f_bicepsfr_Ia, f_force_mu1);
				k <= k + 1;
		  end          
	 end 
  
    // 200Mhz base clock
    always begin
        #5  clk1 = ~clk1;
    end
    
	 wire [31:0] data_output_F0;

	 // *** Integrator test 
    integrator integrate_data_input
    (
        .x(data_input),       //dT_i
        .int_x(data_output),   //T_i
		  .reset(reset_sim),
        .out(data_output_F0)     //T_i_F0
    );

    always @(posedge sim_clk or posedge reset_sim) begin
        if (reset_sim) begin
				data_output <= 32'd0;
        end
        else begin
            data_output <= data_output_F0;
        end
    end
        
    // *** Deriving clocks from on-board clk1:
    wire neuron_clk, sim_clk, spindle_clk;
    wire [NN+2:0] neuronCounter;
    
    gen_clk #(.NN(NN)) useful_clocks
    (   .rawclk(clk1), 
		  .reset(reset_global),
        .half_cnt(delay_cnt_max), 
        .clk_out1(neuron_clk), 
        .clk_out2(sim_clk), 
        .clk_out3(spindle_clk),
        .int_neuron_cnt_out(neuronCounter) );
                   
    wire [31:0] f_gamma_dyn, f_gamma_sta;
    assign f_gamma_dyn = 32'h42A0_0000;
    assign f_gamma_sta = 32'h42A0_0000;
    


    //** MOTOR UNIT 1
    wire [31:0]  f_force_mu1;  // output muscle force 
    wire [31:0]  i_emg_mu1;
    wire MN_spk_mu1;	
    wire [15:0] spkid_MN_mu1;
    motorunit mu1 (
    .f_muscle_length(data_input),  // muscle length
    .f_rawfr_Ia(f_bicepsfr_Ia),     //
    .f_pps_coef_Ia(f_pps_coef_Ia),  //
    .half_cnt(delay_cnt_max),.rawclk(clk1),  .ti_clk(ti_clk), .sim_clk(sim_clk), 
    .neuron_clk(neuron_clk), .reset_sim(reset_sim),.neuronCounter(neuronCounter),
    .gain(IEEE_1),           // gain 
    .i_gain_MN(i_gain_mu1_MN),
    .tau(IEEE_1),
    .f_total_force(f_force_mu1),  // output muscle force 
    .i_emg(i_emg_mu1),
    .MN_spk(MN_spk_mu1),
    .spkid_MN(spkid_MN_mu1)
    );
	 
	 
	 
    // *** Spindle: f_muscle_len => f_rawfr_Ia
    wire [31:0] f_bicepsfr_Ia, x_0_bic, x_1_bic, f_bicepsfr_II;
    
    spindle bic_bag1_bag2_chain
    (	.gamma_dyn(f_gamma_dyn), // 32'h42A0_0000
        .gamma_sta(f_gamma_sta),
        .lce(data_input),
        .clk(spindle_clk),
        .reset(reset_sim),
        .out0(x_0_bic),
        .out1(x_1_bic),
        .out2(f_bicepsfr_II),
        .out3(f_bicepsfr_Ia),
        .BDAMP_1(32'h3E71_4120),
        .BDAMP_2(32'h3D14_4674),
        .BDAMP_chain(32'h3C58_44D0)
		);
    
 
    wire [31:0] delay_cnt_max32;
    assign delay_cnt_max32 = {12'b0, delay_cnt_max};

    
 
  //  assign reset_global = ep00wire[0];
  //  assign reset_sim = ep00wire[1];
    


  // Instantiate the okHost and connect endpoints.
    // Host interface
    // *** Endpoint connections:
  
//    okHost okHI(
//        .hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .hi_aa(hi_aa), .ti_clk(ti_clk),
//        .ok1(ok1), .ok2(ok2));
//        
//    parameter NUM_OK_IO = 20;
//
//    wire [NUM_OK_IO*17 - 1: 0]  ok2x;
//    okWireOR # (.N(NUM_OK_IO)) wireOR (ok2, ok2x);
//    okWireIn     wi00 (.ok1(ok1),                           .ep_addr(8'h00), .ep_dataout(ep00wire));
//    okWireIn     wi01 (.ok1(ok1),                           .ep_addr(8'h01), .ep_dataout(ep01wire));
//    okWireIn     wi02 (.ok1(ok1),                           .ep_addr(8'h02), .ep_dataout(ep02wire));
//    //okWireIn     wi03 (.ok1(ok1),                           .ep_addr(8'h03), .ep_dataout(ep03wire));
//
//
//    okWireOut    wo20 (.ep_datain(f_rawfr_Ia[15:0]), .ok1(ok1), .ok2(ok2x[  0*17 +: 17 ]), .ep_addr(8'h20) );
//    okWireOut    wo21 (.ep_datain(f_rawfr_Ia[31:16]), .ok1(ok1), .ok2(ok2x[  1*17 +: 17 ]), .ep_addr(8'h21) );
////    okWireOut    wo22 (.ep_datain(i_MN_spkcnt[15:0]), .ok1(ok1), .ok2(ok2x[  2*17 +: 17 ]), .ep_addr(8'h22) );
////    okWireOut    wo23 (.ep_datain(i_MN_spkcnt[31:16]), .ok1(ok1), .ok2(ok2x[  3*17 +: 17 ]), .ep_addr(8'h23) );
////    okWireOut    wo24 (.ep_datain(i_CN_spkcnt[15:0]), .ok1(ok1), .ok2(ok2x[  4*17 +: 17 ]), .ep_addr(8'h24) );
////    okWireOut    wo25 (.ep_datain(i_CN_spkcnt[31:16]), .ok1(ok1), .ok2(ok2x[  5*17 +: 17 ]), .ep_addr(8'h25) );
////    okWireOut    wo26 (.ep_datain(i_combined_spkcnt[15:0]), .ok1(ok1), .ok2(ok2x[  6*17 +: 17 ]), .ep_addr(8'h26) );
////    okWireOut    wo27 (.ep_datain(i_combined_spkcnt[31:16]), .ok1(ok1), .ok2(ok2x[  7*17 +: 17 ]), .ep_addr(8'h27) );
////    okWireOut    wof28 (.ep_datain(i_MN_emg[15:0]),  .ok1(ok1), .ok2(ok2x[ 8*17 +: 17 ]), .ep_addr(8'h28) );
////    okWireOut    wo29 (.ep_datain(i_MN_emg[31:16]), .ok1(ok1), .ok2(ok2x[ 9*17 +: 17 ]), .ep_addr(8'h29) );
////    okWireOut    wo30 (.ep_datain(i_CN_emg[15:0]),  .ok1(ok1), .ok2(ok2x[ 10*17 +: 17 ]), .ep_addr(8'h30) );
////    okWireOut    wo31 (.ep_datain(i_CN_emg[31:16]), .ok1(ok1), .ok2(ok2x[ 11*17 +: 17 ]), .ep_addr(8'h31) );
////    okWireOut    wo32 (.ep_datain(i_combined_emg[15:0]),  .ok1(ok1), .ok2(ok2x[ 12*17 +: 17 ]), .ep_addr(8'h32) );
////    okWireOut    wo33 (.ep_datain(i_combined_emg[31:16]), .ok1(ok1), .ok2(ok2x[ 13*17 +: 17 ]), .ep_addr(8'h33) );   
//    //ep_ready = 1 (always ready to receive)
//    okBTPipeIn   ep80 (.ok1(ok1), .ok2(ok2x[ 14*17 +: 17 ]), .ep_addr(8'h80), .ep_write(is_pipe_being_written), .ep_blockstrobe(), .ep_dataout(hex_from_py), .ep_ready(1'b1));
//    //okBTPipeOut  epA0 (.ok1(ok1), .ok2(ok2x[ 5*17 +: 17 ]), .ep_addr(8'ha0), .ep_read(pipe_out_read),  .ep_blockstrobe(), .ep_datain(response_nerf), .ep_ready(pipe_out_valid));
//    //okBTPipeOut  epA0 (.ok1(ok1), .ok2(ok2x[ 11*17 +: 17 ]), .ep_addr(8'ha1), .ep_read(pipe_out_read),  .ep_blockstrobe(), .ep_datain(rawspikes), .ep_ready(1'b1));
//
//    okTriggerIn ep50 (.ok1(ok1),  .ep_addr(8'h50), .ep_clk(clk1), .ep_trigger(ep50trig));
endmodule



