
`timescale 1ns / 1ps

// rack_mn_muscle_xem6010.v
// Generated on Tue Mar 12 15:55:13 -0700 2013

    module rack_mn_muscle_xem6010(
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
	    
	    // Neuron array inputs
          input wire spikein1,  
          input wire spikein2,
          input wire spikein3,
          input wire spikein4,
          input wire spikein5,
          input wire spikein6,
          input wire spikein7,
          input wire spikein8,
          input wire spikein9,
          input wire spikein10,
          input wire spikein11,
          input wire spikein12,
          input wire spikein13,
          input wire spikein14,
      
          // Neuron array outputs
          output wire spikeout1, 
          output wire spikeout2,
          output wire spikeout3,
          output wire spikeout4,
          output wire spikeout5,
          output wire spikeout6,
          output wire spikeout7,
          output wire spikeout8,
          output wire spikeout9,
          output wire spikeout10,
          output wire spikeout11,
          output wire spikeout12,
          output wire spikeout13,
          output wire spikeout14
       );
       
        parameter NN = 8;
		
        // *** Dump all the declarations here:
        wire         ti_clk;
        wire [30:0]  ok1;
        wire [16:0]  ok2;   
        wire reset_global;
        wire is_from_trigger;

        // *** Target interface bus:
        assign i2c_sda = 1'bz;
        assign i2c_scl = 1'bz;
        assign hi_muxsel = 1'b0;
    

      
/////////////////////// BEGIN WIRE DEFINITIONS ////////////////////////////

        // Synapse synapse0 Wire Definitions        
        wire [31:0] I_synapse0;   // sample of the synaptic current (updates once per 1ms simulation time)
        wire [31:0] each_I_synapse0;  // raw synaptic currents
        

        // Triggered Input triggered_input0 Wire Definitions
        reg [31:0] triggered_input0;    // Triggered input sent from USB (lce)       
        

        // Triggered Input triggered_input1 Wire Definitions
        reg [31:0] triggered_input1;    // Triggered input sent from USB (tau)       
        

        // Triggered Input triggered_input2 Wire Definitions
        reg [31:0] triggered_input2;    // Triggered input sent from USB (ltp)       
        

        // Triggered Input triggered_input3 Wire Definitions
        reg [31:0] triggered_input3;    // Triggered input sent from USB (ltd)       
        

        // Triggered Input triggered_input4 Wire Definitions
        reg [31:0] triggered_input4;    // Triggered input sent from USB (p_delta)       
        

        // Triggered Input triggered_input5 Wire Definitions
        reg [31:0] triggered_input5;    // Triggered input sent from USB (syn_gain)       
        

        // Triggered Input triggered_input6 Wire Definitions
        reg [31:0] triggered_input6;    // Triggered input sent from USB (clk_divider)       
        

        // Spike Counter spike_counter0 Wire Definitions
        wire [31:0] spike_count_neuron0;
        

        // Waveform Generator mixed_input0 Wire Definitions
        wire [31:0] mixed_input0;   // Wave out signal
        

    // FPGA Input/Output Rack Wire Definitions
    // these are in the top module input/output list
    

        // Output and OpalKelly Interface Wire Definitions
        
        wire [13*17-1:0] ok2x;
        wire [15:0] ep00wire, ep01wire, ep02wire;
        wire [15:0] ep50trig;
        
        wire pipe_in_write;
        wire [15:0] pipe_in_data;
        

        // Muscle muscle0 Wire Definitions
        wire [31:0] total_force_out_muscle0;
        wire [31:0] current_A_muscle0;
        wire [31:0] current_fp_spikes_muscle0;
        

        // Clock Generator clk_gen0 Wire Definitions
        wire neuron_clk;  // neuron clock (128 cycles per 1ms simulation time) 
        wire sim_clk;     // simulation clock (1 cycle per 1ms simulation time)
        wire spindle_clk; // spindle clock (3 cycles per 1ms simulation time)
        

        // Neuron neuron0 Wire Definitions
        wire [31:0] v_neuron0;   // membrane potential
        wire spike_neuron0;      // spike sample for visualization only
        wire each_spike_neuron0; // raw spike signals
        wire [127:0] population_neuron0; // spike raster for entire population        
        
/////////////////////// END WIRE DEFINITIONS //////////////////////////////

/////////////////////// BEGIN INSTANCE DEFINITIONS ////////////////////////

        // Synapse synapse0 Instance Definition
        synapse synapse0(
            .clk(neuron_clk),                           // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_global),                       // reset synaptic weights
            .spike_in(spikein1),             // spike from presynaptic neuron
            .postsynaptic_spike_in(each_spike_neuron0),   //spike from postsynaptic neuron
            .I_out(I_synapse0),                           // sample of synaptic current out
            .each_I(each_I_synapse0),                      // raw synaptic currents
        
            .ltp(triggered_input2),                        // long term potentiation weight
            .ltd(triggered_input3),                        // long term depression weight
            .p_delta(triggered_input4)                 // chance for decay 
        );

	wire [31:0] i_EPSC_synapse0;
 	unsigned_mult32 synapse0_gain(.out(i_EPSC_synapse0), .a(each_I_synapse0), .b(triggered_input5));
   

        

        // Triggered Input triggered_input0 Instance Definition (lce)
        always @ (posedge ep50trig[9] or posedge reset_global)
        if (reset_global)
            triggered_input0 <= 32'h3f8ccccd;         //reset to 1.1      
        else
            triggered_input0 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input1 Instance Definition (tau)
        always @ (posedge ep50trig[2] or posedge reset_global)
        if (reset_global)
            triggered_input1 <= 32'h3cf5c28f;         //reset to 0.03      
        else
            triggered_input1 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input2 Instance Definition (ltp)
        always @ (posedge ep50trig[12] or posedge reset_global)
        if (reset_global)
            triggered_input2 <= 32'd0;         //reset to 0      
        else
            triggered_input2 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input3 Instance Definition (ltd)
        always @ (posedge ep50trig[11] or posedge reset_global)
        if (reset_global)
            triggered_input3 <= 32'd0;         //reset to 0      
        else
            triggered_input3 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input4 Instance Definition (p_delta)
        always @ (posedge ep50trig[10] or posedge reset_global)
        if (reset_global)
            triggered_input4 <= 32'd0;         //reset to 0      
        else
            triggered_input4 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input5 Instance Definition (syn_gain)
        always @ (posedge ep50trig[3] or posedge reset_global)
        if (reset_global)
            triggered_input5 <= 32'd1;         //reset to 1.0      
        else
            triggered_input5 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input6 Instance Definition (clk_divider)
        always @ (posedge ep50trig[7] or posedge reset_global)
        if (reset_global)
            triggered_input6 <= triggered_input6;         //reset to triggered_input6      
        else
            triggered_input6 <= {ep02wire, ep01wire};      
        

        // Spike Counter spike_counter0 Instance Definition
	wire    clear_signal_from_async_cnt;
        spikecnt_async	spike_counter0
        (      .spike(each_spike_neuron0),
                .int_cnt_out(spike_count_neuron0),
                .slow_clk(sim_clk),
                .fast_clk(clk1),
                .reset(reset_global),
                .clear_out(clear_signal_from_async_cnt));
                
     wire [31:0]  spike_count_neuron0_sync;
      spike_counter  sync_counter
      (                 .clk(neuron_clk),
                        .reset(reset_global),
                        .spike_in(each_spike_neuron0),
                        .spike_count(spike_count_neuron0_sync) );

        

        // Waveform Generator mixed_input0 Instance Definition
        waveform_from_pipe_bram_2s gen_mixed_input0(
            .reset(reset_global),               // reset the waveform
            .pipe_clk(ti_clk),                  // target interface clock from opalkelly interface
            .pipe_in_write(pipe_in_write),      // write enable signal from opalkelly pipe in
            .data_from_trig(triggered_input0),	// data from one of ep50 channel
            .is_from_trigger(is_from_trigger),
            .pipe_in_data(pipe_in_data),        // waveform data from opalkelly pipe in
            .pop_clk(sim_clk),                  // trigger next waveform sample every 1ms
            .wave(mixed_input0)                   // wave out signal
        );
        
    //FPGA-FPGA Outputs
    assign spikeout1 = clear_signal_from_async_cnt;
    assign spikeout2 = 1'b0;
    assign spikeout3 = 1'b0;
    assign spikeout4 = 1'b0;
    assign spikeout5 = 1'b0;
    assign spikeout6 = 1'b0;
    assign spikeout7 = 1'b0;
    assign spikeout8 = sim_clk;
    assign spikeout9 = 1'b0;
    assign spikeout10 = 1'b0;
    assign spikeout11 = 1'b0;
    assign spikeout12 = 1'b0;
    assign spikeout13 = 1'b0;
    assign spikeout14 = 1'b0;

        // Output and OpalKelly Interface Instance Definitions
        //assign led = 0;
        assign reset_global = ep00wire[0];
        assign is_from_trigger = ~ep00wire[1];
        okWireOR # (.N(13)) wireOR (ok2, ok2x);
        okHost okHI(
            .hi_in(hi_in),  .hi_out(hi_out),    .hi_inout(hi_inout),    .hi_aa(hi_aa),
            .ti_clk(ti_clk),    .ok1(ok1),  .ok2(ok2)   );
        
        //okTriggerIn ep50    (.ok1(ok1), .ep_addr(8'h50),    .ep_clk(clk1),  .ep_trigger(ep50trig)   );
        okTriggerIn ep50    (.ok1(ok1), .ep_addr(8'h50),    .ep_clk(sim_clk),  .ep_trigger(ep50trig)   );
        
        okWireIn    wi00    (.ok1(ok1), .ep_addr(8'h00),    .ep_dataout(ep00wire)   );
        okWireIn    wi01    (.ok1(ok1), .ep_addr(8'h01),    .ep_dataout(ep01wire)   );
        okWireIn    wi02    (.ok1(ok1), .ep_addr(8'h02),    .ep_dataout(ep02wire)   );
        
        okBTPipeIn ep80 (   .ok1(ok1), .ok2(ok2x[0*17 +: 17]), .ep_addr(8'h80), .ep_write(pipe_in_write),
                            .ep_blockstrobe(), .ep_dataout(pipe_in_data), .ep_ready(1'b1));
        
        okWireOut wo20 (    .ep_datain(mixed_input0[15:0]),  .ok1(ok1),  .ok2(ok2x[1*17 +: 17]), .ep_addr(8'h20)    );
        okWireOut wo21 (    .ep_datain(mixed_input0[31:16]),  .ok1(ok1),  .ok2(ok2x[2*17 +: 17]), .ep_addr(8'h21)   );    
        
        okWireOut wo22 (    .ep_datain(total_force_out_muscle0_sync[15:0]),  .ok1(ok1),  .ok2(ok2x[3*17 +: 17]), .ep_addr(8'h22)    );
        okWireOut wo23 (    .ep_datain(total_force_out_muscle0_sync[31:16]),  .ok1(ok1),  .ok2(ok2x[4*17 +: 17]), .ep_addr(8'h23)   );    
        
        okWireOut wo24 (    .ep_datain(spike_count_neuron0_sync[15:0]),  .ok1(ok1),  .ok2(ok2x[5*17 +: 17]), .ep_addr(8'h24)    );
        okWireOut wo25 (    .ep_datain(spike_count_neuron0_sync[31:16]),  .ok1(ok1),  .ok2(ok2x[6*17 +: 17]), .ep_addr(8'h25)   );    
        
        okWireOut wo26 (    .ep_datain(spike_count_neuron0[15:0]),  .ok1(ok1),  .ok2(ok2x[7*17 +: 17]), .ep_addr(8'h26)    );
        okWireOut wo27 (    .ep_datain(spike_count_neuron0[31:16]),  .ok1(ok1),  .ok2(ok2x[8*17 +: 17]), .ep_addr(8'h27)   );    
        
        okWireOut wo28 (    .ep_datain(I_synapse0[15:0]),  .ok1(ok1),  .ok2(ok2x[9*17 +: 17]), .ep_addr(8'h28)    );
        okWireOut wo29 (    .ep_datain(I_synapse0[31:16]),  .ok1(ok1),  .ok2(ok2x[10*17 +: 17]), .ep_addr(8'h29)   );    
         
        
        wire [31:0] total_force_out_muscle0_sync;
        // Muscle muscle0 Wire Definitions
        shadmehr_muscle muscle0_sync(
            .i_spike_cnt(spike_count_neuron0_sync),
            .f_pos(mixed_input0),
            .f_vel(32'd0),
            .clk(sim_clk),
            .reset(reset_global),
            .f_tau(triggered_input1),
            .f_total_force_out(total_force_out_muscle0_sync)
            //.f_current_A(),
            //.f_current_fp_spikes()
        );     
        
       

        // Clock Generator clk_gen0 Instance Definition
        gen_clk clocks(
            .rawclk(clk1),
            .half_cnt(triggered_input6),
            .clk_out1(neuron_clk),
            .clk_out2(sim_clk),
            .clk_out3(spindle_clk),
            .int_neuron_cnt_out()
        );
        


        // Neuron neuron0 Instance Definition
        izneuron neuron0(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_global),           // reset to initial conditions
            .I_in(  i_EPSC_synapse0 ),          // input current from synapse
            .v_out(v_neuron0),               // membrane potential
            .spike(spike_neuron0),           // spike sample
            .each_spike(each_spike_neuron0), // raw spikes
            .population(population_neuron0)  // spikes of population per 1ms simulation time
        );
        
/////////////////////// END INSTANCE DEFINITIONS //////////////////////////

	// ** LEDs
    assign led[0] = ~reset_global;
    assign led[1] = ~spikein1;
    assign led[2] = ~each_spike_neuron0;
    assign led[3] = ~0;
    assign led[4] = ~clear_signal_from_async_cnt;
    assign led[5] = ~0;
    assign led[6] = ~neuron_clk; // 
    assign led[7] = ~sim_clk; // clock
    
endmodule
