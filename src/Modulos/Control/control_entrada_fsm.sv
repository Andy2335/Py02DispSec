module control_entrada_fsm(
    input  logic       clk,
    input  logic       rst,

    input  logic       key_valid,
    input  logic [3:0] key_code,

    input  logic       a_lleno,
    input  logic       b_lleno,

    output logic       limpiar,
    output logic       cargar_a,
    output logic       cargar_b,
    output logic       calcular,

    output logic [1:0] seleccion_display
);

    typedef enum logic [1:0] {
        INGRESO_A = 2'd0,
        INGRESO_B = 2'd1,
        MOSTRAR_RESULTADO = 2'd2
    } estado_t;

    estado_t estado_actual, estado_siguiente;

    localparam logic [3:0] TECLA_A = 4'hA;
    localparam logic [3:0] TECLA_B = 4'hB;
    localparam logic [3:0] TECLA_C = 4'hC;
    localparam logic [3:0] TECLA_D = 4'hD;

    function automatic logic es_digito(input logic [3:0] tecla);
        es_digito = (tecla <= 4'd9);
    endfunction

    always_ff @(posedge clk) begin
        if (rst)
            estado_actual <= INGRESO_A;
        else
            estado_actual <= estado_siguiente;
    end

    always_comb begin
        estado_siguiente = estado_actual;

        limpiar = 1'b0;
        cargar_a = 1'b0;
        cargar_b = 1'b0;
        calcular = 1'b0;

        seleccion_display = 2'd0;

        case (estado_actual)

            INGRESO_A: begin
                seleccion_display = 2'd0;

                if (key_valid) begin
                    if (key_code == TECLA_D) begin
                        limpiar = 1'b1;
                        estado_siguiente = INGRESO_A;
                    end else if (es_digito(key_code) && !a_lleno) begin
                        cargar_a = 1'b1;
                    end else if (key_code == TECLA_A) begin
                        estado_siguiente = INGRESO_B;
                    end
                end
            end

            INGRESO_B: begin
                seleccion_display = 2'd1;

                if (key_valid) begin
                    if (key_code == TECLA_D) begin
                        limpiar = 1'b1;
                        estado_siguiente = INGRESO_A;
                    end else if (es_digito(key_code) && !b_lleno) begin
                        cargar_b = 1'b1;
                    end else if (key_code == TECLA_B || key_code == TECLA_C) begin
                        calcular = 1'b1;
                        estado_siguiente = MOSTRAR_RESULTADO;
                    end
                end
            end

            MOSTRAR_RESULTADO: begin
                seleccion_display = 2'd2;

                if (key_valid) begin
                    if (key_code == TECLA_D) begin
                        limpiar = 1'b1;
                        estado_siguiente = INGRESO_A;
                    end
                end
            end

            default: begin
                estado_siguiente = INGRESO_A;
            end

        endcase
    end

endmodule