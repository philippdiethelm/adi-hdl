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

module header_inserter #(

  parameter AXIS_DATA_WIDTH = 512,
  parameter INPUT_WIDTH = 2048
) (

  input  wire                         clk,
  input  wire                         rstn,

  // Ethernet header
  input  wire [48-1:0]                ethernet_destination_MAC,
  input  wire [48-1:0]                ethernet_source_MAC,
  input  wire [16-1:0]                ethernet_type,

  // IPv4 header
  input  wire [4-1:0]                 ip_version,
  input  wire [4-1:0]                 ip_header_length,
  input  wire [8-1:0]                 ip_type_of_service,
  output reg  [16-1:0]                ip_total_length,
  input  wire [16-1:0]                ip_identification,
  input  wire [3-1:0]                 ip_flags,
  input  wire [13-1:0]                ip_fragment_offset,
  input  wire [8-1:0]                 ip_time_to_live,
  input  wire [8-1:0]                 ip_protocol,
  output reg  [16-1:0]                ip_header_checksum,
  input  wire [32-1:0]                ip_source_IP_address,
  input  wire [32-1:0]                ip_destination_IP_address,

  // UDP header
  input  wire [16-1:0]                udp_source,
  input  wire [16-1:0]                udp_destination,
  output reg [16-1:0]                 udp_length,
  input  wire [16-1:0]                udp_checksum,

  input  wire [16-1:0]                packet_size,

  // Control signals
  input  wire                         run_packetizer,
  input  wire                         packet_sent,

  // Input
  input  wire                         input_tvalid,
  output wire                         input_tready,
  input  wire [AXIS_DATA_WIDTH-1:0]   input_tdata,

  input  wire                         packet_tlast,

  // Output
  input  wire                         output_tready,
  output reg                          output_tvalid,
  output reg  [AXIS_DATA_WIDTH-1:0]   output_tdata,
  output reg  [AXIS_DATA_WIDTH/8-1:0] output_tkeep,
  output reg                          output_tlast
);

  localparam HEADER_LENGTH = 336;

  // hton implementation for dynamic byte range
  `define HTOND(length) \
    function [length-1:0] htond_``length``(input [length-1:0] data_in); \
      integer i; \
      begin \
        for (i=0; i<length/8; i=i+1) begin \
          htond_``length``[i*8+:8] = data_in[(length/8-1-i)*8+:8]; \
        end \
      end \
    endfunction

  `HTOND(16)
  `HTOND(32)
  `HTOND(48)

  wire [HEADER_LENGTH-1:0]     header;

  reg [32-1:0] ip_header_checksum_reg0;
  reg [32-1:0] ip_header_checksum_reg1;

  reg  [HEADER_LENGTH-1:0]     cdc_axis_tdata_reg;

  reg                          new_packet;
  reg                          tlast_sig;

  // temporary storage
  always @(posedge clk)
  begin
    if (!rstn) begin
      cdc_axis_tdata_reg <= {HEADER_LENGTH{1'b0}};
    end else begin
      if (input_tvalid && output_tready) begin
        cdc_axis_tdata_reg <= input_tdata[AXIS_DATA_WIDTH-1:AXIS_DATA_WIDTH-HEADER_LENGTH];
      end
    end
  end

  // ready signal generation
  assign input_tready = ~packet_tlast && output_tready;

  // header concatenation
  assign header = {
    htond_16(udp_checksum),
    htond_16(udp_length),
    htond_16(udp_destination),
    htond_16(udp_source),
    htond_32(ip_destination_IP_address),
    htond_32(ip_source_IP_address),
    htond_16(ip_header_checksum),
    htond_16({ip_time_to_live, ip_protocol}),
    htond_16({ip_flags, ip_fragment_offset}),
    htond_16(ip_identification),
    htond_16(ip_total_length),
    htond_16({ip_version, ip_header_length, ip_type_of_service}),
    htond_16(ethernet_type),
    htond_48(ethernet_source_MAC),
    htond_48(ethernet_destination_MAC)};

  // ip header checksum calculation
  always @(posedge clk)
  begin
    if (!rstn) begin
      ip_header_checksum_reg0 <= 'd0;
      ip_header_checksum_reg1 <= 'd0;
      ip_header_checksum <= 'd0;
    end else begin
      ip_header_checksum_reg0 <= {16'h0000, {ip_version, ip_header_length, ip_type_of_service}} +
        {16'h0000, ip_total_length} +
        {16'h0000, ip_identification} +
        {16'h0000, {ip_flags, ip_fragment_offset}} +
        {16'h0000, {ip_time_to_live, ip_protocol}} +
        {16'h0000, ip_source_IP_address[31:16]} +
        {16'h0000, ip_source_IP_address[15:0]} +
        {16'h0000, ip_destination_IP_address[31:16]} +
        {16'h0000, ip_destination_IP_address[15:0]};

      ip_header_checksum_reg1 <= ip_header_checksum_reg0[31:16] + ip_header_checksum_reg0[15:0];

      ip_header_checksum <= ~ip_header_checksum_reg1;
    end
  end

  // udp total length calculation
  always @(posedge clk)
  begin
    if (!rstn) begin
      udp_length <= 16'd0;
    end else begin
      udp_length <= 16'h8 + INPUT_WIDTH*packet_size/8;
    end
  end

  // ip total length calculation
  always @(posedge clk)
  begin
    if (!rstn) begin
      ip_total_length <= 16'h0;
    end else begin
      ip_total_length <= 4*ip_header_length + udp_length;
    end
  end

  // new packet marking
  always @(posedge clk)
  begin
    if (!rstn) begin
      new_packet <= 1'b1;
    end else begin
      if (output_tready && run_packetizer) begin
        if (packet_tlast) begin
          new_packet <= 1'b1;
        end else if (input_tvalid) begin
          new_packet <= 1'b0;
        end
      end
    end
  end

  integer j;
  reg [HEADER_LENGTH-1:0] reg_part1;
  reg [AXIS_DATA_WIDTH-1-HEADER_LENGTH:0] reg_part2;

  // raw data to network byte order
  always @(*)
  begin
    for (j=0; j<HEADER_LENGTH/16; j=j+1) begin
      reg_part1[j*16+:16] = htond_16(cdc_axis_tdata_reg[j*16+:16]);
    end
    for (j=0; j<(AXIS_DATA_WIDTH-HEADER_LENGTH)/16; j=j+1) begin
      reg_part2[j*16+:16] = htond_16(input_tdata[j*16+:16]);
    end
  end

  // header insertion
  always @(posedge clk)
  begin
    if (!rstn) begin
      output_tvalid <= 1'b0;
      output_tdata <= {AXIS_DATA_WIDTH-1{1'b0}};
      output_tkeep <= {AXIS_DATA_WIDTH/8-1{1'b0}};
      output_tlast <= 1'b0;
    end else begin
      if (output_tready && run_packetizer) begin
        // valid
        if (input_tvalid || packet_tlast) begin
          output_tvalid <= 1'b1;
        end else begin
          output_tvalid <= 1'b0;
        end
        // data, keep and last
        if (input_tvalid && input_tready) begin
          if (new_packet) begin
            output_tdata <= {reg_part2, header};
            output_tkeep <= {AXIS_DATA_WIDTH/8{1'b1}};
            output_tlast <= 1'b0;
          end else begin
            output_tdata <= {reg_part2, reg_part1};
            output_tkeep <= {AXIS_DATA_WIDTH/8{1'b1}};
            output_tlast <= 1'b0;
          end
        end else if (packet_tlast) begin
          output_tdata <= {{AXIS_DATA_WIDTH-HEADER_LENGTH{1'b0}}, reg_part1};
          output_tkeep <= {{(AXIS_DATA_WIDTH-HEADER_LENGTH)/8{1'b0}}, {HEADER_LENGTH/8{1'b1}}};
          output_tlast <= 1'b1;
        end
      end else begin
        // stop
        if (!run_packetizer && packet_sent) begin
          output_tvalid <= 1'b0;
        end
      end
    end
  end

endmodule
