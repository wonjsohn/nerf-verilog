`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:28:53 03/18/2016 
// Design Name: 
// Module Name:    fifo_2048 
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
module fifo_long(
              input wire reset,
				  input wire pipe_clk,
				  input wire pipe_in_write,
				  input wire [15:0] pipe_in_data,
				  input wire is_from_trigger,
				  input wire [31:0] data_from_trig,	// data from one of ep50 channel
				  input wire pipe_out_read,
				  output wire [15:0] pipe_out_data,
				  input wire pop_clk,
				  output wire [31:0] wave
    );


assign wave = (is_from_trigger)? data_from_trig : wave_temp  ;

wire fifo_en;
wire n_fifo_em;
wire fifofull1;
wire fifofull2;

// Pipe in functionality
reg [15:0] pipe_addr;
always @(posedge pipe_clk) begin
	if (reset == 1'b1) begin
		pipe_addr <= 11'd0;
	end else begin
		if (pipe_in_write == 1'b1 || pipe_out_read == 1'b1)
			pipe_addr <= pipe_addr + 1;
	end
end

// Wave out functionality
reg [15:1] pop_addr;
always @ (posedge pipe_clk) begin
    if (reset == 1'b1) begin
        pop_addr <= 10'd0;
    end else begin
        pop_addr <= pop_addr + 1;
    end
end


//Circuit behavior
assign fifo_en = ~n_fifo_em;
	

wire [31:0] wave_temp;
fifo_16s fifo16 (
  .rst(reset),   // input rst
  .wr_clk(pipe_clk),   // input wr_clk
  .rd_clk(pop_clk),   // input rd_clk
  .din(pipe_in_data), //input [15 : 0] din;
  .wr_en(pipe_in_write),  // input wr_en
  .rd_en(fifo_en),          // input rd_en
  .dout(wave_temp), //[31 : 0] dout;
  .full(fifofull1),  // output full
  .empty(n_fifo_em), // output empty
  .wr_data_count() //output [14 : 0] wr_data_count;
);





endmodule
