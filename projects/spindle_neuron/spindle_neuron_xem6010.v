`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Creator: C. Minos Niu
// 
// Module Name:    
// Project Name: 
// Target Devices: XEM6010 - OpalKelly
// Design properties: xc6slx150-2fgg484
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module spindle_neuron_xem6010(
	input  wire [7:0]  hi_in,
	output wire [1:0]  hi_out,
	inout  wire [15:0] hi_inout,
	inout  wire        hi_aa,

	output wire        i2c_sda,
	output wire        i2c_scl,
	output wire        hi_muxsel,
	input  wire        clk1,
	input  wire        clk2,
	
	output wire [7:0]  led,
    output wire  Ia_spike,
    output wire II_spike,
    output wire clk_out
   );
   
		parameter NN = 8;
		
    // *** Dump all the declarations here:
    wire         ti_clk;
    wire [30:0]  ok1;
    wire [16:0]  ok2;   
    wire [15:0]  ep00wire, ep01wire, ep02wire, ep50trig, ep20wire, ep21wire, ep22wire, ep23wire;
    wire [15:0]  ep24wire, ep25wire, ep26wire, ep27wire, ep28wire, ep29wire, ep30wire, ep31wire;
    wire reset_global, reset_sim;
    wire        is_pipe_being_written, is_lce_valid;

    wire [31:0] current_lce;
    wire [15:0] lce_from_py;

    wire [31:0] Ia_fr, x_0, x_1, II_fr;
    
    reg [17:0] delay_cnt, delay_cnt_max;
    reg [31:0] gamma_dyn;
    
    reg test_clk;
    reg [15:0] rawspikes;
	 wire pipe_out_read;
    	wire sim_clk, spindle_clk;
    // *** Target interface bus:
    assign i2c_sda = 1'bz;
    assign i2c_scl = 1'bz;
    assign hi_muxsel = 1'b0;

    // *** Endpoint connections:
    assign ep20wire = Ia_fr[15:0];
    assign ep21wire = Ia_fr[31:16];
  
    assign ep22wire = current_lce[15:0];
    assign ep23wire = current_lce[31:16];
    assign ep24wire = v1[15:0];
    assign ep25wire = {16'b0, v1[17:16]};
    assign ep26wire = x_1[15:0];
    assign ep27wire = x_1[31:16];
    assign ep28wire = spike_count_out[15:0];
    assign ep29wire = spike_count_out[31:16];
    assign ep30wire = II_fr[15:0];
    assign ep31wire = II_fr[31:16];
    
    // *** Buttons, physical on XEM3010, software on XEM3050 & XEM6010
    // *** Reset & Enable signals
    assign reset_global = ep00wire[0];
    assign reset_sim = ep00wire[1];
    //assign enable_sim = is_lce_valid;
        
    // ** LEDs
    assign led[4:2] = 3'b111;
    assign led[0] = 1'b1;
    assign led[1] = 1'b1;
    assign led[5] = ~Ia_spike;
    assign led[6] = ~II_spike;
    assign led[7] = ~reset_global;
    //assign led[6] = ~execute; // When execute==1, led lits

    
    // *** Adjust clk1 to test_clk
    always @ (posedge clk1) begin
//        if (reset_global) begin
//            delay_cnt <= 0;
//            test_clk <=
//        end
        if (delay_cnt < delay_cnt_max) begin
            test_clk <= test_clk;
            delay_cnt <= delay_cnt + 1;
        end
        else begin
            test_clk <= ~test_clk;
            delay_cnt <= 0;
        end
    end
    assign clk_out = test_clk;
    // *** Triggered input from Python
    always @(posedge ep50trig[7] or posedge reset_global)
    begin
        if (reset_global)
            delay_cnt_max <= delay_cnt_max;
        else
            delay_cnt_max <= {2'b00, ep01wire};  //firing rate
    end
    
    always @(posedge ep50trig[4] or posedge reset_global)
    begin
        if (reset_global)
            gamma_dyn <= 32'h42A0_0000; // gamma_dyn reset to 80
        else
            gamma_dyn <= {ep02wire, ep01wire};  //firing rate
    end    
    
    reg [31:0] BDAMP_1, BDAMP_2, BDAMP_chain, GI, GII;
	//assign BDAMP_1 = 32'h3E71_4120;//bag 1 BDAMP = 0.2356	 
	//assign BDAMP_2 = 32'h3D14_4674; //bag 2 BDAMP = 0.0362
    //assign BDAMP_chain = 32'h3C58_44D0;// chain BDAMP = 0.0132   
    always @(posedge ep50trig[15] or posedge reset_global)
    begin
        if (reset_global)
            BDAMP_1 <= 32'h3E71_4120; // bag 1 BDAMP reset to 0.2356
        else
            BDAMP_1 <= {ep02wire, ep01wire};  //firing rate
    end
    always @(posedge ep50trig[14] or posedge reset_global)
    begin
        if (reset_global)
            BDAMP_2 <= 32'h3D14_4674; // bag 2 BDAMP reset to 0.0362
        else
            BDAMP_2 <= {ep02wire, ep01wire};  //firing rate
    end    
    always @(posedge ep50trig[13] or posedge reset_global)
    begin
        if (reset_global)
            BDAMP_chain <= 32'h3C58_44D0; // chain BDAMP reset to 0.0132 
        else
            BDAMP_chain <= {ep02wire, ep01wire};  //firing rate
    end
    //assign GI_0	    = 32'h469C4000;    
    always @(posedge ep50trig[12] or posedge reset_global)
    begin
        if (reset_global)
            GI <= 32'h469C4000; // GI reset to 20000
        else
            GI <= {ep02wire, ep01wire};  //firing rate
    end    
    //assign GII = 32'h45E2_9000; //7250
    always @(posedge ep50trig[11] or posedge reset_global)
    begin
        if (reset_global)
            GII <= 32'h45E2_9000; // GII reset to 7250
        else
            GII <= {ep02wire, ep01wire};  //firing rate
    end        
    // *** Generating waveform to stimulate the spindle
//    waveform_from_lut get_muscle_lce
//    (   .clk(test_clk),
//        .reset(reset_global),
//        .value(current_lce)
//    );

	waveform_from_pipe gen(	
        .ti_clk(ti_clk),
        .reset(reset_global),
        .repop(reset_sim),
        .feed_data_valid(is_pipe_being_written),
        .feed_data(lce_from_py),
        .current_element(current_lce),
        .test_clk(sim_clk),
        .done_feeding(is_lce_valid)
    );        

    // *** Spindle: current_lce => Ia_fr
    spindle bag1_bag2_chain(	.gamma_dyn(gamma_dyn), // 32'h42A0_0000
                        .gamma_sta(gamma_dyn),
					.lce(current_lce),
					.clk(spindle_clk),
					.reset(reset_sim),
					.out0(x_0),
                    .out1(x_1),
                    .out2(II_fr),
                    .out3(Ia_fr),
                    .BDAMP_1(BDAMP_1),
                    .BDAMP_2(BDAMP_2),
                    .BDAMP_chain(BDAMP_chain),
                    .GI(GI),
                    .GII(GII)
		);

    // *** Izhikevich: Ia_fr => spikes
        // *** Convert float_fr to int_I1
	/*
    wire [31:0] float_I1;
    wire [17:0] int_I1;

	mult pps_to_I( .x(Ia_fr), .y(32'h438C_E666), .out(float_I1));
	floor float_to_int( .in(float_I1), .out(int_I1) );
    */
    spindle_neuron Ia_neuron(	.pps(Ia_fr),
								.clk(sim_clk),
                                .reset(reset_sim),
								.spike(Ia_spike)
    );
   spindle_neuron II_neuron(	.pps(II_fr),
								.clk(sim_clk),
                                .reset(reset_sim),
								.spike(II_spike)
    );
    // *** Create 1 Izh-neuron
    
	wire [3:0] a, b, tau;
	wire [17:0] c, d, v1, u1, s1;
	assign a = 3 ;  // bits for shifting, a = 0.125
	assign b =  2 ;  // bits for shifting, b = 0.25
	assign c =  18'sh3_599A ; // -0.65  = dec2hex(1+bitcmp(ceil(0.65 * hex2dec('ffff')),18)) = 3599A
	assign d =  18'sh0_147A ; // 0.08 = dec2hex(floor(0.08 * hex2dec('ffff'))) = 147A
	assign tau = 4'h2;
	
	reg [NN+2:0] neuronCounter;
	wire [NN:0] neuronIndex;
	reg firstNeuron;
	reg [31:0] spike_count, spike_count_out;
	always @ (posedge test_clk)
	begin	
		neuronCounter <= neuronCounter + 1'b1;
//		if (spike)
//			spike_count <= spike_count + 1;
		if (firstNeuron)
		begin
			spike_count_out <= spike_count;
			spike_count <= 0;
		end
	end
			
	
	always @ (negedge test_clk)
	begin
		firstNeuron <= (neuronIndex == 0);
	end
	assign sim_clk = (neuronCounter == 0) ? 1 : 0;
    //assign spindle_clk = sim_clk;

    assign spindle_clk = (neuronIndex == 0) ? 1 : 
                        (neuronIndex == 8'd85) ? 1 :
                        (neuronIndex == 8'd170) ? 1 : 0;
    
	wire [1:0] state;
	assign state = neuronCounter[1:0];
	assign neuronIndex = neuronCounter[NN+2:2];
	
	wire state1, state2, state3, state4;
	assign state1 = (state == 2'h0);
	assign state2 = (state == 2'h1);
	assign state3 = (state == 2'h2);
	assign state4 = (state == 2'h3);
	
	wire neuronWriteCount, readClock, neuronWriteEnable, dataValid;
	
	assign neuronWriteCount = state1;	//increment neuronID (ram address)
	assign readClock = state2;				//read RAM
	assign neuronWriteEnable = state4; //(state3 | state4);	//write RAM
	assign dataValid = firstNeuron;  //(neuronIndex ==0) & state2; //(neuronIndex == 1);   //slight delay of positive edge to allow latch set-up times
		
	//Iz_neuron #(.NN(NN),.DELAY(10)) neuIa(v1,s1, a,b,c,d, int_I1[17:0], test_clk, reset_sim, neuronIndex, neuronWriteEnable, readClock, tau, spike);
//	always @(negedge neuronIndex[0]) rawspikes <= {1'b0, neuronIndex[NN:2], spike, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
    // Instantiate the okHost and connect endpoints.
    // Host interface
      
    okHost okHI(
        .hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .hi_aa(hi_aa), .ti_clk(ti_clk),
        .ok1(ok1), .ok2(ok2));

    wire [17*14-1:0]  ok2x;
    okWireOR # (.N(14)) wireOR (ok2, ok2x);
    okWireIn     wi00 (.ok1(ok1),                           .ep_addr(8'h00), .ep_dataout(ep00wire));
    okWireIn     wi01 (.ok1(ok1),                           .ep_addr(8'h01), .ep_dataout(ep01wire));
    okWireIn     wi02 (.ok1(ok1),                           .ep_addr(8'h02), .ep_dataout(ep02wire));

    okWireOut    wo20 (.ok1(ok1), .ok2(ok2x[ 0*17 +: 17 ]), .ep_addr(8'h20), .ep_datain(ep20wire));
    okWireOut    wo21 (.ok1(ok1), .ok2(ok2x[ 1*17 +: 17 ]), .ep_addr(8'h21), .ep_datain(ep21wire));
    okWireOut    wo22 (.ok1(ok1), .ok2(ok2x[ 2*17 +: 17 ]), .ep_addr(8'h22), .ep_datain(ep22wire));
    okWireOut    wo23 (.ok1(ok1), .ok2(ok2x[ 3*17 +: 17 ]), .ep_addr(8'h23), .ep_datain(ep23wire));
    okWireOut    wo24 (.ok1(ok1), .ok2(ok2x[ 4*17 +: 17 ]), .ep_addr(8'h24), .ep_datain(ep24wire));
    okWireOut    wo25 (.ok1(ok1), .ok2(ok2x[ 5*17 +: 17 ]), .ep_addr(8'h25), .ep_datain(ep25wire));
    okWireOut    wo26 (.ok1(ok1), .ok2(ok2x[ 6*17 +: 17 ]), .ep_addr(8'h26), .ep_datain(ep26wire));
    okWireOut    wo27 (.ok1(ok1), .ok2(ok2x[ 7*17 +: 17 ]), .ep_addr(8'h27), .ep_datain(ep27wire));
    okWireOut    wo28 (.ok1(ok1), .ok2(ok2x[ 8*17 +: 17 ]), .ep_addr(8'h28), .ep_datain(ep28wire));
    okWireOut    wo29 (.ok1(ok1), .ok2(ok2x[ 9*17 +: 17 ]), .ep_addr(8'h29), .ep_datain(ep29wire));
    okWireOut    wo30 (.ok1(ok1), .ok2(ok2x[ 12*17 +: 17 ]), .ep_addr(8'h30), .ep_datain(ep30wire));
    okWireOut    wo31 (.ok1(ok1), .ok2(ok2x[ 13*17 +: 17 ]), .ep_addr(8'h31), .ep_datain(ep31wire));
        
     //ep_ready = 1 (always ready to receive)
    okBTPipeIn   ep80 (.ok1(ok1), .ok2(ok2x[ 10*17 +: 17 ]), .ep_addr(8'h80), .ep_write(is_pipe_being_written), .ep_blockstrobe(), .ep_dataout(lce_from_py), .ep_ready(1'b1));

    okBTPipeOut  epA0 (.ok1(ok1), .ok2(ok2x[ 11*17 +: 17 ]), .ep_addr(8'ha1), .ep_read(pipe_out_read),  .ep_blockstrobe(), .ep_datain(rawspikes), .ep_ready(1'b1));

    okTriggerIn ep50 (.ok1(ok1),  .ep_addr(8'h50), .ep_clk(clk1), .ep_trigger(ep50trig));
endmodule

