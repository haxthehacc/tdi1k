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
// Filename     	: su01d2.v
// Description          : 1-Bit Subtractor, 2X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
// STDP arcs            : 14Aug05 ben gilboa 
//


module su01d2 (A,B,CI,S,CO);

output  S,CO;
input   A,B,CI;

U_SUB2_D #1 (S,A,B,CI);
U_SUB2_C #1 (CO,A,B,CI);

`ifdef functional
`else
specify
// Parameter declarations
 specparam default_rise=0,default_fall=0;
// Delays
if ((CI == 1'b0) && (B == 1'b0))
	(A => S) = (default_rise,default_fall);
if ((CI == 1'b1) && (B == 1'b1))
	(A => S) = (default_rise,default_fall);
if ((CI == 1'b0) && (B == 1'b1))
	(A => S) = (default_rise,default_fall);
if ((CI == 1'b1) && (B == 1'b0))
	(A => S) = (default_rise,default_fall);
ifnone (A => S) = (default_rise,default_fall);
if ((CI == 1'b0) && (A == 1'b1))
	(B => S) = (default_rise,default_fall);
if ((CI == 1'b1) && (A == 1'b0))
	(B => S) = (default_rise,default_fall);
if ((CI == 1'b0) && (A == 1'b0))
	(B => S) = (default_rise,default_fall);
if ((CI == 1'b1) && (A == 1'b1))
	(B => S) = (default_rise,default_fall);
ifnone (B => S) = (default_rise,default_fall);
if ((B == 1'b0) && (A == 1'b0))
	(CI => S) = (default_rise,default_fall);
if ((B == 1'b1) && (A == 1'b1))
	(CI => S) = (default_rise,default_fall);
if ((B == 1'b0) && (A == 1'b1))
	(CI => S) = (default_rise,default_fall);
if ((B == 1'b1) && (A == 1'b0))
	(CI => S) = (default_rise,default_fall);
ifnone (CI => S) = (default_rise,default_fall);

 (        A  +=> CO) = (default_rise,default_fall);
 (        B  -=> CO) = (default_rise,default_fall);
 (        CI +=> CO) = (default_rise,default_fall);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
