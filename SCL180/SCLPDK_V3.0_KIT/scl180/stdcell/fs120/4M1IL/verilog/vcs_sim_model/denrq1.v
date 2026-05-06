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
// Filename     	: denrq1.v
// Description  	:  Buffered Enabled D Flip-Flop with Q only, 1X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module denrq1 (CP,D,ENN,Q);

output  Q;
input   CP,D,ENN;

`ifdef neg_tchk
wire d_CP,d_D,d_ENN;
`endif

`ifdef functional
`else
`ifdef neg_tchk
buf (D_buf,d_D);
buf (ENN_buf,d_ENN);
`else
buf (D_buf,D);
buf (ENN_buf,ENN);
`endif
`endif

`ifdef functional
U_FD_EN_P #1 (Q,CP,ENN,D);
`else
reg notifier;
`ifdef neg_tchk
U_FD_EN_P_NO #1 (Q,d_CP,d_ENN,d_D,notifier);
`else
U_FD_EN_P_NO #1 (Q,CP,ENN,D,notifier);
`endif
`endif

`ifdef functional
`else
wire BOOL_OUT = (((!ENN_buf && D_buf)) && ((!ENN_buf))) || !(!Q || ((!ENN_buf)));
specify
// Parameter declarations
 specparam tsu_enn_h_cp=0.36,tsu_enn_l_cp=0.45,tsu_d_h_cp=0.27,tsu_d_l_cp=0.37,
 th_cp_enn_h=0.00,th_cp_enn_l=0.00,th_cp_d_h=0.00,th_cp_d_l=0.00,tpw_cp_h=0.23,
 tpw_cp_l=0.41,cp_lh_q_hl=0,cp_lh_q_lh=0;
// Violation constraints
`ifdef neg_tchk
$setuphold (posedge CP,posedge ENN,tsu_enn_h_cp,th_cp_enn_l,notifier,,,d_CP,d_ENN);
$setuphold (posedge CP,negedge ENN,tsu_enn_l_cp,th_cp_enn_h,notifier,,,d_CP,d_ENN);
$setuphold (posedge CP &&& (ENN==1'b0),posedge D &&& (ENN==1'b0),tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
$setuphold (posedge CP &&& (ENN==1'b0),negedge D &&& (ENN==1'b0),tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
`else
 $setup (posedge ENN,posedge CP,tsu_enn_h_cp,notifier);
 $setup (negedge ENN,posedge CP,tsu_enn_l_cp,notifier);
 $setup (posedge D &&& (ENN==1'b0),posedge CP &&& (ENN==1'b0),tsu_d_h_cp,notifier);
 $setup (negedge D &&& (ENN==1'b0),posedge CP &&& (ENN==1'b0),tsu_d_l_cp,notifier);
 $hold  (posedge CP,negedge ENN,th_cp_enn_h,notifier);
 $hold  (posedge CP,posedge ENN,th_cp_enn_l,notifier);
 $hold  (posedge CP &&& (ENN==1'b0),negedge D &&& (ENN==1'b0),th_cp_d_h,notifier);
 $hold  (posedge CP &&& (ENN==1'b0),posedge D &&& (ENN==1'b0),th_cp_d_l,notifier);
`endif
 $width (posedge CP &&& (ENN==1'b0),tpw_cp_h,0,notifier);
 $width (negedge CP &&& (ENN==1'b0),tpw_cp_l,0,notifier);
// Delays
 if (ENN==1'b0)
 (posedge CP  => (Q +: BOOL_OUT)) = (cp_lh_q_lh,cp_lh_q_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
