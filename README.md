# LC-3 Microprocessor Simulator

## About

L-3 Microprocessor Simulator is a first-year Master's (M1 IMPAIRS) project at Université Paris Cité focused on the implementation, hardware extension, and simulation of a 16-bit **Little Computer 3 (LC-3)** architecture using **Logisim**. Built upon an academic framework and base schema, this project demonstrates a deep understanding of computer architecture, digital logic design, datapath and control unit wiring, and low-level assembly programming.

The simulator successfully executes the standard LC-3 instruction set, integrates custom hardware instructions like `XOR` and `POPCNT` (Population Count), and runs advanced assembly subroutines (such as string manipulation, bit scanning, and saturated arithmetic with overflow prediction).

*Note: As this was an academic project, documentation or comments may contain some French.*

## Tech Stack

- Simulation Tool: Logisim (v2.7.1 or compatible)
- Architecture: LC-3 16-bit RISC-like Architecture
- Language: LC-3 Assembly (.asm)
- Components: Combinational & Sequential Logic (ALU, Multiplexers, Registers, RAM, Decoders)

## Key Features

- **Datapath & Control Unit Integration:** Complete wiring and testing of internal registers, the ALU, multiplexers, and control logic signals.
- **Instruction Set Support:** Full implementation of standard instructions including `ADD`, `AND`, `NOT`, memory operations (`LD`, `LDI`, `LDR`, `ST`, `STI`, `STR`), and control flows (`BR`, `JMP`, `JSR`, `RET`).
- **Custom Assembly Programs:** Development and execution of dedicated `.asm` source files to test, validate, and demonstrate instruction processing on the simulated processor.
- **Interactive Simulation:** Real-time visualization of signal propagation, register states, and instruction execution ticks within Logisim.
- **Hardware Extensions:** Wiring and integration of custom instructions such as `XOR` and `POPCNT` into the Logisim datapath, ALU, and control unit.

## Project Structure

```text
📁 lc3-microprocessor-logisim/
├── 📁 src/                     # Source .asm files
├── 📄 LC-3-v0.circ             # Processor circuit implementation
├── 📄 LC-3-v1.circ             # Processor circuit implementation
├── 📄 LC-3-v2.circ             # Processor circuit implementation
└── 📄 README.md                # Project documentation
```

## Getting Started

### Prerequisites

- Logisim (v2.7.1 recommended to ensure full compatibility with the .circ files).
- An LC-3 Assembler (to translate `.asm` files into `.mem` or `.hex` format if needed).

### Installation & Usage

1. **Clone the repository:**
```bash
git clone https://github.com/your-username/https://github.com/SuyuKuka/lc3-microprocessor-logisim.git
cd lc3-microprocessor-logisim
```

2. **Open the project:**  
Launch Logisim and open one of the main circuit files depending on the version you wish to explore (e.g., LC-3-v2.circ).

3. **Compile & Load Your Assembly Code:**
   - Assemble your `.asm` program using an appropriate LC-3 assembler tool to generate the machine code file (`.hex` or `.mem`).
   - Right-click on the RAM component inside Logisim and select **Load Image...** to import your generated memory file.

4. **Running Simulations:**
   - Use Logisim's simulation tools (Tick / Reset) to observe the datapath, watch register updates, and trace execution steps.

### Circuit Architecture Overview

- main: The central top-level schematic tying together the RAM, ALU, Registers, and control units.
- ALU: Performs 16-bit arithmetic (add, and, not) and logic routing based on control signals.
- Registres: Manages the 8 general-purpose 16-bit registers (R0 through R7) with multiplexed inputs/outputs.
- RegPC: Handles Program Counter updates, incrementation, and jump/branch offsets.
- DecodeIR: Parses the Instruction Register to drive control lines (Load, Store, Jump, WriteReg).

## Team

This project was developed collaboratively as a 2-person team:

- **CHEN Michel** - Implementation & Simulation 
  [![GitHub](https://img.shields.io/badge/GitHub-Profile-181717?logo=github)](https://github.com/SuyuKuka)
  [![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-0A66C2?logo=linkedin)](https://linkedin.com/in/chen-michel)

- **HUYNH Minh Van Claude** - Implementation & Simulation
  [![GitHub](https://img.shields.io/badge/GitHub-Profile-181717?logo=github)](https://github.com/huynh-claude)

## License

This repository contains academic coursework. 

- The initial `LC-3-v0.circ`, `LC-3-v1.circ` and `LC-3-v2.circ` file are the intellectual property of the teaching staff. They are included here strictly for context and evaluation purposes.
- The logical implementations, wiring, and solutions are our team's work.
- The `.asm` files are also our team's work.

This project is shared for portfolio and reference purposes only.