###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

source ../../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

adi_project ada4355_fmc_zcu102

adi_project_files ada4355_fmc_zcu102 [list \
  "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" \
  "$ad_hdl_dir/library/common/ad_iobuf.v" \
  "system_constr.xdc" \
  "system_top.v"
  ]

adi_project_run ada4355_fmc_zcu102
