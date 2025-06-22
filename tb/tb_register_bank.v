`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2025 18:08:59
// Design Name: 
// Module Name: tb_register_bank
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


module tb_register_bank;

reg clk = 1'b0;
reg [7:0] reg_in;
reg write_reg;
reg [3:0] k, i, j;

wire [7:0] left_out, right_out;

// for tb
integer m,n;

register_bank DUT(clk,
	reg_in,
	write_reg,
	k,
	i,
	j,
	left_out, 
	right_out);

parameter cycle = 10,
	thold = 1,
	tsetup = 1;

always #5 clk = ~clk;

task assign_value(input [3:0] x);
	begin
	
	write_reg = 1'b1;
	reg_in = $urandom;
	k = x;

	@(posedge clk);
	#(thold);

	if(DUT.mem[k] == reg_in)
	begin
		$display("The assigned value is %d at %d addr. The actual value stored in dut is %d",reg_in, k, DUT.mem[k]);
	$display("The assign_value op is working");
end
	else
	$display("The assign_value op isn't working");	
	{write_reg, reg_in, k} = 'bx;
	#(cycle-thold-tsetup);
end
endtask

task operation(input [3:0] x, input [3:0] y);
	begin
		write_reg = 1'b1;
		i = x;
		j = y;
	@(posedge clk);
	#(thold);
fork
	if(DUT.mem[i] == left_out)
	begin
		$display("The sampled value is %d at %d addr. The actual value stored in dut is %d",left_out, i, DUT.mem[i]);
	$display("The operation left_out op is working");
	end
	else
	$display("The operation left_out op isn't working");

	if(DUT.mem[j] == right_out)
	begin
		$display("The sampled value is %d at %d addr. The actual value stored in dut is %d",right_out, j, DUT.mem[j]);
	$display("The operation right_out op is working");
	end
	else
	$display("The operation right_out op isn't working");
join

	{write_reg, i, j} = 'bx;
	#(cycle-thold-tsetup);
end
endtask

// assing_value(k);
// operation(i, j);
//
initial begin
	for(m = 0; m < 16; m = m+1)
	begin
		assign_value(m);
	end

	for(n = 0; n < 16;n = n+1)
	begin
		operation(n, n);
	end

	$finish;
end
	

endmodule
