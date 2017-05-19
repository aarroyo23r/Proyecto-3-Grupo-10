`timescale 1ns / 1ps


module RAM (
  input wire [clogb2(RAM_DEPTH-1)-1:0] address,   // Address bus, width determined from RAM_DEPTH
  input wire [RAM_WIDTH-1:0] data_in,            // RAM input data
  input wire clk,                                // Clock
  input wire enable,                            // RAM Enable, for additional power savings, disable port when not in use
  input wire reset,                            // Output reset (does not affect memory contents)
  output wire [RAM_WIDTH-1:0] data_out                   // RAM output data
);

  reg write_en=0;                          // Write enable
  reg  read_en=1;                         // Output register enable

  parameter RAM_WIDTH = 12;                           // Specify RAM data width
  parameter RAM_DEPTH = 307679;                       //Max 524 288         // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "LOW_LATENCY";     // Select "HIGH_PERFORMANCE" or "LOW_LATENCY"
  parameter INIT_FILE = "ArregloMemoria.txt";         // Specify name/location of RAM initialization file if using one (leave blank if not)

  reg [RAM_WIDTH-1:0] RAMGraficos [RAM_DEPTH-1:0];
  reg [RAM_WIDTH-1:0] data_ram = {RAM_WIDTH{1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, RAMGraficos, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          RAMGraficos[ram_index] = {RAM_WIDTH{1'b0}};
    end
  endgenerate

  always @(posedge clk)
    if (enable) begin
      if (write_en)
        RAMGraficos[address] <= data_in;
      data_ram <= RAMGraficos[address];
    end

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "HIGH_PERFORMANCE") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign data_out = data_ram;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [RAM_WIDTH-1:0] douta_reg = {RAM_WIDTH{1'b0}};

      always @(posedge clk)
        if (reset)
          douta_reg <= {RAM_WIDTH{1'b0}};
        else if (read_en)
          douta_reg <= data_ram;

      assign data_out =douta_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction

  endmodule
