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
// Filename     	: deprq2.v
// Description  	:  Buffered Enabled D Flip-Flop with Preset and Q only, 2X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module deprq2 (CP,SDN,D,ENN,Q);

output  Q;
input   CP,SDN,D,ENN;

`ifdef neg_tchk
wire d_CP,d_SDN,d_D,d_ENN;
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (SDN_buf,d_SDN);
buf (D_buf,d_D);
buf (ENN_buf,d_ENN);
`else
buf (SDN_buf,SDN);
buf (D_buf,D);
buf (ENN_buf,ENN);
`endif
`endif

`ifdef functional
U_FD_EN_P_SB #1 (Q,CP,ENN,SDN,D);
`else
reg notifier;
`ifdef neg_tchk
U_FD_EN_P_SB_NO #1 (Q,d_CP,d_ENN,d_SDN,d_D,notifier);
`else
U_FD_EN_P_SB_NO #1 (Q,CP,ENN,SDN,D,notifier);
`endif
`endif

`ifdef functional
`else
wire BOOL_OUT = (((!ENN_buf && D_buf)) && ((!ENN_buf))) || !(!Q || ((!ENN_buf)));
wire vcond1 = ((SDN_buf==1'b1) && (ENN_buf==1'b0));
specify
// Parameter declarations
 specparam tsu_enn_h_cp=0.38,tsu_enn_l_cp=0.46,tsu_d_h_cp=0.32,tsu_d_l_cp=0.39,
 tsu_sdn_h_cp=0.00,th_cp_enn_h=0.00,th_cp_enn_l=0.00,th_cp_d_h=0.00,th_cp_d_l=0.00,
 th_cp_sdn_l=0.13,tpw_cp_h=0.27,tpw_cp_l=0.44,tpw_sdn_l=0.31,cp_lh_q_hl=0,
 cp_lh_q_lh=0,sdn_hl_q_lh_6=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (SDN==1'b1),posedge ENN &&& (SDN==1'b1),tsu_enn_h_cp,th_cp_enn_l,notifier,,,d_CP,d_ENN);
 $setuphold (posedge CP &&& (SDN==1'b1),negedge ENN &&& (SDN==1'b1),tsu_enn_l_cp,th_cp_enn_h,notifier,,,d_CP,d_ENN);
 $setuphold (posedge CP &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
 $recrem (posedge SDN &&& (ENN==1'b0),posedge CP &&& (ENN==1'b0),tsu_sdn_h_cp,th_cp_sdn_l,notifier,,,d_SDN,d_CP);
`else
 $setup (posedge ENN &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_enn_h_cp,notifier);
 $setup (negedge ENN &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_enn_l_cp,notifier);
 $setup (posedge D &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_d_l_cp,notifier);
 $recovery (posedge SDN &&& (ENN==1'b0),posedge CP &&& (ENN==1'b0),tsu_sdn_h_cp,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),negedge ENN &&& (SDN==1'b1),th_cp_enn_h,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),posedge ENN &&& (SDN==1'b1),th_cp_enn_l,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge D &&& (vcond1==1'b1),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge D &&& (vcond1==1'b1),th_cp_d_l,notifier);
 $hold  (posedge CP &&& (ENN==1'b0),posedge SDN &&& (ENN==1'b0),th_cp_sdn_l,notifier);
`endif
 $width (posedge CP &&& (vcond1==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (vcond1==1'b1),tpw_cp_l,0,notifier);
 $width (negedge SDN,tpw_sdn_l,0,notifier);
// Delays
 if ((SDN==1'b1) && (ENN==1'b0))
 (posedge CP   => (Q +: BOOL_OUT)) = (cp_lh_q_lh,cp_lh_q_hl);
 (negedge SDN  => (Q +: 1'b1)) = (sdn_hl_q_lh_6,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
