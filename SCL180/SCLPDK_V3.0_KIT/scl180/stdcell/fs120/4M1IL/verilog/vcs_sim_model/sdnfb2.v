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
// Filename     	: sdnfb2.v
// Description  	:  Muxed Scan D Flip-Flop, 2X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//


module sdnfb2 (D,SD,SC,CPN,Q,QN);

output  Q,QN;
input   D,SD,SC,CPN;

`ifdef neg_tchk
wire d_D,d_SD,d_SC,d_CPN;
`endif

`ifdef functional
U_FD_N #1 (buf_Q,mux_out,CPN);
`else
reg notifier;
`ifdef neg_tchk
U_FD_N_NO #1 (buf_Q,mux_out,d_CPN,notifier);
`else
U_FD_N_NO #1 (buf_Q,mux_out,CPN,notifier);
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
specify
// Parameter declarations
 specparam tsu_sd_h_cpn=0.47,tsu_sd_l_cpn=0.56,tsu_sc_h_cpn=0.46,tsu_sc_l_cpn=0.40,
 tsu_d_h_cpn=0.27,tsu_d_l_cpn=0.36,th_cpn_sd_h=0.00,th_cpn_sd_l=0.00,th_cpn_sc_h=0.00,
 th_cpn_sc_l=0.00,th_cpn_d_h=0.00,th_cpn_d_l=0.00,tpw_cpn_h=0.27,tpw_cpn_l=0.38,
 cpn_hl_qn_hl_1=0,cpn_hl_q_lh_1=0,cpn_hl_qn_lh_1=0,cpn_hl_q_hl_1=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge CPN &&& (SC==1'b1),posedge SD &&& (SC==1'b1),tsu_sd_h_cpn,th_cpn_sd_l,notifier,,,d_CPN,d_SD);
 $setuphold (negedge CPN &&& (SC==1'b1),negedge SD &&& (SC==1'b1),tsu_sd_l_cpn,th_cpn_sd_h,notifier,,,d_CPN,d_SD);
 $setuphold (negedge CPN,posedge SC,tsu_sc_h_cpn,th_cpn_sc_l,notifier,,,d_CPN,d_SC);
 $setuphold (negedge CPN,negedge SC,tsu_sc_l_cpn,th_cpn_sc_h,notifier,,,d_CPN,d_SC);
 $setuphold (negedge CPN &&& (SC==1'b0),posedge D &&& (SC==1'b0),tsu_d_h_cpn,th_cpn_d_l,notifier,,,d_CPN,d_D);
 $setuphold (negedge CPN &&& (SC==1'b0),negedge D &&& (SC==1'b0),tsu_d_l_cpn,th_cpn_d_h,notifier,,,d_CPN,d_D);
`else
 $setup (posedge SD &&& (SC==1'b1),negedge CPN &&& (SC==1'b1),tsu_sd_h_cpn,notifier);
 $setup (negedge SD &&& (SC==1'b1),negedge CPN &&& (SC==1'b1),tsu_sd_l_cpn,notifier);
 $setup (posedge SC,negedge CPN,tsu_sc_h_cpn,notifier);
 $setup (negedge SC,negedge CPN,tsu_sc_l_cpn,notifier);
 $setup (posedge D &&& (SC==1'b0),negedge CPN &&& (SC==1'b0),tsu_d_h_cpn,notifier);
 $setup (negedge D &&& (SC==1'b0),negedge CPN &&& (SC==1'b0),tsu_d_l_cpn,notifier);
 $hold  (negedge CPN &&& (SC==1'b1),negedge SD &&& (SC==1'b1),th_cpn_sd_h,notifier);
 $hold  (negedge CPN &&& (SC==1'b1),posedge SD &&& (SC==1'b1),th_cpn_sd_l,notifier);
 $hold  (negedge CPN,negedge SC,th_cpn_sc_h,notifier);
 $hold  (negedge CPN,posedge SC,th_cpn_sc_l,notifier);
 $hold  (negedge CPN &&& (SC==1'b0),negedge D &&& (SC==1'b0),th_cpn_d_h,notifier);
 $hold  (negedge CPN &&& (SC==1'b0),posedge D &&& (SC==1'b0),th_cpn_d_l,notifier);
`endif
 $width (posedge CPN,tpw_cpn_h,0,notifier);
 $width (negedge CPN,tpw_cpn_l,0,notifier);
// Delays
 (negedge CPN  => (QN -: ((SD && SC) || (D && ~SC)))) = (cpn_hl_qn_lh_1,cpn_hl_qn_hl_1);
 (negedge CPN  => (Q  +: ((SD && SC) || (D && ~SC)))) = (cpn_hl_q_lh_1,cpn_hl_q_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
