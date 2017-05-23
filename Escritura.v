`timescale 1ns / 1ps
module MaquinaEscritura(
    input wire inicio,reset,crono,escribe,
    input wire clk,IndicadorMaquina,cr_activo,
    input wire suma,resta,izquierda,derecha,
    input wire [7:0]segundos,minutos,horas,date,num_semana,mes,ano,dia_sem,
    input wire [7:0]segundos_cr,minutos_cr,horas_cr,
    output reg [7:0] address,
    output reg [7:0]data_mod    
    );
 //Variables----------------------------------------------------------------  
reg [3:0] s_next=4'h1;reg [3:0] s_actual;
reg suma_reg;reg resta_reg;reg[4:0]registro=0; 
reg [7:0]segundos_reg,minutos_reg,horas_reg,date_reg,num_semana_reg,mes_reg,ano_reg,dia_sem_reg;
reg [7:0]segundos_cr_reg,minutos_cr_reg,horas_cr_reg;
reg [7:0]data_directo=0;
reg [7:0]data_activo;

//declaración de estados---------------------------------------------------_
localparam [3:0] s0 = 4'h1, //am-pm---24hrs
                 s1 = 4'h2, //segundos
                 s2 = 4'h3, //minutos
                 s3 = 4'h4, //horas
                 s4 = 4'h5, //date
                 s5 = 4'h6, //mes
                 s6 = 4'h7, //año
                 s7 = 4'h8, //día de semana
                 s8 = 4'h9, //#de semana
                 s9 = 4'ha, //segundos cronometro
                 s10 = 4'hb,//minutos cronometro
                 s11 = 4'hc, //horas cronómetro
                 s12 = 4'hd;
                
//Lógica de reset y de estado siguiente-------------------------------------
always @(posedge clk,posedge reset)begin
    if(reset)begin
        s_actual <=s0;
    end
    else if(crono && s_actual<4'ha)begin
        s_actual<=s9;
    end
    else if(!crono && cr_activo && s_actual<=4'hd)begin
        s_actual<=s12;
    end
    else
        s_actual <=s_next;
end


    

//Máquina de Estados----------------------------------------------------------
always@*begin
if(!inicio && !reset && !crono && escribe && !cr_activo)begin   //escritura de registros de fecha y hora
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
                data_directo=8'h10;
                s_next=s0;
                 end
    else if(!suma && resta && !izquierda && !derecha)begin
                registro=5'd0;
                address=8'h00;
                data_directo=8'h00;
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
//Programación del cronómetro-----------------------------------------------------------------------------
else if(!inicio && !reset && crono && !escribe && !cr_activo)begin              
    case(s_actual)
      s9:begin                                                  //segundos crono
      if(!suma && !resta && !izquierda && !derecha)begin
                  registro=5'd9;
                  address=8'h41;
                  suma_reg=0;
                  resta_reg=0;
                  s_next=s9;
                  end
      else if(suma && !resta && !izquierda && !derecha)begin  
                  registro=5'd9;
                  address=8'h41;
                  suma_reg=1;
                  resta_reg=0;
                  s_next=s9;
                  end
      else if(!suma && resta && !izquierda && !derecha)begin  
                  registro=5'd9;
                  address=8'h41;
                  resta_reg=1;
                  suma_reg=0;
                  s_next=s9;
                  end                    
      else if(!suma && !resta && izquierda && !derecha)begin
                  registro=5'hb;
                  address=8'h43;
                  suma_reg=0;
                  resta_reg=0;
                  s_next=s11;
                  end
      else if(!suma && !resta && !izquierda && derecha)begin
                  registro=5'ha;
                  address=8'h42;
                  suma_reg=0;
                  resta_reg=0;
                  s_next=s10;
                  end  
      end
      s10:begin                                             // minutos crono
      if(!suma && !resta && !izquierda && !derecha)begin
                      registro=5'ha;
                      address=8'h42;
                      suma_reg=0;
                      resta_reg=0;
                      s_next=s10;
                      end
            else if(suma && !resta && !izquierda && !derecha)begin
                      registro=5'ha;
                      address=8'h42;
                      suma_reg=1;
                      resta_reg=0;
                      s_next=s10;
                      end
            else if(!suma && resta && !izquierda && !derecha)begin
                      registro=5'ha;
                      address=8'h42;
                      resta_reg=1;
                      suma_reg=0;
                      s_next=s10;
                      end                    
            else if(!suma && !resta && izquierda && !derecha)begin
                      registro=5'h9;
                      address=8'h41;
                      suma_reg=0;
                      resta_reg=0;
                      s_next=s9;
                      end
            else if(!suma && !resta && !izquierda && derecha)begin
                      registro=5'hb;
                      address=8'h43;
                      suma_reg=0;
                      resta_reg=0;
                      s_next=s11;
                      end
           end
           s11:begin                                            //horas crono
           if(!suma && !resta && !izquierda && !derecha)begin
                      registro=5'hb;
                      address=8'h43;
                      suma_reg=0;
                      resta_reg=0;
                      s_next=s11;
                      end
           else if(suma && !resta && !izquierda && !derecha)begin
                      registro=5'hb;
                      address=8'h43;
                      suma_reg=1;
                      resta_reg=0;
                      s_next=s11;
                      end
           else if(!suma && resta && !izquierda && !derecha)begin
                      registro=5'hb;
                      address=8'h43;
                      resta_reg=1;
                      suma_reg=0;
                      s_next=s11;
                      end                    
           else if(!suma && !resta && izquierda && !derecha)begin
                      registro=5'ha;
                      address=8'h42;
                      suma_reg=0;
                      resta_reg=0;
                      s_next=s10;
                      end
          else if(!suma && !resta && !izquierda && derecha)begin
                      registro=5'h9;
                      address=8'h41;
                      suma_reg=0;
                      resta_reg=0;
                      s_next=s9;
                      end
       end               
    endcase
end

else if(!inicio && !reset && !crono && !escribe && cr_activo)begin 
  address<=8'h00;
  data_activo<=8'h08;  
end


else begin
registro=registro;
address=8'hZZ;
suma_reg=suma_reg;
resta_reg=resta_reg;
s_next=s0;
end
end

//LOGICA SUMADOR Y RESTADO-----------------------------------------------------------------------------------

always @(posedge clk) begin
//SUMADOR
if(!IndicadorMaquina)begin

if(suma_reg && !resta_reg) begin

    if (registro==5'd1)begin
    segundos_reg<=segundos_reg + 1;end
    
    else if (registro==5'd2)begin
    minutos_reg<=minutos_reg + 1;end
    
    else if(registro==5'd3)begin
    horas_reg<=horas_reg+1;end

    else if(registro==5'd4)begin
    date_reg<=date_reg+1;end
    
    else if(registro==5'd5)begin
    mes_reg<=mes_reg+1;end
    
    else if(registro==5'd6)begin
    ano_reg<=ano_reg+1;end
   
    else if(registro==5'd7)begin
    dia_sem_reg<=dia_sem_reg+1;end
    
    else if(registro==5'd8)begin
    num_semana_reg<=num_semana_reg+1;end
    
    else if(registro==5'd9)begin
    segundos_cr_reg<=segundos_cr_reg +1;end
    
    else if(registro==5'ha)begin
    minutos_cr_reg<=minutos_cr_reg+1;end
    
    else if(registro==5'hb)begin
    horas_cr_reg<=horas_reg+1;end
    
    end
   
//Restador
    else if(!suma_reg && resta_reg ) begin

    if (registro==5'd1)begin
    segundos_reg<=segundos_reg - 8'd1;end

    else if (registro==5'd2)begin
    minutos_reg<=minutos_reg - 8'd1;
    end

    else if(registro==5'd3)begin
    horas_reg<=horas_reg-8'd1;
    end

    else if(registro ==5'h4)begin
    date_reg<=date_reg-8'd1;end
    
    else if(registro==5'd5)begin
    num_semana_reg<=num_semana_reg-1;end
    
    else if(registro==5'd6)begin
    mes_reg<=mes_reg-1;end
    
    else if(registro==5'd7)begin
    ano_reg<=ano_reg-1;end
    
    else if(registro==5'd8)begin
    dia_sem_reg<=dia_sem_reg-1;end
    
    else if(registro==5'd9)begin
    segundos_cr_reg<=segundos_cr_reg +1;end
    
    else if(registro==5'ha)begin
    minutos_cr_reg<=minutos_cr_reg;end
    
    else if(registro==5'hb)begin
    horas_cr_reg<=horas_cr_reg;end
     
    end

    else begin
    minutos_reg<=minutos_reg;
    segundos_reg<=segundos_reg;
    horas_reg<=horas_reg;
    date_reg<=date_reg;
    num_semana_reg<=num_semana_reg;
    mes_reg<=mes_reg;
    ano_reg<=ano_reg;
    dia_sem_reg<=dia_sem_reg;
    segundos_cr_reg<=segundos_cr_reg;
    minutos_cr_reg<=minutos_cr_reg;
    horas_cr_reg<=horas_cr_reg;
    end
    
end

else if(IndicadorMaquina)begin
  segundos_reg<=segundos;
  minutos_reg<=minutos;
  horas_reg<=horas;
  date_reg<=date;
  num_semana_reg<=num_semana;
  mes_reg<=mes;
  ano_reg<=ano;
  dia_sem_reg<=dia_sem;
  segundos_cr_reg<=segundos_cr;
  minutos_cr_reg<=minutos_cr;
  horas_cr_reg<=horas_cr;
  end
end


//LOGICA DE SALIDA DEL DATO MODIFICADO------------------------------------------------------------
always@*
  begin
  if(address==8'h21)begin
  data_mod<=segundos_reg;
    end
  else if(address==8'h22)begin
    data_mod<=minutos_reg;
    end
  else if(address==8'h23)begin
    data_mod<=horas_reg;
    end
  else if(address==8'h24)begin
    data_mod<=date_reg;
    end
    
   else if(address==8'h25)begin
    data_mod<=mes_reg;
    end
   else if(address==8'h26)begin
    data_mod<=ano_reg;
    end
   else if(address==8'h27)begin
    data_mod<=num_semana_reg;
    end
   else if(address==8'h28)begin
    data_mod<=dia_sem_reg;
    end
   else if(address==8'h41)begin
    data_mod<=segundos_cr_reg;end
    
   else if(address==8'h42) begin
    data_mod<=minutos_cr_reg;end
   
   else if(address==8'h43 )begin
    data_mod<=horas_cr_reg;end
    
   else if(address==8'h00 && s_actual<s12)begin
   data_mod<=data_directo;end
   
   else if(address==8'h00 && s_actual==s12)begin
   data_mod<=data_activo;end 

//falta asignar datos fantasma que son leidos por el controlador de la VGA durante la lectura
                  
end

endmodule


