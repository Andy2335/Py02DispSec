`timescale 1ns/1ps

module suma_aritmetica_8bits_tb;

    logic        clk;
    logic        rst;
    logic [7:0]  dato_a;
    logic [7:0]  dato_b;
    logic [8:0]  resultado;
    logic        overflow;

    suma_aritmetica_8bits dut (
        .clk(clk),
        .rst(rst),
        .dato_a(dato_a),
        .dato_b(dato_b),
        .resultado(resultado),
        .overflow(overflow)
    );

    // Reloj de 10 ns
    always #5 clk = ~clk;

    task probar_suma(
        input logic [7:0] a,
        input logic [7:0] b
    );
        logic [8:0] esperado;
        begin
            esperado = a + b;

            dato_a = a;
            dato_b = b;

            @(posedge clk);
            #1;

            $display("A=%0d (%b) | B=%0d (%b) | Resultado=%0d (%b) | Overflow=%b | Esperado=%0d (%b)",
                     a, a, b, b, resultado, resultado, overflow, esperado, esperado);

            if (resultado !== esperado || overflow !== esperado[8]) begin
                $display("ERROR: resultado incorrecto");
            end else begin
                $display("OK");
            end

            $display("--------------------------------------------------");
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        dato_a = 8'b00000000;
        dato_b = 8'b00000000;

        #12;
        rst = 0;

        // Casos sin overflow
        probar_suma(8'd0,   8'd0);
        probar_suma(8'd3,   8'd5);
        probar_suma(8'd100, 8'd50);
        probar_suma(8'd127, 8'd128);

        // Casos con overflow
        probar_suma(8'd255, 8'd1);
        probar_suma(8'd200, 8'd100);
        probar_suma(8'd255, 8'd255);
        probar_suma(8'd170, 8'd170);

        #20;
        $finish;
    end

endmodule