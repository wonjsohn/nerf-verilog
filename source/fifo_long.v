`timescale 1ns / 1ps
`default_nettype none
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
				  output wire [31:0] wave,
				  output wire almostfifofull1,
				  output wire n_fifo_almost_em
    );


assign wave = (is_from_trigger)? data_from_trig : wave_temp  ;

wire fifo_rden;
wire fifo_wren;
wire n_fifo_em;
wire fifofull1;


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
assign fifo_rden = ~n_fifo_almost_em;
	
/**
 Full Flag: When asserted, this signal indicates that the FIFO is full.
Write requests are ignored when the FIFO is full, initiating a write
when the FIFO is full is not destructive to the contents of the FIFO.

**/
wire [31:0] wave_temp;
fifo_16seconds fifo32s (
  .rst(reset),   // input rst
  .wr_clk(pipe_clk),   // input wr_clk
  .rd_clk(pop_clk),   // input rd_clk
  .din(pipe_in_data), //input [15 : 0] din;
  .wr_en(pipe_in_write),  // input wr_en
  .rd_en(fifo_rden),          // input rd_en
  .dout(wave_temp), //[31 : 0] dout;
  .full(fifofull1),  // output full
  .almost_full(almostfifofull1),  // output full
  .wr_ack(),
  .overflow(),
  .empty(n_fifo_em), // output empty
  .almost_empty(n_fifo_almost_em),
  .valid(),
  .underflow(),
  .rd_data_count(), //output [14 : 0] rd_data_count;
  .wr_data_count(), //output [15 : 0] wr_data_count;
  .prog_full(),
  .prog_empty()
);





endmodule
