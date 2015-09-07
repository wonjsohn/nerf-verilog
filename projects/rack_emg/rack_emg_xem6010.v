`default_nettype none
`timescale 1ns / 1ps

// rack_mn_muscle_xem6010.v
// Generated on Tue Mar 12 15:55:13 -0700 2013

    module rack_emg_xem6010(
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
        wire reset_global, reset_sim;
        wire is_from_trigger;

        // *** Target interface bus:
        assign i2c_sda = 1'bz;
        assign i2c_scl = 1'bz;
        assign hi_muxsel = 1'b0;
    
  
        wire [31:0] threshold30mv;  // iz neuron threshold 
        assign threshold30mv = 32'd30;
    
      
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
        //reg [31:0] triggered_input4;    // Triggered input sent from USB (p_delta)       
        

        // Triggered Input triggered_input5 Wire Definitions
        reg [31:0] triggered_input5;    // Triggered input sent from USB (syn_gain)       
        

        // Triggered Input triggered_input6 Wire Definitions
        reg [31:0] triggered_input6;    // Triggered input sent from USB (clk_divider)  
        reg [31:0] triggered_input7; 
        reg [31:0] triggered_input8; 
//        reg [31:0] triggered_input9; 
//        reg [31:0] triggered_input10; 
//        reg [31:0] triggered_input11; 
        

        // Spike Counter spike_counter0 Wire Definitions
        wire [31:0] spike_count_neuron0;
        

        // Waveform Generator mixed_input0 Wire Definitions
        wire [31:0] mixed_input0;   // Wave out signal
        

    // FPGA Input/Output Rack Wire Definitions
    // these are in the top module input/output list
    

        // Output and OpalKelly Interface Wire Definitions
        
        wire [27*17-1:0] ok2x;
        wire [15:0] ep00wire, ep01wire, ep02wire, ep03wire, ep04wire, ep05wire, ep06wire, ep07wire, ep08wire;
        wire [15:0] ep50trig;
        
        wire pipe_in_write;
        wire [15:0] pipe_in_data;
        
        wire pipe_in_write_timeref;
        wire [15:0] pipe_in_data_timeref;
        

        // Muscle muscle0 Wire Definitions
        wire [31:0] total_force_out_muscle0;
        wire [31:0] current_A_muscle0;
        wire [31:0] current_fp_spikes_muscle0;
        

        // Clock Generator clk_gen0 Wire Definitions
        wire neuron_clk;  // neuron clock (128 cycles per 1ms simulation time) 
        wire sim_clk;     // simulation clock (1 cycle per 1ms simulation time)
        wire spindle_clk; // spindle clock (3 cycles per 1ms simulation time)
        
        //synapse in-out
        wire each_spike_neuron0;
        wire spike_count_neuron0_sync;

        // Motoneurons Wire Definitions
        wire [31:0] v_neuron_MN1;   // membrane potential
        wire spike_neuron_MN1;      // spike sample for visualization only
        wire each_spike_neuron_MN1; // raw spike signals
        wire [127:0] population_neuron_MN1; // spike raster for entire population        
        
        wire [31:0] v_neuron_MN2;   // membrane potential
        wire spike_neuron_MN2;      // spike sample for visualization only
        wire each_spike_neuron_MN2; // raw spike signals
        wire [127:0] population_neuron_MN2; // spike raster for entire population       
        
        wire [31:0] v_neuron_MN3;   // membrane potential
        wire spike_neuron_MN3;      // spike sample for visualization only
        wire each_spike_neuron_MN3; // raw spike signals
        wire [127:0] population_neuron_MN3; // spike raster for entire population       
        
        wire [31:0] v_neuron_MN4;   // membrane potential
        wire spike_neuron_MN4;      // spike sample for visualization only
        wire each_spike_neuron_MN4; // raw spike signals
        wire [127:0] population_neuron_MN4; // spike raster for entire population       
        
        wire [31:0] v_neuron_MN5;   // membrane potential
        wire spike_neuron_MN5;      // spike sample for visualization only
        wire each_spike_neuron_MN5; // raw spike signals
        wire [127:0] population_neuron_MN5; // spike raster for entire population      
        
        wire [31:0] v_neuron_MN6;   // membrane potential
        wire spike_neuron_MN6;      // spike sample for visualization only
        wire each_spike_neuron_MN6; // raw spike signals
        wire [127:0] population_neuron_MN6; // spike raster for entire population      
        
//        wire [31:0] v_neuron_MN7;   // membrane potential
//        wire spike_neuron_MN7;      // spike sample for visualization only
//        wire each_spike_neuron_MN7; // raw spike signals
//        wire [127:0] population_neuron_MN7; // spike raster for entire population      
//        
        
/////////////////////// END WIRE DEFINITIONS //////////////////////////////

/////////////////////// BEGIN INSTANCE DEFINITIONS ////////////////////////



        // Triggered Input triggered_input0 Instance Definition (lce & vel _ from PXI)
        reg [31:0] f_len_pxi_F0, f_velocity_F0, i_extraMN_drive, i_extraMN2_drive;
        always @ (posedge ep50trig[9] or posedge reset_global)
        if (reset_global) begin
            f_len_pxi_F0 <= 32'h3F800000;         //reset to 1.0    
            f_velocity_F0 <= 32'h0;         //reset to 0   
            i_extraMN_drive <= 32'h0;             
            i_extraMN2_drive <= 32'h0;            
        end
        else  begin
            f_len_pxi_F0 <= {ep02wire, ep01wire};  
            f_velocity_F0 <= {ep04wire, ep03wire};         
            i_extraMN_drive <= {ep06wire, ep05wire};             
            i_extraMN2_drive <= {ep08wire, ep07wire};             
        end

        // Triggered Input triggered_input1 Instance Definition (tau)
        always @ (posedge ep50trig[2] or posedge reset_global)
        if (reset_global)
            triggered_input1 <= 32'h3cf5c28f;         //reset to 0.03      
        else
            triggered_input1 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input2 Instance Definition (synapse offset)
        always @ (posedge ep50trig[12] or posedge reset_global)
        if (reset_global)
            triggered_input2 <= 32'h0;         //reset to 0.0      
        else
            triggered_input2 <= {ep02wire, ep01wire};      
        

//        // Triggered Input triggered_input3 Instance Definition (ltd)
//        always @ (posedge ep50trig[11] or posedge reset_global)
//        if (reset_global)
//            triggered_input3 <= 32'd0;         //reset to 0      
//        else
//            triggered_input3 <= {ep02wire, ep01wire};      
            
            
        // Triggered Input triggered_input3 Instance Definition 
        reg [31:0] f_syn2_gain;
        always @ (posedge ep50trig[11] or posedge reset_global)
        if (reset_global)
            f_syn2_gain <= 32'h420c0000;         //reset to 60.0 -> 35    
        else
            f_syn2_gain <= {ep02wire, ep01wire};    

            
        // Triggered Input CN synapse Instance Definition 
        reg [31:0] f_CN_syn_gain;
        always @ (posedge ep50trig[10] or posedge reset_global)
        if (reset_global)
<<<<<<< HEAD
            f_CN_syn_gain <= 32'h42480000;         //reset to 200.0  -> 50 
=======
            f_CN_syn_gain <= 32'h42480000;         //reset to 50.0  
>>>>>>> development
        else
            f_CN_syn_gain <= {ep02wire, ep01wire};    


//        // Triggered Input extra CNs Gain Instance Definition 
//        reg [31:0] f_extraCN_syn_gain;
//        always @ (posedge ep50trig[13] or posedge reset_global)
//        if (reset_global)
//            f_extraCN_syn_gain <= 32'h42480000;         //reset to 50.0  
//        else
//            f_extraCN_syn_gain <= {ep02wire, ep01wire};    

        
//        reg [31:0] triggered_input4_a;    //
//        reg [31:0] triggered_input4_b;    //
//        reg [31:0] triggered_input4_c;    //
//        reg [31:0] triggered_input4_d;    //
//        reg [31:0] triggered_input4_e;    //
//        reg [31:0] triggered_input4_f;    //
//        reg [31:0] triggered_input4_g;    //
//        // Triggered Input triggered_input4 Instance Definition (threshold)
//        always @ (posedge ep50trig[10] or posedge reset_global)
//        if (reset_global) begin
//            triggered_input4_a <= 32'd30;         //reset to 0      
//            triggered_input4_b <= 32'd0;         //reset to 0  
//            triggered_input4_c <= 32'd0;         //reset to 0      
//            triggered_input4_d <= 32'd0;         //reset to 0      
//            triggered_input4_e <= 32'd0;         //reset to 0      
//            triggered_input4_f <= 32'd0;         //reset to 0    
//            triggered_input4_g <= 32'd0;         //reset to 0                 
//        end
//        else begin
//            triggered_input4_a <= {ep02wire, ep01wire};        //to implement size principle. progressively decreasing threshold.
//            triggered_input4_b <= {ep02wire, ep01wire} - 32'd2; 
//            triggered_input4_c <= {ep02wire, ep01wire} - 32'd4;
//            triggered_input4_d <= {ep02wire, ep01wire} - 32'd6;
//            triggered_input4_e <= {ep02wire, ep01wire} - 32'd8;
//            triggered_input4_f <= {ep02wire, ep01wire} - 32'd10;
//            triggered_input4_g <= {ep02wire, ep01wire} - 32'd12;
//        end

        // Triggered Input triggered_input5 Instance Definition (syn1_gain)
        always @ (posedge ep50trig[3] or posedge reset_global)
        if (reset_global)
            triggered_input5 <= 32'h420c0000;         // gain 60.0 -> 35    
        else
            triggered_input5 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input6 Instance Definition (clk_divider)
        always @ (posedge ep50trig[7] or posedge reset_global)
        if (reset_global)
            triggered_input6 <= 32'd381;     //half count for 0.5x real speed, 381 for real time speed  ;         //reset to triggered_input6      
        else
            triggered_input6 <= {ep02wire, ep01wire};      
            
            
        
//      0.001524 z^2 - 0.001555 z 
//        -------------------------------------
//       z^3 - 2.566 z^2 + 2.195 z - 0.6258    


//tf_sym = subs(s_domain, {a,b,c}, {3, -200, -140})% 
//positive lobe > negative lobe (10/26/14 - Eric)
//Transfer function:
//0.002389 z^2 - 0.002374 z - 1.054e-18
//-------------------------------------
// z^3 - 2.617 z^2 + 2.282 z - 0.6635

//tf_sym = subs(s_domain, {a,b,c}, {2, -200, -170})% 
//positive lobe > negative lobe (10/27/14 - Eric)
//Transfer function:
//0.001493 z^2 - 0.001538 z - 6.831e-19
//-------------------------------------
// z^3 - 2.541 z^2 + 2.152 z - 0.6077
        
        // b1
        always @ (posedge ep50trig[1] or posedge reset_global)
        if (reset_global)
            //triggered_input7 <= 32'h3AA24463;     //0.001238 (b1 default) 
            triggered_input7 <= 32'h3B1C90C5;      // 0.002389 (b1 default) 1
            //triggered_input7 <= 32'h3AC3B0C4;       // 0.001493  (b1 default)   2
        else
            triggered_input7 <= {ep02wire, ep01wire};      
            //        .b1_F0(32'h3A9E55C1),      //0.001208 (b1 default)
//        .b2_F0(32'hBAA6DACB),       //-0.001273 (b2 default)
//        .a1_F0(32'hC00F3B64),       //- 2.238 (a1 default)
//        .a2_F0(32'h3FD5C28F),       //1.67 (a2 default)
//        .a3_F0(32'hBED49518),       // - 0.4152 (a3 default)
//        .clk(sim_clk), 
            
        // b2
        always @ (posedge ep50trig[4] or posedge reset_global)
        if (reset_global)
            //triggered_input8 <= 32'hBAA6DACB;     //-0.001273 (b2 default)  
            //triggered_input8 <= 32'hBB1B951C;       // -0.002374 (b2 default)  1
            //triggered_input8 <= 32'hBAC996B7;       // - 0.001538 (b2 default)  2
            triggered_input8 <= 32'hBB2222D5;//-0.0024740 (1, 2, b2 default, makes difference in level upon tonic. 
        else
            triggered_input8 <= {ep02wire, ep01wire};  

        // a1
//        always @ (posedge ep50trig[5] or posedge reset_global)
//        if (reset_global)
//            triggered_input9 <= 32'hC00F3B64;     //- 2.238 (a1 default)
//        else
//            triggered_input9 <= {ep02wire, ep01wire};   

//        // a2
//        always @ (posedge ep50trig[6] or posedge reset_global)
//        if (reset_global)
//            triggered_input10 <= 32'h3FD5C28F;     //1.67 (a2 default)
//        else
//            triggered_input10 <= {ep02wire, ep01wire};   

        // s_weight
        reg [31:0] apply_s_weight;
        always @ (posedge ep50trig[6] or posedge reset_global)
        if (reset_global)
            apply_s_weight <= 32'h0;     //
        else
            apply_s_weight <= {ep02wire, ep01wire};  

//        // a3
//        always @ (posedge ep50trig[8] or posedge reset_global)
//        if (reset_global)
//            triggered_input11 <= 32'hBED49518;     // - 0.4152(a3 default)
//        else
//            triggered_input11 <= {ep02wire, ep01wire};   
        
        //a1
        wire [31:0] triggered_input9; 
        wire [31:0] triggered_input10; 
        wire [31:0] triggered_input11; 
        //assign triggered_input9 = 32'hC00F3B64;     //- 2.238 (a1 default)
       assign triggered_input9 = 32'hC0277CEE;     //-2.617(a1 default)  1
       //assign triggered_input9 = 32'hC0229FBE;  // -2.541(a1 default)    2
        //a2
        //assign triggered_input10 = 32'h3FD5C28F;     //1.67 (a2 default)
        assign triggered_input10 = 32'h40120C4A;   //2.282 (a2 default)     1
        //assign triggered_input10 = 32'h4009BA5E;   //2.152  (a2 default)     2
        //a3 
//        assign triggered_input11 = 32'hBED49518; // - 0.4152(a3 default)
        assign triggered_input11 = 32'hBF29DB23;    // -0.6635(a3 default)   1
       //assign triggered_input11 = 32'hBF1B923A;    // -0.6077 (a3 default)     2
        
        
        reg [31:0] i_MN_offset; 
        always @ (posedge ep50trig[8] or posedge reset_global)
        if (reset_global)
            i_MN_offset <= 32'd0;     
        else
            i_MN_offset <= {ep02wire, ep01wire}; 



//     wire [31:0]  i_spike_count_neuron_sync_inputPin;
//      spike_counter  sync_counter_input
//      (                 .clk(neuron_clk),
//                        .reset(reset_sim),
//                        .spike_in(spikein1),
//                        .spike_count(i_spike_count_neuron_sync_inputPin) );   
            
       //** latch the inputs

    reg [31:0] f_len_pxi; 
    reg [31:0] f_velocity;
    always @(posedge sim_clk or posedge reset_global)
	 begin
	   if (reset_global)
		begin
		  f_len_pxi <= 32'h3F800000;  // reset to 1.0
          f_velocity <= 32'h0;         // reset to 0
		end else begin
		  f_len_pxi <= f_len_pxi_F0;
          f_velocity <= f_velocity_F0;
		end
	 end       
            
  
       // latching 
    reg [31:0] i_I_drive_to_MN;
    always @(posedge sim_clk or posedge reset_global)
	 begin
	   if (reset_global)
		begin
		  i_I_drive_to_MN <= 32'h0;
		end else begin
		  i_I_drive_to_MN <= i_I_drive_to_MN_F0;
         end
      end
            
         



//        wire [31:0] v_neuron_CN1;   // membrane potential
//        wire spike_neuron_CN1;      // spike sample for visualization only
//        wire each_spike_neuron_CN1; // raw spike signals
//        wire [127:0] population_neuron_CN1; // spike raster for entire population      
//        
//            
//        // Extra CN2 input - spikified sine wave (Goes to CN) 
//           izneuron_th_control CN1(
//            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
//            .reset(reset_sim),           // reset to initial conditions
//            .I_in( i_extraMN_drive ),          // input current from synapse
//            .th_scaled( triggered_input4_a <<< 10),                 // threshold
//            .v_out(v_neuron_CN1),               // membrane potential
//            .spike(spike_neuron_CN1),           // spike sample
//            .each_spike(each_spike_neuron_CN1), // raw spikes
//            .population(population_neuron_CN1)  // spikes of population per 1ms simulation time
//        );    



//         
//         wire [31:0] v_neuron_CN2;   // membrane potential
//        wire spike_neuron_CN2;      // spike sample for visualization only
//        wire each_spike_neuron_CN2; // raw spike signals
//        wire [127:0] population_neuron_CN2; // spike raster for entire population      
//        
//            
//        // Extra CN2 input - spikified sine wave (Goes to CN) 
//           izneuron_th_control CN2(
//            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
//            .reset(reset_sim),           // reset to initial conditions
//            .I_in( i_extraMN2_drive ),          // input current from synapse
//            .th_scaled( triggered_input4_a <<< 10),                 // threshold
//            .v_out(v_neuron_CN2),               // membrane potential
//            .spike(spike_neuron_CN2),           // spike sample
//            .each_spike(each_spike_neuron_CN2), // raw spikes
//            .population(population_neuron_CN2)  // spikes of population per 1ms simulation time
//        );    
            
            
            
//        // Synapse synapse0 Instance Definition
//        synapse_stdp synapse0(
//            .clk(neuron_clk),                           // neuron clock (128 cycles per 1ms simulation time)
//            .reset(reset_global),                       // reset synaptic weights
//            .spike_in(spikein1),             // spike from presynaptic neuron
//            //.postsynaptic_spike_in(each_spike_neuron0),   //spike from postsynaptic neuron
//            .I_out(I_synapse0),                           // sample of synaptic current out
//            .each_I(each_I_synapse0)                      // raw synaptic current 
//            //.ltp(triggered_input2),                        // long term potentiation weight
//            //.ltd(triggered_input3),                        // long term depression weight
//            //.p_delta(32'd0)                 // chance for decay 
//        );
        
        wire [31:0] f_I_synapse_Ia;
        synapse_simple synapse_simple_from_Ia(
            .clk(sim_clk),
            .reset(reset_sim),
            .spike_in(spikein1),
            .f_I_out(f_I_synapse_Ia)
        );
        
        
         wire [31:0] f_I_synapse_II;
        synapse_simple synapse_simple_from_II(
            .clk(sim_clk),
            .reset(reset_sim),
            .spike_in(spikein2),
            .f_I_out(f_I_synapse_II)
        );
        
    
        
        wire [31:0] f_I_synapse_CN;
        synapse_simple synapse_simple_from_CN(
            .clk(sim_clk),
            .reset(reset_sim),
<<<<<<< HEAD
            .spike_in(spikein9|spikein10),
=======
            .spike_in(spikein9),
>>>>>>> development
            .f_I_out(f_I_synapse_CN)
        );
        
        
         
        //******************* synapse Ia output ****************************
        //Remove the offset in synapse output 
<<<<<<< HEAD
//        wire [31:0] f_temp_I_synapse_Ia_removed_offset;
//        sub sub_spindle0_Ia(.x(f_I_synapse_Ia), .y(triggered_input2), .out(f_temp_I_synapse_Ia_removed_offset));

=======
        wire [31:0] f_temp_I_synapse_Ia_removed_offset;
        sub sub_spindle0_Ia(.x(f_I_synapse_Ia), .y(triggered_input2), .out(f_temp_I_synapse_Ia_removed_offset));
	
>>>>>>> development
        //gain control for f_I_synapse_M1extra1synapse output
        wire [31:0] f_gain_controlled_I_synapse_Ia;
        mult mult_synapse_simple0_Ia(.x(f_I_synapse_Ia), .y(triggered_input5), .out(f_gain_controlled_I_synapse_Ia));

        // Ia Afferent datatype conversion (floating point -> integer -> fixed point)   
        wire [31:0] fixed_I_synapse;
        wire [31:0] int_I_synapse;
        wire [31:0] i_I_drive_to_MN_F0;
        
        
        
        //******************* synapse II output ****************************
        //Remove the offset in synapse output 
//        wire [31:0] f_temp_I_synapse_II_removed_offset;
//        sub sub_spindle0_II(.x(f_I_synapse_II), .y(triggered_input2), .out(f_temp_I_synapse_II_removed_offset));   //  Ia, II have same offset (change later if needed)
//	
        //gain control for synapse output
        wire [31:0] f_gain_controlled_I_synapse_II;
        mult mult_synapse_simple0_II(.x(f_I_synapse_II), .y(f_syn2_gain), .out(f_gain_controlled_I_synapse_II));

        
        //*********** add currents from two synapse (Ia, II)  *********
        wire [31:0] f_I_synapse_both;
        add addCurrentsFrom_Ia_and_II(.x(f_gain_controlled_I_synapse_Ia), .y(f_gain_controlled_I_synapse_II), .out(f_I_synapse_both));
        
        
        //gain control for CN synapse output
        wire [31:0] f_gain_controlled_I_synapse_CN;
        mult mult_synapse_simple0_CN(.x(f_I_synapse_CN), .y(f_CN_syn_gain), .out(f_gain_controlled_I_synapse_CN));

        
        
        //*********** add currents from extra cortical input CN *********
        wire [31:0] f_I_SNsCN;
        add addCurrentsFrom_CN(.x(f_gain_controlled_I_synapse_CN), .y(f_I_synapse_both), .out(f_I_SNsCN));
//        
        
       
        

//        
<<<<<<< HEAD
        wire [31:0]  i_drive_to_MN;
        floor   synapse_float_to_int(
//            .in(f_drive_to_MN),
            .in(f_I_SNsCN),
            .out(i_drive_to_MN)
        );

        
        // alpha drive to MN

        wire [31:0]  i_total_drive_to_MN;
        assign i_total_drive_to_MN = i_MN_offset + i_drive_to_MN;
        
        //wire [31:0] fixed_I_synapse;
        //assign fixed_I_synapse= int_I_synapse << 
        assign i_I_drive_to_MN_F0 = i_total_drive_to_MN[31]? 32'd0:i_total_drive_to_MN;// prevent negative current  // + i_extraMN_drive; 
=======
        wire [31:0]  i_drive_to_CN;
        floor   synapse_float_to_int(
//            .in(f_drive_to_CN),
            .in(f_I_SNsCN),
            .out(i_drive_to_CN)
        );

        
        //wire [31:0] fixed_I_synapse;
        //assign fixed_I_synapse= int_I_synapse << 
        assign i_I_drive_to_MN_F0 = i_drive_to_CN; // + i_extraMN_drive; 
>>>>>>> development
//        wire [31:0] int_I_synapse;
//        unsigned_mult32 synapse_simple1_gain(.out(int_I_synapse), .a(i_spike_count_neuron_sync_inputPin), .b(triggered_input5));    // I to each_I   
        
        //wire [31:0] int_I_synapse = i_spike_count_neuron_sync_inputPin << 10;

        
        //assign fixed_I_synapse = int_I_synapse <<< 6;
     
        
        // Synapse synapse0 Instance Definition
//        wire [17:0] si_I_synapse0;
//        synapse_int synapse0(
//            .clk(sim_clk),                           // neuron clock (128 cycles per 1ms simulation time)
//            .reset(reset_sim),                       // reset synaptic weights
//            .spk1(spikein1),             // spike from presynaptic neuron
//            .I_out(each_I_synapse0)                      // raw synaptic currents 
//        );

      //  wire [31:0] i_EPSC_synapse0;
      //  unsigned_mult32 synapse0_gain(.out(i_EPSC_synapse0), .a(each_I_synapse0), .b(triggered_input5));    // I to each_I     
      
        //unsigned_mult32 synapse0_gain(.out(i_EPSC_synapse0), .a({14'd0, si_I_synapse0[17:0]}), .b(triggered_input5));    // I to each_I     
      
      /// ******** EPSP_WEIGHT Variation factor (from monosyn_multiscale.mdl)   ************************
      // SIZE_MU_X = EPSP_WEIGHT.  THIS VALUE SCALES THE INPUT CURRENT TO IZN
      //SIZE_MU_1 =4.6724 (~1*75/16), SIZE_MU_2 = 3.0881, SIZE_MU_3= 2.3215, SIZE_MU_4 = 1.8718, SIZE_MU_5 = 1.5755, 
      //SIZE_MU_6 =1.3647, SIZE_MU_7 = 1.2067, SIZE_MU_8 = 1.0835, SIZE_MU_9 = 0.9845, SIZE_MU_10= 0.9031
     //SIZE_MU_11 =0.8349, SIZE_MU_12 = 0.7768, SIZE_MU_13 =0.7267, SIZE_MU_14= 0.6830, SIZE_MU_15 =0.6445
     //SIZE_MU_16 =0.6104, SIZE_MU_17 = 0.5798, SIZE_MU_18 =0.5523, SIZE_MU_19 =0.5274, SIZE_MU_20 = 0.5047
      /// **************************************************************************************************************************
      //1*75/16 = 4.4875 (MU1)  *
      //1*49/16 = 3.0625 (MU2)  *
      //1*37/16 = 2.3125 (MU3)
      //1*30/16 = 1.875  (MU4)  *
      //1*25/16 = 1.5625  (MU5)
      //1*22/16 = 1.375  (MU6)  
      //1*19/16 = 1.1875  (MU7)
      //1*17/16 =  1.0625 (MU8)  *
      //1*16/16 = 1 (MU9)
      //1*15/16 = 0.9375  (MU10)
      //1*14/16 = 0.875
      //1*13/16 = 0.8125  (MU11)  *
      //1*12/16 = 0.75    (MU12)  
      //1*11/16 =0.6875  (MU14)
      //1*10/16 = 0.625 (MU16)  *
      //1*9/16 = 0.5625 (MU17)  
      //1*8/16 = 0.5  (MU20)    *
   
<<<<<<< HEAD
     //parameter randomness = 10;
     
=======
   
>>>>>>> development
     wire [31:0] MN1_rand_out;
     rng rng_MN1(               
        .clk1(neuron_clk),
        .clk2(neuron_clk),
        .reset(reset_sim),
        .out(MN1_rand_out)
        ); 
        
       wire [31:0] i_rng_current_to_MN1;
<<<<<<< HEAD
       assign i_rng_current_to_MN1= {i_I_drive_to_MN[31:8] , MN1_rand_out[7:0]};
//        assign i_rng_current_to_MN1 = i_I_drive_to_MN;
=======
       assign i_rng_current_to_MN1= {i_I_drive_to_MN[31:6] , MN1_rand_out[5:0]};
        
>>>>>>> development
        
      wire [31:0] MN2_rand_out;
     rng rng_MN2(               
        .clk1(neuron_clk),
        .clk2(neuron_clk),
        .reset(reset_sim),
        .out(MN2_rand_out)
        ); 
        
       wire [31:0] i_rng_current_to_MN2;
<<<<<<< HEAD
       assign i_rng_current_to_MN2= {i_I_drive_to_MN[31:8] , MN2_rand_out[7:0]};
//       assign i_rng_current_to_MN2 = i_I_drive_to_MN;
=======
       assign i_rng_current_to_MN2= {i_I_drive_to_MN[31:6] , MN2_rand_out[5:0]};
       
>>>>>>> development
       
           wire [31:0] MN3_rand_out;
     rng rng_MN3(               
        .clk1(neuron_clk),
        .clk2(neuron_clk),
        .reset(reset_sim),
        .out(MN3_rand_out)
        ); 
        
       wire [31:0] i_rng_current_to_MN3;
<<<<<<< HEAD
       assign i_rng_current_to_MN3= {i_I_drive_to_MN[31:8] , MN3_rand_out[7:0]};
//       assign i_rng_current_to_MN3 = i_I_drive_to_MN;
=======
       assign i_rng_current_to_MN3= {i_I_drive_to_MN[31:6] , MN3_rand_out[5:0]};
>>>>>>> development

      wire [31:0] MN4_rand_out;
     rng rng_MN4(               
        .clk1(neuron_clk),
        .clk2(neuron_clk),
        .reset(reset_sim),
        .out(MN4_rand_out)
        ); 
        
       wire [31:0] i_rng_current_to_MN4;
<<<<<<< HEAD
       assign i_rng_current_to_MN4= {i_I_drive_to_MN[31:8] , MN4_rand_out[7:0]};
//       assign i_rng_current_to_MN4 = i_I_drive_to_MN;
=======
       assign i_rng_current_to_MN4= {i_I_drive_to_MN[31:6] , MN4_rand_out[5:0]};
>>>>>>> development

      wire [31:0] MN5_rand_out;
     rng rng_MN5(               
        .clk1(neuron_clk),
        .clk2(neuron_clk),
        .reset(reset_sim),
        .out(MN5_rand_out)
        ); 
        
       wire [31:0] i_rng_current_to_MN5;
<<<<<<< HEAD
       assign i_rng_current_to_MN5= {i_I_drive_to_MN[31:8] , MN5_rand_out[7:0]};
//    assign i_rng_current_to_MN5 = i_I_drive_to_MN;
=======
       assign i_rng_current_to_MN5= {i_I_drive_to_MN[31:6] , MN5_rand_out[5:0]};
>>>>>>> development

      wire [31:0] MN6_rand_out;
     rng rng_MN6(               
        .clk1(neuron_clk),
        .clk2(neuron_clk),
        .reset(reset_sim),
        .out(MN6_rand_out)
        ); 
        
       wire [31:0] i_rng_current_to_MN6;
<<<<<<< HEAD
       assign i_rng_current_to_MN6= {i_I_drive_to_MN[31:8] , MN6_rand_out[7:0]};
//       assign i_rng_current_to_MN6 = i_I_drive_to_MN;
=======
       assign i_rng_current_to_MN6= {i_I_drive_to_MN[31:6] , MN6_rand_out[5:0]};
>>>>>>> development
//
//      wire [31:0] MN7_rand_out;
//     rng rng_MN7(               
//        .clk1(neuron_clk),
//        .clk2(neuron_clk),
//        .reset(reset_sim),
//        .out(MN7_rand_out)
//        ); 
//        
//       wire [31:0] i_rng_current_to_MN7;
//       assign i_rng_current_to_MN7= {i_EPSC_synapse0[31:5] , MN7_rand_out[4:0]};       
      
      
      
     // MN1 Instance Definition
        izneuron_th_control MN1(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_sim),           // reset to initial conditions
            .I_in(  (i_rng_current_to_MN1*75) >>3 ),          // input current from synapse
            .th_scaled(  threshold30mv <<< 10),                 // threshold
            .v_out(v_neuron_MN1),               // membrane potential
            .spike(spike_neuron_MN1),           // spike sample
            .each_spike(each_spike_neuron_MN1), // raw spikes
            .population(population_neuron_MN1)  // spikes of population per 1ms simulation time
        );        
        
     // MN2 Instance Definition
        izneuron_th_control MN2(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_sim),           // reset to initial conditions
            .I_in(  (i_rng_current_to_MN2*49) >>3),          // input current from synapse
            .th_scaled(  threshold30mv <<< 10  ),                 // threshold
            .v_out(v_neuron_MN2),               // membrane potential
            .spike(spike_neuron_MN2),           // spike sample
            .each_spike(each_spike_neuron_MN2), // raw spikes
            .population(population_neuron_MN2)  // spikes of population per 1ms simulation time
        );   
        
     // MN3  Instance Definition
        izneuron_th_control MN3(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_sim),           // reset to initial conditions
            .I_in( (i_rng_current_to_MN3*30)>>3 ),          // input current from synapse
            .th_scaled( threshold30mv <<< 10   ),                 // threshold
            .v_out(v_neuron_MN3),               // membrane potential
            .spike(spike_neuron_MN3),           // spike sample
            .each_spike(each_spike_neuron_MN3), // raw spikes
            .population(population_neuron_MN3)  // spikes of population per 1ms simulation time
        );   
        
      // MN4  Instance Definition
        izneuron_th_control MN4(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_sim),           // reset to initial conditions
            .I_in( (i_rng_current_to_MN4*17) >>3 ),          // input current from synapse
            .th_scaled(  threshold30mv <<< 10  ),                 // threshold
            .v_out(v_neuron_MN4),               // membrane potential
            .spike(spike_neuron_MN4),           // spike sample
            .each_spike(each_spike_neuron_MN4), // raw spikes
            .population(population_neuron_MN4)  // spikes of population per 1ms simulation time
        );     
        
        // MN5  Instance Definition
        izneuron_th_control MN5(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_sim),           // reset to initial conditions
            .I_in( (i_rng_current_to_MN5*13) >>3 ),          // input current from synapse
            .th_scaled(  threshold30mv <<< 10  ),                 // threshold
            .v_out(v_neuron_MN5),               // membrane potential
            .spike(spike_neuron_MN5),           // spike sample
            .each_spike(each_spike_neuron_MN5), // raw spikes
            .population(population_neuron_MN5)  // spikes of population per 1ms simulation time
        );   
        
        // MN6  Instance Definition
        izneuron_th_control MN6(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_sim),           // reset to initial conditions
            .I_in( (i_rng_current_to_MN6*10) >>3 ),          // input current from synapse
            .th_scaled(  threshold30mv <<< 10  ),                 // threshold
            .v_out(v_neuron_MN6),               // membrane potential
            .spike(spike_neuron_MN6),           // spike sample
            .each_spike(each_spike_neuron_MN6), // raw spikes
            .population(population_neuron_MN6)  // spikes of population per 1ms simulation time
        );            

//        // MN7  Instance Definition
//        izneuron_th_control MN7(
//            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
//            .reset(reset_sim),           // reset to initial conditions
//            .I_in( (i_I_drive_to_MN*8) >>3 ),          // input current from synapse
//            .th_scaled(  threshold30mv <<< 10  ),                 // threshold
//            .v_out(v_neuron_MN7),               // membrane potential
//            .spike(spike_neuron_MN7),           // spike sample
//            .each_spike(each_spike_neuron_MN7), // raw spikes
//            .population(population_neuron_MN7)  // spikes of population per 1ms simulation time
//        );            

//
//     wire [31:0]  spike_count_neuron0_sync;
//      spike_counter  sync_counter
//      (                 .clk(neuron_clk),
//                        .reset(reset_sim),
//                        .spike_in(spikein1),
//                        .spike_count(spike_count_neuron0_sync) );

        

        // Waveform Generator mixed_input0 Instance Definition
        waveform_from_pipe_bram_16s gen_mixed_input0(
            .reset(reset_sim),               // reset the waveform
            .pipe_clk(ti_clk),                  // target interface clock from opalkelly interface
            .pipe_in_write(pipe_in_write),      // write enable signal from opalkelly pipe in
            .data_from_trig(f_len_pxi),	// data from one of ep50 channel
            .is_from_trigger(is_from_trigger),
            .pipe_in_data(pipe_in_data),        // waveform data from opalkelly pipe in
            .pop_clk(sim_clk),                  // trigger next waveform sample every 1ms
            .wave(mixed_input0)                   // wave out signal
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
    assign spikeout10 = 1'b0;  
    assign spikeout11 = 1'b0;
    assign spikeout12 = 1'b0;
    assign spikeout13 = 1'b0;
    assign spikeout14 = 1'b0;

        // Output and OpalKelly Interface Instance Definitions
//          reg reset_external_clean;
//       always @ (posedge sim_clk)
//        if (spikein14)
//            reset_external_clean <= spikein14;      
//        else
//            reset_external_clean <= 0;    

        
//        
//        assign reset_global = ep00wire[0] | reset_external_clean;
//        assign reset_sim = ep00wire[2] | reset_external_clean;
        assign reset_global = ep00wire[0];
        assign reset_sim = ep00wire[2];
        assign is_from_trigger = ~ep00wire[1];
        okWireOR # (.N(27)) wireOR (ok2, ok2x);
        okHost okHI(
            .hi_in(hi_in),  .hi_out(hi_out),    .hi_inout(hi_inout),    .hi_aa(hi_aa),
            .ti_clk(ti_clk),    .ok1(ok1),  .ok2(ok2)   );
        
        //okTriggerIn ep50    (.ok1(ok1), .ep_addr(8'h50),    .ep_clk(clk1),  .ep_trigger(ep50trig)   );
        okTriggerIn ep50    (.ok1(ok1), .ep_addr(8'h50),    .ep_clk(sim_clk),  .ep_trigger(ep50trig)   );
        
        okWireIn    wi00    (.ok1(ok1), .ep_addr(8'h00),    .ep_dataout(ep00wire)   );
        okWireIn    wi01    (.ok1(ok1), .ep_addr(8'h01),    .ep_dataout(ep01wire)   );
        okWireIn    wi02    (.ok1(ok1), .ep_addr(8'h02),    .ep_dataout(ep02wire)   );
        okWireIn    wi03    (.ok1(ok1), .ep_addr(8'h03),    .ep_dataout(ep03wire)   );
        okWireIn    wi04    (.ok1(ok1), .ep_addr(8'h04),    .ep_dataout(ep04wire)   );
        okWireIn    wi05    (.ok1(ok1), .ep_addr(8'h05),    .ep_dataout(ep05wire));
        okWireIn    wi06    (.ok1(ok1), .ep_addr(8'h06),    .ep_dataout(ep06wire));
        okWireIn    wi07    (.ok1(ok1), .ep_addr(8'h07),    .ep_dataout(ep07wire));
        okWireIn    wi08    (.ok1(ok1),  .ep_addr(8'h08),   .ep_dataout(ep08wire));

        
        okBTPipeIn ep80 (   .ok1(ok1), .ok2(ok2x[0*17 +: 17]), .ep_addr(8'h80), .ep_write(pipe_in_write),
                            .ep_blockstrobe(), .ep_dataout(pipe_in_data), .ep_ready(1'b1));
        
        okWireOut wo20 (    .ep_datain(f_emg[15:0]),  .ok1(ok1),  .ok2(ok2x[1*17 +: 17]), .ep_addr(8'h20)    );
        okWireOut wo21 (    .ep_datain(f_emg[31:16]),  .ok1(ok1),  .ok2(ok2x[2*17 +: 17]), .ep_addr(8'h21)   );    
        
        okWireOut wo22 (    .ep_datain(population_neuron_MN1[15:0]),  .ok1(ok1),  .ok2(ok2x[3*17 +: 17]), .ep_addr(8'h22)    );
        okWireOut wo23 (    .ep_datain(population_neuron_MN1[31:16]),  .ok1(ok1),  .ok2(ok2x[4*17 +: 17]), .ep_addr(8'h23)   );    
        
        okWireOut wo24 (    .ep_datain(population_neuron_MN2[15:0]),  .ok1(ok1),  .ok2(ok2x[5*17 +: 17]), .ep_addr(8'h24)    );
        okWireOut wo25 (    .ep_datain(population_neuron_MN2[31:16]),  .ok1(ok1),  .ok2(ok2x[6*17 +: 17]), .ep_addr(8'h25)   );    
        
        okWireOut wo26 (    .ep_datain(population_neuron_MN3[15:0]),  .ok1(ok1),  .ok2(ok2x[7*17 +: 17]), .ep_addr(8'h26)    );
        okWireOut wo27 (    .ep_datain(population_neuron_MN3[31:16]),  .ok1(ok1),  .ok2(ok2x[8*17 +: 17]), .ep_addr(8'h27)   ); 

        okWireOut wo28 (    .ep_datain(population_neuron_MN4[15:0]),  .ok1(ok1),  .ok2(ok2x[9*17 +: 17]), .ep_addr(8'h28)    );
        okWireOut wo29 (    .ep_datain(population_neuron_MN4[31:16]),  .ok1(ok1),  .ok2(ok2x[10*17 +: 17]), .ep_addr(8'h29)   ); 

        okWireOut wo2A (    .ep_datain(population_neuron_MN5[15:0]),  .ok1(ok1),  .ok2(ok2x[11*17 +: 17]), .ep_addr(8'h2A)    );
        okWireOut wo2B (    .ep_datain(population_neuron_MN5[31:16]),  .ok1(ok1),  .ok2(ok2x[12*17 +: 17]), .ep_addr(8'h2B)   ); 

        okWireOut wo2C (    .ep_datain(population_neuron_MN6[15:0]),  .ok1(ok1),  .ok2(ok2x[13*17 +: 17]), .ep_addr(8'h2C)    );
        okWireOut wo2D (    .ep_datain(population_neuron_MN6[31:16]),  .ok1(ok1),  .ok2(ok2x[14*17 +: 17]), .ep_addr(8'h2D)   );    
        
<<<<<<< HEAD
//        okWireOut wo2E (    .ep_datain(mixed_input0[15:0]),  .ok1(ok1),  .ok2(ok2x[15*17 +: 17]), .ep_addr(8'h2E)    );
//        okWireOut wo2F (    .ep_datain(mixed_input0[31:16]),  .ok1(ok1),  .ok2(ok2x[16*17 +: 17]), .ep_addr(8'h2F)   );   
=======
      //  okWireOut wo2E (    .ep_datain(population_neuron_MN2[15:0]),  .ok1(ok1),  .ok2(ok2x[15*17 +: 17]), .ep_addr(8'h2E)    );
      //  okWireOut wo2F (    .ep_datain(population_neuron_MN2[31:16]),  .ok1(ok1),  .ok2(ok2x[16*17 +: 17]), .ep_addr(8'h2F)   );   
>>>>>>> development

        okWireOut wo30 (    .ep_datain(i_active_muscleDrive[15:0]),  .ok1(ok1),  .ok2(ok2x[17*17 +: 17]), .ep_addr(8'h30)    );
        okWireOut wo31 (    .ep_datain(i_active_muscleDrive[31:16]),  .ok1(ok1),  .ok2(ok2x[18*17 +: 17]), .ep_addr(8'h31)   );         

        okWireOut wo32 (    .ep_datain(total_force_out_muscle0_sync[15:0]),  .ok1(ok1),  .ok2(ok2x[19*17 +: 17]), .ep_addr(8'h32)    );
        okWireOut wo33 (    .ep_datain(total_force_out_muscle0_sync[31:16]),  .ok1(ok1),  .ok2(ok2x[20*17 +: 17]), .ep_addr(8'h33)   );  
<<<<<<< HEAD
//        s
=======
//        
>>>>>>> development
//        okWireOut wo34 (    .ep_datain(i_spike_count_neuron_sync_inputPin[15:0]),  .ok1(ok1),  .ok2(ok2x[21*17 +: 17]), .ep_addr(8'h34)    );
//        okWireOut wo35 (    .ep_datain(i_spike_count_neuron_sync_inputPin[31:16]),  .ok1(ok1),  .ok2(ok2x[22*17 +: 17]), .ep_addr(8'h35)   );       

        okWireOut wo36 (    .ep_datain(f_I_synapse_CN[15:0]),  .ok1(ok1),  .ok2(ok2x[23*17 +: 17]), .ep_addr(8'h36)    );
        okWireOut wo37 (    .ep_datain(f_I_synapse_CN[31:16]),  .ok1(ok1),  .ok2(ok2x[24*17 +: 17]), .ep_addr(8'h37)   );            

       

        // Clock Generator clk_gen0 Instance Definition
        gen_clk clocks(
            .rawclk(clk1),
            .half_cnt(triggered_input6),
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
          

//////
     wire [31:0]  spike_count_neuron_sync_MN1;
      spike_counter  sync_counter_MN1
      (                 .clk(neuron_clk),
                        .reset(reset_sim),
                        .spike_in(each_spike_neuron_MN1),
                        .spike_count(spike_count_neuron_sync_MN1) );

     wire [31:0]  spike_count_neuron_sync_MN2;
      spike_counter  sync_counter_MN2
      (                 .clk(neuron_clk),
                        .reset(reset_sim),
                        .spike_in(each_spike_neuron_MN2),
                        .spike_count(spike_count_neuron_sync_MN2) );
                        
     wire [31:0]  spike_count_neuron_sync_MN3;
      spike_counter  sync_counter_MN3
      (                 .clk(neuron_clk),
                        .reset(reset_sim),
                        .spike_in(each_spike_neuron_MN3),
                        .spike_count(spike_count_neuron_sync_MN3) );

     wire [31:0]  spike_count_neuron_sync_MN4;
      spike_counter  sync_counter_MN4
      (                 .clk(neuron_clk),
                        .reset(reset_sim),
                        .spike_in(each_spike_neuron_MN4),
                        .spike_count(spike_count_neuron_sync_MN4) );  
                        
     wire [31:0]  spike_count_neuron_sync_MN5;
      spike_counter  sync_counter_MN5
      (                 .clk(neuron_clk),
                        .reset(reset_sim),
                        .spike_in(each_spike_neuron_MN5),
                        .spike_count(spike_count_neuron_sync_MN5) );   
                        
     wire [31:0]  spike_count_neuron_sync_MN6;
      spike_counter  sync_counter_MN6
      (                 .clk(neuron_clk),
                        .reset(reset_sim),
                        .spike_in(each_spike_neuron_MN6),
                        .spike_count(spike_count_neuron_sync_MN6) );       
//
//     wire [31:0]  spike_count_neuron_sync_MN7;
//      spike_counter  sync_counter_MN7
//      (                 .clk(neuron_clk),
//                        .reset(reset_sim),
//                        .spike_in(spike_neuron_MN7),
//                        .spike_count(spike_count_neuron_sync_MN7) );                               

    wire [31:0] total_spike_count_sync;
    //assign total_spike_count_sync = spike_count_neuron_sync_MN1 + spike_count_neuron_sync_MN2+ spike_count_neuron_sync_MN3+ spike_count_neuron_sync_MN4 + spike_count_neuron_sync_MN5 + spike_count_neuron_sync_MN6 + spike_count_neuron_sync_MN7;

    assign total_spike_count_sync = (spike_count_neuron_sync_MN1*32'd1) +  //MN1 is smallest MN (fires first) ->need to scale MUAP small.  
                                (spike_count_neuron_sync_MN2*32'd3 ) + 
                                (spike_count_neuron_sync_MN3*32'd6 ) +
                                (spike_count_neuron_sync_MN4*32'd15 ) + 
                                (spike_count_neuron_sync_MN5*32'd22 ) + 
                                (spike_count_neuron_sync_MN6*32'd34 ) ;
//                                (spike_count_neuron_sync_MN7*32'd49 );  // MN7 is largest MN (fires last) -> need to scale MUAP big

// 1/ (SIZEMU^1.6)  = SIZEMU to MUAP magnitude scaling
// Columns 1 through 4  (MU1~ MU20, selected 7)
//    1.4485    2.6693    5.8522   14.5209
//  Columns 5 through 
//   22.3050   33.9400   48.5029

                   
//    // ** EMG                
//    wire [31:0] f_emg;
//    emg emg_fool
//    (   .f_total_emg_out(f_emg), 
//        .i_spike_cnt(total_spike_count_sync), 
//        .clk(sim_clk), 
//        .reset(reset_global) ); 
        
        
        
    // ** EMG      
//        Transfer function:
//            0.002412 z^2 - 0.002421 z
//        ----------------------------------
//        z^3 - 2.642 z^2 + 2.327 z - 0.6833    

//      0.001524 z^2 - 0.001555 z 
//        -------------------------------------
//       z^3 - 2.566 z^2 + 2.195 z - 0.6258


//positive lobe > negative lobe (10/26/14 - Eric)
//Transfer function:
//0.002389 z^2 - 0.002374 z - 1.054e-18
//-------------------------------------
// z^3 - 2.617 z^2 + 2.282 z - 0.6635

    wire [31:0] f_emg;
    emg_parameter emg_parater_foo
    (   .f_total_emg_out(f_emg), 
        .i_spike_cnt(total_spike_count_sync), 
        .b1_F0(triggered_input7),
        .b2_F0(triggered_input8),
        .a1_F0(triggered_input9),
        .a2_F0(triggered_input10),
        .a3_F0(triggered_input11),
        .clk(sim_clk), 
        .reset(reset_sim) ); 

    wire [31:0]  i_mixed_input0;
        floor   waveform_float_to_int(
//            .in(f_drive_to_MN),
            .in(mixed_input0),
            .out(i_mixed_input0)
        );
   
   wire [31:0] i_active_muscleDrive;
   assign i_active_muscleDrive = is_from_trigger? total_spike_count_sync:i_mixed_input0;
   
   wire [31:0] total_force_out_muscle0_sync;
  
    // Muscle muscle0 Wire Definitions
    shadmehr_muscle muscle0_sync(
        .i_spike_cnt(i_active_muscleDrive),
        .f_pos(f_len_pxi),
        .f_vel(f_velocity),
        .clk(sim_clk),
        .reset(reset_sim),
        .apply_s_weight(apply_s_weight),
        .f_tau(triggered_input1),
        .f_total_force_out(total_force_out_muscle0_sync)
        //.f_current_A(),
        //.f_current_fp_spikes()
    );     
        
       
        
/////////////////////// END INSTANCE DEFINITIONS //////////////////////////

	// ** LEDs
    assign led[0] = ~reset_global;
    assign led[1] = ~spikein1;
    assign led[2] = ~spike_count_neuron_sync_MN1;
    assign led[3] = ~spike_count_neuron_sync_MN2;
    assign led[4] = ~spike_count_neuron_sync_MN3;
    assign led[5] = ~spike_count_neuron_sync_MN4;
    assign led[6] = ~spike_count_neuron_sync_MN6; // 
    assign led[7] = ~sim_clk; // clock
    
endmodule
