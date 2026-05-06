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
// Filename     	: slchq2.v
// Description          : Muxed Scan High Enable Latch with Clear and Q only, 2X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.9
// Added $width for SC  : 18Dec05 bengil & assafma 
//


module slchq2 (E,D,SD,SC,CDN,Q,SO);

output  Q,SO;
input   E,D,SD,SC,CDN;

`ifdef neg_tchk
wire d_E,d_D,d_SD,d_SC,d_CDN;
`endif

`ifdef functional
U_MUX_2_1 (mux_out,D,SD,SC);
U_LD_P_RB #1 (Q,mux_out,E,CDN);
U_LD_N (SO,Q,E);
`else
reg notifier;
`ifdef neg_tchk
U_MUX_2_1 (mux_out,d_D,d_SD,d_SC);
U_LD_P_RB_NO #1 (Q,mux_out,d_E,d_CDN,notifier);
U_LD_N_NO (SO,Q,d_E,notifier);
`else
U_MUX_2_1 (mux_out,D,SD,SC);
U_LD_P_RB_NO #1 (Q,mux_out,E,CDN,notifier);
U_LD_N_NO (SO,Q,E,notifier);
`endif
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (SC_buf,d_SC);
buf (CDN_buf,d_CDN);
`else
buf (SC_buf,SC);
buf (CDN_buf,CDN);
`endif

wire vcond1 = ((SC_buf==1'b1) && (CDN_buf==1'b1));
wire vcond2 = ((SC_buf==1'b0) && (CDN_buf==1'b1));
specify
// Parameter declarations
 specparam tsu_d_h_e=0.03,tsu_d_l_e=0.16,tsu_cdn_h_e=0.03,th_e_d_h=0.00,
 th_e_d_l=0.00,th_e_cdn_l=0.00,tpw_e_h=0.15,tpw_cdn_l=0.25,e_lh_q_lh=0,
 tpw_e_l=0.00,tpw_sc_h=0,e_lh_q_hl=0,d_lh_q_lh=0,d_hl_q_hl=0,cdn_lh_q_lh=0,cdn_hl_q_hl_3=0,
 sc_lh_q_lh=0,sc_hl_q_hl=0,sd_lh_q_lh=0,sd_hl_q_hl=0,
 tsu_sd_h_e=0,th_e_sd_l=0,tsu_sd_l_e=0,th_e_sd_h=0,tsu_sc_h_e=0,th_e_sc_l=0,
 tsu_sc_l_e=0,th_e_sc_h=0,e_hl_so_hl=0,e_hl_so_lh=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge E &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),tsu_sd_h_e,th_e_sd_l,notifier,,,d_E,d_SD);
 $setuphold (negedge E &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),tsu_sd_l_e,th_e_sd_h,notifier,,,d_E,d_SD);
 $setuphold (negedge E &&& (vcond2==1'b1),posedge D &&& (vcond2==1'b1),tsu_d_h_e,th_e_d_l,notifier,,,d_E,d_D);
 $setuphold (negedge E &&& (vcond2==1'b1),negedge D &&& (vcond2==1'b1),tsu_d_l_e,th_e_d_h,notifier,,,d_E,d_D);
 $setuphold (negedge E &&& (CDN==1'b1),posedge SC &&& (CDN==1'b1),tsu_sc_h_e,th_e_sc_l,notifier,,,d_E,d_SC);
 $setuphold (negedge E &&& (CDN==1'b1),negedge SC &&& (CDN==1'b1),tsu_sc_l_e,th_e_sc_h,notifier,,,d_E,d_SC);
 $recrem (posedge CDN,negedge E,tsu_cdn_h_e,th_e_cdn_l,notifier,,,d_CDN,d_E);
`else
 $setup (posedge SD &&& (vcond1==1'b1),negedge E &&& (vcond1==1'b1),tsu_sd_h_e,notifier);
 $setup (negedge SD &&& (vcond1==1'b1),negedge E &&& (vcond1==1'b1),tsu_sd_l_e,notifier);
 $setup (posedge D &&& (vcond2==1'b1),negedge E &&& (vcond2==1'b1),tsu_d_h_e,notifier);
 $setup (negedge D &&& (vcond2==1'b1),negedge E &&& (vcond2==1'b1),tsu_d_l_e,notifier);
 $setup (posedge SC &&& (CDN==1'b1),negedge E &&& (CDN==1'b1),tsu_sc_h_e,notifier);
 $setup (negedge SC &&& (CDN==1'b1),negedge E &&& (CDN==1'b1),tsu_sc_l_e,notifier);
 $recovery (posedge CDN,negedge E,tsu_cdn_h_e,notifier);
 $hold  (negedge E &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),th_e_sd_l,notifier);
 $hold  (negedge E &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),th_e_sd_h,notifier);
 $hold  (negedge E &&& (vcond2==1'b1),posedge D &&& (vcond2==1'b1),th_e_d_l,notifier);
 $hold  (negedge E &&& (vcond2==1'b1),negedge D &&& (vcond2==1'b1),th_e_d_h,notifier);
 $hold  (negedge E &&& (CDN==1'b1),posedge SC &&& (CDN==1'b1),th_e_sc_l,notifier);
 $hold  (negedge E &&& (CDN==1'b1),negedge SC &&& (CDN==1'b1),th_e_sc_h,notifier);
 $hold  (negedge E,posedge CDN,th_e_cdn_l,notifier);
`endif
 $width (posedge E &&& (CDN==1'b1),tpw_e_h,0,notifier);
 $width (negedge E &&& (CDN==1'b1),tpw_e_l,0,notifier);
 $width (negedge CDN,tpw_cdn_l,0,notifier);
 $width (posedge SC,tpw_sc_h,0,notifier);
// Delays
 if ((E==1'b1) && (CDN==1'b1))
 (        SC   => Q) = (sc_lh_q_lh,sc_hl_q_hl);
 (        CDN +=> Q) = (cdn_lh_q_lh,cdn_hl_q_hl_3);
 if ((E==1'b1) && (CDN==1'b1) && (SC==1'b0))
 (        D   +=> Q) = (d_lh_q_lh,d_hl_q_hl);
 if ((E==1'b1) && (CDN==1'b1) && (SC==1'b1))
 (        SD   +=> Q) = (sd_lh_q_lh,sd_hl_q_hl);
 if (CDN==1'b1)
 (posedge E    => (Q +: ((D && ~SC) || (SD && SC)))) = (e_lh_q_lh,e_lh_q_hl);
 if (CDN==1'b1)
 (negedge E    => (SO +: ((D && ~SC) || (SD && SC)))) = (e_hl_so_lh,e_hl_so_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
