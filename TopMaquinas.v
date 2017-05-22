`timescale 1ns / 1ps

module TopMaquinas(
    input wire clk,
    output reg [7:0] data,
    output reg [7:0] address,
    input wire inicio,
    input wire escribe,
    input wire crono,
    input wire reset,
    inout wire [7:0] DATA_ADDRESS,
    output wire [7:0] data_vga,
    output wire ChipSelect,Read,Write,AoD //Señales de entrada del RTC
    );
wire [7:0] data_inicio;
wire [7:0] address_inicio;
wire [7:0] address_lectura; 
wire [6:0] contador, contador2;
reg IndicadorMaquina;

//módulos instaciados

inicializacion inicio_unit (.clk(clk),.reset(reset),.inicio(inicio),.address(address_inicio),.data_out(data_inicio),.escribe(escribe),.crono(crono));
MaquinaLectura lee_unit (.clk(clk),.reset2(reset),.address(address_lectura),.escribe(escribe),.crono(crono),.inicio(inicio));   
GeneradorFunciones generador_unit (.clk(clk),.IndicadorMaquina(IndicadorMaquina),.ChipSelect1(ChipSelect),.Read1(Read),.Write1(Write),.AoD1(AoD),.contador21(contador2));
Protocolo_rtc rtc_unit(.clk(clk),.reset(reset),.address(address),.DATA_WRITE(data),.IndicadorMaquina(IndicadorMaquina),.Read(Read),.Write(Write),.AoD(AoD),
                       .DATA_ADDRESS(DATA_ADDRESS),.data_vga(data_vga),.contador_todo(contador2));

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

//MUX PARA DIRECCIONES

always @*begin
    if(inicio && !escribe && !crono && !reset)begin   
    address=address_inicio;
    end
    else if(reset && !inicio && !escribe && !crono) begin
    address=address_inicio;end
    else if(!reset && !inicio && !escribe && !crono)begin
    address=address_lectura;end
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
 else if (!inicio && !reset && escribe && !crono)begin
 IndicadorMaquina=0;
 end
 else begin
 IndicadorMaquina=1;
 end
end

   
endmodule
