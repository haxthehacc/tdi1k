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
// Filename     	: nd02d2.v
// Description  	:  2-Input NAND, 2X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module nd02d2 (A1,A2,ZN);

output  ZN;
input   A1,A2;

nand #1 (ZN,A2,A1);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a1_lh_zn_hl=0,a1_hl_zn_lh=0,a2_hl_zn_lh=0,a2_lh_zn_hl=0;
// Delays
 (        A1 -=> ZN) = (a1_hl_zn_lh,a1_lh_zn_hl);
 (        A2 -=> ZN) = (a2_hl_zn_lh,a2_lh_zn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
