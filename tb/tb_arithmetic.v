`timescale 1ns / 1ps

module tb_arithmetic_unit;

reg signed [7:0] left, right;
reg f;
wire signed [7:0] result;

arithmetic_unit DUT(left,
	right, 
	f,
	result);

task add(input signed [7:0] a, input signed [7:0] b);
	begin
	f = 0;
	left = a;
	right = b;

	#1;
	if(result == (a+b))
		$display("ADD SUCCESS, %d + %d = %d", a, b, result);
	else
		$display("ADD FAILURE, %d + %d = %d", a, b, result);
end
endtask

task sub(input signed [7:0] a, input signed [7:0] b);
	begin
	f = 1;
	left = a;
	right = b;
	#1;
	if(result == (a-b))
		$display("SUB SUCCESS, %d - %d = %d", a, b, result);
	else
		$display("SUB FAILURE, %d - %d = %d", a, b, result);
end
endtask

// add(a,b)
// sub(a,b)
// a,b -> can be signed integers


initial begin
	$dumpfile("arithmetic_unit.vcd");
	$dumpvars(0, tb_arithmetic);

	add(5,7);
	sub(3,2);
	add(4,-2);
	add(22,5);
	sub(32,-4);
	sub(5,7);
end

endmodule
