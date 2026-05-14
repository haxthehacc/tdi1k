// =============================================================================
// rtl/row_sequencer_v2.v
//
// Improved row sequencer.
//
// Fixes vs row_sequencer.v:
//   1. Adds a row counter (`row_cnt`) so that `frame_done` asserts ONCE per
//      frame (= N_ROWS lines) instead of once per line.  A new
//      `line_done` output is exposed for consumers that need the per-line
//      strobe (it matches the legacy `frame_done` behaviour bit-for-bit).
//   2. Adds a 2-FF reset synchronizer (sync-deassert, async-assert) so
//      rst_n recovery is clean.
//   3. Adds a 2-FF synchronizer on `tdi_enable` to remove CDC risk if the
//      bit is sourced from an asynchronous domain (or a bouncing input pad).
//   4. Handles non-divisible LINE_CYCLES/N_ROWS gracefully: any "leftover"
//      cycles at the end of a line are simply idle (all outputs zero); this
//      matches the original behaviour but is now explicit and documented.
//
// Outputs and timing match the original 1-cycle NBA latency vs. line_cnt.
// =============================================================================
module row_sequencer_v2 #(
  parameter N_ROWS      = 60,
  parameter LINE_CYCLES = 5000,
  parameter RST_WIDTH   = 5,
  parameter TX_WIDTH    = 10,
  parameter SEL_WIDTH   = 30
)(
  input  wire              clk,
  input  wire              rst_n,        // async active-low
  input  wire              tdi_enable,   // async / unrelated-clock input
  output reg  [N_ROWS-1:0] TX,
  output reg  [N_ROWS-1:0] RST,
  output reg  [N_ROWS-1:0] SEL,
  output reg               line_done,    // 1-cycle pulse at end of each line
  output reg               frame_done    // 1-cycle pulse at end of each frame
);

  localparam ROW_SLOT   = LINE_CYCLES / N_ROWS;
  localparam TX_OFFSET  = ROW_SLOT - TX_WIDTH - SEL_WIDTH;
  localparam SEL_OFFSET = ROW_SLOT - SEL_WIDTH;

  // ---- Reset synchronizer -------------------------------------------------
  reg rst_meta, rst_n_s;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      rst_meta <= 1'b0;
      rst_n_s  <= 1'b0;
    end else begin
      rst_meta <= 1'b1;
      rst_n_s  <= rst_meta;
    end
  end

  // ---- tdi_enable CDC synchronizer ----------------------------------------
  reg en_meta, tdi_en_s;
  always @(posedge clk or negedge rst_n_s) begin
    if (!rst_n_s) begin
      en_meta  <= 1'b0;
      tdi_en_s <= 1'b0;
    end else begin
      en_meta  <= tdi_enable;
      tdi_en_s <= en_meta;
    end
  end

  reg [$clog2(LINE_CYCLES)-1:0] line_cnt;
  reg [$clog2(N_ROWS)-1:0]      row_cnt;
  integer r;

  always @(posedge clk or negedge rst_n_s) begin
    if (!rst_n_s) begin
      line_cnt   <= 0;
      row_cnt    <= 0;
      TX         <= {N_ROWS{1'b0}};
      RST        <= {N_ROWS{1'b0}};
      SEL        <= {N_ROWS{1'b0}};
      line_done  <= 1'b0;
      frame_done <= 1'b0;
    end else if (!tdi_en_s) begin
      line_cnt   <= 0;
      row_cnt    <= 0;
      TX         <= {N_ROWS{1'b0}};
      RST        <= {N_ROWS{1'b0}};
      SEL        <= {N_ROWS{1'b0}};
      line_done  <= 1'b0;
      frame_done <= 1'b0;
    end else begin
      line_done  <= 1'b0;
      frame_done <= 1'b0;

      // Line counter
      if (line_cnt == LINE_CYCLES - 1) begin
        line_cnt  <= 0;
        line_done <= 1'b1;
        // Row counter advances on every line boundary
        if (row_cnt == N_ROWS - 1) begin
          row_cnt    <= 0;
          frame_done <= 1'b1;
        end else begin
          row_cnt <= row_cnt + 1'b1;
        end
      end else begin
        line_cnt <= line_cnt + 1'b1;
      end

      // Per-row pulse generation (unchanged combinational decode)
      for (r = 0; r < N_ROWS; r = r + 1) begin
        RST[r] <= (line_cnt >= r*ROW_SLOT) &&
                  (line_cnt <  r*ROW_SLOT + RST_WIDTH);
        TX [r] <= (line_cnt >= r*ROW_SLOT + TX_OFFSET) &&
                  (line_cnt <  r*ROW_SLOT + TX_OFFSET + TX_WIDTH);
        SEL[r] <= (line_cnt >= r*ROW_SLOT + SEL_OFFSET) &&
                  (line_cnt <  r*ROW_SLOT + SEL_OFFSET + SEL_WIDTH);
      end
    end
  end

endmodule
