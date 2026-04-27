`timescale 1ns/1ps

module tb_control_entrada;

    logic clk;
    logic rst;

    logic key_valid;
    logic [3:0] key_code;

    logic limpiar;
    logic cargar_a;
    logic cargar_b;
    logic calcular;
    logic [1:0] seleccion_display;

    logic [10:0] numA;
    logic [10:0] numB;

    logic [1:0] digitosA;
    logic [1:0] digitosB;

    logic llenoA;
    logic llenoB;

    int errores;

    control_entrada_fsm u_control (
        .clk               (clk),
        .rst               (rst),
        .key_valid         (key_valid),
        .key_code          (key_code),
        .a_lleno           (llenoA),
        .b_lleno           (llenoB),
        .limpiar           (limpiar),
        .cargar_a          (cargar_a),
        .cargar_b          (cargar_b),
        .calcular          (calcular),
        .seleccion_display (seleccion_display)
    );

    constructor_numero u_numA (
        .clk              (clk),
        .rst              (rst),
        .limpiar          (limpiar),
        .cargar_digito    (cargar_a),
        .digito           (key_code),
        .numero           (numA),
        .cantidad_digitos (digitosA),
        .lleno            (llenoA)
    );

    constructor_numero u_numB (
        .clk              (clk),
        .rst              (rst),
        .limpiar          (limpiar),
        .cargar_digito    (cargar_b),
        .digito           (key_code),
        .numero           (numB),
        .cantidad_digitos (digitosB),
        .lleno            (llenoB)
    );

    initial begin
        $dumpfile("tb_control_entrada.vcd");
        $dumpvars(0, tb_control_entrada);
    end

    initial clk = 0;
    always #5 clk = ~clk;

    task automatic presionar_tecla(input logic [3:0] tecla);
        begin
            @(negedge clk);
            key_code  = tecla;
            key_valid = 1'b1;

            @(negedge clk);
            key_valid = 1'b0;
            key_code  = 4'h0;

            repeat (2) @(negedge clk);
        end
    endtask

    task automatic verificar_numero(
        input string nombre,
        input logic [10:0] obtenido,
        input logic [10:0] esperado
    );
        begin
            if (obtenido == esperado) begin
                $display("OK    %s = %0d", nombre, obtenido);
            end else begin
                $display("ERROR %s: esperado = %0d, obtenido = %0d",
                         nombre, esperado, obtenido);
                errores++;
            end
        end
    endtask

    task automatic verificar_bit(
        input string nombre,
        input logic obtenido,
        input logic esperado
    );
        begin
            if (obtenido == esperado) begin
                $display("OK    %s = %0b", nombre, obtenido);
            end else begin
                $display("ERROR %s: esperado = %0b, obtenido = %0b",
                         nombre, esperado, obtenido);
                errores++;
            end
        end
    endtask

    initial begin
        errores = 0;

        rst = 1;
        key_valid = 0;
        key_code = 4'h0;

        #100;
        rst = 0;

        repeat (3) @(negedge clk);

        $display("--------------------------------------");
        $display("PRUEBA 1: ingresar 123 A 45 B");
        $display("--------------------------------------");

        presionar_tecla(4'h1);
        presionar_tecla(4'h2);
        presionar_tecla(4'h3);

        verificar_numero("numA despues de 123", numA, 11'd123);
        verificar_numero("numB antes de ingresar B", numB, 11'd0);

        presionar_tecla(4'hA);

        if (seleccion_display == 2'd1)
            $display("OK    FSM paso a INGRESO_B");
        else begin
            $display("ERROR FSM no paso a INGRESO_B");
            errores++;
        end

        presionar_tecla(4'h4);
        presionar_tecla(4'h5);

        verificar_numero("numB despues de 45", numB, 11'd45);

        presionar_tecla(4'hB);

        if (seleccion_display == 2'd2)
            $display("OK    FSM paso a MOSTRAR_RESULTADO");
        else begin
            $display("ERROR FSM no paso a MOSTRAR_RESULTADO");
            errores++;
        end

        $display("--------------------------------------");
        $display("PRUEBA 2: reset con tecla D");
        $display("--------------------------------------");

        presionar_tecla(4'hD);

        verificar_numero("numA despues de D", numA, 11'd0);
        verificar_numero("numB despues de D", numB, 11'd0);

        if (seleccion_display == 2'd0)
            $display("OK    FSM regreso a INGRESO_A");
        else begin
            $display("ERROR FSM no regreso a INGRESO_A");
            errores++;
        end

        $display("--------------------------------------");
        $display("PRUEBA 3: limite de 3 digitos");
        $display("--------------------------------------");

        presionar_tecla(4'h9);
        presionar_tecla(4'h8);
        presionar_tecla(4'h7);
        presionar_tecla(4'h6);

        verificar_numero("numA limitado a 3 digitos", numA, 11'd987);

        $display("--------------------------------------");

        if (errores == 0) begin
            $display("TODAS LAS PRUEBAS DE CONTROL PASARON");
        end else begin
            $display("FALLARON %0d PRUEBAS DE CONTROL", errores);
        end

        $display("--------------------------------------");

        #200;
        $finish;
    end

endmodule