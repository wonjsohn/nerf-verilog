`timescale 1ns / 1ps
// hi@siri.sh
// Spartan 6 Block RAM project

module block_ram_test(
	input  wire [7:0]  hi_in,
	output wire [1:0]  hi_out,
	inout  wire [15:0] hi_inout,
	inout  wire        hi_aa,

	output wire        i2c_sda,
	output wire        i2c_scl,
	output wire        hi_muxsel,

	input  wire        clk1,
	output wire [7:0]  led
	);

// Target interface bus:
wire         ti_clk;
wire [30:0]  ok1;
wire [16:0]  ok2;

assign i2c_sda = 1'bz;
assign i2c_scl = 1'bz;
assign hi_muxsel = 1'b0;

// Endpoint connections:
wire [15:0]  ep00wire;
wire [15:0]  rcv_errors;
   


// Pipe In
wire        pipe_in_write;
wire        pipe_in_ready;
wire [15:0] pipe_in_data;

wire pipe_out_read;
wire [15:0] pipe_out_data;

wire [15:0] WireIn10;
wire [15:0] TrigIn50;
wire [15:0] TrigIn41;
wire [15:0] TrigOut60;

wire reset;
assign reset        = WireIn10[0];


   reg [31:0] delay_cnt_max;
    always @(posedge TrigIn50[7] or posedge reset)
    begin
        if (reset)
            delay_cnt_max <= delay_cnt_max;
        else
            delay_cnt_max <= {ep02wire, ep01wire};  //firing rate
    end        

wire pop_clk;    
    gen_clk useful_clocks
    (   .rawclk(clk1), 
        .half_cnt(delay_cnt_max), 
        .clk_out1(), 
        .clk_out2(pop_clk), 
        .clk_out3(),
        .int_neuron_cnt_out() );
                
    


wire [31:0] wave;
wire [10:0] pipe_addr;
wire [10:1] pop_addr;



 waveform_from_pipe_bram_16s    generator(
                                .reset(reset),
                                .pipe_clk(ti_clk),
                                .pipe_in_write(pipe_in_write),
                                .pipe_in_data(pipe_in_data),
                                .pipe_out_read(pipe_out_read),
                                .pipe_out_data(pipe_out_data),
                                .pop_clk(pop_clk),
                                .wave(wave)

    );


assign led = wave[7:0];
                                          
// Instantiate the okHost and connect endpoints.
// Host interface
okHost okHI(
	.hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .hi_aa(hi_aa), .ti_clk(ti_clk),
	.ok1(ok1), .ok2(ok2));

wire [17*5-1:0]  ok2x;

okWireOR # (.N(5)) wireOR (ok2, ok2x);
    
wire [15:0]  ep01wire, ep02wire;
okWireIn     wi00 (.ok1(ok1),                           .ep_addr(8'h00), .ep_dataout(ep00wire));
okWireIn     wi01 (.ok1(ok1),                           .ep_addr(8'h01), .ep_dataout(ep01wire));
okWireIn     wi02 (.ok1(ok1),                           .ep_addr(8'h02), .ep_dataout(ep02wire));
    
okWireIn     ep10 (.ok1(ok1),                           .ep_addr(8'h10), .ep_dataout(WireIn10));
    okWireOut    wo20 (.ep_datain(wave[15:0]), .ok1(ok1), .ok2(ok2x[  3*17 +: 17 ]), .ep_addr(8'h20) );
    okWireOut    wo21 (.ep_datain(wave[31:16]), .ok1(ok1), .ok2(ok2x[  4*17 +: 17 ]), .ep_addr(8'h21) );
    
okTriggerIn  ep50 (.ok1(ok1),                           .ep_addr(8'h50), .ep_clk(clk1), .ep_trigger(TrigIn50));

okTriggerIn  ep41 (.ok1(ok1),                           .ep_addr(8'h41), .ep_clk(ti_clk), .ep_trigger(TrigIn41));
okTriggerOut ep60 (.ok1(ok1), .ok2(ok2x[ 0*17 +: 17 ]), .ep_addr(8'h60), .ep_clk(clk1), .ep_trigger(TrigOut60));
okPipeIn     ep80 (.ok1(ok1), .ok2(ok2x[ 1*17 +: 17 ]), .ep_addr(8'h80), .ep_write(pipe_in_write), .ep_dataout(pipe_in_data));
okPipeOut    epA0 (.ok1(ok1), .ok2(ok2x[ 2*17 +: 17 ]), .ep_addr(8'ha0), .ep_read(pipe_out_read), .ep_datain(pipe_out_data));
endmodule


