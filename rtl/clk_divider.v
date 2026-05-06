module clk_divider #(
  parameter LINE_CYCLES = 5000
)(
  input  wire clk_50m,
  input  wire rst_n,
  output reg  clk_line,
  output reg  clk_line_pulse
);

  localparam CNT_WIDTH = $clog2(LINE_CYCLES);

  reg [CNT_WIDTH-1:0] cnt;

  always @(posedge clk_50m or negedge rst_n) begin
    if (!rst_n) begin
      cnt            <= 0;
      clk_line       <= 0;
      clk_line_pulse <= 0;
    end else begin
      clk_line_pulse <= 0;
      if (cnt == LINE_CYCLES - 1) begin
        cnt            <= 0;
        clk_line       <= ~clk_line;
        clk_line_pulse <= 1;
      end else begin
        cnt <= cnt + 1;
      end
    end
  end

endmodule
