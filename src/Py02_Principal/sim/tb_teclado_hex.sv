`timescale 1ns/1ps

module tb_teclado_hex;

    logic clk;
    logic rst;
    logic scan_tick;
    logic [3:0] rows_async;
    logic [3:0] cols;
    logic key_valid;
    logic [3:0] key_code;

    logic       pressing;
    logic [3:0] press_col;
    logic [3:0] press_row;

    int errores;
    int pruebas;

    teclado_hex #(
        .DEBOUNCE_COUNT(1)
    ) dut (
        .clk        (clk),
        .rst        (rst),
        .scan_tick  (scan_tick),
        .rows_async (rows_async),
        .cols       (cols),
        .key_valid  (key_valid),
        .key_code   (key_code)
    );

    initial begin
        $dumpfile("tb_teclado_hex.vcd");
        $dumpvars(0, tb_teclado_hex);
    end

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        scan_tick = 0;
        forever begin
            #40 scan_tick = 1;
            #10 scan_tick = 0;
        end
    end

    always_comb begin
        if (pressing && cols == press_col)
            rows_async = press_row;
        else
            rows_async = 4'b1111;
    end

    task automatic probar_tecla(
        input logic [3:0] col,
        input logic [3:0] row,
        input logic [3:0] esperado,
        input string nombre
    );
        begin
            pruebas++;

            pressing  = 1'b1;
            press_col = col;
            press_row = row;

            wait (key_valid == 1'b1);

            if (key_code == esperado) begin
                $display("OK    tecla %s detectada correctamente: %h", nombre, key_code);
            end else begin
                $display("ERROR tecla %s: esperado = %h, obtenido = %h", nombre, esperado, key_code);
                errores++;
            end

            @(posedge clk);
            pressing = 1'b0;

            repeat (30) @(posedge clk);
        end
    endtask

    initial begin
        errores = 0;
        pruebas = 0;

        rst = 1;
        pressing  = 0;
        press_col = 4'b1111;
        press_row = 4'b1111;

        #100;
        rst = 0;
        #200;

        // Mapa:
        //      COL0   COL1   COL2   COL3
        // ROW0   1      2      3      A
        // ROW1   4      5      6      B
        // ROW2   7      8      9      C
        // ROW3   *      0      #      D

        probar_tecla(4'b1110, 4'b1110, 4'h1, "1");
        probar_tecla(4'b1101, 4'b1110, 4'h2, "2");
        probar_tecla(4'b1011, 4'b1110, 4'h3, "3");
        probar_tecla(4'b0111, 4'b1110, 4'hA, "A");

        probar_tecla(4'b1110, 4'b1101, 4'h4, "4");
        probar_tecla(4'b1101, 4'b1101, 4'h5, "5");
        probar_tecla(4'b1011, 4'b1101, 4'h6, "6");
        probar_tecla(4'b0111, 4'b1101, 4'hB, "B");

        probar_tecla(4'b1110, 4'b1011, 4'h7, "7");
        probar_tecla(4'b1101, 4'b1011, 4'h8, "8");
        probar_tecla(4'b1011, 4'b1011, 4'h9, "9");
        probar_tecla(4'b0111, 4'b1011, 4'hC, "C");

        probar_tecla(4'b1110, 4'b0111, 4'hE, "*");
        probar_tecla(4'b1101, 4'b0111, 4'h0, "0");
        probar_tecla(4'b1011, 4'b0111, 4'hF, "#");
        probar_tecla(4'b0111, 4'b0111, 4'hD, "D");

        #500;

        if (errores == 0) begin
            $display("--------------------------------------");
            $display("TODAS LAS PRUEBAS PASARON: %0d/%0d", pruebas, pruebas);
            $display("--------------------------------------");
        end else begin
            $display("--------------------------------------");
            $display("FALLARON %0d DE %0d PRUEBAS", errores, pruebas);
            $display("--------------------------------------");
        end

        $finish;
    end

endmodule