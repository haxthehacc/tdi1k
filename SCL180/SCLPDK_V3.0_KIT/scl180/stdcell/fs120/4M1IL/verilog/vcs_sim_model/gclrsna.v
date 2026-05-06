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
// Filename     	: gclrsna.v
// Description  	:  latch_posedge_postcontrol clock gating cells, aX Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.10
//
//


module gclrsna (EN,CLK,SE,GCLK);

output  GCLK;
input   EN,SE,CLK;

`ifdef neg_tchk
wire d_CLK,d_EN;
`endif


`ifdef functional
U_LD_N #1 (init,EN,CLK);
`else
reg notifier;
`ifdef neg_tchk
U_LD_N_NO #1 (init,d_EN,d_CLK,notifier);
`else
U_LD_N_NO #1 (init,EN,CLK,notifier);
`endif
`endif

nor (init_2,SE,init);
`ifdef neg_tchk
not (NOT_CLK,d_CLK);
`else
not (NOT_CLK,CLK);
`endif
nor (GCLK,NOT_CLK,init_2);

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_en_h_clk=0.04,tsu_en_l_clk=0.16,th_clk_en_h=0.00,th_clk_en_l=0.00,tpw_clk_l=0.24,clk_lh_gclk_lh=0,clk_lh_gclk_hl=0,se_gclk_lh=0,se_gclk_hl=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CLK ,posedge EN ,tsu_en_h_clk,th_clk_en_l,notifier,,,d_CLK,d_EN);
 $setuphold (posedge CLK ,negedge EN ,tsu_en_l_clk,th_clk_en_h,notifier,,,d_CLK,d_EN);
`else
 $setup (posedge EN ,posedge CLK ,tsu_en_h_clk,notifier);
 $setup (negedge EN ,posedge CLK ,tsu_en_l_clk,notifier);
 $hold  (posedge CLK ,negedge EN ,th_clk_en_h,notifier);
 $hold  (posedge CLK ,posedge EN ,th_clk_en_l,notifier);
`endif
 $width (negedge CLK ,tpw_clk_l,0,notifier);
// Delays
 if (SE==1'b0)
 (posedge CLK  => (GCLK +: EN )) = (clk_lh_gclk_lh,clk_lh_gclk_hl);
 (SE => GCLK) = (se_gclk_lh,se_gclk_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
