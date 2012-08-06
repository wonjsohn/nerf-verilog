
module spikecnt(spike, int_cnt_out, fast_clk, slow_clk, reset, clear_out, cnt, sig1, sig2, read);
    input   spike, slow_clk, fast_clk, reset;
    output  reg [31:0] int_cnt_out, cnt;
    output  clear_out;
          
    //reg     [31:0]  cnt;
    reg sig1_a, sig1_b, sig2_a, sig2_b;
	 output read;
	 output wire sig1, sig2;
	 
    always @(posedge reset or posedge slow_clk) begin
        if (reset) begin
            //t1 <= t2;
				sig1_a <= 1;
        end
        else begin
            if (~sig1) sig1_a <= ~sig1_a;
				//else t1 <= t1;
        end
    end
	 
	 
	 reg [31:0] count_two;
	 always @(posedge fast_clk or posedge sig1)
	 begin
	   if (sig1) 
		begin
		  if (count_two < 32'd3) begin
		    count_two <= count_two + 32'd1;
		  end
		  else begin
		    count_two <= 32'd0;
		  end	 
		end else begin
		  count_two <= count_two;
		end  
	 end	 
    
    always @(negedge spike or posedge reset) begin
        if (reset) begin
            //t2 <= t1;
				sig1_b <= 0;
        end
        else begin
            if (sig1 && (count_two == 32'd2)) sig1_b <= ~sig1_b;
				//else t2 <= t2;
        end
    end
	 
    
    always @(negedge sig1 or posedge reset) begin
        if (reset) begin
            //t2 <= t1;
				sig2_a <= 0;
        end
        else begin
            if (~sig2) sig2_a <= ~sig2_a;
				//else t2 <= t2;
        end
    end	 

    
    always @(negedge fast_clk or posedge reset) begin
        if (reset) begin
				sig2_b <= 0;
        end
        else begin
            if (sig2) sig2_b <= ~sig2_b;
				//else t2 <= t2;
        end
    end	 	 
    
    assign    sig1 = sig1_a ^ sig1_b;
	 assign	  sig2 = sig2_a ^ sig2_b;
	 
	 
	 always @(posedge slow_clk or posedge reset) // for reading
	 begin
	   if (reset) begin
		  int_cnt_out <= 32'd0;
		end
		else begin		  
		  int_cnt_out <= cnt;
		end
	 end
	 
	 always @(posedge sig2 or posedge spike) // for cleaning
	 begin
	   if (sig1) begin
		  cnt <= cnt;
		end
      else begin
		  if (sig2) begin
		    cnt <= 32'd1;
        end
        else begin
			 cnt <= cnt + 32'd1;
		  end
      end		  
	 end
	 
	 
    wire    out_flag = read && slow_clk;
    
    assign clear_out = out_flag;

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