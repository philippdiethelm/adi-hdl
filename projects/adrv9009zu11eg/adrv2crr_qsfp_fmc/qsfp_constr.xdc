set_property -dict {PACKAGE_PIN  AU11 IOSTANDARD LVCMOS18             } [get_ports qsfp_resetl  ] ;
set_property -dict {PACKAGE_PIN  AL12 IOSTANDARD LVCMOS18 PULLUP true } [get_ports qsfp_modprsl ] ;
set_property -dict {PACKAGE_PIN  AW14 IOSTANDARD LVCMOS18 PULLUP true } [get_ports qsfp_intl    ] ;
set_property -dict {PACKAGE_PIN  AV11 IOSTANDARD LVCMOS18             } [get_ports qsfp_lpmode  ] ;

set_property PACKAGE_PIN AD2   [get_ports qsfp_rx1_p ] ;
set_property PACKAGE_PIN AD1   [get_ports qsfp_rx1_n ] ;

set_property PACKAGE_PIN AC4   [get_ports qsfp_rx2_p ] ;
set_property PACKAGE_PIN AC3   [get_ports qsfp_rx2_n ] ;

set_property PACKAGE_PIN AB2   [get_ports qsfp_rx3_p ] ;
set_property PACKAGE_PIN AB1   [get_ports qsfp_rx3_n ] ;

set_property PACKAGE_PIN AA4   [get_ports qsfp_rx4_p ] ;
set_property PACKAGE_PIN AA3   [get_ports qsfp_rx4_n ] ;

set_property PACKAGE_PIN AD6   [get_ports qsfp_tx1_p ] ;
set_property PACKAGE_PIN AD5   [get_ports qsfp_tx1_n ] ;

set_property PACKAGE_PIN AC8   [get_ports qsfp_tx2_p ] ;
set_property PACKAGE_PIN AC7   [get_ports qsfp_tx2_n ] ;

set_property PACKAGE_PIN AB6   [get_ports qsfp_tx3_p ] ;
set_property PACKAGE_PIN AB5   [get_ports qsfp_tx3_n ] ;

set_property PACKAGE_PIN AA8   [get_ports qsfp_tx4_p ] ;
set_property PACKAGE_PIN AA7   [get_ports qsfp_tx4_n ] ;

set_property PACKAGE_PIN AD10  [get_ports qsfp_mgt_refclk_0_p ] ;
set_property PACKAGE_PIN AD9   [get_ports qsfp_mgt_refclk_0_n ] ;


# 156.25 MHz MGT reference clock
create_clock -period 6.400 -name gt_ref_clk [get_ports qsfp_mgt_refclk_0_p] ;
