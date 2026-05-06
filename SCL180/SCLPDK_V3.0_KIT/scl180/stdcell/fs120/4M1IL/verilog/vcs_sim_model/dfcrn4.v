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
// Filename     	: dfcrn4.v
// Description  	:  Buffered D Flip-Flop with Clear and QN only, 4X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module dfcrn4 (D,CP,CDN,QN);

output  QN;
input   D,CP,CDN;

`ifdef neg_tchk
wire d_D,d_CP,d_CDN;
`endif

`ifdef functional
U_FD_P_RB #1 (QN_not,D,CP,CDN);
`else
reg notifier;
`ifdef neg_tchk
U_FD_P_RB_NO #1 (QN_not,d_D,d_CP,d_CDN,notifier);
`else
U_FD_P_RB_NO #1 (QN_not,D,CP,CDN,notifier);
`endif
`endif

not (QN,QN_not);

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_cp=0.12,tsu_d_l_cp=0.22,tsu_cdn_h_cp=0.00,th_cp_d_h=0.00,
 th_cp_d_l=0.00,th_cp_cdn_l=0.33,tpw_cp_h=0.26,tpw_cp_l=0.43,tpw_cdn_l=0.23,
 cp_lh_qn_hl=0,cp_lh_qn_lh=0,cdn_hl_qn_lh_1=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (CDN==1'b1),posedge D &&& (CDN==1'b1),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP &&& (CDN==1'b1),negedge D &&& (CDN==1'b1),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
 $recrem (posedge CDN,posedge CP,tsu_cdn_h_cp,th_cp_cdn_l,notifier,,,d_CDN,d_CP);
`else
 $setup (posedge D &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_d_l_cp,notifier);
 $recovery (posedge CDN,posedge CP,tsu_cdn_h_cp,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),negedge D &&& (CDN==1'b1),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),posedge D &&& (CDN==1'b1),th_cp_d_l,notifier);
 $hold  (posedge CP,posedge CDN,th_cp_cdn_l,notifier);
`endif
 $width (posedge CP &&& (CDN==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (CDN==1'b1),tpw_cp_l,0,notifier);
 $width (negedge CDN,tpw_cdn_l,0,notifier);
// Delays
 if (CDN==1'b1)
 (posedge CP   => (QN -: D   )) = (cp_lh_qn_lh,cp_lh_qn_hl);
 (negedge CDN  => (QN +: 1'b1)) = (cdn_hl_qn_lh_1,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
