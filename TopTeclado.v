`timescale 1ns / 1ps

module TopTeclado(
    input wire clk,
    input wire ps2d,
    input wire ps2c,
    output wire [7:0] ascii_code,
    input wire DoRead,Reset,
    output reg interrupt
    );
wire [7:0] key_code;

kb_code kb_unit(.clk(clk),.reset(Reset),.ps2d(ps2d),.ps2c(ps2c),.rd_key_code(DoRead),
                .key_code(key_code),.kb_buf_empty());
                
ASCII scan_code2ascii_unit(.key_code(key_code),.ascii_code(ascii_code));  

reg [12:0]contador=0;
always @(posedge clk)
    begin
    contador<=0;
    if (ascii_code!=8'h00)begin
    contador <= contador +1;end
    end

always @(posedge clk)
    begin
    if(ascii_code!=8'h00 && contador==12'hBB8)begin
    interrupt <=1;end  //señal de interrupción 
    else if (ascii_code==0)begin
    interrupt<=0;end
    end
  
endmodule
