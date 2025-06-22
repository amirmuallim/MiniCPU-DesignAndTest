`timescale 1ns / 1ps

module go_to(input clk,
	input rst,
	input [3:0] numb_sel,
	input signed [7:0] data,
	input [7:0] N,
	output reg [7:0] number);

always @(posedge clk)
begin
	if(rst)
		number <= 8'd0;
	else 
	begin
		case(numb_sel)
			4'b1110 : number <= N;
			4'b1100 : 
			begin
				if(data > 0) number <= N;
				else number <= number+1;
			end
			4'b1101 :
			begin
				if(data < 0) number <= N;
				else number <= number+1;
			end
			default : number <= number+1;
		endcase
	end
end


endmodule
