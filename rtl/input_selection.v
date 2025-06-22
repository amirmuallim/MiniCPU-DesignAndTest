`timescale 1ns / 1ps

module input_selection(
    input [1:0] input_ctl,
    input [7:0] IN0,
    input [7:0] IN1,
    input [7:0] IN2,
    input [7:0] IN3,
    input [7:0] IN4,
    input [7:0] IN5,
    input [7:0] IN6,
    input [7:0] IN7,
    input [7:0] A,    
    input [2:0] J,
    input [7:0] result,
    output reg [7:0] to_reg 
);

always @(*) 
begin
	case(input_ctl)
		2'd0 : to_reg = A;
		2'd1 : begin
			case(J)
				3'd0 : to_reg = IN0;
				3'd1 : to_reg = IN1;
				3'd2 : to_reg = IN2;
				3'd3 : to_reg = IN3;
				3'd4 : to_reg = IN4;
				3'd5 : to_reg = IN5;
				3'd6 : to_reg = IN6;
				3'd7 : to_reg = IN7;
				default : to_reg = 8'dx;
			endcase
		end
		2'd2 : to_reg = result;
		2'd3 : to_reg = 0;
		default : to_reg = 8'dx;
	endcase
end

endmodule
