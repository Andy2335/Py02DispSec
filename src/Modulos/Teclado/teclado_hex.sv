module teclado_hex #(
    parameter int DEBOUNCE_COUNT = 135000
)(
    input  logic       clk,
    input  logic       rst,
    input  logic       scan_tick,
    input  logic [3:0] rows_async,
    output logic [3:0] cols,
    output logic       key_valid,
    output logic [3:0] key_code
);

    logic [1:0] col_idx;
    logic [1:0] col_idx_d;

    logic [3:0] rows_sync;
    logic [3:0] rows_clean;

    logic       key_found_raw;
    logic [3:0] key_code_raw;

    logic       key_found_d;
    logic [3:0] key_code_d;

    escaner_teclado u_scanner (
        .clk      (clk),
        .rst      (rst),
        .scan_tick(scan_tick),
        .col_idx  (col_idx),
        .cols     (cols)
    );

    always_ff @(posedge clk) begin
        if (rst)
            col_idx_d <= 2'd0;
        else if (scan_tick)
            col_idx_d <= col_idx;
    end

    sincronizador #(
        .WIDTH(4)
    ) u_sync (
        .clk     (clk),
        .rst     (rst),
        .async_in(rows_async),
        .sync_out(rows_sync)
    );

    antirrebote #(
        .WIDTH(4),
        .COUNT_MAX(DEBOUNCE_COUNT)
    ) u_debounce (
        .clk      (clk),
        .rst      (rst),
        .noisy_in (rows_sync),
        .clean_out(rows_clean)
    );

    decodificador_teclado u_decoder (
        .col_idx  (col_idx_d),
        .rows     (rows_clean),
        .key_found(key_found_raw),
        .key_code (key_code_raw)
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            key_valid   <= 1'b0;
            key_code    <= 4'h0;
            key_found_d <= 1'b0;
            key_code_d  <= 4'h0;
        end else begin
            key_valid <= 1'b0;

            if (scan_tick) begin
                if (key_found_raw && (!key_found_d || (key_code_raw != key_code_d))) begin
                    key_valid <= 1'b1;
                    key_code  <= key_code_raw;
                end

                key_found_d <= key_found_raw;
                key_code_d  <= key_code_raw;
            end
        end
    end

endmodule