`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Design Name: 
// Module Name:    
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


// 
module neuron_pool (
    input   wire [31:0]  f_rawfr_Ia,     //
    input   wire [31:0]  f_pps_coef_Ia,  //
    input   wire [31:0]  half_cnt,
    input   wire rawclk,

    input   wire ti_clk,
    input   wire reset_global,
    input   wire signed [31:0] i_gain,
//    input   wire [NN+2:0] neuronCounter,

    output  wire spike,
    output  wire each_spike,
    output wire [127:0] population,
    output  wire [15:0] spkid,
	 // debug
	 output reg  [31:0] i_current_out,
	 output wire signed [31:0] out2,
	 output wire signed [31:0] out3,
	 output wire [31:0] out4
    );

    parameter NN = 6; // 2^(NN+1) = NUM_NEURON
    
//    //Locally generate neuron_clk
//    reg neuron_clk;
//    reg [31:0] delay_cnt;
//    always @ (posedge rawclk) begin
//        if (delay_cnt < half_cnt) begin
//            neuron_clk <= neuron_clk;
//            delay_cnt <= delay_cnt + 1;
//        end
//        else begin
//            neuron_clk<= ~neuron_clk;
//            delay_cnt <= 0;
//        end
//    end

	 reg neuron_clk;
    reg [31:0] delay_cnt;

    always @ (posedge rawclk or posedge reset_global) begin
	     if (reset_global) begin
            neuron_clk <= 0;
		  end 
		  
		  else begin
			  if (delay_cnt < half_cnt) begin
					neuron_clk <= neuron_clk;
					delay_cnt <= delay_cnt + 1;
			  end
			  else begin
					neuron_clk <= ~neuron_clk;
					delay_cnt <= 0;
			  end
		  end
    end	 
	 
    // *** Izhikevich: f_fr_Ia => spikes
    // *** Convert float_fr to int_I1

    wire [31:0] f_fr_Ia_F0;
    
    wire [31:0] rand_out;
    rng rng_0(
            .clk1(rawclk),
            .clk2(rawclk),
            .reset(reset_global),
            .out(rand_out)
    );    
    wire [22:0] i23_rand = {1'b0, rand_out[21:0]};
    
    wire [31:0] f_randn_F0 = {12'h3F8, rand_out[19:0]};
    wire [31:0] f_rand_Ia_F0; 
    mult get_rand_Ia( .x(f_rawfr_Ia), .y(f_randn), .out(f_rand_Ia_F0));
	mult scale_pps_Ia( .x(f_rand_Ia), .y(f_pps_coef_Ia), .out(f_fr_Ia_F0));
        
    wire Ia_spike, s_Ia;
    
    wire signed [17:0] v_Ia;   // cell potentials
      

    // *** izh-Motoneuron :: i_postsyn_I -> (MN_spike, rawspike)
    

    wire [17:0] v1, u1, s1;
    
   
	wire [1:0] state;
//	assign state = neuronCounter[1:0];
//    
//	wire [NN:0] neuronIndex;
//	assign neuronIndex = neuronCounter[NN+2:2];
//	
    //wire MN_spike;


    wire signed [31:0] i_current_out_F0;
    floor float_to_int_Ia( .in(f_fr_Ia), .out(i_current_out_F0) );    

	 //reg [31:0] i_current_out;
     reg    [31:0]  f_fr_Ia, f_rand_Ia, f_randn;
	 always @(posedge neuron_clk or posedge reset_global) begin
		if (reset_global) begin
			i_current_out <= 32'd0;
            f_fr_Ia <= 32'd0;
            f_rand_Ia <= 32'd0;
            f_randn <= 32'd0;
		end
		else begin
			//i_current_out <= i_current_F0;
			i_current_out <= i_current_out_F0;
//            f_fr_Ia <= (flag_fr_Ia[2]) ? f_fr_Ia_F0 : f_fr_Ia; 
//            f_rand_Ia <= (flag_rand_Ia[2]) ? f_rand_Ia_F0 : f_rand_Ia;      
            f_fr_Ia <= f_fr_Ia_F0; 
            f_rand_Ia <= f_rand_Ia_F0;                  
            f_randn <= f_randn_F0;
		end
	 end

	//Iz_neuron #(.NN(NN),.DELAY(10)) neuMN(v1,s1, a,b,c,d, i_current_out18 , neuron_clk, reset_sim, neuronIndex, neuronWriteEnable, readClock, tau, MN_spike, neuronWriteCount);
//    wire [31:0] v;
//    wire spike;
//    wire [127:0] population;
//    izneuron neuron_0(
//                .clk(neuron_clk),
//                .reset(reset_sim),
//                .I_in(i_current_out),                
//                .spike(MN_spike),                
//                .spkid(spkid_MN)
//    );    
	 
	 
	 //********* izneuron *************//
	 //wire [31:0] v;
    //wire spike;
    //wire each_spike;
    //wire [127:0] population;
    izneuron_th_control IZN_neuron_pool(
                .clk(neuron_clk),
                .reset(reset_global),
                .I_in(i_current_out),
                .th_scaled(32'd30720),            // default 30mv threshold scaled x1024
                .spike(spike),
                .each_spike(each_spike),
                .population(population)
    );
    
	 
	 
	 
	 
	 
	 
	 
	 
	 
    //reg [15:0] raw_Ia_spikes, raw_II_spikes, raw_MN_spikes;
	//always @(negedge ti_clk) raw_Ia_spikes <= {1'b0, neuronIndex[NN:2], 1'b0, Ia_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
//    always @(negedge ti_clk) raw_II_spikes <= {1'b0, neuronIndex[NN:2], 1'b0, 1'b0, II_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};

//
//    assign raw_MN_spikes = {1'b0, neuronIndex[NN:2], MN_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
//	assign raw_Ia_spikes = {1'b0, neuronIndex[NN:2], 1'b0, Ia_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
//	assign raw_II_spikes = {1'b0, neuronIndex[NN:2], 1'b0, 1'b0, II_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
    
    // *** Count the spikes: rawspikes -> spike -> spike_count_out
	
    assign out2 = f_rand_Ia;
    assign out3 = {31'b0, neuron_clk};
    assign out4 = f_fr_Ia;
endmodule

