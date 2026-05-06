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
// Filename     	: decrq2.v
// Description  	:  Buffered Enabled D Flip-Flop with Clear and Q only, 2X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module decrq2 (CP,CDN,D,ENN,Q);

output  Q;
input   CP,CDN,D,ENN;

`ifdef neg_tchk
wire d_CP,d_CDN,d_D,d_ENN;
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (CDN_buf,d_CDN);
buf (D_buf,d_D);
buf (ENN_buf,d_ENN);
`else
buf (CDN_buf,CDN);
buf (D_buf,D);
buf (ENN_buf,ENN);
`endif
`endif

`ifdef functional
U_FD_EN_P_RB #1 (Q,CP,ENN,CDN,D);
`else
reg notifier;
`ifdef neg_tchk
U_FD_EN_P_RB_NO #1 (Q,d_CP,d_ENN,d_CDN,d_D,notifier);
`else
U_FD_EN_P_RB_NO #1 (Q,CP,ENN,CDN,D,notifier);
`endif
`endif

`ifdef functional
`else
wire BOOL_OUT = (((!ENN_buf && D_buf)) && ((!ENN_buf))) || !(!Q || ((!ENN_buf)));
wire vcond1 = ((CDN_buf==1'b1) && (ENN_buf==1'b0));
specify
// Parameter declarations
 specparam tsu_enn_h_cp=0.39,tsu_enn_l_cp=0.47,tsu_d_h_cp=0.30,tsu_d_l_cp=0.34,
 tsu_cdn_h_cp=0.00,th_cp_enn_h=0.00,th_cp_enn_l=0.00,th_cp_d_h=0.00,th_cp_d_l=0.00,
 th_cp_cdn_l=0.30,tpw_cp_h=0.24,tpw_cp_l=0.42,tpw_cdn_l=0.22,cp_lh_q_lh=0,
 cp_lh_q_hl=0,cdn_hl_q_hl_1=0;
// Violation constraints
`ifdef neg_tchk
$setuphold (posedge CP &&& (CDN==1'b1),posedge ENN &&& (CDN==1'b1),tsu_enn_h_cp,th_cp_enn_l,notifier,,,d_CP,d_ENN);
$setuphold (posedge CP &&& (CDN==1'b1),negedge ENN &&& (CDN==1'b1),tsu_enn_l_cp,th_cp_enn_h,notifier,,,d_CP,d_ENN);
$setuphold (posedge CP &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
$setuphold (posedge CP &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
$recrem (posedge CDN &&& (ENN==1'b0),posedge CP &&& (ENN==1'b0),tsu_cdn_h_cp,th_cp_cdn_l,notifier,,,d_CDN,d_CP);
`else
 $setup (posedge ENN &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_enn_h_cp,notifier);
 $setup (negedge ENN &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_enn_l_cp,notifier);
 $setup (posedge D &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_d_l_cp,notifier);
 $recovery (posedge CDN &&& (ENN==1'b0),posedge CP &&& (ENN==1'b0),tsu_cdn_h_cp,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),negedge ENN &&& (CDN==1'b1),th_cp_enn_h,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),posedge ENN &&& (CDN==1'b1),th_cp_enn_l,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),th_cp_d_l,notifier);
 $hold  (posedge CP &&& (ENN==1'b0),posedge CDN &&& (ENN==1'b0),th_cp_cdn_l,notifier);
`endif
 $width (posedge CP &&& (vcond1==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (vcond1==1'b1),tpw_cp_l,0,notifier);
 $width (negedge CDN,tpw_cdn_l,0,notifier);
// Delays
 if ((CDN==1'b1) && (ENN==1'b0))
 (posedge CP   => (Q +: BOOL_OUT)) = (cp_lh_q_lh,cp_lh_q_hl);
 (negedge CDN  => (Q -: 1'b1)) = (0,cdn_hl_q_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
