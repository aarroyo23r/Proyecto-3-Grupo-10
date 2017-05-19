`timescale 1ns / 1ps



module ImpresionDatos
    (
    input wire clk,
    input wire instrucciones,ProgramarCrono,
    input wire [6:0] SegundosU,SegundosD,minutosU,minutosD,horasU,horasD,
    fechaU,mesU,anoU,diaSemanaU, numeroSemanaU,fechaD,mesD,anoD,diaSemanaD,
    numeroSemanaD,
    input wire [6:0] SegundosUT,minutosUT,horasUT,
    input wire [6:0] SegundosDT,minutosDT,horasDT,
    input wire Escribir,//Activa el Cursor
    input wire [7:0] cursor,//Posicion en la que debe de estar el cursor
    input wire [9:0] pixelx, //posición pixel x actual
    input wire [9:0] pixely,//posición pixel y actual

    output wire [18:0] rom_addr,//Direccion en la memoria del dato

    output wire [2:0] color_addro, //Tres bits porque por ahora se van a manejar 15 colores
    output wire dpo,//Dice si va a haber un dato en pantalla
    output wire graficosO//Habilitador de la memoria ram
 );




//Definicion de señáles y constantes

reg dp=1'd0;

reg [2:0] color_addr;

//wire [10:0] rom_addr;
//wire [15:0] rom_addrGraficosO,

//Variables para usar la memoria de Graficos
reg graficos;
reg [5:0] contadorx;
reg [9:0] contadorxcambio;
reg [9:0] contadory;
//reg [9:0] contadorycambio=7'h0;

reg [6:0] char_addr; //  bits mas significativos de dirreción de memoria, del caracter a imprimir
reg [3:0] row_addr; //Cambio entre las filas de la memoria, bits menos significativos de pixel y,bit menos significativos de memoria

reg memInt; //Se puede eliminar

reg numGD=0;
reg numGU=0;
reg numP=0;
reg cuadros=0;
reg sem=0;
reg cron=0;

reg [3:0] zero=0;
reg  [18:0] address;
//assign contadorx=(pixelx[5:0]+5) ;//Los contadores son mayores que el tamaño del numero por lo que hay que tomarlo en
//assign contadory= pixely;//Cuenta a la hora de imprimir


//Parametros para indicar la posicion en pantalla

parameter ancho_NumG=62; //Ancho de los numeros grandes
parameter ancho_NumP=8; //Ancho de los numeros pequeños
parameter anchoCursor=218;//Ancho del cursor

parameter alto_NumG=105; //Alto de los numeros grandes
parameter alto_NumP=12; //Alto de los numeros pequeños


//Parametros de las posiciones del Reloj

//Segundos
localparam IsegundosD=10'd459;//Inicio en el eje x Decenas
localparam IsegundosU=10'd524;//Inicio en el eje x Unidades

localparam ARsegundos=10'd197;////Inicio en el eje y


//Minutos
localparam IminutosD=10'd260;
localparam IminutosU=10'd324;

localparam ARminutos=10'd197;


//horas
localparam IhorasD=10'd58;
localparam IhorasU=10'd123;

localparam ARhoras=10'd197;

//Parametros Cronometro

localparam cronoHoras=10'd104;
localparam cronoMinutos=10'd128;
localparam cronoSegundos=10'd152;

//===========================================

//Numero de Semana
localparam IsemanaD=10'd358;
localparam IsemanaU=10'd366;

localparam ARsemana=10'd14;

//Textos
//Semana
localparam textoSemana=10'd271;


//Cronometro
localparam textoCronometro= 10'd19 ;
localparam ARano=10'd418; //Solo 2 porque siempre van a estar a la par


/*
//Fecha
//Limites en el eje x
localparam IfechaD=10'd576;
localparam DfechaD=10'd583;
localparam IfechaU=10'd585;
localparam DfechaU=10'd591;
//Limites en el eje y
localparam ARfecha=10'd450; //Solo 2 porque siempre van a estar a la par
localparam ABfecha=10'd461;


//Mes
//Limites en el eje x
localparam ImesD=10'd607;
localparam DmesD=10'd614;
localparam ImesU=10'd615;
localparam DmesU=10'd622;
//Limites en el eje y
localparam ARmes=10'd450; //Solo 2 porque siempre van a estar a la par
localparam ABmes=10'd461;


//Año
//Limites en el eje x
localparam IanoD=10'd599;
localparam DanoD=10'd606;
localparam IanoU=10'd607;
localparam DanoU=10'd614;
//Limites en el eje y
localparam ARano=10'd418; //Solo 2 porque siempre van a estar a la par
localparam ABano=10'd428;


//Dia de la semana
//Limites en el eje x
localparam IdiaD=10'd591;
localparam DdiaD=10'd598;
localparam IdiaU=10'd599;
localparam DdiaU=10'd606;
//Limites en el eje y
localparam ARdia=10'd434; //Solo 2 porque siempre van a estar a la par
localparam ABdia=10'd446;







//Cronometro
localparam textoCronometro= 10'd24 ;

//Dia
localparam textoDia=10'd559;

//Instrucciones
localparam textoInstrucciones=10'd24;
localparam ARInstrucciones=10'd96;
localparam ABInstrucciones=10'd112;

//Posicion Instrucciones
localparam posicionInstrucciones=10'd240;
localparam posicionPush1=10'd376;
localparam posicionPush2=10'd512;
*/




//body

//Impresiones
always @(posedge clk)

//Raya Negra
  if (pixely >= 244  && (pixely <= 247)) begin
        dp=1'd1;color_addr=3'd1;graficos<=1'd0;end


   //Segundos
    else if ((pixelx >= IsegundosD) && (pixelx<=IsegundosD+ancho_NumG) && (pixely >= ARsegundos) & (pixely<=ARsegundos+alto_NumG))begin
        char_addr <= SegundosD; //direccion de lo que se va a imprimir
        graficos<=1'd1;
        numGD<=1;
        numGU<=0;
        dp<=1'd1; end

    else if ((pixelx >= IsegundosU) && (pixelx<=IsegundosU+ancho_NumG) && (pixely >= ARsegundos) && (pixely<=ARsegundos+alto_NumG))begin
        char_addr <= SegundosU; //direccion de lo que se va a imprimir
        graficos<=1'd1;
        numGD<=0;
        numGU<=1;
        dp<=1'd1;end
/*
    //Cursor Segundos

    else if ((cursor==8'h21) &&( Escribir) && (pixelx >= IsegundosD) && (pixelx<=IsegundosD+anchoCursor) && (pixely >= ARsegundos+alto_NumG + 10'd4) && (pixely<=ARsegundos+alto_NumG + 10'd6))begin
        color_addr<=4'd2;// Color de lo que se va a imprimir
        graficos<=1'd0;
        dp<=1'd1;end
*/
//Minutos
  else if ((pixelx >= IminutosD) && (pixelx<=IminutosD+ancho_NumG) && (pixely >= ARminutos) && (pixely<=ARminutos+alto_NumG))begin
      char_addr <= minutosD; //direccion de lo que se va a imprimir
      graficos<=1'd1;
      numGD<=1;
      numGU<=0;
      dp<=1'd1;end

  else if ((pixelx >= IminutosU) && (pixelx<=IminutosU+ancho_NumG) && (pixely >= ARminutos) && (pixely<=ARminutos+alto_NumG))begin
      char_addr <= minutosU; //direccion de lo que se va a imprimir
      graficos<=1'd1;
      numGD<=0;
      numGU<=1;
      dp<=1'd1;end
/*
      //Cursor Minutos
      else if ((cursor==8'h22) &&( Escribir) && (pixelx >= IminutosD) && (pixelx<=IminutosD+anchoCursor) && (pixely >= ARminutos+alto_NumG + 10'd4) && (pixely<=ARminutos+alto_NumG+ 10'd6))begin
      color_addr<=4'd2;// Color de lo que se va a imprimir
      graficos<=1'd0;
          dp<=1'd1;end
*/
//Horas
 else if ((pixelx >= IhorasD) && (pixelx<=IhorasD+ancho_NumG) && (pixely >= ARhoras) && (pixely<=ARhoras+alto_NumG))begin
    char_addr <= horasD; //direccion de lo que se va a imprimir
    graficos<=1'd1;
    numGD<=1;
    numGU<=0;
    dp<=1'd1; end



    else if ((pixelx >= IhorasU) && (pixelx<=IhorasU+ancho_NumG) && (pixely >= ARhoras) && (pixely<=ARhoras+alto_NumG))begin
        char_addr <= horasU;//direccion de lo que se va a imprimir
        graficos<=1'd1;
        numGD<=0;
        numGU<=1;
        dp<=1'd1;end

        /*
                //Cursor Horas

             else if ((cursor==8'h23) &&( Escribir) && (pixelx >= IhorasD) && (pixelx<=IhorasD+anchoCursor) && (pixely >= ARhoras+alto_NumG + 10'd4) && (pixely<=ARhoras+alto_NumG+ 10'd6))begin
             color_addr<=4'd2;// Color de lo que se va a imprimir
             graficos<=1'd0;
                dp<=1'd1;end//Tamaño de fuente
                */


//Semana
   else if ((pixelx >= IsemanaU) && (pixelx<=IsemanaU+ancho_NumP) && (pixely >= ARsemana) && (pixely<=ARsemana+alto_NumP))begin
        char_addr <= numeroSemanaU;//direccion de lo que se va a imprimir
        graficos<=1'd1;
        numGD<=0;
        numGU<=0;
        numP=1;
        dp<=1'd1;end

   else if ((pixelx >= IsemanaD) && (pixelx<=IsemanaD+ancho_NumP) && (pixely >= ARsemana) && (pixely<=ARsemana+alto_NumP))begin
        char_addr <= numeroSemanaD;//direccion de lo que se va a imprimir
        graficos<=1'd1;
        numGD<=0;
        numGU<=0;
        numP=1;
        dp<=1'd1;end

/*
//Cursor Semana
    else if ((cursor==8'h28) &&( Escribir) && (pixelx >= IsemanaD) && (pixelx<=DsemanaU) && (pixely >= ABsemana + 10'd2) && (pixely<=ABsemana + 10'd3))begin
        char_addr <= 7'h0a; //direccion de lo que se va a imprimir
        color_addr<=4'd2;// Color de lo que se va a imprimir
        font_size<=1;
        memInt<=1'd1;
        graficos<=1'd0;
        dp<=1'd1;end

*/
//Texto
//Semana
else if ((pixelx >= textoSemana) && (pixelx<=textoSemana+64) && (pixely >= ARsemana) && (pixely<=ARsemana+12))begin
   graficos<=1'd1;
   numGD<=0;
   numGU<=0;
   numP=0;
   cuadros<=0;
   sem<=1;
   dp<=1'd1; end


//Cronometro
else if ((pixelx >= textoCronometro) && (pixelx<=textoCronometro+101) && (pixely >= 439) && (pixely<=453))begin
   graficos<=1'd1;
   numGD<=0;
   numGU<=0;
   cuadros<=0;
   numP=0;
   sem<=0;
   cron<=1;
   dp<=1'd1; end

   else if ((pixelx >= cronoHoras+4) && (pixelx<=cronoHoras+73) && (pixely >= 454) && (pixely<=466))begin
      graficos<=1'd1;
      numGD<=0;
      numGU<=0;
      cuadros<=0;
      numP=0;
      sem<=0;
      cron<=1;
      dp<=1'd1; end


///////////Cronometro
//Horas Crono
 else if ((pixelx >= cronoHoras) && (pixelx<cronoHoras+ancho_NumP) && (pixely >= ARano) & (pixely<=ARano+alto_NumP))begin
     char_addr <= horasDT; //direccion de lo que se va a imprimir
     graficos<=1'd0;
     numP<=1;
     dp<=1'd1; end

 else if ((pixelx >= cronoHoras+ancho_NumP) && (pixelx<cronoHoras+ 2*ancho_NumP) && (pixely >= ARano) && (pixely<=ARano+alto_NumP))begin
     char_addr <= horasUT; //direccion de lo que se va a imprimir
     graficos<=1'd0;
     numP<=1;
     dp<=1'd1;end
/*     //Cursor Horas Crono

     else if ((cursor==8'h43) &&( Escribir|ProgramarCrono) && (pixelx >= cronoHoras) && (pixelx<=cronoHoras+ 2*cambioMozaico) && (pixely >= ABmes + 10'd2) && (pixely<=ABmes+ 10'd3))begin
     char_addr <= 7'h0a; //direccion de lo que se va a imprimir
     color_addr<=4'd2;// Color de lo que se va a imprimir
     font_size<=1;
     memInt<=1'd1;
     graficos<=1'd0;
     dp<=1'd1;end
*/

//Minutos Crono
else if ((pixelx >= cronoMinutos) && (pixelx<cronoMinutos+ancho_NumP) && (pixely >= ARano) && (pixely<=ARano+alto_NumP))begin
   char_addr <= minutosDT; //direccion de lo que se va a imprimir
   graficos<=1'd0;
   numP<=1;
   dp<=1'd1;end

else if ((pixelx >= cronoMinutos+ancho_NumP ) && (pixelx<cronoMinutos+ 2*ancho_NumP) && (pixely >= ARano) && (pixely<=ARano+alto_NumP))begin
   char_addr <= minutosUT; //direccion de lo que se va a imprimir
   graficos<=1'd0;
   numP<=1;
   dp<=1'd1;end

/*
   else if ((cursor==8'h42) && ( Escribir|ProgramarCrono) && (pixelx >= cronoMinutos) && (pixelx<=cronoMinutos+ 2*cambioMozaico) && (pixely >= ABmes + 10'd2) && (pixely<=ABmes+ 10'd3))begin
   char_addr <= 7'h0a; //direccion de lo que se va a imprimir
   color_addr<=4'd2;// Color de lo que se va a imprimir
   font_size<=1;
   memInt<=1'd1;
   graficos<=1'd0;
   dp<=1'd1;end//Tamaño de fuente
*/
//Segundos crono
else if ((pixelx >= cronoSegundos ) && (pixelx<cronoSegundos+ancho_NumP) && (pixely >= ARano) && (pixely<=ARano+alto_NumP))begin
 char_addr <= SegundosDT; //direccion de lo que se va a imprimir
 graficos<=1'd0;
 numP<=1;
 dp<=1'd1; end



 else if ((pixelx >= cronoSegundos+ancho_NumP ) && (pixelx<cronoSegundos+ 2*ancho_NumP) && (pixely >= ARano) && (pixely<=ARano+alto_NumP))begin
     char_addr <= SegundosUT;//direccion de lo que se va a imprimir
     graficos<=1'd0;
     numP<=1;
     dp<=1'd1;end

/*
     else if ((cursor==8'h41) &&( Escribir|ProgramarCrono) && (pixelx >= cronoSegundos) && (pixelx<=cronoSegundos+ 2*cambioMozaico) && (pixely >= ABmes + 10'd2) && (pixely<=ABmes+ 10'd3))begin
     char_addr <= 7'h0a; //direccion de lo que se va a imprimir
     color_addr<=4'd2;// Color de lo que se va a imprimir
     font_size<=1;
     memInt<=1'd1;
     graficos<=1'd0;
     dp<=1'd1;end//Tamaño de fuente
*/


/*


//**************************************************************************************************
//Dia

        else if ((pixelx >= IdiaD) && (pixelx<=DdiaD) && (pixely >= ARdia) && (pixely<=ABdia))begin
            char_addr <= diaSemanaD;//direccion de lo que se va a imprimir
            color_addr<=4'd2;// Color de lo que se va a imprimir
            font_size<=2'd1;
            graficos<=1'd0;
            memInt<=1'd0;
            dp<=1'd1;end//Tamaño de fuente

            else if ((pixelx >= IdiaU) && (pixelx<=DdiaU) && (pixely >= ARdia) && (pixely<=ABdia))begin
                char_addr <= diaSemanaU;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                graficos<=1'd0;
                memInt<=1'd0;
                dp<=1'd1;end//Tamaño de fuente


                //Cursor Dia
                else if ((cursor==8'h27) &&( Escribir) && (pixelx >= IdiaD) && (pixelx<=DdiaU) && (pixely >= ABdia + 10'd2) && (pixely<=ABdia + 10'd3))begin
                char_addr <= 7'h0a; //direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=1;
                memInt<=1'd1;
                graficos<=1'd0;
                   dp<=1'd1;end//Tamaño de fuente



//*****************************************************************************************************




                //Fecha
                        else if ((pixelx >= IfechaD) && (pixelx<=DfechaD) && (pixely >= ARfecha) && (pixely<=ABfecha))begin
                            char_addr <= fechaD;//direccion de lo que se va a imprimir
                            color_addr<=4'd2;// Color de lo que se va a imprimir
                            font_size<=2'd1;
                            graficos<=1'd0;
                            memInt<=1'd0;
                            dp<=1'd1;end//Tamaño de fuente

                            else if ((pixelx >= IfechaU) && (pixelx<=DfechaU) && (pixely >= ARfecha) && (pixely<=ABfecha))begin
                                char_addr <= fechaU;//direccion de lo que se va a imprimir
                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                font_size<=2'd1;
                                graficos<=1'd0;
                                memInt<=1'd0;
                                dp<=1'd1;end//Tamaño de fuente


                                else if ((cursor==8'h24) &&( Escribir) && (pixelx >= IfechaD) && (pixelx<=DfechaU) && (pixely >= ABfecha + 10'd2) && (pixely<=ABfecha+ 10'd3))begin
                                char_addr <= 7'h0a; //direccion de lo que se va a imprimir
                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                font_size<=1;
                                memInt<=1'd1;
                                graficos<=1'd0;
                                   dp<=1'd1;end//Tamaño de fuente



//Año 20

  else if ((pixelx >= 10'd591) && (pixelx<=10'd598) && (pixely >= ARano) && (pixely<=ABano))begin
  char_addr <= 7'h30;//direccion de lo que se va a imprimir
  color_addr<=4'd2;// Color de lo que se va a imprimir
    font_size<=2'd1;
    graficos<=1'd0;
    memInt<=1'd0;
    dp<=1'd1;end//Tamaño de fuente

else if ((pixelx >= 10'd583) && (pixelx<=10'd590) && (pixely >= ARano) && (pixely<=ABano))begin
  char_addr <= 7'h32;//direccion de lo que se va a imprimir
  color_addr<=4'd2;// Color de lo que se va a imprimir
  font_size<=2'd1;
  graficos<=1'd0;
  memInt<=1'd0;
  dp<=1'd1;end//Tamaño de fuente


    //Año
              else if ((pixelx >= IanoD) && (pixelx<=DanoD) && (pixely >= ARano) && (pixely<=ABano))begin
                char_addr <= anoD;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color d de lo que se va a imprimir
                  font_size<=2'd1;
                  graficos<=1'd0;
                  memInt<=1'd0;
                  dp=1'd1;end//Tamaño de fuente

              else if ((pixelx >= IanoU) && (pixelx<=DanoU) && (pixely >= ARano) && (pixely<=ABano))begin
                char_addr <= anoU;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                graficos<=1'd0;
                memInt<=1'd0;
                dp<=1'd1;end//Tamaño de fuente

                //Cursor Año
                else if ((cursor==8'h26) &&( Escribir) && (pixelx >= IanoD) && (pixelx<=DanoU) && (pixely >= ABano + 10'd2) && (pixely<=ABano + 10'd3))begin
                char_addr <= 7'h0a; //direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=1;
                memInt<=1'd1;
                graficos<=1'd0;
                   dp<=1'd1;end//Tamaño de fuente


                //Mes
                          else if ((pixelx >= ImesD) && (pixelx<=DmesD) && (pixely >= ARmes) && (pixely<=ABmes))begin
                            char_addr <=mesD;//direccion de lo que se va a imprimir
                            color_addr<=4'd2;// Color de lo que se va a imprimir
                              font_size<=2'd1;
                              graficos<=1'd0;
                              memInt<=1'd0;
                              dp<=1'd1;end//Tamaño de fuente

                          else if ((pixelx >= ImesU) && (pixelx<=DmesU) && (pixely >= ARmes) && (pixely<=ABmes))begin
                            char_addr <= mesU;//direccion de lo que se va a imprimir
                            color_addr<=4'd2;// Color de lo que se va a imprimir
                            font_size<=2'd1;
                            graficos<=1'd0;
                            memInt<=1'd0;
                            dp<=1'd1;end//Tamaño de fuente


                            //Cursor Mes
                            else if ((cursor==8'h25) &&( Escribir) && (pixelx >= ImesD) && (pixelx<=DmesU) && (pixely >= ABmes + 10'd2) && (pixely<=ABmes + 10'd3))begin
                            char_addr <= 7'h0a; //direccion de lo que se va a imprimir
                            color_addr<=4'd2;// Color de lo que se va a imprimir
                            font_size<=1;
                            memInt<=1'd1;
                            graficos<=1'd0;
                               dp<=1'd1;end//Tamaño de fuente


*/

 else //Fondo de Pamtalla
begin

//Verde
if ((pixely >= 10'd0) && (pixely<=10'd140))begin
color_addr=4'd0;// Color de lo que se va a imprimir
graficos<=1'd0;
dp=1'd1; end

/*
//Negro
else if ((pixely >= 10'd141) && (pixely<=10'd151))begin
color_addr=4'd1;// Color de lo que se va a imprimir
graficos<=1'd0;
dp=1'd1; end*/



//cuadros
//===========================================================================
else if ((pixely >= 10'd141) && (pixely<=10'd348))begin
cuadros<=1;
numGD<=0;
numGU<=0;
numP=0;
sem<=0;
cron<=0;
graficos<=1'd1;
dp=1'd1; end




//-----------------------------------------------------------
//Colores debajo de los cuadros

/*
//Negro++
else if ((pixely >= 10'd339) && (pixely<=10'd348))begin
color_addr<=4'd1;// Color de lo que se va a imprimir
graficos<=1'd0;
dp<=1'd1; end*/


//Verde
else if ((pixely >= 10'd349) && (pixely<=10'd351))begin
color_addr<=4'd0;// Color de lo que se va a imprimir
graficos<=1'd0;
dp<=1'd1; end


//Negro
else if ((pixely >= 10'd352) && (pixely<=10'd353))begin
color_addr<=4'd1;// Color de lo que se va a imprimir
graficos<=1'd0;
dp<=1'd1; end

//Verde
else if ((pixely >= 10'd354) && (pixely<=10'd472))begin
color_addr<=4'd0;// Color de lo que se va a imprimir
graficos<=1'd0;
dp<=1'd1; end


//Linea Blanca ring
else if ((pixely >= 10'd473) && (pixely<= 10'd480))begin
color_addr<=4'd2;// Color de lo que se va a imprimir
graficos<=1'd0;
dp<=1'd1; end


else begin
color_addr<=4'd0;// Color de lo que se va a imprimir
graficos<=1'd0;
numGD<=0;
numGU<=0;
cuadros<=0;
dp<=1'd1; end


end

//Logica impresion de numeros grandes centrada
always @*

if (numGU | numGD)begin


 if (pixelx< 10'd212) begin
contadorx=(pixelx[5:0] + 6'd5);
end

else if (pixelx< 10'd412) begin
contadorx=(pixelx[5:0] - 6'd4);
end

else if (pixelx< 10'd640) begin
contadorx=(pixelx[5:0] - 6'd12);
end

else begin
contadorx=(pixelx[5:0] + 6'd5); //Evitar warning
end

end

else begin
contadorx=pixelx[2:0];
end






always @*

if (numGU) begin
contadory=pixely-192; //Correccion para que pixel y concuerde con los datos de la memoria
case (char_addr)
7'h30:contadorxcambio=0;
7'h31:contadorxcambio=67;
7'h32:contadorxcambio=127;
7'h33:contadorxcambio=192;
7'h34:contadorxcambio=253;
7'h35:contadorxcambio=320;
7'h36:contadorxcambio=383;
7'h37:contadorxcambio=450;
7'h38:contadorxcambio=511;
7'h39:contadorxcambio=576;
default: contadorxcambio = 0;
endcase

address=contadorx+(contadory*640)+contadorxcambio;
end

else if (numGD) begin
contadory=pixely-192; //Correccion para que pixel y concuerde con los datos de la memoria
case (char_addr)
7'h30:contadorxcambio=0;
7'h31:contadorxcambio=67;
7'h32:contadorxcambio=127;
7'h33:contadorxcambio=192;
7'h34:contadorxcambio=253;
7'h35:contadorxcambio=320;
7'h36:contadorxcambio=383;
7'h37:contadorxcambio=450;
7'h38:contadorxcambio=511;
7'h39:contadorxcambio=576;
default: contadorxcambio = 0;
endcase

address=contadorx+(contadory*640)+contadorxcambio;
end


else if (numP) begin

if (pixely>=ARsemana && pixely<=ARsemana+alto_NumP)begin
contadory=pixely+312; //Correccion para que pixel y concuerde con los datos de la memoria
end

case (char_addr)
7'h30:contadorxcambio=1;
7'h31:contadorxcambio=10;
7'h32:contadorxcambio=21;
7'h33:contadorxcambio=31;
7'h34:contadorxcambio=40;
7'h35:contadorxcambio=51;
7'h36:contadorxcambio=60;
7'h37:contadorxcambio=71;
7'h38:contadorxcambio=80;
7'h39:contadorxcambio=90;
default: contadorxcambio = 0;
endcase

address=contadorx+(contadory*640)+contadorxcambio;
end


else if(cuadros) begin
contadory=pixely-29;
address=pixelx+(contadory*640);//Logica para sacar los datos de la memoria
end

//Texto Semana
else if(sem) begin
contadory=pixely+313;
address=pixelx+(contadory*640)+72;//Logica para sacar los datos de la memoria
end

//Texto crono
else if(cron) begin
if (pixelx>104)begin
contadory=pixely-138;
address=pixelx+(contadory*640)+115;//Logica para sacar los datos de la memoria
end
else begin
contadory=pixely-98;
address=pixelx+(contadory*640)+90;//Logica para sacar los datos de la memoria
end
end

else begin
address=0;
end







assign rom_addr = address; //concatena direcciones de registros y filas

assign graficosO=graficos;


//assign rom_addrO=rom_addr;

assign dpo=dp;
assign color_addro=color_addr;


endmodule
