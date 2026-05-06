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
// Filename     	: oai31d1.v
// Description  	:  3/1 OR-AND-INVERT, 1X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module oai31d1 (B3,B2,B1,A,ZN);

output  ZN;
input   B3,B2,B1,A;

or (g_2_out,B2,B1,B3);
nand #1 (ZN,A,g_2_out);

`ifdef functional
`else
specify
// Parameter declarations
 specparam a_hl_zn_lh_1=0,b1_hl_zn_lh=0,b1_lh_zn_hl=0,b2_lh_zn_hl=0,
 b2_hl_zn_lh=0,b3_lh_zn_hl=0,a_lh_zn_hl_4=0,b3_hl_zn_lh=0;
// Delays
 (        A  -=> ZN) = (a_hl_zn_lh_1,a_lh_zn_hl_4);
 (        B1 -=> ZN) = (b1_hl_zn_lh,b1_lh_zn_hl);
 (        B2 -=> ZN) = (b2_hl_zn_lh,b2_lh_zn_hl);
 (        B3 -=> ZN) = (b3_hl_zn_lh,b3_lh_zn_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
