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

module application_tx #(

  // Structural configuration
  parameter IF_COUNT = 1,
  parameter PORTS_PER_IF = 1,

  // Ethernet interface configuration (direct, sync)
  parameter AXIS_DATA_WIDTH = 512,
  parameter AXIS_KEEP_WIDTH = AXIS_DATA_WIDTH/8,
  parameter AXIS_TX_USER_WIDTH = 17,

  // Input stream
  parameter INPUT_WIDTH = 2048,
  parameter CHANNELS = 4
) (

  input  wire                            clk,
  input  wire                            rstn,

  // Ethernet (synchronous MAC interface - low latency raw traffic)
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]     s_axis_sync_tx_tdata,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]     s_axis_sync_tx_tkeep,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                     s_axis_sync_tx_tvalid,
  output wire [IF_COUNT*PORTS_PER_IF-1:0]                     s_axis_sync_tx_tready,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                     s_axis_sync_tx_tlast,
  input  wire [IF_COUNT*PORTS_PER_IF*AXIS_TX_USER_WIDTH-1:0]  s_axis_sync_tx_tuser,

  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_DATA_WIDTH-1:0]     m_axis_sync_tx_tdata,
  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_KEEP_WIDTH-1:0]     m_axis_sync_tx_tkeep,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_tx_tvalid,
  input  wire [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_tx_tready,
  output reg  [IF_COUNT*PORTS_PER_IF-1:0]                     m_axis_sync_tx_tlast,
  output reg  [IF_COUNT*PORTS_PER_IF*AXIS_TX_USER_WIDTH-1:0]  m_axis_sync_tx_tuser,

  // Input data
  input  wire                            input_clk,
  input  wire                            input_rstn,

  input  wire [INPUT_WIDTH-1:0]          input_axis_tdata,
  input  wire                            input_axis_tvalid,
  output wire                            input_axis_tready,

  input  wire [CHANNELS-1:0]             input_enable,

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
  output wire [16-1:0]                   ip_total_length,
  input  wire [16-1:0]                   ip_identification,
  input  wire [3-1:0]                    ip_flags,
  input  wire [13-1:0]                   ip_fragment_offset,
  input  wire [8-1:0]                    ip_time_to_live,
  input  wire [8-1:0]                    ip_protocol,
  output wire [16-1:0]                   ip_header_checksum,
  input  wire [32-1:0]                   ip_source_IP_address,
  input  wire [32-1:0]                   ip_destination_IP_address,

  // UDP header
  input  wire [16-1:0]                   udp_source,
  input  wire [16-1:0]                   udp_destination,
  output wire [16-1:0]                   udp_length,
  input  wire [16-1:0]                   udp_checksum
);

  ////----------------------------------------Data generation---------------//
  //////////////////////////////////////////////////

  // reg  [7:0]             gen_data;

  // reg  [INPUT_WIDTH-1:0] input_axis_tdata;
  // reg                    input_axis_tvalid;
  // wire                   input_axis_tready;

  // always @(posedge input_clk)
  // begin
  //   if (!input_rstn) begin
  //     gen_data <= 8'd0;
  //   end else begin
  //     if (input_axis_tready) begin
  //       gen_data <= gen_data + 1;
  //     end
  //   end
  // end

  // always @(posedge input_clk)
  // begin
  //   if (!input_rstn) begin
  //     input_axis_tdata <= {INPUT_WIDTH{1'b0}};
  //     input_axis_tvalid <= 1'b0;
  //   end else begin
  //     input_axis_tdata <= {INPUT_WIDTH/8{gen_data}};
  //     input_axis_tvalid <= 1'b1;
  //   end
  // end

  ////----------------------------------------Start application---------------//
  //////////////////////////////////////////////////

  reg  run_packetizer;
  wire run_packetizer_cdc;

  wire input_rstn_gated;
  wire rstn_gated;

  wire input_axis_tready_buffered;

  wire packet_tlast;

  always @(posedge clk)
  begin
    if (!rstn) begin
      run_packetizer <= 1'b0;
    end else begin
      if (start_app) begin
        run_packetizer <= 1'b1;
      end else if (packet_tlast) begin
        run_packetizer <= 1'b0;
      end
    end
  end

  sync_bits #(
    .NUM_OF_BITS(1)
  ) sync_bits_run_packetizer (
    .in_bits(run_packetizer),
    .out_resetn(input_rstn),
    .out_clk(input_clk),
    .out_bits(run_packetizer_cdc)
  );

  assign input_rstn_gated = input_rstn && run_packetizer_cdc;
  assign rstn_gated = rstn && run_packetizer;

  assign input_axis_tready = input_axis_tready_buffered && run_packetizer_cdc;

  ////----------------------------------------Buffer, CDC and Scaling FIFO----//
  //////////////////////////////////////////////////

  wire                       cdc_axis_tvalid;
  wire                       cdc_axis_tready;
  wire [AXIS_DATA_WIDTH-1:0] cdc_axis_tdata;

  util_axis_fifo_asym #(
    .ASYNC_CLK(1),
    .S_DATA_WIDTH(INPUT_WIDTH),
    .ADDRESS_WIDTH($clog2(8192/INPUT_WIDTH)+1),
    .M_DATA_WIDTH(AXIS_DATA_WIDTH),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(0),
    .ALMOST_FULL_THRESHOLD(0),
    .TLAST_EN(0),
    .TKEEP_EN(0),
    .FIFO_LIMITED(0),
    .ADDRESS_WIDTH_PERSPECTIVE(1)
  ) cdc_scale_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(rstn_gated),
    .m_axis_ready(cdc_axis_tready),
    .m_axis_valid(cdc_axis_tvalid),
    .m_axis_data(cdc_axis_tdata),
    .m_axis_tkeep(),
    .m_axis_tlast(),
    .m_axis_empty(),
    .m_axis_almost_empty(),
    .m_axis_level(),

    .s_axis_aclk(input_clk),
    .s_axis_aresetn(input_rstn_gated),
    .s_axis_ready(input_axis_tready_buffered),
    .s_axis_valid(input_axis_tvalid),
    .s_axis_data(input_axis_tdata),
    .s_axis_tkeep({INPUT_WIDTH/8{1'b0}}),
    .s_axis_tlast(1'b0),
    .s_axis_full(),
    .s_axis_almost_full(),
    .s_axis_room());

  ////----------------------------------------Packetizer--------------------//
  //////////////////////////////////////////////////

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

  packetizer #(
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .CHANNELS(CHANNELS)
  ) packetizer_inst (
    .clk(clk),
    .rstn(rstn),
    .input_axis_tvalid(cdc_axis_tvalid),
    .input_axis_tready(cdc_axis_tready),
    .input_enable(input_enable_cdc),
    .packet_size(packet_size),
    .packet_tlast(packet_tlast));

  ////----------------------------------------Header Inserter---------------//
  //////////////////////////////////////////////////

  wire                         packet_axis_tvalid;
  wire                         packet_axis_tready;
  wire [AXIS_DATA_WIDTH-1:0]   packet_axis_tdata;
  wire [AXIS_DATA_WIDTH/8-1:0] packet_axis_tkeep;
  wire                         packet_axis_tlast;

  reg                          packet_buffer_axis_tready;
  wire                         packet_buffer_axis_tvalid;
  wire [AXIS_DATA_WIDTH-1:0]   packet_buffer_axis_tdata;
  wire                         packet_buffer_axis_tlast;
  wire [AXIS_DATA_WIDTH/8-1:0] packet_buffer_axis_tkeep;

  wire packet_sent;

  assign packet_sent = packet_buffer_axis_tready && packet_buffer_axis_tvalid && packet_buffer_axis_tlast;

  header_inserter #(
    .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
    .INPUT_WIDTH(INPUT_WIDTH)
  ) header_inserter_inst (
    .clk(clk),
    .rstn(rstn),
    .ethernet_destination_MAC(ethernet_destination_MAC),
    .ethernet_source_MAC(ethernet_source_MAC),
    .ethernet_type(ethernet_type),
    .ip_version(ip_version),
    .ip_header_length(ip_header_length),
    .ip_type_of_service(ip_type_of_service),
    .ip_total_length(ip_total_length),
    .ip_identification(ip_identification),
    .ip_flags(ip_flags),
    .ip_fragment_offset(ip_fragment_offset),
    .ip_time_to_live(ip_time_to_live),
    .ip_protocol(ip_protocol),
    .ip_header_checksum(ip_header_checksum),
    .ip_source_IP_address(ip_source_IP_address),
    .ip_destination_IP_address(ip_destination_IP_address),
    .udp_source(udp_source),
    .udp_destination(udp_destination),
    .udp_length(udp_length),
    .udp_checksum(udp_checksum),
    .input_enable(input_enable),
    .packet_size(packet_size),
    .run_packetizer(run_packetizer),
    .packet_sent(packet_sent),
    .input_axis_tvalid(cdc_axis_tvalid),
    .input_axis_tready(cdc_axis_tready),
    .input_axis_tdata(cdc_axis_tdata),
    .packet_tlast(packet_tlast),
    .output_axis_tready(packet_axis_tready),
    .output_axis_tvalid(packet_axis_tvalid),
    .output_axis_tdata(packet_axis_tdata),
    .output_axis_tkeep(packet_axis_tkeep),
    .output_axis_tlast(packet_axis_tlast));

  ////----------------------------------------Packet Buffer FIFO----------------------//
  //////////////////////////////////////////////////

  wire packet_buffer_almost_full;
  wire packet_buffer_almost_empty;

  wire packet_fifo_rstn;

  assign packet_fifo_rstn = rstn && !(!run_packetizer && packet_buffer_axis_tready && packet_buffer_axis_tvalid && packet_buffer_axis_tlast);

  util_axis_fifo #(
    .DATA_WIDTH(AXIS_DATA_WIDTH),
    .ADDRESS_WIDTH($clog2(8192/AXIS_DATA_WIDTH)+1),
    .ASYNC_CLK(0),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(8192/AXIS_DATA_WIDTH),
    .ALMOST_FULL_THRESHOLD(8192/AXIS_DATA_WIDTH),
    .TLAST_EN(1),
    .TKEEP_EN(1),
    .REMOVE_NULL_BEAT_EN(0)
  ) packet_buffer_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(packet_fifo_rstn),
    .m_axis_ready(packet_buffer_axis_tready),
    .m_axis_valid(packet_buffer_axis_tvalid),
    .m_axis_data(packet_buffer_axis_tdata),
    .m_axis_tkeep(packet_buffer_axis_tkeep),
    .m_axis_tlast(packet_buffer_axis_tlast),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(packet_buffer_almost_empty),

    .s_axis_aclk(clk),
    .s_axis_aresetn(packet_fifo_rstn),
    .s_axis_ready(packet_axis_tready),
    .s_axis_valid(packet_axis_tvalid),
    .s_axis_data(packet_axis_tdata),
    .s_axis_tkeep(packet_axis_tkeep),
    .s_axis_tlast(packet_axis_tlast),
    .s_axis_room(),
    .s_axis_full(),
    .s_axis_almost_full(packet_buffer_almost_full));

  ////----------------------------------------OS Buffer FIFO----------------------//
  //////////////////////////////////////////////////

  reg                           os_buffer_axis_tready;
  wire                          os_buffer_axis_tvalid;
  wire [AXIS_DATA_WIDTH-1:0]    os_buffer_axis_tdata;
  wire                          os_buffer_axis_tlast;
  wire [AXIS_DATA_WIDTH/8-1:0]  os_buffer_axis_tkeep;
  wire [AXIS_TX_USER_WIDTH-1:0] os_buffer_axis_tuser;

  util_axis_fifo #(
    .DATA_WIDTH(AXIS_DATA_WIDTH/8*9 + AXIS_TX_USER_WIDTH),
    .ADDRESS_WIDTH($clog2(12288/AXIS_DATA_WIDTH)+1),
    .ASYNC_CLK(0),
    .M_AXIS_REGISTERED(1),
    .ALMOST_EMPTY_THRESHOLD(),
    .ALMOST_FULL_THRESHOLD(),
    .TLAST_EN(1),
    .TKEEP_EN(0),
    .REMOVE_NULL_BEAT_EN(0)
  ) os_buffer_fifo (
    .m_axis_aclk(clk),
    .m_axis_aresetn(rstn),
    .m_axis_ready(os_buffer_axis_tready),
    .m_axis_valid(os_buffer_axis_tvalid),
    .m_axis_data({os_buffer_axis_tdata, os_buffer_axis_tkeep, os_buffer_axis_tuser}),
    .m_axis_tkeep(),
    .m_axis_tlast(os_buffer_axis_tlast),
    .m_axis_level(),
    .m_axis_empty(),
    .m_axis_almost_empty(),

    .s_axis_aclk(clk),
    .s_axis_aresetn(rstn),
    .s_axis_ready(s_axis_sync_tx_tready),
    .s_axis_valid(s_axis_sync_tx_tvalid),
    .s_axis_data({s_axis_sync_tx_tdata, s_axis_sync_tx_tkeep, s_axis_sync_tx_tuser}),
    .s_axis_tkeep(),
    .s_axis_tlast(s_axis_sync_tx_tlast),
    .s_axis_room(),
    .s_axis_full(),
    .s_axis_almost_full());

  // Datapath switch
  reg datapath_switch; // 0 - OS
                       // 1 - Packet

  always @(posedge clk)
  begin
    if (!rstn) begin
      datapath_switch <= 1'b0;
    end else begin
      if ((packet_buffer_almost_empty || !run_packetizer) && (packet_buffer_axis_tready && packet_buffer_axis_tvalid && packet_buffer_axis_tlast) || !packet_fifo_rstn) begin
        datapath_switch <= 1'b0;
      end else if (packet_buffer_almost_full && (!os_buffer_axis_tvalid || (os_buffer_axis_tready && os_buffer_axis_tvalid && os_buffer_axis_tlast))) begin
        datapath_switch <= 1'b1;
      end
    end
  end

  always @(*)
  begin
    if (!datapath_switch) begin
      m_axis_sync_tx_tdata = os_buffer_axis_tdata;
      m_axis_sync_tx_tkeep = os_buffer_axis_tkeep;
      m_axis_sync_tx_tvalid = os_buffer_axis_tvalid;
      os_buffer_axis_tready = m_axis_sync_tx_tready;
      m_axis_sync_tx_tlast = os_buffer_axis_tlast;
      m_axis_sync_tx_tuser = s_axis_sync_tx_tuser;

      packet_buffer_axis_tready = 1'b0;
    end else begin
      m_axis_sync_tx_tdata = packet_buffer_axis_tdata;
      m_axis_sync_tx_tkeep = packet_buffer_axis_tkeep;
      m_axis_sync_tx_tvalid = packet_buffer_axis_tvalid;
      packet_buffer_axis_tready = m_axis_sync_tx_tready;
      m_axis_sync_tx_tlast = packet_buffer_axis_tlast;
      m_axis_sync_tx_tuser = 1'b0;

      os_buffer_axis_tready = 1'b0;
    end
  end

endmodule
