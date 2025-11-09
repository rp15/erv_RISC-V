module dff (
  input  logic [63:0] d,
  input  logic        clk,
  input  logic        rst,
  input  logic        en,
  output logic [63:0] q
);

  always_ff @(posedge clk or negedge rst)
    if (!rst)
      q <= 64'h0400000;
    else if (en)
      q <= d;

endmodule
