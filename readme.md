# Asynchronous signal transfer test

Test modules to find if clock skew causes glitch on asynchronous signals on FPGA.

### tcl script

Generates a block design. The script is made on Vivado 2021.2.

### simulation source

`allbench.sv` runs simulation for signal exchange. It must show that no glitch happens on a simulation.

### Result

+ Glitch occured in

| Clock Frequency | Naive | Gray code |
| --------------- | ----- | --------- |
| 80/100MHz       | No    | No        |
| 131/199MHz      | Yes   | No        |
| 189/210MHz      | Yes   | No        |
| 190/210MHz      | No    | No        |