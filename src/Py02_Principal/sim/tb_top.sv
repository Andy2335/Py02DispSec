`timescale 1ns/1ps

module tb_top;

    logic clk27;
    logic rst_n;

    logic [3:0] keypad_rows;
    logic [3:0] keypad_cols;

    logic [6:0] seg;
    logic [3:0] dig;

    logic pressing;
    logic [3:0] press_col;
    logic [3:0] press_row;

    int errores;

    top dut (
        .clk27       (clk27),
        .rst_n       (rst_n),
        .keypad_rows (keypad_rows),
        .keypad_cols (keypad_cols),
        .seg         (seg),
        .dig         (dig)
    );

    //-------------------------------------------------
    // VCD
    //-------------------------------------------------
    initial begin
        $dumpfile("tb_top.vcd");
        $dumpvars(0, tb_top);
    end

    //-------------------------------------------------
    // Clock
    //-------------------------------------------------
    initial clk27 = 0;
    always #5 clk27 = ~clk27;

    //-------------------------------------------------
    // Modelo del teclado
    //-------------------------------------------------
    always_comb begin
        if (pressing && keypad_cols == press_col)
            keypad_rows = press_row;
        else
            keypad_rows = 4'b1111;
    end

    //-------------------------------------------------
    // Presionar tecla
    //-------------------------------------------------
    task automatic presionar_tecla(
    input logic [3:0] col,
    input logic [3:0] row
);
    int timeout;
    begin
        // Espera antes de presionar
        repeat (300_000) @(posedge clk27);

        press_col = col;
        press_row = row;
        pressing  = 1'b1;

        timeout = 0;

        while (dut.key_valid != 1'b1 && timeout < 30_000_000) begin
            @(posedge clk27);
            timeout++;
        end

        if (timeout >= 30_000_000) begin
            $display("ERROR: timeout esperando key_valid. col=%b row=%b", col, row);
            errores++;
        end

        // Mantiene la tecla presionada un poco más
        repeat (300_000) @(posedge clk27);

        // Suelta la tecla
        pressing = 1'b0;

        // MUY IMPORTANTE:
        // Esperar a que el antirrebote vuelva a detectar "sin tecla"
        repeat (600_000) @(posedge clk27);
    end
endtask
    //-------------------------------------------------
    // Verificación
    //-------------------------------------------------
    task automatic check(
        input string name,
        input int obtenido,
        input int esperado
    );
        begin
            if (obtenido == esperado)
                $display("OK    %s = %0d", name, obtenido);
            else begin
                $display("ERROR %s: esperado=%0d obtenido=%0d", name, esperado, obtenido);
                errores++;
            end
        end
    endtask

    //-------------------------------------------------
    // TEST
    //-------------------------------------------------
    initial begin
        errores = 0;

        rst_n = 0;
        pressing = 0;
        press_col = 4'b1111;
        press_row = 4'b1111;

        #100;
        rst_n = 1;

        repeat (5000) @(posedge clk27);

        $display("======================================");
        $display("TEST TOP: 123 + 45");
        $display("======================================");

        // 1
        presionar_tecla(4'b1110, 4'b1110);

        // 2
        presionar_tecla(4'b1101, 4'b1110);

        // 3
        presionar_tecla(4'b1011, 4'b1110);

        check("numA", dut.numA, 123);

        // A (cambiar a B)
        presionar_tecla(4'b0111, 4'b1110);

        // 4
        presionar_tecla(4'b1110, 4'b1101);

        // 5
        presionar_tecla(4'b1101, 4'b1101);

        check("numB", dut.numB, 45);

        // B (calcular)
        presionar_tecla(4'b0111, 4'b1101);

        repeat (5000) @(posedge clk27);

        check("resultado", dut.resultado_suma, 168);

        if (dut.d3 == 0 && dut.d2 == 1 && dut.d1 == 6 && dut.d0 == 8)
            $display("OK    Display correcto: 0168");
        else begin
            $display("ERROR Display: %0d%0d%0d%0d",
                dut.d3, dut.d2, dut.d1, dut.d0);
            errores++;
        end

        $display("======================================");

        if (errores == 0)
            $display("TODO EL TOP FUNCIONA");
        else
            $display("FALLARON %0d PRUEBAS", errores);

        $display("======================================");

        #1000;
        $finish;
    end

endmodule