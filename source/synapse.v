`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:57:07 05/30/2012 
// Design Name: 
// Module Name:    synapse 
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

// max frequency 88.746 MHz
module synapse(
                input wire clk,
                input wire reset,
                input wire spike_in,
                input wire postsynaptic_spike_in,
                output reg signed [31:0] I_out,  // updates once per population (scaling factor 1024) 
                output reg signed [31:0] each_I, // updates on each synapse
                
                input wire [31:0] ltp,              // long term potentiation delta
                input wire [31:0] ltd,              // long term depression delta
                input wire [31:0] p_delta           // probability of plasticity event
    );

// COMPUTE EACH SYNAPTIC CURRENT /////////////////////////////////////////////////////////////////

wire [31:0] impulse;

reg spike;
reg postsynaptic_spike;
//assign impulse = spike ? 31'd1024 : 0; // 1(unit?) current per spike
//assign impulse = spike ? 31'd10240 : 0; // 10(unit?) current per spike
assign impulse = spike ? impulse_mem_in : 0;

wire [31:0] i_mem;
wire [31:0] i_mem_in;

assign i_mem_in = first_pass ? 0 : (i_mem >>> 1) + (i_mem >>> 2) + (i_mem >>> 3) + impulse;

wire [31:0] spike_history_mem;
wire [31:0] spike_history_mem_in;

assign spike_history_mem_in = first_pass ? 0 : {spike_history_mem[30:0], spike};

wire [31:0] delta_w;

assign delta_w = postsynaptic_spike ? ((spike_history_mem == 32'd0) ? 0 : ltp) :
                        0 ;

wire [31:0] ps_spike_history_mem;
wire [31:0] ps_spike_history_mem_in;

assign ps_spike_history_mem_in = first_pass ? 0 : {ps_spike_history_mem[30:0], postsynaptic_spike};

wire [31:0] delta_w_ltd;

assign delta_w_ltd = spike ? ((ps_spike_history_mem == 32'd0) ? 0 : ltd) :
                        0 ;
                        
wire [31:0] random_out;
wire [31:0] impulse_decay;

assign impulse_decay = (random_out <= p_delta) ? impulse_mem >>> 7 : 0; 
    
    rng decay_rng(
            .clk1(clk),
            .clk2(clk),
            .reset(reset),
            .out(random_out),
            
            .lfsr(),
            .casr()
    );
    
wire [31:0] impulse_mem;
wire [31:0] impulse_mem_in;

assign impulse_mem_in = first_pass ? 32'd10240 : impulse_mem+delta_w+delta_w_ltd-impulse_decay;


// STATE MACHINE //////////////////////////////////////////////////////////////////////////////////////
    
    reg state;
    reg read;
    reg write;
    reg first_pass;
    reg [6:0] neuron_index;

    
    
    always @ (posedge clk or posedge reset)
    begin
        if (reset) begin
            state <= 1;
            write <= 0;
            spike <= 0;
            postsynaptic_spike <= 0;
            neuron_index<=0;
        end else begin
            case(state)
                0:  begin
                    neuron_index <= neuron_index + 1;
                    write <= 0;
                    state <= 1;
                    spike <= spike;
                    postsynaptic_spike <= postsynaptic_spike;
                    end
                1:  begin
                    neuron_index <= neuron_index;
                    write <= 1;
                    state <= 0;
                    spike <= spike_in;
                    postsynaptic_spike <= postsynaptic_spike_in;
                    end
             endcase
        end
    end
    
    // PERFORM READ/COMPUTE/WRITE CYCLE ON RAM CONTENTS


wire reset_bar;
assign reset_bar = ~reset;
always @ (negedge clk or negedge reset_bar) begin
    if (~reset_bar) begin
       first_pass <= 1;
       I_out <= 0;
       each_I <= 0;
    end else begin
        if (state) begin
            each_I <= i_mem_in;
            if (neuron_index == 7'h7f) begin
                first_pass <= 0;
                I_out <= i_mem_in;
            end
        end
    end
end

    
    neuron_ram i_ram (
  .clka(~clk), // input clka
  .wea(write), // input [0 : 0] wea
  .addra(neuron_index), // input [6 : 0] addra
  .dina(i_mem_in), // input [31 : 0] dina
  .douta(i_mem), // output [31 : 0] douta
  .clkb(clk), // input clkb
  .web(1'b0), // input [0 : 0] web
  .addrb(7'd0), // input [6 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb() // output [31 : 0] doutb
    );

    neuron_ram spike_history_ram (
  .clka(~clk), // input clka
  .wea(write), // input [0 : 0] wea
  .addra(neuron_index), // input [6 : 0] addra
  .dina(spike_history_mem_in), // input [31 : 0] dina
  .douta(spike_history_mem), // output [31 : 0] douta
  .clkb(clk), // input clkb
  .web(1'b0), // input [0 : 0] web
  .addrb(7'd0), // input [6 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb() // output [31 : 0] doutb
    );
    
     neuron_ram ps_spike_history_ram (
  .clka(~clk), // input clka
  .wea(write), // input [0 : 0] wea
  .addra(neuron_index), // input [6 : 0] addra
  .dina(ps_spike_history_mem_in), // input [31 : 0] dina
  .douta(ps_spike_history_mem), // output [31 : 0] douta
  .clkb(clk), // input clkb
  .web(1'b0), // input [0 : 0] web
  .addrb(7'd0), // input [6 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb() // output [31 : 0] doutb
    );

    neuron_ram impulse_ram (
  .clka(~clk), // input clka
  .wea(write), // input [0 : 0] wea
  .addra(neuron_index), // input [6 : 0] addra
  .dina(impulse_mem_in), // input [31 : 0] dina
  .douta(impulse_mem), // output [31 : 0] douta
  .clkb(clk), // input clkb
  .web(1'b0), // input [0 : 0] web
  .addrb(7'd0), // input [6 : 0] addrb
  .dinb(32'd0), // input [31 : 0] dinb
  .doutb() // output [31 : 0] doutb
    );
endmodule















//
//
//
//////////////////////////////////////////
////// Synapse ///////////////////////////
//////////////////////////////////////////
//// Acts to create an exponentially falling current at the output 
//// from a spike input and a weight which can be +/-
//// up to three spike inputs are defined, each with its own weight
//module synapse_int(I_out,spk1,w1,spk2,w2,spk3,w3,clk,reset);
//
//	output reg [17:0] I_out; 				//the simulated current
//	input spk1,spk2,spk3;     			// the spike inputs
//	input signed [17:0] w1,w2,w3;   //weights
//
//	input clk, reset;
//	reg  [17:0] syn1_trace, syn2_trace, syn3_trace;  // current synaptic traces
//	wire  [17:0] I_F0, syn1_trace_F0, syn2_trace_F0, syn3_trace_F0; // synaptic traces delayed by 1 clk cycle
//	
//	//maintain "traces" that are decaying functions of the last spike time
//	//if spike comes in then reset count, otherwise multiply by 0.875 = 0.5 + 0.25 + 0.125
//
//	//assign syn1_trace_F0 = spk1 ? 9'sh0ff : ((syn1_trace >>> 1) + (syn1_trace >>> 2) + (syn1_trace >>> 3));
//	//assign syn2_trace_F0 = spk2 ? 9'sh0ff : ((syn2_trace >>> 1) + (syn2_trace >>> 2) + (syn2_trace >>> 3));
//	//assign syn3_trace_F0 = spk3 ? 9'sh0ff : ((syn3_trace >>> 1) + (syn3_trace >>> 2) + (syn3_trace >>> 3));	//not used
//    
//    
////	assign syn1_trace_F0 = spk1 ? 18'sh3ffff : (syn1_trace - (syn1_trace >>> 10));  // allow half life in 500 clk cycles.
////    assign syn2_trace_F0 = spk2 ? 18'sh3ffff : (syn2_trace - (syn2_trace >>> 10));  // xn = (0.9991)*xn_1  (for 10 bit shift)
////	assign syn3_trace_F0 = spk3 ? 18'sh3ffff : (syn3_trace - (syn3_trace >>> 10)); 
//	
//    assign syn1_trace_F0 = spk1 ? 18'sh3ffff : ((syn1_trace >>> 1) + (syn1_trace >>> 2) + (syn1_trace >>> 3) + (syn1_trace >>> 4) + (syn1_trace >>> 5) + (syn1_trace >>> 6) + (syn1_trace >>> 7) + (syn1_trace >>> 8) + (syn1_trace >>> 9));  // allow half life in 500 clk cycles.
//    assign syn2_trace_F0 = spk2 ? 18'sh3ffff : ((syn2_trace >>> 1) + (syn2_trace >>> 2) + (syn2_trace >>> 3) + (syn2_trace >>> 4) + (syn2_trace >>> 5) + (syn2_trace >>> 6) + (syn2_trace >>> 7) + (syn2_trace >>> 8) + (syn2_trace >>> 9));  // xn = (0.9991)*xn_1  (for 10 bit shift)
//	assign syn3_trace_F0 = spk3 ? 18'sh3ffff : ((syn3_trace >>> 1) + (syn3_trace >>> 2) + (syn3_trace >>> 3) + (syn3_trace >>> 4) + (syn3_trace >>> 5) + (syn3_trace >>> 6) + (syn3_trace >>> 7) + (syn3_trace >>> 8) + (syn3_trace >>> 9));
//    
//	assign I_F0 = syn1_trace * w1 + syn2_trace * w2 + syn3_trace * w3;
//	
//   always @(posedge clk or posedge reset) begin
//        if (reset) begin
//				syn1_trace <= 18'd0;
//				syn2_trace <= 18'd0;
//				syn3_trace <= 18'd0;
//				I_out <= 18'd0;
//        end
//        else begin
//				I_out <= I_F0;
//				syn1_trace <= syn1_trace_F0;
//				syn2_trace <= syn2_trace_F0;
//				syn3_trace <= syn3_trace_F0;
//        end
//    end
//
//endmodule
//
