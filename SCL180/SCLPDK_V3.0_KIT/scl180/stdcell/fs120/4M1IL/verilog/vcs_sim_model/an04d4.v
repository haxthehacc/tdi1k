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
// Filename     	: an04d4.v
// Description  	:  4-Input AND, 4X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module an04d4 (A1,A2,A3,A4,Z);

output  Z;
input   A1,A2,A3,A4;

and #1 (Z,A4,A3,A2,A1);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a1_lh_z_lh=0,a1_hl_z_hl=0,a2_hl_z_hl=0,a2_lh_z_lh=0,
 a3_hl_z_hl=0,a3_lh_z_lh=0,a4_hl_z_hl=0,a4_lh_z_lh=0;
// Delays
 (        A1 +=> Z) = (a1_lh_z_lh,a1_hl_z_hl);
 (        A2 +=> Z) = (a2_lh_z_lh,a2_hl_z_hl);
 (        A3 +=> Z) = (a3_lh_z_lh,a3_hl_z_hl);
 (        A4 +=> Z) = (a4_lh_z_lh,a4_hl_z_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
