`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2025 15:51:51
// Design Name: 
// Module Name: register_bank
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_bank(input clk,
	input signed [7:0] reg_in,
	input write_reg,
	input [3:0] k,
	input [3:0] i,
	input [3:0] j,
	output signed [7:0] left_out,
	output signed [7:0] right_out);

reg signed [7:0] mem [15:0];

reg signed [7:0] lo, ro;

always @(posedge clk)
begin
	if(write_reg)
		mem[k] <= reg_in;

	// left_out <= mem[i];		
	// right_out <= mem[j];
	
end

assign left_out = mem[i];		
assign right_out = mem[j];

endmodule
