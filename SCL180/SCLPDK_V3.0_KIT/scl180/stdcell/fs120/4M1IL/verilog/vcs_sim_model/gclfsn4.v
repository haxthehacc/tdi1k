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
// Filename     	: gclfsn4.v
// Description  	:  latch_negedge_postcontrol clock gating cells, 4X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.10
//
//


module gclfsn4 (EN,CLK,SE,GCLK);

output  GCLK;
input   EN,SE,CLK;

`ifdef neg_tchk
wire d_CLK,d_EN;
`endif


`ifdef functional
U_LD_P #1 (init,EN,CLK);
`else
reg notifier;
`ifdef neg_tchk
U_LD_P_NO #1 (init,d_EN,d_CLK,notifier);
`else
U_LD_P_NO #1 (init,EN,CLK,notifier);
`endif
`endif

nor (init_2,init,SE);
`ifdef neg_tchk
or (GCLK,init_2,d_CLK);
`else
or (GCLK,init_2,CLK);
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_en_h_clk=0.04,tsu_en_l_clk=0.16,th_clk_en_h=0.00,th_clk_en_l=0.00,tpw_clk_h=0.24,clk_hl_gclk_lh=0,clk_hl_gclk_hl=0,se_gclk_lh=0,se_gclk_hl=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge CLK ,posedge EN ,tsu_en_h_clk,th_clk_en_l,notifier,,,d_CLK,d_EN);
 $setuphold (negedge CLK ,negedge EN ,tsu_en_l_clk,th_clk_en_h,notifier,,,d_CLK,d_EN);
`else
 $setup (posedge EN ,negedge CLK ,tsu_en_h_clk,notifier);
 $setup (negedge EN ,negedge CLK ,tsu_en_l_clk,notifier);
 $hold  (negedge CLK ,negedge EN ,th_clk_en_h,notifier);
 $hold  (negedge CLK ,posedge EN ,th_clk_en_l,notifier);
`endif
 $width (posedge CLK ,tpw_clk_h,0,notifier);
// Delays
 if (SE==1'b0)
 (negedge CLK  => (GCLK -: EN )) = (clk_hl_gclk_lh,clk_hl_gclk_hl);
 (SE => GCLK) = (se_gclk_lh,se_gclk_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
