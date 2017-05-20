`timescale 1ns / 1ps


module inicializacion(
    input wire clk,reset,escribe,lee,
    input wire Inicio,
    output reg[7:0] data_out,
    output reg [7:0] address
    );
localparam [11:0] limit = 12'd36; //tiempo en el que la dirección se mantiene
    reg [11:0] contador=0;
    reg [4:0] c_dir=0;


always @(posedge clk)
begin
    if((Inicio|reset) && !escribe && !lee)begin
    contador<=contador + 1'b1;
      if(contador==limit)
      begin
      contador<=0;
      c_dir<=c_dir +1'b1;
        if(c_dir==4'hd)begin
        c_dir<=0;
      end
      end
    end
        if(!Inicio && !reset)begin
        contador<=0;
        c_dir<=0;
    end
    end


always @*begin
  if((Inicio|reset) && !escribe && !lee)
    begin
    case(c_dir)
        4'h1:
            begin
            address<=8'h02;
            data_out<=8'h08;//Inicializa máquina
            end
         4'h2:
            begin
            address<=8'h02;
            data_out<=8'h00;//Inicializa la máquina
            end
         4'h3:
            begin
            address<=8'h21;
            data_out<=8'h00;//pone en ceros los segundos
            end
         4'h4:
            begin
            address<=8'h22;
            end
         4'h5:
            begin
            address<=8'h23;
            end
         4'h6:
            begin
            address<=8'h24;
            end
         4'h7:
            begin
            address<=8'h25;
            end
         4'h8:
            begin
            address<=8'h26;
            end
         4'h9:
            begin
            address<=8'h27;
            end
         4'ha:
            begin
            address<=8'h28;
            end
         4'hb:
            begin
            address<=8'h31;
            end
         4'hc:
            begin
            address<=8'h32;
            end
         4'hd:
            begin
            address<=8'h33;
            end
         default:address<=8'hZZ;
    endcase
    end
    else
    address<=8'hZZ;
    end

endmodule

