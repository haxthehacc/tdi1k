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
// Filename     	: dfnrn2.v
// Description  	:  Buffered D Flip-Flop with QN only, 2X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module dfnrn2 (CP,D,QN);

output  QN;
input   CP,D;

`ifdef neg_tchk
wire d_CP,d_D;
`endif

`ifdef functional
U_FD_P #1 (QN_not,D,CP);
`else
reg notifier;
`ifdef neg_tchk
U_FD_P_NO #1 (QN_not,d_D,d_CP,notifier);
`else
U_FD_P_NO #1 (QN_not,D,CP,notifier);
`endif
`endif

not (QN,QN_not);

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_cp=0.14,tsu_d_l_cp=0.18,th_cp_d_h=0.00,th_cp_d_l=0.00,
 tpw_cp_h=0.24,tpw_cp_l=0.41,cp_lh_qn_hl=0,cp_lh_qn_lh=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (posedge CP,posedge D,tsu_d_h_cp,th_cp_d_l,notifier,,,d_CP,d_D);
 $setuphold (posedge CP,negedge D,tsu_d_l_cp,th_cp_d_h,notifier,,,d_CP,d_D);
`else
 $setup (posedge D,posedge CP,tsu_d_h_cp,notifier);
 $setup (negedge D,posedge CP,tsu_d_l_cp,notifier);
 $hold  (posedge CP,negedge D,th_cp_d_h,notifier);
 $hold  (posedge CP,posedge D,th_cp_d_l,notifier);
`endif
 $width (posedge CP,tpw_cp_h,0,notifier);
 $width (negedge CP,tpw_cp_l,0,notifier);
// Delays
 (posedge CP  => (QN -: D  )) = (cp_lh_qn_lh,cp_lh_qn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
