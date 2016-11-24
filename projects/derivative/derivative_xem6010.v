`default_nettype none
`timescale 1ns / 1ps

// rack_test_xem6010.v
// Generated on Wed Mar 13 14:57:46 -0700 2013

    module derivative_xem6010 (
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

        // *** Target interface bus:
        assign i2c_sda = 1'bz;
        assign i2c_scl = 1'bz;
        assign hi_muxsel = 1'b0;
    

      
/////////////////////// BEGIN WIRE DEFINITIONS ////////////////////////////

        // Spindle spindle0 Wire Definitions
        wire [31:0] Ia_spindle0;    // Ia afferent (pps)
        wire [31:0] II_spindle0;    // II afferent (pps)
        
        wire [31:0] int_Ia_spindle0; // Ia afferent integer format
        wire [31:0] int_II_spindle0; // II afferent integer format
        wire [31:0] fixed_Ia_spindle0; // Ia afferent fixed point format
        wire [31:0] fixed_II_spindle0; // II afferent fixed point format
        

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
        reg [31:0] triggered_input6;    // Triggered input sent from USB (spindle_Ia_gain)       
        

        // Triggered Input triggered_input7 Wire Definitions
        reg [31:0] triggered_input7;    // Triggered input sent from USB (clk_divider)       
        

        // Triggered Input triggered_input8 Wire Definitions
        reg [31:0] triggered_input8;    // Triggered input sent from USB (spindle_II_gain)      
        
        // Spike Counter spike_counter0 Wire Definitions
        wire [31:0] spike_count_neuron0;
        

        // Waveform Generator mixed_input0 Wire Definitions
        wire [31:0] mixed_input0;   // Wave out signal
        

    // FPGA Input/Output Rack Wire Definitions
    // these are in the top module input/output list
    

        // Output and OpalKelly Interface Wire Definitions
        
        wire [24*17-1:0] ok2x;
		  wire [16:0] ok2a; // test for trig out
        wire [15:0] ep00wire, ep01wire, ep02wire;
        wire [15:0] ep50trig;
		  reg [15:0] ep60trig;  // trigger out to inidicate fifo fullness
        
        wire pipe_in_write;
        wire [15:0] pipe_in_data;



        // Clock Generator clk_gen0 Wire Definitions
        wire neuron_clk;  // neuron clock (128 cycles per 1ms simulation time) 
        wire sim_clk;     // simulation clock (1 cycle per 1ms simulation time)
        wire spindle_clk; // spindle clock (3 cycles per 1ms simulation time)
        


/////////////////////// END WIRE DEFINITIONS //////////////////////////////

/////////////////////// BEGIN INSTANCE DEFINITIONS ////////////////////////


    

        
        
        // Triggered Input triggered_input0 Instance Definition (lce)
        always @ (posedge ep50trig[9] or posedge reset_global)
        if (reset_global)
            triggered_input0 <= 32'h3F800000;         //reset to 1.0    
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
        

        // Triggered Input triggered_input3 Instance Definition (BDAMP_1)
        always @ (posedge ep50trig[15] or posedge reset_global)
        if (reset_global)
            triggered_input3 <= 32'h3e714120;         //reset to 0.2356      
        else
            triggered_input3 <= {ep02wire, ep01wire};      
        
        
        
        reg [31:0] f_spindle_offset;
        always @ (posedge ep50trig[3] or posedge reset_global)
        if (reset_global)
            f_spindle_offset <= 32'h428C0000;         //reset to 70.0  
        else
            f_spindle_offset <= {ep02wire, ep01wire};

        
        reg [31:0] f_spindle_offset_II;
        always @ (posedge ep50trig[6] or posedge reset_global)
        if (reset_global)
            f_spindle_offset_II <= 32'h42480000;         //reset to 50.0    
        else
            f_spindle_offset_II <= {ep02wire, ep01wire};              
        

        // Triggered Input triggered_input4 Instance Definition (BDAMP_2)
        always @ (posedge ep50trig[14] or posedge reset_global)
        if (reset_global)
            triggered_input4 <= 32'h3d144674;         //reset to 0.0362      
        else
            triggered_input4 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input5 Instance Definition (BDAMP_chain)
        always @ (posedge ep50trig[13] or posedge reset_global)
        if (reset_global)
            triggered_input5 <= 32'h3c5844d0;         //reset to 0.0132      
        else
            triggered_input5 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input6 Instance Definition (spindle_Ia_gain)
        always @ (posedge ep50trig[1] or posedge reset_global)
        if (reset_global)
            triggered_input6 <= 32'h3F99999A;         //reset to 1.2      
        else
            triggered_input6 <= {ep02wire, ep01wire};      
        

        // Triggered Input triggered_input7 Instance Definition (clk_divider)
        always @ (posedge ep50trig[7] or posedge reset_global)
        if (reset_global)
            triggered_input7 <= 32'd381;        //count for 0.5x real speed, 762 for real time speed   
        else
            triggered_input7 <= {ep02wire, ep01wire};     

       // Triggered Input triggered_input8 Instance Definition (spindle_II_gain)
        always @ (posedge ep50trig[10] or posedge reset_global)
        if (reset_global)
            triggered_input8 <= 32'h40000000;         //reset to 2.0    
        else
            triggered_input8 <= {ep02wire, ep01wire};                  
        

//
//        // Waveform Generator mixed_input0 Instance Definition
//        waveform_from_pipe_bram_2s gen_mixed_input0(
//            .reset(reset_sim),               // reset the waveform
//            .pipe_clk(ti_clk),                  // target interface clock from opalkelly interface
//            .pipe_in_write(pipe_in_write),      // write enable signal from opalkelly pipe in
//            .data_from_trig(triggered_input0),	// data from one of ep50 channel
//            .is_from_trigger(is_from_trigger),
//            .pipe_in_data(pipe_in_data),        // waveform data from opalkelly pipe in
//            .pop_clk(sim_clk),                  // trigger next waveform sample every 1ms
//            .wave(mixed_input0)                   // wave out signal
//        );
		  
		          // Waveform Generator mixed_input0 Instance Definition
        waveform_from_pipe_bram_32s gen_mixed_input32s(
            .reset(reset_sim),               // reset the waveform
            .pipe_clk(ti_clk),                  // target interface clock from opalkelly interface
            .pipe_in_write(pipe_in_write),      // write enable signal from opalkelly pipe in
            .data_from_trig(triggered_input0),	// data from one of ep50 channel
            .is_from_trigger(is_from_trigger),
            .pipe_in_data(pipe_in_data),        // waveform data from opalkelly pipe in
            .pop_clk(sim_clk),                  // trigger next waveform sample every 1ms
            .wave(mixed_input0)                   // wave out signal
        );
        
        
		    
 reg [31:0] f_mixed_input0_F0, f_mixed_input0_F1, f_mixed_input0_F2, f_mixed_input0_F3, f_mixed_input0_F4;

	  always @(posedge sim_clk or posedge reset_global)
		begin
		  if (reset_global)
			begin
			  f_mixed_input0_F0 <= 32'd0;
			  f_mixed_input0_F1 <= 32'd0;
			  f_mixed_input0_F2 <= 32'd0;
			  f_mixed_input0_F3 <= 32'd0;
			  f_mixed_input0_F4 <= 32'd0;
			end else begin
			  f_mixed_input0_F0 <= mixed_input0;
			  f_mixed_input0_F1 <= f_mixed_input0_F0;
				f_mixed_input0_F2 <= f_mixed_input0_F1; 	
				f_mixed_input0_F3 <= f_mixed_input0_F2; 	
				f_mixed_input0_F4 <= f_mixed_input0_F3; 	
			end
		 end	  
//		 
//		 reg [31:0] f_velocity;
//	// two consecutive values
//	  always @(posedge sim_clk or posedge reset_global)
//		begin
//		  if (reset_global)
//			begin
//			  f_velocity <= 32'd0;
//			end else begin
//			  f_velocity <= f_velocity_F0; 
//			end
//		 end
		  
		    //*********** add  *********
        wire [31:0] f_difference;
        sub sub1(.x(f_mixed_input0_F0), .y(f_mixed_input0_F4), .out(f_difference));
		//wire [31:0] f_gain_controlled_I_synapse_Ia;
		wire [31:0] f_derivative;
		wire [31:0] IEEE_240;
		assign IEEE_240 = 32'h43700000;
		mult mult1(.x(f_difference), .y(IEEE_240), .out(f_derivative)); // multiplicator is adjusted to get vel=~4.5 at fastest ramp (Kian's)
		
       // mult mult_synapse_simple0_Ia(.x(f_difference), .y(triggered_input5), .out(f_gain_controlled_I_synapse_Ia));
 
        
		  
//		         // Waveform Generator mixed_input0 Instance Definition
//        fifo_long fifo1(
//            .reset(reset_sim),               // reset the waveform
//            .pipe_clk(ti_clk),                  // target interface clock from opalkelly interface
//            .pipe_in_write(pipe_in_write),      // write enable signal from opalkelly pipe in
//            .data_from_trig(triggered_input0),	// data from one of ep50 channel
//            .is_from_trigger(is_from_trigger),
//            .pipe_in_data(pipe_in_data),        // waveform data from opalkelly pipe in
//            .pop_clk(sim_clk),                  // trigger next waveform sample every 1ms
//            .wave(mixed_input0),                   // wave out signal
//				.almostfifofull1(fifo_almost_full),					// fifo is almost full
//				.n_fifo_almost_em(fifo_almost_empty)
//        );
//		 
		  
//		  // trigger out fifo full signal
//		  
//	   always @(posedge clk1 or posedge reset_global)
//         begin
//           if (reset_global)
//            begin
//              ep60trig <= 16'd0;
//            end else begin
//              ep60trig <= {14'd0,fifo_almost_empty, fifo_almost_full}; 
//            end
//          end
//        
        // time reference for latency measure 
         // Waveform Generator mixed_input0 Instance Definition

//         wire [31:0] timeref_wave;
//        waveform_from_pipe_bram_2s gen_additional_pipeinput(
//            .reset(reset_sim),               // reset the waveform
//            .pipe_clk(ti_clk),                  // target interface clock from opalkelly interface
//            .pipe_in_write(pipe_in_write_timeref),      // write enable signal from opalkelly pipe in
//            .data_from_trig(triggered_input0),	// data from one of ep50 channel
//            .is_from_trigger(1'd0),
//            .pipe_in_data(pipe_in_data_timeref),        // waveform data from opalkelly pipe in
//            .pop_clk(sim_clk),                  // trigger next waveform sample every 1ms
//            .wave(timeref_wave)                   // wave out signal
//        );

        
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

//        // Output and OpalKelly Interface Instance Definitions
//       reg reset_external_clean;
//       always @ (posedge sim_clk)
//        if (spikein14)
//            reset_external_clean <= spikein14;      
//        else
//            reset_external_clean <= 0;    

        
        
        assign reset_global = ep00wire[0];
        assign reset_sim = ep00wire[2];
        assign is_from_trigger = ~ep00wire[1];
        okWireOR # (.N(24)) wireOR (ok2, ok2x);
        okHost okHI(
            .hi_in(hi_in),  .hi_out(hi_out),    .hi_inout(hi_inout),    .hi_aa(hi_aa),
            .ti_clk(ti_clk),    .ok1(ok1),  .ok2(ok2)   );
        
        //okTriggerIn ep50    (.ok1(ok1), .ep_addr(8'h50),    .ep_clk(clk1),  .ep_trigger(ep50trig)   );
        okTriggerIn ep50    (.ok1(ok1), .ep_addr(8'h50),    .ep_clk(sim_clk),  .ep_trigger(ep50trig)   );
        okTriggerOut ep60 (.ok1(ok1), .ok2(ok2x[20*17 +: 17]), .ep_addr(8'h60), .ep_clk(clk1), .ep_trigger(ep60trig));
		  
        okWireIn    wi00    (.ok1(ok1), .ep_addr(8'h00),    .ep_dataout(ep00wire)   );
        okWireIn    wi01    (.ok1(ok1), .ep_addr(8'h01),    .ep_dataout(ep01wire)   );
        okWireIn    wi02    (.ok1(ok1), .ep_addr(8'h02),    .ep_dataout(ep02wire)   );
        
        okBTPipeIn ep80 (   .ok1(ok1), .ok2(ok2x[0*17 +: 17]), .ep_addr(8'h80), .ep_write(pipe_in_write),
                            .ep_blockstrobe(), .ep_dataout(pipe_in_data), .ep_ready(1'b1));
//        okPipeIn ep80 (   .ok1(ok1), .ok2(ok2x[0*17 +: 17]), .ep_addr(8'h80), .ep_write(pipe_in_write),
//                             .ep_dataout(pipe_in_data));
        
		  
//        okWireOut wo20 (    .ep_datain(population_neuron0[31:16]),  .ok1(ok1),  .ok2(ok2x[1*17 +: 17]), .ep_addr(8'h20)    );
//        okWireOut wo21 (    .ep_datain(population_neuron0[47:32]),  .ok1(ok1),  .ok2(ok2x[2*17 +: 17]), .ep_addr(8'h21)   );    
        
//        okWireOut wo22 (    .ep_datain(Ia_spindle0[15:0]),  .ok1(ok1),  .ok2(ok2x[3*17 +: 17]), .ep_addr(8'h22)    );
//        okWireOut wo23 (    .ep_datain(Ia_spindle0[31:16]),  .ok1(ok1),  .ok2(ok2x[4*17 +: 17]), .ep_addr(8'h23)   );    
//        
        okWireOut wo24 (    .ep_datain(f_derivative[15:0]),  .ok1(ok1),  .ok2(ok2x[5*17 +: 17]), .ep_addr(8'h24)    );
        okWireOut wo25 (    .ep_datain(f_derivative[31:16]),  .ok1(ok1),  .ok2(ok2x[6*17 +: 17]), .ep_addr(8'h25)   );    
        
        okWireOut wo26 (    .ep_datain(mixed_input0[15:0]),  .ok1(ok1),  .ok2(ok2x[7*17 +: 17]), .ep_addr(8'h26)    );
        okWireOut wo27 (    .ep_datain(mixed_input0[31:16]),  .ok1(ok1),  .ok2(ok2x[8*17 +: 17]), .ep_addr(8'h27)   );    
        
        okWireOut wo28 (    .ep_datain(f_difference[15:0]),  .ok1(ok1),  .ok2(ok2x[9*17 +: 17]), .ep_addr(8'h28)    );
        okWireOut wo29 (    .ep_datain(f_difference[31:16]),  .ok1(ok1),  .ok2(ok2x[10*17 +: 17]), .ep_addr(8'h29)   );    
        
//        okWireOut wo2A (    .ep_datain(i_rng_current_to_SN_Ia[15:0]),  .ok1(ok1),  .ok2(ok2x[11*17 +: 17]), .ep_addr(8'h2A)    );
//        okWireOut wo2B (    .ep_datain(i_rng_current_to_SN_Ia[31:16]),  .ok1(ok1),  .ok2(ok2x[12*17 +: 17]), .ep_addr(8'h2B)   );    
//        
//        okWireOut wo2C (    .ep_datain(spike_count_Ia_normal[15:0]),  .ok1(ok1),  .ok2(ok2x[13*17 +: 17]), .ep_addr(8'h2C)    );
//        okWireOut wo2D (    .ep_datain(spike_count_Ia_normal[31:16]),  .ok1(ok1),  .ok2(ok2x[14*17 +: 17]), .ep_addr(8'h2D)   );    
//        
//        okWireOut wo2E (    .ep_datain(spike_count_II_normal[15:0]),  .ok1(ok1),  .ok2(ok2x[15*17 +: 17]), .ep_addr(8'h2E)    );
//        okWireOut wo2F (    .ep_datain(spike_count_II_normal[31:16]),  .ok1(ok1),  .ok2(ok2x[16*17 +: 17]), .ep_addr(8'h2F)   );   
//        
//        okWireOut wo30 (    .ep_datain(population_neuron0_II[31:16]),  .ok1(ok1),  .ok2(ok2x[17*17 +: 17]), .ep_addr(8'h30)    );
//        okWireOut wo31 (    .ep_datain(population_neuron0_II[47:32]),  .ok1(ok1),  .ok2(ok2x[18*17 +: 17]), .ep_addr(8'h31)   );        
        
//        okBTPipeIn ep82 (   .ok1(ok1), .ok2(ok2x[19*17 +: 17]), .ep_addr(8'h82), .ep_write(pipe_in_write_timeref),
//                            .ep_blockstrobe(), .ep_dataout(pipe_in_data_timeref), .ep_ready(1'b1));
//        
                


        // Clock Generator clk_gen0 Instance Definition
        gen_clk clocks(
            .rawclk(clk1),
            .half_cnt(triggered_input7),
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
        
    




/////////////////////// END INSTANCE DEFINITIONS //////////////////////////

	// ** LEDs
    assign led[0] = ~reset_global;
    assign led[1] = ~reset_sim;
    assign led[2] = ~spikeout1;
    assign led[3] = ~spikeout2;
    assign led[4] = ~0;
    assign led[5] = ~ep60trig[0]; // fifo almost full
    assign led[6] = ~neuron_clk; // 
    assign led[7] = ~sim_clk; // clock
    
endmodule
