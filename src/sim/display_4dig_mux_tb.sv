`timescale 1ns/1ps

module display_4dig_mux_tb;

    // =========================================================
    // Señales de prueba
    // =========================================================
    logic        clk;
    logic        rst;
    logic [13:0] number;
    logic [6:0]  seg;
    logic [3:0]  dig;

    // =========================================================
    // Instancia del DUT
    // =========================================================
    display_4dig_mux #(
        .CLK_FREQ(1000),       // valor pequeño para simulación rápida
        .REFRESH_HZ(10),       // valor pequeño para ver cambios fácilmente
        .COMMON_ANODE(0)       // cambiar a 1 si quiere probar ánodo común
    ) dut (
        .clk   (clk),
        .rst   (rst),
        .number(number),
        .seg   (seg),
        .dig   (dig)
    );

    // =========================================================
    // Generación de reloj
    // =========================================================
    initial clk = 0;
    always #5 clk = ~clk;   // reloj de 10 ns de período

    // =========================================================
    // Monitoreo
    // =========================================================
    initial begin
        $display("Tiempo\t rst\t number\t dig\t seg");
        $monitor("%0t\t %b\t %0d\t %b\t %b", $time, rst, number, dig, seg);
    end

    // =========================================================
    // Estímulos
    // =========================================================
    initial begin
        // Inicialización
        rst    = 1;
        number = 0;

        // Mantener reset unos ciclos
        #30;
        rst = 0;

        // Prueba 1
        number = 14'd0;
        #500;

        // Prueba 2
        number = 14'd7;
        #500;

        // Prueba 3
        number = 14'd42;
        #500;

        // Prueba 4
        number = 14'd123;
        #500;

        // Prueba 5
        number = 14'd2026;
        #500;

        // Prueba 6
        number = 14'd9999;
        #500;

        // Prueba 7: valor mayor a 9999
        number = 14'd12000;
        #500;

        $finish;
    end

endmodule