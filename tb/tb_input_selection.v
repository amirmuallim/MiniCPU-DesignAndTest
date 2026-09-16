`timescale 1ns / 1ps

module tb_input_selection;

    reg [1:0] ic;
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [7:0] in4;
    reg [7:0] in5;
    reg [7:0] in6;
    reg [7:0] in7;
    reg [7:0] a;
    reg [2:0] j;
    reg [7:0] result;
    wire [7:0] to_reg;


    // for tb
    //
    reg [7:0] const;
	reg [7:0] temp;


    input_selection DUT(.input_ctl(ic),
	    .IN0(in0),
	    .IN1(in1),
	    .IN2(in2),
	    .IN3(in3),
	    .IN4(in4),
	    .IN5(in5),
	    .IN6(in6),
	    .IN7(in7),
	    .A(a),
	    .J(j),
	    .result(result),
	    .to_reg(to_reg));

    task assign_value(input [7:0] y);
	    begin
	    ic = 2'b00;
	    a = y;
	    #1;
	    if(to_reg == y)begin
		    $display("The assigned value is :%d, the sampled value is %d", a, to_reg);
		    $display("The assign value operation is correct");
	    end
	    else
		    $display("The assign value is not correct");
    end
    endtask
			
    task data_input(input [2:0] x);
	    begin
	    ic = 2'b01;
	    j = x;
		#1;
	    begin

	    case(x)
		    0 : temp = in0;
		    1 : temp = in1;
		    2 : temp = in2;
		    3 : temp = in3;
		    4 : temp = in4;
		    5 : temp = in5;
		    6 : temp = in6;
		    7 : temp = in7;
	    endcase

	    if(to_reg == temp)
	    begin
		    $display("The input port selected is %d , the port value is %d and sampled value is %d", j, temp, to_reg);
		    $display("The data_input operation is correct");
	    end
	    else
		    $display("The data_input is'nt correct");
    end
    end
    endtask

    task operation;
	    begin
	    ic = 2'b10;
		#1;
	    if(to_reg == result)
	    begin
		    $display("The sampled output is %d with result as %d", to_reg, result);
		    $display("The - operation is correct");
	    end
	    else
		    $display("The - is'nt correct");
    end
    endtask

    task dont_care;
	    begin
	    ic = 2'b11;
	    #1;
	    $display("The to_reg value for ic = 2'd11 dont care operaiton is :%d", to_reg);
	    if(to_reg == 8'd0)
		    $display("The don_care op is correct");
	    else
		    $display("The dont_care op is'nt correct");

    end
    endtask
	
    initial begin

		$dumpfile("input_selection.vcd");
		$dumpvars(0, tb_input_selection);
	    // checking assign value
	    const = 8'd10;
	    assign_value(const);

	    // checking data input
	    in0 = 8'd15;
	    data_input(3'd0);

	    // checking opertiaon
	    result = 8'd23;
	    operation();

	    // checking dont_care ic
	    dont_care();
	    
	    $finish;
    end

endmodule
