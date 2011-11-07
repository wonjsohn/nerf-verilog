module spike_counter(spike, int_cnt_out, slow_clk, clk, reset, cnt, slow_clk_up, spike_while_slow_clk);
//module spike_counter(spike, int_cnt_out, slow_clk, clk, reset, cnt, slow_clk_bar, slow_clk_reg, slow_clk_up, spike_while_slow_clk, spike_out);

	input   spike, slow_clk, clk, reset;
   output  reg    [31:0]  int_cnt_out;
	output slow_clk_up, spike_while_slow_clk;   
   output reg     [31:0]  cnt;
	 
	reg slow_clk_up; 
   always @(posedge reset or posedge slow_clk or posedge slow_clk_up) begin
	  if (reset) begin 
			slow_clk_up <= 1'b0;
	  end 
	  else if (slow_clk) begin
			slow_clk_up <= 1'b1;
        end
	  else begin
			slow_clk_up <= 1'b0;
        end
    end 

     
    always @(posedge reset or posedge slow_clk_up or posedge spike) begin
	  if (reset) begin
			cnt <= 32'd0;
			int_cnt_out <= 32'd0;	
	  end
	  else if (slow_clk_up && spike) begin   // SPIKE HIGH and SLOW_CLK UP.
			int_cnt_out <= cnt;
			cnt <= 32'd1;  // add one spike                 
	  end   
	  else if (slow_clk_up) begin  // SLOW CLK UP, NO SPIKE
			int_cnt_out <= cnt;
			cnt <= 32'd0;    // count being renewed at every posedge of slow clock = read.
	  end
	  else begin//if (spike) begin //   SPIKE HIGH ONLY
			int_cnt_out <= int_cnt_out;
			cnt <= cnt + 32'd1;
	end
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
    


