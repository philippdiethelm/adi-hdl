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

`include "macro_definitions.vh"

module application_rx #(

  // Structural configuration
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,

  // Ethernet interface configuration (direct, sync)
  parameter AXIS_DATA_WIDTH = 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter AXIS_RX_USER_WIDTH = 17,

  // Input stream
  parameter OUTPUT_WIDTH = 2048,
  parameter CHANNELS = 4
) (

  input  wire                            clk,
  input  wire                            rstn,

  // Ethernet (synchronous MAC interface - low latency raw traffic)
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]     s_axis_sync_rx_tdata,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]     s_axis_sync_rx_tkeep,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                     s_axis_sync_rx_tvalid,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                     s_axis_sync_rx_tready,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                     s_axis_sync_rx_tlast,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0]  s_axis_sync_rx_tuser,

  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]     m_axis_sync_rx_tdata,
  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]     m_axis_sync_rx_tkeep,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_rx_tvalid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_rx_tready,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_rx_tlast,
  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0]  m_axis_sync_rx_tuser,

  // Input data
  input  wire                            output_clk,
  input  wire                            output_rstn,

  output wire [OUTPUT_WIDTH-1:0]         output_axis_tdata,
  output wire                            output_axis_tvalid,
  input  wire                            output_axis_tready,

  input  wire [CHANNELS-1:0]             output_enable,

  input  wire                            start_app,
  input  wire [15:0]                     packet_size,

  // Ethernet header
  input  wire [48-1:0]                   ethernet_destination_MAC,
  input  wire [48-1:0]                   ethernet_source_MAC,
  input  wire [16-1:0]                   ethernet_type,

  // IPv4 header
  input  wire [4-1:0]                    ip_version,
  input  wire [4-1:0]                    ip_header_length,
  input  wire [8-1:0]                    ip_type_of_service,
  input  wire [16-1:0]                   ip_identification,
  input  wire [3-1:0]                    ip_flags,
  input  wire [13-1:0]                   ip_fragment_offset,
  input  wire [8-1:0]                    ip_time_to_live,
  input  wire [8-1:0]                    ip_protocol,
  input  wire [32-1:0]                   ip_source_IP_address,
  input  wire [32-1:0]                   ip_destination_IP_address,

  // UDP header
  input  wire [16-1:0]                   udp_source,
  input  wire [16-1:0]                   udp_destination,
  input  wire [16-1:0]                   udp_checksum
);

  `HTOND(16)

  ////----------------------------------------Data checking---------------//
  //////////////////////////////////////////////////

  // reg  [7:0]             gen_data;

  // reg  [OUTPUT_WIDTH-1:0] output_axis_tdata;
  // reg                    output_axis_tvalid;
  // wire                   output_axis_tready;

  // always @(posedge output_clk)
  // begin
  //   if (!output_rstn) begin
  //     gen_data <= 8'd0;
  //   end else begin
  //     if (output_axis_tready) begin
  //       gen_data <= gen_data + 1;
  //     end
  //   end
  // end

  // always @(posedge output_clk)
  // begin
  //   if (!output_rstn) begin
  //     output_axis_tdata <= {OUTPUT_WIDTH{1'b0}};
  //     output_axis_tvalid <= 1'b0;
  //   end else begin
  //     output_axis_tdata <= {OUTPUT_WIDTH/8{gen_data}};
  //     output_axis_tvalid <= 1'b1;
  //   end
  // end

  ////----------------------------------------Arbiter-------------------------//
  //////////////////////////////////////////////////

  wire valid;

  rx_arbiter #(
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .CHANNELS(CHANNELS)
  ) rx_arbiter_inst (
    .clk(clk),
    .rstn(rstn),
    .start_app(start_app),
    .packet_size(packet_size),
    .ethernet_destination_MAC(ethernet_destination_MAC),
    .ethernet_source_MAC(ethernet_source_MAC),
    .ethernet_type(ethernet_type),
    .ip_version(ip_version),
    .ip_header_length(ip_header_length),
    .ip_type_of_service(ip_type_of_service),
    .ip_identification(ip_identification),
    .ip_flags(ip_flags),
    .ip_fragment_offset(ip_fragment_offset),
    .ip_time_to_live(ip_time_to_live),
    .ip_protocol(ip_protocol),
    .ip_source_IP_address(ip_source_IP_address),
    .ip_destination_IP_address(ip_destination_IP_address),
    .udp_source(udp_source),
    .udp_destination(udp_destination),
    .udp_checksum(udp_checksum),
    .input_clk(output_clk),
    .input_rstn(output_rstn),
    .input_axis_tvalid(s_axis_sync_rx_tvalid),
    .input_axis_tready(s_axis_sync_rx_tready),
    .input_axis_tdata(s_axis_sync_rx_tdata),
    .input_axis_tlast(s_axis_sync_rx_tlast),
    .output_enable(output_enable),
    .valid(valid),
    .switch(switch));

  ////----------------------------------------Datapath switch-----------------//
  //////////////////////////////////////////////////
  reg [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]    axis_sync_rx_tdata_reg;
  reg [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]    axis_sync_rx_tkeep_reg;
  reg [IF_COUNT*PORTS_PER_IF-1:0]                    axis_sync_rx_tvalid_reg;
  reg [IF_COUNT*PORTS_PER_IF-1:0]                    axis_sync_rx_tready_reg;
  reg [IF_COUNT*PORTS_PER_IF-1:0]                    axis_sync_rx_tlast_reg;
  reg [IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH-1:0] axis_sync_rx_tuser_reg;

  always @(posedge clk)
  begin
    if (!rstn) begin
      axis_sync_rx_tdata_reg <= {IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH{1'b0}};
      axis_sync_rx_tkeep_reg <= {IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH{1'b0}};
      axis_sync_rx_tvalid_reg <= {IF_COUNT*PORTS_PER_IF{1'b0}};
      axis_sync_rx_tlast_reg <= {IF_COUNT*PORTS_PER_IF{1'b0}};
      axis_sync_rx_tuser_reg <= {IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH{1'b0}};
    end else begin
      axis_sync_rx_tdata_reg <= s_axis_sync_rx_tdata;
      axis_sync_rx_tkeep_reg <= s_axis_sync_rx_tkeep;
      axis_sync_rx_tvalid_reg <= s_axis_sync_rx_tvalid;
      axis_sync_rx_tlast_reg <= s_axis_sync_rx_tlast;
      axis_sync_rx_tuser_reg <= s_axis_sync_rx_tuser;
    end
  end

  localparam HEADER_LENGTH = 336;

  reg  [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]    input_axis_tdata_reg [1:0];
  reg  [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]    input_axis_tkeep_reg [1:0];
  reg  [IF_COUNT*PORTS_PER_IF-1:0]                    input_axis_tvalid_reg [1:0];
  wire [IF_COUNT*PORTS_PER_IF-1:0]                    input_axis_tready_reg;
  reg  [IF_COUNT*PORTS_PER_IF-1:0]                    input_axis_tlast_reg;


  integer j;
  reg [HEADER_LENGTH-1:0] reg_part1;
  reg [AXIS_DATA_WIDTH-1-HEADER_LENGTH:0] reg_part2;

  // raw data to network byte order
  always @(*)
  begin
    for (j=0; j<HEADER_LENGTH/16; j=j+1) begin
      reg_part1[j*16+:16] = htond_16(axis_sync_rx_tdata_reg[j*16+:16]);
    end
    for (j=0; j<(AXIS_DATA_WIDTH-HEADER_LENGTH)/16; j=j+1) begin
      reg_part2[j*16+:16] = htond_16(axis_sync_rx_tdata_reg[j*16+:16]);
    end
  end

  always @(posedge clk)
  begin
    if (!rstn) begin
      m_axis_sync_rx_tdata <= {IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH{1'b0}};
      m_axis_sync_rx_tkeep <= {IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH{1'b0}};
      m_axis_sync_rx_tvalid <= {IF_COUNT*PORTS_PER_IF{1'b0}};
      axis_sync_rx_tready_reg <= {IF_COUNT*PORTS_PER_IF{1'b0}};
      m_axis_sync_rx_tlast <= {IF_COUNT*PORTS_PER_IF{1'b0}};
      m_axis_sync_rx_tuser <= {IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH{1'b0}};
    end else begin
      if (!switch) begin
        m_axis_sync_rx_tdata <= axis_sync_rx_tdata_reg;
        m_axis_sync_rx_tkeep <= axis_sync_rx_tkeep_reg;
        m_axis_sync_rx_tvalid <= axis_sync_rx_tvalid_reg;
        m_axis_sync_rx_tlast <= axis_sync_rx_tlast_reg;
        m_axis_sync_rx_tuser <= axis_sync_rx_tuser_reg;

        input_axis_tdata_reg[0] <= {IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH{1'b0}};
        input_axis_tkeep_reg[0] <= {IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH{1'b0}};
        input_axis_tvalid_reg[0] <= {IF_COUNT*PORTS_PER_IF{1'b0}};
        input_axis_tlast_reg <= {IF_COUNT*PORTS_PER_IF{1'b0}};

        input_axis_tdata_reg[1] <= {IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH{1'b0}};
        input_axis_tkeep_reg[1] <= {IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH{1'b0}};
        input_axis_tvalid_reg[1] <= {IF_COUNT*PORTS_PER_IF{1'b0}};

        axis_sync_rx_tready_reg <= m_axis_sync_rx_tready;
      end else begin
        m_axis_sync_rx_tdata <= {IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH{1'b0}};
        m_axis_sync_rx_tkeep <= {IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH{1'b0}};
        m_axis_sync_rx_tvalid <= {IF_COUNT*PORTS_PER_IF{1'b0}};
        m_axis_sync_rx_tlast <= {IF_COUNT*PORTS_PER_IF{1'b0}};
        m_axis_sync_rx_tuser <= {IF_COUNT*PORTS_PER_IF*AXIS_RX_USER_WIDTH{1'b0}};

        if (valid) begin
          axis_sync_rx_tready_reg <= {IF_COUNT*PORTS_PER_IF{1'b1}};

          input_axis_tdata_reg[0] <= {IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH{1'b0}};
          input_axis_tkeep_reg[0] <= {IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH{1'b0}};
          input_axis_tvalid_reg[0] <= {IF_COUNT*PORTS_PER_IF{1'b0}};

          input_axis_tdata_reg[1] <= {IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH{1'b0}};
          input_axis_tkeep_reg[1] <= {IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH{1'b0}};
          input_axis_tvalid_reg[1] <= {IF_COUNT*PORTS_PER_IF{1'b0}};

          input_axis_tlast_reg <= {IF_COUNT*PORTS_PER_IF{1'b0}};
        end else begin
          // header extraction
          input_axis_tdata_reg[0] <= reg_part1;
          input_axis_tkeep_reg[0] <= axis_sync_rx_tkeep_reg[AXIS_DATA_WIDTH/8-1:(AXIS_DATA_WIDTH-HEADER_LENGTH)/8];
          input_axis_tvalid_reg[0] <= axis_sync_rx_tvalid_reg;

          input_axis_tdata_reg[1] <= {input_axis_tdata_reg[0], reg_part2};
          input_axis_tkeep_reg[1] <= {input_axis_tkeep_reg[0], axis_sync_rx_tkeep_reg[(AXIS_DATA_WIDTH-HEADER_LENGTH)/8-1:0]};
          input_axis_tvalid_reg[1] <= input_axis_tvalid_reg[0];

          input_axis_tlast_reg <= axis_sync_rx_tlast_reg;

          axis_sync_rx_tready_reg <= input_axis_tready_reg;
        end
      end
    end
  end

  assign s_axis_sync_rx_tready = axis_sync_rx_tready_reg;

  ////----------------------------------------Buffer, CDC and Scaling FIFO----//
  //////////////////////////////////////////////////

  util_axis_fifo_asym #(
    .ASYNC_CLK(1),
    .S_DATA_WIDTH(AXIS_DATA_WIDTH),
    .ADDRESS_WIDTH($clog2(8192/OUTPUT_WIDTH)+1),
    .M_DATA_WIDTH(OUTPUT_WIDTH),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(0),
    .ALMOST_FULL_THRESHOLD(0),
    .TLAST_EN(1),
    .TKEEP_EN(1),
    .FIFO_LIMITED(0),
    .ADDRESS_WIDTH_PERSPECTIVE(1)
  ) cdc_scale_fifo (
    .m_axis_aclk(output_clk),
    .m_axis_aresetn(output_rstn),
    .m_axis_ready(output_axis_tready),
    .m_axis_valid(output_axis_tvalid),
    .m_axis_data(output_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tlast(),
    .m_axis_empty(),
    .m_axis_almost_empty(),
    .m_axis_level(),

    .s_axis_aclk(clk),
    .s_axis_aresetn(rstn),
    .s_axis_ready(input_axis_tready_reg),
    .s_axis_valid(input_axis_tvalid_reg[1]),
    .s_axis_data(input_axis_tdata_reg[1]),
    .s_axis_tkeep(input_axis_tkeep_reg[1]),
    .s_axis_tlast(input_axis_tlast_reg),
    .s_axis_full(),
    .s_axis_almost_full(),
    .s_axis_room());

endmodule
