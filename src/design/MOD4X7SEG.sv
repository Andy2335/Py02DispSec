// MODULO 5.2 - Seven Segment Display
// Autor: 
// Circuito combinacional para el display de 7 segmentos en representacion hexadecimal (0-F)

module top (
    input logic [3:0] sw,           // Bits de entrada: AIN ,BIN ,CIN ,DIN (MSB a LSB)
    output logic [6:0] segments     // Segments: SA, SB, SC, SD, SE, SF, SG (LSB a MSB)
    output logic [3:0] enable // Habilita la pocisiòn de cada segmento

);


// Definicion de bits de entrada y sus negados para facilitar la expresion de las funciones logicas de cada segmento
logic AIN, BIN, CIN, DIN;
logic AIN_N, BIN_N, CIN_N, DIN_N;
logic SA, SB, SC, SD, SE, SF, SG;

/*Asignacion de los bits de entrada */
assign AIN = sw[3];
assign BIN = sw[2];
assign CIN = sw[1];
assign DIN = sw[0];

/*Asignacion de operadores logicos reutilizados - NOT*/
assign AIN_N = ~AIN;
assign BIN_N = ~BIN;
assign CIN_N = ~CIN;
assign DIN_N = ~DIN;


/*Expresiones logicas para cada segmento*/

//Segmento A: SA = Din'(Ain+Bin')+Ain'(Cin+BinDin)+BinCin+AinBin'Cin'
assign SA = (DIN_N) & (AIN | BIN_N) | 
            (AIN_N) & (CIN | (BIN & DIN)) | 
            (BIN & CIN) | 
            (AIN & BIN_N & CIN_N);  

//Segmento B: SB = Bin'(Ain' + Din') + Ain'(Cin ⊙ Din) + Ain Din Cin'
assign SB = (BIN_N) & (AIN_N | DIN_N) | 
            (AIN_N) & (~(CIN ^ DIN)) | 
            (AIN & DIN & CIN_N);

//Segmento C: SC = AinBin' + Ain'(Bin + Din + Cin') + DinCin'
assign SC = (AIN & BIN_N) | 
            (AIN_N) & (BIN | DIN | CIN_N) | 
            (DIN & CIN_N);   

//Segmento D: SD = Din'(Ain'Bin' + BinCin + AinCin') + Din(BinCin' + Bin'Cin)
assign SD = (DIN_N & (AIN_N & BIN_N | BIN & CIN | AIN & CIN_N)) | 
            (DIN & (BIN & CIN_N | BIN_N & CIN));

//Segmento E: SE = Din'(Bin'+Cin) + Ain(Cin + Bin)
assign SE = (DIN_N & (BIN_N | CIN)) | 
            (AIN & (CIN | BIN));

//Segmento F: SF = Ain(Cin + Bin') + Din'(Bin + Cin') + Ain'BinCin'
assign SF = (AIN & (CIN | BIN_N)) | 
            (DIN_N & (BIN | CIN_N)) | 
            (AIN_N & BIN & CIN_N);

//Segmento G: SG = Ain(Din + Bin') + Cin(Bin' + Din') + Ain'BinCin'
assign SG = (AIN & (DIN | BIN_N)) | 
            (CIN & (BIN_N | DIN_N)) | 
            (AIN_N & BIN & CIN_N);

/*Asignacion de los bits de salida */
assign segments[0] = SA;
assign segments[1] = SB;
assign segments[2] = SC;
assign segments[3] = SD;
assign segments[4] = SE;
assign segments[5] = SF;
assign segments[6] = SG;

endmodule

/*
module bin_to_7seg_converter (
    input  logic [3:0] data_in,        // Entrada de 4 bits (datos corregidos o posición de error)
    output logic [6:0] segments        // Salida para el display de 7 segmentos
);

    always_comb begin
        case (data_in)
            4'b0000: segments = 7'b0111111; // 0
            4'b0001: segments = 7'b0000110; // 1
            4'b0010: segments = 7'b1011011; // 2
            4'b0011: segments = 7'b1001111; // 3
            4'b0100: segments = 7'b1100110; // 4
            4'b0101: segments = 7'b1101101; // 5
            4'b0110: segments = 7'b1111101; // 6
            4'b0111: segments = 7'b0000111; // 7
            4'b1000: segments = 7'b1111111; // 8
            4'b1001: segments = 7'b1101111; // 9
            4'b1010: segments = 7'b1110111; // A
            4'b1011: segments = 7'b1111100; // B
            4'b1100: segments = 7'b0111001; // C
            4'b1101: segments = 7'b1011110; // D
            4'b1110: segments = 7'b1111001; // E
            4'b1111: segments = 7'b1110001; // F
            default: segments = 7'b0111111; // Apagar
        endcase
    end
endmodule

*/
