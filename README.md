# PIPELINE-PROCESSOR-DESIGN

*COMPANY*: CODTECH IT SLOUTIONS

*NAME*: MALLAMPALLY JAYANTHA SIVA SRINIVAS

*INTERN ID*: CTIS7516

*DOMAIN*: VLSI

*DURATION*: 4 WEEKS

*MENTOR*: NEELA SANTOSH

Task 3 — 4-Stage Pipelined Processor Design

Language: Verilog HDL

Tool: Xilinx Vivado

Target: Artix-7 FPGA

Description

Pipelining is the single most important architectural technique for improving processor throughput. Instead of waiting for one instruction to fully complete before fetching the next, a pipelined processor overlaps the execution of multiple instructions — each at a different stage — in the same clock cycle. This task involved the complete design, simulation, synthesis, and implementation of a 4-stage pipelined processor in Verilog HDL on the Artix-7 FPGA.
The processor operates on a 16-bit instruction word with 4-bit register fields and supports three core instructions: ADD, SUB, and LOAD. The pipeline is divided into four classic stages, each separated by pipeline registers to hold intermediate results:

<img width="1004" height="246" alt="image" src="https://github.com/user-attachments/assets/58ae0e8b-3e18-47f8-97ee-4e0dca8f7b27" />

The Verilog implementation uses separate always blocks for each pipeline stage, with pipeline registers (if_id_reg, id_ex_reg, ex_wb_reg) capturing and propagating data between stages on every rising clock edge. A full testbench was written to simulate a sequence of instructions through the pipeline, verifying correct stage-by-stage execution and write-back.

Key Results

Resources: 26 LUTs (0.02%), 65 Flip-Flops (0.02%) — the flip-flop count directly reflects the pipeline register storage
Worst-case Delay: 5.320 ns (the highest of the three FPGA tasks, as expected from the pipelined register chains)
Simulation: Verified correct 4-stage pipeline operation — instruction overlap confirmed across IF, ID, EX, and WB stages simultaneously
Artix-7 Fit: Only 26 LUTs and 65 FFs consumed — a negligible fraction of available resources

The 65 flip-flops are a direct hardware signature of the pipelining technique — they represent the pipeline registers holding partial results between stages. This design can be extended to support hazard detection, data forwarding, branch prediction, or a full RISC-V subset instruction set.

#OUTPUT

<img width="1548" height="550" alt="Image" src="https://github.com/user-attachments/assets/3b36c2ac-27ca-40a7-b49c-1cd6f239b526" />


