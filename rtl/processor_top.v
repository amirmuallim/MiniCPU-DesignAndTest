`timescale 1ns / 1ps

module processor_top(input clk,
	input rst,

	input signed [7:0] IN0,
	input signed [7:0] IN1,
	input signed [7:0] IN2,
	input signed [7:0] IN3,
	input signed [7:0] IN4,
	input signed [7:0] IN5,
	input signed [7:0] IN6,
	input signed [7:0] IN7,
	
	input [15:0] instr, 

	output signed [7:0] OUT0,
	output signed [7:0] OUT1,
	output signed [7:0] OUT2,
	output signed [7:0] OUT3,
	output signed [7:0] OUT4,
	output signed [7:0] OUT5,
	output signed [7:0] OUT6,
	output signed [7:0] OUT7,
	
	output [7:0] number);

wire write_reg = (~instr[15]);
wire out_en = (instr[15] && (~instr[14]));

wire signed [7:0] result;
wire signed [7:0] reg_in;

wire signed [7:0] left_out, right_out;


input_selection i_s(instr[14:13],
	IN0,
	IN1,
	IN2,
	IN3,
	IN4,
	IN5,
	IN6,
	IN7,
	instr[11:4],
	instr[6:4],
	result,
	reg_in);

register_bank r_b(clk,
	reg_in,
	write_reg,
	instr[3:0],
	instr[11:8],
	instr[7:4],
	left_out,
	right_out);

arithmetic_unit a_u(left_out,
	right_out,
	instr[12],
	result);

output_selection o_u(clk,
	right_out,
	out_en,
	instr[13], // out_sel
	instr[7:0], // A
	instr [10:8], // i
	OUT0,
	OUT1,
	OUT2,
	OUT3,
	OUT4,
	OUT5,
	OUT6,
	OUT7);

go_to g_t(clk,
	rst,
	instr[15:12], // numb_sel
	left_out, // data
	instr[7:0], // N
	number);

endmodule
