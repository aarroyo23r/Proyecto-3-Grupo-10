`timescale 1ns / 1ps

module TopMaquinas(
    input wire clk,
    output reg [7:0] data,
    output reg [7:0] address,
    input wire escribe1,crono,reset1,cr_activo,
    input wire push_arriba,push_abajo,push_izquierda,push_derecha,
    inout wire [7:0] DATA_ADDRESS,
    output wire [7:0]data_mod,
    output wire [7:0] data_vga,
    output wire inicio1,
    output wire ChipSelect,Read,Write,AoD //Señales de entrada del RTC
    );
localparam [12:0] limit =16'd1034;    
wire [7:0] data_inicio;
wire [7:0] address_inicio;
wire [7:0] address_lectura,address_escritura; 
wire [6:0] contador2;
reg IndicadorMaquina;
reg reset,escribe;
reg inicio=1;
reg [12:0]contador_inicio=0;
reg [12:0]contador_reset=0;

wire[7:0] datos0,datos1,datos2, datos3,datos4, datos5,datos6, datos7,datos8,datos9,datos10; //datos a controlador_vga durante lectura

 wire [7:0]segundosSal, minutosSal,horasSal,dateSal,num_semanaSal,mesSal,anoSal,dia_semSal; //datos a controlador_vga durante la escritura
 wire [7:0]segundos_crSal,minutos_crSal,horas_crSal;

assign inicio1=inicio;

//módulos instanciados-----------------------------------------------------------------------------------------

inicializacion inicio_unit (.clk(clk),.reset(reset),.inicio(inicio),.address(address_inicio),.data_out(data_inicio),.escribe(escribe),.crono(crono));

MaquinaLectura lee_unit (.clk(clk),.reset2(reset),.address(address_lectura),.escribe(escribe),.crono(crono),.inicio(inicio));   

GeneradorFunciones generador_unit (.clk(clk),.IndicadorMaquina(IndicadorMaquina),.ChipSelect1(ChipSelect),.Read1(Read),.Write1(Write),.AoD1(AoD),.contador21(contador2));

Protocolo_rtc rtc_unit(.clk(clk),.address(address),.DATA_WRITE(data),.IndicadorMaquina(IndicadorMaquina),.Read(Read),.Write(Write),.AoD(AoD),
                       .DATA_ADDRESS(DATA_ADDRESS),.data_vga(data_vga),.contador_todo(contador2));

MaquinaEscritura Escritura_unit(.clk(clk),.inicio(inicio),.reset(reset),.crono(crono),.escribe(escribe),.suma(push_arriba),.resta(push_abajo),.data_mod(data_mod),
                                .izquierda(push_izquierda),.derecha(push_derecha),.address(address_escritura),.segundos(datos0),.minutos(datos1),.horas(datos2),.date(datos3),.num_semana(datos4),.mes(datos5),
                                .ano(datos6),.dia_sem(datos7),.IndicadorMaquina(IndicadorMaquina),.segundos_cr(datos8),.minutos_cr(datos9),.horas_cr(datos10),.cr_activo(cr_activo),.segundosSal(segundosSal),.minutosSal(minutosSal),
                                .horasSal(horasSal),.dateSal(dateSal),.num_semanaSal(num_semanaSal),.mesSal(mesSal),.anoSal(anoSal),.dia_semSal(dia_semSal),
                                .segundos_crSal(segundos_crSal),.minutos_crSal(minutos_crSal),.horas_crSal(horas_crSal));

Registros Reg_unit(.clk(clk),.AoD(AoD),.data_vga(data_vga),.address(address),.data_0(datos0),.data_1(datos1),.data_2(datos2),.data_3(datos3),.data_4(datos4),
                                .data_5(datos5),.data_6(datos6),.data_7(datos7),.data_8(datos8),.data_9(datos9),.data_10(datos10));

//Lógica para evitar escritura en momento incorrecto----------------------------------------------------------
always@(posedge clk)begin
    if(escribe1 && contador2==7'h4a)begin
    escribe<=1;
    end
    else if(!escribe1 && contador2==7'h4a)begin
    escribe=0;
    end
    else begin
    escribe<=escribe;
    end
end

//Lógica para evitar reset en momento incorrecto--------------------------------------------------------------
always@(posedge clk)begin
    if(reset1 && contador2==7'h4a)begin
    reset<=1;
    end
    else if(!reset1 && address==8'h02)begin
    reset<=0;
    end
    else begin
    reset<=reset;
    end
end



//MUX PARA DATOS a Programar--------------------------------------------------------------------------------------------
always @*begin
    if(inicio && !escribe && !crono && !reset && !cr_activo)begin   
    data=data_inicio;end
    else if(reset && !inicio && !escribe && !crono && !cr_activo) begin
    data=data_inicio;end
    else if(!reset && !inicio && escribe && !crono && !cr_activo)begin
    data=data_mod;end
    else if(!reset && !inicio && !escribe && crono && !cr_activo)begin
    data=data_mod;end
    else if(!reset && !inicio && !escribe && !crono && cr_activo)begin
    data=data_mod;
    end
    else begin
    data=8'hZZ;end
end

//MUX PARA DIRECCIONES----------------------------------------------------------------------------------------

always @*begin
    if(inicio && !escribe && !crono && !reset && !cr_activo)begin   
    address=address_inicio;
    end
    else if(reset && !inicio && !escribe && !crono && !cr_activo) begin
    address=address_inicio;end
    else if(!reset && !inicio && !escribe && !crono && !cr_activo)begin
    address=address_lectura;end
    else if(!reset && !inicio && escribe && !crono && !cr_activo)begin
    address=address_escritura;end
    else  if(!reset && !inicio && !escribe && crono && !cr_activo)begin
    address=address_escritura;end
    else  if(!reset && !inicio && !escribe &&!crono && cr_activo) begin
    address=address_escritura;end
    else begin
    address=8'hZZ;end
end

//LOGICA DE REG INICIO PARA INICIALIZACIÓN
always@(posedge clk)begin
   if((inicio) && contador_inicio<=limit)begin
        contador_inicio<=contador_inicio +1;
   end
   else if(inicio && contador_inicio==limit)begin
        inicio<=0;
   end
   else begin
   inicio<=0;end
      
   end

//LOGICA COMBINACIONAL PARA GENERADOR DE FUNCIONES (INDICADORMaquina)--------------------------------------------

always @*begin
 if(inicio && !reset && !escribe && !crono && !cr_activo)begin
 IndicadorMaquina=0;
 end
 else if(!inicio && reset && !escribe && !crono && !cr_activo)begin
 IndicadorMaquina=0;
 end
 else if (!inicio && !reset && escribe && !crono && !cr_activo)begin
 IndicadorMaquina=0;
 end
 else if(!inicio && !reset && !escribe && crono && !cr_activo)begin
 IndicadorMaquina=0;
 end
 else if(!inicio && !reset && !escribe && !crono && cr_activo)begin
 IndicadorMaquina=0;
 end
 else begin
 IndicadorMaquina=1;
 end
end

   
endmodule
