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
// Filename     	: cg01d1.v
// Description  	:  1-Bit Carry Generator, 1X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module cg01d1 (A,B,CI,CO);

output  CO;
input   A,B,CI;

U_AO3 #1 cg01d1_CO(CO, A, B, CI);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a_lh_co_lh_1=0,a_hl_co_hl_1=0,b_hl_co_hl_1=0,b_lh_co_lh_1=0,
 ci_hl_co_hl_1=0,ci_lh_co_lh_2=0;
// Delays
 (        A  +=> CO) = (a_lh_co_lh_1,a_hl_co_hl_1);
 (        B  +=> CO) = (b_lh_co_lh_1,b_hl_co_hl_1);
 (        CI +=> CO) = (ci_lh_co_lh_2,ci_hl_co_hl_1);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
