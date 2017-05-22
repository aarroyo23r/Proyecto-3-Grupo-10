`timescale 1ns / 1ps

module TopMaquinas(
    input wire clk,
    output reg [7:0] data,
    output reg [7:0] address,
    input wire inicio,
    input wire escribe,
    input wire crono,
    input wire reset1,
    inout wire [7:0] DATA_ADDRESS,
    output wire [7:0] data_vga,
    output wire ChipSelect,Read,Write,AoD, //Señales de entrada del RTC
    output reg reset
    );
wire [7:0] data_inicio;
wire [7:0] address_inicio;
wire [7:0] address_lectura; 
wire [6:0] contador2;
reg IndicadorMaquina;

wire [7:0] datos0,datos1,datos2, datos3,datos4, datos5,datos6, datos7, datos8,datos9,datos10;

//módulos instanciados-----------------------------------------------------------------------------------------

inicializacion inicio_unit (.clk(clk),.reset(reset),.inicio(inicio),.address(address_inicio),.data_out(data_inicio),.escribe(escribe),.crono(crono));

MaquinaLectura lee_unit (.clk(clk),.reset2(reset),.address(address_lectura),.escribe(escribe),.crono(crono),.inicio(inicio));   

GeneradorFunciones generador_unit (.clk(clk),.IndicadorMaquina(IndicadorMaquina),.ChipSelect1(ChipSelect),.Read1(Read),.Write1(Write),.AoD1(AoD),.contador21(contador2));

Protocolo_rtc rtc_unit(.clk(clk),.address(address),.DATA_WRITE(data),.IndicadorMaquina(IndicadorMaquina),.Read(Read),.Write(Write),.AoD(AoD),
                       .DATA_ADDRESS(DATA_ADDRESS),.data_vga(data_vga),.contador_todo(contador2));

Registros register_unit (.clk(clk),.AoD(AoD),.data_vga(data_vga),.address(address),.datos0(datos0),.datos1(datos1),.datos2(datos2),.datos3(datos3),.datos4(datos4),.datos5(datos5),
                         .datos6(datos6),.datos7(datos7),.datos8(datos8),.datos9(datos9),.datos10(datos10));
                         
//Lógica para evitar reset en momento incorrecto--------------------------------------------------------
always@(posedge clk)begin
    if(reset1 && contador2==7'h4a)begin
    reset<=1;
    end
    else if(!reset1)begin
    reset<=0;
    end
end

//MUX PARA DATOS--------------------------------------------------------------------------------------------
always @*begin
    if(inicio && !escribe && !crono && !reset)begin   
    data=data_inicio;
    end
    else if(reset && !inicio && !escribe && !crono) begin
    data=data_inicio;end
    else begin
    data=8'hZZ;end
end

//MUX PARA DIRECCIONES----------------------------------------------------------------------------------------

always @*begin
    if(inicio && !escribe && !crono && !reset)begin   
    address=address_inicio;
    end
    else if(reset && !inicio && !escribe && !crono) begin
    address=address_inicio;end
    else if(!reset && !inicio && !escribe && !crono)begin
    address=address_lectura;end
    else begin
    address=8'hZZ;end
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
