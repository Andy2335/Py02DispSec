module display_4dig_mux #(
    parameter CLK_FREQ    = 27_000_000,   // Frecuencia del reloj
    parameter REFRESH_HZ  = 1000,         // Freco total de refresco
    parameter COMMON_ANODE = 1            // 1 = ánodo común, 0 = cátodo común
)(
    input  logic        clk,
    input  logic        rst,
    input  logic [13:0] number,           // Rango suficiente para 0 a 9999
    output logic [6:0]  seg,              // Segmentos a,b,c,d,e,f,g
    output logic [3:0]  dig               // Habilitación de displays
);

    // =========================================================
    // 1) Separar número decimal en 4 dígitos BCD
    // =========================================================
    logic [3:0] unidades;
    logic [3:0] decenas;
    logic [3:0] centenas;
    logic [3:0] millares;

    logic [13:0] num_limited;

    always_comb begin
        // Limitar a 9999 por seguridad
        if (number > 14'd9999)
            num_limited = 14'd9999;
        else
            num_limited = number;

        millares = num_limited / 1000;
        centenas = (num_limited % 1000) / 100;
        decenas  = (num_limited % 100) / 10;
        unidades = num_limited % 10;
    end

    // =========================================================
    // 2) Divisor para multiplexación
    // =========================================================
    localparam integer TICKS_PER_DIGIT = CLK_FREQ / (REFRESH_HZ * 4);

    logic [$clog2(TICKS_PER_DIGIT)-1:0] refresh_counter;
    logic [1:0] sel;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            refresh_counter <= 0;
            sel             <= 0;
        end else begin
            if (refresh_counter == TICKS_PER_DIGIT - 1) begin
                refresh_counter <= 0;
                sel             <= sel + 2'd1;
            end else begin
                refresh_counter <= refresh_counter + 1;
            end
        end
    end

    // =========================================================
    // 3) Selección del dígito actual
    // =========================================================
    logic [3:0] current_digit;

    always_comb begin
        case (sel)
            2'd0: current_digit = unidades;
            2'd1: current_digit = decenas;
            2'd2: current_digit = centenas;
            2'd3: current_digit = millares;
            default: current_digit = 4'd0;
        endcase
    end

    // =========================================================
    // 4) Activación del display correspondiente
    // =========================================================
    logic [3:0] dig_raw;

    always_comb begin
        case (sel)
            2'd0: dig_raw = 4'b0001; // display 0
            2'd1: dig_raw = 4'b0010; // display 1
            2'd2: dig_raw = 4'b0100; // display 2
            2'd3: dig_raw = 4'b1000; // display 3
            default: dig_raw = 4'b0001;
        endcase
    end

    // Ajuste para ánodo común o cátodo común
    always_comb begin
        if (COMMON_ANODE)
            dig = ~dig_raw;
        else
            dig = dig_raw;
    end

    // =========================================================
    // 5) Decodificador BCD a 7 segmentos
    //    Formato seg = {a,b,c,d,e,f,g}
    // =========================================================
    logic [6:0] seg_raw;

    always_comb begin
        case (current_digit)
            4'd0: seg_raw = 7'b1111110;
            4'd1: seg_raw = 7'b0110000;
            4'd2: seg_raw = 7'b1101101;
            4'd3: seg_raw = 7'b1111001;
            4'd4: seg_raw = 7'b0110011;
            4'd5: seg_raw = 7'b1011011;
            4'd6: seg_raw = 7'b1011111;
            4'd7: seg_raw = 7'b1110000;
            4'd8: seg_raw = 7'b1111111;
            4'd9: seg_raw = 7'b1111011;
            default: seg_raw = 7'b0000001; // guión o apagado según convenga
        endcase
    end

    // Ajuste para ánodo común o cátodo común
    always_comb begin
        if (COMMON_ANODE)
            seg = ~seg_raw;
        else
            seg = seg_raw;
    end

endmodule