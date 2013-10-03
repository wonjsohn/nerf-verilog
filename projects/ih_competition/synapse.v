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
                
                output reg [31:0] synaptic_strength, //synaptic weight
                
                input wire [31:0] base_strength, // baseline synaptic strength
                
                input wire [31:0] ltp,              // long term potentiation delta (stdp)
                input wire [31:0] ltd,              // long term depression delta   (stdp)
                input wire [31:0] p_delta           // probability of synaptic decay event
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

wire [31:0] impulse_stdp;
//wire [31:0] impulse_bcm;
reg [31:0] impulse_bcm;

//assign impulse_mem_in = first_pass ? 32'd10240 : impulse_mem+delta_w+delta_w_ltd-impulse_decay;
//assign impulse_stdp = first_pass ? 32'd10240 : impulse_mem+delta_w+delta_w_ltd-impulse_decay;
assign impulse_stdp = first_pass ? base_strength : impulse_mem+delta_w+delta_w_ltd-impulse_decay;

// BCM-like functionality
wire [31:0] ones;
wire [31:0] d;
assign d = ps_spike_history_mem_in;
assign    ones = (((d[ 0] + d[ 1] + d[ 2] + d[ 3]) + (d[ 4] + d[ 5] + d[ 6] + d[ 7]))
          +  ((d[ 8] + d[ 9] + d[10] + d[11]) + (d[12] + d[13] + d[14] + d[15])))
          + (((d[16] + d[17] + d[18] + d[19]) + (d[20] + d[21] + d[22] + d[23]))
          +  ((d[24] + d[25] + d[26] + d[27]) + (d[28] + d[29] + d[30] + d[31])));

// Estimate firing rate = ones*33 Hz

always @ (ones)
    case (ones)
        0:  impulse_bcm = impulse_stdp << 2;        // push towards 66Hz firing rate
        1:  impulse_bcm = impulse_stdp << 1;
        2:  impulse_bcm = impulse_mem;              // at tuned frequency, do not change synaptic strengths
        3:  impulse_bcm = impulse_stdp >> 1;
        4:  impulse_bcm = impulse_stdp >> 2;
        5:  impulse_bcm = impulse_stdp >> 3;        // pull away from high firing rates
        default: impulse_bcm = impulse_mem;         // default do nothing
    endcase

//assign impulse_mem_in = impulse_bcm;
assign impulse_mem_in = impulse_mem;

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
       synaptic_strength <= 0;
    end else begin
        if (state) begin
            each_I <= i_mem_in;
            if (neuron_index == 7'h7f) begin
                first_pass <= 0;
                I_out <= i_mem_in;
                synaptic_strength <= impulse_mem_in;
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


