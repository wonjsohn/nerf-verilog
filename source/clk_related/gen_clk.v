module gen_clk(rawclk, reset, half_cnt, clk_out1, clk_out2, clk_out3, int_neuron_cnt_out);
    parameter NN = 6; // 2^(NN+1) = NUM_NEURON
    parameter SR = 10; // 2^SR = SAMPLING_RATE
    parameter CYCLE = 1; // 2^CYCLE = Iterations cycles needed for each neuron
    input rawclk;
    input reset;
    input [31:0] half_cnt;
    output reg clk_out1, clk_out2, clk_out3;
    output [31:0] int_neuron_cnt_out;

    reg [31:0] delay_cnt;

    always @ (posedge rawclk) begin
	     if (reset) begin
            clk_out1 <= 0;
				delay_cnt <= 0;
		  end 
		  
		  else begin
			  if (delay_cnt < half_cnt) begin
					clk_out1 <= clk_out1;
					delay_cnt <= delay_cnt + 1;
			  end
			  else begin
					clk_out1 <= ~clk_out1;
					delay_cnt <= 0;
			  end
		  end
    end	 
	 
	 
	 
	reg [NN+CYCLE:0] neuronCounter;
	wire [NN:0] neuronIndex;

	assign neuronIndex = neuronCounter[NN+CYCLE:CYCLE];

	always @ (posedge clk_out1 or posedge reset)
	begin
        if (reset) begin
            neuronCounter <= 0;
				clk_out2 <= 0;
				clk_out3 <= 0;
        end else begin
            neuronCounter <= neuronCounter + 1'b1;
            clk_out2 <= {neuronIndex == 0};
            clk_out3 <= {(neuronIndex == 40) || (neuronIndex == 9'd80) ||
                        (neuronIndex == 9'd120)};
            end
	end
	 
	 wire [32-NN-CYCLE-2:0] zerofiller;
	 assign zerofiller = 0;
    assign int_neuron_cnt_out = {zerofiller, neuronCounter};
endmodule
