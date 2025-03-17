# TEMPLATE HDL Project

- Evaluation board product page: [EVAL-AD400x-FMCZ](https://www.analog.com/eval-ad400x-fmcz)
- System documentation: https://wiki.analog.com/resources/eval/10-lead-pulsar-adc-evaluation-board
- HDL project documentation [online](http://analogdevicesinc.github.io/hdl/projects/pulsar_adc/index.html)

## Supported parts

| Part name                                      | Description                                                  |
|------------------------------------------------|--------------------------------------------------------------|
| [AD9081 (MxFE)](https://www.analog.com/ad9081) | Quad, 16-Bit, 12 GSPS RF DAC and Quad, 12-Bit, 4 GSPS RF ADC |

## Building the project

Please enter the folder for the FPGA carrier you want to use and read the README.md.

---

# Template for the carrier-specific README.md

! The following contents go in the carrier-specific folder.

## Building the project

:warning: Make sure that you set up your required ADC resolution in [../common/pulsar_adc_bd.tcl](../common/pulsar_adc_bd.tcl)

> [!NOTE]
> * For the ALERT functionality, the following parameters will be used in make command: ALERT_SPI_N

This project is supported only on FPGA AMD Xilinx VCU118.

This project is parameterized, and it can have many configurations.
For detailed information, check the HDL project documentation.

The parameters configurable through the `make` command, can be found in the **system_project.tcl** file;
it contains the default configuration.

```
// default configuration

cd hdl/projects/ad9081_fmca_ebz/zcu102
make
```

### Example configurations

! List all the possible configurations for which we have a Linux device tree.

! Take a look at the AD9081 README.md or at the PULSAR-ADC README.md for examples on READMEs.

How to use overwritable parameter from the environment:

**AD40XX_ADAQ400X_N** - selects the evaluation board to be used:
  * 1 - EVAL-AD40XX-FMCZ (default option)
  * 0 - EVAL-ADAQ400x

```
// default option (1), building project for EVAL-AD40XX-FMCZ

cd hdl/projects/pulsar_adc/zed
make AD40XX_ADAQ400X_N

// building project for EVAL-ADAQ400x

cd hdl/projects/pulsar_adc/zed
make AD40XX_ADAQ400X_N=0
```
