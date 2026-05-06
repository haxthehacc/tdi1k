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
// Filename     	: aor22d4.v
// Description          : 2/2 AND-OR, 4X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//


module aor22d4 (B2,B1,A2,A1,Z);

output  Z;
input   B2,B1,A2,A1;

and (g_1_out,B2,B1);
and (g_2_out,A2,A1);
or #1 (Z,g_1_out,g_2_out);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a2_lh_z_lh_2=0,a1_hl_z_hl_2=0,a1_lh_z_lh_2=0,a2_hl_z_hl_2=0,
 b1_hl_z_hl_1=0,b1_lh_z_lh_1=0,b2_lh_z_lh_2=0,b2_hl_z_hl_2=0;
// Delays
 (        A2 +=> Z) = (a2_lh_z_lh_2,a2_hl_z_hl_2);
 (        A1 +=> Z) = (a1_lh_z_lh_2,a1_hl_z_hl_2);
 (        B1 +=> Z) = (b1_lh_z_lh_1,b1_hl_z_hl_1);
 (        B2 +=> Z) = (b2_lh_z_lh_2,b2_hl_z_hl_2);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
