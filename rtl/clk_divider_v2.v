// =============================================================================
// rtl/clk_divider_v2.v
//
// Improved clock divider with reset synchronization.
//
// Changes vs clk_divider.v:
//   - Adds 2-FF synchronizer for the deassertion edge of asynchronous reset
//     (rst_n is sampled into the clk_50m domain so that recovery from reset
//     does not violate flop recovery/removal timing).
//   - Functionally identical otherwise (same outputs, same period).
//
// rst_n input is still asynchronous-active-low (held low to reset). Only its
// rising/deassertion edge is synchronized.
// =============================================================================
module clk_divider_v2 #(
  parameter LINE_CYCLES = 5000
)(
  input  wire clk_50m,
  input  wire rst_n,         // async active-low
  output reg  clk_line,
  output reg  clk_line_pulse
);

  // ---- 2-FF reset synchronizer (sync-deassert, async-assert) --------------
  reg rst_sync_meta;
  reg rst_n_sync;
  always @(posedge clk_50m or negedge rst_n) begin
    if (!rst_n) begin
      rst_sync_meta <= 1'b0;
      rst_n_sync    <= 1'b0;
    end else begin
      rst_sync_meta <= 1'b1;
      rst_n_sync    <= rst_sync_meta;
    end
  end

  localparam CNT_WIDTH = $clog2(LINE_CYCLES);
  reg [CNT_WIDTH-1:0] cnt;

  always @(posedge clk_50m or negedge rst_n_sync) begin
    if (!rst_n_sync) begin
      cnt            <= {CNT_WIDTH{1'b0}};
      clk_line       <= 1'b0;
      clk_line_pulse <= 1'b0;
    end else begin
      clk_line_pulse <= 1'b0;
      if (cnt == LINE_CYCLES - 1) begin
        cnt            <= {CNT_WIDTH{1'b0}};
        clk_line       <= ~clk_line;
        clk_line_pulse <= 1'b1;
      end else begin
        cnt <= cnt + 1'b1;
      end
    end
  end

endmodule
