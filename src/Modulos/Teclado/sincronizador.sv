module sincronizador #(
    parameter int WIDTH = 1
)(
    input  logic             clk,
    input  logic             rst,
    input  logic [WIDTH-1:0] async_in,
    output logic [WIDTH-1:0] sync_out
);

    logic [WIDTH-1:0] stage1, stage2;

    always_ff @(posedge clk) begin
        if (rst) begin
            stage1   <= '0;
            stage2   <= '0;
            sync_out <= '0;
        end else begin
            stage1   <= async_in;
            stage2   <= stage1;
            sync_out <= stage2;
        end
    end

endmodule

/* 
Este módulo sincroniza las señales de entrada provenientes del teclado con el reloj interno 
de la FPGA. 
Esto es importante porque las señales externas pueden llegar de forma asincrónica y 
causar errores de funcionamiento. Su objetivo es asegurar que los datos entren de forma 
estable al sistema.
*/