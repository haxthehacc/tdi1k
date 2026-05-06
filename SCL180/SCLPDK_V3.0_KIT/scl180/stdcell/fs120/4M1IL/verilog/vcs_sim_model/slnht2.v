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
// Filename     	: slnht2.v
// Description          : Muxed Scan Latch with Z-output only and Active Higher Enable, 2X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.10
//
//


module slnht2 (D,SD,SC,E,OE,Z,SO);

output  Z,SO;
input   D,SD,SC,E,OE;

`ifdef neg_tchk
wire d_D,d_SD,d_SC,d_E;
`endif


`ifdef functional
buf b_OE (OE_buf,OE);
U_MUX_2_1 (mux_out,D,SD,SC);
U_LD_P #1 (Q,mux_out,E);
U_LD_N #1 (SO,Q,E);
bufif1 b1(Z,Q,OE_buf);
`else
reg notifier;
`ifdef neg_tchk
buf b_OE (OE_buf,OE);
U_MUX_2_1 (mux_out,d_D,d_SD,d_SC);
U_LD_P_NO #1 (Q,mux_out,d_E,notifier);
U_LD_N_NO #1 (SO,Q,d_E,notifier);
bufif1 b1(Z,Q,OE_buf);
`else
buf b_OE (OE_buf,OE);
U_MUX_2_1 (mux_out,D,SD,SC);
U_LD_P_NO #1 (Q,mux_out,E,notifier);
U_LD_N_NO #1 (SO,Q,E,notifier);
bufif1 b1(Z,Q,OE_buf);
`endif
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_e=0.04,tsu_d_l_e=0.18,th_e_d_h=0.00,th_e_d_l=0.01,
 tpw_e_l=0.00,tpw_e_h=0.25,d_lh_z_lh=0,oe_hl_z_hz_1=0,oe_lh_z_zl_1=0,d_hl_z_hl=0,
 tsu_sd_h_e=0.04,tsu_sd_l_e=0.18,tsu_sc_h_e=0.04,tsu_sc_l_e=0.18,
 th_e_sd_h=0.00,th_e_sd_l=0.01,th_e_sc_h=0.00,th_e_sc_l=0.01,
 sd_lh_z_lh=0,sd_hl_z_hl=0,sc_hl_z_lh=0,sc_hl_z_hl=0,e_hl_so_lh=0,e_hl_so_hl=0,
 e_lh_z_lh=0,e_lh_z_hl=0,oe_hl_z_lz_1=0,oe_lh_z_zh_2=0;
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
// Delays
 (        OE  => Z) = (oe_hl_z_lz_1,oe_hl_z_hz_1,oe_hl_z_lz_1,oe_lh_z_zh_2,oe_hl_z_hz_1,oe_lh_z_zl_1);
 (D   *> Z) = (d_lh_z_lh,d_hl_z_hl);
 (SD   *> Z) = (sd_lh_z_lh,sd_hl_z_hl);
 (SC   *> Z) = (sc_hl_z_lh,sc_hl_z_hl);
 (E   *> Z) = (e_lh_z_lh,e_lh_z_hl);
 (negedge E  => (SO +: ((SD && SC) || (D && ~SC)))) = (e_hl_so_lh,e_hl_so_hl);
endspecify
`endif



endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
