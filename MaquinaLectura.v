`timescale 1ns / 1ps
module MaquinaLectura(
    input wire clk,reset2,escribe,crono,inicio,
    output reg [7:0] address
    );
localparam [11:0] limit = 12'h04a; //tiempo en el que la dirección se mantiene
reg [11:0] contador=1;
reg reset;
reg [3:0] c_dir=0;
  

always @(posedge clk)
begin
    if(crono | (!escribe && !reset2 && !inicio))
    begin
    contador<=contador + 1'b1;
    if(contador==limit)
    begin
        contador<=1;
        c_dir<=c_dir +1'b1;
        if(c_dir==4'hb)
            begin
            c_dir<=0;
            end
    end
    end
    else
    begin
    contador<=0;
    c_dir<=0;
end
end



always @(posedge clk)
begin
if(crono | (!escribe && !reset2 && !inicio))
begin
case(c_dir)
    4'h1:
        begin
        address<=8'h21;
        end
     4'h2:
        begin
        address<=8'h22;
        end
     4'h3:
        begin
        address<=8'h23;
        end
     4'h4:
        begin
        address<=8'h24;
        end
     4'h5:
        begin
        address<=8'h25;
        end
     4'h6:
        begin
        address <=8'h26;
        end
     4'h7:
        begin
        address<=8'h27;
        end
     4'h8:
        begin
        address<=8'h28;
        end
     4'h9:
        begin
        address<=8'h41;
        end
     4'ha:
        begin
        address<=8'h42;
        end
     4'hb:
        begin
        address<=8'h43;
        end
     default:address<=8'hZZ;
endcase
end
else
address<=8'hZZ;
end

endmodule