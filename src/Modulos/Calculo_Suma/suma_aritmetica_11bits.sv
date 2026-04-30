// ============================================================
// Subsistema de suma aritmética de dos datos de 8 bits
// Salida completa de 9 bits + indicador de desbordamiento
// ============================================================

module suma_aritmetica_11bits (
    input  logic        clk,        // Reloj del sistema
    input  logic        rst,        // Reset
    input  logic [10:0]  dato_a,     // Primer dato (8 bits)
    input  logic [10:0]  dato_b,     // Segundo dato (8 bits)
    output logic [10:0]  resultado,  // Resultado completo (9 bits)
    output logic        overflow    // LED de desbordamiento
);

    logic [11:0] suma_extendida; // Para capturar el carry

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
             resultado <= 11'd0;
             overflow  <= 1'b0;
        end else begin
            suma_extendida = dato_a + dato_b; // suma completa
            resultado      <= suma_extendida[10:0]; // 9 bits completos
            overflow       <= suma_extendida[11]; // MSB = carry-out
        end
    end

endmodule