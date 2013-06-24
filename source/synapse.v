`timescale 1ns / 1ps
`default_nettype none
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



module synapse_simple(
    input wire clk, //sim_clk
    input wire reset,
    input wire spike_in,
    //input wire postsynaptic_spike_in,
    output wire [31:0] f_I_out  // updates once per population (scaling factor 1024) 
    //output reg signed [31:0] each_I // updates on each synapse
 ); 
    wire [31:0] IEEE_1;
    reg [31:0] f_spikes_in; 
    assign IEEE_1 = 32'h3F800000;
 
 
    reg [31:0]      f_spikes_in_1,  f_spikes_in_2;
    reg signed   	 [31:0] f_total_I_out1, f_total_I_out2;
    reg signed  	 [31:0] f_total_I_out;     
    wire signed      [31:0] f_total_I_out_F0;
    
    wire signed [31:0] a0, a1, a2, a3, b1, b2;
    wire signed [31:0] b1x1, b2x2, a1y1, a2y2, bx_terms, ay_terms;
    
    
    //filter coefficients: 
//    num_syn =  0    2.2179   -2.1644
//    den_syn = 1.0000   -1.9518    0.9523
    assign b1 = 32'h400DF213;   //2.2179 
    assign b2 = 32'hC00A8588 ;    // -2.1644
    assign a1 = 32'hBFF9D495;     //-1.9518
    assign a2 = 32'h3F73C9EF;    //0.9523
    
     // ********************implementing difference equation ********************
    // y[n] = b1*x[n-1] + b2*x[n-2] - a1*y[n-1] - a2*y[n-2] - a3*y[n-3]
    // ***************************************************************************************
    mult  mult_b1(.x(b1), .y(f_spikes_in_1), .out(b1x1));
    mult  mult_b2(.x(b2), .y(f_spikes_in_2), .out(b2x2));
    mult  mult_a1(.x(a1), .y(f_total_I_out1), .out(a1y1));
    mult  mult_a2(.x(a2), .y(f_total_I_out2), .out(a2y2));
    
    add   add_b1b2(.x(b1x1), .y(b2x2), .out(bx_terms));
    add   add_a1a2(.x(a1y1), .y(a2y2), .out(ay_terms));
    sub   sub_b1b2_a1a2a3(.x(bx_terms), .y(ay_terms), .out(f_total_I_out_F0));
    
    
    
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            f_spikes_in_1 <= 32'd0;
            f_spikes_in_2 <= 32'd0;
            f_total_I_out1 <= 32'd0;
            f_total_I_out2 <= 32'd0;
			f_total_I_out <= 32'd0;
            f_spikes_in <= 32'h0;

        end
        else begin
            f_spikes_in_1 <= f_spikes_in;
            f_spikes_in_2 <= f_spikes_in_1;
            f_total_I_out1 <= f_total_I_out_F0;
            f_total_I_out2 <= f_total_I_out1;
			f_total_I_out <= f_total_I_out_F0;
            f_spikes_in <= (spike_in)? IEEE_1 : 32'h0;

        end
    end
    
    assign f_I_out = f_total_I_out;
                
              
 endmodule





// max frequency 88.746 MHz
module synapse_stdp(
                input wire clk,
                input wire reset,
                input wire spike_in,
                input wire postsynaptic_spike_in,
                output reg signed [31:0] I_out,  // updates once per population (scaling factor 1024) 
                output reg signed [31:0] each_I // updates on each synapse
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

assign spike_history_mem_in = first_pass ? 0 : {spike_history_mem[31:1], spike};

wire [31:0] delta_w;

assign delta_w = postsynaptic_spike ? ((spike_history_mem == 32'd0) ? 0 : 32'd1024) :
                        0 ;

wire [31:0] ps_spike_history_mem;
wire [31:0] ps_spike_history_mem_in;

assign ps_spike_history_mem_in = first_pass ? 0 : {ps_spike_history_mem[31:1], postsynaptic_spike};

wire [31:0] delta_w_ltd;

assign delta_w_ltd = spike ? ((ps_spike_history_mem == 32'd0) ? 0 : -32'd512) :
                        0 ;

wire [31:0] impulse_mem;
wire [31:0] impulse_mem_in;

assign impulse_mem_in = first_pass ? 32'd10240 : impulse_mem+delta_w+delta_w_ltd;

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


