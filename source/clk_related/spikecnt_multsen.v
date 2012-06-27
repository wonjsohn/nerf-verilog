module spike_counter(spike, int_cnt_out, slow_clk, reset, clear_out);
    input   spike, slow_clk, reset;
    output  reg    [31:0]  int_cnt_out;
    reg     [31:0]  cnt;
	 reg slow_clk_up; 
    output clear_out;
    assign clear_out = slow_clk_up;
	 
    always @(posedge reset or posedge slow_clk or posedge spike) begin
        if (reset) begin 
            slow_clk_up <= 1'b0;
        end 
		  else if (spike) begin
				slow_clk_up <= 1'b0;	
		  end
		  else begin
            slow_clk_up <= 1'b1;
        end
    end 


	 
    always @(posedge reset or posedge slow_clk_up or posedge spike) begin
	  if (reset) begin
			cnt <= 32'd0;
			int_cnt_out <= 32'd0;	
	  end
	  else if (spike && !slow_clk_up) begin //   SPIKE HIGH ONLY
			int_cnt_out <= int_cnt_out;
			cnt <= cnt + 32'd1;
	  end
	  else begin   // SPIKE HIGH and SLOW_CLK UP.
			int_cnt_out <= cnt;
			cnt <= 32'd0;  // add one spike                 
	  end   
//	  else if (!slow_clk_up && (spike == 1'b0)) begin  // SLOW CLK UP, NO SPIKE
//			int_cnt_out <= cnt;
//			cnt <= 32'd0;    // count being renewed at every posedge of slow clock = read.
//	  end

  end  

endmodule	 
     
// Button experiment
     
//    always @(posedge reset or posedge button1 or posedge button2 or posedge spike) begin
//             if (reset) begin
//                button1_response <= 1'b0;
//                button2_response <= 1'b0;
//                spike_out <= 1'b0;
//             end
//             else if (button1) begin
//                button1_response <= 1'b1;
//                button2_response <= 1'b0;
//                spike_out <= 1'b0;
//             end
//             else if (button2) begin
//                button1_response <= 1'b0;
//                button2_response <= 1'b1;
//                spike_out <= 1'b0;
//             end
//             else begin
//                button1_response <= 1'b0;
//                button2_response <= 1'b0;
//                spike_out <= 1'b1;
//             end
//         end
//          
    


