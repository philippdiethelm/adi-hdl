###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

if {![info exists ADI_PHY_SEL]} {
  set ADI_PHY_SEL 1
}

if {![info exists INTF_CFG]} {
  set INTF_CFG RXTX
}

if {![info exists TRANSCEIVER_TYPE]} {
  set TRANSCEIVER_TYPE GTY
}

set JESD_MODE  $ad_project_params(JESD_MODE)
set TX_LANE_RATE $ad_project_params(TX_LANE_RATE)
set RX_LANE_RATE $ad_project_params(RX_LANE_RATE)

set TX_NUM_LINKS $ad_project_params(TX_NUM_LINKS)
set RX_NUM_LINKS $ad_project_params(RX_NUM_LINKS)

set TX_JESD_L $ad_project_params(TX_JESD_L)
set TX_JESD_M $ad_project_params(TX_JESD_M)

set RX_JESD_L $ad_project_params(RX_JESD_L)
set RX_JESD_M $ad_project_params(RX_JESD_M)

# TX parameters
set TX_NUM_OF_LANES [expr $TX_JESD_L * $TX_NUM_LINKS]      ; # L
set TX_NUM_OF_CONVERTERS [expr $TX_JESD_M * $TX_NUM_LINKS] ; # M
set TX_SAMPLES_PER_FRAME $ad_project_params(TX_JESD_S)     ; # S
set TX_SAMPLE_WIDTH 16                                     ; # N/NP

set TX_SAMPLES_PER_CHANNEL [expr $TX_NUM_OF_LANES * 32 / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)] ; # L * 32 / (M * N)

# RX parameters
set RX_NUM_OF_LANES [expr $RX_JESD_L * $RX_NUM_LINKS]      ; # L
set RX_NUM_OF_CONVERTERS [expr $RX_JESD_M * $RX_NUM_LINKS] ; # M
set RX_SAMPLES_PER_FRAME $ad_project_params(RX_JESD_S)     ; # S
set RX_SAMPLE_WIDTH 16                                     ; # N/NP

set RX_SAMPLES_PER_CHANNEL [expr $RX_NUM_OF_LANES * 32 / ($RX_NUM_OF_CONVERTERS * $RX_SAMPLE_WIDTH)] ; # L * 32 / (M * N)

set dac_fifo_name axi_adrv9026_dacfifo
set dac_data_width [expr 32*$TX_NUM_OF_LANES]
set dac_dma_data_width 128

if {$JESD_MODE == "8B10B"} {
  set DATAPATH_WIDTH 4
  set NP12_DATAPATH_WIDTH 6
  set ENCODER_SEL 1
} else {
  set DATAPATH_WIDTH 8
  set NP12_DATAPATH_WIDTH 12
  set ENCODER_SEL 2
}

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# adrv9026

create_bd_port -dir I dac_fifo_bypass
create_bd_port -dir I core_clk

# dac peripherals
if {$ADI_PHY_SEL == 1} {

  ad_ip_instance axi_adxcvr axi_adrv9026_tx_xcvr
  ad_ip_parameter axi_adrv9026_tx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
  ad_ip_parameter axi_adrv9026_tx_xcvr CONFIG.NUM_OF_LANES $TX_NUM_OF_LANES
  ad_ip_parameter axi_adrv9026_tx_xcvr CONFIG.QPLL_ENABLE 1
  ad_ip_parameter axi_adrv9026_tx_xcvr CONFIG.TX_OR_RX_N 1
  ad_ip_parameter axi_adrv9026_tx_xcvr CONFIG.SYS_CLK_SEL 3
  ad_ip_parameter axi_adrv9026_tx_xcvr CONFIG.OUT_CLK_SEL 3
}

adi_axi_jesd204_tx_create axi_adrv9026_tx_jesd $TX_NUM_OF_LANES $TX_NUM_LINKS $ENCODER_SEL

ad_ip_instance util_upack2 util_adrv9026_tx_upack [list \
  NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
]

adi_tpl_jesd204_tx_create tx_adrv9026_tpl_core $TX_NUM_OF_LANES \
                                               $TX_NUM_OF_CONVERTERS \
                                               $TX_SAMPLES_PER_FRAME \
                                               $TX_SAMPLE_WIDTH

ad_ip_instance axi_dmac axi_adrv9026_tx_dma
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.ASYNC_CLK_DEST_REQ 1
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.ASYNC_CLK_SRC_DEST 1
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.ASYNC_CLK_REQ_SRC 1
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_dma_data_width
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.MAX_BYTES_PER_BURST 256
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.DMA_DATA_WIDTH_SRC 128
ad_ip_parameter axi_adrv9026_tx_dma CONFIG.FIFO_SIZE 32

ad_dacfifo_create $dac_fifo_name $dac_data_width $dac_dma_data_width $dac_fifo_address_width
if {$ADI_PHY_SEL == 1} {
# adc peripherals
  ad_ip_instance axi_adxcvr axi_adrv9026_rx_xcvr
  ad_ip_parameter axi_adrv9026_rx_xcvr CONFIG.LINK_MODE $ENCODER_SEL
  ad_ip_parameter axi_adrv9026_rx_xcvr CONFIG.NUM_OF_LANES $RX_NUM_OF_LANES
  ad_ip_parameter axi_adrv9026_rx_xcvr CONFIG.QPLL_ENABLE 0
  ad_ip_parameter axi_adrv9026_rx_xcvr CONFIG.TX_OR_RX_N 0
  ad_ip_parameter axi_adrv9026_rx_xcvr CONFIG.SYS_CLK_SEL 0
  ad_ip_parameter axi_adrv9026_rx_xcvr CONFIG.OUT_CLK_SEL 3
}
if {$ADI_PHY_SEL == 0} {
  # reset generator
  ad_ip_instance proc_sys_reset core_clk_rstgen
  ad_connect  core_clk core_clk_rstgen/slowest_sync_clk
  ad_connect  $sys_cpu_resetn core_clk_rstgen/ext_reset_in
}

adi_axi_jesd204_rx_create axi_adrv9026_rx_jesd $RX_NUM_OF_LANES $RX_NUM_LINKS $ENCODER_SEL

ad_ip_instance util_cpack2 util_adrv9026_rx_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
  ]

adi_tpl_jesd204_rx_create rx_adrv9026_tpl_core $RX_NUM_OF_LANES \
                                               $RX_NUM_OF_CONVERTERS \
                                               $RX_SAMPLES_PER_FRAME \
                                               $RX_SAMPLE_WIDTH

ad_ip_instance axi_dmac axi_adrv9026_rx_dma
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.ASYNC_CLK_DEST_REQ 1
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.ASYNC_CLK_SRC_DEST 1
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.ASYNC_CLK_REQ_SRC 1
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.DMA_DATA_WIDTH_SRC [expr 32*$RX_NUM_OF_LANES]
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.MAX_BYTES_PER_BURST 256
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.DMA_DATA_WIDTH_DEST 128
ad_ip_parameter axi_adrv9026_rx_dma CONFIG.FIFO_SIZE 32

# xcvr interfaces

set tx_ref_clk         tx_ref_clk_0
set rx_ref_clk         rx_ref_clk_0

create_bd_port -dir I $tx_ref_clk
create_bd_port -dir I $rx_ref_clk

# common cores
if {$ADI_PHY_SEL == 1} {
  ad_ip_instance util_adxcvr util_adrv9026_xcvr
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_NUM_OF_LANES $RX_NUM_OF_LANES
  ad_ip_parameter util_adrv9026_xcvr CONFIG.LINK_MODE $ENCODER_SEL
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_LANE_RATE $RX_LANE_RATE
  ad_ip_parameter util_adrv9026_xcvr CONFIG.TX_LANE_RATE $TX_LANE_RATE
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_OUT_DIV 1
  ad_ip_parameter util_adrv9026_xcvr CONFIG.TX_NUM_OF_LANES $TX_NUM_OF_LANES
  ad_ip_parameter util_adrv9026_xcvr CONFIG.TX_OUT_DIV 1
  ad_ip_parameter util_adrv9026_xcvr CONFIG.CPLL_FBDIV 4
  ad_ip_parameter util_adrv9026_xcvr CONFIG.CPLL_FBDIV_4_5 5
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_CLK25_DIV 10
  ad_ip_parameter util_adrv9026_xcvr CONFIG.TX_CLK25_DIV 10
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_PMA_CFG 0x001E7080
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_CDR_CFG 0x0b000023ff10400020
  ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_FBDIV 40
  ad_ip_parameter util_adrv9026_xcvr CONFIG.QPLL_REFCLK_DIV 1
  ad_ip_parameter util_adrv9026_xcvr CONFIG.TX_LANE_INVERT 6
  ad_ip_parameter util_adrv9026_xcvr CONFIG.RX_LANE_INVERT 15
}  else {
  source ../common/versal_transceiver.tcl

  set REF_CLK_RATE [ expr { [info exists ad_project_params(REF_CLK_RATE)] \
                            ? $ad_project_params(REF_CLK_RATE) : 245.76 } ]

  create_bd_port -dir I gt_reset
  create_bd_port -dir O gt_powergood
  create_bd_port -dir O rx_resetdone
  create_bd_port -dir O tx_resetdone
  create_bd_port -dir I gt_reset_rx_pll_and_datapath
  create_bd_port -dir I gt_reset_tx_pll_and_datapath
  create_bd_port -dir I gt_reset_rx_datapath
  create_bd_port -dir I gt_reset_tx_datapath

  switch $INTF_CFG {
    "RXTX" {
      create_versal_phy jesd204_phy_rxtx $JESD_MODE $RX_NUM_OF_LANES $TX_NUM_OF_LANES $RX_LANE_RATE $TX_LANE_RATE $REF_CLK_RATE $TRANSCEIVER_TYPE $INTF_CFG
      set rx_phy jesd204_phy_rxtx
      set tx_phy jesd204_phy_rxtx
      ad_connect $rx_ref_clk     ${rx_phy}/GT_REFCLK
      ad_connect gt_reset        ${rx_phy}/gtreset_in
      ad_connect $sys_cpu_clk    ${rx_phy}/s_axi_clk
      ad_connect $sys_cpu_resetn ${rx_phy}/s_axi_resetn
      ad_connect ${rx_phy}/gtpowergood gt_powergood
      ad_connect ${rx_phy}/gtreset_rx_datapath gt_reset_rx_datapath
      ad_connect ${rx_phy}/gtreset_tx_datapath gt_reset_tx_datapath
      ad_connect ${rx_phy}/gtreset_rx_pll_and_datapath gt_reset_rx_pll_and_datapath
      ad_connect ${rx_phy}/gtreset_tx_pll_and_datapath gt_reset_tx_pll_and_datapath
      ad_connect ${rx_phy}/rx_resetdone rx_resetdone
      ad_connect ${tx_phy}/tx_resetdone tx_resetdone
    }
    "RX" {
      create_versal_phy jesd204_phy_rx $JESD_MODE $RX_NUM_OF_LANES $RX_NUM_OF_LANES $RX_LANE_RATE $TX_LANE_RATE $REF_CLK_RATE $TRANSCEIVER_TYPE $INTF_CFG
      set rx_phy jesd204_phy_rx
      ad_connect $tx_ref_clk     ${rx_phy}/GT_REFCLK
      ad_connect gt_reset        ${rx_phy}/gtreset_in
      ad_connect $sys_cpu_clk    ${rx_phy}/s_axi_clk
      ad_connect $sys_cpu_resetn ${rx_phy}/s_axi_resetn
      ad_connect ${rx_phy}/gtpowergood gt_powergood
      ad_connect ${rx_phy}/gtreset_rx_datapath gt_reset_rx_datapath
      ad_connect ${rx_phy}/gtreset_rx_pll_and_datapath gt_reset_rx_pll_and_datapath
      ad_connect ${rx_phy}/rx_resetdone rx_resetdone
    }
    "TX" {
      create_versal_phy jesd204_phy_tx $JESD_MODE $TX_NUM_OF_LANES $TX_NUM_OF_LANES $RX_LANE_RATE $TX_LANE_RATE $REF_CLK_RATE $TRANSCEIVER_TYPE $INTF_CFG
      set tx_phy jesd204_phy_tx
      ad_connect $ref_clock      ${tx_phy}/GT_REFCLK
      ad_connect gt_reset        ${tx_phy}/gtreset_in
      ad_connect $sys_cpu_clk    ${tx_phy}/s_axi_clk
      ad_connect $sys_cpu_resetn ${tx_phy}/s_axi_resetn
      ad_connect ${tx_phy}/gtpowergood gt_powergood
      ad_connect ${tx_phy}/gtreset_tx_datapath gt_reset_tx_datapath
      ad_connect ${tx_phy}/gtreset_tx_pll_and_datapath gt_reset_tx_pll_and_datapath
      ad_connect ${tx_phy}/tx_resetdone tx_resetdone
    }
  }
}

if {$ADI_PHY_SEL == 1} {
  ad_connect  $sys_cpu_resetn util_adrv9026_xcvr/up_rstn
  ad_connect  $sys_cpu_clk util_adrv9026_xcvr/up_clk

  # Tx
  ad_xcvrcon util_adrv9026_xcvr axi_adrv9026_tx_xcvr axi_adrv9026_tx_jesd {3 2 0 1} {} core_clk
  ad_xcvrpll $tx_ref_clk util_adrv9026_xcvr/qpll_ref_clk_0
  ad_xcvrpll axi_adrv9026_tx_xcvr/up_pll_rst util_adrv9026_xcvr/up_qpll_rst_0
  ad_xcvrpll $tx_ref_clk util_adrv9026_xcvr/qpll_ref_clk_4
  ad_xcvrpll axi_adrv9026_tx_xcvr/up_pll_rst util_adrv9026_xcvr/up_qpll_rst_4

  # Rx
  ad_xcvrcon  util_adrv9026_xcvr axi_adrv9026_rx_xcvr axi_adrv9026_rx_jesd {} {} core_clk
  for {set i 0} {$i < $RX_NUM_OF_LANES} {incr i} {
    set ch [expr $i]
    ad_xcvrpll  $rx_ref_clk util_adrv9026_xcvr/cpll_ref_clk_$ch
    ad_xcvrpll  axi_adrv9026_rx_xcvr/up_pll_rst util_adrv9026_xcvr/up_cpll_rst_$ch
  }
}  else {
    set rx_link_clock  ${rx_phy}/rxusrclk_out
    # Connect PHY to Link Layer
    ad_connect  axi_adrv9026_rx_jesd/rx_phy0 ${rx_phy}/rx1
    ad_connect  axi_adrv9026_rx_jesd/rx_phy1 ${rx_phy}/rx0
    ad_connect  axi_adrv9026_rx_jesd/rx_phy2 ${rx_phy}/rx2
    ad_connect  axi_adrv9026_rx_jesd/rx_phy3 ${rx_phy}/rx3

    ad_connect  $rx_link_clock /axi_adrv9026_rx_jesd/link_clk
    ad_connect  core_clk /axi_adrv9026_rx_jesd/device_clk
    ad_connect  axi_adrv9026_rx_jesd/phy_en_char_align ${rx_phy}/en_char_align

    create_bd_port -dir I rx_sysref_0
    ad_connect axi_adrv9026_rx_jesd/sysref rx_sysref_0

    create_bd_port -dir O rx_sync_0
    ad_connect rx_sync_0 axi_adrv9026_rx_jesd/sync
  
    set tx_link_clock ${tx_phy}/txusrclk_out
    # Connect PHY to Link Layer
    ad_connect  axi_adrv9026_tx_jesd/tx_phy0 ${tx_phy}/tx3
    ad_connect  axi_adrv9026_tx_jesd/tx_phy1 ${tx_phy}/tx2
    ad_connect  axi_adrv9026_tx_jesd/tx_phy2 ${tx_phy}/tx1
    ad_connect  axi_adrv9026_tx_jesd/tx_phy3 ${tx_phy}/tx0

    ad_connect  $tx_link_clock /axi_adrv9026_tx_jesd/link_clk
    ad_connect  core_clk /axi_adrv9026_tx_jesd/device_clk

    create_bd_port -dir I tx_sysref_0
    ad_connect axi_adrv9026_tx_jesd/sysref tx_sysref_0

    create_bd_port -dir I tx_sync_0
    ad_connect tx_sync_0 axi_adrv9026_tx_jesd/sync
}
# connections (dac)

ad_connect  core_clk tx_adrv9026_tpl_core/link_clk
ad_connect  axi_adrv9026_tx_jesd/tx_data tx_adrv9026_tpl_core/link

ad_connect  core_clk util_adrv9026_tx_upack/clk
ad_connect  core_clk_rstgen/peripheral_reset util_adrv9026_tx_upack/reset

for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  tx_adrv9026_tpl_core/dac_enable_$i util_adrv9026_tx_upack/enable_$i
  ad_connect  util_adrv9026_tx_upack/fifo_rd_data_$i tx_adrv9026_tpl_core/dac_data_$i
}

ad_connect  tx_adrv9026_tpl_core/dac_valid_0  util_adrv9026_tx_upack/fifo_rd_en
ad_connect  core_clk axi_adrv9026_dacfifo/dac_clk
ad_connect  core_clk_rstgen/peripheral_reset axi_adrv9026_dacfifo/dac_rst

ad_connect  util_adrv9026_tx_upack/s_axis_valid VCC
ad_connect  util_adrv9026_tx_upack/s_axis_ready axi_adrv9026_dacfifo/dac_valid
ad_connect  util_adrv9026_tx_upack/s_axis_data axi_adrv9026_dacfifo/dac_data

ad_connect  core_clk axi_adrv9026_dacfifo/dma_clk
ad_connect  core_clk_rstgen/peripheral_reset axi_adrv9026_dacfifo/dma_rst
ad_connect  core_clk  axi_adrv9026_tx_dma/m_axis_aclk
ad_connect  axi_adrv9026_dacfifo/dma_valid axi_adrv9026_tx_dma/m_axis_valid
ad_connect  axi_adrv9026_dacfifo/dma_data axi_adrv9026_tx_dma/m_axis_data
ad_connect  axi_adrv9026_dacfifo/dma_ready axi_adrv9026_tx_dma/m_axis_ready
ad_connect  axi_adrv9026_dacfifo/dma_xfer_req axi_adrv9026_tx_dma/m_axis_xfer_req
ad_connect  axi_adrv9026_dacfifo/dma_xfer_last axi_adrv9026_tx_dma/m_axis_last
ad_connect  axi_adrv9026_dacfifo/dac_dunf tx_adrv9026_tpl_core/dac_dunf
ad_connect  axi_adrv9026_dacfifo/bypass dac_fifo_bypass
ad_connect  core_clk_rstgen/peripheral_aresetn axi_adrv9026_tx_dma/m_src_axi_aresetn

# connections (adc)

ad_connect  core_clk rx_adrv9026_tpl_core/link_clk
ad_connect  axi_adrv9026_rx_jesd/rx_sof rx_adrv9026_tpl_core/link_sof
ad_connect  axi_adrv9026_rx_jesd/rx_data_tdata rx_adrv9026_tpl_core/link_data
ad_connect  axi_adrv9026_rx_jesd/rx_data_tvalid rx_adrv9026_tpl_core/link_valid
ad_connect  core_clk util_adrv9026_rx_cpack/clk
ad_connect  core_clk_rstgen/peripheral_reset util_adrv9026_rx_cpack/reset

for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
  ad_connect  rx_adrv9026_tpl_core/adc_enable_$i util_adrv9026_rx_cpack/enable_$i
  ad_connect  rx_adrv9026_tpl_core/adc_data_$i util_adrv9026_rx_cpack/fifo_wr_data_$i
}
ad_connect  $sys_dma_resetn axi_adrv9026_rx_dma/m_dest_axi_aresetn

ad_connect  rx_adrv9026_tpl_core/adc_valid_0 util_adrv9026_rx_cpack/fifo_wr_en
ad_connect  rx_adrv9026_tpl_core/adc_dovf util_adrv9026_rx_cpack/fifo_wr_overflow

ad_connect  core_clk axi_adrv9026_rx_dma/fifo_wr_clk
ad_connect  util_adrv9026_rx_cpack/packed_fifo_wr axi_adrv9026_rx_dma/fifo_wr

# interconnect (cpu)

ad_cpu_interconnect 0x44A00000 rx_adrv9026_tpl_core
ad_cpu_interconnect 0x44A04000 tx_adrv9026_tpl_core
if {$ADI_PHY_SEL == 1} {
  ad_cpu_interconnect 0x44A60000 axi_adrv9026_rx_xcvr
  ad_cpu_interconnect 0x44A80000 axi_adrv9026_tx_xcvr
}
ad_cpu_interconnect 0x44A90000 axi_adrv9026_tx_jesd
ad_cpu_interconnect 0x7c420000 axi_adrv9026_tx_dma
ad_cpu_interconnect 0x44AA0000 axi_adrv9026_rx_jesd
ad_cpu_interconnect 0x7c400000 axi_adrv9026_rx_dma

# gt uses hp0, and 100MHz clock for both DRP and AXI4

ad_mem_hp0_interconnect $sys_cpu_clk sys_ps7/S_AXI_HP0
if {$ADI_PHY_SEL == 1} {
  ad_mem_hp0_interconnect $sys_cpu_clk axi_adrv9026_rx_xcvr/m_axi
}

# interconnect (mem/dac)

ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect $sys_dma_clk axi_adrv9026_rx_dma/m_dest_axi
ad_mem_hp3_interconnect $sys_dma_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect $sys_dma_clk axi_adrv9026_tx_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-10 mb-15 axi_adrv9026_tx_jesd/irq
ad_cpu_interrupt ps-11 mb-14 axi_adrv9026_rx_jesd/irq
ad_cpu_interrupt ps-13 mb-12 axi_adrv9026_tx_dma/irq
ad_cpu_interrupt ps-14 mb-11 axi_adrv9026_rx_dma/irq

# Dummy outputs for unused lanes
if {$ADI_PHY_SEL == 1} {
  if {$INTF_CFG != "TX"} {
    # Unused Rx lanes
    for {set i $RX_NUM_OF_LANES} {$i < 4} {incr i} {
      create_bd_port -dir I rx_data_${i}_n
      create_bd_port -dir I rx_data_${i}_p
    }
  }
  if {$INTF_CFG != "RX"} {
    # Unused Tx lanes
    for {set i $TX_NUM_OF_LANES} {$i < 4} {incr i} {
      create_bd_port -dir O tx_data_${i}_n
      create_bd_port -dir O tx_data_${i}_p
    }
  }
} else {
    if {$INTF_CFG != "TX"} {
      create_bd_port -dir I -from 3 -to 0 rx_0_p
      create_bd_port -dir I -from 3 -to 0 rx_0_n
      ad_connect rx_0_p ${rx_phy}/rx_0_p
      ad_connect rx_0_n ${rx_phy}/rx_0_n
    }
    if {$INTF_CFG != "RX"} {
      create_bd_port -dir O -from 3 -to 0 tx_0_p
      create_bd_port -dir O -from 3 -to 0 tx_0_n
      ad_connect tx_0_p ${rx_phy}/tx_0_p
      ad_connect tx_0_n ${rx_phy}/tx_0_n
    }
}
