`timescale 1ns/1ps

module display_4dig_mux_tb;

    logic clk;
    logic rst;
    logic [3:0] d0, d1, d2, d3;
    logic [6:0] seg;
    logic [3:0] dig;

    display_4dig_mux #(
        .CLK_FREQ(1000),
        .REFRESH_HZ(10),
        .COMMON_ANODE(0)
    ) dut (
        .clk(clk),
        .rst(rst),
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .seg(seg),
        .dig(dig)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        d0 = 0; d1 = 0; d2 = 0; d3 = 0;
        #20;
        rst = 0;

        // 0000
        d0 = 0; d1 = 0; d2 = 0; d3 = 0;
        #500;

        // 0007
        d0 = 7; d1 = 0; d2 = 0; d3 = 0;
        #500;

        // 0042
        d0 = 2; d1 = 4; d2 = 0; d3 = 0;
        #500;

        // 0123
        d0 = 3; d1 = 2; d2 = 1; d3 = 0;
        #500;

        // 2026
        d0 = 6; d1 = 2; d2 = 0; d3 = 2;
        #500;

        // 9999
        d0 = 9; d1 = 9; d2 = 9; d3 = 9;
        #500;

        $finish;
    end

endmodule