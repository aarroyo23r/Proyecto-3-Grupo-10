`timescale 1ns / 1ps
module MaquinaEscritura(
    input wire inicio,reset,crono,escribe,
    input wire clk,
    input wire suma,resta,izquierda,derecha,
    //input wire [7:0]segundos,minutos,horas,date,num_semana,mes,ano,dia_sem,
    output reg [7:0] address    
    );
 //Variables----------------------------------------------------------------  
reg [3:0] s_next=4'h1;reg [3:0] s_actual;
reg suma_reg;reg resta_reg;reg[4:0]registro=0; 

//declaración de estados---------------------------------------------------_
localparam [3:0] s0 = 4'h1, //am-pm---24hrs
                 s1 = 4'h2, //segundos
                 s2 = 4'h3, //minutos
                 s3 = 4'h4, //horas
                 s4 = 4'h5, //date
                 s5 = 4'h6, //mes
                 s6 = 4'h7, //año
                 s7 = 4'h8, //día de semana
                 s8 = 4'h9; //#de semana
                
//Lógica de reset y de estado siguiente-------------------------------------
always @(posedge clk,posedge reset)begin
    if(reset|crono)begin
        s_actual <=s0;
    end
    else
        s_actual <=s_next;
end

//Máquina de Estados----------------------------------------------------------
always@*begin
if(!inicio && !reset && !crono && escribe)begin
case(s_actual)
    s0:begin                                                   //am-pm---24hrs
    if(!suma && !resta && !izquierda && !derecha)begin
                registro=5'd0;
                address=8'h00;
                suma_reg=0;
                resta_reg=0;
                s_next=s0;
                end
    else if(suma && !resta && !izquierda && !derecha)begin
                registro=5'd0;
                address=8'h00;
                suma_reg=1;
                resta_reg=0;
                s_next=s0;
                 end
    else if(!suma && resta && !izquierda && !derecha)begin
                registro=5'd0;
                address=8'h00;
                resta_reg=1;
                suma_reg=0;
                s_next=s0;
                end
    
    else if(!suma && !resta && izquierda && !derecha)begin
                registro=5'd8;
                address=8'h28;
                suma_reg=0;
                resta_reg=0;
                s_next=s8;
                end
    else if(!suma && !resta && !izquierda && derecha)begin
                registro=5'd1;
                address=8'h21;
                suma_reg=0;
                resta_reg=0;
                s_next=s1;
                end
    
    end
    s1:begin                                                   //segundos
    if(!suma && !resta && !izquierda && !derecha)begin
                registro=5'd1;
                address=8'h21;
                suma_reg=0;
                resta_reg=0;
                s_next=s1;
                end
    else if(suma && !resta && !izquierda && !derecha)begin
                registro=5'd1;
                address=8'h21;
                suma_reg=1;
                resta_reg=0;
                s_next=s1;
                end
    else if(!suma && resta && !izquierda && !derecha)begin
                registro=5'd1;
                address=8'h21;
                resta_reg=1;
                suma_reg=0;
                s_next=s1;
                end
        
    else if(!suma && !resta && izquierda && !derecha)begin
                registro=5'd1;
                address=8'h00;
                suma_reg=0;
                resta_reg=0;
                s_next=s0;
                end
    else if(!suma && !resta && !izquierda && derecha)begin
                registro=5'd1;
                address=8'h22;
                suma_reg=0;
                resta_reg=0;
                s_next=s2;
                end
    end
    s2:begin                                                   //minutos
    if(!suma && !resta && !izquierda && !derecha)begin
                registro=5'd2;
                address=8'h22;
                suma_reg=0;
                resta_reg=0;
                s_next=s2;
                end
    else if(suma && !resta && !izquierda && !derecha)begin
                registro=5'd2;
                address=8'h22;
                suma_reg=1;
                resta_reg=0;
                s_next=s2;
                end
    else if(!suma && resta && !izquierda && !derecha)begin
                registro=5'd2;
                address=8'h22;
                resta_reg=1;
                suma_reg=0;
                s_next=s2;
                end
            
    else if(!suma && !resta && izquierda && !derecha)begin
                registro=5'd1;
                address=8'h21;
                suma_reg=0;
                resta_reg=0;
                s_next=s1;
                end
    else if(!suma && !resta && !izquierda && derecha)begin
                registro=5'd3;
                address=8'h23;
                suma_reg=0;
                resta_reg=0;
                s_next=s3;
                end
    end
    s3:begin                                                   //horas
    if(!suma && !resta && !izquierda && !derecha)begin
                registro=5'd3;
                address=8'h23;
                suma_reg=0;
                resta_reg=0;
                s_next=s3;
                end
    else if(suma && !resta && !izquierda && !derecha)begin
                registro=5'd3;
                address=8'h23;
                suma_reg=1;
                resta_reg=0;
                s_next=s3;
                end
    else if(!suma && resta && !izquierda && !derecha)begin
                registro=5'd3;
                address=8'h23;
                resta_reg=1;
                suma_reg=0;
                s_next=s3;
                end
                
    else if(!suma && !resta && izquierda && !derecha)begin
                registro=5'd2;
                address=8'h22;
                suma_reg=0;
                resta_reg=0;
                s_next=s2;
                end
    else if(!suma && !resta && !izquierda && derecha)begin
                registro=5'd4;
                address=8'h24;
                suma_reg=0;
                resta_reg=0;
                s_next=s4;
                end
    end
    s4:begin                                                   //date
    if(!suma && !resta && !izquierda && !derecha)begin
                registro=5'd4;
                address=8'h24;
                suma_reg=0;
                resta_reg=0;
                s_next=s4;
                end
   else if(suma && !resta && !izquierda && !derecha)begin
                registro=5'd4;
                address=8'h24;
                suma_reg=1;
                resta_reg=0;
                s_next=s4;
                end
   else if(!suma && resta && !izquierda && !derecha)begin
                registro=5'd4;
                address=8'h24;
                resta_reg=1;
                suma_reg=0;
                s_next=s4;
                end          
   else if(!suma && !resta && izquierda && !derecha)begin
                registro=5'd3;
                address=8'h23;
                suma_reg=0;
                resta_reg=0;
                s_next=s3;
                end
   else if(!suma && !resta && !izquierda && derecha)begin
                registro=5'd5;
                address=8'h25;
                suma_reg=0;
                resta_reg=0;
                s_next=s5;
                end
        end
   s5:begin                                                   //mes
   if(!suma && !resta && !izquierda && !derecha)begin
                registro=5'd5;
                address=8'h25;
                suma_reg=0;
                resta_reg=0;
                s_next=s5;
                end
    else if(suma && !resta && !izquierda && !derecha)begin
                registro=5'd5;
                address=8'h25;
                suma_reg=1;
                resta_reg=0;
                s_next=s5;
                end
    else if(!suma && resta && !izquierda && !derecha)begin
                registro=5'd5;
                address=8'h25;
                resta_reg=1;
                suma_reg=0;
                s_next=s5;
                end
                    
    else if(!suma && !resta && izquierda && !derecha)begin
                registro=5'd4;
                address=8'h24;
                suma_reg=0;
                resta_reg=0;
                s_next=s4;
                end
    else if(!suma && !resta && !izquierda && derecha)begin
                registro=5'd6;
                address=8'h26;
                suma_reg=0;
                resta_reg=0;
                s_next=s6;
                end
    end
    s6:begin                                                   //año
    if(!suma && !resta && !izquierda && !derecha)begin
                registro=5'd6;
                address=8'h26;
                suma_reg=0;
                resta_reg=0;
                s_next=s6;
                end
    else if(suma && !resta && !izquierda && !derecha)begin
                registro=5'd6;
                address=8'h26;
                suma_reg=1;
                resta_reg=0;
                s_next=s6;
                end
    else if(!suma && resta && !izquierda && !derecha)begin
                registro=5'd6;
                address=8'h26;
                resta_reg=1;
                suma_reg=0;
                s_next=s6;
                end    
   else if(!suma && !resta && izquierda && !derecha)begin
                registro=5'd5;
                address=8'h25;
                suma_reg=0;
                resta_reg=0;
                s_next=s5;
                end
   else if(!suma && !resta && !izquierda && derecha)begin
                registro=5'd7;
                address=8'h27;
                suma_reg=0;
                resta_reg=0;
                s_next=s7;
                end
   end
   s7:begin                                                   //dia_semana
      if(!suma && !resta && !izquierda && !derecha)begin
                registro=5'd7;
                address=8'h27;
                suma_reg=0;
                resta_reg=0;
                s_next=s7;
                end
      else if(suma && !resta && !izquierda && !derecha)begin
                registro=5'd7;
                address=8'h27;
                suma_reg=1;
                resta_reg=0;
                s_next=s7;
                end
      else if(!suma && resta && !izquierda && !derecha)begin
                registro=5'd7;
                address=8'h27;
                resta_reg=1;
                suma_reg=0;
                s_next=s7;
                end                    
      else if(!suma && !resta && izquierda && !derecha)begin
                registro=5'd6;
                address=8'h26;
                suma_reg=0;
                resta_reg=0;
                s_next=s6;
                end
      else if(!suma && !resta && !izquierda && derecha)begin
                registro=5'd8;
                address=8'h28;
                suma_reg=0;
                resta_reg=0;
                s_next=s8;
                end
      end
      s8:begin                                                   //numero_semana
      if(!suma && !resta && !izquierda && !derecha)begin
                registro=5'd8;
                address=8'h28;
                suma_reg=0;
                resta_reg=0;
                s_next=s8;
                end
      else if(suma && !resta && !izquierda && !derecha)begin
                registro=5'd8;
                address=8'h28;
                suma_reg=1;
                resta_reg=0;
                s_next=s8;
                end
      else if(!suma && resta && !izquierda && !derecha)begin
                registro=5'd8;
                address=8'h28;
                resta_reg=1;
                suma_reg=0;
                s_next=s8;
                end                    
      else if(!suma && !resta && izquierda && !derecha)begin
                registro=5'd7;
                address=8'h27;
                suma_reg=0;
                resta_reg=0;
                s_next=s7;
                end
      else if(!suma && !resta && !izquierda && derecha)begin
                registro=5'd0;
                address=8'h00;
                suma_reg=0;
                resta_reg=0;
                s_next=s0;
                end
      end
    
endcase
end

else begin
registro=registro;
address=address;
suma_reg=suma_reg;
resta_reg=resta_reg;
s_next=s_next;
end

end

endmodule


