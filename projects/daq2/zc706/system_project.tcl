###############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# Parameter description:
# To correctly specify the project for which you want to run `make`, follow the format: project_name/carrier_folder.
# LANE_RATE: Value of lane rate [gbps]
# REF_CLK: Value of the reference clock [MHz] (usually LANE_RATE/20 or LANE_RATE/40)
# PLL_TYPE: The PLL used for driving the link [CPLL/QPLL0/QPLL1]
#
#   e.g. call for make with parameters
#     adi_project_make xcvr_wizard/zc706 [list \
#       LANE_RATE=10 \
#       REF_CLK=500   \
#       PLL_TYPE=QPLL\
#     ]
#   
#   e.g call for make without parameters
#     adi_project_make xcvr_wizard/zc706 {}

#adi_project_make xcvr_wizard/zc706 {}

# adi_project_make xcvr_wizard/zc706 [list \
#   LANE_RATE=10 \
#   REF_CLK=500   \
#   PLL_TYPE=QPLL\
# ]
#global XCVR_CONFIG_PATH
global FILE_PATHS

set FILE_PATHS [adi_project_make xcvr_wizard zc706 GTXE2 [list \
  LANE_RATE [get_env_param LANE_RATE  10] \
  REF_CLK   [get_env_param REF_CLK    500]   \
  PLL_TYPE  [get_env_param PLL_TYPE  QPLL]\
]]
puts "xcvr config path in sys proj: [dict get $FILE_PATHS cfng_file_path]"
puts "local param file path: [dict get $FILE_PATHS param_file_path]"

# adi_project_make xcvr_wizard zc706 [list \
#   LANE_RATE [get_env_param LANE_RATE  10] \
#   REF_CLK   [get_env_param REF_CLK    500]   \
#   PLL_TYPE  [get_env_param PLL_TYPE  QPLL]\
# ]

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#   Use over-writable parameters from the environment.
#
#    e.g.
#      make RX_JESD_L=4 RX_JESD_M=2 TX_JESD_L=4 TX_JESD_M=2 

# Parameter description:
#   [RX/TX]_JESD_M : Number of converters per link
#   [RX/TX]_JESD_L : Number of lanes per link
#   [RX/TX]_JESD_S : Number of samples per frame

adi_project daq2_zc706 0 [list \
  RX_JESD_M    [get_env_param RX_JESD_M    2 ] \
  RX_JESD_L    [get_env_param RX_JESD_L    4 ] \
  RX_JESD_S    [get_env_param RX_JESD_S    1 ] \
  TX_JESD_M    [get_env_param TX_JESD_M    2 ] \
  TX_JESD_L    [get_env_param TX_JESD_L    4 ] \
  TX_JESD_S    [get_env_param TX_JESD_S    1 ] \
]

adi_project_files daq2_zc706 [list \
  "../common/daq2_spi.v" \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zc706/zc706_plddr3_constr.xdc" \
  "$ad_hdl_dir/projects/common/zc706/zc706_system_constr.xdc" ]

# adi_project_run daq2_zc706

## To improve timing in the axi_ad9680_offload component
set_property strategy Performance_Retiming [get_runs impl_1]


