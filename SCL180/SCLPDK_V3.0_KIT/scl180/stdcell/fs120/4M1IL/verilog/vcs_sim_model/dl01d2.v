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
// Filename     	: dl01d2.v
// Description  	:  Non Inverting Delay Buffer with 1X Delay, 2X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.6
//
//


module dl01d2 (I,Z);

output  Z;
input   I;

buf #1 (Z,I);

`ifdef functional
`else
specify
// Parameter declarations
 specparam i_lh_z_lh=0,i_hl_z_hl=0;
// Delays
 (        I +=> Z) = (i_lh_z_lh,i_hl_z_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
