`default_nettype none
`timescale 1ns / 1ps

// rack_test_xem6010.v
// Generated on Wed Mar 13 14:57:46 -0700 2013

    module stdp_test_xem6010 (
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
        wire reset_sim;
        wire is_from_trigger;
        wire cut_synapse1;
        wire cut_synapse2;
        

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
        
        wire [40*17-1:0] ok2x;
        wire [15:0] ep00wire, ep01wire, ep02wire;
        wire [15:0] ep50trig;
        
        wire pipe_out_read;
        wire pipe_in_write;
        wire pipe_in_write_2;
        wire [15:0] pipe_in_data;
        wire [15:0] pipe_in_data_2;
        

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


        

        // Triggered Input triggered_input0 Instance Definition (left_m1_in)
        always @ (posedge ep50trig[6] or posedge reset_global)
        if (reset_global)
            triggered_input0 <= 32'd10240;    //32'd10240;         //reset to 10      
        else
            triggered_input0 <= {ep02wire, ep01wire};        
        

        // Triggered Input triggered_input1 Instance Definition (right_m1_in)
        always @ (posedge ep50trig[5] or posedge reset_global)
        if (reset_global)
            triggered_input1 <= 32'd10240;   //32'd10240;         //reset to 10      
        else
            triggered_input1 <= {ep02wire, ep01wire};        
            
       // Triggered Input triggered_input1 Instance Definition ()
       reg [31:0] flag_sync_inputs;
        always @ (posedge ep50trig[3] or posedge reset_global)
        if (reset_global)
            flag_sync_inputs <= 32'd0;   //32'd0   
        else
            flag_sync_inputs <= {ep02wire, ep01wire};     

            
            
//                   // Triggered Input triggered_input1 Instance Definition (lut2_index)
//       reg [31:0] neuron2_input_offset;
//        always @ (posedge ep50trig[4] or posedge reset_global)
//        if (reset_global)
//            neuron2_input_offset <= 32'd0;   //32'd0  
//        else
//            neuron2_input_offset <= {ep02wire, ep01wire};            
        
        

        // Triggered Input triggered_input2 Instance Definition (ltp)
        always @ (posedge ep50trig[12] or posedge reset_global)
        if (reset_global)
            triggered_input2 <= 32'd2;         //reset to 0      
        else
            triggered_input2 <= {ep02wire, ep01wire};        
        

        // Triggered Input triggered_input3 Instance Definition (ltd)
        always @ (posedge ep50trig[11] or posedge reset_global)
        if (reset_global)
            triggered_input3 <= 32'd1;         //reset to 0      
        else
            triggered_input3 <= {ep02wire, ep01wire};        
        

        // Triggered Input triggered_input4 Instance Definition (p_delta)
        always @ (posedge ep50trig[10] or posedge reset_global)
        if (reset_global)
            triggered_input4 <= 32'd0;         //reset to 0      
        else
            triggered_input4 <= {ep02wire, ep01wire};      

        // Triggered Input triggered_input4 Instance Definition (sync_scale)
        reg [31:0] block_neuron1;
        always @ (posedge ep50trig[4] or posedge reset_global)
        if (reset_global)
            block_neuron1 <= 32'd0;         //reset to 0     
        else
            block_neuron1 <= {ep02wire, ep01wire};               
            
        // Triggered Input triggered_input4 Instance Definition (sync_scale)
        reg [31:0] block_neuron2;
        always @ (posedge ep50trig[8] or posedge reset_global)
        if (reset_global)
            block_neuron2 <= 32'd0;         //reset to 0     
        else
            block_neuron2 <= {ep02wire, ep01wire};        
        

        // Triggered Input triggered_input5 Instance Definition (clk_divider)
        always @ (posedge ep50trig[7] or posedge reset_global)
        if (reset_global)
            triggered_input5 <= 32'd381;         //reset to triggered_input5      
        else
            triggered_input5 <= {ep02wire, ep01wire};        
        

        // Output and OpalKelly Interface Instance Definitions
        //assign led = 0;
        


/////////////////////// END WIRE DEFINITIONS //////////////////////////////

        
        
        


//        wire [31:0] mixed_input0;
//        // Waveform Generator mixed_input0 Instance Definition
//        waveform_from_pipe_bram_2s gen_input2n0(
//            .reset(reset_sim),               // reset the waveform
//            .pipe_clk(ti_clk),                  // target interface clock from opalkelly interface
//            .pipe_in_write(pipe_in_write),      // write enable signal from opalkelly pipe in
//            .data_from_trig(triggered_input0),	// data from one of ep50 channel
//            .is_from_trigger(is_from_trigger),
//            .pipe_in_data(pipe_in_data),        // waveform data from opalkelly pipe in
//            .pop_clk(sim_clk),                  // trigger next waveform sample every 1ms
//            .wave(mixed_input0)                   // wave out signal
//        );
//        
//        // time reference for latency measure 
//         // Waveform Generator mixed_input0 Instance Definition
//         wire [31:0] mixed_input2;
//        waveform_from_pipe_bram_2s gen_input2n2(
//            .reset(reset_sim),               // reset the waveform
//            .pipe_clk(ti_clk),                  // target interface clock from opalkelly interface
//            .pipe_in_write(pipe_in_write_2),      // write enable signal from opalkelly pipe in
//            .data_from_trig(triggered_input0),	// data from one of ep50 channel
//            .is_from_trigger(1'd0),
//            .pipe_in_data(pipe_in_data_2),        // waveform data from opalkelly pipe in
//            .pop_clk(sim_clk),                  // trigger next waveform sample every 1ms
//            .wave(mixed_input2)                   // wave out signal
//        );

        wire [31:0] mixed_input0;
        // Waveform Generator mixed_input0 Instance Definition
        waveform_from_pipe_bram_16s gen_input2n0_16(
            .reset(reset_sim),               // reset the waveform
            .pipe_clk(ti_clk),                  // target interface clock from opalkelly interface
            .pipe_in_write(pipe_in_write),      // write enable signal from opalkelly pipe in
            //.data_from_trig(triggered_input0),	// data from one of ep50 channel
            //.is_from_trigger(is_from_trigger),
            .pipe_in_data(pipe_in_data),        // waveform data from opalkelly pipe in
            .pop_clk(sim_clk),                  // trigger next waveform sample every 1ms
            .wave(mixed_input0)                   // wave out signal
        );
        
        // time reference for latency measure 
         // Waveform Generator mixed_input0 Instance Definition
         wire [31:0] mixed_input2;
        waveform_from_pipe_bram_16s gen_input2n2_16(
            .reset(reset_sim),               // reset the waveform
            .pipe_clk(ti_clk),                  // target interface clock from opalkelly interface
            .pipe_in_write(pipe_in_write_2),      // write enable signal from opalkelly pipe in
            //.data_from_trig(triggered_input0),	// data from one of ep50 channel
            //.is_from_trigger(1'd0),
            .pipe_in_data(pipe_in_data_2),        // waveform data from opalkelly pipe in
            .pop_clk(sim_clk),                  // trigger next waveform sample every 1ms
            .wave(mixed_input2)                   // wave out signal
        );
        
               
                      
                                
                             
        
        
    //FPGA-FPGA Outputs
    assign spikeout1 = 1'b0;
    assign spikeout2 = 1'b0;
    assign spikeout3 = 1'b0;
    assign spikeout4 = 1'b0;
    assign spikeout5 = 1'b0;
    assign spikeout6 = 1'b0;
    assign spikeout7 = 1'b0;
    assign spikeout8 = 1'b0;
    assign spikeout9 = 1'b0;
    assign spikeout10 = 1'b0;   // Ia afferent spike output,  (randomized I input, in floating point way. )
    assign spikeout11 = 1'b0;
    assign spikeout12 = 1'b0;
    assign spikeout13 = 1'b0;
    assign spikeout14 = 1'b0;

        // Output and OpalKelly Interface Instance Definitions
       reg reset_external_clean;
       always @ (posedge sim_clk)
        if (spikein14)
            reset_external_clean <= spikein14;      
        else
            reset_external_clean <= 0;    

        
        
        assign reset_global = ep00wire[0] | reset_external_clean;
        assign reset_sim = ep00wire[2] | reset_external_clean;
        assign is_from_trigger = ~ep00wire[1];
        assign cut_synapse1 = ~ep00wire[3];
        assign cut_synapse2 = ~ep00wire[4];
        
        okWireOR # (.N(40)) wireOR (ok2, ok2x);
        okHost okHI(
            .hi_in(hi_in),  .hi_out(hi_out),    .hi_inout(hi_inout),    .hi_aa(hi_aa),
            .ti_clk(ti_clk),    .ok1(ok1),  .ok2(ok2)   );
        
        //okTriggerIn ep50    (.ok1(ok1), .ep_addr(8'h50),    .ep_clk(clk1),  .ep_trigger(ep50trig)   );
        okTriggerIn ep50    (.ok1(ok1), .ep_addr(8'h50),    .ep_clk(sim_clk),  .ep_trigger(ep50trig)   );
        
        okWireIn    wi00    (.ok1(ok1), .ep_addr(8'h00),    .ep_dataout(ep00wire)   );
        okWireIn    wi01    (.ok1(ok1), .ep_addr(8'h01),    .ep_dataout(ep01wire)   );
        okWireIn    wi02    (.ok1(ok1), .ep_addr(8'h02),    .ep_dataout(ep02wire)   );
        
        
        
        okWireOut wo20 (    .ep_datain(neuron0_input[15:0]),  .ok1(ok1),  .ok2(ok2x[0*17 +: 17]), .ep_addr(8'h20)    );
        okWireOut wo21 (    .ep_datain(neuron0_input[31:16]),  .ok1(ok1),  .ok2(ok2x[1*17 +: 17]), .ep_addr(8'h21)   );    
        
        okWireOut wo22 (    .ep_datain(population_neuron0[31:16]),  .ok1(ok1),  .ok2(ok2x[2*17 +: 17]), .ep_addr(8'h22)    );
        okWireOut wo23 (    .ep_datain(population_neuron0[47:32]),  .ok1(ok1),  .ok2(ok2x[3*17 +: 17]), .ep_addr(8'h23)   );    
        
        okWireOut wo24 (    .ep_datain(variable_synaptic_strength0[15:0]),  .ok1(ok1),  .ok2(ok2x[4*17 +: 17]), .ep_addr(8'h24)    );
        okWireOut wo25 (    .ep_datain(variable_synaptic_strength0[31:16]),  .ok1(ok1),  .ok2(ok2x[5*17 +: 17]), .ep_addr(8'h25)   );    
        
        okWireOut wo26 (    .ep_datain(delta_w_ltp[15:0]),  .ok1(ok1),  .ok2(ok2x[6*17 +: 17]), .ep_addr(8'h26)    );
        okWireOut wo27 (    .ep_datain(delta_w_ltp[31:16]),  .ok1(ok1),  .ok2(ok2x[7*17 +: 17]), .ep_addr(8'h27)   );    
        
        okWireOut wo28 (    .ep_datain(each_I_synapse0[15:0]),  .ok1(ok1),  .ok2(ok2x[8*17 +: 17]), .ep_addr(8'h28)    );
        okWireOut wo29 (    .ep_datain(each_I_synapse0[31:16]),  .ok1(ok1),  .ok2(ok2x[9*17 +: 17]), .ep_addr(8'h29)   );    
        
        okWireOut wo2a (    .ep_datain(population_neuron1[31:16]),  .ok1(ok1),  .ok2(ok2x[10*17 +: 17]), .ep_addr(8'h2a)    );
        okWireOut wo2b (    .ep_datain(population_neuron1[47:32]),  .ok1(ok1),  .ok2(ok2x[11*17 +: 17]), .ep_addr(8'h2b)   );    
        
        okWireOut wo2c (    .ep_datain(variable_synaptic_strength1[15:0]),  .ok1(ok1),  .ok2(ok2x[12*17 +: 17]), .ep_addr(8'h2c)    );
        okWireOut wo2d (    .ep_datain(variable_synaptic_strength1[31:16]),  .ok1(ok1),  .ok2(ok2x[13*17 +: 17]), .ep_addr(8'h2d)   );    
        
        okWireOut wo2e (    .ep_datain(v_neuron1[15:0]),  .ok1(ok1),  .ok2(ok2x[14*17 +: 17]), .ep_addr(8'h2e)    );
        okWireOut wo2f (    .ep_datain(v_neuron1[31:16]),  .ok1(ok1),  .ok2(ok2x[15*17 +: 17]), .ep_addr(8'h2f)   );    
        
        okWireOut wo30 (    .ep_datain(each_I_synapse1[15:0]),  .ok1(ok1),  .ok2(ok2x[16*17 +: 17]), .ep_addr(8'h30)    );
        okWireOut wo31 (    .ep_datain(each_I_synapse1[31:16]),  .ok1(ok1),  .ok2(ok2x[17*17 +: 17]), .ep_addr(8'h31)   );    
        
        okWireOut wo32 (    .ep_datain(population_neuron2[31:16]),  .ok1(ok1),  .ok2(ok2x[18*17 +: 17]), .ep_addr(8'h32)    );
        okWireOut wo33 (    .ep_datain(population_neuron2[47:32]),  .ok1(ok1),  .ok2(ok2x[19*17 +: 17]), .ep_addr(8'h33)   );    
        
        okWireOut wo34 (    .ep_datain(variable_synaptic_strength2[15:0]),  .ok1(ok1),  .ok2(ok2x[20*17 +: 17]), .ep_addr(8'h34)    );
        okWireOut wo35 (    .ep_datain(variable_synaptic_strength2[31:16]),  .ok1(ok1),  .ok2(ok2x[21*17 +: 17]), .ep_addr(8'h35)   );    
        
        okWireOut wo36 (    .ep_datain(each_I_synapse2[15:0]),  .ok1(ok1),  .ok2(ok2x[22*17 +: 17]), .ep_addr(8'h36)    );
        okWireOut wo37 (    .ep_datain(each_I_synapse2[31:16]),  .ok1(ok1),  .ok2(ok2x[23*17 +: 17]), .ep_addr(8'h37)   );    
        
        okWireOut wo38 (    .ep_datain(population_neuron3[31:16]),  .ok1(ok1),  .ok2(ok2x[24*17 +: 17]), .ep_addr(8'h38)    );
        okWireOut wo39 (    .ep_datain(population_neuron3[47:32]),  .ok1(ok1),  .ok2(ok2x[25*17 +: 17]), .ep_addr(8'h39)   );    
        
        okWireOut wo3a (    .ep_datain(variable_synaptic_strength3[15:0]),  .ok1(ok1),  .ok2(ok2x[26*17 +: 17]), .ep_addr(8'h3a)    );
        okWireOut wo3b (    .ep_datain(variable_synaptic_strength3[31:16]),  .ok1(ok1),  .ok2(ok2x[27*17 +: 17]), .ep_addr(8'h3b)   );    
        
        okWireOut wo3c (    .ep_datain(neuron2_input[15:0]),  .ok1(ok1),  .ok2(ok2x[28*17 +: 17]), .ep_addr(8'h3c)    );
        okWireOut wo3d (    .ep_datain(neuron2_input[31:16]),  .ok1(ok1),  .ok2(ok2x[29*17 +: 17]), .ep_addr(8'h3d)   );    
        
        okWireOut wo3e (    .ep_datain(each_I_synapse3[15:0]),  .ok1(ok1),  .ok2(ok2x[30*17 +: 17]), .ep_addr(8'h3e)    );
        okWireOut wo3f (    .ep_datain(each_I_synapse3[31:16]),  .ok1(ok1),  .ok2(ok2x[31*17 +: 17]), .ep_addr(8'h3f)   );    
        //okBTPipeIn ep82 (   .ok1(ok1), .ok2(ok2x[19*17 +: 17]), .ep_addr(8'h82), .ep_write(pipe_in_write_timeref),
         //                   .ep_blockstrobe(), .ep_dataout(pipe_in_data_timeref), .ep_ready(1'b1));
        okBTPipeIn ep80 (   .ok1(ok1), .ok2(ok2x[32*17 +: 17]), .ep_addr(8'h80), .ep_write(pipe_in_write),
                            .ep_blockstrobe(), .ep_dataout(pipe_in_data), .ep_ready(1'b1));
        okBTPipeIn ep82 (   .ok1(ok1), .ok2(ok2x[34*17 +: 17]), .ep_addr(8'h82), .ep_write(pipe_in_write_2),
                            .ep_blockstrobe(), .ep_dataout(pipe_in_data_2), .ep_ready(1'b1));
                     
        okBTPipeOut epA0 (.ok1(ok1), .ok2(ok2x[36*17 +: 17]), .ep_addr(8'ha0), .ep_datain(variable_synaptic_strength0[15:0]), .ep_read(pipe_out_read),
                                .ep_blockstrobe(), .ep_ready(1'b1));
        okBTPipeOut epA2 (.ok1(ok1), .ok2(ok2x[38*17 +: 17]), .ep_addr(8'ha2), .ep_datain(variable_synaptic_strength0[31:16]), .ep_read(pipe_out_read),
                                .ep_blockstrobe(), .ep_ready(1'b1));                        

        // Clock Generator clk_gen0 Instance Definition
        gen_clk clocks(
            .rawclk(clk1),
            .half_cnt(triggered_input5),
            .clk_out1(neuron_clk),
            .clk_out2(sim_clk),
            .clk_out3(spindle_clk),
            .int_neuron_cnt_out()
        );
                
        // time tagging       
       reg [31:0] i_time;

        always @(posedge sim_clk or posedge reset_global)
         begin
           if (reset_global)
            begin
              i_time <= 32'd0;
            end else begin
              i_time <= i_time + 1; 
            end
          end
        
//    
//       wire [31:0] SN_Ia_rand_out;
//       rng rng_SN_Ia(               
//          .clk1(neuron_clk),
//          .clk2(neuron_clk),
//          .reset(reset_sim),
//          .out(SN_Ia_rand_out)
//        );     
        
//       wire [31:0] i_rng_current_to_SN_Ia;
//       assign i_rng_current_to_SN_Ia= {fixed_Ia_spindle0[31:10] , SN_Ia_rand_out[11:0]}; // randomness
//       assign i_rng_current_to_SN_Ia= fixed_Ia_spindle0;  // no randomness
       
       
//       wire [31:0] SN_II_rand_out;
//       rng rng_SN_II(               
//          .clk1(neuron_clk),
//          .clk2(neuron_clk),
//          .reset(reset_sim),
//          .out(SN_II_rand_out)
//        );     
//        
//       wire [31:0] i_rng_current_to_SN_II;
//       assign i_rng_current_to_SN_II= {fixed_II_spindle0[31:10] , SN_II_rand_out[11:0]};
//       assign i_rng_current_to_SN_II= fixed_II_spindle0;  // no randomness
        
        wire [31:0]  i_mixed_input0;
        floor   float_to_int1(
            .in(mixed_input0),
            .out(i_mixed_input0)
        );
        
        wire [31:0]  i_mixed_input2;
        floor   float_to_int2(
            .in(mixed_input2),
            .out(i_mixed_input2)
        );


    
        //Control input to neuron 2 (e.g. ambliopia)
        //wire [31:0] i_mixed_input2_scaled;
        //unsigned_mult32 mult_changeNeuron2(.out(i_mixed_input2_scaled), .a(i_mixed_input2), .b(sync_scale));

        
        wire [31:0] neuron0_input;
        assign neuron0_input = is_from_trigger? triggered_input0 :i_mixed_input0;
        wire [31:0] neuron2_input;
        assign neuron2_input = is_from_trigger? triggered_input0: flag_sync_inputs? i_mixed_input0: i_mixed_input2;
        
//        // randomization of input current 
//        wire [31:0] rand_n01;
//        rng randomize_n0Input(
//                .clk1(neuron_clk),
//                .clk2(neuron_clk),
//                .reset(reset_sim),
//                .out(rand_n01)
//               
//        );
//        wire [31:0] i_rng_current_to_neuron0;
//        assign i_rng_current_to_neuron0= {i_mixed_input0[31:12] , rand_n01[11:0]};
//        
//         wire [31:0] rand_n02;
//        rng randomize_n2Input(
//                .clk1(neuron_clk),
//                .clk2(neuron_clk),
//                .reset(reset_sim),
//                .out(rand_n02)
//               
//        );
//        wire [31:0] i_rng_current_to_neuron2;
//        assign i_rng_current_to_neuron2= {i_mixed_input2[31:12] , rand_n02[11:0]};    
        
        // Neuron neuron0 Instance Definition 
        izneuron_th_control neuron0(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_sim),           // reset to initial conditions
            .I_in( (block_neuron1)? 32'd0 : i_mixed_input0),          // input current from synapse
            .th_scaled(32'd30720),            // default 30mv threshold scaled x1024
            .v_out(v_neuron0),               // membrane potential
            .spike(spike_neuron0),           // spike sample
            .each_spike(each_spike_neuron0), // raw spikes
            .population(population_neuron0)  // spikes of population per 1ms simulation time
        );
        
        
        
        
       // Neuron neuron1 Instance Definition 
        izneuron_th_control neuron1(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_sim),           // reset to initial conditions
            .I_in(  (each_I_synapse0) + (each_I_synapse2)  ),          // input current from synapse. crosstalk contribution smaller.
            .th_scaled(32'd30720),            // default 30mv threshold scaled x1024
            .v_out(v_neuron1),               // membrane potential
            .spike(spike_neuron1),           // spike sample
            .each_spike(each_spike_neuron1), // raw spikes
            .population(population_neuron1)  // spikes of population per 1ms simulation time
        );
        
        
        wire [31:0] neuron0_input_scaled;
        //scale the sync amplitude between two neuron inputs  
        //unsigned_mult32 mult0(.out(neuron0_input_scaled), .a(neuron0_input), .b(sync_scale));
        //wire [31:0] neuron2_input;
        //assign neuron2_input =  (neuron2_input_offset)? neuron2_input_offset-neuron0_input_scaled: neuron0_input_scaled; //if non-zero offset, make subtraction. if zero offset, do nothing
        
        
        // Neuron neuron2 Instance Definition       
        izneuron_th_control neuron2(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_sim),           // reset to initial conditions
            .I_in( (block_neuron2)? 32'd0 : i_mixed_input2 ),          // input current from synapse
            .th_scaled(32'd30720),            // default 30mv threshold scaled x1024
            .v_out(v_neuron2),               // membrane potential
            .spike(spike_neuron2),           // spike sample
            .each_spike(each_spike_neuron2), // raw spikes
            .population(population_neuron2)  // spikes of population per 1ms simulation time
        );
        
        // Neuron neuron3 Instance Definition 
         izneuron_th_control neuron3(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_sim),           // reset to initial conditions
            .I_in(  (each_I_synapse1) + (each_I_synapse3) ),          // input current from synapse crosstalk contribution smaller.
            .th_scaled(32'd30720),            // default 30mv threshold scaled x1024
            .v_out(v_neuron3),               // membrane potential
            .spike(spike_neuron3),           // spike sample
            .each_spike(each_spike_neuron3), // raw spikes
            .population(population_neuron3)  // spikes of population per 1ms simulation time
        );
        
        
     wire [31:0]  spike_count_0_normal;
      spike_counter  sync_counter_0
      (                 .clk(neuron_clk),
                        .reset(reset_sim),
                        .spike_in(each_spike_neuron0),
                        .spike_count(spike_count_0_normal) );
//
//      
//
//                        
      wire [31:0]  spike_count_1_normal;
      spike_counter  sync_counter_1
      (                 .clk(neuron_clk),
                        .reset(reset_sim),
                        .spike_in(each_spike_neuron1),
                        .spike_count(spike_count_1_normal) );
//
//    wire [31:0]  spike_count_2_normal;
//      spike_counter  sync_counter_2
//      (                 .clk(neuron_clk),
//                        .reset(reset_sim),
//                        .spike_in(each_spike_neuron2),
//                        .spike_count(spike_count_2_normal) );
//                        
//     wire [31:0]  spike_count_3_normal;
//      spike_counter  sync_counter_3
//      (                 .clk(neuron_clk),
//                        .reset(reset_sim),
//                        .spike_in(each_spike_neuron3),
//                        .spike_count(spike_count_3_normal) );                   
                        


// Synapse synapse0 Instance Definition
        
    assign synaptic_strength_synapse0 = 32'd10240<<<1; // baseline synaptic strength
     wire [31:0] variable_synaptic_strength0;
     wire [31:0] delta_w_ltp;
    synapse_stdp_eric synapse0(
        .clk(neuron_clk),                           // neuron clock (128 cycles per 1ms simulation time)
        .reset(reset_sim),                       // reset synaptic weights
        .spike_in(each_spike_neuron0),             // spike from presynaptic neuron
        .postsynaptic_spike_in(each_spike_neuron1),   //spike from postsynaptic neuron
        
        
        .I_out(I_synapse0),                           // sample of synaptic current out
        .synaptic_strength(variable_synaptic_strength0),                           // sample of synaptic current out
        .delta_w_ltp(delta_w_ltp),
        .each_I(each_I_synapse0),                      // raw synaptic currents
        .base_strength(synaptic_strength_synapse0) , // baseline synaptic strength              
    
        .ltp_scale(triggered_input2),                        // long term potentiation weight
        .ltd_scale(triggered_input3),                        // long term depression weight
        .p_delta(triggered_input4)                 // chance for decay 
    );
    

    // Synapse synapse1 Instance Definition
    
    assign synaptic_strength_synapse1 = 32'd10240>>>1; // baseline synaptic strength
    wire [31:0] variable_synaptic_strength1;
    synapse_stdp_eric synapse1(
        .clk(neuron_clk),                           // neuron clock (128 cycles per 1ms simulation time)
        .reset(reset_sim),                       // reset synaptic weights
        .spike_in(cut_synapse1? each_spike_neuron0:32'd0),             // spike from presynaptic neuron
        .postsynaptic_spike_in(each_spike_neuron3),   //spike from postsynaptic neuron
        .I_out(I_synapse1),                           // sample of synaptic current out
        .synaptic_strength(variable_synaptic_strength1),                           // sample of synaptic current out
        .each_I(each_I_synapse1),                      // raw synaptic currents
        
        .base_strength(synaptic_strength_synapse1),  // baseline synaptic strength              
    
        .ltp_scale(triggered_input2),                        // long term potentiation weight
        .ltd_scale(triggered_input3),                        // long term depression weight
        .p_delta(triggered_input4)                 // chance for decay 
    );
    
//
    // Synapse synapse2 Instance Definition
    
    assign synaptic_strength_synapse2 = 32'd10240>>>1; // baseline synaptic strength
    wire [31:0] variable_synaptic_strength2;
    synapse_stdp_eric synapse2(
        .clk(neuron_clk),                           // neuron clock (128 cycles per 1ms simulation time)
        .reset(reset_sim),                       // reset synaptic weights
        .spike_in(cut_synapse2? each_spike_neuron2:32'd0),             // spike from presynaptic neuron
        .postsynaptic_spike_in(each_spike_neuron1),   //spike from postsynaptic neuron
        .I_out(I_synapse2),                           // sample of synaptic current out
        .synaptic_strength(variable_synaptic_strength2),                           // sample of synaptic current out
        .each_I(each_I_synapse2),                      // raw synaptic currents
        
        .base_strength(synaptic_strength_synapse2),  // baseline synaptic strength              
    
        .ltp_scale(triggered_input2),                        // long term potentiation weight
        .ltd_scale(triggered_input3),                        // long term depression weight
        .p_delta(triggered_input4)                 // chance for decay 
    );
    

    // Synapse synapse3 Instance Definition
    
    assign synaptic_strength_synapse3 = 32'd10240<<<1; // baseline synaptic strength
     wire [31:0] variable_synaptic_strength3;
    synapse_stdp_eric synapse3(
        .clk(neuron_clk),                           // neuron clock (128 cycles per 1ms simulation time)
        .reset(reset_sim),                       // reset synaptic weights
        .spike_in(each_spike_neuron2),             // spike from presynaptic neuron
        .postsynaptic_spike_in(each_spike_neuron3),   //spike from postsynaptic neuron
        .I_out(I_synapse3),                           // sample of synaptic current out
        .synaptic_strength(variable_synaptic_strength3),                           // sample of synaptic current out
        .each_I(each_I_synapse3),                      // raw synaptic currents
        
        .base_strength(synaptic_strength_synapse3),  // baseline synaptic strength              
    
        .ltp_scale(triggered_input2),                        // long term potentiation weight
        .ltd_scale(triggered_input3),                        // long term depression weight
        .p_delta(triggered_input4)                 // chance for decay 
    );


/////////////////////// END INSTANCE DEFINITIONS //////////////////////////

	// ** LEDs
    assign led[0] = ~reset_global;
    assign led[1] = ~reset_sim;
    assign led[2] = ~each_spike_neuron0;
    assign led[3] = ~each_spike_neuron1;
    assign led[4] = ~each_spike_neuron2;
    assign led[5] = ~each_spike_neuron3;
    assign led[6] = ~neuron_clk; // 
    assign led[7] = ~sim_clk; // clock
    
endmodule
