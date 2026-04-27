module top(
    input  logic       clk27,
    input  logic       rst_n,
    input  logic [3:0] keypad_rows,
    output logic [3:0] keypad_cols,
    output logic [3:0] leds
);

    logic rst;
    logic scan_tick;
    logic key_valid;
    logic [3:0] key_code;

    assign rst = ~rst_n;

    generador_tick #(
        .DIV(27000)
    ) u_clk_enable (
        .clk (clk27),
        .rst (rst),
        .tick(scan_tick)
    );

    teclado_hex u_keypad (
        .clk        (clk27),
        .rst        (rst),
        .scan_tick  (scan_tick),
        .rows_async (keypad_rows),
        .cols       (keypad_cols),
        .key_valid  (key_valid),
        .key_code   (key_code)
    );

    always_ff @(posedge clk27) begin
        if (rst)
            leds <= 4'b0000;
        else if (key_valid)
            leds <= key_code;
    end

endmodule