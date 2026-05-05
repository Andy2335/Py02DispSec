// =============================================================================
// top_teclado.sv
// Top de prueba del subsistema de teclado hexadecimal.


module top(
    input  logic       clk,         // 27 MHz
    input  logic       rst_n,       // Boton reset activo en bajo

    // Teclado hexadecimal 4x4
    input  logic [3:0] rows,        // Filas del teclado (activo en bajo)
    output logic [3:0] cols,        // Columnas del teclado (activo en bajo)

    // Salidas de depuracion (conectar a LEDs o analizador logico)
    output logic       key_valid,   // Pulso de un ciclo: tecla detectada
    output logic [3:0] key_code     // Codigo hexadecimal de la tecla
);

    // -------------------------------------------------------------------------
    // Senales internas
    // -------------------------------------------------------------------------
    logic rst;
    logic scan_tick;

    // -------------------------------------------------------------------------
    // Reset: convierte rst_n (activo en bajo) a rst (activo en alto)
    // Mantiene rst=1 durante ~185 ms al encender
    // -------------------------------------------------------------------------
    reset_inicio #(
        .CICLOS (5_000_000)
    ) u_reset (
        .clk   (clk),
        .rst_n (rst_n),
        .rst   (rst)
    );

    // -------------------------------------------------------------------------
    // Generador de tick: 27 MHz / 27000 = 1 kHz (tick cada 1 ms)
    // -------------------------------------------------------------------------
    generador_tick #(
        .DIV (27000)
    ) u_tick (
        .clk  (clk),
        .rst  (rst),
        .tick (scan_tick)
    );

    // -------------------------------------------------------------------------
    // Subsistema de teclado
    // -------------------------------------------------------------------------
    teclado_hex u_teclado (
        .clk        (clk),
        .rst        (rst),
        .scan_tick  (scan_tick),
        .rows_async (rows),
        .cols       (cols),
        .key_valid  (key_valid),
        .key_code   (key_code)
    );

endmodule