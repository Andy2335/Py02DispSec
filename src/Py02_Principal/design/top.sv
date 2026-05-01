module top(
    input  logic       clk27,
    input  logic       rst_n,

    input  logic [3:0] keypad_rows,
    output logic [3:0] keypad_cols,

    output logic [6:0] seg,
    output logic [3:0] dig
);

    logic rst;
    assign rst = 1'b0;

    logic scan_tick;
    logic key_valid;
    logic [3:0] key_code;

    logic [3:0] a0, a1, a2;
    logic [3:0] b0, b1, b2;
    logic [3:0] r0, r1, r2, r3;

    logic [1:0] digitos_a;
    logic [1:0] digitos_b;

    typedef enum logic [1:0] {
        INGRESAR_A = 2'd0,
        INGRESAR_B = 2'd1,
        MOSTRAR_R  = 2'd2
    } estado_t;

    estado_t estado = INGRESAR_A;

    generador_tick #(
        .DIV(27000)
    ) u_tick_teclado (
        .clk  (clk27),
        .rst  (rst),
        .tick (scan_tick)
    );

    teclado_hex u_teclado (
        .clk        (clk27),
        .rst        (rst),
        .scan_tick  (scan_tick),
        .rows_async (keypad_rows),
        .cols       (keypad_cols),
        .key_valid  (key_valid),
        .key_code   (key_code)
    );

    logic [4:0] suma0, suma1, suma2;

    always_comb begin
        suma0 = a0 + b0;
        suma1 = a1 + b1 + (suma0 >= 10);
        suma2 = a2 + b2 + (suma1 >= 10);

        r0 = (suma0 >= 10) ? suma0 - 10 : suma0;
        r1 = (suma1 >= 10) ? suma1 - 10 : suma1;
        r2 = (suma2 >= 10) ? suma2 - 10 : suma2;
        r3 = (suma2 >= 10) ? 4'd1 : 4'd0;
    end

    always_ff @(posedge clk27) begin
        if (key_valid) begin

            if (key_code == 4'hD || key_code == 4'hE) begin
                estado <= INGRESAR_A;

                a0 <= 0; a1 <= 0; a2 <= 0;
                b0 <= 0; b1 <= 0; b2 <= 0;

                digitos_a <= 0;
                digitos_b <= 0;
            end else begin
                case (estado)

                    INGRESAR_A: begin
                        if (key_code <= 9 && digitos_a < 3) begin
                            a2 <= a1;
                            a1 <= a0;
                            a0 <= key_code;
                            digitos_a <= digitos_a + 1'b1;
                        end else if (key_code == 4'hA) begin
                            estado <= INGRESAR_B;
                        end
                    end

                    INGRESAR_B: begin
                        if (key_code <= 9 && digitos_b < 3) begin
                            b2 <= b1;
                            b1 <= b0;
                            b0 <= key_code;
                            digitos_b <= digitos_b + 1'b1;
                        end else if (key_code == 4'hB || key_code == 4'hC || key_code == 4'hF) begin
                            estado <= MOSTRAR_R;
                        end
                    end

                    MOSTRAR_R: begin
                    end

                endcase
            end
        end
    end

    logic [3:0] d0, d1, d2, d3;

    always_comb begin
        case (estado)
            INGRESAR_A: begin
                d0 = a0;
                d1 = a1;
                d2 = a2;
                d3 = 0;
            end

            INGRESAR_B: begin
                d0 = b0;
                d1 = b1;
                d2 = b2;
                d3 = 0;
            end

            MOSTRAR_R: begin
                d0 = r0;
                d1 = r1;
                d2 = r2;
                d3 = r3;
            end

            default: begin
                d0 = 0;
                d1 = 0;
                d2 = 0;
                d3 = 0;
            end
        endcase
    end

    display_4dig_mux #(
        .CLK_FREQ(27000000),
        .REFRESH_HZ(1000),
        .COMMON_ANODE(0)
    ) u_display (
        .clk (clk27),
        .rst (1'b0),

        .d0  (d0),
        .d1  (d1),
        .d2  (d2),
        .d3  (d3),

        .seg (seg),
        .dig (dig)
    );

endmodule