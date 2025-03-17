# AD719x-ASDZ HDL Project

## Building the project

#### Default configuration (PMOD)

Connect the evaluation board PMOD to the PMOD JA connector of Cora. The default ``make`` command: 

```
cd projects/ad719x_asdz/cora
make
```

in this case it is equivalent to running:

```
make ARDZ_PMOD_N=0
```

#### Configuration with Arduino shield

Connect the eval board to the Arduino shield (placing it on top of Cora).

```
make ARDZ_PMOD_N=1
```