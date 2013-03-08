module spikecnt_async(spike, int_cnt_out, fast_clk, slow_clk, reset, clear_out, cnt, sig1, sig2, read);
    input   spike, slow_clk, fast_clk, reset;
    output  reg [31:0] int_cnt_out, cnt;
    output  clear_out;
    
    output read;
    output reg sig1, sig2;
	 
	 reg [31:0] status_counter;
    always @(posedge reset or posedge fast_clk) begin
        if (reset) begin
            //t1 <= t2;
				status_counter <= 0;
        end
        else begin
		      if (slow_clk) begin
					status_counter <= status_counter + 32'd1;
			   end else begin
				   status_counter <= 32'd0;
				end
        end
    end	 
	
    always @(posedge spike or posedge sig2) // for cleaning
    begin
        if (sig2) begin // cnt being read, lock the register
          cnt <= 32'd0;
        end
        else begin
            if (~sig1) begin
					  cnt <= cnt + 32'd1;
            end
//            case ({sig1, sig2}) 
//                2'b10 : cnt <= cnt; // sig1 = being read, lock the data
//                2'b01 : cnt <= 32'd0; // sig2 = cnt ready for cleaning
//                2'b00 : cnt <= cnt + 32'd1; // ~sig1 && ~sig2 = normal spike counting
//                default : cnt <= cnt; // ERROR, stop counting
//            endcase
        end		  
    end
    
    always @(posedge fast_clk or posedge reset)
    begin
        if (reset) begin
            sig1 <= 1'b0;
            sig2 <= 1'b0;
        end else begin
            sig1 <= {(status_counter == 32'd1) || (status_counter == 32'd2)};
            sig2 <= {(status_counter == 32'd3) || (status_counter == 32'd4)};
        end
    end
    
    always @(posedge sig1 or posedge reset)
    begin
        if (reset) begin
            int_cnt_out <= 32'd0;
        end
        else begin
            int_cnt_out <= cnt;
        end
    end
endmodule



module spikecnt_shaky(spike, int_cnt_out, fast_clk, slow_clk, reset, clear_out, cnt, sig1, sig2, read);
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
				sig1_a <= 0;
        end
        else begin
            if (~sig1 && ~sig2) sig1_a <= ~sig1_a;
				//else t1 <= t1;
        end
    end
	 
	 
	 reg [31:0] count_two_sig1;
	 always @(posedge fast_clk or posedge sig1)
	 begin
	   if (sig1) 
		begin
		  if (count_two_sig1 < 32'd3) begin
		    count_two_sig1 <= count_two_sig1 + 32'd1;
		  end
		  else begin
		    count_two_sig1 <= 32'd0;
		  end	 
		end else begin
		  count_two_sig1 <= count_two_sig1;
		end  
	 end	 
    
	 
	 reg [31:0] count_two_sig2;
	 always @(posedge fast_clk or posedge sig2)
	 begin
	   if (sig2) 
		begin
		  if (count_two_sig2 < 32'd3) begin
		    count_two_sig2 <= count_two_sig2 + 32'd1;
		  end
		  else begin
		    count_two_sig2 <= 32'd0;
		  end	 
		end else begin
		  count_two_sig2 <= count_two_sig2;
		end  
	 end	 	 
	 
	 
    always @(posedge fast_clk or posedge reset) begin
        if (reset) begin
            //t2 <= t1;
				sig1_b <= 0;
        end
        else begin
            if (sig1 && ~sig2 && (count_two_sig1 == 32'd2)) sig1_b <= ~sig1_b;
            //if (sig1) sig1_b <= ~sig1_b;
				//else t2 <= t2;
        end
    end
	 
    
    always @(negedge sig1 or posedge reset) begin
        if (reset) begin
            //t2 <= t1;
				sig2_a <= 0;
        end
        else begin
            if (~sig1 && ~sig2) sig2_a <= ~sig2_a;
				//else t2 <= t2;
        end
    end	 

    
    always @(negedge fast_clk or posedge reset) begin
        if (reset) begin
				sig2_b <= 0;
        end
        else begin
//            if (sig2) sig2_b <= ~sig2_b;
            if (~sig1 && sig2 && (count_two_sig2 == 32'd3)) sig2_b <= ~sig2_b;
				
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
	   if (sig1) begin // cnt being read, lock the register
		  cnt <= cnt;
		end
      else begin
		  if (sig2) begin
		    cnt <= 32'd0;
        end
        else begin
			 cnt <= cnt + 32'd1;
		  end
      end		  
	 end
	 
	 
    wire    out_flag = read && slow_clk;
    
    assign clear_out = out_flag;

endmodule
