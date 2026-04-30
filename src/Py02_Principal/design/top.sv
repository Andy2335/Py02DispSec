module top(
    input  logic       clk27,
   input  logic rst_n,

    input  logic [3:0] keypad_rows,
    output logic [3:0] keypad_cols,

    output logic [6:0] seg,
    output logic [3:0] dig
    // Agregar LED Carry out 
);

    logic rst;
assign rst = ~rst_n;

    logic scan_tick;
    logic key_valid;
    logic [3:0] key_code;

    logic [11:0] valor_temp;
    logic [11:0] valor_temp2;

    logic limpiar;
    logic cargar_a;
    logic cargar_b;
    logic calcular;
    logic [1:0] seleccion_display;

    logic [10:0] numA;
    logic [10:0] numB;
    logic [1:0] digitosA;
    logic [1:0] digitosB;
    logic llenoA;
    logic llenoB;

    logic [11:0] resultado_suma;
    logic [11:0] valor_mostrar;

    logic [10:0] resultado_suma_11bits;
    logic        overflow_suma;

    logic [3:0] d0;
    logic [3:0] d1;
    logic [3:0] d2;
    logic [3:0] d3;

    generador_tick #(
        .DIV(270000)
    ) u_tick_teclado (
        .clk (clk27),
        .rst (rst),
        .tick(scan_tick)
    );

    teclado_hex #(
        .DEBOUNCE_COUNT(135000)
    ) u_teclado (
        .clk        (clk27),
        .rst        (rst),
        .scan_tick  (scan_tick),
        .rows_async (keypad_rows),
        .cols       (keypad_cols),
        .key_valid  (key_valid),
        .key_code   (key_code)
    );

    control_entrada_fsm u_control (
        .clk               (clk27),
        .rst               (rst),
        .key_valid         (key_valid),
        .key_code          (key_code),
        .a_lleno           (llenoA),
        .b_lleno           (llenoB),
        .limpiar           (limpiar),
        .cargar_a          (cargar_a),
        .cargar_b          (cargar_b),
        .calcular          (calcular),
        .seleccion_display (seleccion_display)
    );

    constructor_numero #(
        .WIDTH(11),
        .MAX_DIGITOS(3)
    ) u_numA (
        .clk              (clk27),
        .rst              (rst),
        .limpiar          (limpiar),
        .cargar_digito    (cargar_a),
        .digito           (key_code),
        .numero           (numA),
        .cantidad_digitos (digitosA),
        .lleno            (llenoA)
    );

    constructor_numero #(
        .WIDTH(11),
        .MAX_DIGITOS(3)
    ) u_numB (
        .clk              (clk27),
        .rst              (rst),
        .limpiar          (limpiar),
        .cargar_digito    (cargar_b),
        .digito           (key_code),
        .numero           (numB),
        .cantidad_digitos (digitosB),
        .lleno            (llenoB)
    );



suma_aritmetica_11bits u_suma (
    .clk       (clk27),
    .rst       (rst),
    .dato_a    (numA),
    .dato_b    (numB),
    .resultado (resultado_suma_11bits),
    .overflow  (overflow_suma)
);

assign resultado_suma = {1'b0, resultado_suma_11bits};

    always_comb begin
        case (seleccion_display)
            2'd0: valor_mostrar = {1'b0, numA};
            2'd1: valor_mostrar = {1'b0, numB};
            2'd2: valor_mostrar = resultado_suma;
            default: valor_mostrar = 12'd0;
        endcase
    end

    always_comb begin
    d3 = 4'd0;
    d2 = 4'd0;
    d1 = 4'd0;
    d0 = 4'd0;

    if (valor_mostrar >= 12'd1000) begin
        d3 = 4'd1;
        valor_temp = valor_mostrar - 12'd1000;
    end else begin
        d3 = 4'd0;
        valor_temp = valor_mostrar;
    end

    if (valor_temp >= 12'd900) begin
        d2 = 4'd9;
        valor_temp2 = valor_temp - 12'd900;
    end else if (valor_temp >= 12'd800) begin
        d2 = 4'd8;
        valor_temp2 = valor_temp - 12'd800;
    end else if (valor_temp >= 12'd700) begin
        d2 = 4'd7;
        valor_temp2 = valor_temp - 12'd700;
    end else if (valor_temp >= 12'd600) begin
        d2 = 4'd6;
        valor_temp2 = valor_temp - 12'd600;
    end else if (valor_temp >= 12'd500) begin
        d2 = 4'd5;
        valor_temp2 = valor_temp - 12'd500;
    end else if (valor_temp >= 12'd400) begin
        d2 = 4'd4;
        valor_temp2 = valor_temp - 12'd400;
    end else if (valor_temp >= 12'd300) begin
        d2 = 4'd3;
        valor_temp2 = valor_temp - 12'd300;
    end else if (valor_temp >= 12'd200) begin
        d2 = 4'd2;
        valor_temp2 = valor_temp - 12'd200;
    end else if (valor_temp >= 12'd100) begin
        d2 = 4'd1;
        valor_temp2 = valor_temp - 12'd100;
    end else begin
        d2 = 4'd0;
        valor_temp2 = valor_temp;
    end

    if (valor_temp2 >= 12'd90) begin
        d1 = 4'd9;
        d0 = valor_temp2 - 12'd90;
    end else if (valor_temp2 >= 12'd80) begin
        d1 = 4'd8;
        d0 = valor_temp2 - 12'd80;
    end else if (valor_temp2 >= 12'd70) begin
        d1 = 4'd7;
        d0 = valor_temp2 - 12'd70;
    end else if (valor_temp2 >= 12'd60) begin
        d1 = 4'd6;
        d0 = valor_temp2 - 12'd60;
    end else if (valor_temp2 >= 12'd50) begin
        d1 = 4'd5;
        d0 = valor_temp2 - 12'd50;
    end else if (valor_temp2 >= 12'd40) begin
        d1 = 4'd4;
        d0 = valor_temp2 - 12'd40;
    end else if (valor_temp2 >= 12'd30) begin
        d1 = 4'd3;
        d0 = valor_temp2 - 12'd30;
    end else if (valor_temp2 >= 12'd20) begin
        d1 = 4'd2;
        d0 = valor_temp2 - 12'd20;
    end else if (valor_temp2 >= 12'd10) begin
        d1 = 4'd1;
        d0 = valor_temp2 - 12'd10;
    end else begin
        d1 = 4'd0;
        d0 = valor_temp2[3:0];
    end
end

    display_4dig_mux #(
        .CLK_FREQ(27000000),
        .REFRESH_HZ(1000),
        .COMMON_ANODE(1)
    ) u_display (
        .clk (clk27),
        .rst (rst),
        .d0  (d0),
        .d1  (d1),
        .d2  (d2),
        .d3  (d3),
        .seg (seg),
        .dig (dig)
    );

endmodule