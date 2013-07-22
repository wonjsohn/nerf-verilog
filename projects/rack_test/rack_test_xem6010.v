
`timescale 1ns / 1ps

// rack_test_xem6010.v
// Generated on Wed Mar 13 14:57:46 -0700 2013

    module rack_test_xem6010(
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

        // Spindle spindle0 Wire Definitions
        wire [31:0] Ia_spindle0;    // Ia afferent (pps)
        wire [31:0] II_spindle0;    // II afferent (pps)
        
        wire [31:0] int_Ia_spindle0; // Ia afferent integer format
        wire [31:0] fixed_Ia_spindle0; // Ia afferent fixed point format
        
        wire [31:0] int_II_spindle0; // Ia afferent integer format
        wire [31:0] fixed_II_spindle0; // Ia afferent fixed point format

        // Triggered Input triggered_input0 Wire Definitions
        reg [31:0] triggered_input0;    // Triggered input sent from USB (lce)       
        

        // Triggered Input triggered_input1 Wire Definitions
        reg [31:0] triggered_input1;    // Triggered input sent from USB (gamma_dynamic)       
        

        // Triggered Input triggered_input2 Wire Definitions
        reg [31:0] triggered_input2;    // Triggered input sent from USB (gamma_static)       
        

        // Triggered Input triggered_input3 Wire Definitions
        reg [31:0] triggered_input3;    // Triggered input sent from USB (BDAMP_1)       
        

        // Triggered Input triggered_input4 Wire Definitions
        reg [31:0] triggered_input4;    // Triggered input sent from USB (BDAMP_2)       
        

        // Triggered Input triggered_input5 Wire Definitions
        reg [31:0] triggered_input5;    // Triggered input sent from USB (BDAMP_chain)       
        

        // Triggered Input triggered_input6 Wire Definitions
        reg [31:0] triggered_input6;    // Triggered input sent from USB (spindle_gain)       
        

        // Triggered Input triggered_input7 Wire Definitions
        reg [31:0] triggered_input7;    // Triggered input sent from USB (clk_divider)       
        
        reg [31:0] triggered_input8;
        reg [31:0] triggered_input9;
        
        reg [31:0] f_spindle_offset;
        
        reg [31:0] f_spindle_II_gain;
        reg [31:0] f_spindle_II_offset;

        // Spike Counter spike_counter0 Wire Definitions
        wire [31:0] spike_count_neuron0;
        

        // Waveform Generator mixed_input0 Wire Definitions
        wire [31:0] mixed_input0;   // Wave out signal
        

    // FPGA Input/Output Rack Wire Definitions
    // these are in the top module input/output list
    

        // Output and OpalKelly Interface Wire Definitions
        
        wire [36*17-1:0] ok2x;
        wire [15:0] ep00wire, ep01wire, ep02wire;
        wire [15:0] ep50trig;
        
        wire pipe_in_write;
        wire [15:0] pipe_in_data;
        

        // Clock Generator clk_gen0 Wire Definitions
        wire neuron_clk;  // neuron clock (128 cycles per 1ms simulation time) 
        wire sim_clk;     // simulation clock (1 cycle per 1ms simulation time)
        wire spindle_clk; // spindle clock (3 cycles per 1ms simulation time)
        

        // Neuron neuron0 Wire Definitions
        wire [31:0] v_neuron0;   // membrane potential
        
        wire [31:0] u_neuron0;  // recovery variable
        
        wire spike_neuron0;      // spike sample for visualization only
        wire each_spike_neuron0; // raw spike signals
        wire [127:0] population_neuron0; // spike raster for entire population        

        
        
  
        // Neuron neuron1 Wire Definitions
        wire [31:0] v_neuron1;   // membrane potential
        
        wire [31:0] u_neuron1;  // recovery variable
        
        wire spike_neuron1;      // spike sample for visualization only
        wire each_spike_neuron1; // raw spike signals
        wire [127:0] population_neuron1; // spike raster for entire population        
        
        
        // spindle dampings
        wire [31:0] bdamp_1;
        wire [31:0] bdamp_2;
        wire [31:0] bdamp_chain;
      
/////////////////////// END WIRE DEFINITIONS //////////////////////////////

/////////////////////// BEGIN INSTANCE DEFINITIONS ////////////////////////

        assign bdamp_1 = 32'h3e714120;         //reset to 0.2356
        assign bdamp_2 = 32'h3d144674;         //reset to 0.0362 
        assign bdamp_chain = 32'h3c5844d0;         //reset to 0.0132

        // Spindle spindle0 Instance Definition
        spindle spindle0 (
            .gamma_dyn(triggered_input1),   // spindle dynamic gamma input (pps)
            .gamma_sta(triggered_input2),    // spindle static gamma input (pps)
            .lce(mixed_input0),                   // length of contractile element (muscle length)
            .clk(spindle_clk),                  // spindle clock (3 cycles per 1ms simulation time) 
            .reset(reset_global),               // reset the spindle
            .out0(),
            .out1(),
            .out2(II_spindle0),                   // II afferent (pps)
            .out3(Ia_spindle0),                   // Ia afferent (pps)
            .BDAMP_1(bdamp_1),           // Damping coefficient for bag1 fiber
            .BDAMP_2(bdamp_2),           // Damping coefficient for bag2 fiber
            .BDAMP_chain(bdamp_chain)    // Damping coefficient for chain fiber
        );
    

    //Remove the offset in spindle output rate
    wire [31:0] f_temp_spindle_remove_offset;
    sub sub_spindle0(.x(Ia_spindle0), .y(f_spindle_offset), .out(f_temp_spindle_remove_offset));
	//gain control for spindle output rate 
    
    
	wire [31:0] Ia_gain_controlled_spindle0, Ia_gain_controlled_temp;
	mult mult_spindle0(.x(f_temp_spindle_remove_offset), .y(triggered_input6), .out(Ia_gain_controlled_temp));
    
    assign Ia_gain_controlled_spindle0 = Ia_gain_controlled_temp[31] ? 32'd0 : Ia_gain_controlled_temp;

        // Ia Afferent datatype conversion (floating point -> integer -> fixed point)
        floor   ia_spindle0_float_to_int(
            .in(Ia_gain_controlled_spindle0),
            .out(int_Ia_spindle0)
        );
        
        //assign fixed_Ia_spindle0 = int_Ia_spindle0 <<< 6;
        assign fixed_Ia_spindle0 = int_Ia_spindle0 * triggered_input8;


    //Remove the offset in spindle output rate
    wire [31:0] f_temp_spindle_remove_II_offset;
    sub sub_II_spindle0(.x(II_spindle0), .y(f_spindle_II_offset), .out(f_temp_spindle_remove_II_offset));
	//gain control for spindle output rate 
    
    
	wire [31:0] II_gain_controlled_spindle0, II_gain_controlled_temp;
	mult mult_II_spindle0(.x(f_temp_spindle_remove_II_offset), .y(f_spindle_II_gain), .out(II_gain_controlled_temp));
    
    assign II_gain_controlled_spindle0 = II_gain_controlled_temp[31] ? 32'd0 : II_gain_controlled_temp;

        // Ia Afferent datatype conversion (floating point -> integer -> fixed point)
        floor   ii_spindle0_float_to_int(
            .in(II_gain_controlled_spindle0),
            .out(int_II_spindle0)
        );
        
        //assign fixed_Ia_spindle0 = int_Ia_spindle0 <<< 6;
        assign fixed_II_spindle0 = int_II_spindle0 * triggered_input9;
        
 

        // Triggered Input triggered_input0 Instance Definition (lce)
        always @ (posedge ep50trig[9] or posedge reset_global)
        if (reset_global)
            triggered_input0 <= 32'h3f8ccccd;         //reset to 1.1      
        else
            triggered_input0 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input1 Instance Definition (gamma_dynamic)
        always @ (posedge ep50trig[4] or posedge reset_global)
        if (reset_global)
            triggered_input1 <= 32'h42a00000;         //reset to 80      
        else
            triggered_input1 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input2 Instance Definition (gamma_static)
        always @ (posedge ep50trig[5] or posedge reset_global)
        if (reset_global)
            triggered_input2 <= 32'h42a00000;         //reset to 80      
        else
            triggered_input2 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input3 Instance Definition (izneuron 'a')
        always @ (posedge ep50trig[15] or posedge reset_global)
        if (reset_global)
            triggered_input3 <= 32'd82;         // a = 0.02    
        else
            triggered_input3 <= {ep02wire, ep01wire};      
        
        
        

        // Triggered Input triggered_input3 Instance Definition (BDAMP_1)
        always @ (posedge ep50trig[3] or posedge reset_global)
        if (reset_global)
            f_spindle_offset <= 32'h3e714120;         //reset to 0.2356      
        else
            f_spindle_offset <= {ep02wire, ep01wire};            
 

        // Triggered Input triggered_input3 Instance Definition (BDAMP_1)
        always @ (posedge ep50trig[10] or posedge reset_global)
        if (reset_global)
            f_spindle_II_offset <= 32'd0;         //reset to 0.2356      
        else
            f_spindle_II_offset <= {ep02wire, ep01wire};   
        
 
        // Triggered Input triggered_input3 Instance Definition (BDAMP_1)
        always @ (posedge ep50trig[8] or posedge reset_global)
        if (reset_global)
            f_spindle_II_gain <= 32'd0;         //reset to 0.2356      
        else
            f_spindle_II_gain <= {ep02wire, ep01wire}; 

        // Triggered Input triggered_input4 Instance Definition (izneuron 'd')
        always @ (posedge ep50trig[14] or posedge reset_global)
        if (reset_global)
            triggered_input4 <= 32'd2048;         // d = 2   
        else
            triggered_input4 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input5 Instance Definition (u_hard_limit)
        always @ (posedge ep50trig[13] or posedge reset_global)
        if (reset_global)
            triggered_input5 <= 32'd10000;         //reset to 0.0132      
        else
            triggered_input5 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input6 Instance Definition (spindle_gain)
        always @ (posedge ep50trig[1] or posedge reset_global)
        if (reset_global)
            triggered_input6 <= 32'h40800000;         //reset to 4.0      
        else
            triggered_input6 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input7 Instance Definition (clk_divider)
        always @ (posedge ep50trig[7] or posedge reset_global)
        if (reset_global)
            triggered_input7 <= 32'd381;        //count for 0.5x real speed, 381 for real time speed   
        else
            triggered_input7 <= {ep02wire, ep01wire};      
        
        // Triggered Input triggered_input8 Instance Definition (Ia Current Gain)
        always @ (posedge ep50trig[12] or posedge reset_global)
        if (reset_global)
            triggered_input8 <= 32'd1;        //1
        else
            triggered_input8 <= {ep02wire, ep01wire};   
        
        // Triggered Input triggered_input9 Instance Definition (II current gain)
        always @ (posedge ep50trig[11] or posedge reset_global)
        if (reset_global)
            triggered_input9 <= 32'd1;        //1
        else
            triggered_input9 <= {ep02wire, ep01wire};  

            
        // Spike Counter spike_counter0 Instance Definition
	wire    dummy_slow;
        spikecnt_async	spike_counter0
        (      .spike(each_spike_neuron0),
                .int_cnt_out(spike_count_neuron0),
                .slow_clk(sim_clk),
                .fast_clk(clk1),
                .reset(reset_global),
                .clear_out(dummy_slow));
        

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
    assign spikeout1 = each_spike_neuron0;
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
       reg reset_external_clean;
       always @ (posedge sim_clk)
        if (spikein14)
            reset_external_clean <= spikein14;      
        else
            reset_external_clean <= 0;    

        
        
        assign reset_global = ep00wire[0] | reset_external_clean;
        assign is_from_trigger = ~ep00wire[1];
        okWireOR # (.N(36)) wireOR (ok2, ok2x);
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
        
        okWireOut wo20 (    .ep_datain(population_neuron0[15:0]),  .ok1(ok1),  .ok2(ok2x[1*17 +: 17]), .ep_addr(8'h20)    );
        okWireOut wo21 (    .ep_datain(population_neuron0[31:16]),  .ok1(ok1),  .ok2(ok2x[2*17 +: 17]), .ep_addr(8'h21)   );    
        
        //okWireOut wo22 (    .ep_datain(Ia_spindle0[15:0]),  .ok1(ok1),  .ok2(ok2x[3*17 +: 17]), .ep_addr(8'h22)    );
        //okWireOut wo23 (    .ep_datain(Ia_spindle0[31:16]),  .ok1(ok1),  .ok2(ok2x[4*17 +: 17]), .ep_addr(8'h23)   );    
        okWireOut wo22 (    .ep_datain(Ia_gain_controlled_spindle0[15:0]),  .ok1(ok1),  .ok2(ok2x[3*17 +: 17]), .ep_addr(8'h22)    );
        okWireOut wo23 (    .ep_datain(Ia_gain_controlled_spindle0[31:16]),  .ok1(ok1),  .ok2(ok2x[4*17 +: 17]), .ep_addr(8'h23)   );  
        
        okWireOut wo24 (    .ep_datain(II_gain_controlled_spindle0[15:0]),  .ok1(ok1),  .ok2(ok2x[5*17 +: 17]), .ep_addr(8'h24)    );
        okWireOut wo25 (    .ep_datain(II_gain_controlled_spindle0[31:16]),  .ok1(ok1),  .ok2(ok2x[6*17 +: 17]), .ep_addr(8'h25)   );    
        
        okWireOut wo26 (    .ep_datain(v_neuron0[15:0]),  .ok1(ok1),  .ok2(ok2x[7*17 +: 17]), .ep_addr(8'h26)    );
        okWireOut wo27 (    .ep_datain(v_neuron0[31:16]),  .ok1(ok1),  .ok2(ok2x[8*17 +: 17]), .ep_addr(8'h27)   );    
        
        okWireOut wo28 (    .ep_datain(v_neuron1[15:0]),  .ok1(ok1),  .ok2(ok2x[9*17 +: 17]), .ep_addr(8'h28)    );
        okWireOut wo29 (    .ep_datain(v_neuron1[31:16]),  .ok1(ok1),  .ok2(ok2x[10*17 +: 17]), .ep_addr(8'h29)   ); 

        okWireOut wo2a (    .ep_datain(mixed_input0[15:0]),  .ok1(ok1),  .ok2(ok2x[11*17 +: 17]), .ep_addr(8'h2a)    );
        okWireOut wo2b (    .ep_datain(mixed_input0[31:16]),  .ok1(ok1),  .ok2(ok2x[12*17 +: 17]), .ep_addr(8'h2b)   ); 
        
        okWireOut wo2c (    .ep_datain(u_neuron0[15:0]),  .ok1(ok1),  .ok2(ok2x[13*17 +: 17]), .ep_addr(8'h2c)    );
        okWireOut wo2d (    .ep_datain(u_neuron0[31:16]),  .ok1(ok1),  .ok2(ok2x[14*17 +: 17]), .ep_addr(8'h2d)   ); 
                
        okWireOut wo2e (    .ep_datain(u_neuron1[15:0]),  .ok1(ok1),  .ok2(ok2x[15*17 +: 17]), .ep_addr(8'h2e)    );
        okWireOut wo2f (    .ep_datain(u_neuron1[31:16]),  .ok1(ok1),  .ok2(ok2x[16*17 +: 17]), .ep_addr(8'h2f)   ); 
        
        okWireOut wo30 (    .ep_datain(population_neuron0[15:0]),  .ok1(ok1),  .ok2(ok2x[18*17 +: 17]), .ep_addr(8'h30)    );
        okWireOut wo31 (    .ep_datain(population_neuron0[31:16]),  .ok1(ok1),  .ok2(ok2x[19*17 +: 17]), .ep_addr(8'h31)   );  
        okWireOut wo32 (    .ep_datain(population_neuron0[47:32]),  .ok1(ok1),  .ok2(ok2x[20*17 +: 17]), .ep_addr(8'h32)    );
        okWireOut wo33 (    .ep_datain(population_neuron0[63:48]),  .ok1(ok1),  .ok2(ok2x[21*17 +: 17]), .ep_addr(8'h33)   ); 
        okWireOut wo34 (    .ep_datain(population_neuron0[79:64]),  .ok1(ok1),  .ok2(ok2x[22*17 +: 17]), .ep_addr(8'h34)    );
        okWireOut wo35 (    .ep_datain(population_neuron0[95:80]),  .ok1(ok1),  .ok2(ok2x[23*17 +: 17]), .ep_addr(8'h35)   ); 
        okWireOut wo36 (    .ep_datain(population_neuron0[111:96]),  .ok1(ok1),  .ok2(ok2x[24*17 +: 17]), .ep_addr(8'h36)    );
        okWireOut wo37 (    .ep_datain(population_neuron0[127:112]),  .ok1(ok1),  .ok2(ok2x[25*17 +: 17]), .ep_addr(8'h37)   );

        okWireOut wo38 (    .ep_datain(population_neuron1[15:0]),  .ok1(ok1),  .ok2(ok2x[26*17 +: 17]), .ep_addr(8'h38)    );
        okWireOut wo39 (    .ep_datain(population_neuron1[31:16]),  .ok1(ok1),  .ok2(ok2x[27*17 +: 17]), .ep_addr(8'h39)   );  
        okWireOut wo3a (    .ep_datain(population_neuron1[47:32]),  .ok1(ok1),  .ok2(ok2x[28*17 +: 17]), .ep_addr(8'h3a)    );
        okWireOut wo3b (    .ep_datain(population_neuron1[63:48]),  .ok1(ok1),  .ok2(ok2x[29*17 +: 17]), .ep_addr(8'h3b)   ); 
        okWireOut wo3c (    .ep_datain(population_neuron1[79:64]),  .ok1(ok1),  .ok2(ok2x[30*17 +: 17]), .ep_addr(8'h3c)    );
        okWireOut wo3d (    .ep_datain(population_neuron1[95:80]),  .ok1(ok1),  .ok2(ok2x[31*17 +: 17]), .ep_addr(8'h3d)   ); 
        okWireOut wo3e (    .ep_datain(population_neuron1[111:96]),  .ok1(ok1),  .ok2(ok2x[32*17 +: 17]), .ep_addr(8'h3e)    );
        okWireOut wo3f (    .ep_datain(population_neuron1[127:112]),  .ok1(ok1),  .ok2(ok2x[33*17 +: 17]), .ep_addr(8'h3f)   );        
        // Clock Generator clk_gen0 Instance Definition
        gen_clk clocks(
            .rawclk(clk1),
            .half_cnt(triggered_input7),
            .clk_out1(neuron_clk),
            .clk_out2(sim_clk),
            .clk_out3(spindle_clk),
            .int_neuron_cnt_out()
        );
    
    wire [31:0] a, b, c, d;
        
    assign a = 32'd82; // a = 0.02      (scaling factor 4096)
    assign b = 32'd205; // b = 0.2      (scaling factor 1024)
    assign c = -32'd65560; // c = -65   (scaling factor 1024)
    assign d = 32'd2048; // d = 2       (scaling factor 1024)

wire [31:0] rng_out;
rng noisy_I(
            .clk1(neuron_clk),
            .clk2(neuron_clk),
            .reset(reset_global),
            .out(rng_out),
            
            .lfsr(),
            .casr()
    );
    
wire [31:0] noisy_Ia;

assign noisy_Ia = fixed_Ia_spindle0 + {20'd0, rng_out[11:0]};

        // Neuron neuron0 Instance Definition
        izneuron_abcd_hard_limit_u neuron0(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_global),           // reset to initial conditions
            //.I_in(  fixed_Ia_spindle0 ),          // input current from synapse
            .I_in(  noisy_Ia ),          // input current from synapse            
            
            .a(triggered_input3),
            .b(b),
            .c(c),
            .d(triggered_input4),
            
            .hard_limit_u(triggered_input5),                 // limit the membrane recovery variable
            
            .v_out(v_neuron0),               // membrane potential
            
            .u_out(u_neuron0),
            
            .spike(spike_neuron0),           // spike sample
            .each_spike(each_spike_neuron0), // raw spikes
            .population(population_neuron0)  // spikes of population per 1ms simulation time
        );

wire [31:0] noisy_II;

assign noisy_II = fixed_II_spindle0 + {20'd0, rng_out[11:0]};


        // Neuron neuron1 Instance Definition
        izneuron_abcd_hard_limit_u neuron1(
            .clk(neuron_clk),               // neuron clock (128 cycles per 1ms simulation time)
            .reset(reset_global),           // reset to initial conditions
            //.I_in(  fixed_II_spindle0 ),          // input current from synapse
            .I_in(  noisy_II ),          // input current from synapse
            
            .a(triggered_input3),
            .b(b),
            .c(c),
            .d(triggered_input4),
            
            .hard_limit_u(triggered_input5),                // limit the membrane recovery variable
            
            .v_out(v_neuron1),               // membrane potential
            
            .u_out(u_neuron1),
            
            .spike(spike_neuron1),           // spike sample
            .each_spike(each_spike_neuron1), // raw spikes
            .population(population_neuron1)  // spikes of population per 1ms simulation time
        );        
/////////////////////// END INSTANCE DEFINITIONS //////////////////////////

	// ** LEDs
    assign led[0] = ~reset_global;
    assign led[1] = ~0;
    assign led[2] = ~spikeout1;
    assign led[3] = ~0;
    assign led[4] = ~0;
    assign led[5] = ~0;
    assign led[6] = ~neuron_clk; // 
    assign led[7] = ~sim_clk; // clock
    
endmodule
