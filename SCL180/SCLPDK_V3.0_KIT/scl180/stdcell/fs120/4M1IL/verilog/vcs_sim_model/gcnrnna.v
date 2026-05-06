////////////////////////////////////////////////////////////////////
// Copyright (c) 2003 Synopsys, Inc.  All Rights Reserved       //
// This information is provided pursuant to a license agreement //
// that grants limited rights of access/use and requires that   //
// the information be treated as confidential.                  //
////////////////////////////////////////////////////////////////////

`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 1ps
 `delay_mode_path
`endif 


// Model type   	: zero timing
// Filename     	: gcnrnna.v
// Description  	:  none_posedge clock gating cells, aX Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.6
//
//


module gcnrnna (CLK,EN,GCLK);

output  GCLK;
input   CLK,EN;

`ifdef functional
not (not_EN,EN);
or #1 (GCLK,not_EN,CLK);
`else
reg notifier,buf_gclk,mem_notifier;
always @(notifier or EN or CLK) begin
  if (notifier !== 1'bx && mem_notifier !== notifier) begin
   buf_gclk = 1'bx;
   mem_notifier = notifier;
  end
  else begin
   buf_gclk = ~EN || CLK;
  end
end
buf #1 (GCLK,buf_gclk);
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam en_lh_gclk_hl=0,clk_lh_gclk_lh=0,clk_hl_gclk_hl=0,en_hl_gclk_lh=0,
 tpw_clk_h=0,tpw_clk_l=0,en_lh_clk_lh=0,en_lh_clk_hl=0,en_hl_clk_lh=0,
  en_hl_clk_hl=0;
$nochange (negedge CLK,posedge EN,en_lh_clk_lh,en_hl_clk_lh,notifier);
$nochange (negedge CLK,negedge EN,en_hl_clk_hl,en_lh_clk_hl,notifier);
$width (posedge CLK,tpw_clk_h,0,notifier);
$width (negedge CLK,tpw_clk_l,0,notifier);
// Delays
 (        EN -=> GCLK) = (en_hl_gclk_lh,en_lh_gclk_hl);
 (        CLK +=> GCLK) = (clk_lh_gclk_lh,clk_hl_gclk_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
