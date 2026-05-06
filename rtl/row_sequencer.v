module row_sequencer #(
  parameter N_ROWS      = 60,
  parameter LINE_CYCLES = 5000,
  parameter RST_WIDTH   = 5,
  parameter TX_WIDTH    = 10,
  parameter SEL_WIDTH   = 30
)(
  input  wire              clk,
  input  wire              rst_n,
  input  wire              tdi_enable,
  output reg  [N_ROWS-1:0] TX,
  output reg  [N_ROWS-1:0] RST,
  output reg  [N_ROWS-1:0] SEL,
  output reg               frame_done
);

  localparam ROW_SLOT   = LINE_CYCLES / N_ROWS;
  localparam TX_OFFSET  = ROW_SLOT - TX_WIDTH - SEL_WIDTH;
  localparam SEL_OFFSET = ROW_SLOT - SEL_WIDTH;

  reg [$clog2(LINE_CYCLES)-1:0] line_cnt;
  integer r;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      line_cnt   <= 0;
      frame_done <= 0;
      TX         <= 0;
      RST        <= 0;
      SEL        <= 0;
    end else if (!tdi_enable) begin
      TX         <= 0;
      RST        <= 0;
      SEL        <= 0;
      frame_done <= 0;
    end else begin
      frame_done <= 0;
      if (line_cnt == LINE_CYCLES - 1)
        line_cnt <= 0;
      else
        line_cnt <= line_cnt + 1;

      for (r = 0; r < N_ROWS; r = r+1) begin
        RST[r] <= (line_cnt >= r*ROW_SLOT) &&
                  (line_cnt <  r*ROW_SLOT + RST_WIDTH);
        TX[r]  <= (line_cnt >= r*ROW_SLOT + TX_OFFSET) &&
                  (line_cnt <  r*ROW_SLOT + TX_OFFSET + TX_WIDTH);
        SEL[r] <= (line_cnt >= r*ROW_SLOT + SEL_OFFSET) &&
                  (line_cnt <  r*ROW_SLOT + SEL_OFFSET + SEL_WIDTH);
      end

      if (line_cnt == LINE_CYCLES - 1)
        frame_done <= 1;
    end
  end

endmodule
