`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2025 14:43:55
// Design Name: 
// Module Name: tb_output_selection
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


module tb_output_selection;

reg clk = 1'b0;
reg signed [7:0] regi;
reg out_en;
reg out_sel;
reg signed [7:0] A;
reg [2:0] i;

wire [7:0] OUT0;
wire [7:0] OUT1;
wire [7:0] OUT2;
wire [7:0] OUT3;
wire [7:0] OUT4;
wire [7:0] OUT5;
wire [7:0] OUT6;
wire [7:0] OUT7;


// for tb
//

reg [7:0] temp;
integer seed;

output_selection DUT(
	clk,
	regi,
	out_en,
	out_sel, 
	A,
	i,
	OUT0,
	OUT1,
	OUT2,
	OUT3,
	OUT4,
	OUT5,
	OUT6,
	OUT7);

parameter thold = 1,
	tsetup = 1,
	cycle = 10;

//// Clock generation

always 
begin
	#(cycle/2) clk = ~clk;
end


/*task data_output(input signed [7:0] x, input [2:0] y);
	begin
	regi = x;
	i = y;
	out_en = 1'b1;
	out_sel = 1'b1;

	@(posedge clk);
	#(thold);
	
	case(i)
		3'd0 : temp = OUT0;
		3'd1 : temp = OUT1;
		3'd2 : temp = OUT2;
		3'd3 : temp = OUT3;
		3'd4 : temp = OUT4;
		3'd5 : temp = OUT5;
		3'd6 : temp = OUT6;
		3'd7 : temp = OUT7;
	endcase
	
	if(regi == temp)
		begin
			$display("The reg input is %d, selected output port is %d, the sampled value is %d", regi, i, temp);
			$display("The data_output op is correct");
		end
		else
			$display("The data_output op is'nt correct");
	{regi, i, out_en, out_sel} = 'bx;
	#(cycle-thold-tsetup);
	end

endtask
*/
task output_value(input signed [7:0] x, input [2:0] y);
	begin
		out_en = 1'b1;
		out_sel = 1'b0;
		A = x;
		i = y;
	@(posedge clk);
	#(thold);
		case(i)
		3'd0 : temp = OUT0;
		3'd1 : temp = OUT1;
		3'd2 : temp = OUT2;
		3'd3 : temp = OUT3;
		3'd4 : temp = OUT4;
		3'd5 : temp = OUT5;
		3'd6 : temp = OUT6;
		3'd7 : temp = OUT7;
		endcase
	


	if(A == temp)
		begin
			$display("The constant input is %d, selected output port is %d, the sampled value is %d", A, i, temp);
			$display("The output value op is correct");
		end
		else
			$display("The output value op is'nt correct");
	{A, i, out_en, out_sel} = 'bx;
	#(cycle-thold-tsetup);
	end

endtask


task data_output(input signed [7:0] x, input [2:0] y);
begin
    regi    = x;
    i       = y;
    out_en  = 1'b1;
    out_sel = 1'b1;

    @(posedge clk);    // Latch into register
    #(cycle/10);       // Give time for OUTx to settle

    case(i)
        3'd0: temp = OUT0;
        3'd1: temp = OUT1;
        3'd2: temp = OUT2;
        3'd3: temp = OUT3;
        3'd4: temp = OUT4;
        3'd5: temp = OUT5;
        3'd6: temp = OUT6;
        3'd7: temp = OUT7;
    endcase

    if(temp === x) $display("Correct output"); 
    else           $display("Incorrect output: expected %0d, got %0d", x, temp);

    // Optionally hold value before disabling
    @(posedge clk);    // extra cycle if desired

    {regi, i, out_en, out_sel} = 'bx;
end
endtask


task output_disable();
	begin
	out_en = 1'b0;
	out_sel = 1'b1;
	i = $urandom;
	@(posedge clk);
	#(thold);
		case(i)
		3'd0 : temp = OUT0;
		3'd1 : temp = OUT1;
		3'd2 : temp = OUT2;
		3'd3 : temp = OUT3;
		3'd4 : temp = OUT4;
		3'd5 : temp = OUT5;
		3'd6 : temp = OUT6;
		3'd7 : temp = OUT7;
		endcase
	

	if(8'bz === temp)
		begin
			$display("The output disable op is correct");
		end
		else
			$display("The output disable op is'nt correct");
	{out_en, out_sel, i} = 'bx;
	#(cycle-thold-tsetup);
	end

endtask

// data_output(data, port);  -> randomly selects the output port and provide random
// 			input from the register
// output_value(data, port); -> randomly selects the output port and provide random
// 			input value 
// output_disable(); -> checks whether the output ports goes in high impedence
// 			when out_en is low

/*
initial begin
//	seed = $random;
	//repeat(8)
	data_output(-5, 2);
	//repeat(8)
	output_value(34, 3);
	
	output_disable();

	$finish;
end
*/

initial begin
    // Initialize
    out_en  = 0;
    out_sel = 0;
    regi    = 0;
    A       = 0;
    i       = 0;
    @(posedge clk);  // wait a cycle

    // Write value 22 to reg0
    A       = 8'd22;
    out_sel = 1'b1;
    i       = 3'd0;
    out_en  = 1'b1;  // enable output latch and drive
    @(posedge clk);  // latch value into reg0
    #1; // small delay
    $display("OUT0 = %0d", OUT0); // check output

    // Keep out_en high if you want OUT0 to drive the bus.
    // If you want to test high-impedance:
    @(posedge clk); 
    out_en  = 1'b0;  // tri-state all OUTx
    #1;
    $display("OUT0 = %0s (expect Z)", OUT0 === 8'bz ? "Z" : "not Z");

    $finish;
end


endmodule
