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
// Filename     	: invbdf.v
// Description          : Inverting Buffer with Balanced Rise/Fall Time, 15X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//


module invbdf (I,ZN);

output  ZN;
input   I;

not #1 (ZN,I);

`ifdef functional
`else
specify
// Parameter declarations
 specparam i_lh_zn_hl=0,i_hl_zn_lh=0;
// Delays
 (        I -=> ZN) = (i_hl_zn_lh,i_lh_zn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
