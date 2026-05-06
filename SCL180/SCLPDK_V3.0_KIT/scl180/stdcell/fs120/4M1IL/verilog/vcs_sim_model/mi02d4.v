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
// Filename     	: mi02d4.v
// Description  	:  2-to-1 Inverting Multiplexer, 4X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
// STDP arcs            : 14Aug05 ben gilboa 
//


module mi02d4 (I0,I1,S,ZN);

output  ZN;
input   I0,I1,S;

U_MUX_2_1_INV #1 (ZN,I0,I1,S);

`ifdef functional
`else
specify
// Parameter declarations
 specparam default_rise=0,default_fall=0;
// Delays
if ((I1 == 1'b0) && (I0 == 1'b1))
	(S => ZN) = (default_rise,default_fall);
if ((I1 == 1'b1) && (I0 == 1'b0))
	(S => ZN) = (default_rise,default_fall);
ifnone (S => ZN) = (default_rise,default_fall);
 (        I0 -=> ZN) = (default_rise,default_fall);
 (        I1 -=> ZN) = (default_rise,default_fall);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
