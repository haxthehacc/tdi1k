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
// Filename     	: jkbrb1.v
// Description          : Buffered JKZ Flip-Flop with Clear, Preset, 1X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//

module jkbrb1 (J,KZ,CP,Q,QN,SDN,CDN);

output  Q,QN;
input   J,KZ,CP,SDN,CDN;

`ifdef neg_tchk
wire d_J,d_KZ,d_CP,d_SDN,d_CDN;
`endif

U_MUX_2_1 (temp,not_J,not_KZ,Q);
not (not_temp,temp);

`ifdef functional
U_FD_N_RB_SB_QN #1 (QN,not_temp,not_CP,CDN,SDN);
U_FD_P_RB_SB #1 (Q,not_temp,CP,CDN,SDN);
`else
reg notifier;
`ifdef neg_tchk
U_FD_N_R_S_NO_QN #1 (QN,not_temp,not_CP,not_CDN,not_SDN,notifier);
U_FD_P_RB_SB_NO #1 (Q,not_temp,d_CP,d_CDN,d_SDN,notifier);
`else
U_FD_N_R_S_NO_QN #1 (QN,not_temp,not_CP,not_CDN,not_SDN,notifier);
U_FD_P_RB_SB_NO #1 (Q,not_temp,CP,CDN,SDN,notifier);
`endif
`endif

`ifdef functional
not (not_J,J);
not (not_KZ,KZ);
not (not_CP,CP);
`else
`ifdef neg_tchk
not (not_J,d_J);
not (not_KZ,d_KZ);
not (not_SDN,d_SDN);
not (not_CDN,d_CDN);
not (not_CP,d_CP);
`else
not (not_J,J);
not (not_KZ,KZ);
not (not_SDN,SDN);
not (not_CDN,CDN);
not (not_CP,CP);
`endif
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (SDN_buf,d_SDN);
buf (CDN_buf,d_CDN);
`else
buf (SDN_buf,SDN);
buf (CDN_buf,CDN);
`endif


wire vcond1 = ((SDN_buf==1'b1) && (CDN_buf==1'b1));
specify
// Parameter declarations
 specparam tsu_kz_h_cp=0.22,tsu_kz_l_cp=0.33,tsu_j_h_cp=0.32,tsu_j_l_cp=0.26,
 tsu_sdn_h_cp=0.00,tsu_cdn_h_cp=0.00,th_cp_kz_h=0.00,th_cp_kz_l=0.00,th_cp_j_h=0.00,
 th_cp_j_l=0.00,th_cp_sdn_l=0.18,th_cp_cdn_l=0.26,tpw_cp_h=0.28,tpw_cp_l=0.41,
 tpw_sdn_l=0.47,tpw_cdn_l=0.38,cdn_hl_qn_lh_1=0,cdn_hl_q_hl_1=0,sdn_lh_qn_lh_3=0,
 cdn_lh_q_lh_3=0,sdn_hl_qn_hl_5=0,sdn_hl_q_lh_1=0,cp_lh_qn_lh_1=0,cp_lh_q_hl_1=0,
 cp_lh_qn_hl_1=0,cp_lh_q_lh_1=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP &&& (vcond1==1'b1),posedge KZ &&& (vcond1==1'b1),tsu_kz_h_cp,th_cp_kz_l,notifier,,,d_CP,d_KZ);
 $setuphold (posedge CP &&& (vcond1==1'b1),negedge KZ &&& (vcond1==1'b1),tsu_kz_l_cp,th_cp_kz_h,notifier,,,d_CP,d_KZ);
 $setuphold (posedge CP &&& (vcond1==1'b1),posedge J &&& (vcond1==1'b1),tsu_j_h_cp,th_cp_j_l,notifier,,,d_CP,d_J);
 $setuphold (posedge CP &&& (vcond1==1'b1),negedge J &&& (vcond1==1'b1),tsu_j_l_cp,th_cp_j_h,notifier,,,d_CP,d_J);
 $recrem (posedge SDN &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_sdn_h_cp,th_cp_sdn_l,notifier,,,d_SDN,d_CP);
 $recrem (posedge CDN &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_cdn_h_cp,th_cp_cdn_l,notifier,,,d_CDN,d_CP);
`else
 $setup (posedge KZ &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_kz_h_cp,notifier);
 $setup (negedge KZ &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_kz_l_cp,notifier);
 $setup (posedge J &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_j_h_cp,notifier);
 $setup (negedge J &&& (vcond1==1'b1),posedge CP &&& (vcond1==1'b1),tsu_j_l_cp,notifier);
 $recovery (posedge SDN &&& (CDN==1'b1),posedge CP &&& (CDN==1'b1),tsu_sdn_h_cp,notifier);
 $recovery (posedge CDN &&& (SDN==1'b1),posedge CP &&& (SDN==1'b1),tsu_cdn_h_cp,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge KZ &&& (vcond1==1'b1),th_cp_kz_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge KZ &&& (vcond1==1'b1),th_cp_kz_l,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),negedge J &&& (vcond1==1'b1),th_cp_j_h,notifier);
 $hold  (posedge CP &&& (vcond1==1'b1),posedge J &&& (vcond1==1'b1),th_cp_j_l,notifier);
 $hold  (posedge CP &&& (CDN==1'b1),posedge SDN &&& (CDN==1'b1),th_cp_sdn_l,notifier);
 $hold  (posedge CP &&& (SDN==1'b1),posedge CDN &&& (SDN==1'b1),th_cp_cdn_l,notifier);
`endif
 $width (posedge CP &&& (vcond1==1'b1),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (vcond1==1'b1),tpw_cp_l,0,notifier);
 $width (negedge SDN &&& (CDN==1'b1),tpw_sdn_l,0,notifier);
 $width (negedge CDN &&& (SDN==1'b1),tpw_cdn_l,0,notifier);
// Delays
 (        CDN +=> Q ) = (cdn_lh_q_lh_3,cdn_hl_q_hl_1);
 (        SDN +=> QN) = (sdn_lh_qn_lh_3,sdn_hl_qn_hl_5);
 if ((SDN==1'b1) && (CDN==1'b1))
 (posedge CP   => (QN -: ((J && ~Q) || (KZ && Q)))) = (cp_lh_qn_lh_1,cp_lh_qn_hl_1);
 if ((SDN==1'b1) && (CDN==1'b1))
 (posedge CP   => (Q  +: ((J && ~Q) || (KZ && Q)))) = (cp_lh_q_lh_1,cp_lh_q_hl_1);
 (negedge CDN  => (QN +: 1'b1)) = (cdn_hl_qn_lh_1,0);
 (negedge SDN  => (Q  +: 1'b1)) = (sdn_hl_q_lh_1,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
