module display_4dig_mux #(
    parameter integer CLK_FREQ     = 27_000_000,
    parameter integer REFRESH_HZ   = 1000,
    parameter         COMMON_ANODE = 1
)(
    input  logic       clk,
    input  logic       rst,
    input  logic [3:0] d0,    // unidades
    input  logic [3:0] d1,    // decenas
    input  logic [3:0] d2,    // centenas
    input  logic [3:0] d3,    // millares
    output logic [6:0] seg,
    output logic [3:0] dig
);

//-----------------------------------------------------
// Divisor frecuencia, cada dígito se activa durante 1/4 del ciclo de refresco
//-----------------------------------------------------

    localparam integer TICKS_PER_DIGIT = CLK_FREQ / (REFRESH_HZ * 4);

    logic [$clog2(TICKS_PER_DIGIT)-1:0] refresh_cnt;
    logic [1:0] sel;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            refresh_cnt <= '0;
            sel         <= 2'd0;
        end else begin
            if (refresh_cnt == TICKS_PER_DIGIT - 1) begin
                refresh_cnt <= '0;
                sel         <= sel + 2'd1;
            end else begin
                refresh_cnt <= refresh_cnt + 1;
            end
        end
    end

//-----------------------------------------------------
// Selección del dígito activo y su valor
//-----------------------------------------------------

    logic [3:0] digit_val;
    logic [3:0] dig_raw;

    always_comb begin
        case (sel)
            2'd0: begin digit_val = d0; dig_raw = 4'b0001; end
            2'd1: begin digit_val = d1; dig_raw = 4'b0010; end
            2'd2: begin digit_val = d2; dig_raw = 4'b0100; end
            2'd3: begin digit_val = d3; dig_raw = 4'b1000; end
            default: begin digit_val = 4'd0; dig_raw = 4'b0001; end
        endcase
    end

//-----------------------------------------------------
// Decodificador BCD 7SEG
//-----------------------------------------------------

    logic [6:0] seg_raw;

    always_comb begin
        case (digit_val)
            4'd0: seg_raw = 7'b0111111;
            4'd1: seg_raw = 7'b0000110;
            4'd2: seg_raw = 7'b1011011;
            4'd3: seg_raw = 7'b1001111;
            4'd4: seg_raw = 7'b1100110;
            4'd5: seg_raw = 7'b1101101;
            4'd6: seg_raw = 7'b1111101;
            4'd7: seg_raw = 7'b0000111;
            4'd8: seg_raw = 7'b1111111;
            4'd9: seg_raw = 7'b1101111;
            default: seg_raw = 7'b0000000;
        endcase
    end

//-----------------------------------------------------
// Registra salidas sincrónicas
// Evita glitches en los segmentos y dígitos
//-----------------------------------------------------

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            seg <= '0;
            dig <= '0;
        end else begin
            seg <= COMMON_ANODE ? ~seg_raw : seg_raw;
            dig <= COMMON_ANODE ? ~dig_raw : dig_raw;
        end
    end

endmodule