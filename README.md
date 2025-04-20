# PMOD ALS: Didilent Ambient Light Sensor Controller

A FPGA SPI-master implementation of an SPI controller for interfacing with an Ambient Light Sensor.
Includes functional simulation models and basic hardware testing in the Xilinx development environment.

---

## Overview

This project implements an SPI-master controller designed to interface with a Digilent Ambient Light Sensor.
Digelent PMOD ALS is based on ADC081S021 Single-Channel, 50-ksps to 200-ksps, 8-Bit A/D Converter
Datasheet: https://www.ti.com/lit/ds/symlink/adc081s021.pdf
The controller handles SPI communication and provides a simple interface for retrieving light intensity data.

The project includes:
- RTL implementation of the controller (Verilog)
- Functional testbench
- Simple hardware validation in a Xilinx FPGA environment (Digilent Zybo Z7 board, ALS, 7-segment display)

---

## Features

- SPI Master controller in Verilog
- Configurable clock frequency and SPI mode
- Functional model of Ambient Light Sensor for simulation
- Testbench verifying read/write SPI transactions
- Hardware test setup for on-board sensor validation

---

## Implementation details

SPI serial clock comes from clock divider. Divisor is a controller module parameter.
Since A/D converter work frequencies are 1-4 MHz it is supposed that design clock have to conform equation:

design_clock/divisor in [1 ...4] Mhz

Hardware test is made for 12 MHz (made from Z7 125 MHz onboard system clock and MMCM)

---

## Test Bench

### Functional model
```
cd test-bench
make -f Makefile.fmodel
```
GtkWave is required

### SPI masterfunctional test
```
cd test-bench
make
```

## Hardware test

```
cd xilinx/zybo-z7-10
./create_project.tcl
```

run Vivado, create bitstream
