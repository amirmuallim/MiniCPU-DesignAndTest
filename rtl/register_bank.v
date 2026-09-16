`timescale 1ns / 1ps

module register_bank(
	input clk,
	input signed [7:0] reg_in,
	input write_reg,
	input [3:0] k, // write index
	input [3:0] i, // read index 1 / left
	input [3:0] j, // read index 2 / right
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
