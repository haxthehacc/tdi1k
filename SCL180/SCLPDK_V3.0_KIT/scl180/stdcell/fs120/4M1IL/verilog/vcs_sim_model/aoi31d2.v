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
// Filename     	: aoi31d2.v
// Description  	:  3/1 AND-OR-INVERT, 2X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module aoi31d2 (B1,B2,B3,A,ZN);

output  ZN;
input   B1,B2,B3,A;

and (g_1_out,B2,B1,B3);
nor #1 (ZN,g_1_out,A);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a_lh_zn_hl_4=0,a_hl_zn_lh_4=0,b3_lh_zn_hl=0,b2_hl_zn_lh=0,
 b2_lh_zn_hl=0,b1_hl_zn_lh=0,b1_lh_zn_hl=0,b3_hl_zn_lh=0;
// Delays
 (        A  -=> ZN) = (a_hl_zn_lh_4,a_lh_zn_hl_4);
 (        B3 -=> ZN) = (b3_hl_zn_lh,b3_lh_zn_hl);
 (        B2 -=> ZN) = (b2_hl_zn_lh,b2_lh_zn_hl);
 (        B1 -=> ZN) = (b1_hl_zn_lh,b1_lh_zn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
