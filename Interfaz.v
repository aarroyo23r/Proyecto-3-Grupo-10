`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:Andrés Arroyo Romero
//
// Create Date: 03/24/2017 11:48:12 PM
// Design Name:
// Module Name: Interfaz
// Project Name:RTC
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module Interfaz(
    input wire clk,reset,resetSync,
    input wire instrucciones,ProgramarCrono,ring,//Señales de control
    input wire [7:0] cursor,//Direccion del cursor
    input wire Escribir,//Control escritura
    output wire  [11:0] rgbO,//Salida de color
    output wire hsync,vsync,//Sincronizacion de la VGA
    output wire video_on,
    //Datos  de entrada
    input wire [7:0] datos0,datos1,datos2,datos3,datos4,datos5,datos6,datos7,datos8,
    datos9,datos10

    //output wire [9:0] pixelx, pixely
    //output reg [3:0] contGuardados
    );





//_____________________________________________________________________
//Declaracion de señales
//_____________________________________________________________________

//SincronizadorVGA
wire [9:0] pixelx, pixely;
//wire video_on;
/*
    wire [7:0] cursor=00;

    wire [7:0] datos0=06;
    wire [7:0]datos1=07;
    wire [7:0]datos2=23;
    wire [7:0]datos3=03;
    wire [7:0]datos4=05;
    wire [7:0]datos5=04;
    wire [7:0]datos6=00;
    wire [7:0]datos7=01;
    wire [7:0]datos8=08;
   wire [7:0] datos9=03;
   wire [7:0]datos10=02;
*/
//Tick antes de refrescar la pantalla
reg tick;//Tick para guardar datos mientras se refresca la pantalla, para que al volver a imprimir los datos esten listos para ser leidos
//reg tick=1;



//Datos de entrada
//Reloj
reg [6:0] SegundosU, minutosU,horasU, fechaU,mesU,anoU,diaSemanaU, numeroSemanaU;
reg [6:0] SegundosD,minutosD,horasD,fechaD,mesD,anoD,diaSemanaD,numeroSemanaD;
//Temporizador
reg [6:0] SegundosUT,minutosUT,horasUT;
reg [6:0] SegundosDT,minutosDT,horasDT;


//Memoria
wire [11:0] datoMemoria;   //Salida memoria
wire [18:0] address;      //Direccion memoria
wire graficos;            //Enable de la memoria ram
wire [11:0] data_in=0;      //Entrada memoria

wire dp;//Señal de control para saber si se debe de imprimir algo


//Mux color
wire [2:0] color_addr;    //Direccion del color
reg [11:0] color;
reg [11:0] colorMux;


//Ring
reg [11:0] colorAlarma=12'hf00;


//Cursor ***************


//Salida VGA***********
reg [11:0] rgb;


//*******************************************************************************************
//_____________________________________________________________________
//Cuerpo
//_____________________________________________________________________

//Tick antes de refrescar la pantalla
always @(posedge clk)//Se activa la señal tick cuando la pantalla comienza a refrescarse

if (pixely>=10'd480) //finalizoContar desactiva la señal cuando ya se guardaron todos los datos
begin
  tick=1;
end
else
begin
  tick=0;
end




//Guarda los datos decodificados en registros intermedios
always @(posedge clk, posedge reset)
//reloj
if (reset)begin //Reset
SegundosU <= 7'h00;
SegundosD<= 7'h00;
minutosU <= 7'h00;
minutosD <= 7'h00;
horasU <= 7'h00;
horasD <= 7'h00;
fechaU <= 7'h00;
fechaD <= 7'h00;
mesU <= 7'h00;
mesD <= 7'h00;
anoU <= 7'h00;
anoD <= 7'h00;
diaSemanaU <= 7'h00;
diaSemanaD <= 7'h00;
numeroSemanaU <= 7'h00;
numeroSemanaD <= 7'h00;
SegundosUT <= 7'h00;
SegundosDT <= 7'h00;
minutosUT <= 7'h00;
minutosDT <= 7'h00;
horasUT <= 7'h00;
horasDT <= 7'h00;

end

else begin

if (tick)begin //Guarda los datos en BCD
SegundosU <= {4'h3,datos0[3:0]};
SegundosD <= {4'h3,datos0[7:4]};

minutosU <= {4'h3,datos1[3:0]};
minutosD <= {4'h3,datos1[7:4]};

horasU <= {4'h3,datos2[3:0]};
horasD <= {4'h3,datos2[7:4]};

fechaU <= {4'h3,datos3[3:0]};
fechaD <= {4'h3,datos3[7:4]};

mesU <= {4'h3,datos4[3:0]};
mesD <= {4'h3,datos4[7:4]};

anoU <= {4'h3,datos5[3:0]};
anoD <= {4'h3,datos5[7:4]};

diaSemanaU <= {4'h3,datos6[3:0]};
diaSemanaD <= {4'h3,datos6[7:4]};

numeroSemanaU <= {4'h3,datos7[3:0]};
numeroSemanaD <= {4'h3,datos7[7:4]};

//Temporizador
SegundosUT <= {4'h3,datos8[3:0]};
SegundosDT <= {4'h3,datos8[7:4]};

minutosUT <= {4'h3,datos9[3:0]};
minutosDT <= {4'h3,datos9[7:4]};

horasUT <= {4'h3,datos10[3:0]};
horasDT <= {4'h3,datos10[7:4]};

end

else begin //Mantiene los datos igual
SegundosU <= SegundosU;
SegundosD <= SegundosD;
minutosU <= minutosU;
minutosD <= minutosD;
horasU <= horasU;
horasD <= horasD;
fechaU <= fechaU;
fechaD <= fechaD;
mesU <= mesU;
mesD <= mesD;
anoU <= anoU;
anoD <= anoD;
diaSemanaU <= diaSemanaU;
diaSemanaD <= diaSemanaD;
numeroSemanaU <= numeroSemanaU;
numeroSemanaD <= numeroSemanaD;
SegundosUT <= SegundosUT;
SegundosDT <= SegundosDT;
minutosUT <= minutosUT;
minutosDT <= minutosDT;
horasUT <= horasUT;
horasDT <= horasDT;
end

end




//____________________________________________________________________________________________________
//Instanciaciones
//____________________________________________________________________________________________________


ImpresionDatos ImpresionDatos_unit
    (
    .clk(clk),.pixelx(pixelx),.pixely(pixely),.rom_addr(address),
    .color_addro(color_addr),
    .SegundosU(SegundosU),.SegundosD(SegundosD),.minutosU(minutosU)
    ,.minutosD(minutosD),.horasU(horasU),.horasD(horasD),.dpo(dp)
    ,.fechaU(fechaU),.mesU(mesU),.anoU(anoU),.diaSemanaU(diaSemanaU),
     .numeroSemanaU(numeroSemanaU),.fechaD(fechaD),.mesD(mesD),.anoD(anoD),.diaSemanaD(diaSemanaD),
     .numeroSemanaD(numeroSemanaD),.graficosO(graficos),
     .SegundosUT(SegundosUT),.minutosUT(minutosUT),.horasUT(horasUT),
     .SegundosDT(SegundosDT),.minutosDT(minutosDT),.horasDT(horasDT),.cursor(cursor)
     ,.Escribir(Escribir),.ProgramarCrono(ProgramarCrono)
    );


     SincronizadorVGA SincronizadorVGA_unit(
               .clk(clk),.reset(resetSync),
               .hsync(hsync),.vsync(vsync),.video_on(video_on),
               .pixelx(pixelx),.pixely(pixely)
               );


     RAM RAM_unit (
                .address(address),.data_in(data_in),.clk(clk),
                .enable(graficos),.reset(reset),.data_out(datoMemoria)
               );






//Rom colores
//Almacena las combinaciones de colores posibles

always @*

case (color_addr) // combinación de colores seleccionados de acuerdo al switch, solo se puede seleccionar un siwtch a la vez
//         r      g    b
//color = 0000  0000  0000

3'd0: color = 12'h032;//Verde
3'd1:  color = 12'h000;//Negro
3'd2: color = 12'hFFE;//Blanco
3'd3: color = 12'h111;
3'd4: color = 12'h222;
3'd5: color = 12'h333;
3'd6: color = 12'h032;
3'd7: color = 12'h120;
default: color = 12'h111;

endcase

//Mux Salida color

always @*


if (graficos)begin
colorMux=datoMemoria;
end

else if (ring  && (pixely >= 10'd473) && (pixely<= 10'd480) ) begin
colorMux= colorAlarma; end //Cambio de color

else begin
colorMux=color;
end

//Salida VGA

always @(posedge clk) //operación se realiza con cada pulso de reloj
    if (video_on && dp)  //se encienden los LEDs solo si el bit se encuentra en 1 en memoria
        rgb<=colorMux;

 else
    rgb <= 12'h032;


assign rgbO=rgb;

endmodule
