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
// Filename     	: slnlb4.v
// Description          : Muxed Scan Latch with Low Enable, 4X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.9
// Added $width for SC  : 18Dec05 bengil & assafma 
//


module slnlb4 (D,SD,SC,EN,Q,QN,SO);

output  Q,QN,SO;
input   D,SD,SC,EN;

`ifdef neg_tchk
wire d_D,d_EN,d_SD,d_SC;
`endif

`ifdef functional
U_MUX_2_1 (mux_out,D,SD,SC);
U_LD_N #1 (buf_Q,mux_out,EN);
U_LD_P #1 (SO,buf_Q,EN);
`else
reg notifier;
`ifdef neg_tchk
U_MUX_2_1 (mux_out,d_D,d_SD,d_SC);
U_LD_N_NO #1 (buf_Q,mux_out,d_EN,notifier);
U_LD_P_NO #1 (SO,buf_Q,d_EN,notifier);
`else
U_MUX_2_1 (mux_out,D,SD,SC);
U_LD_N_NO #1 (buf_Q,mux_out,EN,notifier);
U_LD_P_NO #1 (SO,buf_Q,EN,notifier);
`endif
`endif

buf (Q,buf_Q);
not (QN,buf_Q);

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_en=0.00,tsu_d_l_en=0.13,th_en_d_h=0.00,th_en_d_l=0.15,
 tsu_sd_h_en=0.00,tsu_sd_l_en=0.13,tsu_sc_h_en=0.00,tsu_sc_l_en=0.13,
 th_en_sd_h=0.00,th_en_sd_l=0.15,th_en_sc_h=0.00,th_en_sc_l=0.15,
 tpw_en_h=0.00,tpw_en_l=0.21,tpw_sc_h=0,d_hl_q_hl=0,d_hl_qn_lh=0,d_lh_q_lh=0,d_lh_qn_hl=0,
 en_hl_q_hl=0,en_hl_qn_lh=0,en_hl_q_lh=0,en_hl_qn_hl=0,
 sc_hl_q_lh=0,sc_hl_q_hl=0,sc_hl_qn_lh=0,sc_hl_qn_hl=0,sd_lh_q_lh=0,
 sd_hl_q_hl=0,sd_hl_qn_lh=0,sd_lh_qn_hl=0,en_lh_so_lh=0,en_lh_so_hl=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge EN &&& (SC==1'b1),posedge SD &&& (SC==1'b1),tsu_sd_h_en,th_en_sd_l,notifier,,,d_EN,d_SD);
 $setuphold (posedge EN &&& (SC==1'b1),negedge SD &&& (SC==1'b1),tsu_sd_l_en,th_en_sd_h,notifier,,,d_EN,d_SD);
 $setuphold (posedge EN,posedge SC,tsu_sc_h_en,th_en_sc_l,notifier,,,d_EN,d_SC);
 $setuphold (posedge EN,negedge SC,tsu_sc_l_en,th_en_sc_h,notifier,,,d_EN,d_SC);
 $setuphold (posedge EN &&& (SC==1'b0),posedge D &&& (SC==1'b0),tsu_d_h_en,th_en_d_l,notifier,,,d_EN,d_D);
 $setuphold (posedge EN &&& (SC==1'b0),negedge D &&& (SC==1'b0),tsu_d_l_en,th_en_d_h,notifier,,,d_EN,d_D);
`else
 $setup (posedge SD &&& (SC==1'b1),posedge EN &&& (SC==1'b1),tsu_sd_h_en,notifier);
 $setup (negedge SD &&& (SC==1'b1),posedge EN &&& (SC==1'b1),tsu_sd_l_en,notifier);
 $setup (posedge SC,posedge EN,tsu_sc_h_en,notifier);
 $setup (negedge SC,posedge EN,tsu_sc_l_en,notifier);
 $setup (posedge D &&& (SC==1'b0),posedge EN &&& (SC==1'b0),tsu_d_h_en,notifier);
 $setup (negedge D &&& (SC==1'b0),posedge EN &&& (SC==1'b0),tsu_d_l_en,notifier);
 $hold  (posedge EN &&& (SC==1'b1),negedge SD &&& (SC==1'b1),th_en_sd_h,notifier);
 $hold  (posedge EN &&& (SC==1'b1),posedge SD &&& (SC==1'b1),th_en_sd_l,notifier);
 $hold  (posedge EN,negedge SC,th_en_sc_h,notifier);
 $hold  (posedge EN,posedge SC,th_en_sc_l,notifier);
 $hold  (posedge EN &&& (SC==1'b0),negedge D &&& (SC==1'b0),th_en_d_h,notifier);
 $hold  (posedge EN &&& (SC==1'b0),posedge D &&& (SC==1'b0),th_en_d_l,notifier);
`endif
 $width (negedge EN,tpw_en_l,0,notifier);
 $width (posedge EN,tpw_en_h,0,notifier);
 $width (posedge SC,tpw_sc_h,0,notifier);
// Delays
 if (EN==1'b0)
 (        SC => Q ) = (sc_hl_q_lh,sc_hl_q_hl);
 if (EN==1'b0)
 (        SC => QN ) = (sc_hl_qn_lh,sc_hl_qn_hl);
 if ((EN==1'b0) && (SC==1'b0))
 (        D +=> Q ) = (d_lh_q_lh,d_hl_q_hl);
 if ((EN==1'b0) && (SC==1'b0))
 (        D -=> QN) = (d_hl_qn_lh,d_lh_qn_hl);
 if ((EN==1'b0) && (SC==1'b1))
 (        SD +=> Q ) = (sd_lh_q_lh,sd_hl_q_hl);
 if ((EN==1'b0) && (SC==1'b1))
 (        SD -=> QN) = (sd_hl_qn_lh,sd_lh_qn_hl);
 (negedge EN  => (Q  +: ((SD && SC) || (D && ~SC)))) = (en_hl_q_lh,en_hl_q_hl);
 (negedge EN  => (QN -: ((SD && SC) || (D && ~SC)))) = (en_hl_qn_lh,en_hl_qn_hl);
 (posedge EN  => (SO +: ((SD && SC) || (D && ~SC)))) = (en_lh_so_lh,en_lh_so_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
