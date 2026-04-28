module constructor_numero #(
    parameter int WIDTH = 11,
    parameter int MAX_DIGITOS = 3
)(
    input  logic              clk,
    input  logic              rst,
    input  logic              limpiar,
    input  logic              cargar_digito,
    input  logic [3:0]        digito,

    output logic [WIDTH-1:0]  numero,
    output logic [1:0]        cantidad_digitos,
    output logic              lleno
);

    assign lleno = (cantidad_digitos == MAX_DIGITOS);

    always_ff @(posedge clk) begin
        if (rst || limpiar) begin
            numero           <= '0;
            cantidad_digitos <= 2'd0;
        end else begin
            if (cargar_digito && !lleno && digito <= 4'd9) begin
                numero           <= (numero * 10) + digito;
                cantidad_digitos <= cantidad_digitos + 1'b1;
            end
        end
    end

endmodule

/*
Este módulo se encarga de construir el número completo a partir de los dígitos que el 
usuario va presionando en el teclado. Cada tecla llega como un valor de 4 bits (0–9), 
y el módulo va formando el número como una calculadora: multiplica el valor anterior 
por 10 y le suma el nuevo dígito. Por ejemplo, si se presiona 1, luego 2 y luego 3, 
el resultado almacenado será 123. También controla cuántos dígitos se han ingresado 
y activa la señal lleno cuando se llega al máximo permitido, que en este proyecto son 
3 dígitos.
*/