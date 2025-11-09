`timescale 1ns/1ps

module tb_riscV;
  // ---------------------------
  // Clock / Reset
  // ---------------------------
  logic clk = 0, rst = 1;
  always #5 clk = ~clk;  // 100 MHz

  initial begin
    rst = 1;
    repeat (5) @(posedge clk);
    rst = 0;
  end

  // ---------------------------
  // DUT I/O wires
  // ---------------------------
  logic [31:0] inst;
  logic [63:0] PC_IMEM;

  logic [63:0] readData_DMEM;
  logic [63:0] addrData_DMEM, wrData_DMEM;
  logic        MemWrite_DMEM, MemRead_DMEM;

  logic signed [63:0] readData1_RF, readData2_RF;
  logic [4:0]         readAddr1_RF, readAddr2_RF, writeAddr_RF;
  logic [63:0]        writeData_RF;
  logic               RegWrite_RF;

  // ---------------------------
  // Instantiate DUT
  // ---------------------------
  riscV dut (
    .inst,
    .PC_IMEM,

    .readData_DMEM,
    .addrData_DMEM,
    .wrData_DMEM,
    .MemWrite_DMEM,
    .MemRead_DMEM,

    .readData1_RF,
    .readData2_RF,
    .readAddr1_RF,
    .readAddr2_RF,
    .writeData_RF,
    .writeAddr_RF,
    .RegWrite_RF,

    .clk,
    .rst
  );

  // ---------------------------
  // Tiny instruction memory
  // ---------------------------
  localparam IMEM_DEPTH = 64;
  logic [31:0] imem [0:IMEM_DEPTH-1];

  // PC is byte address; IMEM is word addressed
  assign inst = imem[PC_IMEM[31:2]];

  // ---------------------------
  // Simple data memory (64-bit words)
  // ---------------------------
  localparam DMEM_DEPTH = 64;
  logic [63:0] dmem [0:DMEM_DEPTH-1];

  // Read: combinational (MEM is always-read in your top)
  wire [63:0] dmem_rdata = dmem[addrData_DMEM[63:3]];
  assign readData_DMEM = dmem_rdata;

  // Write: on MemWrite_DMEM
  always_ff @(posedge clk) begin
    if (MemWrite_DMEM) begin
      dmem[addrData_DMEM[63:3]] <= wrData_DMEM;
    end
  end

  // ---------------------------
  // Minimal register-file model
  // ---------------------------
  logic [63:0] rf [0:31];

  // Drive reads combinationally
  assign readData1_RF = (readAddr1_RF == 0) ? 64'd0 : rf[readAddr1_RF];
  assign readData2_RF = (readAddr2_RF == 0) ? 64'd0 : rf[readAddr2_RF];

  // Capture writes
  always_ff @(posedge clk) begin
    if (RegWrite_RF && (writeAddr_RF != 0))
      rf[writeAddr_RF] <= writeData_RF;
    // Enforce x0 = 0
    rf[0] <= 64'd0;
  end

  // ---------------------------
  // Encoders for a few RV64I/M ops
  // ---------------------------
  function automatic [31:0] enc_ADDI(input [4:0] rd, rs1, input integer imm);
    // opcode=0010011, funct3=000
    enc_ADDI = { {20{imm[11]}}, imm[11:0], rs1, 3'b000, rd, 7'b0010011 };
  endfunction

  function automatic [31:0] enc_Rtype(input [4:0] rd, rs1, rs2, input [6:0] funct7, input [2:0] funct3);
    // opcode=0110011
    enc_Rtype = { funct7, rs2, rs1, funct3, rd, 7'b0110011 };
  endfunction

  function automatic [31:0] enc_ADD (input [4:0] rd, rs1, rs2);
    enc_ADD = enc_Rtype(rd, rs1, rs2, 7'b0000000, 3'b000);
  endfunction

  function automatic [31:0] enc_SUB (input [4:0] rd, rs1, rs2);
    enc_SUB = enc_Rtype(rd, rs1, rs2, 7'b0100000, 3'b000);
  endfunction

  function automatic [31:0] enc_AND (input [4:0] rd, rs1, rs2);
    enc_AND = enc_Rtype(rd, rs1, rs2, 7'b0000000, 3'b111);
  endfunction

  function automatic [31:0] enc_OR (input [4:0] rd, rs1, rs2);
    enc_OR = enc_Rtype(rd, rs1, rs2, 7'b0000000, 3'b110);
  endfunction

  function automatic [31:0] enc_MUL (input [4:0] rd, rs1, rs2);
    // M-extension: funct7=0000001, funct3=000
    enc_MUL = enc_Rtype(rd, rs1, rs2, 7'b0000001, 3'b000);
  endfunction

  function automatic [31:0] enc_SD (input [4:0] rs2, rs1, input integer imm);
    // S-type: opcode=0100011, funct3=011 (SD), imm[11:5], rs2, rs1, imm[4:0]
    enc_SD = { imm[11:5], rs2, rs1, 3'b011, imm[4:0], 7'b0100011 };
  endfunction

  function automatic [31:0] enc_LD (input [4:0] rd, rs1, input integer imm);
    // I-type: opcode=0000011, funct3=011 (LD)
    enc_LD = { {20{imm[11]}}, imm[11:0], rs1, 3'b011, rd, 7'b0000011 };
  endfunction

  function automatic [31:0] enc_BEQ(input [4:0] rs1, rs2, input integer imm);
    // B-type: opcode=1100011, funct3=000
    // imm is bytes; encode into imm[12|10:5|4:1|11] with LSB zero
    automatic int simm = imm >>> 1;  // will place <<1 back by bit positions
    enc_BEQ = { simm[12], simm[10:5], rs2, rs1, 3'b000, simm[4:1], simm[11], 7'b1100011 };
  endfunction

  function automatic [31:0] enc_BNE(input [4:0] rs1, rs2, input integer imm);
    // funct3=001
    automatic int simm = imm >>> 1;
    enc_BNE = { simm[12], simm[10:5], rs2, rs1, 3'b001, simm[4:1], simm[11], 7'b1100011 };
  endfunction

  // ---------------------------
  // Program
  // ---------------------------
  // x1 <- 5
  // x2 <- 3
  // x3 <- x1 + x2 = 8
  // x4 <- x1 - x2 = 2
  // x5 <- x1 & x2 = 1
  // x6 <- x1 | x2 = 7
  // x7 <- x1 * x2 = 15
  // MEM[0] <- x3 (SD)
  // x8 <- MEM[0] (LD)  => 8
  // BEQ x3,x8,+8 -> skip next ADDI if equal
  // ADDI x9,x0,123 (should be skipped)
  // BNE x3,x4,+8 -> should branch (8 != 2) and skip next ADDI
  // ADDI x10,x0,77 (should be skipped)
  // (end: loop with BEQ x0,x0,0)

  localparam int START_PC = 0;
  int pc = START_PC >> 2;
  initial begin
    // Clear memories & RF
    //for (int i = 0; i < IMEM_DEPTH; i++) imem[i] = 32'h00000013; // NOP = ADDI x0,x0,0
    //for (int i = 0; i < DMEM_DEPTH; i++) dmem[i] = '0;
    //for (int i = 0; i < 32; i++) rf[i] = '0;

    imem[pc++] = enc_ADDI(5'd1, 5'd0, 5);     // x1 = 5
    imem[pc++] = enc_ADDI(5'd2, 5'd0, 3);     // x2 = 3
    imem[pc++] = enc_ADD (5'd3, 5'd1, 5'd2);  // x3 = 8
    imem[pc++] = enc_SUB (5'd4, 5'd1, 5'd2);  // x4 = 2
    imem[pc++] = enc_AND (5'd5, 5'd1, 5'd2);  // x5 = 1
    imem[pc++] = enc_OR  (5'd6, 5'd1, 5'd2);  // x6 = 7
    imem[pc++] = enc_MUL (5'd7, 5'd1, 5'd2);  // x7 = 15

    // SD x3,0(x0)
    imem[pc++] = enc_SD(5'd3, 5'd0, 0);
    // LD x8,0(x0)
    imem[pc++] = enc_LD(5'd8, 5'd0, 0);

    // BEQ x3,x8, +8  (skip next ADDI if equal)
    imem[pc++] = enc_BEQ(5'd3, 5'd8, 8);
    imem[pc++] = enc_ADDI(5'd9, 5'd0, 123);   // should be skipped

    // BNE x3,x4, +8  (8 != 2 -> take branch)
    imem[pc++] = enc_BNE(5'd3, 5'd4, 8);
    imem[pc++] = enc_ADDI(5'd10, 5'd0, 77);   // should be skipped

    // Tight loop: BEQ x0,x0,0 (halt)
    imem[pc++] = enc_BEQ(5'd0, 5'd0, 0);

    // Run long enough
    repeat (200) @(posedge clk);

    // ---------------------------
    // Checks
    // ---------------------------
    // Registers
    assert(rf[1] == 64'd5)  else $fatal("x1 mismatch: %0d", rf[1]);
    assert(rf[2] == 64'd3)  else $fatal("x2 mismatch: %0d", rf[2]);
    assert(rf[3] == 64'd8)  else $fatal("x3 mismatch: %0d", rf[3]);
    assert(rf[4] == 64'd2)  else $fatal("x4 mismatch: %0d", rf[4]);
    assert(rf[5] == 64'd1)  else $fatal("x5 mismatch: %0d", rf[5]);
    assert(rf[6] == 64'd7)  else $fatal("x6 mismatch: %0d", rf[6]);
    assert(rf[7] == 64'd15) else $fatal("x7 mismatch: %0d", rf[7]);

    // Memory
    assert(dmem[0] == 64'd8) else $fatal("DMEM[0] mismatch: %0d", dmem[0]);

    // Branch-skipped writes
    assert(rf[9]  == 64'd0)  else $fatal("x9 should be unchanged (skipped), got %0d", rf[9]);
    assert(rf[10] == 64'd0)  else $fatal("x10 should be unchanged (skipped), got %0d", rf[10]);

    $display("[TB] All checks passed ✅");
    $finish;
  end

endmodule
