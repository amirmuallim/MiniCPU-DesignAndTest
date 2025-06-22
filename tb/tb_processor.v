`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2025 16:38:57
// Design Name: 
// Module Name: tb_processor
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


module tb_processor;

// SIGNAL DECLARATION //

reg clk = 1'b0,rst;

reg signed [7:0] IN0,
	IN1,
	IN2,
	IN3,
	IN4,
	IN5,
	IN6,
	IN7;

reg [15:0] instr;

wire signed [7:0] OUT0,
	OUT1,
	OUT2,
	OUT3,
	OUT4,
	OUT5,
	OUT6,
	OUT7;

wire [7:0] number;

// for tb

integer i;

// PROGRAM MEM //

reg [15:0] mem [255:0];

////////////////////////////////////////////////////////
///////// INSTRUCTION ENCODING /////////////////////////
////////////////////////////////////////////////////////

//  ASSING VALUE INSTR // assign_value(k,a); --> X(k) = A;

function [15:0] assign_value(input [3:0] x, input [7:0] y);
	assign_value = {4'b0000, y, x};
endfunction

// DATA INPUT INSTR // data_input(j, k); --> X(k) = IN(j);

function [15:0] data_input(input [3:0] x, input [3:0] y);
	data_input = {4'b0010, 4'b0000, x, y};
endfunction

// DATA OUTPUT INSTR // data_output(i, j); --> OUT(i) = X(j);

function [15:0] data_output(input [3:0] x, input [3:0] y);
	data_output = {4'b1010, x, y, 4'b0000};
endfunction

// OUTPUT VALUE INSTR // output_value(i, A); --> OUT(i) = A;

function [15:0] output_value(input [3:0] x, input [7:0] y);
	output_value = {4'b1000, x,  y, 4'b0000};
endfunction

// ADD INSTR // add(i, j, k); --> X(k) = X(i)+X(j);

function [15:0] add(input [3:0] x, input [3:0] y, input [3:0] z);
	add = {4'b0100, x, y, z};
endfunction


// SUB INSTR // sub(i, j, k); --> X(k) = X(i)-X(j);

function [15:0] sub(input [3:0] x, input [3:0] y, input [3:0] z);
	sub = {4'b0101, x, y, z};
endfunction

// JUMP INSTR // jump(n); --> goto n;

function [15:0] jump(input [7:0] x);
	jump = {4'b1110, 4'b0000, x};
endfunction


// JUMP_POS INSTR // jump_pos(i, n); --> if X(i) > 0 then goto n;

function [15:0] jump_pos(input [3:0] y, input [7:0] x);
	jump_pos = {4'b1100, y, x};
endfunction

// JUMP_NEG INSTR // jumb_neg(i, n); --> if X(i) < 0 then goto n;

function [15:0] jump_neg(input [3:0] y, input [7:0] x);
	jump_neg = {4'b1101, y, x};
endfunction

//////////////////////////////////////////////////////////////////
/////////////// SELF CHECKING INSTRUCTION ENCODING ///////////////
/////////////////////////////////////////////////////////////////

// test_assign_value(k, A); --> X(k) = A
task test_assign_value(input [3:0] k, input signed [7:0] A);
    begin
        instr = assign_value(k, A);
        @(posedge clk); #(thold);
        if (DUT.r_b.mem[k] === A) begin
            $display("\033[32m\033[32m[PASS]\033[0m\033[0m assign_value: X(%0d) = %0d OK, Given Const Value: %0d --> X(%0d)",
                     k, DUT.r_b.mem[k], A, k);
        end
        else begin
            $error("\033[31m\033[31m[FAIL]\033[0m\033[0m assign_value: X(%0d) expected %0d, got %0d (Const Value: %0d)",
                    k, A, DUT.r_b.mem[k], A);
        end
    end
endtask


// test_data_input(j, k); --> X(k) = IN(j)
task test_data_input(input [3:0] j, input [3:0] k, input signed [7:0] data);
    begin
        case (j)
            4'd0: IN0 = data;  4'd1: IN1 = data;  4'd2: IN2 = data;  4'd3: IN3 = data;
            4'd4: IN4 = data;  4'd5: IN5 = data;  4'd6: IN6 = data;  4'd7: IN7 = data;
        endcase
        instr = data_input(j, k);
        @(posedge clk); #thold;
        if (DUT.r_b.mem[k] === data)
            $display("\033[32m[PASS]\033[0m data_input: X(%0d) = %0d OK, Given Data: %0d to IN[%0d] to store in X(%0d)", k, DUT.r_b.mem[k], data, j, k);
        else
            $error("\033[31m[FAIL]\033[0m data_input: X(%0d) expected %0d, got %0d",
                    k, data, DUT.r_b.mem[k]);
    end
endtask

// test_data_output(i, j): Verify OUT(i) matches X(j) register value
task test_data_output(input [3:0] i, input [3:0] j);
    begin
        instr = data_output(i, j);  // Form instruction
        @(posedge clk); #thold;
        case (i)
            4'd0: if (OUT0 === DUT.r_b.mem[j]) 
                    $display("\033[32m[PASS]\033[0m data_output: OUT0 OK (i=%0d, j=%0d), Expected %0d, Got %0d",
                             i, j, DUT.r_b.mem[j], OUT0); 
                  else 
                    $error("\033[31m[FAIL]\033[0m data_output: OUT0 mismatch (i=%0d, j=%0d), Expected %0d, Got %0d",
                           i, j, DUT.r_b.mem[j], OUT0);
            4'd1: if (OUT1 === DUT.r_b.mem[j]) 
                    $display("\033[32m[PASS]\033[0m data_output: OUT1 OK (i=%0d, j=%0d), Expected %0d, Got %0d",
                             i, j, DUT.r_b.mem[j], OUT1); 
                  else 
                    $error("\033[31m[FAIL]\033[0m data_output: OUT1 mismatch (i=%0d, j=%0d), Expected %0d, Got %0d",
                           i, j, DUT.r_b.mem[j], OUT1);
            4'd2: if (OUT2 === DUT.r_b.mem[j]) 
                    $display("\033[32m[PASS]\033[0m data_output: OUT2 OK (i=%0d, j=%0d), Expected %0d, Got %0d",
                             i, j, DUT.r_b.mem[j], OUT2); 
                  else 
                    $error("\033[31m[FAIL]\033[0m data_output: OUT2 mismatch (i=%0d, j=%0d), Expected %0d, Got %0d",
                           i, j, DUT.r_b.mem[j], OUT2);
            4'd3: if (OUT3 === DUT.r_b.mem[j]) 
                    $display("\033[32m[PASS]\033[0m data_output: OUT3 OK (i=%0d, j=%0d), Expected %0d, Got %0d",
                             i, j, DUT.r_b.mem[j], OUT3); 
                  else 
                    $error("\033[31m[FAIL]\033[0m data_output: OUT3 mismatch (i=%0d, j=%0d), Expected %0d, Got %0d",
                           i, j, DUT.r_b.mem[j], OUT3);
            4'd4: if (OUT4 === DUT.r_b.mem[j]) 
                    $display("\033[32m[PASS]\033[0m data_output: OUT4 OK (i=%0d, j=%0d), Expected %0d, Got %0d",
                             i, j, DUT.r_b.mem[j], OUT4); 
                  else 
                    $error("\033[31m[FAIL]\033[0m data_output: OUT4 mismatch (i=%0d, j=%0d), Expected %0d, Got %0d",
                           i, j, DUT.r_b.mem[j], OUT4);
            4'd5: if (OUT5 === DUT.r_b.mem[j]) 
                    $display("\033[32m[PASS]\033[0m data_output: OUT5 OK (i=%0d, j=%0d), Expected %0d, Got %0d",
                             i, j, DUT.r_b.mem[j], OUT5); 
                  else 
                    $error("\033[31m[FAIL]\033[0m data_output: OUT5 mismatch (i=%0d, j=%0d), Expected %0d, Got %0d",
                           i, j, DUT.r_b.mem[j], OUT5);
            4'd6: if (OUT6 === DUT.r_b.mem[j]) 
                    $display("\033[32m[PASS]\033[0m data_output: OUT6 OK (i=%0d, j=%0d), Expected %0d, Got %0d",
                             i, j, DUT.r_b.mem[j], OUT6); 
                  else 
                    $error("\033[31m[FAIL]\033[0m data_output: OUT6 mismatch (i=%0d, j=%0d), Expected %0d, Got %0d",
                           i, j, DUT.r_b.mem[j], OUT6);
            4'd7: if (OUT7 === DUT.r_b.mem[j]) 
                    $display("\033[32m[PASS]\033[0m data_output: OUT7 OK (i=%0d, j=%0d), Expected %0d, Got %0d",
                             i, j, DUT.r_b.mem[j], OUT7); 
                  else 
                    $error("\033[31m[FAIL]\033[0m data_output: OUT7 mismatch (i=%0d, j=%0d), Expected %0d, Got %0d",
                           i, j, DUT.r_b.mem[j], OUT7);
            default: $error("\033[31m[FAIL]\033[0m data_output: Invalid OUT index i=%0d", i);
        endcase
    end
endtask



// test_output_value(i, A): Verify OUT(i) matches immediate value A
task test_output_value(input [3:0] i, input signed [7:0] A);
    begin
        instr = output_value(i, A); 
        @(posedge clk); #thold;
        case (i)
            4'd0: if (OUT0 === A) 
                    $display("\033[32m[PASS]\033[0m output_value: OUT0 OK (i=%0d, Expected %0d, Got %0d)", i, A, OUT0); 
                  else 
                    $error("\033[31m[FAIL]\033[0m output_value: OUT0 mismatch (i=%0d). Expected %0d, Got %0d", i, A, OUT0);
            4'd1: if (OUT1 === A) 
                    $display("\033[32m[PASS]\033[0m output_value: OUT1 OK (i=%0d, Expected %0d, Got %0d)", i, A, OUT1); 
                  else 
                    $error("\033[31m[FAIL]\033[0m output_value: OUT1 mismatch (i=%0d). Expected %0d, Got %0d", i, A, OUT1);
            4'd2: if (OUT2 === A) 
                    $display("\033[32m[PASS]\033[0m output_value: OUT2 OK (i=%0d, Expected %0d, Got %0d)", i, A, OUT2); 
                  else 
                    $error("\033[31m[FAIL]\033[0m output_value: OUT2 mismatch (i=%0d). Expected %0d, Got %0d", i, A, OUT2);
            4'd3: if (OUT3 === A) 
                    $display("\033[32m[PASS]\033[0m output_value: OUT3 OK (i=%0d, Expected %0d, Got %0d)", i, A, OUT3); 
                  else 
                    $error("\033[31m[FAIL]\033[0m output_value: OUT3 mismatch (i=%0d). Expected %0d, Got %0d", i, A, OUT3);
            4'd4: if (OUT4 === A) 
                    $display("\033[32m[PASS]\033[0m output_value: OUT4 OK (i=%0d, Expected %0d, Got %0d)", i, A, OUT4); 
                  else 
                    $error("\033[31m[FAIL]\033[0m output_value: OUT4 mismatch (i=%0d). Expected %0d, Got %0d", i, A, OUT4);
            4'd5: if (OUT5 === A) 
                    $display("\033[32m[PASS]\033[0m output_value: OUT5 OK (i=%0d, Expected %0d, Got %0d)", i, A, OUT5); 
                  else 
                    $error("\033[31m[FAIL]\033[0m output_value: OUT5 mismatch (i=%0d). Expected %0d, Got %0d", i, A, OUT5);
            4'd6: if (OUT6 === A) 
                    $display("\033[32m[PASS]\033[0m output_value: OUT6 OK (i=%0d, Expected %0d, Got %0d)", i, A, OUT6); 
                  else 
                    $error("\033[31m[FAIL]\033[0m output_value: OUT6 mismatch (i=%0d). Expected %0d, Got %0d", i, A, OUT6);
            4'd7: if (OUT7 === A) 
                    $display("\033[32m[PASS]\033[0m output_value: OUT7 OK (i=%0d, Expected %0d, Got %0d)", i, A, OUT7); 
                  else 
                    $error("\033[31m[FAIL]\033[0m output_value: OUT7 mismatch (i=%0d). Expected %0d, Got %0d", i, A, OUT7);
            default: $error("\033[31m[FAIL]\033[0m output_value: Invalid OUT index i=%0d", i);
        endcase
    end
endtask



// test_add(i, j, k); --> X(k) = X(i) + X(j)
task test_add(input [3:0] i, input [3:0] j, input [3:0] k);
    reg signed [7:0] expected;
    reg signed [7:0] val_i, val_j;  // snapshot inputs
    begin
        // Take snapshots before executing instruction
        val_i = DUT.r_b.mem[i];
        val_j = DUT.r_b.mem[j];
        expected = val_i + val_j;

        instr = add(i, j, k);
        @(posedge clk); #thold;

        if (DUT.r_b.mem[k] === expected)
            $display("\033[32m[PASS]\033[0m add: X(%0d) = X(%0d) + X(%0d) --> %0d = %0d + %0d OK",
                     k, i, j, DUT.r_b.mem[k], val_i, val_j);
        else
            $error("\033[31m[FAIL]\033[0m add: X(%0d) = X(%0d) + X(%0d) --> expected %0d = %0d + %0d, got %0d",
                    k, i, j, expected, val_i, val_j, DUT.r_b.mem[k]);
    end
endtask


// test_sub(i, j, k); --> X(k) = X(i) - X(j)
task test_sub(input [3:0] i, input [3:0] j, input [3:0] k);
    reg signed [7:0] expected;
    reg signed [7:0] val_i, val_j;  // snapshot inputs
    begin
        // Take snapshots before executing instruction
        val_i = DUT.r_b.mem[i];
        val_j = DUT.r_b.mem[j];
        expected = val_i - val_j;

        instr = sub(i, j, k);
        @(posedge clk); #thold;

        if (DUT.r_b.mem[k] === expected)
            $display("\033[32m[PASS]\033[0m sub: X(%0d) = X(%0d) - X(%0d) --> %0d = %0d - %0d OK",
                     k, i, j, DUT.r_b.mem[k], val_i, val_j);
        else
            $error("\033[31m[FAIL]\033[0m sub: X(%0d) = X(%0d) - X(%0d) --> expected %0d = %0d - %0d, got %0d",
                    k, i, j, expected, val_i, val_j, DUT.r_b.mem[k]);
    end
endtask


// test_jump(addr); --> jump to addr
task test_jump(input [7:0] addr);
    reg [7:0] pc_before;
    begin
        pc_before = number;        // snapshot current PC
        instr = jump(addr);        // issue jump instruction
        @(posedge clk); #thold;

        if (number === addr)
            $display("\033[32m[PASS]\033[0m jump: PC before=%0d, jump_arg=%0d --> jumped to PC=%0d OK",
                     pc_before, addr, number);
        else
            $error("\033[31m[FAIL]\033[0m jump: PC before=%0d, jump_arg=%0d, got PC=%0d",
                    pc_before, addr, number);
    end
endtask



// test_jump_pos(i, addr); --> if X(i) > 0 then jump to addr
task test_jump_pos(input [3:0] i, input [7:0] addr);
    reg signed [7:0] val_i;
    reg [7:0] pc_before;
    begin
        val_i = DUT.r_b.mem[i];      // snapshot register value
        pc_before = number;          // snapshot current PC
        instr = jump_pos(i, addr);   // issue jump instruction
        @(posedge clk); #thold;

        if (val_i > 0 && number === addr)
            $display("\033[32m[PASS]\033[0m jump_pos: X(%0d)=%0d > 0, PC before=%0d, jump_arg=%0d --> jumped to PC=%0d OK",
                     i, val_i, pc_before, addr, number);
        else if (val_i <= 0 && number === pc_before + 1)
            $display("\033[32m[PASS]\033[0m jump_pos: X(%0d)=%0d <= 0, PC before=%0d, jump_arg=%0d --> incremented to PC=%0d OK",
                     i, val_i, pc_before, addr, number);
        else
            $error("\033[31m[FAIL]\033[0m jump_pos: X(%0d)=%0d, PC before=%0d, jump_arg=%0d, expected PC=%0d, got PC=%0d",
                    i, val_i, pc_before, addr, (val_i > 0) ? addr : (pc_before + 1), number);
    end
endtask



// test_jump_neg(i, addr); --> if X(i) < 0 then jump to addr
task test_jump_neg(input [3:0] i, input [7:0] addr);
    reg signed [7:0] val_i;
    reg [7:0] pc_before;
    begin
        val_i = DUT.r_b.mem[i];      // snapshot register value
        pc_before = number;          // snapshot current PC
        instr = jump_neg(i, addr);   // issue jump instruction
        @(posedge clk); #thold;

        if (val_i < 0 && number === addr)
            $display("\033[32m[PASS]\033[0m jump_neg: X(%0d)=%0d < 0, PC before=%0d, jump_arg=%0d --> jumped to PC=%0d OK",
                     i, val_i, pc_before, addr, number);
        else if (val_i >= 0 && number === pc_before + 1)
            $display("\033[32m[PASS]\033[0m jump_neg: X(%0d)=%0d >= 0, PC before=%0d, jump_arg=%0d --> incremented to PC=%0d OK",
                     i, val_i, pc_before, addr, number);
        else
            $error("\033[31m[FAIL]\033[0m jump_neg: X(%0d)=%0d, PC before=%0d, jump_arg=%0d, expected PC=%0d, got PC=%0d",
                    i, val_i, pc_before, addr, (val_i < 0) ? addr : (pc_before + 1), number);
    end
endtask




///////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////:

// DUT INSTANTIATION //

processor_top DUT(clk,
	rst,
	IN0,
	IN1,
	IN2,
	IN3,
	IN4,
	IN5,
	IN6,
	IN7, 
	instr,
	OUT0,
	OUT1,
	OUT2,
	OUT3,
	OUT4,
	OUT5,
	OUT6,
	OUT7, 
	number);

// CLK GENERATION //

parameter cycle = 10, 
	thold = 1,
	tsetup = 1;

always #5 clk = ~clk;  // 100 MHz

// INSTRUCTION ENCODING //

/*parameter assign_value = 4'b0000,
	data_input = 0010,
	data_output = 1010,
	output_value = 1000,
	add = 0100,
	sub = 0101,
	jump = 1110,
	jump_pos = 1100,
	jump_neg = 1101;
*/

// RST TASK //

// reset task: Assert reset and verify PC is reset to 0
task reset;
    reg [7:0] pc_before;
    begin
        pc_before = number;    // Save PC before reset
        rst = 1'b1;
        @(posedge clk); 
        #thold;

        if (number === 8'd0) begin
            $display("\033[32m[PASS]\033[0m reset: PC before=%0d, PC after reset=%0d OK",
                     pc_before, number);
        end else begin
            $error("\033[31m[FAIL]\033[0m reset: PC before=%0d, expected PC after reset=0, got PC=%0d",
                    pc_before, number);
        end

        rst = 1'b0;
        #(cycle - thold - tsetup); // Wait for next cycle
    end
endtask


// ASSING VALUE INSTR // assign_value(k,a); --> X(k) = A;
// DATA INPUT INSTR // data_input(j, k); --> X(k) = IN(j);
// DATA OUTPUT INSTR // data_output(i, j); --> OUT(i) = X(j);
// OUTPUT VALUE INSTR // output_value(i, A); --> OUT(i) = A;
// ADD INSTR // add(i, j, k); --> X(k) = X(i)+X(j);
// SUB INSTR // sub(i, j, k); --> X(k) = X(i)-X(j);
// JUMP INSTR // jump(n); --> goto n;
// JUMP_POS INSTR // jump_pos(i, n); --> if X(i) > 0 then goto n;
// JUMP_NEG INSTR // jumb_neg(i, n); --> if X(i) < 0 then goto n;

// Simple Program for testing different instrctions //

task simple(); 
	begin
		mem [0] = assign_value(3, 45);
		mem [1] = assign_value(4, 20);
		mem [2] = add(3, 4, 1);
		mem [3] = sub(3, 4, 2);
		mem [4] = data_output(1, 1);
		mem [5] = data_output(2, 2);
		IN5 = 54;
		IN6 = 31;
		mem [6] = data_input(5, 0);
		mem [7] = data_input(6, 5);
		mem [8] = data_output(1, 0);
		mem [9] = data_output(2, 5);

	end
endtask

task run_simple();
	begin 
	for (i = 0; i < 10; i = i + 1) begin
    		instr = mem[number];
    		@(posedge clk);
    		
		#(thold);
		/*$display("The instr number is %d", number);
		$display("The x  in alu is %d", DUT.a_u.left_in);
		$display("The y in alu is %d", DUT.a_u.right_in);
		$display("The value's of x(3): %d and x(4): %d", DUT.r_b.mem[3], DUT.r_b.mem[4]);


		$display("The added result in alu is %d", DUT.a_u.result);
		$display("The added value is %d", DUT.r_b.mem[1]);
        $display("////////////////////////");
		//instr = 'bx;
		*/

		#(cycle-thold-tsetup);

  	end
end
endtask

// Main execution to TB // 

// test_assign_value(k, A): Verify register X(k) is loaded with immediate value A
// test_data_input(j, k, IN*): Verify register X(k) is loaded with input port IN(j) with data given to PORT 
// test_data_output(i, j): Verify output port OUT(i) matches register X(j) value
// test_output_value(i, A): Verify output port OUT(i) is driven with immediate value A
// test_add(i, j, k): Verify register X(k) holds sum of X(i) and X(j)
// test_sub(i, j, k): Verify register X(k) holds difference of X(i) and X(j)
// test_jump(n): Verify program counter jumps to address n
// test_jump_pos(i, n): Verify jump to address n when register X(i) is greater than 0
// test_jump_neg(i, n): Verify jump to address n when register X(i) is less than 0

task test_simple;
begin
	$display("'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''");
	$display("'''''''''''''''''' STARTING TEST_SIMPLE PROGRAM ''''''''''''''''''''''");
  	$display("'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''");
  test_assign_value(0, -45);
  //IN5 = 42;
  test_data_input(5, 3, 42);
  test_data_output(4, 0);
  test_add(0, 3, 2);
  test_sub(0, 3, 3);
  test_jump(5);
  test_jump_neg(0, 4);
  test_jump_pos(0, 7);
  reset();
	$display("'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''");
	$display("'''''''''''''''''' ENDING TEST_SIMPLE PROGRAM ''''''''''''''''''''''");
	$display("'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''");
end
endtask


initial begin
	// for debugging
    $dumpfile("tb_processor.vcd");  // Name of VCD file
    $dumpvars(0, tb_processor);     // Dump all vars under testbench top
	/* 
	// for debuggin
	$dumpvars(0, DUT.r_b.mem[0]);
    $dumpvars(0, DUT.r_b.mem[1]);
    $dumpvars(0, DUT.r_b.mem[2]);
    $dumpvars(0, DUT.r_b.mem[3]);
    $dumpvars(0, DUT.r_b.mem[4]);
    $dumpvars(0, DUT.r_b.mem[5]);
    $dumpvars(0, DUT.r_b.mem[6]);
    $dumpvars(0, DUT.r_b.mem[7]);
	*/

	// actual stimulus driving

	reset();
	// without self testing run the below two task
	//simple();
	//run_simple();
	test_simple();
	
	#10 $finish;
end

endmodule
