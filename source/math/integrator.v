module integrator
(
		input wire [31:0] x,
        input wire [31:0] int_x,
		output wire [31:0] out // out = x*dt + int_x
);
	
    wire [31:0] int_x_F0;

	wire [4:0] int_adder_flags;
	wire [1:0] int_adder_error;
	reg [31:0] x_by_dt;
	wire [7:0] x_by_dt_exp;
	wire [22:0] x_by_dt_man;
	reg x_by_dt_underflow;
	
	
	assign x_by_dt_exp = x[30:23] - 8'd10;
	assign x_by_dt_man = x[22:0];
	
	always @ (x)
	begin
		if ( x[30:23]<= 8'd10 )
			begin
				x_by_dt = 0;
				x_by_dt_underflow=1;
			end
		else
			begin
				x_by_dt = {x[31], x_by_dt_exp, x_by_dt_man};
				x_by_dt_underflow = 0;
			end
	end
	
	add int_adder
		(	.x(int_x), .y(x_by_dt), .out(int_x_F0) ); 

	assign out = int_x_F0;
    //assign out = 32'h3f67b7cc;
endmodule

module integrator_trapezoid
(
		input wire [31:0] x,
        input wire [31:0] x_hat,
        input wire [31:0] int_x,
		output wire [31:0] out // out = (x+x_hat)*dt/2 + int_x
);
	
    wire [31:0] int_x_F0;

	wire [4:0] int_adder_flags;
	wire [1:0] int_adder_error;
	reg [31:0] x_by_dt;
	wire [7:0] x_by_dt_exp;
	wire [22:0] x_by_dt_man;
	reg x_by_dt_underflow;
	
	wire [31:0] x_plus_x_hat;
    add A1(.x(x), .y(x_hat), .out(x_plus_x_hat));
	assign x_by_dt_exp = x_plus_x_hat[30:23] - 8'd11;
	assign x_by_dt_man = x_plus_x_hat[22:0];
	
	always @ (x_plus_x_hat)
	begin
		if ( x_plus_x_hat[30:23]<= 8'd11 )
			begin
				x_by_dt = 0;
				x_by_dt_underflow=1;
			end
		else
			begin
				x_by_dt = {x_plus_x_hat[31], x_by_dt_exp, x_by_dt_man};
				x_by_dt_underflow = 0;
			end
	end
	
	add int_adder
		(	.x(int_x), .y(x_by_dt), .out(int_x_F0) ); 

	assign out = int_x_F0;
    //assign out = 32'h3f67b7cc;
endmodule
