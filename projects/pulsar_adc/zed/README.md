# PULSAR-ADC HDL Project

## Building the project

:warning: Make sure that you set up your required ADC resolution in [../common/pulsar_adc_bd.tcl](../common/pulsar_adc_bd.tcl)

How to use overwritable parameter from the environment:

**AD40XX_ADAQ400X_N** - selects the evaluation board to be used:
-  1 - EVAL-AD40XX-FMCZ (default option)
-  0 - EVAL-ADAQ400x

#### Default option (1), building project for EVAL-AD40XX-FMCZ

```
cd projects/pulsar_adc/zed
make AD40XX_ADAQ400X_N
```

#### Building project for EVAL-ADAQ400x

```
cd projects/pulsar_adc/zed
make AD40XX_ADAQ400X_N=0
```
