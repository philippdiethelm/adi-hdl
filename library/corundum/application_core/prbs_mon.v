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

// Uses Ficonacci style LFSR

`timescale 1ns/100ps

module prbs_mon #(

  parameter DATA_WIDTH = 32,
  parameter POLYNOMIAL_WIDTH = 31
) (

  input  wire                        clk,
  input  wire                        rstn,

  input  wire [DATA_WIDTH-1:0]       input_data,
  input  wire                        input_valid,
  output reg                         error,

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

  reg state;  // 0 - Waiting for first value
              // 1 - Running

  reg  [DATA_WIDTH-1:0] internal_data;
  wire [DATA_WIDTH-1:0] calculated_prbs_data;

  prbs #(
    .DATA_WIDTH(DATA_WIDTH),
    .POLYNOMIAL_WIDTH(POLYNOMIAL_WIDTH)
  ) prbs_inst (
    .input_data(internal_data),
    .output_data(calculated_prbs_data),
    .polynomial(polynomial),
    .inverted(inverted)
  );

  always @(posedge clk)
  begin
    if (!rstn) begin
      internal_data <= {DATA_WIDTH{1'b0}};
      error <= 1'b0;
      state <= 1'b0;
    end else begin
      if (input_valid) begin
        if (!state) begin
          state <= 1'b1;
          internal_data <= input_data;
        end else begin
          internal_data <= calculated_prbs_data;
          if (input_data !== calculated_prbs_data) begin
            error <= 1'b1;
          end else begin
            error <= 1'b0;
          end
        end
      end
    end
  end

endmodule
