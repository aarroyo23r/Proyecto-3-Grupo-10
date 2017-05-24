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
  output wire sumar,restar //Señáles de control para la suma o resta
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

always @*
if(!read_strobe && port_id==8'h03)begin
in=in_port;
end

else begin
in=0;
end
/*
always @*

//Si la señal de inicio esta activa y aun no se atendio
if (inicio && !interrupt_ack)begin
in=inicioActivo;//Señal de inicio que necesita el picoblaze
interrupcion=inicio;//Activa la señal de interrupcion
end

//Interrupciones del teclado
else begin
in=in_port;
interrupcion=interrupt;
end
*/

//Mux  y registros de salida
always @(posedge clk)
if (write_strobe && port_id==8'h01 )begin
teclaOutPort<=out_port;
EstadoPort<=EstadoPort;
end

else if (write_strobe && port_id==8'h02 )begin
EstadoPort<=out_port;
teclaOutPort<=teclaOutPort;
end

else begin
teclaOutPort<=0;
EstadoPort<=0;
end


//Deco para sumas y restas

always @*
if (teclaOutPort==8'h1d)begin //Tecla W
suma=1;
resta=0;
end
else if (teclaOutPort==8'h1b)begin//Tecla S
suma=0;
resta=1;
end

else begin
suma=0;
resta=0;
end

//Salidas
assign sumar=suma;
assign restar=resta;

endmodule
