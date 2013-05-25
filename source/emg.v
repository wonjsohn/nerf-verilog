`default_nettype none
`timescale 1ns / 1ps

//*****************************************************************************************************
//          floating point emg model - recursive method
//*******************************************************************************************************

module emg(f_total_emg_out, i_spike_cnt, clk, reset);

	output [31:0] f_total_emg_out;
	input [31:0] i_spike_cnt;
	input wire  clk, reset;
    
    reg signed		 [31:0] f_spikes_cnt_1, f_spikes_cnt_2;
    reg signed   	 [31:0] f_total_emg1, f_total_emg2, f_total_emg3;
    reg signed  	 [31:0] f_total_emg; 
    wire signed      [31:0] f_total_emg_F0;
    wire [31:0]  f_spikes_cnt;
    wire signed [31:0] a0, a1, a2, a3, b1, b2;
    wire signed [31:0] b1x1, b2x2, a1y1, a2y2, a3y3, bx_terms, a1y1a2y2, ay_terms;
    
    //** implementation 
    int_to_float get_fp_spike(.out(f_spikes_cnt), .in(i_spike_cnt));
    
//	assign b1 = 32'h3FC645A2; //1.549  
//    assign b2 = 32'hBFD0A3D7; //-1.63
////    assign b1 = 32'h3ACB07D1; //0.001549  
////    assign b2 = 32'hBAD5A5B9; //-0.00163
//
//	assign a0 = 32'h3F800000; //1.0
//    assign a1 = 32'hC0253F7D; //-2.582 
//    assign a2 = 32'h400E353F; //2.222
//    assign a3 = 32'hBF2339C1; //-0.6376
    
    //Transfer function:
    //     0.001503 z^2 - 0.001535 z 
    //       -------------------------------------
    // z^3 - 2.506 z^2 + 2.093 z - 0.5827
    
//    assign b1 = 32'h3FC645A2; //1.549  
//    assign b2 = 32'hBFD0A3D7; //-1.63
    assign b1 = 32'h3AC50050; //0.001503 
    assign b2 = 32'hBAC9320E; //-0.001535

	assign a0 = 32'h3F800000; //1.0
    assign a1 = 32'hC020624E; //-2.506
    assign a2 = 32'h4005F3B6; //2.093
    assign a3 = 32'hBF152BD4; //-0.5827
    
    
    
    // ********************implementing difference equation ********************
    // y[n] = b1*x[n-1] + b2*x[n-2] - a1*y[n-1] - a2*y[n-2] - a3*y[n-3]
    // ***************************************************************************************
    mult  mult_b1(.x(b1), .y(f_spikes_cnt_1), .out(b1x1));
    mult  mult_b2(.x(b2), .y(f_spikes_cnt_2), .out(b2x2));
    mult  mult_a1(.x(a1), .y(f_total_emg1), .out(a1y1));
    mult  mult_a2(.x(a2), .y(f_total_emg2), .out(a2y2));
    mult  mult_a3(.x(a3), .y(f_total_emg3), .out(a3y3));
    
    add   add_b1b2(.x(b1x1), .y(b2x2), .out(bx_terms));
    add   add_a1a2(.x(a1y1), .y(a2y2), .out(a1y1a2y2));
    add   add_a1a2a3(.x(a1y1a2y2), .y(a3y3), .out(ay_terms));
    sub   sub_b1b2_a1a2a3(.x(bx_terms), .y(ay_terms), .out(f_total_emg_F0));
    
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            f_spikes_cnt_1 <= 32'd0;
            f_spikes_cnt_2 <= 32'd0;
            f_total_emg1 <= 32'd0;
            f_total_emg2 <= 32'd0;
            f_total_emg3 <= 32'd0;
			f_total_emg <= 32'd0;
        end
        else begin
            f_spikes_cnt_1 <= f_spikes_cnt;
            f_spikes_cnt_2 <= f_spikes_cnt_1;
            f_total_emg1 <= f_total_emg_F0;
            f_total_emg2 <= f_total_emg1;
            f_total_emg3 <= f_total_emg2;
			f_total_emg <= f_total_emg_F0;
        end
    end
    
    assign f_total_emg_out = f_total_emg;
  

endmodule

//
//
//module emg(emg_out, i_spk_cnt, clk, reset);
//	parameter NN = 6;  // (log2(neuronCount) - 1)
//	output wire signed  [17:0] emg_out;
//	input wire [NN:0] i_spk_cnt;
//	input wire  clk, reset;
//	
//	reg signed [35:0] emg_hp, emg_lp;
//	wire [35:0] stimulus, emg_stimulus;
//	reg [35:0]	spikes_long;
//	wire signed [35:0] emg_long;
//
//	assign emg_stimulus = (spikes_long <<< 8);  //{{(29-NN) {1'b0}}, spikes, 7'h00};
//	//assign emg_stimulus = (spikes_long);  //{{(29-NN) {1'b0}}, spikes, 7'h00};
//	assign stimulus = spikes_long;
//
//	assign emg_long = emg_lp - emg_hp;
//	assign emg_out = emg_long[17:0]; 
//	
//	always @(posedge clk or posedge reset)
//	begin
//		spikes_long <= reset? 0:	{{(35-NN) {1'b0}}, i_spk_cnt};
//		emg_hp <= reset ? 36'h0 : (emg_hp + (emg_stimulus >>> 4) - (emg_hp >>> 4)); //TDS 8-17-08 + ((-last_stimulus) >>>4); //0.04 at 25 msec  (40hz hp)
//		emg_lp <= reset ? 36'h0 : (emg_lp - (emg_lp >>> 2) + (emg_stimulus >>> 2)); 			//stimulus;  // (1khz lp)  
//	end
//
//endmodule
