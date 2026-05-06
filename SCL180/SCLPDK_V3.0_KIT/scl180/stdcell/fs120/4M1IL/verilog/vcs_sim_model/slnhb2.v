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
// Filename     	: slnhb2.v
// Description          : Muxed Scan Latch, 2X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.8
// Added $width for SC  : 18Dec05 bengil & assafma 
//


module slnhb2 (D,SD,SC,E,Q,QN,SO);

output  Q,QN,SO;
input   D,SD,SC,E;

`ifdef neg_tchk
wire d_D,d_E,d_SD,d_SC;
`endif

`ifdef functional
U_MUX_2_1 (mux_out,D,SD,SC);
U_LD_P #1 (buf_Q,mux_out,E);
U_LD_N #1 (SO,buf_Q,E);
`else
reg notifier;
`ifdef neg_tchk
U_MUX_2_1 (mux_out,d_D,d_SD,d_SC);
U_LD_P_NO #1 (buf_Q,mux_out,d_E,notifier);
U_LD_N_NO #1 (SO,buf_Q,d_E,notifier);
`else
U_MUX_2_1 (mux_out,D,SD,SC);
U_LD_P_NO #1 (buf_Q,mux_out,E,notifier);
U_LD_N_NO #1 (SO,buf_Q,E,notifier);
`endif
`endif

buf (Q,buf_Q);
not (QN,buf_Q);

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_e=0.00,tsu_d_l_e=0.13,th_e_d_h=0.00,th_e_d_l=0.15,
 tsu_sd_h_e=0.00,tsu_sd_l_e=0.13,tsu_sc_h_e=0.00,tsu_sc_l_e=0.13,
 th_e_sd_h=0.00,th_e_sd_l=0.15,th_e_sc_h=0.00,th_e_sc_l=0.15,
 tpw_e_l=0.00,tpw_e_h=0.21,tpw_sc_h=0,d_hl_q_hl=0,d_hl_qn_lh=0,d_lh_q_lh=0,d_lh_qn_hl=0,
 e_lh_q_hl=0,e_lh_qn_lh=0,e_lh_q_lh=0,e_lh_qn_hl=0,
 sc_lh_q_lh=0,sc_hl_q_hl=0,sc_lh_qn_lh=0,sc_hl_qn_hl=0,sd_lh_q_lh=0,
 sd_hl_q_hl=0,sd_hl_qn_lh=0,sd_lh_qn_hl=0,e_hl_so_hl=0,e_hl_so_lh=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge E &&& (SC==1'b1),posedge SD &&& (SC==1'b1),tsu_sd_h_e,th_e_sd_l,notifier,,,d_E,d_SD);
 $setuphold (negedge E &&& (SC==1'b1),negedge SD &&& (SC==1'b1),tsu_sd_l_e,th_e_sd_h,notifier,,,d_E,d_SD);
 $setuphold (negedge E,posedge SC,tsu_sc_h_e,th_e_sc_l,notifier,,,d_E,d_SC);
 $setuphold (negedge E,negedge SC,tsu_sc_l_e,th_e_sc_h,notifier,,,d_E,d_SC);
 $setuphold (negedge E &&& (SC==1'b0),posedge D &&& (SC==1'b0),tsu_d_h_e,th_e_d_l,notifier,,,d_E,d_D);
 $setuphold (negedge E &&& (SC==1'b0),negedge D &&& (SC==1'b0),tsu_d_l_e,th_e_d_h,notifier,,,d_E,d_D);
`else
 $setup (posedge SD &&& (SC==1'b1),negedge E &&& (SC==1'b1),tsu_sd_h_e,notifier);
 $setup (negedge SD &&& (SC==1'b1),negedge E &&& (SC==1'b1),tsu_sd_l_e,notifier);
 $setup (posedge SC,negedge E,tsu_sc_h_e,notifier);
 $setup (negedge SC,negedge E,tsu_sc_l_e,notifier);
 $setup (posedge D &&& (SC==1'b0),negedge E &&& (SC==1'b0),tsu_d_h_e,notifier);
 $setup (negedge D &&& (SC==1'b0),negedge E &&& (SC==1'b0),tsu_d_l_e,notifier);
 $hold  (negedge E &&& (SC==1'b1),negedge SD &&& (SC==1'b1),th_e_sd_h,notifier);
 $hold  (negedge E &&& (SC==1'b1),posedge SD &&& (SC==1'b1),th_e_sd_l,notifier);
 $hold  (negedge E,negedge SC,th_e_sc_h,notifier);
 $hold  (negedge E,posedge SC,th_e_sc_l,notifier);
 $hold  (negedge E &&& (SC==1'b0),negedge D &&& (SC==1'b0),th_e_d_h,notifier);
 $hold  (negedge E &&& (SC==1'b0),posedge D &&& (SC==1'b0),th_e_d_l,notifier);
`endif
 $width (posedge E,tpw_e_h,0,notifier);
 $width (negedge E,tpw_e_l,0,notifier);
 $width (posedge SC,tpw_sc_h,0,notifier);
// Delays
 if (E==1'b1)
 (        SC => Q ) = (sc_lh_q_lh,sc_hl_q_hl);
 if (E==1'b1)
 (        SC => QN) = (sc_lh_qn_lh,sc_hl_qn_hl);
 if ((E==1'b1) && (SC==1'b0))
 (        D +=> Q ) = (d_lh_q_lh,d_hl_q_hl);
 if ((E==1'b1) && (SC==1'b0))
 (        D -=> QN) = (d_hl_qn_lh,d_lh_qn_hl);
 if ((E==1'b1) && (SC==1'b1))
 (        SD +=> Q ) = (sd_lh_q_lh,sd_hl_q_hl);
 if ((E==1'b1) && (SC==1'b1))
 (        SD -=> QN) = (sd_hl_qn_lh,sd_lh_qn_hl);
 (posedge E  => (Q  +: ((SD && SC) || (D && ~SC)))) = (e_lh_q_lh,e_lh_q_hl);
 (posedge E  => (QN -: ((SD && SC) || (D && ~SC)))) = (e_lh_qn_lh,e_lh_qn_hl);
 (negedge E  => (SO +: ((SD && SC) || (D && ~SC)))) = (e_hl_so_lh,e_hl_so_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
