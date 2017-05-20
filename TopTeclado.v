`timescale 1ns / 1ps

module TopTeclado(
    input wire clk,
    input wire ps2d,
    input wire ps2c,
    output wire [7:0] ascii_code,
    input wire Reset,DoRead
    );
wire [7:0] key_code;

kb_code kb_unit(.clk(clk),.reset(Reset),.ps2d(ps2d),.ps2c(ps2c),.rd_key_code(DoRead),
                .key_code(key_code),.kb_buf_empty(kb_buf_empty));
                
ASCII scan_code2ascii_unit(.key_code(key_code),.ascii_code(ascii_code));                    
    
endmodule
