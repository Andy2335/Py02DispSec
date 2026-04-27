module escaner_teclado(
    input  logic       clk,
    input  logic       rst,
    input  logic       scan_tick,
    output logic [1:0] col_idx,
    output logic [3:0] cols
);

    always_ff @(posedge clk) begin
        if (rst)
            col_idx <= 2'd0;
        else if (scan_tick)
            col_idx <= col_idx + 2'd1;
    end

    always_comb begin
        case (col_idx)
            2'd0: cols = 4'b1110;
            2'd1: cols = 4'b1101;
            2'd2: cols = 4'b1011;
            2'd3: cols = 4'b0111;
            default: cols = 4'b1111;
        endcase
    end

endmodule