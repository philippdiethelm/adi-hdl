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

module packetizer #(

  parameter AXIS_DATA_WIDTH = 512,
  parameter CHANNELS = 4
) (

  input  wire                         clk,
  input  wire                         rstn,

  input  wire                         input_clk,
  input  wire                         input_rstn,

  // input
  input  wire                         input_axis_tvalid,
  input  wire                         input_axis_tready,

  input  wire [CHANNELS-1:0]          input_enable,
  input  wire [15:0]                  packet_size,
  output reg                          packet_tlast
);

  reg  [15:0] sample_counter;
  reg  [15:0] packet_size_dynamic;
  wire [15:0] packet_size_dynamic_calc;

  reg  [CHANNELS-1:0] input_enable_old;
  reg                 input_enable_ff;
  wire                input_enable_ff_cdc;
  reg                 input_enable_ff_cdc2;
  reg  [CHANNELS-1:0] input_enable_cdc;

  always @(posedge input_clk)
  begin
    if (!input_rstn) begin
      input_enable_ff <= 1'b0;
    end else begin
      input_enable_old <= input_enable;
      if (input_enable_old != input_enable) begin
        input_enable_ff <= ~input_enable_ff;
      end
    end
  end

  sync_bits #(
    .NUM_OF_BITS(1)
  ) sync_bits_input_enable_ff (
    .in_bits(input_enable_ff),
    .out_resetn(rstn),
    .out_clk(clk),
    .out_bits(input_enable_ff_cdc)
  );

  always @(posedge clk)
  begin
    if (!rstn) begin
      input_enable_ff_cdc2 <= 1'b0;
    end else begin
      input_enable_ff_cdc2 <= input_enable_ff_cdc;
    end
  end

  always @(posedge clk)
  begin
    if (!rstn) begin
      input_enable_cdc <= {CHANNELS{1'b0}};
    end else begin
      if (input_enable_ff_cdc2 ^ input_enable_ff_cdc) begin
        input_enable_cdc <= input_enable;
      end
    end
  end

  function [$clog2(CHANNELS):0] converters(input [CHANNELS-1:0] input_enable);
    integer i;
    begin
      converters = 0;
      for (i=0; i<CHANNELS; i=i+1) begin
        converters = converters + input_enable[i];
      end
    end
  endfunction

  assign packet_size_dynamic_calc = (packet_size/AXIS_DATA_WIDTH*8/(2**$clog2(CHANNELS)))*converters(input_enable_cdc);

  always @(posedge clk)
  begin
    if (!rstn) begin
      packet_size_dynamic <= packet_size;
    end else begin
      packet_size_dynamic <= packet_size_dynamic_calc;
    end
  end

  always @(posedge clk)
  begin
    if (!rstn) begin
      sample_counter <= 8'd0;
      packet_tlast <= 1'b0;
    end else begin
      if (input_axis_tvalid && input_axis_tready) begin
        if (sample_counter < packet_size_dynamic-1) begin
          sample_counter <= sample_counter + 1;
        end else begin
          sample_counter <= 8'd0;
          packet_tlast <= 1'b1;
        end
      end else begin
        packet_tlast <= 1'b0;
      end
    end
  end

endmodule
