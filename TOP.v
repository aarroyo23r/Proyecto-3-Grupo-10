
`timescale 1ns / 1ps

module TOP(
    input wire clk,Reset,
    input wire ps2d,
    input wire ps2c,
    inout wire [7:0] DATA_ADDRESS,
    output wire [7:0]ascii_code,
    output wire ChipSelect,Read,Write,AoD, //Señales de entrada del RTC
    output wire [7:0]address,data
    );
wire DoRead;
wire interrupt;
wire inicio1;
wire [7:0] EstadoPort;
wire escribe1,crono,cr_activo;
wire sumar,restar;
reg reset1=0;
wire izquierda,derecha;


assign escribe1 = EstadoPort[0];
assign crono = EstadoPort[1];
assign cr_activo = EstadoPort[2];



PicoBlaze Picoblaze_unit(.clk(clk),.reset(),.inicio(inicio1),.in_port(ascii_code),.interrupt(interrupt),.interrupt_ack(DoRead),.EstadoPort(EstadoPort),.sumar(sumar),.restar(restar),
                         .izquierda(izquierda),.derecha(derecha));

TopTeclado teclado_unit(.clk(clk), .ps2d(ps2d),.ps2c(ps2c),.Reset(Reset),.ascii_code(ascii_code),.DoRead(DoRead),.interrupt(interrupt));

TopMaquinas Maquinas_unit(.clk(clk),.data(data),.address(address),.escribe1(escribe1),.crono(crono),.reset1(reset1),.cr_activo(cr_activo),.push_arriba(sumar),.push_abajo(restar),
                          .push_izquierda(izquierda),.push_derecha(derecha),.DATA_ADDRESS(DATA_ADDRESS),.data_mod(),.data_vga(),.inicio1(inicio1),.ChipSelect(ChipSelect),.Read(Read),
                          .Write(Write),.AoD(AoD));


endmodule
