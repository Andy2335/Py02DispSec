module display_4dig_mux #(
    parameter CLK_FREQ     = 27_000_000,
    parameter REFRESH_HZ   = 1000,
    parameter COMMON_ANODE = 1
)(
    input  logic       clk,
    input  logic       rst,
    input  logic [3:0] d0,   // unidades
    input  logic [3:0] d1,   // decenas
    input  logic [3:0] d2,   // centenas
    input  logic [3:0] d3,   // millares
    output logic [6:0] seg,
    output logic [3:0] dig
);

    localparam integer TICKS_PER_DIGIT = CLK_FREQ / (REFRESH_HZ * 4);

    logic [$clog2(TICKS_PER_DIGIT)-1:0] refresh_counter;
    logic [1:0] sel;
    logic [3:0] current_digit;
    logic [6:0] seg_raw;
    logic [3:0] dig_raw;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            refresh_counter <= 0;
            sel <= 0;
        end else begin
            if (refresh_counter == TICKS_PER_DIGIT - 1) begin
                refresh_counter <= 0;
                sel <= sel + 2'd1;
            end else begin
                refresh_counter <= refresh_counter + 1;
            end
        end
    end

    always_comb begin
        case (sel)
            2'd0: current_digit = d0;
            2'd1: current_digit = d1;
            2'd2: current_digit = d2;
            2'd3: current_digit = d3;
            default: current_digit = 4'd0;
        endcase
    end

    always_comb begin
        case (sel)
            2'd0: dig_raw = 4'b0001;
            2'd1: dig_raw = 4'b0010;
            2'd2: dig_raw = 4'b0100;
            2'd3: dig_raw = 4'b1000;
            default: dig_raw = 4'b0001;
        endcase
    end

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
            default: seg_raw = 7'b0000001;
        endcase
    end

    always_comb begin
        if (COMMON_ANODE) begin
            seg = ~seg_raw;
            dig = ~dig_raw;
        end else begin
            seg = seg_raw;
            dig = dig_raw;
        end
    end

endmodule