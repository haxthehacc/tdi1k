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
// Filename     	: sdbfb1.v
// Description  	:  Muxed Scan D Flip-Flop with Clear, Preset, 1X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//


module sdbfb1 (D,SD,SC,CPN,SDN,CDN,Q,QN);

output  Q,QN;
input   D,SD,SC,CPN,SDN,CDN;

`ifdef neg_tchk
wire d_D,d_SD,d_SC,d_CPN,d_SDN,d_CDN;
`endif

`ifdef functional
U_FD_N_RB_SB_QN #1 (QN,mux_out,CPN,CDN,SDN);
U_FD_N_RB_SB #1 (Q,mux_out,CPN,CDN,SDN);
`else
reg notifier;
`ifdef neg_tchk
U_FD_N_R_S_NO_QN #1 (QN,mux_out,d_CPN,not_CDN,not_SDN,notifier);
U_FD_N_RB_SB_NO #1 (Q,mux_out,d_CPN,d_CDN,d_SDN,notifier);
`else
U_FD_N_R_S_NO_QN #1 (QN,mux_out,CPN,not_CDN,not_SDN,notifier);
U_FD_N_RB_SB_NO #1 (Q,mux_out,CPN,CDN,SDN,notifier);
`endif
`endif

`ifdef functional
U_MUX_2_1 (mux_out,D,SD,SC);
`else
`ifdef neg_tchk
U_MUX_2_1 (mux_out,d_D,d_SD,d_SC);
not (not_SDN,d_SDN);
not (not_CDN,d_CDN);
`else
U_MUX_2_1 (mux_out,D,SD,SC);
not (not_SDN,SDN);
not (not_CDN,CDN);
`endif
`endif


`ifdef functional
`else
`ifdef neg_tchk
buf (SC_buf,d_SC);
buf (SDN_buf,d_SDN);
buf (CDN_buf,d_CDN);
`else
buf (SC_buf,SC);
buf (SDN_buf,SDN);
buf (CDN_buf,CDN);
`endif

wire vcond1 = ((SC_buf==1'b1) && (SDN_buf==1'b1) && (CDN_buf==1'b1));
wire vcond2 = ((SDN_buf==1'b1) && (CDN_buf==1'b1));
wire vcond3 = ((SC_buf==1'b0) && (SDN_buf==1'b1) && (CDN_buf==1'b1));
specify
// Parameter declarations
 specparam tsu_sd_h_cpn=0.52,tsu_sd_l_cpn=0.60,tsu_sc_h_cpn=0.51,tsu_sc_l_cpn=0.42,
 tsu_d_h_cpn=0.33,tsu_d_l_cpn=0.41,tsu_sdn_h_cpn=0.00,tsu_cdn_h_cpn=0.00,th_cpn_sd_h=0.00,
 th_cpn_sd_l=0.00,th_cpn_sc_h=0.00,th_cpn_sc_l=0.00,th_cpn_d_h=0.00,th_cpn_d_l=0.00,
 th_cpn_sdn_l=0.16,th_cpn_cdn_l=0.31,tpw_cpn_h=0.37,tpw_cpn_l=0.43,tpw_sdn_l=0.31,
 tpw_cdn_l=0.31,cdn_lh_q_lh_1=0,sdn_lh_qn_lh_8=0,cpn_hl_qn_lh_1=0,cpn_hl_q_hl_1=0,
 cdn_hl_q_hl_8=0,cpn_hl_qn_hl_1=0,cpn_hl_q_lh_1=0,sdn_hl_qn_hl_15=0,sdn_hl_q_lh_7=0,cdn_hl_qn_lh_6=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge CPN &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),tsu_sd_h_cpn,th_cpn_sd_l,notifier,,,d_CPN,d_SD);
 $setuphold (negedge CPN &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),tsu_sd_l_cpn,th_cpn_sd_h,notifier,,,d_CPN,d_SD);
 $setuphold (negedge CPN &&& (vcond2==1'b1),posedge SC &&& (vcond2==1'b1),tsu_sc_h_cpn,th_cpn_sc_l,notifier,,,d_CPN,d_SC);
 $setuphold (negedge CPN &&& (vcond2==1'b1),negedge SC &&& (vcond2==1'b1),tsu_sc_l_cpn,th_cpn_sc_h,notifier,,,d_CPN,d_SC);
 $setuphold (negedge CPN &&& (vcond3==1'b1),posedge D &&& (vcond3==1'b1),tsu_d_h_cpn,th_cpn_d_l,notifier,,,d_CPN,d_D);
 $setuphold (negedge CPN &&& (vcond3==1'b1),negedge D &&& (vcond3==1'b1),tsu_d_l_cpn,th_cpn_d_h,notifier,,,d_CPN,d_D);
 $recrem (posedge SDN &&& (CDN==1'b1),negedge CPN &&& (CDN==1'b1),tsu_sdn_h_cpn,th_cpn_sdn_l,notifier,,,d_SDN,d_CPN);
 $recrem (posedge CDN &&& (SDN==1'b1),negedge CPN &&& (SDN==1'b1),tsu_cdn_h_cpn,th_cpn_cdn_l,notifier,,,d_CDN,d_CPN);
`else
 $setup (posedge SD &&& (vcond1==1'b1),negedge CPN &&& (vcond1==1'b1),tsu_sd_h_cpn,notifier);
 $setup (negedge SD &&& (vcond1==1'b1),negedge CPN &&& (vcond1==1'b1),tsu_sd_l_cpn,notifier);
 $setup (posedge SC &&& (vcond2==1'b1),negedge CPN &&& (vcond2==1'b1),tsu_sc_h_cpn,notifier);
 $setup (negedge SC &&& (vcond2==1'b1),negedge CPN &&& (vcond2==1'b1),tsu_sc_l_cpn,notifier);
 $setup (posedge D &&& (vcond3==1'b1),negedge CPN &&& (vcond3==1'b1),tsu_d_h_cpn,notifier);
 $setup (negedge D &&& (vcond3==1'b1),negedge CPN &&& (vcond3==1'b1),tsu_d_l_cpn,notifier);
 $recovery (posedge SDN &&& (CDN==1'b1),negedge CPN &&& (CDN==1'b1),tsu_sdn_h_cpn,notifier);
 $recovery (posedge CDN &&& (SDN==1'b1),negedge CPN &&& (SDN==1'b1),tsu_cdn_h_cpn,notifier);
 $hold  (negedge CPN &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),th_cpn_sd_h,notifier);
 $hold  (negedge CPN &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),th_cpn_sd_l,notifier);
 $hold  (negedge CPN &&& (vcond2==1'b1),negedge SC &&& (vcond2==1'b1),th_cpn_sc_h,notifier);
 $hold  (negedge CPN &&& (vcond2==1'b1),posedge SC &&& (vcond2==1'b1),th_cpn_sc_l,notifier);
 $hold  (negedge CPN &&& (vcond3==1'b1),negedge D &&& (vcond3==1'b1),th_cpn_d_h,notifier);
 $hold  (negedge CPN &&& (vcond3==1'b1),posedge D &&& (vcond3==1'b1),th_cpn_d_l,notifier);
 $hold  (negedge CPN &&& (CDN==1'b1),posedge SDN &&& (CDN==1'b1),th_cpn_sdn_l,notifier);
 $hold  (negedge CPN &&& (SDN==1'b1),posedge CDN &&& (SDN==1'b1),th_cpn_cdn_l,notifier);
`endif
 $width (posedge CPN &&& (vcond2==1'b1),tpw_cpn_h,0,notifier);
 $width (negedge CPN &&& (vcond2==1'b1),tpw_cpn_l,0,notifier);
 $width (negedge SDN &&& (CDN==1'b1),tpw_sdn_l,0,notifier);
 $width (negedge CDN &&& (SDN==1'b1),tpw_cdn_l,0,notifier);
// Delays
 (        CDN +=> Q ) = (cdn_lh_q_lh_1,cdn_hl_q_hl_8);
 (        SDN +=> QN) = (sdn_lh_qn_lh_8,sdn_hl_qn_hl_15);
 if ((SDN==1'b1) && (CDN==1'b1))
 (negedge CPN   => (QN -: ((D && ~SC) || (SD && SC)))) = (cpn_hl_qn_lh_1,cpn_hl_qn_hl_1);
 if ((SDN==1'b1) && (CDN==1'b1))
 (negedge CPN   => (Q  +: ((D && ~SC) || (SD && SC)))) = (cpn_hl_q_lh_1,cpn_hl_q_hl_1);
 (negedge SDN  => (Q  +: 1'b1)) = (sdn_hl_q_lh_7,0);
 (negedge CDN  => (QN +: 1'b1)) = (cdn_hl_qn_lh_6,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
