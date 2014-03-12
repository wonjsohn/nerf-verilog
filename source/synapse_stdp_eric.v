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
module synapse_stdp_eric(
                input wire clk,
                input wire reset,
                input wire spike_in,
                input wire [31:0] lut2_index,
                input wire postsynaptic_spike_in,
                
                
                output reg signed [31:0] I_out,  // updates once per population (scaling factor 1024) 
                output reg signed [31:0] each_I, // updates on each synapse
                
                output reg [31:0] synaptic_strength, //synaptic weight
                output wire [31:0] delta_w_ltp,            //  
                
                input wire [31:0] base_strength, // baseline synaptic strength
                
                input wire [31:0] ltp_scale,              // long term potentiation delta (stdp)
                input wire [31:0] ltd_scale,              // long term depression delta   (stdp)
                input wire [31:0] p_delta           // probability of synaptic decay event
    );

// COMPUTE EACH SYNAPTIC CURRENT /////////////////////////////////////////////////////////////////
//wire [31:0] ltp;
//assign ltp = 32'd10;
//wire [31:0] ltd;
//assign ltd = 32'd5;
//wire [31:0] p_delta;
//assign p_delta= 32'd0;

wire [31:0] impulse;

reg spike;
reg postsynaptic_spike;
//assign impulse = spike ? 31'd1024 : 0; // 1(unit?) current per spike
//assign impulse = spike ? 31'd10240 : 0; // 10(unit?) c urrent per spike
assign impulse = spike ? impulse_mem_in : 0;  // synaptic strength

wire [31:0] i_mem; // I_out
wire [31:0] i_mem_in;

//i_mem updates every neuron_clk
assign i_mem_in = first_pass ? 0 : i_mem - (i_mem >>> 3) + impulse; //I = 0.875*I + impulse  (current decay+impulse)  

wire [31:0] spike_history_mem;
wire [31:0] spike_history_mem_in;

assign spike_history_mem_in = first_pass ? 0 : {spike_history_mem[30:0], spike};

//wire [31:0] delta_w_ltp;

//assign delta_w_ltp = postsynaptic_spike ? ((spike_history_mem == 32'd0) ? 0 : ltp) : 0 ; // make a LookupTabe STDP curve & check last spike only. 
wire [31:0] delta_w_ltp_pre;
//assign delta_w_ltp = delta_w_ltp_pre*ltp_scale;
unsigned_mult32 multltp(.out(delta_w_ltp), .a(delta_w_ltp_pre), .b(ltp_scale));
assign delta_w_ltp_pre = postsynaptic_spike ? 
                           ((spike_history_mem[31]? 1:0)+
                                (spike_history_mem[30]? 2 :0) +
                                (spike_history_mem[29]?3:0)+
                                (spike_history_mem[28]?4:0)+
                                (spike_history_mem[27]?5:0)+
                                (spike_history_mem[26]?6:0)+
                                (spike_history_mem[25]?7:0)+
                                (spike_history_mem[24]?8:0)+
                                (spike_history_mem[23]?9:0)+
                                (spike_history_mem[22]?10:0)+
                                (spike_history_mem[21]?11:0)+
                                (spike_history_mem[20]?12:0)+
                                (spike_history_mem[19]?13:0)+
                                (spike_history_mem[18]?14:0)+
                                (spike_history_mem[17]?15:0)+
                                (spike_history_mem[16]?16:0)+
                                (spike_history_mem[15]?17:0)+
                                (spike_history_mem[14]?18:0)+
                                (spike_history_mem[13]?19:0)+
                                (spike_history_mem[12]?20:0)+
                                (spike_history_mem[11]?21:0)+
                                (spike_history_mem[10]?22:0)+
                                (spike_history_mem[9]?23:0)+
                                (spike_history_mem[8]?24:0)+
                                (spike_history_mem[7]?25:0)+
                                (spike_history_mem[6]?26:0)+
                                (spike_history_mem[5]?27:0)+
                                (spike_history_mem[4]?28:0)+
                                (spike_history_mem[3]?29:0)+
                                (spike_history_mem[2]?30:0)+
                                (spike_history_mem[1]?31:0)) : 0;

//lut2_index0= spike_history_mem[31]? 0 :  ; // lut2
//lut2_index1= spike_history_mem[30]? 1 :  ; // lut2
//lut2_index2= spike_history_mem[29]? 2 :  ; // lut2
//lut2_index3= spike_history_mem[28]? 3 :  ; // lut2
//lut2_index4= spike_history_mem[27]? 4 :  ; // lut2
//lut2_index5= spike_history_mem[26]? 5 :  ; // lut2
//lut2_index6= spike_history_mem[25]? 6 :  ; // lut2
//lut2_index7= spike_history_mem[24]? 7 :  ; // lut2
//lut2_index8= spike_history_mem[23]? 8 :  ; // lut2
//lut2_index9= spike_history_mem[22]? 9 :  ; // lut2
//lut2_index10= spike_history_mem[21]? 10 :  ; // lut2
//lut2_index11= spike_history_mem[20]? 11 :  ; // lut2
//lut2_index12= spike_history_mem[19]? 12 :  ; // lut2
//lut2_index13= spike_history_mem[18]? 13 :  ; // lut2
//lut2_index14= spike_history_mem[17]? 14 :  ; // lut2
//lut2_index15= spike_history_mem[16]? 15 :  ; // lut2
//lut2_index16= spike_history_mem[15]? 16 :  ; // lut2
//lut2_index17= spike_history_mem[14]? 17 :  ; // lut2
//lut2_index18= spike_history_mem[13]? 18 :  ; // lut2
//lut2_index19= spike_history_mem[12]? 19 :  ; // lut2
//lut2_index20= spike_history_mem[11]? 20 :  ; // lut2
//lut2_index21= spike_history_mem[10]? 21 :  ; // lut2
//lut2_index22= spike_history_mem[9]? 22 :  ; // lut2
//lut2_index23= spike_history_mem[8]? 23 :  ; // lut2
//lut2_index24= spike_history_mem[7]? 24 :  ; // lut2
//lut2_index25= spike_history_mem[6]? 25 :  ; // lut2
//lut2_index26= spike_history_mem[5]? 26 :  ; // lut2
//lut2_index27= spike_history_mem[4]? 27 :  ; // lut2
//lut2_index28= spike_history_mem[3]? 28 :  ; // lut2
//lut2_index29= spike_history_mem[2]? 29 :  ; // lut2
//lut2_index30= spike_history_mem[1]? 30 :  ; // lut2
//lut2_index31= spike_history_mem[0]? 31 :  ; // lut2



wire [31:0] ps_spike_history_mem;
wire [31:0] ps_spike_history_mem_in;

assign ps_spike_history_mem_in = first_pass ? 0 : {ps_spike_history_mem[30:0], postsynaptic_spike};

wire [31:0] delta_w_ltd;

//assign delta_w_ltd = spike ? ((ps_spike_history_mem == 32'd0) ? 0 : ltd) : 0 ; // make a LookupTable STDP curve
wire [31:0] delta_w_ltd_pre;
//assign delta_w_ltd = delta_w_ltd_pre*ltd_scale;
unsigned_mult32 multltd(.out(delta_w_ltd), .a(delta_w_ltd_pre), .b(ltd_scale));
assign delta_w_ltd_pre = spike ? 
                                ((ps_spike_history_mem[31]? 1:0)+
                                (ps_spike_history_mem[30]? 2 :0) +
                                (ps_spike_history_mem[29]?3:0)+
                                (ps_spike_history_mem[28]?4:0)+
                                (ps_spike_history_mem[27]?5:0)+
                                (ps_spike_history_mem[26]?6:0)+
                                (ps_spike_history_mem[25]?7:0)+
                                (ps_spike_history_mem[24]?8:0)+
                                (ps_spike_history_mem[23]?9:0)+
                                (ps_spike_history_mem[22]?10:0)+
                                (ps_spike_history_mem[21]?11:0)+
                                (ps_spike_history_mem[20]?12:0)+
                                (ps_spike_history_mem[19]?13:0)+
                                (ps_spike_history_mem[18]?14:0)+
                                (ps_spike_history_mem[17]?15:0)+
                                (ps_spike_history_mem[16]?16:0)+
                                (ps_spike_history_mem[15]?17:0)+
                                (ps_spike_history_mem[14]?18:0)+
                                (ps_spike_history_mem[13]?19:0)+
                                (ps_spike_history_mem[12]?20:0)+
                                (ps_spike_history_mem[11]?21:0)+
                                (ps_spike_history_mem[10]?22:0)+
                                (ps_spike_history_mem[9]?23:0)+
                                (ps_spike_history_mem[8]?24:0)+
                                (ps_spike_history_mem[7]?25:0)+
                                (ps_spike_history_mem[6]?26:0)+
                                (ps_spike_history_mem[5]?27:0)+
                                (ps_spike_history_mem[4]?28:0)+
                                (ps_spike_history_mem[3]?29:0)+
                                (ps_spike_history_mem[2]?30:0)+
                                (ps_spike_history_mem[1]?31:0)) : 0;
                        
wire [31:0] random_out;
wire [31:0] impulse_decay;

assign impulse_decay = (random_out <= p_delta) ? impulse_mem >>> 7 : 0; // not used.
 

 
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
wire [31:0] lut_out32_F0;
assign lut_out32_F0 = {27'b0, lut_out}; 
//wire [31:0] impulse_bcm;
//reg [31:0] impulse_bcm;

//assign impulse_mem_in = first_pass ? 32'd10240 : impulse_mem+delta_w+delta_w_ltd-impulse_decay;
//assign impulse_stdp = first_pass ? 32'd10240 : impulse_mem+delta_w+delta_w_ltd-impulse_decay;
//assign impulse_stdp = first_pass ? base_strength : impulse_mem+delta_w-delta_w_ltd-impulse_decay;  

assign impulse_stdp = first_pass ? base_strength : impulse_mem - (impulse_mem >>> 13) + delta_w_ltp - delta_w_ltd; //-synaptic strength_decay; // small decay. modified by eric

//assign impulse_mem_in = impulse_bcm;
//assign impulse_mem_in = impulse_mem;

assign impulse_mem_in = (impulse_stdp >= base_strength)? impulse_stdp: base_strength;  // set minimum synaptic strength 
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
       //lut_out32 <= 0;
    end else begin
        if (state) begin
            each_I <= i_mem_in;
            if (neuron_index == 7'h7f) begin  //every 128 neuron_clk
                first_pass <= 0;
                I_out <= i_mem_in;
                synaptic_strength <= impulse_mem_in;
               // lut_out32 <= lut_out32_F0;
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
    
    
    // STDP LUT (not used)
    wire [4:0] lut_out;
    wire [4:0] lut2_index5;
    assign lut2_index5 = lut2_index[4:0];
   blk_mem_gen_LUT2 stdp_manual(
  .clka(~clk),  //input clka;
  .addra(lut2_index5), //input [4 : 0] addra;
  .douta(lut_out)  //output [4 : 0] douta;
);





    
endmodule


