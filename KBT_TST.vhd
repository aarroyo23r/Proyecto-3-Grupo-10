-- KBD_TST.vhd
---------------------------------------------------
-- Self-Testing PS/2 Keyboard Test bench (c) ALSE
---------------------------------------------------
-- Author : Bert Cuzeau - ALSE - http://www.alse-fr.com
-- No part of this code can be used without the prior
-- written consent of ALSE.
-- This is a simplified model.
-- Compile with '93 option (hex constants...)
use STD.Textio.all;
library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.Numeric_std.all;
use IEEE.Std_Logic_Textio.all;
-------------------
entity Kbd_tst is
constant Period : time := 10 ns; -- 100 MHz System Clock
constant BitPeriod : time := 60 us; -- Kbd Clock is 16.7 kHz max
end;
-------------------
-------------------
architecture Test of Kbd_tst is
-------------------
--- Declaracion del modulo Verilog a instanciar
-- Ver mas adelante, cuando lo conectamos
--- Esto quiere decir que su modulo Verilog debe declararse como module PS2_Ctrl(....)
Component TopTeclado
port( clk : in std_logic; -- System Clock
Reset : in std_logic; -- System Reset
ps2c : in std_logic; -- Keyboard Clock Line
ps2d : in std_logic; -- Keyboard Data Line
DoRead : in std_logic; -- From outside when reading the scan code
--Scan_Err : out std_logic; -- To outside if wrong parity or Overflow
--kb_buf_empty : out std_logic; -- To outside when a scan code has arrived
ascii_code : out std_logic_vector(7 downto 0) ); -- scan code
end component;
signal Clk : std_logic := '0';
signal Reset : std_logic;
signal Kbd_Clk : std_logic := 'H';
signal Kbd_Data : std_logic := 'H';
signal DoRead : std_logic := '0';
signal Scan_Err : std_logic;
signal Scan_DAV : std_logic;
signal Scan_Code : std_logic_vector(7 downto 0);
signal Succeeded : boolean := true;
type Code_r is
record
Cod : std_logic_vector (7 downto 0);
Err : Std_logic; -- note: '1' <=> parity error
end record;
type Codes_Table_t is array (natural range <>) of Code_r;
---Aqui definimos los valores en hexadecimal a enviar. Pongan los de los numeros dentro de esta tabla
constant Codes_Table : Codes_Table_t -- if you need more codes: just add them!
:= ( (x"45",'0'), (x"F0",'1'), (x"45",'0'), (x"16",'0'),  --recordar que se debe de enviar FO para indicar que se solto la tecla
(x"F0",'1'), (x"16",'0'), (x"45",'0'), (x"F0",'1'),
(x"45",'0'));
-- in Verilog, the function below is just : ^V ;-)
function Even (V : std_logic_vector) return std_logic is
variable p : std_logic := '0';
begin
for i in V'range loop p := p xor V(i); end loop; return p;
end function;
-------------------
begin
-------------------
-- Instanciate the UUT (PS/2 Controller) :
-- Aqui debe instanciarse su teclado
-- Este testbench generar un error al enviar el codigo 56. Por eso existe la semnal Scan_Err
-- Ustedes pueden eliminar estas sennales para simplificar:
-- DoRead (que indica a su controlador que ya se leyo el dato por parte del amo)
-- Scan_DAV (que indica al amo que el controlador esclavo tiene un dato listo)
-- Scan_Err (que indica que ha habido un error de Paridad, O que hay un desborde, porque se tiene un dato listo para salir, pero
-- el amo no lo ha leido aun, y ya llego un dato nuevo por el teclado
-- No obstante, es recomendable dejarlas para mejorar el control y saber si su controlador esta funcionando
-- Para instanciar un modulo Verilog en un TestBench en VHDL, vayan a 
-- El orden de conexion en VHDL sigue el mismo orden que VErilog. Primero va el pin del modulo instanciado, y luego el alambre o sennak
--ak que estariammos alambrando
UUT: TopTeclado
port map ( clk => Clk,
Reset => Reset,
ps2c => Kbd_Clk,
ps2d => Kbd_Data,
DoRead => DoRead,
--Scan_Err => Scan_Err,
--kb_buf_empty => Scan_DAV,
ascii_code => Scan_Code );
-- System Clock & Reset
clk <= not Clk after (Period / 2);
Reset <= '1', '0' after Period;

-- Keyboard sending Data to the Controller
Emit: process
procedure SendCode ( D : std_logic_vector(7 downto 0);
Err : std_logic := '0') is
begin
Kbd_Clk <= 'H';
Kbd_Data <= 'H';
-- (1) verify that Clk was Idle (high) at least for 50 us.
-- this is not coded here.
wait for (BitPeriod / 2);
-- Start bit
Kbd_Data <= '0';
wait for (BitPeriod / 2);
Kbd_Clk <= '0'; wait for (BitPeriod / 2);
Kbd_Clk <= '1';
-- Data Bits
for i in 0 to 7 loop
Kbd_Data <= D(i);
wait for (BitPeriod / 2);
Kbd_Clk <= '0'; wait for (BitPeriod / 2);
Kbd_Clk <= '1';
end loop;
-- Odd Parity bit
Kbd_Data <= Err xor not Even (D);
wait for (BitPeriod / 2);
Kbd_Clk <= '0'; wait for (BitPeriod / 2);
Kbd_Clk <= '1';
-- Stop bit
Kbd_Data <= '1';
wait for (BitPeriod / 2);
Kbd_Clk <= '0'; wait for (BitPeriod / 2);
Kbd_Clk <= '1';
Kbd_Data <= 'H';
wait for (BitPeriod * 3);
end procedure SendCode;
begin -- process Emit
-----
Wait for BitPeriod;
-- Send the Test Frames
for i in Codes_Table'range loop
SendCode (Codes_Table(i).Cod,Codes_Table(i).Err);
end loop;
if not Succeeded then
report "End of simulation : " & Lf &
" There have been errors in the Data / Err read !"
severity failure;
else
report Lf & " SUCCESSFULL End of simulation : " & Lf &
" There has been no (zero) error !" & Lf & Ht
severity note;
report "End of Simulation" severity failure;
end if;
end process Emit;

-- Host reading (& verifying) Data :
Host: process
variable L : line;
variable Index : natural := 0;
begin
wait until Scan_DAV='1';
wait for 300 * Period;
DoRead <= '1';
write (L,now,right,12);
write (L,Ht&"Scan code read (hex) = ");
hwrite (L,Scan_Code);
if Scan_Err='1' then
write (L,ht&" >>> Scan_Err <<<");
end if;
-- Compare with the original Data-Error :
if (Scan_Code /= Codes_Table(Index).Cod)
or (Scan_Err /= Codes_Table(Index).Err) then
Succeeded <= False;
write (L, Ht&"!!! Mismatch !!!");
end if;
Index := Index + 1;
writeline (output,L);
wait for Period;
DoRead <= '0';
end process Host;
end Test;

