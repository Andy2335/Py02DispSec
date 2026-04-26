// ============================================================
// Subsistema de suma aritmética de dos datos de 4 bits
// Incluye salida de carry-out para encender un LED
// ============================================================

module suma_aritmetica_4bits (
    input  logic        clk,        // Reloj del sistema
    input  logic        rst,        // Reset
    input  logic [3:0]  dato_a,     // Primer dato de 4 bits
    input  logic [3:0]  dato_b,     // Segundo dato de 4 bits
    output logic [3:0]  resultado,  // Resultado (4 bits)
    output logic        carry_out   // Carry-out (LED)
);

    logic [4:0] suma_extendida; // 5 bits para capturar el carry

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            resultado   <= 4'b0000;
            carry_out   <= 1'b0;
        end else begin
            suma_extendida = dato_a + dato_b;  // Suma completa (5 bits)
            resultado      <= suma_extendida[3:0]; // 4 LSB
            carry_out      <= suma_extendida[4];   // MSB → carry
        end
    end

endmodule