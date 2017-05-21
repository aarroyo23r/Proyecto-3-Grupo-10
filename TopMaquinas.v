`timescale 1ns / 1ps

module TopMaquinas(
    input wire clk,
    output reg [7:0] data,
    output wire [7:0] address,
    input wire inicio,
    input wire escribe,
    input wire crono,
    input wire reset
    );
wire data_inicio;    
inicializacion inicio_unit (.clk(clk),.reset(reset),.inicio(inicio),.address(address),.data_out(data_inicio),.escribe(escribe),.crono(crono));
MaquinaLectura lee_unit (.clk(clk),.reset2(reset),.address(address),.escribe(escribe),.crono(crono),.inicio(inicio));   

always @*begin
    if(inicio && !escribe && !crono && !reset)begin
    data<=data_inicio;
    end
    else if(reset && !inicio && !escribe && !crono) begin
    data<=data_inicio;end
    else begin
    data<=8'hZZ;end
end
   
endmodule
