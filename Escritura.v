`timescale 1ns / 1ps
module MaquinaEscritura(
    input wire inicio,reset,crono,escribe,
    input wire clk,IndicadorMaquina,cr_activo,
    input wire suma,resta,izquierda,derecha,
    input wire control_1,control_2,control_3,
    input wire [7:0]segundos,minutos,horas,date,num_semana,mes,ano,dia_sem,
    input wire [7:0]segundos_cr,minutos_cr,horas_cr,
    output reg [7:0] address,
    output reg [7:0]data_mod,
    output wire [7:0]segundosSal, minutosSal,horasSal,dateSal,num_semanaSal,mesSal,anoSal,dia_semSal,
    output wire [7:0]segundos_crSal,minutos_crSal,horas_crSal,
    output wire [7:0]comp1,comp2

    );
 //Variables----------------------------------------------------------------
reg [3:0] s_next=4'h1;reg [3:0] s_actual;
reg suma_reg;reg resta_reg;reg[4:0]registro=0;
reg [7:0]segundos_reg,minutos_reg,horas_reg,date_reg,num_semana_reg,mes_reg,ano_reg,dia_sem_reg;
reg [7:0]segundos_cr_reg,minutos_cr_reg,horas_cr_reg;
reg [7:0]data_directo=0;
reg [7:0]data_activo;
reg [7:0]compara1=0;
reg [7:0] compara2=0;

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
                 s12 = 4'hd,
                 s13 = 4'he;





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
    else if(control_1 && control_2 && control_3)begin
        s_actual<=s13;
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
                suma_reg=0;
                resta_reg=0;
                s_next=s0;
                 end
    else if(!suma && resta && !izquierda && !derecha)begin
                registro=5'd0;
                address=8'h00;
                data_directo=8'h00;
                suma_reg=0;
                resta_reg=0;
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
    else begin
                registro=8'hZZ;
                address=8'hZZ;
                suma_reg=0;
                resta_reg=0;
                s_next=s0;end

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
                else begin
                registro=8'hZZ;
                address=8'hZZ;
                suma_reg=0;
                resta_reg=0;
                s_next=s1;end
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
                else begin
                registro=8'hZZ;
                address=8'hZZ;
                suma_reg=0;
                resta_reg=0;
                s_next=s2;end
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
                else begin
                registro=8'hZZ;
                address=8'hZZ;
                suma_reg=0;
                resta_reg=0;
                s_next=s3;end
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
                else begin
                registro=8'hZZ;
                address=8'hZZ;
                suma_reg=0;
                resta_reg=0;
                s_next=s4;end
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
                else begin
                registro=8'hZZ;
                address=8'hZZ;
                suma_reg=0;
                resta_reg=0;
                s_next=s5;end
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
                else begin
                registro=8'hZZ;
                address=8'hZZ;
                suma_reg=0;
                resta_reg=0;
                s_next=s6;end
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
                else begin
                registro=8'hZZ;
                address=8'hZZ;
                suma_reg=0;
                resta_reg=0;
                s_next=s7;end
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
      else begin
                registro=8'hZZ;
                address=8'hZZ;
                suma_reg=0;
                resta_reg=0;
                s_next=s8;end
      end
      default:begin
                registro=8'h21;
                address=8'hZZ;
                suma_reg=0;
                resta_reg=0;
                s_next=s0;end

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
      else begin
                  registro=8'hZZ;
                  address=8'h21;
                  suma_reg=0;
                  resta_reg=0;
                  s_next=s9;end
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
           else begin
                      registro=8'hZZ;
                      address=8'hZZ;
                      suma_reg=0;
                      resta_reg=0;
                      s_next=s10;end
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
          else begin
                      registro=8'hZZ;
                      address=8'hZZ;
                      suma_reg=0;
                      resta_reg=0;
                      s_next=s11;end
       end
       default:begin
                      registro=8'hZZ;
                      address=8'h21;
                      suma_reg=0;
                      resta_reg=0;
                      s_next=s0;end
    endcase
end

else if(!inicio && !reset && !crono && !escribe && cr_activo)begin
  address=8'h00;
  data_activo=8'h08;
  registro=8'hZZ;
  suma_reg=0;
  resta_reg=0;
  s_next=4'hZ;
end


else begin
registro=0;
address=8'hZZ;
suma_reg=0;
resta_reg=0;
s_next=s0;
end
end

//LOGICA SUMADOR Y RESTADO-----------------------------------------------------------------------------------

always @(posedge clk)  begin
//SUMADOR
if(!IndicadorMaquina)begin

if(suma_reg && !resta_reg) begin

if (registro==5'd1)begin

    if (segundos_reg<=8'h58) begin

        if (segundos_reg[3:0]==4'h9) begin
            segundos_reg<=segundos_reg+7;
        end

        else begin
            segundos_reg<=segundos_reg+1;
            end
    end

     else begin

     segundos_reg<=segundos_reg;
     end
    end

//------------------------------------------------------------------------------
    else if (registro==5'd2)begin

    if (minutos_reg<=8'h58) begin

        if (minutos_reg[3:0]==4'h9) begin
            minutos_reg<=minutos_reg+7;
            end

        else begin
            minutos_reg<=minutos_reg+1;
            end
    end

    else begin
        minutos_reg<=minutos_reg;
    end

    end

//------------------------------------------------------------------------------
    else if(registro==5'd3)begin

    if (horas_reg<=8'h22)begin

          if (horas_reg[3:0]==4'h9) begin
                horas_reg<=horas_reg+7;
          end

          else begin
                horas_reg<=horas_reg+1;
                end

    end

    else begin
          horas_reg<=horas_reg;
          end
    end
//------------------------------------------------------------------------------
        else if(registro==5'd4)begin

        if (date_reg<=8'h30)begin

              if (date_reg[3:0]==4'h9) begin
                    date_reg<=date_reg+7;
              end

              else begin
                    date_reg<=date_reg+1;
                    end

        end

        else begin
              date_reg<=date_reg;
              end
        end
//------------------------------------------------------------------------------
            else if(registro==5'd5)begin

            if (mes_reg<=8'h11)begin

                  if (mes_reg[3:0]==4'h9) begin
                        mes_reg<=mes_reg+7;
                  end

                  else begin
                        mes_reg<=mes_reg+1;
                        end

            end

            else begin
                  mes_reg<=mes_reg;
                  end
            end
//------------------------------------------------------------------------------
                else if(registro==5'd6)begin

                if (ano_reg<=8'h98)begin

                      if (ano_reg[3:0]==4'h9) begin
                            ano_reg<=ano_reg+7;
                      end

                      else begin
                            ano_reg<=ano_reg+1;
                            end

                end

                else begin
                      ano_reg<=ano_reg;
                      end
                end
//------------------------------------------------------------------------------
                    else if(registro==5'd7)begin

                    if (dia_sem_reg<=8'h6)begin

                          if (dia_sem_reg[3:0]==4'h9) begin
                                dia_sem_reg<=dia_sem_reg+7;
                          end

                          else begin
                                dia_sem_reg<=dia_sem_reg+1;
                                end

                    end

                    else begin
                          dia_sem_reg<=dia_sem_reg;
                          end
                    end

//------------------------------------------------------------------------------
    else if(registro==5'd8)begin

    if (num_semana_reg<=8'h3)begin

          if (num_semana_reg[3:0]==4'h9) begin
                num_semana_reg<=num_semana_reg+7;
          end

          else begin
                num_semana_reg<=num_semana_reg+1;
                end

    end


    else begin
          num_semana_reg<=num_semana_reg;
          end
    end

//------------------------------------------------------------------------------
    else if(registro==5'd9)begin

    if (segundos_cr_reg<=8'h58)begin

          if (segundos_cr_reg[3:0]==4'h9) begin
                segundos_cr_reg<=segundos_cr_reg+7;
          end

          else begin
                segundos_cr_reg<=segundos_cr_reg+1;
                end

    end

    else begin
          segundos_cr_reg<=segundos_cr_reg;
          end
    end
    //------------------------------------------------------------------------------
        else if(registro==5'ha)begin

        if (minutos_cr_reg<=8'h58)begin

              if (minutos_cr_reg[3:0]==4'h9) begin
                    minutos_cr_reg<=minutos_cr_reg+7;
              end

              else begin
                    minutos_cr_reg<=minutos_cr_reg+1;
                    end

        end

        else begin
              minutos_cr_reg<=minutos_cr_reg;
              end
        end

//------------------------------------------------------------------------------
    else if(registro==5'hb)begin

    if (horas_cr_reg<=8'h22)begin

          if (horas_cr_reg[3:0]==4'h9) begin
                horas_cr_reg<=horas_cr_reg+7;
          end

          else begin
                horas_cr_reg<=horas_cr_reg+1;
                end

    end

    else begin
          horas_cr_reg<=horas_cr_reg;
          end
    end


end

//Restador
  else if(!suma_reg && resta_reg ) begin

  if (registro==5'd1)begin

    if (segundos_reg>8'h00) begin

    if (segundos_reg[3:0]==4'h0 && segundos_reg[7:4]!=4'h0) begin
    segundos_reg<=segundos_reg-7;
    end

    else begin
    segundos_reg<=segundos_reg-1;
    end

    end

    else begin
    segundos_reg<=segundos_reg;

    end
    end

  //------------------------------------------------------------------------------
    else if (registro==5'd2)begin
    if (minutos_reg>8'h00)begin

    if (minutos_reg[3:0]==4'h0 && minutos_reg[7:4]!=4'h0) begin
    minutos_reg<=minutos_reg-7;
    end

    else begin
    minutos_reg<=minutos_reg-1;
    end
    end

    else begin
    minutos_reg<=minutos_reg;
    end
    end

//------------------------------------------------------------------------------
    else if(registro==5'd3)begin

    if (horas_reg>8'h00)begin

    if (horas_reg[3:0]==4'h0 && horas_reg[7:4]!=4'h0) begin
    horas_reg<=horas_reg-7;
    end

    else begin
    horas_reg<=horas_reg-1;
    end
    end

    else begin
    horas_reg<=horas_reg;

    end
    end
//------------------------------------------------------------------------------
    else if(registro ==5'h4)begin

    if (date_reg>8'h00)begin

    if (date_reg[3:0]==4'h0 && date_reg[7:4]!=4'h0) begin
    date_reg<=date_reg-7;
    end

    else begin
    date_reg<=date_reg-1;
    end
    end

    else begin
    date_reg<=date_reg;

    end
    end
//------------------------------------------------------------------------------
    else if(registro==5'd5)begin

    if (num_semana_reg>8'h00)begin

    if (num_semana_reg[3:0]==4'h0 && num_semana_reg[7:4]!=4'h0) begin
    num_semana_reg<=num_semana_reg-7;
    end

    else begin
    num_semana_reg<=num_semana_reg-1;
    end
    end

    else begin
    num_semana_reg<=num_semana_reg;

    end
    end
//------------------------------------------------------------------------------
    else if(registro==5'd6)begin

    if (mes_reg>8'h00)begin

    if (mes_reg[3:0]==4'h0 && mes_reg[7:4]!=4'h0) begin
    mes_reg<=mes_reg-7;
    end

    else begin
    mes_reg<=mes_reg-1;
    end
    end

    else begin
    mes_reg<=mes_reg;

    end
    end
//------------------------------------------------------------------------------
    else if(registro==5'd7)begin

    if (ano_reg>8'h00)begin

    if (ano_reg[3:0]==4'h0 && ano_reg[7:4]!=4'h0) begin
    ano_reg<=ano_reg-7;
    end

    else begin
    ano_reg<=ano_reg-1;
    end
    end

    else begin
    ano_reg<=ano_reg;

    end
    end
//------------------------------------------------------------------------------
    else if(registro==5'd8)begin

    if (dia_sem_reg>8'h00)begin

    if (dia_sem_reg[3:0]==4'h0 && dia_sem_reg[7:4]!=4'h0) begin
    dia_sem_reg<=dia_sem_reg-7;
    end

    else begin
    dia_sem_reg<=dia_sem_reg-1;
    end
    end

    else begin
    dia_sem_reg<=dia_sem_reg;

    end
    end
//------------------------------------------------------------------------------
    else if(registro==5'd9)begin

    if (segundos_cr_reg>8'h00)begin

    if (segundos_cr_reg[3:0]==4'h0 && segundos_cr_reg[7:4]!=4'h0 ) begin
    segundos_cr_reg<=segundos_cr_reg-7;
    end

    else begin
    segundos_cr_reg<=segundos_cr_reg-1;
    end
    end

    else begin
    segundos_cr_reg<=segundos_cr_reg;

    end
    end
//------------------------------------------------------------------------------
    else if(registro==5'ha)begin
    if (minutos_cr_reg>8'h00)begin

    if (minutos_cr_reg[3:0]==4'h0 && minutos_cr_reg[7:4]!=4'h0) begin
    minutos_cr_reg<=minutos_cr_reg-7;
    end

    else begin
    minutos_cr_reg<=minutos_cr_reg-1;
    end
    end

    else begin
    minutos_cr_reg<=minutos_cr_reg;

    end
    end
//------------------------------------------------------------------------------
    else if(registro==5'hb)begin

    if (horas_cr_reg>8'h00)begin

    if (horas_cr_reg[3:0]==4'h0 && horas_cr_reg[7:4]!=4'h0) begin
    horas_cr_reg<=horas_cr_reg-7;
    end

    else begin
    horas_cr_reg<=horas_cr_reg-1;
    end
    end

    else begin
    horas_cr_reg<=horas_cr_reg;

    end
    end
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
  segundos_reg<=minutos;
  minutos_reg<=horas;
  horas_reg<=date;
  date_reg<=num_semana;
  num_semana_reg<=mes;
  mes_reg<=ano;
  ano_reg<=dia_sem;
  dia_sem_reg<=segundos_cr;
  segundos_cr_reg<=minutos_cr;
  minutos_cr_reg<=horas_cr;
  horas_cr_reg<=segundos;
  end
end

//Registros cronometro

always @(posedge clk)
if (crono)begin
compara1<=segundos_cr_reg;
compara2<=minutos_cr_reg;
end

else begin
compara1<=compara1;
compara2<=compara2;
 end

//LOGICA DE SALIDA DEL DATO MODIFICADO------------------------------------------------------------
always@*
  begin
  if(address==8'h21)begin
  data_mod=segundos_reg;
  end
  else if(address==8'h22)begin
  data_mod=minutos_reg;
  end
  else if(address==8'h23)begin
  data_mod=horas_reg;
  end
  else if(address==8'h24)begin
  data_mod=date_reg;
  end
  else if(address==8'h25)begin
  data_mod=mes_reg;
  end
  else if(address==8'h26)begin
  data_mod=ano_reg;
  end
  else if(address==8'h27)begin
  data_mod=num_semana_reg;
  end
  else if(address==8'h28)begin
  data_mod=dia_sem_reg;
  end
  else if(address==8'h41)begin
  data_mod=segundos_cr_reg;end
  else if(address==8'h42) begin
  data_mod=minutos_cr_reg;end
  else if(address==8'h43 )begin
  data_mod=horas_cr_reg;end
  else if(address==8'h00 && s_actual<s12)begin
  data_mod=data_directo;end
  else if(address==8'h00 && s_actual==s12)begin
  data_mod=data_activo;end
  else if(address==8'h00 && s_actual==s13)begin
  data_mod=data_activo;end
  end

//WIRE fantasma que son leidos por el controlador de la VGA durante la escritura

assign segundosSal=segundos_reg,
       minutosSal=minutos_reg,
       horasSal=horas_reg,
       dateSal=date_reg,
       mesSal=mes_reg,
       anoSal=ano_reg,
       num_semanaSal=num_semana_reg,
       dia_semSal=dia_sem_reg,
       segundos_crSal=segundos_cr_reg,
       horas_crSal=horas_cr_reg,
       minutos_crSal=minutos_cr_reg;


assign comp1=compara1;
assign comp2=compara2;

endmodule
