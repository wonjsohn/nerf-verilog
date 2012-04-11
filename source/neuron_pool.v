`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Design Name: 
// Module Name:    neuron_pool.v
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
module neuron_pool (//(f_muscle_length, f_rawfr_Ia, f_pps_coef_Ia, gain, sim_clk, neuron_clk, reset_sim, f_total_force);
    //input   [31:0]  vel,            // change of muscle length
    input   wire [31:0]  f_rawfr_Ia,     //
    input   wire [31:0]  f_pps_coef_Ia,  //
    input   wire [31:0]  half_cnt,
    input   wire rawclk,

    input   wire ti_clk,
    input   wire reset_sim,
    input   wire signed [31:0] i_gain_MN,
    input   wire [NN+2:0] neuronCounter,

    output  wire MN_spike,
    output  wire [15:0] spkid_MN,
	 // debug
	 output wire signed  [31:0] i_current_out,
	 output wire signed [31:0] i_synI_rand_out,
	 output wire signed [31:0] i_postsyn_I_out,
	 output wire signed [31:0] i_gain_MN_used
    );

    parameter NN = 8; // 2^(NN+1) = NUM_NEURON
    
    //Locally generate neuron_clk
    reg neuron_clk;
    reg [31:0] delay_cnt;
    always @ (posedge rawclk) begin
        if (delay_cnt < half_cnt) begin
            neuron_clk <= neuron_clk;
            delay_cnt <= delay_cnt + 1;
        end
        else begin
            neuron_clk<= ~neuron_clk;
            delay_cnt <= 0;
        end
    end

    // *** Izhikevich: f_fr_Ia => spikes
    // *** Convert float_fr to int_I1

    wire [31:0] f_fr_Ia;
    wire [31:0] i_synI_Ia;

	mult scale_pps_Ia( .x(f_rawfr_Ia), .y(f_pps_coef_Ia), .out(f_fr_Ia));
    floor float_to_int_Ia( .in(f_fr_Ia), .out(i_synI_Ia) );
    
    wire Ia_spike, s_Ia;
    wire signed [17:0] v_Ia;   // cell potentials
        
   
//    Iz_neuron #(.NN(NN),.DELAY(10)) Ia_neuron
//    (v_Ia,s_Ia, a,b,c,d, {i_synI_Ia[31], i_synI_Ia[16:0]}, neuron_clk, reset_sim, neuronIndex, neuronWriteEnable, readClock, 4'h2, Ia_spike, neuronWriteCount);
////
//    wire [31:0] f_fr_II;
//    wire [31:0] i_synI_II;
//    mult scale_pps_II( .x(f_rawfr_II), .y(f_pps_coef_II), .out(f_fr_II));
//    floor float_to_int_II( .in(f_fr_II), .out(i_synI_II) );
//    wire II_spike, s_II;
//    wire signed [17:0] v_II;   // cell potentials
//    Iz_neuron #(.NN(NN),.DELAY(10)) II_neuron
//    (v_II,s_II, a,b,c,d, i_synI_II, neuron_clk, reset_sim, neuronIndex, neuronWriteEnable, readClock, 4'h2, II_spike);

    //*** Synapse:: spike -> I   
	wire signed [17:0]  I_out;
    wire [31:0] i_postsyn_I;
  
	assign i_postsyn_I = {{14{I_out[17]}}, I_out};
    
    // *** izh-Motoneuron :: i_postsyn_I -> (MN_spike, rawspike)
    

    wire [17:0] v1, u1, s1;
    
   
	wire [1:0] state;
	assign state = neuronCounter[1:0];
    
	wire [NN:0] neuronIndex;
	assign neuronIndex = neuronCounter[NN+2:2];
	
    //wire MN_spike;
    
    wire [31:0] rand_out;
    rng rng_0(
            .clk1(rawclk),
            .clk2(rawclk),
            .reset(reset_sim),
            .out(rand_out)
    );    
    wire signed [17:0] i_synI_rand = {{14{1'b0}},rand_out[3:0]};
	 ///debug
	 //assign  i_current_out = ( {{14{i_postsyn_I[17]}}, i_postsyn_I[17:0]} + {{14{i_synI_rand[17]}}, i_synI_rand[17:0]} ) * i_gain_MN;
	 //wire signed [17:0] i_init_current = i_postsyn_I[17:0] + i_synI_rand[17:0];
	 
	 wire signed [17:0] i_temp = i_synI_Ia[17:0];
	 wire signed [17:0] i_init_current = i_temp + i_synI_rand;
	 wire signed [17:0] i_gain_MN18 = {i_gain_MN[31], i_gain_MN[16:0]};
	 wire signed [35:0] i_current36 = i_init_current * i_gain_MN18;
	 
	 reg [17:0] i_current_out18;
	 always @(posedge neuron_clk or posedge reset_sim) begin
		if (reset_sim) begin
			i_current_out18 <= 18'd0;
		end
		else begin
			i_current_out18 <= {i_current36[35],i_current36[16:0]};
		end
	 end
	 assign  i_current_out = {{14{i_current_out18[17]}}, i_current_out18[16:0]};
	 assign i_gain_MN_used = {{14{i_gain_MN18[17]}}, i_gain_MN18[17:0]};
	 
	 
	 assign i_synI_rand_out =  {{14{1'b0}}, i_synI_rand[17:0]};
	 assign i_postsyn_I_out = {{14{i_postsyn_I[17]}},i_postsyn_I[17:0]};

	//Iz_neuron #(.NN(NN),.DELAY(10)) neuMN(v1,s1, a,b,c,d, i_current_out18 , neuron_clk, reset_sim, neuronIndex, neuronWriteEnable, readClock, tau, MN_spike, neuronWriteCount);
    wire [31:0] v;
    wire spike;
    wire [127:0] population;
    izneuron neuron_0(
                .clk(neuron_clk),
                .reset(reset_sim),
                .I_in(i_current_out),                
                .spike(MN_spike),                
                .spkid(spkid_MN)
    );    
    //reg [15:0] raw_Ia_spikes, raw_II_spikes, raw_MN_spikes;
	//always @(negedge ti_clk) raw_Ia_spikes <= {1'b0, neuronIndex[NN:2], 1'b0, Ia_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
//    always @(negedge ti_clk) raw_II_spikes <= {1'b0, neuronIndex[NN:2], 1'b0, 1'b0, II_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};

//
//    assign raw_MN_spikes = {1'b0, neuronIndex[NN:2], MN_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
//	assign raw_Ia_spikes = {1'b0, neuronIndex[NN:2], 1'b0, Ia_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
//	assign raw_II_spikes = {1'b0, neuronIndex[NN:2], 1'b0, 1'b0, II_spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
    
    // *** Count the spikes: rawspikes -> spike -> spike_count_out
	
   




endmodule

