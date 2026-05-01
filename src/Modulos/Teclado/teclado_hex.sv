module teclado_hex(
    input  logic       clk,
    input  logic       rst,
    input  logic       scan_tick,
    input  logic [3:0] rows_async,

    output logic [3:0] cols,
    output logic       key_valid,
    output logic [3:0] key_code
);

    logic [1:0] col_idx;
    logic [3:0] rows_1, rows_2;

    logic cur_found;
    logic [3:0] cur_key;

    logic scan_found;
    logic [3:0] scan_key;

    logic locked;
    logic [2:0] press_count;
    logic [2:0] release_count;

    always_ff @(posedge clk) begin
        rows_1 <= rows_async;
        rows_2 <= rows_1;
    end

    always_comb begin
        case (col_idx)
            2'd0: cols = 4'b1110; // C1
            2'd1: cols = 4'b1101; // C2
            2'd2: cols = 4'b1011; // C3
            2'd3: cols = 4'b0111; // C4
            default: cols = 4'b1111;
        endcase
    end

    always_comb begin
        cur_found = 1'b0;
        cur_key   = 4'h0;

        case ({rows_2, col_idx})

            {4'b1110, 2'd0}: begin cur_found = 1'b1; cur_key = 4'h1; end
            {4'b1101, 2'd0}: begin cur_found = 1'b1; cur_key = 4'h4; end
            {4'b1011, 2'd0}: begin cur_found = 1'b1; cur_key = 4'h7; end
            {4'b0111, 2'd0}: begin cur_found = 1'b1; cur_key = 4'hE; end // *

            {4'b1110, 2'd1}: begin cur_found = 1'b1; cur_key = 4'h2; end
            {4'b1101, 2'd1}: begin cur_found = 1'b1; cur_key = 4'h5; end
            {4'b1011, 2'd1}: begin cur_found = 1'b1; cur_key = 4'h8; end
            {4'b0111, 2'd1}: begin cur_found = 1'b1; cur_key = 4'h0; end

            // C3
            {4'b1110, 2'd2}: begin cur_found = 1'b1; cur_key = 4'h3; end
            {4'b1101, 2'd2}: begin cur_found = 1'b1; cur_key = 4'h6; end
            {4'b1011, 2'd2}: begin cur_found = 1'b1; cur_key = 4'h9; end
            {4'b0111, 2'd2}: begin cur_found = 1'b1; cur_key = 4'hF; end // #// #

            {4'b1110, 2'd3}: begin cur_found = 1'b1; cur_key = 4'hA; end
            {4'b1101, 2'd3}: begin cur_found = 1'b1; cur_key = 4'hB; end
            {4'b1011, 2'd3}: begin cur_found = 1'b1; cur_key = 4'hC; end
            {4'b0111, 2'd3}: begin cur_found = 1'b1; cur_key = 4'hD; end

            default: begin
                cur_found = 1'b0;
                cur_key   = 4'h0;
            end
        endcase
    end

    always_ff @(posedge clk) begin
        if (rst) begin
            col_idx       <= 2'd0;
            key_valid     <= 1'b0;
            key_code      <= 4'h0;
            scan_found    <= 1'b0;
            scan_key      <= 4'h0;
            locked        <= 1'b0;
            press_count   <= 3'd0;
            release_count <= 3'd0;
        end else begin
            key_valid <= 1'b0;

            if (scan_tick) begin

                if (cur_found) begin
                    scan_found <= 1'b1;
                    scan_key   <= cur_key;
                end

                if (col_idx == 2'd3) begin

                    if (scan_found || cur_found) begin
                        release_count <= 3'd0;

                        if (!locked) begin
                            if (press_count >= 3'd2) begin
                                key_code  <= cur_found ? cur_key : scan_key;
                                key_valid <= 1'b1;
                                locked    <= 1'b1;
                                press_count <= 3'd0;
                            end else begin
                                press_count <= press_count + 1'b1;
                            end
                        end

                    end else begin
                        press_count <= 3'd0;

                        if (release_count >= 3'd2) begin
                            locked <= 1'b0;
                            release_count <= 3'd0;
                        end else begin
                            release_count <= release_count + 1'b1;
                        end
                    end

                    scan_found <= 1'b0;
                    scan_key   <= 4'h0;
                end

                col_idx <= col_idx + 2'd1;
            end
        end
    end

endmodule
/*
Este módulo se encarga de leer el teclado hexadecimal completo. 
Su función principal es detectar cuándo se presiona una tecla y convertir esa 
pulsación en un valor digital de 4 bits (key_code). Para lograrlo, este integra el escaneo 
de columnas, la sincronización de señales externas, la eliminación de rebotes y la 
decodificación de la tecla presionada. Genera una señal key_valid que indica 
que la tecla detectada es válida y puede ser utilizada por el sistema.
*/