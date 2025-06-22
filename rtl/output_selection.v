module output_selection(
    input               clk,
    input signed  [7:0] regi,
    input               out_en,
    input               out_sel,
    input signed  [7:0] A,
    input        [2:0]  i,
    output signed [7:0] OUT0,
    output signed [7:0] OUT1,
    output signed [7:0] OUT2,
    output signed [7:0] OUT3,
    output signed [7:0] OUT4,
    output signed [7:0] OUT5,
    output signed [7:0] OUT6,
    output signed [7:0] OUT7
);

    // regs to hold last value
    reg signed [7:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;

    // Capture value on posedge clk
    always @(posedge clk) begin
        if (out_en) begin
            case(i)
                3'd0: reg0 <= (out_sel) ? regi : A;
                3'd1: reg1 <= (out_sel) ? regi : A;
                3'd2: reg2 <= (out_sel) ? regi : A;
                3'd3: reg3 <= (out_sel) ? regi : A;
                3'd4: reg4 <= (out_sel) ? regi : A;
                3'd5: reg5 <= (out_sel) ? regi : A;
                3'd6: reg6 <= (out_sel) ? regi : A;
                3'd7: reg7 <= (out_sel) ? regi : A;
            endcase
        end
    end

    // Tri-state buffer logic
    assign OUT0 = (out_en) ? reg0 : 8'bz;
    assign OUT1 = (out_en) ? reg1 : 8'bz;
    assign OUT2 = (out_en) ? reg2 : 8'bz;
    assign OUT3 = (out_en) ? reg3 : 8'bz;
    assign OUT4 = (out_en) ? reg4 : 8'bz;
    assign OUT5 = (out_en) ? reg5 : 8'bz;
    assign OUT6 = (out_en) ? reg6 : 8'bz;
    assign OUT7 = (out_en) ? reg7 : 8'bz;

endmodule

