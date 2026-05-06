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
// Filename     	: secfq4.v
// Description  	:  Muxed Scan Enable D Flip-Flop with Clear and Q only, 4X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
// Added negedge to CPN 
// at delay path        : 20Dec05 assafma & bengil 
// Added source to above : 29Jun06 tamasto
// Add `+` for veritime usage  : 11July06 tamasto


module secfq4 (CPN,CDN,ENN,D,SC,SD,Q);

output  Q;
input   CPN,CDN,ENN,D,SC,SD;

`ifdef neg_tchk
wire d_CPN,d_CDN,d_ENN,d_D,d_SC,d_SD;
`endif

`ifdef functional
not (not_CPN,CPN);
U_FD_SC_EN_P_RB #1 (Q,not_CPN,ENN,SC,CDN,D,SD);
`else
reg notifier;
`ifdef neg_tchk
not (not_CPN,d_CPN);
U_FD_SC_EN_P_RB_NO #1 (Q,not_CPN,d_ENN,d_SC,d_CDN,d_D,d_SD,notifier);
`else
not (not_CPN,CPN);
U_FD_SC_EN_P_RB_NO #1 (Q,not_CPN,ENN,SC,CDN,D,SD,notifier);
`endif
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (CDN_buf,d_CDN);
buf (SC_buf,d_SC);
buf (ENN_buf,d_ENN);
`else
buf (CDN_buf,CDN);
buf (SC_buf,SC);
buf (ENN_buf,ENN);
`endif


wire vcond1 = ((CDN_buf==1'b1) && (SC_buf==1'b1));
wire vcond_CDN_vio = ((ENN_buf==1'b0) || (SC_buf==1'b1));
wire vcond_ENN_vio = ((CDN_buf==1'b1) && (SC_buf==1'b0));
wire vcond_D_vio = ((CDN_buf==1'b1) && (SC_buf==1'b0) && (ENN_buf==1'b0));
wire vcond2 = ((CDN_buf==1'b1) && (SC_buf==1'b0));
specify
// Parameter declarations
 specparam tsu_sd_h_cpn=0.53,tsu_sd_l_cpn=0.66,tsu_sc_h_cpn=0.68,tsu_sc_l_cpn=0.77,
 tsu_enn_h_cpn=0.52,tsu_enn_l_cpn=0.75,tsu_d_h_cpn=0.39,tsu_d_l_cpn=0.53,tsu_cdn_h_cpn=0.00,
 th_cpn_sd_h=0.00,th_cpn_sd_l=0.00,th_cpn_sc_h=0.00,th_cpn_sc_l=0.00,th_cpn_enn_h=0.00,
 th_cpn_enn_l=0.00,th_cpn_d_h=0.00,th_cpn_d_l=0.00,th_cpn_cdn_l=0.22,tpw_cpn_h=0.21,
 tpw_cpn_l=0.42,tpw_cdn_l=0.16,cpn_hl_q_lh_1=0,cpn_hl_q_hl_1=0,cdn_hl_q_hl_1=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge CPN &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),tsu_sd_h_cpn,th_cpn_sd_l,notifier,,,d_CPN,d_SD);
 $setuphold (negedge CPN &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),tsu_sd_l_cpn,th_cpn_sd_h,notifier,,,d_CPN,d_SD);
 $setuphold (negedge CPN &&& (CDN==1'b1),posedge SC &&& (CDN==1'b1),tsu_sc_h_cpn,th_cpn_sc_l,notifier,,,d_CPN,d_SC);
 $setuphold (negedge CPN &&& (CDN==1'b1),negedge SC &&& (CDN==1'b1),tsu_sc_l_cpn,th_cpn_sc_h,notifier,,,d_CPN,d_SC);
 $setuphold (negedge CPN &&& (CDN==1'b1),posedge ENN &&& (vcond_ENN_vio==1'b1),tsu_enn_h_cpn,th_cpn_enn_l,notifier,,,d_CPN,d_ENN);
 $setuphold (negedge CPN &&& (CDN==1'b1),negedge ENN &&& (vcond_ENN_vio==1'b1),tsu_enn_l_cpn,th_cpn_enn_h,notifier,,,d_CPN,d_ENN);
 $setuphold (negedge CPN &&& (vcond2==1'b1),posedge D &&& (vcond_D_vio==1'b1),tsu_d_h_cpn,th_cpn_d_l,notifier,,,d_CPN,d_D);
 $setuphold (negedge CPN &&& (vcond2==1'b1),negedge D &&& (vcond_D_vio==1'b1),tsu_d_l_cpn,th_cpn_d_h,notifier,,,d_CPN,d_D);
 $recrem (posedge CDN &&& (vcond_CDN_vio==1'b1) ,negedge CPN,tsu_cdn_h_cpn,th_cpn_cdn_l,notifier,,,d_CDN,d_CPN);
`else
 $setup (posedge SD &&& (vcond1==1'b1),negedge CPN &&& (vcond1==1'b1),tsu_sd_h_cpn,notifier);
 $setup (negedge SD &&& (vcond1==1'b1),negedge CPN &&& (vcond1==1'b1),tsu_sd_l_cpn,notifier);
 $setup (posedge SC &&& (CDN==1'b1),negedge CPN &&& (CDN==1'b1),tsu_sc_h_cpn,notifier);
 $setup (negedge SC &&& (CDN==1'b1),negedge CPN &&& (CDN==1'b1),tsu_sc_l_cpn,notifier);
 $setup (posedge ENN &&& (vcond_ENN_vio==1'b1),negedge CPN &&& (CDN==1'b1),tsu_enn_h_cpn,notifier);
 $setup (negedge ENN &&& (vcond_ENN_vio==1'b1),negedge CPN &&& (CDN==1'b1),tsu_enn_l_cpn,notifier);
 $setup (posedge D &&& (vcond_D_vio==1'b1),negedge CPN &&& (vcond2==1'b1),tsu_d_h_cpn,notifier);
 $setup (negedge D &&& (vcond_D_vio==1'b1),negedge CPN &&& (vcond2==1'b1),tsu_d_l_cpn,notifier);
 $recovery (posedge CDN &&& (vcond_CDN_vio==1'b1) ,negedge CPN,tsu_cdn_h_cpn,notifier);
 $hold  (negedge CPN &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),th_cpn_sd_h,notifier);
 $hold  (negedge CPN &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),th_cpn_sd_l,notifier);
 $hold  (negedge CPN &&& (CDN==1'b1),negedge SC &&& (CDN==1'b1),th_cpn_sc_h,notifier);
 $hold  (negedge CPN &&& (CDN==1'b1),posedge SC &&& (CDN==1'b1),th_cpn_sc_l,notifier);
 $hold  (negedge CPN &&& (CDN==1'b1),negedge ENN &&& (vcond_ENN_vio==1'b1),th_cpn_enn_h,notifier);
 $hold  (negedge CPN &&& (CDN==1'b1),posedge ENN &&& (vcond_ENN_vio==1'b1),th_cpn_enn_l,notifier);
 $hold  (negedge CPN &&& (vcond2==1'b1),negedge D &&& (vcond_D_vio==1'b1),th_cpn_d_h,notifier);
 $hold  (negedge CPN &&& (vcond2==1'b1),posedge D &&& (vcond_D_vio==1'b1),th_cpn_d_l,notifier);
 $hold  (negedge CPN,posedge CDN &&& (vcond_CDN_vio==1'b1) ,th_cpn_cdn_l,notifier);
`endif
 $width (posedge CPN &&& (CDN==1'b1),tpw_cpn_h,0,notifier);
 $width (negedge CPN &&& (CDN==1'b1),tpw_cpn_l,0,notifier);
 $width (negedge CDN,tpw_cdn_l,0,notifier);
// Delays
 (negedge CPN   => (Q +: D)) = (cpn_hl_q_lh_1,cpn_hl_q_hl_1);
 (negedge CDN  => (Q -: 1'b1)) = (0,cdn_hl_q_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
