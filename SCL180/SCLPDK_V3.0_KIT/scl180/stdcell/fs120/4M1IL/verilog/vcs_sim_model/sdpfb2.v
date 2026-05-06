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
// Filename     	: sdpfb2.v
// Description  	:  Muxed Scan D Flip-Flop with Preset, 2X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//


module sdpfb2 (D,SD,SC,CPN,SDN,Q,QN);

output  Q,QN;
input   D,SD,SC,CPN,SDN;

`ifdef neg_tchk
wire d_D,d_SD,d_SC,d_CPN,d_SDN;
`endif

`ifdef functional
not (CPN_not,CPN);
U_FD_P_SB #1 (buf_Q,mux_out,CPN_not,SDN);
`else
reg notifier;
`ifdef neg_tchk
U_FD_N_SB_NO #1 (buf_Q,mux_out,d_CPN,d_SDN,notifier);
`else
U_FD_N_SB_NO #1 (buf_Q,mux_out,CPN,SDN,notifier);
`endif
`endif

`ifdef functional
U_MUX_2_1 (mux_out,D,SD,SC);
`else
`ifdef neg_tchk
U_MUX_2_1 (mux_out,d_D,d_SD,d_SC);
`else
U_MUX_2_1 (mux_out,D,SD,SC);
`endif
`endif

buf (Q,buf_Q);
not (QN,buf_Q);

`ifdef functional
`else
`ifdef neg_tchk
buf (SC_buf,d_SC);
buf (SDN_buf,d_SDN);
`else
buf (SC_buf,SC);
buf (SDN_buf,SDN);
`endif


wire vcond1 = ((SC_buf==1'b1) && (SDN_buf==1'b1));
wire vcond2 = ((SC_buf==1'b0) && (SDN_buf==1'b1));
specify
// Parameter declarations
 specparam tsu_sd_h_cpn=0.50,tsu_sd_l_cpn=0.57,tsu_sc_h_cpn=0.47,tsu_sc_l_cpn=0.50,
 tsu_d_h_cpn=0.31,tsu_d_l_cpn=0.40,tsu_sdn_h_cpn=0.00,th_cpn_sd_h=0.00,th_cpn_sd_l=0.00,
 th_cpn_sc_h=0.00,th_cpn_sc_l=0.00,th_cpn_d_h=0.00,th_cpn_d_l=0.00,th_cpn_sdn_l=0.20,
 tpw_cpn_h=0.31,tpw_cpn_l=0.41,tpw_sdn_l=0.37,cpn_hl_qn_lh_1=0,cpn_hl_q_hl_1=0,
 sdn_hl_qn_hl_1=0,cpn_hl_qn_hl_1=0,cpn_hl_q_lh_1=0,sdn_hl_q_lh_6=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge CPN &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),tsu_sd_h_cpn,th_cpn_sd_l,notifier,,,d_CPN,d_SD);
 $setuphold (negedge CPN &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),tsu_sd_l_cpn,th_cpn_sd_h,notifier,,,d_CPN,d_SD);
 $setuphold (negedge CPN &&& (SDN==1'b1),posedge SC &&& (SDN==1'b1),tsu_sc_h_cpn,th_cpn_sc_l,notifier,,,d_CPN,d_SC);
 $setuphold (negedge CPN &&& (SDN==1'b1),negedge SC &&& (SDN==1'b1),tsu_sc_l_cpn,th_cpn_sc_h,notifier,,,d_CPN,d_SC);
 $setuphold (negedge CPN &&& (vcond2==1'b1),posedge D &&& (vcond2==1'b1),tsu_d_h_cpn,th_cpn_d_l,notifier,,,d_CPN,d_D);
 $setuphold (negedge CPN &&& (vcond2==1'b1),negedge D &&& (vcond2==1'b1),tsu_d_l_cpn,th_cpn_d_h,notifier,,,d_CPN,d_D);
 $recrem (posedge SDN,negedge CPN,tsu_sdn_h_cpn,th_cpn_sdn_l,notifier,,,d_SDN,d_CPN);
`else
 $setup (posedge SD &&& (vcond1==1'b1),negedge CPN &&& (vcond1==1'b1),tsu_sd_h_cpn,notifier);
 $setup (negedge SD &&& (vcond1==1'b1),negedge CPN &&& (vcond1==1'b1),tsu_sd_l_cpn,notifier);
 $setup (posedge SC &&& (SDN==1'b1),negedge CPN &&& (SDN==1'b1),tsu_sc_h_cpn,notifier);
 $setup (negedge SC &&& (SDN==1'b1),negedge CPN &&& (SDN==1'b1),tsu_sc_l_cpn,notifier);
 $setup (posedge D &&& (vcond2==1'b1),negedge CPN &&& (vcond2==1'b1),tsu_d_h_cpn,notifier);
 $setup (negedge D &&& (vcond2==1'b1),negedge CPN &&& (vcond2==1'b1),tsu_d_l_cpn,notifier);
 $recovery (posedge SDN,negedge CPN,tsu_sdn_h_cpn,notifier);
 $hold  (negedge CPN &&& (vcond1==1'b1),negedge SD &&& (vcond1==1'b1),th_cpn_sd_h,notifier);
 $hold  (negedge CPN &&& (vcond1==1'b1),posedge SD &&& (vcond1==1'b1),th_cpn_sd_l,notifier);
 $hold  (negedge CPN &&& (SDN==1'b1),negedge SC &&& (SDN==1'b1),th_cpn_sc_h,notifier);
 $hold  (negedge CPN &&& (SDN==1'b1),posedge SC &&& (SDN==1'b1),th_cpn_sc_l,notifier);
 $hold  (negedge CPN &&& (vcond2==1'b1),negedge D &&& (vcond2==1'b1),th_cpn_d_h,notifier);
 $hold  (negedge CPN &&& (vcond2==1'b1),posedge D &&& (vcond2==1'b1),th_cpn_d_l,notifier);
 $hold  (negedge CPN,posedge SDN,th_cpn_sdn_l,notifier);
`endif
 $width (posedge CPN &&& (SDN==1'b1),tpw_cpn_h,0,notifier);
 $width (negedge CPN &&& (SDN==1'b1),tpw_cpn_l,0,notifier);
 $width (negedge SDN,tpw_sdn_l,0,notifier);
// Delays
 if (SDN==1'b1)
 (negedge CPN   => (QN -: ((D && ~SC) || (SD && SC)))) = (cpn_hl_qn_lh_1,cpn_hl_qn_hl_1);
 if (SDN==1'b1)
 (negedge CPN   => (Q  +: ((D && ~SC) || (SD && SC)))) = (cpn_hl_q_lh_1,cpn_hl_q_hl_1);
 (negedge SDN  => (QN -: 1'b1)) = (0,sdn_hl_qn_hl_1);
 (negedge SDN  => (Q  +: 1'b1)) = (sdn_hl_q_lh_6,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
