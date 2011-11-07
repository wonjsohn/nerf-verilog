module spike_counter(spike, int_cnt_out, slow_clk, clk, reset, cnt, slow_clk_bar, slow_clk_reg, slow_clk_up, spike_while_slow_clk, spike_out);
//module spike_counter(spike, int_cnt_out, slow_clk, clk, reset, cnt, slow_clk_bar, slow_clk_reg, slow_clk_up, spike_while_slow_clk, button1, button2, button1_response, button2_response, spike_out);
    input   spike, slow_clk, clk, reset;
    //input  button1, button2; // testing sensitivity list
    output  reg[31:0] int_cnt_out;
	output slow_clk_bar, slow_clk_up, slow_clk_reg, spike_while_slow_clk;
    //output reg  button1_response, button2_response, 
    output reg spike_out;
    
   // output  clear_ut;
          
    output reg     [31:0]  cnt;
    assign slow_clk_up = (slow_clk && ~slow_clk_reg)? 1'b1 : 1'b0;
	assign spike_while_slow_clk = (spike && slow_clk_up )? 1'b1 : 1'b0;
	 

     
    always @(posedge reset or posedge spike_while_slow_clk or posedge slow_clk_up or posedge spike) begin
        if (reset) begin
				cnt <= 32'b0;
				int_cnt_out <= 32'b0;	
                spike_out <= 1'b0;
        end
		else if (spike_while_slow_clk) begin   // SPIKE HIGH and SLOW_CLK UP.
				int_cnt_out <= cnt;
				cnt <= 1'b1;  // add one spike  
				//cnt <= 32'b1;  //  count from 1. 
                spike_out <= 1'b0;
		  end
        
        else if (slow_clk_up) begin  // SLOW CLK UP, NO SPIKE
		//  else begin
				int_cnt_out <= cnt;
				cnt <= 32'b0;  
                spike_out <= 1'b1;
		end
        else begin//if (spike) begin //   SPIKE HIGH ONLY
				int_cnt_out <= int_cnt_out;
                cnt <= cnt + 32'd1;
                spike_out <= 1'b0;
		end
     end  
	 
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
     
	 reg  slow_clk_reg;
	 always @(posedge reset or posedge clk) begin
			if (reset)
				 slow_clk_reg <= 0;
			else 
				 slow_clk_reg <= slow_clk; // one cycle delaying
	 end
	 
	 reg  slow_clk_bar;
	 always @(posedge reset or negedge clk) begin
			if (reset)
				 slow_clk_bar <= 0;
			else 
				 slow_clk_bar <= slow_clk_reg; // one cycle delaying
	 end
	 
	
	 
//    
//    always @(posedge spike) begin
//        if (read) begin
//            cnt <= 32'd1;
//        end
//        else begin
//            cnt <= cnt + 32'd1;
//        end
//    end
  
    
    //assign clear_out = out_flag;

endmodule

//module spikecnt(spike, int_cnt_out, fast_clk, slow_clk, reset, clear_out);
//    input   spike, slow_clk, fast_clk, reset;
//    output  reg [31:0] int_cnt_out;
//    output  clear_out;
//          
//    reg     [31:0]  cnt;
//    reg     t2;
//    always @(posedge spike or posedge reset) begin
//        if (reset) begin
//            cnt <= 32'd0;
//        end
//        else begin
//            cnt = cnt + 32'd1;
//            if (read) begin 
//                t2 = ~t2;
//                cnt = 32'd0;
//            end
//        end
//    end
//    
//    always @(posedge slow_clk or posedge reset) begin
//        if (reset) begin
//            int_cnt_out <= 32'd0;
//        end
//        else begin
//            int_cnt_out <= cnt;
//        end
//    end
//    
//    reg t1;
//    always @(posedge reset or posedge slow_clk) begin
//        if (reset) begin
//            t1 <= 0;
//        end
//        else begin
//            if (read) t1 <= t1;
//            else t1 <= ~t1;
//        end
//    end
//    
//    wire    read = t1 ^ t2;
//    wire    out_flag = read && slow_clk;
//    assign clear_out = out_flag;
//
//endmodule



//module spikecnt(spike, int_cnt_out, fast_clk, slow_clk, reset, clear_out, t1, t2, read, cnt);
//   input   spike, slow_clk, fast_clk, reset;
//   output  reg [31:0] int_cnt_out;
//   output  clear_out;
//        output  t1, t2, read;
//        output  [31:0] cnt;
//         
//   reg     [31:0]  cnt;
//   reg     t2;
//    always @(posedge spike or posedge out_flag) begin
////        if (reset) begin
////            cnt <= 32'd0;
////                                t2 <= 0;
////        end
//       //else begin
//        if (out_flag) begin
//            cnt <= 32'd0;
//        end
//        cnt <= cnt + 32'd1;
//        if (read) begin
//            t2 <= ~t2;
//        end
//
//       //end
//   end
//   
//   always @(posedge slow_clk or posedge reset) begin
//       if (reset) begin
//           int_cnt_out <= 32'd0;
//       end
//       else begin
//           int_cnt_out <= cnt;
//           //cnt <= 32'd0;
//       end
//   end
//   
//   reg t1;
//   always @(posedge reset or posedge slow_clk) begin
//       if (reset) begin
//           t1 <= 0;
//       end
//       else begin
//           if (read) t1 <= t1;
//           else t1 <= ~t1;
//       end
//   end
//   
//   wire    read = t1 ^ t2;
//   wire    out_flag = read && slow_clk;
//   assign clear_out = out_flag;
//
//endmodule