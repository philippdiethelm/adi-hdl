# QUAD-MxFE HDL Project

## Building the project

This project is parameterized, and it can have many configurations.

The parameters configurable through the `make` command, can be found in the **system_project.tcl** file;
it contains the default configuration.

:warning: **When changing the default configuration, the timimg_constr.xdc constraints should be updated as well!**

Default configuration, as described in ./system_project.tcl: 

```
cd projects/ad_quadmxfe1_ebz/vcu118
make
```

### Example configurations

All of the RX/TX link modes can be found in the [AD9081 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

:warning: RX_LANE_RATE, TX_LANE_RATE, REF_CLK_RATE are used only in 64B66B mode!

The overwritable parameters from the environment:

- JESD_MODE - link layer encoder mode used; 
  - 8B10B - 8b10b link layer defined in JESD204B, uses ADI IP as Physical layer
  - 64B66B - 64b66b link layer defined in JESD204C, uses Xilinx IP as Physical layer
- [RX/TX]_LANE_RATE - lane rate of the [RX/TX] link (RX: MxFE to FPGA/TX: FPGA to MxFE)
- [RX/TX]_PLL_SEL - used in 64B66B mode:
  - 0 - CPLL for lane rates 4-12.5 Gbps and integer sub-multiples
  - 1 - QPLL0 for lane rates 19.6–32.75 Gbps and integer sub-multiples (e.g. 9.8–16.375;)
  - 2 - QPLL1 for lane rates 16.0–26.0 Gbps and integer sub-multiple (e.g. 8.0–13.0;)
  - For details, see JESD204 PHY v4.0 pg198-jesd204-phy.pdf and ug578-ultrascale-gty-transceivers.pdf
- REF_CLK_RATE - frequency of the reference clock in MHz used in 64B66B mode
- [RX/TX]_JESD_M - [RX/TX] number of converters per link
- [RX/TX]_JESD_L - [RX/TX] number of lanes per link
- [RX/TX]_JESD_S - [RX/TX] number of samples per converter per frame
- [RX/TX]_JESD_NP - [RX/TX] number of bits per sample, only 16 is supported
- [RX/TX]_NUM_LINKS - [RX/TX] number of links, which matches the number of MxFE devices
- [RX/TX]_KS_PER_CHANNEL
- DAC_TPL_XBAR_ENABLE

#### Default configuration (JESD204C, RX mode 4, TX mode 11)

Corresponding device tree [vcu118_quad_ad9081_204c_txmode_11_rxmode_4.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/microblaze/boot/dts/vcu118_quad_ad9081_204c_txmode_11_rxmode_4.dts)

This specific command is equivalent to running "make" only:

```
make JESD_MODE=64B66B
RX_LANE_RATE=16.5
TX_LANE_RATE=16.5
RX_PLL_SEL=2
TX_PLL_SEL=2
REF_CLK_RATE=250
RX_JESD_M=8
RX_JESD_L=2
RX_JESD_S=1
RX_JESD_NP=16
RX_NUM_LINKS=4
TX_JESD_M=16
TX_JESD_L=4
TX_JESD_S=1
TX_JESD_NP=16
TX_NUM_LINKS=4
RX_KS_PER_CHANNEL=32
TX_KS_PER_CHANNEL=16
```

#### 

```
make JESD_MODE=8B10B  RX_JESD_L=4 RX_JESD_M=8 TX_JESD_L=4 TX_JESD_M=8
make JESD_MODE=64B66B RX_JESD_L=2 RX_JESD_M=8 TX_JESD_L=4 TX_JESD_M=16
make JESD_MODE=64B66B RX_LANE_RATE=24.75 TX_LANE_RATE=24.75 REF_CLK_RATE=250 RX_JESD_M=4 RX_JESD_L=4 RX_JESD_S=2 RX_JESD_NP=12 TX_JESD_M=4 TX_JESD_L=4 TX_JESD_S=2 TX_JESD_NP=12 RX_PLL_SEL=1 TX_PLL_SEL=1
```
