// ***************************************************************************
// ***************************************************************************
// Copyright (C) 2014-2024 Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module top  #(

  parameter DATA_WIDTH = 32,
  parameter POLYNOMIAL_WIDTH = 31
) (

  input  wire [DATA_WIDTH-1:0] input_data,
  output wire [DATA_WIDTH-1:0] output_data1,
  output wire [DATA_WIDTH-1:0] output_data2,

  input  wire [POLYNOMIAL_WIDTH-1:0] polynomial,
  input  wire                        inverted
);

  prbs #(
    .DATA_WIDTH(DATA_WIDTH),
    .POLYNOMIAL_WIDTH(31)
  ) prbs1_inst (
    .input_data(input_data),
    .output_data(output_data1),
    .polynomial(polynomial),
    .inverted(inverted)
  );

  prbs #(
    .DATA_WIDTH(DATA_WIDTH),
    .POLYNOMIAL_WIDTH(31)
  ) prbs2_inst (
    .input_data(input_data),
    .output_data(output_data2),
    .polynomial('h48000000),
    .inverted(1'b1)
  );

endmodule

module prbs #(

  parameter DATA_WIDTH = 32,
  parameter POLYNOMIAL_WIDTH = 31
) (

  input  wire [DATA_WIDTH-1:0] input_data,
  output reg  [DATA_WIDTH-1:0] output_data,

  input  wire [POLYNOMIAL_WIDTH-1:0] polynomial,
  input  wire                        inverted
);

  /* Common polynomials:
   * 'h60 // PRBS7
   * 'h110 // PRBS9
   * 'h500 // PRBS11
   * 'h1C80 // PRBS13
   * 'h6000 // PRBS15
   * 'h80004 // PRBS20
   * 'h420000 // PRBS23
   * 'h48000000 // PRBS31
   */

  // check configuration
  initial begin
    if (DATA_WIDTH < POLYNOMIAL_WIDTH) begin
      $error("Data width must be equal to or larger than polynomial width!");
      $finish;
    end
  end

  reg [DATA_WIDTH*POLYNOMIAL_WIDTH-1:0] internal_data;

  integer i;

  always @(*)
  begin
    internal_data[POLYNOMIAL_WIDTH-1:0] = {input_data[POLYNOMIAL_WIDTH-2:0], ^(polynomial & input_data[POLYNOMIAL_WIDTH-1:0]) ^ inverted};

    for (i = 1; i < DATA_WIDTH; i = i + 1) begin
      internal_data[POLYNOMIAL_WIDTH*i +: POLYNOMIAL_WIDTH] = {internal_data[POLYNOMIAL_WIDTH*(i-1) +: POLYNOMIAL_WIDTH-1], ^(polynomial & internal_data[POLYNOMIAL_WIDTH*(i-1)+:POLYNOMIAL_WIDTH]) ^ inverted};
    end
  end

  always @(*)
  begin
    for (i = 0; i < DATA_WIDTH; i = i + 1) begin
      output_data[i] = internal_data[(DATA_WIDTH-1-i)*POLYNOMIAL_WIDTH];
    end
  end

endmodule
