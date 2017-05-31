
`timescale 1ns / 1ps

module TOP(
    input wire clk,
    input wire ps2d,
    input wire ps2c,
    input wire MasterReset,//Reset para el picoblaze
    inout wire [7:0] DATA_ADDRESS,
    output wire ChipSelect,Read,Write,AoD,//Señales de entrada del RTC
    output wire [11:0] rgbO,//Salida RGB
    output wire hsync,vsync
    );
wire DoRead;
wire interrupt;
wire [7:0] EstadoPort;
wire escribe1,crono1,cr_activo;
wire sumar,restar;

wire inicio1;
wire instrucciones;
wire izquierda,derecha;


wire [7:0] ascii_code;

wire [7:0]address,data;



wire ring;

//Registro ascii
reg [7:0] ascii_reg;

//Datos de las Maquinas de estados

wire[7:0] datos0,datos1,datos2, datos3,datos4, datos5,datos6, datos7,datos8,datos9,datos10;
wire [7:0]segundosSal, minutosSal,horasSal,dateSal,num_semanaSal,mesSal,anoSal,dia_semSal //datos a controlador_vga durante la escritura
,segundos_crSal,minutos_crSal,horas_crSal;

wire escribeC,cronoC,cr_activoC;//Señales que controlan las maquinas de estados sincronizadas

//Señales PicoBlaze
//==============================================================================
reg inicio=0;
wire reset1;//Reset General

//Señales Interfaz
//==============================================================================
wire video_on;
//reloj
reg [7:0] Segundos,minutos,horas,fecha,mes,ano,diaSemana,numeroSemana,SegundosT,minutosT
,horasT;



assign escribe1 = EstadoPort[0];
assign crono = EstadoPort[1];
assign cr_activo = EstadoPort[2];


PicoBlaze Picoblaze_unit(.clk(clk),.reset(MasterReset),.inicio(inicio),.in_port(ascii_reg),.interrupt(interrupt),.interrupt_ack(DoRead),.EstadoPort(EstadoPort),.sumar(sumar),.restar(restar),
                         .izquierda(izquierda),.derecha(derecha),.resetO(reset1),.instrucciones(instrucciones)
                         );

TopTeclado teclado_unit(.clk(clk), .ps2d(ps2d),.ps2c(ps2c),.Reset(reset1),.ascii_code(ascii_code),.DoRead(DoRead),.interrupt(interrupt));

TopMaquinas Maquinas_unit(.clk(clk),.data(data),.address(address),.escribe1(escribe1),.crono1(crono1),.reset1(reset1),.cr_activo1(cr_activo),.push_arriba(sumar),.push_abajo(restar),
                          .push_izquierda(izquierda),.push_derecha(derecha),.DATA_ADDRESS(DATA_ADDRESS),.data_mod(),.data_vga(),.inicio1(inicio1),.ChipSelect(ChipSelect),.Read(Read),
                          .Write(Write),.AoD(AoD),.ring(ring)
                          ,.datos0(datos0),.datos1(datos1),.datos2(datos2),.datos3(datos3),.datos4(datos4),.datos5(datos5)
                          ,.datos6(datos6),.datos7(datos7),.datos8(datos8),.datos9(datos9),.datos10(datos10)

                          ,.segundosSal(segundosSal),.minutosSal(minutosSal),.horasSal(horasSal),.dateSal(dateSal),.num_semanaSal(num_semanaSal)
                          ,.mesSal(mesSal),.anoSal(anoSal),.dia_semSal(dia_semSal)

                          ,.escribe(escribeC),.crono(cronoC),.cr_activo(cr_activoC)
                          );

Interfaz Interfaz_unit(.clk(clk),.reset(reset1),.resetSync(reset1),.instrucciones(instrucciones)
                       ,.ProgramarCrono(cronoC),.ring(ring),.cursor(address),.rgbO(rgbO)
                       ,.hsync(hsync),.vsync(vsync),.video_on(video_on),.Escribir(escribeC)
                       ,.datos0(Segundos),.datos1(minutos),.datos2(horas),.datos3(fecha),.datos4(mes),.datos5(ano)
                       ,.datos6(diaSemana),.datos7(numeroSemana),.datos8(SegundosT),.datos9(minutosT),.datos10(horasT)
                       );


//Logica para los datos que recibe la Interfaz
//==============================================================================

always @*

if (escribeC) begin
Segundos=segundosSal;
minutos=minutosSal;
horas=horasSal;
fecha=dateSal;
mes=num_semanaSal;
ano=mesSal;
diaSemana=anoSal;
numeroSemana=dia_semSal;
SegundosT=0;
minutosT=0;
horasT=0;
end

else if (cronoC) begin
Segundos=datos0;
minutos=datos1;
horas=datos2;
fecha=datos3;
mes=datos4;
ano=datos5;
diaSemana=datos6;
numeroSemana=datos7;
SegundosT=segundos_crSal;
minutosT=minutos_crSal;
horasT=horas_crSal;
end

else if (cr_activoC) begin
Segundos=datos0;
minutos=datos1;
horas=datos2;
fecha=datos3;
mes=datos4;
ano=datos5;
diaSemana=datos6;
numeroSemana=datos7;
SegundosT=datos8;
minutosT=datos9;
horasT=datos10;
end

else begin
Segundos=datos10;
minutos=datos0;
horas=datos1;
fecha=datos2;
mes=datos3;
ano=datos4;
diaSemana=datos5;
numeroSemana=datos6;
SegundosT=0;
minutosT=0;
horasT=0;
end


//Registro para guardar el codigo Ascii
//==============================================================================
always @(posedge clk)
if(interrupt)begin
ascii_reg<=ascii_code;
end
else begin
ascii_reg<=ascii_reg;
end

endmodule
