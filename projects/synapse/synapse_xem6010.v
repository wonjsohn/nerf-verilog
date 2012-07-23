`timescale 1ns / 1ps

module synapse_xem6010(
	input  wire [7:0]  hi_in,
	output wire [1:0]  hi_out,
	inout  wire [15:0] hi_inout,
	inout  wire        hi_aa,

	output wire        i2c_sda,
	output wire        i2c_scl,
	output wire        hi_muxsel,
	input  wire        clk1,
	input  wire        clk2,
	
	output wire [7:0]  led
   );
   
    parameter NN = 8;
		
    // *** Dump all the declarations here:
    wire         ti_clk;
    wire [30:0]  ok1;
    wire [16:0]  ok2;   
    wire reset_global;

    // *** Target interface bus:
    assign i2c_sda = 1'bz;
    assign i2c_scl = 1'bz;
    assign hi_muxsel = 1'b0;

    // *** Triggered input from Python
   
    
    reg [31:0] delay_cnt_max;
    always @(posedge ep50trig[7] or posedge reset_global)
    begin
        if (reset_global)
            delay_cnt_max <= delay_cnt_max;
        else
            delay_cnt_max <= {ep02wire, ep01wire};  //firing rate
    end        

    reg [31:0] I;
    always @(posedge ep50trig[6] or posedge reset_global)
    begin
        if (reset_global)
            I <= 32'd10240;
        else
            I <= {ep02wire, ep01wire};  //firing rate
    end      

    
    // *** Deriving clocks from on-board clk1:
    wire neuron_clk;
    wire sim_clk;

    gen_clk useful_clocks
    (   .rawclk(clk1), 
        .half_cnt(delay_cnt_max), 
        .clk_out1(neuron_clk), 
        .clk_out2(sim_clk), 
        .clk_out3(),
        .int_neuron_cnt_out() );
                
    wire [36:0] casr_out;
    wire [42:0] lfsr_out;
    wire [31:0] random_out;
    rng rng_0(
            .clk1(neuron_clk),
            .clk2(neuron_clk),
            .reset(reset_global),
            .out(random_out),
            
            .lfsr(lfsr_out),
            .casr(casr_out)
    );
    
    wire enable_noisy_I;

    
    wire [31:0] noisy_I;
    //assign noisy_I = enable_noisy_I ? {I[31:10], random_out[9:0]} : I;
    assign noisy_I = {I[31:10], random_out[9:0]};
    
    wire [31:0] v;
    wire spike;
    wire each_spike;
    wire [127:0] population;
    izneuron neuron_0(
                .clk(neuron_clk),
                .reset(reset_global),
                .I_in(noisy_I),
                .v_out(v),
                .spike(spike),
                .each_spike(each_spike),
                
                .population(population)
    );
    
    wire [31:0] I_synapse;
    wire [31:0] each_I_synapse;
    wire each_spike_2;
    
    synapse synapse_0(
                .clk(neuron_clk),
                .reset(reset_global),
                .spike_in(each_spike),
                .postsynaptic_spike_in(each_spike_2),
                .I_out(I_synapse),  // updates once per population (scaling factor 1024) 
                .each_I(each_I_synapse) // updates on each synapse
    );
    
    wire [31:0] spike_count;
    spike_counter count_0(
                        .clk(neuron_clk),
                        .reset(reset_global),
                        .spike_in(each_spike),
                        .spike_count(spike_count)
    );
    
    
    wire [31:0] v_2;
    wire spike_2;

    wire [127:0] population_2;
    izneuron neuron_1(
                .clk(neuron_clk),
                .reset(reset_global),
                .I_in(each_I_synapse),
                .v_out(v_2),
                .spike(spike_2),
                .each_spike(each_spike_2),
                
                .population(population_2)
    );

    wire [31:0] spike_count_2;
    spike_counter count_1(
                        .clk(neuron_clk),
                        .reset(reset_global),
                        .spike_in(each_spike_2),
                        .spike_count(spike_count_2)
    );
    
    assign led[5:2] = 7'b1111111;
    assign led[0] = ~spike;
    assign led[1] = ~each_spike;
    
    assign led[6] = ~each_spike_2;
    assign led[7] = ~spike_2;

    // *** OpalKelly XEM interface
    okHost okHI(
        .hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .hi_aa(hi_aa), .ti_clk(ti_clk),
        .ok1(ok1), .ok2(ok2));

    wire [21*17-1:0]  ok2x;
    okWireOR # (.N(21)) wireOR (ok2, ok2x);
    wire [15:0]  ep00wire, ep01wire, ep02wire;
    assign reset_global = ep00wire[0];
    
    assign enable_noisy_i = ep00wire[15];
    
    okWireIn     wi00 (.ok1(ok1),                           .ep_addr(8'h00), .ep_dataout(ep00wire));
    okWireIn     wi01 (.ok1(ok1),                           .ep_addr(8'h01), .ep_dataout(ep01wire));
    okWireIn     wi02 (.ok1(ok1),                           .ep_addr(8'h02), .ep_dataout(ep02wire));
    
    okWireOut    wo20 (.ep_datain(v[15:0]), .ok1(ok1), .ok2(ok2x[  0*17 +: 17 ]), .ep_addr(8'h20) );
    okWireOut    wo21 (.ep_datain(v[31:16]), .ok1(ok1), .ok2(ok2x[  1*17 +: 17 ]), .ep_addr(8'h21) );
    
    okWireOut    wo30 (.ep_datain(population[15:0]), .ok1(ok1), .ok2(ok2x[  2*17 +: 17 ]), .ep_addr(8'h30) );
    okWireOut    wo31 (.ep_datain(population[31:16]), .ok1(ok1), .ok2(ok2x[  3*17 +: 17 ]), .ep_addr(8'h31) );
    okWireOut    wo32 (.ep_datain(population[47:32]), .ok1(ok1), .ok2(ok2x[  4*17 +: 17 ]), .ep_addr(8'h32) );
    okWireOut    wo33 (.ep_datain(population[63:48]), .ok1(ok1), .ok2(ok2x[  6*17 +: 17 ]), .ep_addr(8'h33) );
    okWireOut    wo34 (.ep_datain(population[79:64]), .ok1(ok1), .ok2(ok2x[  7*17 +: 17 ]), .ep_addr(8'h34) );
    okWireOut    wo35 (.ep_datain(population[95:80]), .ok1(ok1), .ok2(ok2x[  8*17 +: 17 ]), .ep_addr(8'h35) );
    okWireOut    wo36 (.ep_datain(population[111:96]), .ok1(ok1), .ok2(ok2x[  9*17 +: 17 ]), .ep_addr(8'h36) );
    okWireOut    wo37 (.ep_datain(population[127:112]), .ok1(ok1), .ok2(ok2x[  10*17 +: 17 ]), .ep_addr(8'h37) );
    
    okWireOut    wo22 (.ep_datain(I_synapse[15:0]), .ok1(ok1), .ok2(ok2x[  11*17 +: 17 ]), .ep_addr(8'h22) );
    okWireOut    wo23 (.ep_datain(I_synapse[31:16]), .ok1(ok1), .ok2(ok2x[  12*17 +: 17 ]), .ep_addr(8'h23) );

    okWireOut    wo24 (.ep_datain(v_2[15:0]), .ok1(ok1), .ok2(ok2x[  13*17 +: 17 ]), .ep_addr(8'h24) );
    okWireOut    wo25 (.ep_datain(v_2[31:16]), .ok1(ok1), .ok2(ok2x[  14*17 +: 17 ]), .ep_addr(8'h25) );

    okWireOut    wo26 (.ep_datain(spike_count[15:0]), .ok1(ok1), .ok2(ok2x[  17*17 +: 17 ]), .ep_addr(8'h26) );
    okWireOut    wo27 (.ep_datain(spike_count[31:16]), .ok1(ok1), .ok2(ok2x[  18*17 +: 17 ]), .ep_addr(8'h27) );
    
    okWireOut    wo28 (.ep_datain(spike_count_2[15:0]), .ok1(ok1), .ok2(ok2x[  19*17 +: 17 ]), .ep_addr(8'h28) );
    okWireOut    wo29 (.ep_datain(spike_count_2[31:16]), .ok1(ok1), .ok2(ok2x[  20*17 +: 17 ]), .ep_addr(8'h29) );
    
    okWireOut    wo38 (.ep_datain(population_2[15:0]), .ok1(ok1), .ok2(ok2x[  15*17 +: 17 ]), .ep_addr(8'h38) );
    okWireOut    wo39 (.ep_datain(population_2[31:16]), .ok1(ok1), .ok2(ok2x[  16*17 +: 17 ]), .ep_addr(8'h39) );
    
    
    wire [15:0] ep50trig;
    okTriggerIn ep50 (.ok1(ok1),  .ep_addr(8'h50), .ep_clk(clk1), .ep_trigger(ep50trig));
endmodule