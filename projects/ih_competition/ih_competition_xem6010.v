
`timescale 1ns / 1ps

// ih_competition_xem6010.v
// Generated on 2013-09-30 13:36:55 -0700

    module ih_competition_xem6010(
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
		
        
        assign spikeout1 = 1'b0;
        assign spikeout2 = 1'b0;
        assign spikeout3 = 1'b0;
        assign spikeout4 = 1'b0;
        assign spikeout5 = 1'b0;
        assign spikeout6 = 1'b0;
        assign spikeout7 = 1'b0;
        assign spikeout8 = 1'b0;
        assign spikeout9 = 1'b0;
        assign spikeout10 = 1'b0;
        assign spikeout11 = 1'b0;
        assign spikeout12 = 1'b0;
        assign spikeout13 = 1'b0;
        assign spikeout14 = 1'b0;
        
        
        
        // *** Dump all the declarations here:
        wire         ti_clk;
        wire [30:0]  ok1;
        wire [16:0]  ok2;   
        wire reset_global;

        // *** Target interface bus:
        assign i2c_sda = 1'bz;
        assign i2c_scl = 1'bz;
        assign hi_muxsel = 1'b0;
    
/////////////////////// BEGIN WIRE DEFINITIONS ////////////////////////////

        // Clock Generator clk_gen0 Wire Definitions
        wire neuron_clk;  // neuron clock (128 cycles per 1ms simulation time) 
        wire sim_clk;     // simulation clock (1 cycle per 1ms simulation time)
        wire spindle_clk; // spindle clock (3 cycles per 1ms simulation time)
        

        // Triggered Input triggered_input0 Wire Definitions
        reg [31:0] triggered_input0;    // Triggered input sent from USB (left_m1_in)       
        

        // Triggered Input triggered_input1 Wire Definitions
        reg [31:0] triggered_input1;    // Triggered input sent from USB (right_m1_in)       
        

        // Triggered Input triggered_input2 Wire Definitions
        reg [31:0] triggered_input2;    // Triggered input sent from USB (ltp)       
        

        // Triggered Input triggered_input3 Wire Definitions
        reg [31:0] triggered_input3;    // Triggered input sent from USB (ltd)       
        

        // Triggered Input triggered_input4 Wire Definitions
        reg [31:0] triggered_input4;    // Triggered input sent from USB (p_delta)       
        

        // Triggered Input triggered_input5 Wire Definitions
        reg [31:0] triggered_input5;    // Triggered input sent from USB (clk_divider)       
        

        // Output and OpalKelly Interface Wire Definitions
        
        wire [32*17-1:0] ok2x;
        wire [15:0] ep00wire, ep01wire, ep02wire;
        wire [15:0] ep50trig;
        
        wire pipe_in_write;
        wire [15:0] pipe_in_data;
        

        // Spike Counter spike_counter0 Wire Definitions
        wire [31:0] spike_count_neuron0;
        

        // Spike Counter spike_counter1 Wire Definitions
        wire [31:0] spike_count_neuron1;
        

        // Spike Counter spike_counter2 Wire Definitions
        wire [31:0] spike_count_neuron2;
        

        // Spike Counter spike_counter3 Wire Definitions
        wire [31:0] spike_count_neuron3;
        

        // Synapse synapse0 Wire Definitions        
        wire [31:0] I_synapse0;   // sample of the synaptic current (updates once per 1ms simulation time)
        wire [31:0] each_I_synapse0;  // raw synaptic currents
        wire [31:0] synaptic_strength_synapse0; // baseline synaptic strength
        

        // Synapse synapse1 Wire Definitions        
        wire [31:0] I_synapse1;   // sample of the synaptic current (updates once per 1ms simulation time)
        wire [31:0] each_I_synapse1;  // raw synaptic currents
        wire [31:0] synaptic_strength_synapse1; // baseline synaptic strength
        

        // Synapse synapse2 Wire Definitions        
        wire [31:0] I_synapse2;   // sample of the synaptic current (updates once per 1ms simulation time)
        wire [31:0] each_I_synapse2;  // raw synaptic currents
        wire [31:0] synaptic_strength_synapse2; // baseline synaptic strength
        

        // Synapse synapse3 Wire Definitions        
        wire [31:0] I_synapse3;   // sample of the synaptic current (updates once per 1ms simulation time)
        wire [31:0] each_I_synapse3;  // raw synaptic currents
        wire [31:0] synaptic_strength_synapse3; // baseline synaptic strength
        

        // Neuron neuron0 Wire Definitions (left_m1)
        wire [31:0] v_neuron0;   // membrane potential
        wire spike_neuron0;      // spike sample for visualization only
        wire each_spike_neuron0; // raw spike signals
        wire [127:0] population_neuron0; // spike raster for entire population  
        
        wire [31:0] a_neuron0;  // membrane recovery decay rate
        wire [31:0] b_neuron0;  // membrane recovery sensitivity
        wire [31:0] c_neuron0;  // membrane potential reset value
        wire [31:0] d_neuron0;  // membrane recovery reset value    
        

        // Neuron neuron1 Wire Definitions (right_m1)
        wire [31:0] v_neuron1;   // membrane potential
        wire spike_neuron1;      // spike sample for visualization only
        wire each_spike_neuron1; // raw spike signals
        wire [127:0] population_neuron1; // spike raster for entire population  
        
        wire [31:0] a_neuron1;  // membrane recovery decay rate
        wire [31:0] b_neuron1;  // membrane recovery sensitivity
        wire [31:0] c_neuron1;  // membrane potential reset value
        wire [31:0] d_neuron1;  // membrane recovery reset value    
        

        // Neuron neuron2 Wire Definitions (left_motoneuron)
        wire [31:0] v_neuron2;   // membrane potential
        wire spike_neuron2;      // spike sample for visualization only
        wire each_spike_neuron2; // raw spike signals
        wire [127:0] population_neuron2; // spike raster for entire population  
        
        wire [31:0] a_neuron2;  // membrane recovery decay rate
        wire [31:0] b_neuron2;  // membrane recovery sensitivity
        wire [31:0] c_neuron2;  // membrane potential reset value
        wire [31:0] d_neuron2;  // membrane recovery reset value    
        

        // Neuron neuron3 Wire Definitions (right_motoneuron)
        wire [31:0] v_neuron3;   // membrane potential
        wire spike_neuron3;      // spike sample for visualization only
        wire each_spike_neuron3; // raw spike signals
        wire [127:0] population_neuron3; // spike raster for entire population  
        
        wire [31:0] a_neuron3;  // membrane recovery decay rate
        wire [31:0] b_neuron3;  // membrane recovery sensitivity
        wire [31:0] c_neuron3;  // membrane potential reset value
        wire [31:0] d_neuron3;  // membrane recovery reset value    
        
/////////////////////// END WIRE DEFINITIONS //////////////////////////////

/////////////////////// BEGIN INSTANCE DEFINITIONS ////////////////////////

        // Clock Generator clk_gen0 Instance Definition
        gen_clk clocks(
            .rawclk(clk1),
            .half_cnt(triggered_input5),
            .clk_out1(neuron_clk),
            .clk_out2(sim_clk),
            .clk_out3(spindle_clk),
            .int_neuron_cnt_out()
        );
        

        // Triggered Input triggered_input0 Instance Definition (left_m1_in)
        always @ (posedge ep50trig[6] or posedge reset_global)
        if (reset_global)
            triggered_input0 <= 32'd10240;         //reset to 10      
        else
            triggered_input0 <= {ep02wire, ep01wire};        
        

        // Triggered Input triggered_input1 Instance Definition (right_m1_in)
        always @ (posedge ep50trig[5] or posedge reset_global)
        if (reset_global)
            triggered_input1 <= 32'd10240;         //reset to 10      
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
        

        // Triggered Input triggered_input5 Instance Definition (clk_divider)
        always @ (posedge ep50trig[7] or posedge reset_global)
        if (reset_global)
            triggered_input5 <= triggered_input5;         //reset to triggered_input5      
        else
            triggered_input5 <= {ep02wire, ep01wire};        
        

        // Output and OpalKelly Interface Instance Definitions
        //assign led = 0;
        

        assign led[0] = ~spike_neuron0;
        assign led[1] = 1'b0;
        assign led[2] = ~spike_neuron1;
        assign led[3] = 1'b0;
        assign led[4] = ~spike_neuron2;
        assign led[5] = 1'b0;
        assign led[6] = ~spike_neuron3;
        assign led[7] = 1'b0;
        
        assign reset_global = ep00wire[0];
        okWireOR # (.N(32)) wireOR (ok2, ok2x);
        okHost okHI(
            .hi_in(hi_in),  .hi_out(hi_out),    .hi_inout(hi_inout),    .hi_aa(hi_aa),
            .ti_clk(ti_clk),    .ok1(ok1),  .ok2(ok2)   );
        
        //okTriggerIn ep50    (.ok1(ok1), .ep_addr(8'h50),    .ep_clk(clk1),  .ep_trigger(ep50trig)   );
        okTriggerIn ep50    (.ok1(ok1), .ep_addr(8'h50),    .ep_clk(sim_clk),  .ep_trigger(ep50trig)   );
        
        okWireIn    wi00    (.ok1(ok1), .ep_addr(8'h00),    .ep_dataout(ep00wire)   );
        okWireIn    wi01    (.ok1(ok1), .ep_addr(8'h01),    .ep_dataout(ep01wire)   );
        okWireIn    wi02    (.ok1(ok1), .ep_addr(8'h02),    .ep_dataout(ep02wire)   );
        
        okWireOut wo20 (    .ep_datain(v_neuron0[15:0]),  .ok1(ok1),  .ok2(ok2x[0*17 +: 17]), .ep_addr(8'h20)    );
        okWireOut wo21 (    .ep_datain(v_neuron0[31:16]),  .ok1(ok1),  .ok2(ok2x[1*17 +: 17]), .ep_addr(8'h21)   );    
        
        okWireOut wo22 (    .ep_datain(population_neuron0[15:0]),  .ok1(ok1),  .ok2(ok2x[2*17 +: 17]), .ep_addr(8'h22)    );
        okWireOut wo23 (    .ep_datain(population_neuron0[31:16]),  .ok1(ok1),  .ok2(ok2x[3*17 +: 17]), .ep_addr(8'h23)   );    
        
        okWireOut wo24 (    .ep_datain(spike_count_neuron0[15:0]),  .ok1(ok1),  .ok2(ok2x[4*17 +: 17]), .ep_addr(8'h24)    );
        okWireOut wo25 (    .ep_datain(spike_count_neuron0[31:16]),  .ok1(ok1),  .ok2(ok2x[5*17 +: 17]), .ep_addr(8'h25)   );    
        
        okWireOut wo26 (    .ep_datain(v_neuron1[15:0]),  .ok1(ok1),  .ok2(ok2x[6*17 +: 17]), .ep_addr(8'h26)    );
        okWireOut wo27 (    .ep_datain(v_neuron1[31:16]),  .ok1(ok1),  .ok2(ok2x[7*17 +: 17]), .ep_addr(8'h27)   );    
        
        okWireOut wo28 (    .ep_datain(population_neuron1[15:0]),  .ok1(ok1),  .ok2(ok2x[8*17 +: 17]), .ep_addr(8'h28)    );
        okWireOut wo29 (    .ep_datain(population_neuron1[31:16]),  .ok1(ok1),  .ok2(ok2x[9*17 +: 17]), .ep_addr(8'h29)   );    
        
        okWireOut wo2a (    .ep_datain(spike_count_neuron1[15:0]),  .ok1(ok1),  .ok2(ok2x[10*17 +: 17]), .ep_addr(8'h2a)    );
        okWireOut wo2b (    .ep_datain(spike_count_neuron1[31:16]),  .ok1(ok1),  .ok2(ok2x[11*17 +: 17]), .ep_addr(8'h2b)   );    
        
        okWireOut wo2c (    .ep_datain(v_neuron2[15:0]),  .ok1(ok1),  .ok2(ok2x[12*17 +: 17]), .ep_addr(8'h2c)    );
        okWireOut wo2d (    .ep_datain(v_neuron2[31:16]),  .ok1(ok1),  .ok2(ok2x[13*17 +: 17]), .ep_addr(8'h2d)   );    
        
        okWireOut wo2e (    .ep_datain(population_neuron2[15:0]),  .ok1(ok1),  .ok2(ok2x[14*17 +: 17]), .ep_addr(8'h2e)    );
        okWireOut wo2f (    .ep_datain(population_neuron2[31:16]),  .ok1(ok1),  .ok2(ok2x[15*17 +: 17]), .ep_addr(8'h2f)   );    
        
        okWireOut wo30 (    .ep_datain(spike_count_neuron2[15:0]),  .ok1(ok1),  .ok2(ok2x[16*17 +: 17]), .ep_addr(8'h30)    );
        okWireOut wo31 (    .ep_datain(spike_count_neuron2[31:16]),  .ok1(ok1),  .ok2(ok2x[17*17 +: 17]), .ep_addr(8'h31)   );    
        
        okWireOut wo32 (    .ep_datain(I_synapse1[15:0]),  .ok1(ok1),  .ok2(ok2x[18*17 +: 17]), .ep_addr(8'h32)    );
        okWireOut wo33 (    .ep_datain(I_synapse1[31:16]),  .ok1(ok1),  .ok2(ok2x[19*17 +: 17]), .ep_addr(8'h33)   );    
        
        okWireOut wo34 (    .ep_datain(I_synapse2[15:0]),  .ok1(ok1),  .ok2(ok2x[20*17 +: 17]), .ep_addr(8'h34)    );
        okWireOut wo35 (    .ep_datain(I_synapse2[31:16]),  .ok1(ok1),  .ok2(ok2x[21*17 +: 17]), .ep_addr(8'h35)   );    
        
        okWireOut wo36 (    .ep_datain(v_neuron3[15:0]),  .ok1(ok1),  .ok2(ok2x[22*17 +: 17]), .ep_addr(8'h36)    );
        okWireOut wo37 (    .ep_datain(v_neuron3[31:16]),  .ok1(ok1),  .ok2(ok2x[23*17 +: 17]), .ep_addr(8'h37)   );    
        
        okWireOut wo38 (    .ep_datain(population_neuron3[15:0]),  .ok1(ok1),  .ok2(ok2x[24*17 +: 17]), .ep_addr(8'h38)    );
        okWireOut wo39 (    .ep_datain(population_neuron3[31:16]),  .ok1(ok1),  .ok2(ok2x[25*17 +: 17]), .ep_addr(8'h39)   );    
        
        okWireOut wo3a (    .ep_datain(spike_count_neuron3[15:0]),  .ok1(ok1),  .ok2(ok2x[26*17 +: 17]), .ep_addr(8'h3a)    );
        okWireOut wo3b (    .ep_datain(spike_count_neuron3[31:16]),  .ok1(ok1),  .ok2(ok2x[27*17 +: 17]), .ep_addr(8'h3b)   );    
        
        okWireOut wo3c (    .ep_datain(I_synapse0[15:0]),  .ok1(ok1),  .ok2(ok2x[28*17 +: 17]), .ep_addr(8'h3c)    );
        okWireOut wo3d (    .ep_datain(I_synapse0[31:16]),  .ok1(ok1),  .ok2(ok2x[29*17 +: 17]), .ep_addr(8'h3d)   );    
        
        okWireOut wo3e (    .ep_datain(I_synapse3[15:0]),  .ok1(ok1),  .ok2(ok2x[30*17 +: 17]), .ep_addr(8'h3e)    );
        okWireOut wo3f (    .ep_datain(I_synapse3[31:16]),  .ok1(ok1),  .ok2(ok2x[31*17 +: 17]), .ep_addr(8'h3f)   );    
        

        // Spike Counter spike_counter0 Instance Definition
        spike_counter spike_counter0(
            .clk(neuron_clk),
            .reset(reset_global),
            .spike_in(each_spike_neuron0), 
            .spike_count( spike_count_neuron0)
        );
        

        // Spike Counter spike_counter1 Instance Definition
        spike_counter spike_counter1(
            .clk(neuron_clk),
            .reset(reset_global),
            .spike_in(each_spike_neuron1), 
            .spike_count( spike_count_neuron1)
        );
        

        // Spike Counter spike_counter2 Instance Definition
        spike_counter spike_counter2(
            .clk(neuron_clk),
            .reset(reset_global),
            .spike_in(each_spike_neuron2), 
            .spike_count( spike_count_neuron2)
        );
        

        // Spike Counter spike_counter3 Instance Definition
        spike_counter spike_counter3(
            .clk(neuron_clk),
            .reset(reset_global),
            .spike_in(each_spike_neuron3), 
            .spike_count( spike_count_neuron3)
        );
        

        // Synapse synapse0 Instance Definition
        
        assign synaptic_strength_synapse0 = 32'd1024; // baseline synaptic strength
        
        synapse synapse0(
            .clk(neuron_clk),                           // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_global),                       // reset synaptic weights
            .spike_in(each_spike_neuron0),             // spike from presynaptic neuron
            .postsynaptic_spike_in(each_spike_neuron3),   //spike from postsynaptic neuron
            
            //.I_out(I_synapse0),                           // sample of synaptic current out
            .synaptic_strength(I_synapse0),                           // sample of synaptic current out

            .each_I(each_I_synapse0),                      // raw synaptic currents
            
            .base_strength(synaptic_strength_synapse0),  // baseline synaptic strength              
        
            .ltp(triggered_input2),                        // long term potentiation weight
            .ltd(triggered_input3),                        // long term depression weight
            .p_delta(triggered_input4)                 // chance for decay 
        );
        

        // Synapse synapse1 Instance Definition
        
        assign synaptic_strength_synapse1 = 32'd1024; // baseline synaptic strength
        
        synapse synapse1(
            .clk(neuron_clk),                           // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_global),                       // reset synaptic weights
            .spike_in(each_spike_neuron1),             // spike from presynaptic neuron
            .postsynaptic_spike_in(each_spike_neuron2),   //spike from postsynaptic neuron
            //.I_out(I_synapse1),                           // sample of synaptic current out
            .synaptic_strength(I_synapse1),                           // sample of synaptic current out
            .each_I(each_I_synapse1),                      // raw synaptic currents
            
            .base_strength(synaptic_strength_synapse1),  // baseline synaptic strength              
        
            .ltp(triggered_input2),                        // long term potentiation weight
            .ltd(triggered_input3),                        // long term depression weight
            .p_delta(triggered_input4)                 // chance for decay 
        );
        

        // Synapse synapse2 Instance Definition
        
        assign synaptic_strength_synapse2 = 32'd1024; // baseline synaptic strength
        
        synapse synapse2(
            .clk(neuron_clk),                           // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_global),                       // reset synaptic weights
            .spike_in(each_spike_neuron0),             // spike from presynaptic neuron
            .postsynaptic_spike_in(each_spike_neuron2),   //spike from postsynaptic neuron
            //.I_out(I_synapse2),                           // sample of synaptic current out
            .synaptic_strength(I_synapse2),                           // sample of synaptic current out
            .each_I(each_I_synapse2),                      // raw synaptic currents
            
            .base_strength(synaptic_strength_synapse2),  // baseline synaptic strength              
        
            .ltp(triggered_input2),                        // long term potentiation weight
            .ltd(triggered_input3),                        // long term depression weight
            .p_delta(triggered_input4)                 // chance for decay 
        );
        

        // Synapse synapse3 Instance Definition
        
        assign synaptic_strength_synapse3 = 32'd1024; // baseline synaptic strength
        
        synapse synapse3(
            .clk(neuron_clk),                           // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_global),                       // reset synaptic weights
            .spike_in(each_spike_neuron1),             // spike from presynaptic neuron
            .postsynaptic_spike_in(each_spike_neuron3),   //spike from postsynaptic neuron
            //.I_out(I_synapse3),                           // sample of synaptic current out
            .synaptic_strength(I_synapse3),                           // sample of synaptic current out
            .each_I(each_I_synapse3),                      // raw synaptic currents
            
            .base_strength(synaptic_strength_synapse3),  // baseline synaptic strength              
        
            .ltp(triggered_input2),                        // long term potentiation weight
            .ltd(triggered_input3),                        // long term depression weight
            .p_delta(triggered_input4)                 // chance for decay 
        );
        


        // Neuron neuron0 Instance Definition (left_m1 - regular)
        assign a_neuron0 = 32'd82;
        assign b_neuron0 = 32'd205;
        assign c_neuron0 = -32'd65560;
        assign d_neuron0 = 32'd2048;
        
        izneuron_abcd neuron0(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_global),           // reset to initial conditions
            
            .a(a_neuron0),
            .b(b_neuron0),
            .c(c_neuron0),
            .d(d_neuron0),
            
            .I_in(  triggered_input0 ),          // input current from synapse
            .v_out(v_neuron0),               // membrane potential
            .spike(spike_neuron0),           // spike sample
            .each_spike(each_spike_neuron0), // raw spikes
            .population(population_neuron0)  // spikes of population per 1ms simulation time
        );
        


        // Neuron neuron1 Instance Definition (right_m1 - regular)
        assign a_neuron1 = 32'd82;
        assign b_neuron1 = 32'd205;
        assign c_neuron1 = -32'd65560;
        assign d_neuron1 = 32'd2048;
        
        izneuron_abcd neuron1(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_global),           // reset to initial conditions
            
            .a(a_neuron1),
            .b(b_neuron1),
            .c(c_neuron1),
            .d(d_neuron1),
            
            .I_in(  triggered_input1 ),          // input current from synapse
            .v_out(v_neuron1),               // membrane potential
            .spike(spike_neuron1),           // spike sample
            .each_spike(each_spike_neuron1), // raw spikes
            .population(population_neuron1)  // spikes of population per 1ms simulation time
        );
        


        // Neuron neuron2 Instance Definition (left_motoneuron - regular)
        assign a_neuron2 = 32'd82;
        assign b_neuron2 = 32'd205;
        assign c_neuron2 = -32'd65560;
        assign d_neuron2 = 32'd2048;
        
        izneuron_abcd neuron2(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_global),           // reset to initial conditions
            
            .a(a_neuron2),
            .b(b_neuron2),
            .c(c_neuron2),
            .d(d_neuron2),
            
            .I_in(  each_I_synapse1 + each_I_synapse2 ),          // input current from synapse
            .v_out(v_neuron2),               // membrane potential
            .spike(spike_neuron2),           // spike sample
            .each_spike(each_spike_neuron2), // raw spikes
            .population(population_neuron2)  // spikes of population per 1ms simulation time
        );
        


        // Neuron neuron3 Instance Definition (right_motoneuron - regular)
        assign a_neuron3 = 32'd82;
        assign b_neuron3 = 32'd205;
        assign c_neuron3 = -32'd65560;
        assign d_neuron3 = 32'd2048;
        
        izneuron_abcd neuron3(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_global),           // reset to initial conditions
            
            .a(a_neuron3),
            .b(b_neuron3),
            .c(c_neuron3),
            .d(d_neuron3),
            
            .I_in(  each_I_synapse0 + each_I_synapse3 ),          // input current from synapse
            .v_out(v_neuron3),               // membrane potential
            .spike(spike_neuron3),           // spike sample
            .each_spike(each_spike_neuron3), // raw spikes
            .population(population_neuron3)  // spikes of population per 1ms simulation time
        );
        
/////////////////////// END INSTANCE DEFINITIONS //////////////////////////
endmodule
