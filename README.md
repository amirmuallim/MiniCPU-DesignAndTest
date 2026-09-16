# MiniCPU-DesignAndTest

A Verilog-based project for designing and testing a simple Mini CPU. This repository contains the RTL implementation of a basic CPU architecture, along with associated testbenches and scripts for simulation and verification.

## Features

- Written primarily in Verilog (92.5%)
- Includes Makefile scripts (7.5%) for building and simulating designs
- Modular CPU design suitable for educational purposes
- Testbenches for functional verification
- 8 instruction types with complete self-checking testbench

## Directory Structure

```
MiniCPU-DesignAndTest/
├── rtl/                      # Verilog RTL source files for CPU components
├── tb/                       # Testbenches for simulation and verification
├── sim/                      # Build and simulation automation scripts
├── block_diagrams/           # Block diagrams and architecture visualizations
│   ├── block-diagram.png        # Overall CPU block diagram
│   ├── processor_top.png        # Top-level processor architecture
│   ├── arithmetic_unit.png      # ALU architecture
│   ├── register_bank.png        # Register file design
│   ├── input_selection.png      # Input multiplexer logic
│   ├── output_selection.png     # Output multiplexer logic
│   └── go_to.png                # Branch/Jump control logic
├── BUG_LOG.md                # Known issues and bug tracking
└── README.md                 # Project documentation
```

## Getting Started

### Prerequisites

- Verilog simulator (e.g., Icarus Verilog, ModelSim, or Vivado)
- GNU Make

### Build and Run

1. Clone the repository:
    ```sh
    git clone https://github.com/amirmuallim/MiniCPU-DesignAndTest.git
    cd MiniCPU-DesignAndTest/sim
    ```

2. Build and simulate using Make:
    ```sh
    make
    ```

   This will compile the Verilog files and run the included testbenches.

3. To clean build artifacts:
    ```sh
    make clean
    ```

## Instruction Encoding

The MiniCPU supports 8 instruction types with a 16-bit instruction format. Each instruction is composed of:
- **Opcode (4 bits)**: Specifies the operation type
- **Parameters (12 bits)**: Instruction-specific operands

### Instruction Format Reference

| Instruction | Opcode | Format | Operation | Description |
|---|---|---|---|---|
| **ASSIGN_VALUE** | `0000` | `0000 AAAAAAAA KKKK` | `X(k) := A` | Load immediate value A into register X(k) |
| **DATA_INPUT** | `0010` | `0010 0000 JJJJ KKKK` | `X(k) := IN(j)` | Load input port IN(j) into register X(k) |
| **DATA_OUTPUT** | `1010` | `1010 IIII JJJJ 0000` | `OUT(i) := X(j)` | Output register X(j) to output port OUT(i) |
| **OUTPUT_VALUE** | `1000` | `1000 IIII AAAAAAAA 0000` | `OUT(i) := A` | Output immediate value A to port OUT(i) |
| **ADD** | `0100` | `0100 IIII JJJJ KKKK` | `X(k) := X(i) + X(j)` | Add X(i) and X(j), store result in X(k) |
| **SUB** | `0101` | `0101 IIII JJJJ KKKK` | `X(k) := X(i) - X(j)` | Subtract X(j) from X(i), store result in X(k) |
| **JUMP** | `1110` | `1110 0000 NNNNNNNN` | `PC := N` | Unconditional jump to instruction address N |
| **JUMP_POS** | `1100` | `1100 IIII NNNNNNNN` | `if X(i) > 0 then PC := N` | Conditional jump if X(i) is positive |
| **JUMP_NEG** | `1101` | `1101 IIII NNNNNNNN` | `if X(i) < 0 then PC := N` | Conditional jump if X(i) is negative |

### Encoding Parameters

- **A** (8 bits): Immediate data value
- **I, J, K** (4 bits each): Register indices (0-15)
- **N** (8 bits): Jump destination address
- **X(i)**: Register file storage location
- **IN(j)**: Input data port
- **OUT(i)**: Output data port

### Instruction Examples with Binary Representation

#### Example 1: ASSIGN_VALUE - Load constant into register
```
Instruction: assign_value(k=3, A=45)
Operation: X(3) := 45

Binary breakdown:
┌────────┬──────────────┬────────┐
│ Opcode │   Immediate  │Register│
│  0000  │   00101101   │  0011  │
└────────┴──────────────┴────────┘
Result: 0000 00101101 0011 = 0x0B3

Assembly format: ASSIGN_VALUE 3, 45
```

#### Example 2: ADD - Add two registers
```
Instruction: add(i=3, j=4, k=1)
Operation: X(1) := X(3) + X(4)

Binary breakdown:
┌────────┬──────┬──────┬──────┐
│ Opcode │ X(i) │ X(j) │ X(k) │
│  0100  │ 0011 │ 0100 │ 0001 │
└────────┴──────┴──────┴──────┘
Result: 0100 0011 0100 0001 = 0x4341

Assembly format: ADD 3, 4, 1
```

#### Example 3: JUMP_POS - Conditional positive jump
```
Instruction: jump_pos(i=2, N=10)
Operation: if X(2) > 0 then PC := 10

Binary breakdown:
┌────────┬──────┬──────────────┐
│ Opcode │ X(i) │   Address N  │
│  1100  │ 0010 │   00001010   │
└────────┴──────┴──────────────┘
Result: 1100 0010 00001010 = 0xC20A

Assembly format: JUMP_POS 2, 10
```

#### Example 4: DATA_OUTPUT - Output register to port
```
Instruction: data_output(i=1, j=0)
Operation: OUT(1) := X(0)

Binary breakdown:
┌────────┬──────┬──────┬──────┐
│ Opcode │OUT(i)│ X(j) │0000  │
│  1010  │ 0001 │ 0000 │ 0000 │
└────────┴──────┴──────┴──────┘
Result: 1010 0001 0000 0000 = 0xA100

Assembly format: DATA_OUTPUT 1, 0
```

## Datapath Architecture

The MiniCPU employs a simplified datapath architecture designed for educational purposes and efficient instruction execution:

![MiniCPU Datapath Architecture](./block_diagrams/cpu_datapath_arch.png)

The datapath integrates key CPU components including the instruction fetch unit, decoder, ALU, registers, and memory interfaces to execute a complete instruction cycle.

## Contributing

Contributions, issues, and feature requests are welcome! Please open a pull request or submit an issue via the Issues tab.

## License

This project is licensed under the MIT License.

## Author

Created and maintained by [amirmuallim](https://github.com/amirmuallim).
