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
// Filename     	: adp1d4.v
// Description  	:  1-Bit Full Adder with Propagate, 4X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
// STDP arcs            : 14Aug05 ben gilboa 
//


module adp1d4 (A,B,CI,S,P,CO);

output  S,P,CO;
input   A,B,CI;

buf (A_buf,A);
buf (B_buf,B);
buf (CI_buf,CI);

wire S_OUT = ((!CI_buf && !B_buf && A_buf) || (!CI_buf && B_buf && !A_buf) || (CI_buf && B_buf && A_buf) || (CI_buf && !B_buf && !A_buf));

buf #1 (S,S_OUT);
wire P_OUT = ((!B_buf && A_buf) || (B_buf && !A_buf));

buf #1 (P,P_OUT);
wire CO_OUT = ((B_buf && A_buf) || (CI_buf && B_buf) || (CI_buf && A_buf));

buf #1 (CO,CO_OUT);

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
if ((CI == 1'b0) && (A == 1'b0))
	(B => S) = (default_rise,default_fall);
if ((CI == 1'b1) && (A == 1'b1))
	(B => S) = (default_rise,default_fall);
if ((CI == 1'b0) && (A == 1'b1))
	(B => S) = (default_rise,default_fall);
if ((CI == 1'b1) && (A == 1'b0))
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
if ((CI == 1'b0) && (B == 1'b0))
	(A => P) = (default_rise,default_fall);
if ((CI == 1'b1) && (B == 1'b1))
	(A => P) = (default_rise,default_fall);
if ((CI == 1'b0) && (B == 1'b1))
	(A => P) = (default_rise,default_fall);
if ((CI == 1'b1) && (B == 1'b0))
	(A => P) = (default_rise,default_fall);
ifnone (A => P) = (default_rise,default_fall);
if ((CI == 1'b0) && (A == 1'b0))
	(B => P) = (default_rise,default_fall);
if ((CI == 1'b1) && (A == 1'b1))
	(B => P) = (default_rise,default_fall);
if ((CI == 1'b0) && (A == 1'b1))
	(B => P) = (default_rise,default_fall);
if ((CI == 1'b1) && (A == 1'b0))
	(B => P) = (default_rise,default_fall);
ifnone (B => P) = (default_rise,default_fall);

 (        CI +=> CO) = (default_rise,default_fall);
 (        A  +=> CO) = (default_rise,default_fall);
 (        B  +=> CO) = (default_rise,default_fall);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
