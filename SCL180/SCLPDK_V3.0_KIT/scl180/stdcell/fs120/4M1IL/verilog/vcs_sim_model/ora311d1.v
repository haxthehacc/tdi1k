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
// Filename     	: ora311d1.v
// Description  	:  3/1/1 OR-AND, 1X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module ora311d1 (C3,C2,C1,B,A,Z);

output  Z;
input   C3,C2,C1,B,A;

or (g_3_out,C1,C3,C2);
and #1 (Z,B,A,g_3_out);

`ifdef functional
`else
specify
// Parameter declarations
 specparam c1_hl_z_hl=0,c1_lh_z_lh=0,c2_lh_z_lh=0,a_hl_z_hl_2=0,
 b_hl_z_hl_2=0,c2_hl_z_hl=0,c3_lh_z_lh=0,a_lh_z_lh_4=0,b_lh_z_lh_4=0,c3_hl_z_hl=0;
// Delays
 (        C1 +=> Z) = (c1_lh_z_lh,c1_hl_z_hl);
 (        C2 +=> Z) = (c2_lh_z_lh,c2_hl_z_hl);
 (        A  +=> Z) = (a_lh_z_lh_4,a_hl_z_hl_2);
 (        B  +=> Z) = (b_lh_z_lh_4,b_hl_z_hl_2);
 (        C3 +=> Z) = (c3_lh_z_lh,c3_hl_z_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
