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
// Filename     	: seprq2.v
// Description  	:  Muxed Scan Enable D Flip-Flop with Preset and Q only, 2X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
// Added posedge to CP 
// at delay path        : 20Dec05 assafma & bengil 
// Added source to above : 29Jun06 tamasto
// Add `+` for veritime usage  : 11July06 tamasto


module seprq2 (CP,SDN,ENN,D,SC,SD,Q);

output  Q;
input   CP,SDN,ENN,D,SC,SD;

`ifdef neg_tchk
wire d_CP,d_SDN,d_ENN,d_D,d_SC,d_SD;
`endif

`ifdef functional
U_FD_SC_EN_P_SB #1 (Q,CP,ENN,SC,SDN,D,SD);
`else
reg notifier;
`ifdef neg_tchk
U_FD_SC_EN_P_SB_NO #1 (Q,d_CP,d_ENN,d_SC,d_SDN,d_D,d_SD,notifier);
`else
U_FD_SC_EN_P_SB_NO #1 (Q,CP,ENN,SC,SDN,D,SD,notifier);
`endif
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (SDN_buf,d_SDN);
buf (SC_buf,d_SC);
buf (ENN_buf,d_ENN);
`else
buf (SDN_buf,SDN);
buf (SC_buf,SC);
buf (ENN_buf,ENN);
`endif


wire vcond1 = ((SDN_buf==1'b1) && (SC_buf==1'b1));
wire vcond_SDN_vio = ((ENN_buf==1'b0) || (SC_buf==1'b1));
wire vcond_ENN_vio = ((SDN_buf==1'b1) && (SC_buf==1'b0));
wire vcond_D_vio = ((SDN_buf==1'b1) && (SC_buf==1'b0) && (ENN_buf==1'b0));
wire vcond2 = ((SDN_buf==1'b1) && (SC_buf==1'b0));
specify
// Parameter declarations
 specparam tsu_sd_h_cp=0.52,tsu_sd_l_cp=0.69,tsu_sc_h_cp=0.72,tsu_sc_l_cp=0.76,
 tsu_enn_h_cp=0.52,tsu_enn_l_cp=0.80,tsu_d_h_cp=0.37,tsu_d_l_cp=0.57,tsu_sdn_h_cp=0.00,
 th_cp_sd_h=0.00,th_cp_sd_l=0.00,th_cp_sc_h=0.00,th_cp_sc_l=0.00,th_cp_enn_h=0.00,
 th_cp_enn_l=0.00,th_cp_d_h=0.00,th_cp_d_l=0.00,th_cp_sdn_l=0.07,tpw_cp_h=0.31,
 tpw_cp_l=0.43,tpw_sdn_l=0.46,cp_lh_q_hl_1=0,sdn_hl_q_lh_1=0,cp_lh_q_lh_1=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),tsu_sd_h_cp,th_cp_sd_l,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),tsu_sd_l_cp,th_cp_sd_h,notifier,,,d_CP,d_SD);
 $setuphold (posedge CP &&& (SDN==1'b1),posedge SC &&& (SDN==1'b1),tsu_sc_h_cp,th_cp_sc_l,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP &&& (SDN==1'b1),negedge SC &&& (SDN==1'b1),tsu_sc_l_cp,th_cp_sc_h,notifier,,,d_CP,d_SC);
 $setuphold (posedge CP &&& (SDN==1'b1),posedge ENN &&& (vcond_ENN_vio==1'b1),tsu_enn_h_cp,th_cp_enn_l,notifier,,,d_CP,d_ENN);
 $setuphold (posedge CP &&& (SDN==1'b1),negedge ENN &&& (vcond_ENN_vio==1'b1),tsu_enn_l_cp,th_cp_enn_h,notifier,,,d_CP,d_ENN);
 $setuphold (posedge CP &&& (vcond2==1'b1),posedge D &&& (vcond_D_vio==1'b1),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP &&& (vcond2==1'b1),negedge D &&& (vcond_D_vio==1'b1),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
 $recrem (posedge SDN &&& (vcond_SDN_vio==1'b1) ,posedge CP,tsu_sdn_h_cp,th_cp_sdn_l,notifier,,,d_SDN,d_CP);
`else
 $setup (posedge SD &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_sd_h_cp,notifier);
 $setup (negedge SD &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_sd_l_cp,notifier);
 $setup (posedge SC &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_sc_h_cp,notifier);
 $setup (negedge SC &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_sc_l_cp,notifier);
 $setup (posedge ENN &&& (vcond_ENN_vio==1'b1),posedge CP &&& (SDN==1'b1),tsu_enn_h_cp,notifier);
 $setup (negedge ENN &&& (vcond_ENN_vio==1'b1),posedge CP &&& (SDN==1'b1),tsu_enn_l_cp,notifier);
 $setup (posedge D &&& (vcond_D_vio==1'b1),posedge CP &&& (vcond2==1'b1),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (vcond_D_vio==1'b1),posedge CP &&& (vcond2==1'b1),tsu_d_l_cp,notifier);
 $recovery (posedge SDN &&& (vcond_SDN_vio==1'b1) ,posedge CP,tsu_sdn_h_cp,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),th_cp_sd_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),th_cp_sd_l,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),negedge SC &&& (SDN==1'b1),th_cp_sc_h,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),posedge SC &&& (SDN==1'b1),th_cp_sc_l,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),negedge ENN &&& (vcond_ENN_vio==1'b1),th_cp_enn_h,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),posedge ENN &&& (vcond_ENN_vio==1'b1),th_cp_enn_l,notifier);
 $hold  (posedge CP &&& (vcond2==1'b1),negedge D &&& (vcond_D_vio==1'b1),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (vcond2==1'b1),posedge D &&& (vcond_D_vio==1'b1),th_cp_d_l,notifier);
 $hold  (posedge CP,posedge SDN &&& (vcond_SDN_vio==1'b1) ,th_cp_sdn_l,notifier);
`endif
 $width (posedge CP &&& (SDN==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (SDN==1'b1),tpw_cp_l,0,notifier);
 $width (negedge SDN,tpw_sdn_l,0,notifier);
// Delays
 (posedge CP   => (Q+:D)) = (cp_lh_q_lh_1,cp_lh_q_hl_1);
 (negedge SDN  => (Q +: 1'b1)) = (sdn_hl_q_lh_1,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
