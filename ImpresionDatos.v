`timescale 1ns / 1ps



module ImpresionDatos
    (
    input wire clk,ProgramarCrono,
    input wire instrucciones,
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
//reg instrucciones=1;
reg memInt;//Eliminar

reg dp=1'd0;//Indica si hay un dato para imprimir
reg [6:0] char_addr; //  Caracter a imprimir
reg [2:0] color_addr;//Color de la impresion
reg [19:0] address;//Direccion de memoria
//wire [10:0] rom_addr;
//wire [15:0] rom_addrGraficosO,

//Variables para usar la memoria de Graficos
//==============================================================================
reg graficos;//Activa la  memoria de graficos

//Ajustes para direcciones de memoria
reg [5:0] contadorx;
reg [9:0] contadorxcambio;
reg [9:0] contadory;
//reg [9:0] contadorycambio=7'h0;

//Señales de control para la impresion de los datos de la memoria
reg numG=0;
reg numP=0;
reg cuadros=0;
reg sem=0;
reg cron=0;
reg dias=0;
reg anoo20=0;
reg instr=0;


//Parametros para indicar la posicion en pantalla
//==============================================================================
//Ancho de los numeros
parameter ancho_NumG=62;
parameter ancho_NumP=8;
parameter anchoCursor=124;//Ancho del cursor
//Alto de los numeros
parameter alto_NumG=105; //Alto de los numeros grandes
parameter alto_NumP=15; //Alto de los numeros pequeños


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
localparam IhorasD=10'd59;//58
localparam IhorasU=10'd123;

localparam ARhoras=10'd197;

//Dia
localparam IdiaD=10'd448;//511

//Ano
localparam IanoD=488;
localparam IanoU=496;
localparam ARanoo=419;

//Numero de Semana
localparam IsemanaD=10'd360;
localparam IsemanaU=10'd367;

localparam ARsemana=10'd14;

//Fecha
localparam IfechaD=464;
localparam IfechaU=471;
localparam ARfecha=10'd454;

//Mes
localparam ImesD=496;//94
localparam ImesU=503;
//Parametros Cronometro

localparam cronoHoras=10'd127;
localparam cronoMinutos=10'd152;
localparam cronoSegundos=10'd176;

//..............................................................................

//Textos
//Semana
localparam textoSemana=10'd272;

//Cronometro
localparam textoCronometro= 10'd19 ;
localparam ARano=433;




//Cuerpo
//==============================================================================
//==============================================================================
//Impresiones
always @(posedge clk)

//Raya Negra
  if (pixely >= 244  && (pixely <= 247)) begin
        dp=1'd1;color_addr=3'd1;graficos<=1'd0;end


//Segundos
  else if ((pixelx >= IsegundosD) && (pixelx<=IsegundosD+ancho_NumG) && (pixely >= ARsegundos) & (pixely<=ARsegundos+alto_NumG))begin
        char_addr <= SegundosD; //direccion de lo que se va a imprimir
        graficos<=1'd1;
        numG<=1;
        dias<=0;
        anoo20<=0;
        instr<=0;
        dp<=1'd1; end

    else if ((pixelx >= IsegundosU) && (pixelx<=IsegundosU+ancho_NumG) && (pixely >= ARsegundos) && (pixely<=ARsegundos+alto_NumG))begin
        char_addr <= SegundosU; //direccion de lo que se va a imprimir
        graficos<=1'd1;
        numG<=1;
        dias<=0;
        anoo20<=0;
        instr<=0;
        dp<=1'd1;end

    //Cursor Segundos

    else if ((cursor==8'h21) &&( Escribir) && (pixelx >= IsegundosD) && (pixelx<=IsegundosD+anchoCursor) && (pixely >= ARsegundos+alto_NumG + 10'd4) && (pixely<=ARsegundos+alto_NumG + 10'd6))begin
        color_addr<=4'd2;// Color de lo que se va a imprimir
        graficos<=1'd0;
        dp<=1'd1;end

//Minutos
  else if ((pixelx >= IminutosD) && (pixelx<=IminutosD+ancho_NumG) && (pixely >= ARminutos) && (pixely<=ARminutos+alto_NumG))begin
      char_addr <= minutosD; //direccion de lo que se va a imprimir
      graficos<=1'd1;
      numG<=1;
      dias<=0;
      anoo20<=0;
      instr<=0;
      dp<=1'd1;end

  else if ((pixelx >= IminutosU) && (pixelx<=IminutosU+ancho_NumG) && (pixely >= ARminutos) && (pixely<=ARminutos+alto_NumG))begin
      char_addr <= minutosU; //direccion de lo que se va a imprimir
      graficos<=1'd1;
      numG<=1;
      dias<=0;
      anoo20<=0;
      instr<=0;
      dp<=1'd1;end

//Cursor Minutos
   else if ((cursor==8'h22) &&( Escribir) && (pixelx >= IminutosD) && (pixelx<=IminutosD+anchoCursor) && (pixely >= ARminutos+alto_NumG + 10'd4) && (pixely<=ARminutos+alto_NumG+ 10'd6))begin
      color_addr<=4'd2;
      graficos<=1'd0;
      dp<=1'd1;end

//Horas
 else if ((pixelx >= IhorasD) && (pixelx<=IhorasD+ancho_NumG) && (pixely >= ARhoras) && (pixely<=ARhoras+alto_NumG))begin
    char_addr <= horasD; //direccion de lo que se va a imprimir
    graficos<=1'd1;
    numG<=1;
    dias<=0;
    anoo20<=0;
    instr<=0;
    dp<=1'd1; end



    else if ((pixelx >= IhorasU) && (pixelx<=IhorasU+ancho_NumG) && (pixely >= ARhoras) && (pixely<=ARhoras+alto_NumG))begin
        char_addr <= horasU;//direccion de lo que se va a imprimir
        graficos<=1'd1;
        numG<=1;
        dias<=0;
        anoo20<=0;
        instr<=0;
        dp<=1'd1;end


//Cursor Horas

     else if ((cursor==8'h23) &&( Escribir) && (pixelx >= IhorasD) && (pixelx<=IhorasD+anchoCursor) && (pixely >= ARhoras+alto_NumG + 10'd4) && (pixely<=ARhoras+alto_NumG+ 10'd6))begin
        color_addr<=4'd2;// Color de lo que se va a imprimir
        graficos<=1'd0;
        dp<=1'd1;end//Tamaño de fuente



//Semana
   else if ((pixelx >= IsemanaU) && (pixelx<=IsemanaU+ancho_NumP) && (pixely >= ARsemana) && (pixely<=ARsemana+alto_NumP))begin
        char_addr <= numeroSemanaU;//direccion de lo que se va a imprimir
        graficos<=1'd1;
        numG<=0;
        numP=1;
        dias<=0;
        anoo20<=0;
        instr<=0;
        dp<=1'd1;end

   else if ((pixelx >= IsemanaD) && (pixelx<=IsemanaD+ancho_NumP) && (pixely >= ARsemana) && (pixely<=ARsemana+alto_NumP))begin
        char_addr <= numeroSemanaD;//direccion de lo que se va a imprimir
        graficos<=1'd1;
        numG<=0;
        numP=1;
        dias<=0;
        anoo20<=0;
        instr<=0;
        dp<=1'd1;end


//Cursor Semana
     else if ((cursor==8'h28) &&( Escribir) && (pixelx >= IsemanaD) && (pixelx<=IsemanaD+2*ancho_NumP) && (pixely >= ARsemana +alto_NumP+ 10'd2) && (pixely<=ARsemana +alto_NumP+ 10'd3))begin
        color_addr<=4'd2;// Color de lo que se va a imprimir
        graficos<=1'd0;
        dp<=1'd1;end


//Texto
//Semana
else if ((pixelx >= textoSemana) && (pixelx<=textoSemana+63) && (pixely >= ARsemana) && (pixely<=ARsemana+14))begin
   graficos<=1'd1;
   numG<=0;
   numP=0;
   cuadros<=0;
   sem<=1;
   dias<=0;
   anoo20<=0;
   instr<=0;
   dp<=1'd1; end


//Cronometro
else if ((pixelx >= textoCronometro) && (pixelx<=textoCronometro+101) && (pixely >= ARano) && (pixely<=ARano+alto_NumP))begin
   graficos<=1'd1;
   numG<=0;
   cuadros<=0;
   numP=0;
   sem<=0;
   cron<=1;
   dias<=0;
   anoo20<=0;
   instr<=0;
   dp<=1'd1; end

   //Año 20

     else if ((pixelx >= 472) && (pixelx<=486) && (pixely >= ARanoo+1) && (pixely<=ARanoo+alto_NumP+1))begin
     char_addr <= 7'h30;//direccion de lo que se va a imprimir
       graficos<=1;
       numG<=0;
       cuadros<=0;
       numP=0;
       sem<=0;
       cron<=0;
       dias<=0;
       anoo20<=1;
       instr<=0;
       dp<=1'd1;end//Tamaño de fuente


///////////Cronometro
//Horas Crono
 else if ((pixelx >= cronoHoras) && (pixelx<cronoHoras+ancho_NumP) && (pixely >= ARano+3) & (pixely<=ARano+alto_NumP))begin
     char_addr <= horasDT; //direccion de lo que se va a imprimir
     graficos<=1;
     numG<=0;
     cuadros<=0;
     sem<=0;
     numP<=1;
     dias<=0;
     anoo20<=0;
     instr<=0;
     dp<=1'd1; end

 else if ((pixelx >= cronoHoras+ancho_NumP) && (pixelx<cronoHoras+ 2*ancho_NumP) && (pixely >= ARano+3) && (pixely<=ARano+alto_NumP))begin
     char_addr <= horasUT; //direccion de lo que se va a imprimir
     graficos<=1;
     numG<=0;
     cuadros<=0;
     sem<=0;
     numP<=1;
     dias<=0;
     anoo20<=0;
     instr<=0;
     dp<=1'd1;end

     //Cursor Horas Crono

  else if ((cursor==8'h43) &&( ProgramarCrono) && (pixelx >= cronoHoras) && (pixelx<=cronoHoras+ 2*ancho_NumP) && (pixely >= ARano+alto_NumP + 10'd2) && (pixely<=ARano+alto_NumP+ 10'd3))begin
     color_addr<=4'd2;// Color de lo que se va a imprimir
     graficos<=1'd0;
     dp<=1'd1;end


//Minutos Crono
else if ((pixelx >= cronoMinutos) && (pixelx<cronoMinutos+ancho_NumP) && (pixely >= ARano+3) && (pixely<=ARano+alto_NumP))begin
   char_addr <= minutosDT; //direccion de lo que se va a imprimir
   graficos<=1;
   numG<=0;
   cuadros<=0;
   sem<=0;
   numP<=1;
   dias<=0;
   anoo20<=0;
   instr<=0;
   dp<=1'd1;end

else if ((pixelx >= cronoMinutos+ancho_NumP ) && (pixelx<cronoMinutos+ 2*ancho_NumP) && (pixely >= ARano+3) && (pixely<=ARano+alto_NumP))begin
   char_addr <= minutosUT; //direccion de lo que se va a imprimir
   graficos<=1;
   numG<=0;
   cuadros<=0;
   sem<=0;
   numP<=1;
   dias<=0;
   anoo20<=0;
   instr<=0;
   dp<=1'd1;end


else if ((cursor==8'h42) && ( ProgramarCrono) && (pixelx >= cronoMinutos) && (pixelx<=cronoMinutos+ 2*ancho_NumP) && (pixely >= ARano+alto_NumP + 10'd2) && (pixely<=ARano+alto_NumP+ 10'd3))begin
   color_addr<=4'd2;// Color de lo que se va a imprimir
   graficos<=1'd0;
   dp<=1'd1;end//Tamaño de fuente

//Segundos crono
else if ((pixelx >= cronoSegundos ) && (pixelx<cronoSegundos+ancho_NumP) && (pixely >= ARano+3) && (pixely<=ARano+alto_NumP))begin
 char_addr <= SegundosDT; //direccion de lo que se va a imprimir
 graficos<=1;
 numG<=0;
 cuadros<=0;
 sem<=0;
 numP<=1;
 dias<=0;
 anoo20<=0;
 instr<=0;
 dp<=1'd1; end



 else if ((pixelx >= cronoSegundos+ancho_NumP ) && (pixelx<cronoSegundos+ 2*ancho_NumP) && (pixely >= ARano+3) && (pixely<=ARano+alto_NumP))begin
     char_addr <= SegundosUT;//direccion de lo que se va a imprimir
     graficos<=1;
     numG<=0;
     cuadros<=0;
     sem<=0;
     numP<=1;
     dias<=0;
     anoo20<=0;
     instr<=0;
     dp<=1'd1;end


     else if ((cursor==8'h41) &&( ProgramarCrono) && (pixelx >= cronoSegundos) && (pixelx<=cronoSegundos+ 2*ancho_NumP) && (pixely >= ARano+alto_NumP + 10'd2) && (pixely<=ARano+alto_NumP+ 10'd3))begin
     color_addr<=4'd2;// Color de lo que se va a imprimir
     graficos<=1'd0;
     dp<=1'd1;end//Tamaño de fuente






//**************************************************************************************************
//Dia

        else if ((pixelx >= IdiaD) && (pixelx<=IdiaD+64) && (pixely >= ARano) && (pixely<=ARano+alto_NumP))begin //513
            char_addr <= diaSemanaU;
            graficos<=1;
            numG<=0;
            cuadros<=0;
            sem<=0;
            numP<=0;
            cron<=0;
            dias<=1;
            anoo20<=0;
            instr<=0;
            dp<=1'd1;end



//Cursor Dia
      else if ((cursor==8'h27) &&( Escribir) && (pixelx >= IdiaD) && (pixelx<=533) && (pixely >= ARano+alto_NumP + 10'd2) && (pixely<=ARano+alto_NumP + 10'd3))begin
            color_addr<=4'd2;// Color de lo que se va a imprimir
            graficos<=1'd0;
            dp<=1'd1;end



//Año
        else if ((pixelx >= IanoD) && (pixelx<=IanoD+ancho_NumP) && (pixely >= ARanoo) && (pixely<=ARanoo+alto_NumP-3))begin
            char_addr <= anoD;//direccion de lo que se va a imprimir
            graficos<=1;
            numG<=0;
            cuadros<=0;
            sem<=0;
            numP<=1;
            cron<=0;
            dias<=0;
            anoo20<=0;
            instr<=0;
            dp=1'd1;end


        else if ((pixelx >= IanoU) && (pixelx<=IanoU+ancho_NumP) && (pixely >= ARanoo) && (pixely<=ARanoo+alto_NumP-3))begin
            char_addr <= anoU;//direccion de lo que se va a imprimir
            graficos<=1;
            numG<=0;
            cuadros<=0;
            sem<=0;
            numP<=1;
            cron<=0;
            dias<=0;
            anoo20<=0;
            instr<=0;
            dp<=1'd1;end

 //Cursor Año
        else if ((cursor==8'h26) &&( Escribir) && (pixelx >= IanoD) && (pixelx<=IanoD +2*ancho_NumP) && (pixely >= ARanoo+alto_NumP + 10'd2) && (pixely<=ARanoo+alto_NumP + 10'd3))begin
            char_addr <= 7'h0a; //direccion de lo que se va a imprimir
            graficos<=1'd0;
            dp<=1'd1;end




//Fecha
          else if ((pixelx >= IfechaD) && (pixelx<=IfechaD+ancho_NumP) && (pixely >= ARfecha) && (pixely<=ARfecha+alto_NumP-3))begin
              char_addr <= fechaD;//direccion de lo que se va a imprimir
              graficos<=1;
              numG<=0;
              cuadros<=0;
              sem<=0;
              numP<=1;
              cron<=0;
              dias<=0;
              anoo20<=0;
              instr<=0;
              dp<=1'd1;end

          else if ((pixelx >= IfechaU) && (pixelx<=IfechaU+ancho_NumP) && (pixely >= ARfecha) && (pixely<=ARfecha+alto_NumP-3))begin
              char_addr <= fechaU;//direccion de lo que se va a imprimir
              graficos<=1;
              numG<=0;
              cuadros<=0;
              sem<=0;
              numP<=1;
              cron<=0;
              dias<=0;
              anoo20<=0;
              instr<=0;
              dp<=1'd1;end


          else if ((cursor==8'h24) &&( Escribir) && (pixelx >= IfechaD) && (pixelx<=IfechaD+2*ancho_NumP) && (pixely >= ARfecha+alto_NumP + 10'd2) && (pixely<=ARfecha+alto_NumP+ 10'd3))begin
               color_addr<=4'd2;// Color de lo que se va a imprimir
               graficos<=1'd0;
               dp<=1'd1;end//Tamaño de fuente




//Mes
           else if ((pixelx >= ImesD) && (pixelx<=ImesD+ancho_NumP) && (pixely >= ARfecha) && (pixely<=ARfecha+alto_NumP-3))begin
               char_addr <=mesD;//direccion de lo que se va a imprimir
               graficos<=1;
               numG<=0;
               cuadros<=0;
               sem<=0;
               numP<=1;
               cron<=0;
               dias<=0;
               anoo20<=0;
               instr<=0;
               dp<=1'd1;end

           else if ((pixelx >= ImesU) && (pixelx<=ImesU+ancho_NumP) && (pixely >= ARfecha) && (pixely<=ARfecha+alto_NumP-3))begin
               char_addr <= mesU;//direccion de lo que se va a imprimir
               graficos<=1;
               numG<=0;
               cuadros<=0;
               sem<=0;
               numP<=1;
               cron<=0;
               dias<=0;
               anoo20<=0;
               instr<=0;
               dp<=1'd1;end


//Cursor Mes
           else if ((cursor==8'h25) &&( Escribir) && (pixelx >= ImesD) && (pixelx<=ImesD+2*ancho_NumP) && (pixely >= ARfecha+alto_NumP + 10'd2) && (pixely<=ARfecha+alto_NumP + 10'd3))begin
               char_addr <= 7'h0a; //direccion de lo que se va a imprimir
               graficos<=1'd0;
               dp<=1'd1;end



//Fondo de Pantalla
//==============================================================================
 else
begin



//Instrucciones
//..............................................................................

if ((instrucciones) && (pixely >=50) && (pixely<=125) && (50<pixelx) && (pixelx<575) )begin
cuadros<=0;
numG<=0;
numP=0;
sem<=0;
cron<=0;
dias<=0;
anoo20<=0;
graficos<=1'd1;
instr<=1;
dp=1'd1; end

//Tecla para acticar las instrucciones
else if ((pixely >= 423) && (pixely<=466) && (pixelx>559))begin
cuadros<=0;
numG<=0;
numP=0;
sem<=0;
dias<=0;
cron<=0;
anoo20<=0;
graficos<=1'd1;
instr<=1;
dp=1'd1; end

//Verde
else if ((pixely >= 10'd0) && (pixely<=10'd140))begin
color_addr=4'd0;// Color de lo que se va a imprimir
graficos<=1'd0;
dp=1'd1; end


//cuadros
//..............................................................................

else if ((pixely >= 10'd141) && (pixely<=157))begin
cuadros<=1;
numG<=0;
numP=0;
sem<=0;
cron<=0;
anoo20<=0;
graficos<=1'd1;
instr<=0;
dp=1'd1; end

//Parte constante
else if ((pixelx <=28) && (pixely >= 158) && (pixely <= 264))begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=29) && (pixely >= 158)  && (pixely <= 264)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=212) && (pixely >= 158)  && (pixely <= 264)) begin
dp=1'd1;color_addr=3'd3;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=213) && (pixely >= 158)  && (pixely <= 264)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=228) && (pixely >= 158)  && (pixely <= 264)) begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=229) && (pixely >= 158)  && (pixely <= 264)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=412) && (pixely >= 158 ) && (pixely <= 264)) begin
dp=1'd1;color_addr=3'd3;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=413) && (pixely >= 158)  && (pixely <= 264)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=428) && (pixely >= 158)  && (pixely <= 264)) begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=429) && (pixely >= 158)  && (pixely <= 264)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=612) && (pixely >= 158)  && (pixely <= 264)) begin
dp=1'd1;color_addr=3'd3;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=613) && (pixely >= 158)  && (pixely <= 264)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=800) && (pixely >= 158)  && (pixely <= 264)) begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end


else if ((pixely >=265) && (pixely<=10'd348))begin
cuadros<=1;
numG<=0;
numP=0;
sem<=0;
cron<=0;
anoo20<=0;
graficos<=1'd1;
instr<=0;
dp=1'd1; end

//-----------------------------------------------------------
//Colores debajo de los cuadros


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
color_addr<=4'd0;
graficos<=1'd0;
numG<=0;
cuadros<=0;
numP<=0;
dp<=1'd0; end


end

//Logica para centrar los numeros grandes
//==============================================================================
always @*


if (dias) begin
contadorx=pixelx[5:0];
end

else if (numG)begin

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

//Logica de direcciones de memoria
//==============================================================================
always @*

//Numeros Grandes
if (numG) begin
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

//Numeros Pequeños
else if (numP) begin

if (pixely>=ARsemana && pixely<=ARsemana+alto_NumP)begin
contadory=pixely+312; //Correccion para que pixel y concuerde con los datos de la memoria
end

else if (pixely>=436 && pixely<=453)begin
contadory=pixely-109; //Correccion para que pixel y concuerde con los datos de la memoria
end

else if (pixely>=419 && pixely<=431) begin
contadory=pixely-93; //año
  end

else if (pixely>=454 && pixely<=466) begin
contadory=pixely-128; //fecha y mes
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

//Dias de la semana
else if (dias) begin
contadory=pixely-88; //Correccion para que pixel y concuerde con los datos de la memoria
case (char_addr)
7'h30:contadorxcambio=0;
7'h31:contadorxcambio=81;
7'h32:contadorxcambio=170;
7'h33:contadorxcambio=279;
7'h34:contadorxcambio=365;
7'h35:contadorxcambio=458;
7'h36:contadorxcambio=554;
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
contadory=pixely-109;//111
address=pixelx+(contadory*640)+90;//Logica para sacar los datos de la memoria
end

//Instrucciones
else if(instr) begin
if (pixely >= 423) begin
contadory=pixely-254;//111
address=pixelx+(contadory*640)+15;//Logica para sacar los datos de la memoria
end
else begin
contadory=pixely+108;//108
address=pixelx+(contadory*640-50);//Logica para sacar los datos de la memoria
end
end
//20 del Año
else if(anoo20) begin
contadory=pixely-93;
address=pixelx+(contadory*640)-44;//Logica para sacar los datos de la memoria
end


else begin
address=0;
end


assign rom_addr = address;
assign graficosO=graficos;
assign dpo=dp;
assign color_addro=color_addr;


endmodule
