module antirrebote #(
    parameter int WIDTH = 4,
    parameter int COUNT_MAX = 135000
)(
    input  logic             clk,
    input  logic             rst,
    input  logic [WIDTH-1:0] noisy_in,
    output logic [WIDTH-1:0] clean_out
);

    localparam int CW = (COUNT_MAX <= 1) ? 1 : $clog2(COUNT_MAX);

    logic [WIDTH-1:0] last_sample;
    logic [CW-1:0]    counter [WIDTH-1:0];

    integer i;

    always_ff @(posedge clk) begin
        if (rst) begin
            clean_out    <= '0;
            last_sample  <= '0;
            for (i = 0; i < WIDTH; i++) begin
                counter[i] <= '0;
            end
        end else begin
            for (i = 0; i < WIDTH; i++) begin
                if (noisy_in[i] == last_sample[i]) begin
                    if (counter[i] < COUNT_MAX-1) begin
                        counter[i] <= counter[i] + 1'b1;
                    end else begin
                        clean_out[i] <= noisy_in[i];
                    end
                end else begin
                    last_sample[i] <= noisy_in[i];
                    counter[i]     <= '0;
                end
            end
        end
    end

endmodule

/* 
Este módulo elimina los rebotes mecánicos de las teclas del teclado. 
Cuando una tecla se presiona, lo normal es que genere varias transiciones rápidas no deseadas. 
El antirrebote espera a que la señal se mantenga estable antes de aceptarla como una 
pulsación real.
*/
