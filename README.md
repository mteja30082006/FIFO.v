FIFO Memory Design Using Verilog

Overview

This project implements a FIFO (First-In First-Out) memory using Verilog HDL.

FIFO is a memory structure in which the first data written into the memory is the first data read from the memory.

The design supports:

- Write operation
- Read operation
- Full detection
- Empty detection
- Reset operation
- Synchronous clock
- Simulation using a Verilog testbench

FIFO Configuration

Parameter| Value
Data Width| 8 bits
FIFO Depth| 8 locations
Address Width| 3 bits
Memory| 8 × 8 bits

The FIFO can store up to 8 data values, with each value being 8 bits wide.

FIFO Principle

FIFO follows the rule:

First Data Written
       ↓
First Data Read

Example:

Write: 10 → 20 → 30 → 40

Read:
10 → 20 → 30 → 40

Inputs

Signal| Width| Description
"clk"| 1| Clock
"reset"| 1| Active-high reset
"wr_en"| 1| Write enable
"rd_en"| 1| Read enable
"data_in"| 8| Input data

Outputs

Signal| Width| Description
"data_out"| 8| Output data
"full"| 1| FIFO full indication
"empty"| 1| FIFO empty indication

Working

Write Operation

When "wr_en = 1" and the FIFO is not full:

data_in → FIFO memory

The write pointer moves to the next location.

Read Operation

When "rd_en = 1" and the FIFO is not empty:

FIFO memory → data_out

The read pointer moves to the next location.

Full Condition

The "full" signal becomes HIGH when all 8 FIFO locations contain data.

Empty Condition

The "empty" signal becomes HIGH when there is no data available to read.

FIFO Block Diagram

              +------------------+
data_in ----> |                  |
wr_en ------> |      FIFO        | ----> data_out
rd_en ------> |    8 x 8 RAM     |
clk --------> |                  |
reset ------> |                  |
              +------------------+
                 |          |
                 v          v
               FULL       EMPTY

Files

RTL Code

src/fifo.v

Contains the FIFO design.

Testbench

tb/fifo_tb.v

Tests FIFO write and read operations.

Simulation

simulation/simulation_output.txt

Contains expected simulation results.

Simulation Using Icarus Verilog

Compile the design:

iverilog -o fifo_sim src/fifo.v tb/fifo_tb.v

Run the simulation:

vvp fifo_sim

The testbench generates:

fifo.vcd

Open the waveform:

gtkwave fifo.vcd

Test Cases

The testbench checks:

1. FIFO reset
2. Write data into FIFO
3. Read data from FIFO
4. FIFO empty condition
5. FIFO full condition
6. Multiple write and read operations
7. FIFO ordering

Expected FIFO Behavior

If the following values are written:

10
20
30
40

The values must be read in exactly the same order:

10
20
30
40

Applications

FIFO memories are commonly used in:

- Data buffering
- UART communication
- Serial communication
- Network interfaces
- Processor-to-processor communication
- Data streaming
- Clock-domain crossing systems

Future Improvements

This project can be extended by adding:

- Parameterized FIFO depth
- Parameterized data width
- Asynchronous FIFO
- Almost-full flag
- Almost-empty flag
- Read/write counters
- Overflow and underflow detection

Conclusion

This project demonstrates the implementation of a basic FIFO memory using Verilog HDL. It shows how memory, read/write pointers, and status flags can be combined to implement a First-In First-Out data buffer.
