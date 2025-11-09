function [63:0] upper_dword(input [127:0] val128);
  upper_dword = val128[127:64];
endfunction

module risc5ALU_core
(
  input  logic signed [64 - 1:0] in0,
  input  logic signed [64 - 1:0] in1,

  input  logic [6 - 1:0] ALUSel,

  output logic signed [64 - 1:0] res

  //output logic zero
);

  typedef logic signed [31:0] WORD;

  // ALU
  always_comb
    unique case (ALUSel)
      'd0:  res = in0 + in1;
      'd1:  res = WORD'(in0[31:0] + in1[31:0]);
      'd2:  res = (in0 < in1) ? 64'b1 : 64'b0;
      'd3:  res = (unsigned'(in0) < unsigned'(in1)) ? 64'b1 : 64'b0;
      'd4:  res = in0 ^ in1;
      'd5:  res = in0 | in1;
      'd6:  res = in0 & in1;
      'd7:  res = in0 << in1[5:0];
      'd8:  res = in0 >> in1[5:0];
      'd9:  res = in0 >>> in1[5:0];
      'd10: res = WORD'(in0[31:0] << in1[4:0]);
      'd11: res = WORD'(in0[31:0] >> in1[4:0]);
      'd12: res = WORD'(in0[31:0] >>> in1[4:0]);
      'd13: res = in0 - in1;
      'd14: res = WORD'(in0[31:0] - in1[31:0]);
      'd15: res = in0 * in1;
      'd16: res = WORD'(in0[31:0] * in1[31:0]);
      'd17: res = upper_dword(in0 * in1);
      'd18: res = upper_dword(in0 * unsigned'(in1));
      'd19: res = upper_dword(unsigned'(in0) * unsigned'(in1));
      'd20: res = in0 / in1;
      'd21: res = WORD'(in0[31:0] / in1[31:0]);
      'd22: res = unsigned'(in0) / unsigned'(in1);
      'd23: res = WORD'(unsigned'(in0[31:0]) / unsigned'(in1[31:0]));
      'd24: res = in0 % in1;
      'd25: res = WORD'(in0[31:0] % in1[31:0]);
      'd26: res = unsigned'(in0) % unsigned'(in1);
      'd27: res = WORD'(unsigned'(in0[31:0]) % unsigned'(in1[31:0]));
      default: res = 64'b0;
    endcase

  // assign zero = ~|res;

endmodule : risc5ALU_core
