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
  

    logic [3:0] rows_sync;
    logic [3:0] rows_clean;

    logic       key_found_raw;
    logic [3:0] key_code_raw;

    logic       key_found_d;
    logic [3:0] key_code_d;

  // Conectar sample_en del escáner
    logic sample_en;

    escaner_teclado u_scanner (
        .clk      (clk),
        .rst      (rst),
        .scan_tick(scan_tick),
        .col_idx  (col_idx),
        .cols     (cols),
        .sample_en(sample_en)  // nuevo
    );


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
        .col_idx  (col_idx),
        .rows     (rows_clean),
        .key_found(key_found_raw),
        .key_code (key_code_raw)
    );

    // En el always_ff, usar sample_en en vez de scan_tick
always_ff @(posedge clk) begin
    if (rst) begin
        key_valid   <= 1'b0;
        key_code    <= 4'h0;
        key_found_d <= 1'b0;
        key_code_d  <= 4'h0;
    end else begin
        key_valid <= 1'b0;
        if (sample_en) begin  // ← aquí el cambio
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

/* 
Este módulo se encarga de leer el teclado hexadecimal completo. 
Su función principal es detectar cuándo se presiona una tecla y convertir esa 
pulsación en un valor digital de 4 bits (key_code). Para lograrlo, este integra el escaneo 
de columnas, la sincronización de señales externas, la eliminación de rebotes y la 
decodificación de la tecla presionada. Genera una señal key_valid que indica 
que la tecla detectada es válida y puede ser utilizada por el sistema.
*/