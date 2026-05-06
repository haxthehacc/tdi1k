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
// Filename     	: slbhb4.v
// Description  	: Muxed Scan Latch with Clear, Preset, 4X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.8
// Added $width for SC  : 18Dec05 bengil & assafma 
//


module slbhb4 (E,SC,D,SD,CDN,SDN,Q,QN,SO);

output  Q,QN,SO;
input   E,SC,D,SD,CDN,SDN;

`ifdef neg_tchk
wire d_E,d_D,d_SC,d_SD,d_CDN,d_SDN;
`endif

`ifdef functional
U_MUX_2_1 (mux_out,D,SD,SC);
U_LD_P_SB_RB_QN #1 (QN,mux_out,E,CDN,SDN);
U_LD_P_SB_RB #1 (Q,mux_out,E,CDN,SDN);
U_LD_N (SO,Q,E);
`else
reg notifier;
`ifdef neg_tchk
U_MUX_2_1 (mux_out,d_D,d_SD,d_SC);
U_LD_P_SB_RB_QN_NO #1 (QN,mux_out,d_E,d_CDN,d_SDN,notifier);
U_LD_P_SB_RB_NO #1 (Q,mux_out,d_E,d_CDN,d_SDN,notifier);
U_LD_N_NO (SO,Q,d_E,notifier);
`else
U_MUX_2_1 (mux_out,D,SD,SC);
U_LD_P_SB_RB_QN_NO #1 (QN,mux_out,E,CDN,SDN,notifier);
U_LD_P_SB_RB_NO #1 (Q,mux_out,E,CDN,SDN,notifier);
U_LD_N_NO (SO,Q,E,notifier);
`endif
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (SC_buf,d_SC);
buf (CDN_buf,d_CDN);
buf (SDN_buf,d_SDN);
`else
buf (SC_buf,SC);
buf (CDN_buf,CDN);
buf (SDN_buf,SDN);
`endif


wire vcond1 = ((SC_buf==1'b1) && (SDN_buf==1'b1) && (CDN_buf==1'b1));
wire vcond2 = ((SDN_buf==1'b1) && (CDN_buf==1'b1));
wire vcond3 = ((SC_buf==1'b0) && (SDN_buf==1'b1) && (CDN_buf==1'b1));
specify
// Parameter declarations
 specparam tsu_d_h_e=0.14,tsu_d_l_e=0.21,tsu_sdn_h_e=0.00,tsu_cdn_h_e=0.13,
 th_e_d_h=0.00,th_e_d_l=0.00,th_e_sdn_l=0.08,th_e_cdn_l=0.00,tpw_e_h=0.24,tpw_e_l=0.00,
 tpw_sdn_l=0.22,tpw_cdn_l=0.27,tpw_sc_h=0,cdn_hl_q_hl_1=0,sdn_hl_q_lh_1=0,sdn_lh_q_hl_1=0,
 sdn_lh_qn_lh=0,e_lh_q_hl=0,e_lh_qn_lh=0,e_lh_q_lh=0,e_lh_qn_hl=0,
tsu_sd_h_e=0,th_e_sd_l=0,tsu_sd_l_e=0,th_e_sd_h=0,tsu_sc_h_e=0,th_e_sc_l=0,
tsu_sc_l_e=0,th_e_sc_h=0,cdn_hl_qn_lh_6=0,cdn_lh_q_lh=0,cdn_lh_qn_hl_5=0,
 d_hl_q_hl=0,d_hl_qn_lh=0,sdn_hl_qn_hl_2=0,d_lh_q_lh=0,d_lh_qn_hl=0,
 sc_lh_q_lh=0,sc_hl_q_hl=0,sc_lh_qn_lh=0,sc_hl_qn_hl=0,sd_lh_q_lh=0,
 sd_hl_q_hl=0,sd_hl_qn_lh=0,sd_lh_qn_hl=0,e_hl_so_hl=0,e_hl_so_lh=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge E &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),tsu_sd_h_e,th_e_sd_l,notifier,,,d_E,d_SD);
 $setuphold (negedge E &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),tsu_sd_l_e,th_e_sd_h,notifier,,,d_E,d_SD);
 $setuphold (negedge E &&& (vcond2==1'b1),posedge SC &&& (vcond2==1'b1),tsu_sc_h_e,th_e_sc_l,notifier,,,d_E,d_SC);
 $setuphold (negedge E &&& (vcond2==1'b1),negedge SC &&& (vcond2==1'b1),tsu_sc_l_e,th_e_sc_h,notifier,,,d_E,d_SC);
 $setuphold (negedge E &&& (vcond3==1'b1),posedge D &&& (vcond3==1'b1),tsu_d_h_e,th_e_d_l,notifier,,,d_E,d_D);
 $setuphold (negedge E &&& (vcond3==1'b1),negedge D &&& (vcond3==1'b1),tsu_d_l_e,th_e_d_h,notifier,,,d_E,d_D);
 $recrem (posedge SDN &&& (CDN==1'b1),negedge E &&& (CDN==1'b1),tsu_sdn_h_e,th_e_sdn_l,notifier,,,d_SDN,d_E);
 $recrem (posedge CDN &&& (SDN==1'b1),negedge E &&& (SDN==1'b1),tsu_cdn_h_e,th_e_cdn_l,notifier,,,d_CDN,d_E);
`else
 $setup (posedge SD &&& (vcond1==1'b1),negedge E &&& (vcond1==1'b1),tsu_sd_h_e,notifier);
 $setup (negedge SD &&& (vcond1==1'b1),negedge E &&& (vcond1==1'b1),tsu_sd_l_e,notifier);
 $setup (posedge SC &&& (vcond2==1'b1),negedge E &&& (vcond2==1'b1),tsu_sc_h_e,notifier);
 $setup (negedge SC &&& (vcond2==1'b1),negedge E &&& (vcond2==1'b1),tsu_sc_l_e,notifier);
 $setup (posedge D &&& (vcond3==1'b1),negedge E &&& (vcond3==1'b1),tsu_d_h_e,notifier);
 $setup (negedge D &&& (vcond3==1'b1),negedge E &&& (vcond3==1'b1),tsu_d_l_e,notifier);
 $recovery (posedge SDN &&& (CDN==1'b1),negedge E &&& (CDN==1'b1),tsu_sdn_h_e,notifier);
 $recovery (posedge CDN &&& (SDN==1'b1),negedge E &&& (SDN==1'b1),tsu_cdn_h_e,notifier);
 $hold  (negedge E &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),th_e_sd_l,notifier);
 $hold  (negedge E &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),th_e_sd_h,notifier);
 $hold  (negedge E &&& (vcond2==1'b1),posedge SC &&& (vcond2==1'b1),th_e_sc_l,notifier);
 $hold  (negedge E &&& (vcond2==1'b1),negedge SC &&& (vcond2==1'b1),th_e_sc_h,notifier);
 $hold  (negedge E &&& (vcond3==1'b1),negedge D &&& (vcond3==1'b1),th_e_d_h,notifier);
 $hold  (negedge E &&& (vcond3==1'b1),posedge D &&& (vcond3==1'b1),th_e_d_l,notifier);
 $hold  (negedge E &&& (CDN==1'b1),posedge SDN &&& (CDN==1'b1),th_e_sdn_l,notifier);
 $hold  (negedge E &&& (SDN==1'b1),posedge CDN &&& (SDN==1'b1),th_e_cdn_l,notifier);
`endif
 $width (posedge E &&& (vcond1==1'b1),tpw_e_h,0,notifier);
 $width (negedge E &&& (vcond1==1'b1),tpw_e_l,0,notifier);
 $width (negedge SDN &&& (CDN==1'b1),tpw_sdn_l,0,notifier);
 $width (negedge CDN &&& (SDN==1'b1),tpw_cdn_l,0,notifier);
 $width (posedge SC,tpw_sc_h,0,notifier);
// Delays
 (        SDN -=> Q ) = (sdn_hl_q_lh_1,sdn_lh_q_hl_1);
 (        CDN -=> QN) = (cdn_hl_qn_lh_6,cdn_lh_qn_hl_5);
 if (SDN==1'b1)
 (        CDN +=> Q ) = (cdn_lh_q_lh,cdn_hl_q_hl_1);
 if (CDN==1'b1)
 (        SDN +=> QN) = (sdn_lh_qn_lh,sdn_hl_qn_hl_2);
 if ((E==1'b1) && (CDN==1'b1) && (SDN==1'b1))
 (        SC  => Q ) = (sc_lh_q_lh,sc_hl_q_hl);
 if ((E==1'b1) && (CDN==1'b1) && (SDN==1'b1))
 (        SC  => QN ) = (sc_lh_qn_lh,sc_hl_qn_hl);
 if ((E==1'b1) && (CDN==1'b1) && (SDN==1'b1) && (SC==1'b0))
 (        D  +=> Q ) = (d_lh_q_lh,d_hl_q_hl);
 if ((E==1'b1) && (CDN==1'b1) && (SDN==1'b1) && (SC==1'b0))
 (        D  -=> QN ) = (d_hl_qn_lh,d_lh_qn_hl);
 if ((E==1'b1) && (CDN==1'b1) && (SDN==1'b1) && (SC==1'b1))
 (        SD  +=> Q ) = (sd_lh_q_lh,sd_hl_q_hl);
 if ((E==1'b1) && (CDN==1'b1) && (SDN==1'b1) && (SC==1'b1))
 (        SD  -=> QN ) = (sd_hl_qn_lh,sd_lh_qn_hl);
 if ((CDN==1'b1) && (SDN==1'b1))
 (posedge E    => (Q  +: ((D && ~SC) || (SD && SC)))) = (e_lh_q_lh,e_lh_q_hl);
 if ((CDN==1'b1) && (SDN==1'b1))
 (posedge E    => (QN -: ((D && ~SC) || (SD && SC)))) = (e_lh_qn_lh,e_lh_qn_hl);
 if ((CDN==1'b1) && (SDN==1'b1))
 (negedge E    => (SO +: ((D && ~SC) || (SD && SC)))) = (e_hl_so_lh,e_hl_so_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
