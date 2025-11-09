module immGen (
  input  logic [32-1:0] inst,
  input  logic [3-1:0]  immGenType,
  output logic [64-1:0] immediate
);

  always_comb
    unique case (immGenType)

      3'b000:
        immediate = { {32{inst[31]}}, inst[31:12], 12'b0 };

      3'b001:
        immediate = { {53{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0 };

      3'b002:
        immediate = { {52{inst[31]}}, inst[31:20] };

      3'b011:
        immediate = { {51{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0 };

      3'b100:
        immediate = { {52{inst[31]}}, inst[31:25], inst[11:7] };

      default:
        immediate = 64'b0;

    endcase

endmodule
