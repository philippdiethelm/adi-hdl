###############################################################################
## Copyright (C) 2023-2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value
#
#   Use over-writable parameters from the environment.
#
#    e.g.
#      make RX_JESD_L=4 RX_JESD_M=2 TX_JESD_L=4 TX_JESD_M=2 

# Parameter description:
#   project_name: Name of the project you want to build
#   LANE_RATE: Value of lane rate [gbps]
#   REF_CLK: Value of the reference clock [MHz] (usually LANE_RATE/20 or LANE_RATE/40)
#   PLL_TYPE: The PLL used for driving the link [CPLL/QPLL0/QPLL1]
#
#   e.g. call for make with parameters
#     adi_project_make project_name [list \
#       LANE_RATE=10  \
#       REF_CLK=500   \
#       PLL_TYPE=QPLL0\
#     ]
#   
#   e.g call for make without parameters
#     adi_project_make project_name {}
#
# The function returns a dictionary with the paths to the `cfng` file
# containing the modified parameters and to the `_common.v` file for extracting the value of the `QPLL_FBDIV_TOP` parameter for GTXE2.

global FILE_PATHS

set FILE_PATHS [adi_project_make xcvr_wizard [list \
  LANE_RATE [get_env_param LANE_RATE  9.83] \
  REF_CLK   [get_env_param REF_CLK  245.75] \
  PLL_TYPE  [get_env_param PLL_TYPE  QPLL0] \
]]

adi_project adrv9026_zcu102 0 [list \
  JESD_MODE           [get_env_param JESD_MODE      8B10B ] \
  TX_LANE_RATE        [get_env_param TX_LANE_RATE    9.83 ] \
  RX_LANE_RATE        [get_env_param RX_LANE_RATE    9.83 ] \
  TX_NUM_LINKS        [get_env_param RX_NUM_LINKS       1 ] \
  RX_NUM_LINKS        [get_env_param RX_NUM_LINKS       1 ] \
  TX_JESD_M           [get_env_param TX_JESD_M          8 ] \
  TX_JESD_L           [get_env_param TX_JESD_L          4 ] \
  TX_JESD_S           [get_env_param TX_JESD_S          1 ] \
  RX_JESD_M           [get_env_param RX_JESD_M          8 ] \
  RX_JESD_L           [get_env_param RX_JESD_L          4 ] \
  RX_JESD_S           [get_env_param RX_JESD_S          1 ] \
]
adi_project_files adrv9026_zcu102 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

adi_project_run adrv9026_zcu102
