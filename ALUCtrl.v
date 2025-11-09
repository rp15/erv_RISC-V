module ALUCtrl (
  input  logic [7-1:0] funct7,
  input  logic [3-1:0] funct3,
  input  logic [5-1:0] ALUOp,

  output logic [6-1:0] ALUSel
);

  always_comb
    unique casez ({ALUOp, funct7, funct3})

      // Auto-generated cases (ALUOp[4:0] _ funct7[6:0] _ funct3[2:0])

      // AUIPC
      'b00111_???????_???: ALUSel = 'b000000; // 'd0
      // JALR
      'b00000_???????_000: ALUSel = 'b000000; // 'd0

      // Loads/Stores
      'b00001_???????_011: ALUSel = 'b000000; // LD -> 0
      'b00010_???????_011: ALUSel = 'b000000; // SD -> 0

      // I-type (32/64)
      'b00011_???????_000: ALUSel = 'b000000; // ADDI -> 0
      'b00100_???????_000: ALUSel = 'b000001; // ADDIW -> 1
      'b00011_???????_010: ALUSel = 'b000010; // SLTI -> 2
      'b00011_???????_011: ALUSel = 'b000011; // SLTIU -> 3
      'b00011_???????_100: ALUSel = 'b000100; // XORI -> 4
      'b00011_???????_110: ALUSel = 'b000101; // ORI  -> 5
      'b00011_???????_111: ALUSel = 'b000110; // ANDI -> 6

      // Shift-immediate
      'b00011_000000?_001: ALUSel = 'b000111; // SLLI  -> 7
      'b00011_000000?_101: ALUSel = 'b001000; // SRLI  -> 8
      'b00011_010000?_101: ALUSel = 'b001001; // SRAI  -> 9

      // *W shift-immediate
      'b00100_0000000_001: ALUSel = 'b001010; // SLLIW -> 10
      'b00100_0000000_101: ALUSel = 'b001011; // SRLIW -> 11
      'b00100_0100000_101: ALUSel = 'b001100; // SRAIW -> 12

      // R-type add/sub
      'b00101_0000000_000: ALUSel = 'b000000; // ADD  -> 0
      'b00110_0000000_000: ALUSel = 'b000001; // ADDW -> 1
      'b00101_0100000_000: ALUSel = 'b001101; // SUB  -> 13
      'b00110_0100000_000: ALUSel = 'b001110; // SUBW -> 14

      // R-type shifts
      'b00101_0000000_001: ALUSel = 'b000111; // SLL  -> 7
      'b00110_0000000_001: ALUSel = 'b001010; // SLLW -> 10
      'b00101_0000000_101: ALUSel = 'b001000; // SRL  -> 8
      'b00110_0000000_101: ALUSel = 'b001011; // SRLW -> 11
      'b00101_0100000_101: ALUSel = 'b001001; // SRA  -> 9
      'b00110_0100000_101: ALUSel = 'b001100; // SRAW -> 12

      // R-type set/logic
      'b00101_0000000_010: ALUSel = 'b000010; // SLT  -> 2
      'b00101_0000000_011: ALUSel = 'b000011; // SLTU -> 3
      'b00101_0000000_100: ALUSel = 'b000100; // XOR  -> 4
      'b00101_0000000_110: ALUSel = 'b000101; // OR   -> 5
      'b00101_0000000_111: ALUSel = 'b000110; // AND  -> 6

      // M-extension (RV64)
      'b00101_0000001_000: ALUSel = 'b001111; // MUL  -> 15
      'b00110_0000001_000: ALUSel = 'b010000; // MULW -> 16
      'b00101_0000001_001: ALUSel = 'b010001; // MULH -> 17
      'b00101_0000001_010: ALUSel = 'b010010; // MULHSU -> 18
      'b00101_0000001_011: ALUSel = 'b010011; // MULHU  -> 19
      'b00101_0000001_100: ALUSel = 'b010100; // DIV  -> 20
      'b00110_0000001_100: ALUSel = 'b010101; // DIVW -> 21
      'b00101_0000001_101: ALUSel = 'b010110; // DIVU -> 22
      'b00110_0000001_101: ALUSel = 'b010111; // DIVUW -> 23
      'b00101_0000001_110: ALUSel = 'b011000; // REM  -> 24
      'b00110_0000001_110: ALUSel = 'b011001; // REMW -> 25
      'b00101_0000001_111: ALUSel = 'b011010; // REMU -> 26
      'b00110_0000001_111: ALUSel = 'b011011; // REMUW -> 27

      default: ALUSel = 'b000000; // safe default
    endcase

endmodule
