module decodificador_teclado(
    input  logic [1:0] col_idx,
    input  logic [3:0] rows,
    output logic       key_found,
    output logic [3:0] key_code
);

    always_comb begin
        key_found = 1'b0;
        key_code  = 4'h0;

        case (col_idx)
            2'd0: begin
                case (rows)
                    4'b1110: begin key_found = 1'b1; key_code = 4'h1; end
                    4'b1101: begin key_found = 1'b1; key_code = 4'h4; end
                    4'b1011: begin key_found = 1'b1; key_code = 4'h7; end
                    4'b0111: begin key_found = 1'b1; key_code = 4'hE; end // *
                    default: ;
                endcase
            end

            2'd1: begin
                case (rows)
                    4'b1110: begin key_found = 1'b1; key_code = 4'h2; end
                    4'b1101: begin key_found = 1'b1; key_code = 4'h5; end
                    4'b1011: begin key_found = 1'b1; key_code = 4'h8; end
                    4'b0111: begin key_found = 1'b1; key_code = 4'h0; end
                    default: ;
                endcase
            end

            2'd2: begin
                case (rows)
                    4'b1110: begin key_found = 1'b1; key_code = 4'h3; end
                    4'b1101: begin key_found = 1'b1; key_code = 4'h6; end
                    4'b1011: begin key_found = 1'b1; key_code = 4'h9; end
                    4'b0111: begin key_found = 1'b1; key_code = 4'hF; end // #
                    default: ;
                endcase
            end

            2'd3: begin
                case (rows)
                    4'b1110: begin key_found = 1'b1; key_code = 4'hA; end
                    4'b1101: begin key_found = 1'b1; key_code = 4'hB; end
                    4'b1011: begin key_found = 1'b1; key_code = 4'hC; end
                    4'b0111: begin key_found = 1'b1; key_code = 4'hD; end
                    default: ;
                endcase
            end

            default: begin
                key_found = 1'b0;
                key_code  = 4'h0;
            end
        endcase
    end

endmodule

/* 
Este módulo convierte la combinación de fila y columna detectada en el valor real de la 
tecla presionada.
Transforma una posición física del teclado en un número hexadecimal 
como 1, 5, A o D, representado en binario de 4 bits.
*/