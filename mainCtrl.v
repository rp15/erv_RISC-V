module mainCtrl
(
  input  logic [7 - 1:0] opcode,

  output logic LUI,
  output logic AUIPC,
  output logic JAL,
  output logic JALR,
  output logic memToReg,
  output logic regWr,
  output logic ALUImm,
  output logic memWr,
  output logic branch,
  output logic [5 - 1:0] ALUOp,
  output logic [3 - 1:0] immGenType
);

  logic [17 - 1:0] ctrlLines;

  always_comb
    unique casez (opcode)

      // 'b0110011: // R (full version, uses the 64b regs)
      //   ctrlLines = 'b00100010;
      // 'b0111011: // R (word version, uses the rightmost 32b of the 64b regs)
      //   ctrlLines = 'b00100011;
      // 'b0000011: // I (ld)
      //   ctrlLines = 'b11110000;
      // 'b0010011: // I (addi)
      //   ctrlLines = 'b10100000;
      // 'b0011011: // I (addiw)
      //   ctrlLines = 'b10100011;
      // 'b0100011: // S (sd)
      //   ctrlLines = 'b10001000;
      // 'b1100011: // SB (beq, bltu, bne)
      //   ctrlLines = 'b00000101;

      'b0110111: // LUI - does not use ALU.
        ctrlLines = 'b100001x00_xxxxx_000; // b100001000_00000_000

      'b0010111: // AUIPC
        ctrlLines = 'b010001x00_00111_000; // ALUOp=7, immGenType=0

      'b1101111: // JAL - does not use ALU.
        ctrlLines = 'b001001x00_xxxxx_001;

      'b1100111: // JALR
        ctrlLines = 'b000101100_00000_010;

      'b1100011: // Branches - do not use ALU.
        ctrlLines = 'b000000x01_xxxxx_011;

      'b0000011: // LD
        ctrlLines = 'b000011100_00001_010;

      'b0100011: // SD
        ctrlLines = 'b000000110_00010_100;

      'b0010011: // Arithmetic Immediates - 64b
        ctrlLines = 'b000001100_00011_010;

      'b0011011: // Arithmetic Immediates - 32b
        ctrlLines = 'b000001100_00100_010;

      'b0110011: // Arithmetic Non-Immediates - 64b
        ctrlLines = 'b000001000_00101_xxx;

      'b0111011: // Arithmetic Non-Immediates - 32b
        ctrlLines = 'b000001000_00110_xxx;

      default:
        ctrlLines = 'b000000000_00000_000;

    endcase

  // {9 ctrl bits, ALUOp[4:0], immGenType[2:0]} = ctrlLines
  assign {LUI, AUIPC, JAL, JALR, memToReg, regWr, ALUImm, memWr, branch, ALUOp, immGenType} = ctrlLines;

endmodule
