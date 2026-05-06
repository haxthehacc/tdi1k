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
// Filename     	: srlab1.v
// Description  	:  SetN ResetN Latch, (NAND Inputs) 1X
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.6
//
//


module srlab1 (RN,SN,Q,QN);

output  Q,QN;
input   RN,SN;

buf b_RN (RN_buf,RN);
buf b_SN (SN_buf,SN);

`ifdef functional
U_L_SB_RB #1 srlab1_Q(Q,SN_buf,RN_buf);
U_L_SB_RB_QN #1 srlab1_QN(QN,SN_buf,RN_buf);
`else
reg notifier;
U_L_SB_RB_NO #1 srlab1_Q(Q,SN_buf,RN_buf,notifier);
U_L_SB_RB_QN_NO #1 srlab1_QN(QN,SN_buf,RN_buf,notifier);
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam tpw_sn_l=0.28,tpw_rn_l=0.29,rn_hl_qn_lh=0,sn_hl_qn_hl_1=0,
 rn_lh_q_lh=0,sn_lh_qn_lh=0,rn_hl_q_hl_2=0,sn_hl_q_lh=0;
// Violation constraints
 $width (negedge SN,tpw_sn_l,0,notifier);
 $width (negedge RN,tpw_rn_l,0,notifier);
// Delays
 (        SN +=> QN) = (sn_lh_qn_lh,sn_hl_qn_hl_1);
 (        RN +=> Q ) = (rn_lh_q_lh,rn_hl_q_hl_2);
 (negedge RN  => (QN +: 1'b1)) = (rn_hl_qn_lh,0);
 (negedge SN  => (Q  +: 1'b1)) = (sn_hl_q_lh,0);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
