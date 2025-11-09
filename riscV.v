// SD, LD, BEQ, BNE, ADD, SUB, ADDI, MUL, AND, OR

module riscV
(
  input  logic [32 - 1:0] inst,
  output logic [64 - 1:0] PC_IMEM,

  input  logic [64 - 1:0] readData_DMEM,
  output logic [64 - 1:0] addrData_DMEM,
  output logic [64 - 1:0] wrData_DMEM,
  output logic            MemWrite_DMEM,
  output logic            MemRead_DMEM,

  input  logic signed [64 - 1:0] readData1_RF,
  input  logic signed [64 - 1:0] readData2_RF,
  output logic [5  - 1:0]        readAddr1_RF,
  output logic [5  - 1:0]        readAddr2_RF,
  output logic [64 - 1:0]        writeData_RF,
  output logic [5  - 1:0]        writeAddr_RF,
  output logic                   RegWrite_RF,

  input logic clk,
  input logic rst
);

  // Control
  logic LUI, AUIPC, JAL, JALR, memToReg, regWr, ALUImm, memWr, branch;
  logic [5 - 1:0]  ALUOp;
  logic [3 - 1:0]  immGenType;

  // Fields
  logic [7 - 1:0]  opcode;
  assign opcode = inst[6:0];

  // ALU select
  logic [6 - 1:0]  ALUSel;

  // PC & datapath temps
  logic [64 - 1:0] PC, PC_nxt;
  logic [64 - 1:0] res;
  logic [64 - 1:0] immediate;
  logic [64 - 1:0] RFInput;
  logic [64 - 1:0] PCPlusImm;
  assign PCPlusImm = PC + immediate;

  logic [64 - 1:0] PCPlusFour;
  assign PCPlusFour = PC + 64'd4;

  // WB mux
  always_comb
    unique case (1'b1) // ({LUI, AUIPC, JAL, JALR, memToReg})
      LUI:      RFInput = immediate;
      AUIPC:    RFInput = PCPlusImm;
      JAL:      RFInput = PCPlusFour;
      JALR:     RFInput = PCPlusFour;
      memToReg: RFInput = readData_DMEM;
      default:  RFInput = res;
    endcase

  // ----------------------------------------------------------------
  // Instantiations (expanded from the generator calls)
  // ----------------------------------------------------------------

  // mainCtrl
  mainCtrl my_mainCtrl (
    .opcode     (opcode),
    .LUI        (LUI),
    .AUIPC      (AUIPC),
    .JAL        (JAL),
    .JALR       (JALR),
    .memToReg   (memToReg),
    .regWr      (regWr),
    .ALUImm     (ALUImm),
    .memWr      (memWr),
    .branch     (branch),
    .ALUOp      (ALUOp),
    .immGenType (immGenType)
  );

  // ALUCtrl
  ALUCtrl my_ALUCtrl (
    .funct7 (inst[31:25]),
    .funct3 (inst[14:12]),
    .ALUOp  (ALUOp),
    .ALUSel (ALUSel)
  );

  // ALU core
  risc5ALU_core my_risc5ALU_core (
    .in0    (readData1_RF),
    .in1    (ALUImm ? immediate : readData2_RF),
    .ALUSel (ALUSel),
    .res    (res)
  );

  // PC register (64-bit)
  dff my_PCReg (
    .d   (PC_nxt),
    .clk (clk),
    .rst (rst),
    .en  (1'b1),
    .q   (PC)
  );

  // Immediate generator
  immGen my_immGen (
    .inst       (inst),
    .immGenType (immGenType),
    .immediate  (immediate)
  );

  // ----------------------------------------------------------------
  // Next PC logic (JAL/JALR/branches)
  // ----------------------------------------------------------------
  always_comb
    unique case (1'b1)
      JAL:
        PC_nxt = PCPlusImm;
      JALR:
        PC_nxt = {res[64 - 1:1], 1'b0}; // aligned to even address
      // Branches
      branch && (inst[14:12] == 3'b000) && (readData1_RF == readData2_RF):                       // BEQ
        PC_nxt = PCPlusImm;
      branch && (inst[14:12] == 3'b001) && (readData1_RF != readData2_RF):                       // BNE
        PC_nxt = PCPlusImm;
      branch && (inst[14:12] == 3'b100) && (readData1_RF <  readData2_RF):                       // BLT (signed)
        PC_nxt = PCPlusImm;
      branch && (inst[14:12] == 3'b101) && (readData1_RF >= readData2_RF):                       // BGE (signed)
        PC_nxt = PCPlusImm;
      branch && (inst[14:12] == 3'b110) && (unsigned'(readData1_RF) <  unsigned'(readData2_RF)): // BLTU
        PC_nxt = PCPlusImm;
      branch && (inst[14:12] == 3'b111) && (unsigned'(readData1_RF) >= unsigned'(readData2_RF)): // BGEU
        PC_nxt = PCPlusImm;
      default:
        PC_nxt = PCPlusFour;
    endcase

  // IMEM
  assign PC_IMEM = PC;

  // DMEM
  assign addrData_DMEM  = res;
  assign wrData_DMEM    = readData2_RF;
  assign MemWrite_DMEM  = memWr;
  assign MemRead_DMEM   = 1'b1;

  // RF
  assign readAddr1_RF = inst[19:15];
  assign readAddr2_RF = inst[24:20];
  assign writeData_RF = RFInput;
  assign writeAddr_RF = inst[11:7];
  assign RegWrite_RF  = regWr;

endmodule
