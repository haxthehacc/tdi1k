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
// Filename     	: lanln4.v
// Description  	:  Buffered Latch with Low Enable and QN only, 4X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module lanln4 (EN,D,QN);

output  QN;
input   EN,D;

`ifdef neg_tchk
wire d_EN,d_D;
`endif

`ifdef functional
U_LD_N (QN_not,D,EN);
`else
reg notifier;
`ifdef neg_tchk
U_LD_N_NO (QN_not,d_D,d_EN,notifier);
`else
U_LD_N_NO (QN_not,D,EN,notifier);
`endif
`endif

not #1 (QN,QN_not);

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_en=0.21,tsu_d_l_en=0.27,th_en_d_h=0.00,th_en_d_l=0.00,
 tpw_en_l=0.26,d_lh_qn_hl=0,d_hl_qn_lh=0,en_hl_qn_lh=0,en_hl_qn_hl=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge EN,posedge D,tsu_d_h_en,th_en_d_l,notifier,,,d_EN,d_D);
 $setuphold (posedge EN,negedge D,tsu_d_l_en,th_en_d_h,notifier,,,d_EN,d_D);
`else
 $setup (posedge D,posedge EN,tsu_d_h_en,notifier);
 $setup (negedge D,posedge EN,tsu_d_l_en,notifier);
 $hold  (posedge EN,negedge D,th_en_d_h,notifier);
 $hold  (posedge EN,posedge D,th_en_d_l,notifier);
`endif
 $width (negedge EN,tpw_en_l,0,notifier);
// Delays
 if (EN==1'b0)
 (        D  -=> QN) = (d_hl_qn_lh,d_lh_qn_hl);
 (negedge EN  => (QN -: D  )) = (en_hl_qn_lh,en_hl_qn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 1ps


