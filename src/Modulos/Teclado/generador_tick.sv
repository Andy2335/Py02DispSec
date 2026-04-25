module generador_tick #(
    parameter int DIV = 27000
)(
    input  logic clk,
    input  logic rst,
    output logic tick
);

    localparam int W = (DIV <= 1) ? 1 : $clog2(DIV);
    logic [W-1:0] count;

    always_ff @(posedge clk) begin
        if (rst) begin
            count <= '0;
            tick  <= 1'b0;
        end else begin
            if (count == DIV-1) begin
                count <= '0;
                tick  <= 1'b1;
            end else begin
                count <= count + 1'b1;
                tick  <= 1'b0;
            end
        end
    end

endmodule