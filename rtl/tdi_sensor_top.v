// =============================================================================
// rtl/tdi_sensor_top.v
//
// Top-level integration of the TDI 1024x60 imager.
//
// Digital blocks (synthesized + PNR'd):
//   - clk_divider_v2     : 50 MHz -> line clock
//   - row_sequencer_v2   : per-row TX / RST / SEL pulse generator
//
// Analog blocks (instantiated as black-box modules, layout-only):
//   - pixel_array_1024x60 : 1024 x 60 4T pixel matrix
//   - column_isource      : per-column current source / bias
//
// All analog blocks are declared as empty modules in this file so that the
// digital netlist is structurally complete.  Their GDS is merged at chip
// assembly via scripts/merge_top_gds.py.
// =============================================================================

`timescale 1ns/1ps

module tdi_sensor_top #(
  parameter N_ROWS      = 60,
  parameter N_COLS      = 1024,
  parameter LINE_CYCLES = 5000
) (
  // Digital control
  input  wire                  clk_50m,
  input  wire                  rst_n,
  input  wire                  tdi_enable,

  // Status / observation
  output wire                  clk_line,
  output wire                  clk_line_pulse,
  output wire                  line_done,
  output wire                  frame_done,

  // Analog supplies / biases (top-level pads — pass through to analog blocks)
  inout  wire                  vdd_a,
  inout  wire                  vss_a,
  inout  wire                  vref_pix,
  inout  wire                  ibias_col,

  // Pixel-array analog outputs (one per column, bonded out / to ADC)
  inout  wire [N_COLS-1:0]     col_out
);

  // ---------------------------------------------------------------------------
  // Internal nets driven by digital sequencers
  // ---------------------------------------------------------------------------
  wire [N_ROWS-1:0] TX;
  wire [N_ROWS-1:0] RST;
  wire [N_ROWS-1:0] SEL;

  // ---------------------------------------------------------------------------
  // Clock divider (50 MHz -> line-rate)
  // ---------------------------------------------------------------------------
  clk_divider_v2 #(
    .LINE_CYCLES (LINE_CYCLES)
  ) u_clk_divider (
    .clk_50m        (clk_50m),
    .rst_n          (rst_n),
    .clk_line       (clk_line),
    .clk_line_pulse (clk_line_pulse)
  );

  // ---------------------------------------------------------------------------
  // Row sequencer (drives per-row TX / RST / SEL pulses)
  // ---------------------------------------------------------------------------
  row_sequencer_v2 #(
    .N_ROWS      (N_ROWS),
    .LINE_CYCLES (LINE_CYCLES)
  ) u_row_sequencer (
    .clk        (clk_50m),
    .rst_n      (rst_n),
    .tdi_enable (tdi_enable),
    .TX         (TX),
    .RST        (RST),
    .SEL        (SEL),
    .line_done  (line_done),
    .frame_done (frame_done)
  );

  // ---------------------------------------------------------------------------
  // Pixel array (analog, 1024 x 60 4T pixels) — black-box for synthesis
  // ---------------------------------------------------------------------------
  pixel_array_1024x60 u_pixel_array (
    .TX        (TX),
    .RST       (RST),
    .SEL       (SEL),
    .vdd_a     (vdd_a),
    .vss_a     (vss_a),
    .vref_pix  (vref_pix),
    .col_out   (col_out)
  );

  // ---------------------------------------------------------------------------
  // Per-column current sources / biases — black-box
  // ---------------------------------------------------------------------------
  column_isource u_column_isource (
    .col_in    (col_out),
    .ibias_col (ibias_col),
    .vss_a     (vss_a)
  );

endmodule


// -----------------------------------------------------------------------------
// Black-box analog module declarations (layout-only; no behavioral content).
// -----------------------------------------------------------------------------
(* blackbox *)
module pixel_array_1024x60 (
  input  wire [59:0]    TX,
  input  wire [59:0]    RST,
  input  wire [59:0]    SEL,
  inout  wire           vdd_a,
  inout  wire           vss_a,
  inout  wire           vref_pix,
  inout  wire [1023:0]  col_out
);
endmodule

(* blackbox *)
module column_isource (
  inout  wire [1023:0]  col_in,
  inout  wire           ibias_col,
  inout  wire           vss_a
);
endmodule
