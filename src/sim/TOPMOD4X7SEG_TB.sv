`timescale 1ns/1ps

module top_tb;
    /*
    Observe que en esta seccion los logic no se definen como input o output, son propios del modulo
    como si fueran un nodo, por eso se conectan en el DUT. 
    */
    logic [3:0] sw;                      
    logic [6:0] segments;
    logic [6:0] out;

    // DUT (Device Under Test)

    /*
    Observe que .sw se refiere al nodo sw creado en este propio modulo, (sw) se refiere al input 
    definido en el top. Se recomienda usar los mismos nombres porque esto permite seguir trabajando
    con el mismo nombre de variable y la conexion es mas facil. De igual forma para las demas.

    Observe que se prefiere usar los S# porque es mas facil y corto que escribir segments[#]...
    */
    top dut (
        .sw(sw),
        .segments({SA, SB, SC, SD, SE, SF, SG})
    );

    // Función que devuelve patrón esperado. Se utilizara para comparar 'segments' contra 'expected'
    function automatic [6:0] expected (input [3:0] val);
        case (val)
            4'd0: expected = 7'b1111110;
            4'd1: expected = 7'b0110000;
            4'd2: expected = 7'b1101101;
            4'd3: expected = 7'b1111001;
            4'd4: expected = 7'b0110011;
            4'd5: expected = 7'b1011011;
            4'd6: expected = 7'b1011111;
            4'd7: expected = 7'b1110000;
            4'd8: expected = 7'b1111111;
            4'd9: expected = 7'b1110011;
            4'd10: expected = 7'b1110111; // A
            4'd11: expected = 7'b0011111; // B
            4'd12: expected = 7'b1001110; // C
            4'd13: expected = 7'b0111101; // D
            4'd14: expected = 7'b1001111; // E
            4'd15: expected = 7'b1000111; // F


            default: expected = 7'b0000000;
        endcase
    endfunction

    initial begin
        $display("Starting exhaustive test...");

        for (int i = 0; i < 16; i++) begin
            sw = i;
            #1;
            out = {SG, SF, SE, SD, SC, SB, SA};       

            if (out !== expected(i)) begin
                $display("ERROR at %0d -> got %b expected %b",
                         i, out, expected(i));
            end
            else begin
                $display("OK %0d -> %b", i, out);
            end
        end

        $display("Test finished");
        $finish;
    end

    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0,top_tb);
    end

endmodule