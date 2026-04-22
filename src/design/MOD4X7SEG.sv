// MODULO 5.2 - Seven Segment Display
// Autor: Andres Obregon Lopez
// Circuito combinacional para el display de 7 segmentos en representacion hexadecimal (0-F)

module top (
    input logic [3:0] sw,           // Bits de entrada: AIN ,BIN ,CIN ,DIN (MSB a LSB)
    output logic [6:0] segments     // Segments: SA, SB, SC, SD, SE, SF, SG (LSB a MSB)
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