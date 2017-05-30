`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/15/2017 10:27:52 AM
// Design Name:
// Module Name: PicoBlaze
// Project Name:
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


module PicoBlaze(
  input  wire clk,reset,inicio,
  input	 wire[7:0]	in_port,//Entrada
  input		wire	interrupt,//Señal de interrupcion

  output wire	interrupt_ack,//Indica que ya se atendio la interrupcion
  output reg [7:0]EstadoPort,//Señales de salida maquina de estados general
  output wire instrucciones,//Activa y desactiva las instrucciones
  output wire resetO,//Salida del reset
  output wire sumar,restar, //Señáles de control para la suma o resta
  output wire izquierda,derecha //Señales de control para moverse entre los registros
    );

    //inicializacion
    reg [7:0] inicioActivo=8'h02;
    reg interrupcion;
    //Señales del picoblaze
    reg [7:0] teclaOutPort;
    reg [7:0] in;
    wire [11:0]	address ;//Direccion de PC
    wire	[17:0]  instruction;//Instruccion a ejecutar
    reg sleep=0 ;//Modo suspencion picoblaze
    reg data_in=0;

    wire[7:0]	port_id;//Codigo del puerto a leer o escribir
    wire[7:0]	out_port;//Puerto de salida

    wire	write_strobe;//Valida que el dato se escribio en el puerto de salida
    wire	k_write_strobe;
    wire	read_strobe;//Valida que el dato en el puerto de entrada se leyo


    wire	bram_enable;

    //Señales para suma y resta
    reg suma,resta;

    //Señales para moverse entre registros
    reg izquierdaReg,derechaReg;

   //Intrucciones
    reg instruc;
    //Salida del reset
    reg resetOut;
    reg [10:0] contador=0;
    reg duracionReset=0;
/*
    //Alternar entre lectura y ProgramarCrono
    reg alterna;
    reg [7:0] PrEstado;
    reg [6:0] contador2=0;
    reg ProgCron=0;*/

//Memoria de Instrucciones

MemoriaDeInstrucciones MemoriaDeInstrucciones_unit (
           .address(address),.clk(clk),
           .instruction(instruction),.enable(bram_enable)
          );

//PicoBlaze
 kcpsm6 kcpsm6_unit(
    .address(address),.instruction(instruction),.bram_enable(bram_enable),.in_port(in_port)
    ,.out_port(out_port),.port_id(port_id),.write_strobe(write_strobe),.k_write_strobe(k_write_strobe)
    ,.read_strobe(read_strobe),.interrupt(interrupt),.interrupt_ack(interrupt_ack),.sleep(sleep)
    ,.reset(reset),.clk(clk)
    );


//Mux entrada e interrupciones
/*
always @*

//Si la señal de inicio esta activa y aun no se atendio
if (inicio && !interrupt_ack)begin
in=inicioActivo;//Señal de inicio que necesita el picoblaze
interrupcion=inicio;//Activa la señal de interrupcion
end

else begin
in=in_port;
interrupcion=interrupt;
end*/


//Mux  y registros de salida
//==============================================================================
always @(posedge clk)

/*if (ProgCron) begin//Si se activa el estado Programar Cronometro
teclaOutPort<=teclaOutPort; //No se modifica teclaOutPort
EstadoPort<=PrEstado; //EstadoPort se le asigna los estados alternados de programar cronometro y lectura
end*/

if (write_strobe && port_id==8'h01 )begin
teclaOutPort<=out_port;
EstadoPort<=EstadoPort;
end

else if (write_strobe && port_id==8'h02 )begin

EstadoPort<=out_port;
teclaOutPort<=teclaOutPort;
end

//Asignacion normal de las salidas
else begin
teclaOutPort<=0;
EstadoPort<=EstadoPort;
end






//Deco para sumas y restas
//==============================================================================
always @(posedge clk)
if (teclaOutPort==8'h57)begin //Tecla W
suma<=1;
resta<=0;
end
else if (teclaOutPort==8'h53)begin//Tecla S
suma<=0;
resta<=1;
end

else begin
suma<=0;
resta<=0;
end

//Deco Izquierda derecha
//==============================================================================
always @(posedge clk)
if (teclaOutPort==8'h41)begin //Tecla A
izquierdaReg<=1;
derechaReg<=0;

end
else if (teclaOutPort==8'h44)begin//Tecla D
izquierdaReg<=0;
derechaReg<=1;
end


else begin
izquierdaReg<=0;
derechaReg<=0;
end

//Reset
//==============================================================================
always @(posedge clk)  //Activa el contador para la duracion de la señal
if (teclaOutPort==8'h08)begin//Tecla r
duracionReset<=~duracionReset;
end
else if (contador==1043)begin
duracionReset<=0;
end
else begin
duracionReset<=duracionReset;
end

always @(posedge clk) //Duracion del reset
if (duracionReset && contador<1044) begin
contador<=contador+1;
resetOut<=1;
end

else begin
contador<=0;
resetOut<=0;
end

//Activar o desactivar instrucciones
//==============================================================================
always @(posedge clk)
if (teclaOutPort==8'h49)begin//Tecla I
instruc<=~instruc;
end

else begin
instruc<=instruc;end
/*
//Duracion de cada estado de ProgramarCrono
//==============================================================================
always @(posedge clk)
if (in_port==8'h50) begin
ProgCron<=1;    //Control del cambio de estado

if (contador2<73)begin //Duracion 740ns para cada estado
  alterna<=alterna;
 contador2<=contador2+1;
  if (alterna) begin
    PrEstado<=8'h02; //ProgramarCrono
    end

 else begin
    PrEstado<=8'h00;//Lectura
    end

end

else begin
  alterna<=~alterna; //Cambio de estado
  contador2<=0;       //Reinicio Contador
  PrEstado<=PrEstado;
  end
end

else begin
ProgCron<=0;    //Control del cambio de estado
contador2<=0;    //Limpia el contador
end*/

//==============================================================================
//Salidas
assign sumar=suma;
assign restar=resta;
assign izquierda=izquierdaReg;
assign derecha=derechaReg;
assign instrucciones=instruc;
assign resetO=resetOut;
endmodule
