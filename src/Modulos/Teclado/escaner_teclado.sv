module escaner_teclado(
    input  logic       clk,
    input  logic       rst,
    input  logic       scan_tick,
    output logic [1:0] col_idx,
    output logic [3:0] cols,
    output logic       sample_en  // nuevo: pulso para leer filas
);
    logic phase; // 0 = drive, 1 = sample

    always_ff @(posedge clk) begin
        if (rst) begin
            col_idx   <= 2'd0;
            phase     <= 1'b0;
            sample_en <= 1'b0;
        end else begin
            sample_en <= 1'b0;
            if (scan_tick) begin
                if (phase == 1'b0) begin
                    phase <= 1'b1; // siguiente tick: samplear
                end else begin
                    sample_en <= 1'b1; // pulso de lectura
                    phase     <= 1'b0;
                    col_idx   <= col_idx + 2'd1;
                end
            end
        end
    end

    always_comb begin
        case (col_idx)
            2'd0: cols = 4'b1110;
            2'd1: cols = 4'b1101;
            2'd2: cols = 4'b1011;
            2'd3: cols = 4'b0111;
            default: cols = 4'b1111;
        endcase
    end
endmodule


/* 
Este módulo realiza el barrido de las columnas del teclado matricial. 
Activa una columna a la vez para identificar en cuál se encuentra la tecla presionada. 
Esto permite combinar esa información con las filas activas y así detectar correctamente 
qué botón fue pulsado.
*/