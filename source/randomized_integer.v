`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Design Name: 
// Module Name:    
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


// 
module randomized_integer(
    input   wire [31:0]  i_in,     //
    input   wire neuron_clk,
    input   wire reset_global,
    output wire  [31:0] i_rand_out

    );

     //wire [31:0] f_in;
     //int_to_float get_f(.out(f_in), .in(i_in));
     
        wire [31:0] rand_out;
        rng rng_0(
                .clk1(neuron_clk),
                .clk2(neuron_clk),
                .reset(reset_global),
                .out(rand_out)
        ); 
        
//        wire [31:0] i_out; 
        assign i_rand_out= {i_in[31:10] , rand_out[9:0]};
        
        //wire [31:0] f_randn_F0 = {12'h3F8, rand_out[19:0]};
        //wire [31:0] f_rand_Ia_F0; 
        //mult get_rand_Ia( .x(f_in), .y(f_randn), .out(f_rand_Ia_F0));

        //wire signed [31:0] i_synI_Ia, fixed_synI_Ia;
        //floor float_to_int_Ia( .in(f_rand_Ia), .out(i_synI_Ia) );   

        //assign fixed_synI_Ia = i_synI_Ia <<< 6;

//         reg    [31:0] f_rand_Ia, f_randn;
//         always @(posedge neuron_clk or posedge reset_global) begin
//            if (reset_global) begin
//                i_out <= 32'd0;
////                f_fr_Ia <= 32'd0;
//                f_rand_Ia <= 32'd0;
//                f_randn <= 32'd0;
//            end
//            else begin
//                i_out <= fixed_synI_Ia;
////                f_fr_Ia <= f_fr_Ia_F0; 
//                f_rand_Ia <= f_rand_Ia_F0;                  
//                f_randn <= f_randn_F0;
//            end
//         end
endmodule

