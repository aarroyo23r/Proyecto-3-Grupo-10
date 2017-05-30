`timescale 1ns / 1ps
module Registros(
    input wire clk,
    input wire AoD,
    input wire [7:0] data_vga,
    input wire [7:0]address,
    output reg [7:0] data_0,
    output reg [7:0] data_1,
    output reg [7:0] data_2,
    output reg [7:0] data_3,
    output reg [7:0] data_4,
    output reg [7:0] data_5,
    output reg [7:0] data_6,
    output reg [7:0] data_7,
    output reg [7:0] data_8,
    output reg [7:0] data_9,
    output reg [7:0] data_10
    );

always@(posedge clk)begin

    if(address==8'h22 && !AoD)begin
    data_0<=data_vga;
    //data_0<=1;
    end

    else if(address==8'h23 && !AoD)begin
    data_1<=data_vga;end

    else if(address==8'h24 && !AoD)begin
    data_2<=data_vga;end

    else if(address==8'h25 && !AoD )begin
    data_3<=data_vga;end

    else if(address==8'h26 && !AoD)begin
    data_4<=data_vga;end

    else if(address==8'h27 && !AoD)begin
    data_5<=data_vga;
    end

    else if(address==8'h28 && !AoD)begin
    data_6<=data_vga;end

    else if(address==8'h41 &&!AoD)begin
    data_7<=data_vga;end


    //Cronometro
    else if(address==8'h42 && !AoD)begin
    data_8<=data_vga;end

    else if(address==8'h43 && !AoD)begin
    data_9<=data_vga;end

    else if(address==8'h21 &&  !AoD)begin
    data_10<=data_vga;end

    else begin
          data_0<=data_0;
          data_1<=data_1;
          data_2<=data_2;
          data_3<=data_3;
          data_4<=data_4;
          data_5<=data_5;
          data_6<=data_6;
          data_7<=data_7;
          data_8<=data_8;
          data_9<=data_9;
          data_10<=data_10;

    end

end

endmodule
