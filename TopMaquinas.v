`timescale 1ns / 1ps

module TopMaquinas(
    input wire clk,
    output reg [7:0] data,
    output wire [7:0] address,
    input wire inicio,
    input wire escribe,
    input wire crono,
    input wire reset,
    output wire ChipSelect,Read,Write,AoD //Señales de entrada del RTC
    );
wire [7:0] data_inicio; 
wire [6:0] contador, contador2;
reg IndicadorMaquina;
   
inicializacion inicio_unit (.clk(clk),.reset(reset),.inicio(inicio),.address(address),.data_out(data_inicio),.escribe(escribe),.crono(crono));
MaquinaLectura lee_unit (.clk(clk),.reset2(reset),.address(address),.escribe(escribe),.crono(crono),.inicio(inicio));   
GeneradorFunciones generador_unit (.clk(clk),.IndicadorMaquina(IndicadorMaquina),.ChipSelect(ChipSelect),.Read(Read),.Write(Write),.AoD(AoD));

//MUX PARA DATOS--------------------------------------------------
always @*begin
    if(inicio && !escribe && !crono && !reset)begin   
    data=data_inicio;
    end
    else if(reset && !inicio && !escribe && !crono) begin
    data=data_inicio;end
    else begin
    data=8'hZZ;end
end

//LOGICA COMBINACIONAL PARA GENERADOR DE FUNCIONES (INDICADORMaquina)--------------------------------------------

always @*begin
 if(inicio && !reset && !escribe && !crono)begin
 IndicadorMaquina=0;
 end
 else if(!inicio && reset && !escribe && !crono)begin
 IndicadorMaquina=0;
 end
 else begin
 IndicadorMaquina=1;
 end
end

   
endmodule
