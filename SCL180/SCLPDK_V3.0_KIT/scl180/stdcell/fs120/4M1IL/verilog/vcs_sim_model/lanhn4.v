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
// Filename     	: lanhn4.v
// Description  	:  Buffered Latch with QN only, 4X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module lanhn4 (E,D,QN);

output  QN;
input   E,D;


`ifdef neg_tchk
wire d_E,d_D;
`endif

`ifdef functional
U_LD_P (QN_not,D,E);
`else
reg notifier;
`ifdef neg_tchk
U_LD_P_NO (QN_not,d_D,d_E,notifier);
`else
U_LD_P_NO (QN_not,D,E,notifier);
`endif
`endif

not #1 (QN,QN_not);

`ifdef functional
`else
specify
// Parameter declarations
 specparam tsu_d_h_e=0.24,tsu_d_l_e=0.16,th_e_d_h=0.00,th_e_d_l=0.00,
 tpw_e_h=0.21,d_lh_qn_hl=0,d_hl_qn_lh=0,e_lh_qn_hl=0,e_lh_qn_lh=0;
// Violation constraints
`ifdef neg_tchk
 $setuphold (negedge E,posedge D,tsu_d_h_e,th_e_d_l,notifier,,,d_E,d_D);
 $setuphold (negedge E,negedge D,tsu_d_l_e,th_e_d_h,notifier,,,d_E,d_D);
`else
 $setup (posedge D,negedge E,tsu_d_h_e,notifier);
 $setup (negedge D,negedge E,tsu_d_l_e,notifier);
 $hold  (negedge E,negedge D,th_e_d_h,notifier);
 $hold  (negedge E,posedge D,th_e_d_l,notifier);
 `endif
 $width (posedge E,tpw_e_h,0,notifier);
// Delays
 if (E==1'b1)
 (        D -=> QN) = (d_hl_qn_lh,d_lh_qn_hl);
 (posedge E  => (QN -: D )) = (e_lh_qn_lh,e_lh_qn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 1ps

