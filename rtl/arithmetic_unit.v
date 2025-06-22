`timescale 1ns / 1ps

module arithmetic_unit(input signed [7:0] left_in, 
	input signed [7:0] right_in,
	input f,
	output signed [7:0] result

    );
assign result = f ? (left_in-right_in) : (left_in+right_in);
    
endmodule
