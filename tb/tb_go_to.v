`timescale 1ns / 1ps

module tb_go_to;

reg clk = 1'b0,rst;
reg [3:0] numb_sel;
reg signed [7:0] data;
reg [7:0]N;

wire [7:0]number;

// for tb
//time t;

go_to DUT(clk,
	rst,
	numb_sel,
	data,
	N,
	number);

parameter cycle = 10,
	thold = 1,
	tsetup = 1;

always #(5) clk = ~clk;

task reset;
    begin
        rst = 1'b1; // Assert reset
        // Set other inputs to 'x' or known safe values during reset

        @(posedge clk); // Wait for a clock edge for synchronous reset to take effect
        #(thold);       // Wait for hold time

        if(number == 8'd0) begin
            $display("At time %0t: Reset operation successful. Program counter is %0d.", $time, number);
        end else begin
            $display("At time %0t: Reset operation FAILED. Program counter is %0d, expected 0.", $time, number);
        end

        rst = 1'b0; // De-assert reset
        // Wait for the next clock edge to ensure DUT sees rst=0 before next instruction
        @(posedge clk);
        #(cycle - thold - tsetup); // Wait for the rest of the cycle if needed
    end
endtask

task jump(input [7:0]n);
	begin
		rst = 1'b0;
		numb_sel = 4'b1110;
		N = n;

		@(posedge clk);
		#(thold);

		if(number == N)
		begin
			$display("At time t = %0t,The jump instr is working",$time);
			$display("At time t = %0t,The instr number generetad is %d, the given instr number is %d",$time, number, N);
		end
		else 
			$display("At time t = %0t,The jumb instr is not working",$time);

		{numb_sel, N} = 'bx;

		#(cycle-thold-tsetup);
	end
endtask

task jump_pos;
    input [7:0] n_target;
    input signed [7:0] d_val; // Ensure 'data' in DUT is also signed
    reg [7:0] prev_number; // Local variable to store PC before jump

    begin
        prev_number = number; // Capture current PC before new instruction

        rst = 1'b0;
        numb_sel = 4'b1100;
        N = n_target;
        data = d_val;

        @(posedge clk);
        #(thold);

        if (d_val > 0) begin // Expected to jump
            if (number == N) begin
                $display("At time %0t: JUMP_POS SUCCESS (data > 0). PC: %0d -> %0d, Target: %0d, Data: %0d.", $time, prev_number, number, N, d_val);
            end else begin
                $display("At time %0t: JUMP_POS FAILED (data > 0, no jump). PC: %0d , Expected: %0d, Data: %0d.", $time, prev_number, number, N, d_val);
            end
        end else begin // Expected to increment (no jump)
            if (number == prev_number + 1) begin
                $display("At time %0t: JUMP_POS SUCCESS (data <= 0, PC incremented). PC: %0d -> %0d, Data: %0d.", $time, prev_number, number, d_val);
            end else begin
                $display("At time %0t: JUMP_POS FAILED (data <= 0, incorrect PC). PC: %0d , Expected: %0d, Data: %0d.", $time, prev_number, number, d_val);
            end
        end

        {numb_sel, N, data} = 'bx; // De-assert control signals
        #(cycle-thold-tsetup);
    end
endtask

task jump_neg;
    input [7:0] n_target;
    input signed [7:0] d_val; // Ensure 'data' in DUT is also signed
    reg [7:0] prev_number; // Local variable to store PC before jump

    begin
        prev_number = number; // Capture current PC before new instruction

        rst = 1'b0;
        numb_sel = 4'b1101;
        N = n_target;
        data = d_val;

        @(posedge clk);
        #(thold);

        if (d_val < 0) begin // Expected to jump
            if (number == N) begin
                $display("At time %0t: jumb_neg SUCCESS (data > 0). PC: %0d -> %0d, Target: %0d, Data: %0d.", $time, prev_number, number, N, d_val);
            end else begin
                $display("At time %0t: jumb_neg FAILED (data > 0, no jump). PC: %0d , Expected: %0d, Data: %0d.", $time, prev_number, number, N, d_val);
            end
        end else begin // Expected to increment (no jump)
            if (number == prev_number + 1) begin
                $display("At time %0t: jumb_neg SUCCESS (data <= 0, PC incremented). PC: %0d -> %0d, Data: %0d.", $time, prev_number, number, d_val);
            end else begin
                $display("At time %0t: jumb_neg FAILED (data <= 0, incorrect PC). PC: %0d , Expected: %0d, Data: %0d.", $time, prev_number, number, d_val);
            end
        end

        {numb_sel, N, data} = 'bx; // De-assert control signals
        #(cycle-thold-tsetup);
    end
endtask
// reset();
// jump(N);
// jump_pos(N, d);
// jump_neg(N, d);
//
// N is instr no to jump
// d is data

initial begin

    $dumpfile("go_to.vcd");
	$dumpvars(0, tb_go_to);
	reset();
	repeat(4)
	begin
		@(posedge clk);
		$display("At time t= %0t, the pc %d is at without any instructions", $time, number);
	end
	jump(5);
	jump_pos(4, 5);
	jump_pos(8, -4);
	jump_neg(10, -3);
	jump_neg(15, 4);
	reset();
	$monitor("At time t= %0t, the number is %d", $time, number);
	$finish;

end


endmodule
