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
// Filename     	: mx04d4.v
// Description  	:  4-to-1 Multiplexer, 4X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.3
// STDP arcs            : 14Aug05 ben gilboa 
//


module mx04d4 (I0,I1,I2,I3,S0,S1,Z);

output  Z;
input   I0,I1,I2,I3,S0,S1;

U_MUX_4_2 #1 (Z,I0,I1,I2,I3,S0,S1);

`ifdef functional
`else
specify
// Parameter declarations
 specparam default_rise=0,default_fall=0;
// Delays
if ((S1 == 1'b0) && (I3 == 1'b0) && (I2 == 1'b0) && (I1 == 1'b0) && (I0 == 1'b1))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b0) && (I3 == 1'b0) && (I2 == 1'b0) && (I1 == 1'b1) && (I0 == 1'b0))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b0) && (I3 == 1'b0) && (I2 == 1'b1) && (I1 == 1'b0) && (I0 == 1'b1))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b0) && (I3 == 1'b0) && (I2 == 1'b1) && (I1 == 1'b1) && (I0 == 1'b0))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b0) && (I3 == 1'b1) && (I2 == 1'b0) && (I1 == 1'b0) && (I0 == 1'b1))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b0) && (I3 == 1'b1) && (I2 == 1'b0) && (I1 == 1'b1) && (I0 == 1'b0))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b0) && (I3 == 1'b1) && (I2 == 1'b1) && (I1 == 1'b0) && (I0 == 1'b1))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b0) && (I3 == 1'b1) && (I2 == 1'b1) && (I1 == 1'b1) && (I0 == 1'b0))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b1) && (I3 == 1'b0) && (I2 == 1'b1) && (I1 == 1'b0) && (I0 == 1'b0))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b1) && (I3 == 1'b0) && (I2 == 1'b1) && (I1 == 1'b0) && (I0 == 1'b1))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b1) && (I3 == 1'b0) && (I2 == 1'b1) && (I1 == 1'b1) && (I0 == 1'b0))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b1) && (I3 == 1'b0) && (I2 == 1'b1) && (I1 == 1'b1) && (I0 == 1'b1))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b1) && (I3 == 1'b1) && (I2 == 1'b0) && (I1 == 1'b0) && (I0 == 1'b0))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b1) && (I3 == 1'b1) && (I2 == 1'b0) && (I1 == 1'b0) && (I0 == 1'b1))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b1) && (I3 == 1'b1) && (I2 == 1'b0) && (I1 == 1'b1) && (I0 == 1'b0))
	(S0 => Z) = (default_rise,default_fall);
if ((S1 == 1'b1) && (I3 == 1'b1) && (I2 == 1'b0) && (I1 == 1'b1) && (I0 == 1'b1))
	(S0 => Z) = (default_rise,default_fall);
ifnone (S0 => Z) = (default_rise,default_fall);	
if ((S0 == 1'b0) && (I3 == 1'b0) && (I2 == 1'b0) && (I1 == 1'b0) && (I0 == 1'b1))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b0) && (I3 == 1'b0) && (I2 == 1'b0) && (I1 == 1'b1) && (I0 == 1'b1))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b0) && (I3 == 1'b0) && (I2 == 1'b1) && (I1 == 1'b0) && (I0 == 1'b0))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b0) && (I3 == 1'b0) && (I2 == 1'b1) && (I1 == 1'b1) && (I0 == 1'b0))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b0) && (I3 == 1'b1) && (I2 == 1'b0) && (I1 == 1'b0) && (I0 == 1'b1))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b0) && (I3 == 1'b1) && (I2 == 1'b0) && (I1 == 1'b1) && (I0 == 1'b1))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b0) && (I3 == 1'b1) && (I2 == 1'b1) && (I1 == 1'b0) && (I0 == 1'b0))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b0) && (I3 == 1'b1) && (I2 == 1'b1) && (I1 == 1'b1) && (I0 == 1'b0))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b1) && (I3 == 1'b0) && (I2 == 1'b0) && (I1 == 1'b1) && (I0 == 1'b0))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b1) && (I3 == 1'b0) && (I2 == 1'b0) && (I1 == 1'b1) && (I0 == 1'b1))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b1) && (I3 == 1'b0) && (I2 == 1'b1) && (I1 == 1'b1) && (I0 == 1'b0))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b1) && (I3 == 1'b0) && (I2 == 1'b1) && (I1 == 1'b1) && (I0 == 1'b1))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b1) && (I3 == 1'b1) && (I2 == 1'b0) && (I1 == 1'b0) && (I0 == 1'b0))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b1) && (I3 == 1'b1) && (I2 == 1'b0) && (I1 == 1'b0) && (I0 == 1'b1))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b1) && (I3 == 1'b1) && (I2 == 1'b1) && (I1 == 1'b0) && (I0 == 1'b0))
	(S1 => Z) = (default_rise,default_fall);
if ((S0 == 1'b1) && (I3 == 1'b1) && (I2 == 1'b1) && (I1 == 1'b0) && (I0 == 1'b1))
	(S1 => Z) = (default_rise,default_fall);
ifnone (S1 => Z) = (default_rise,default_fall);

 (        I0 +=> Z) = (default_rise,default_fall);
 (        I1 +=> Z) = (default_rise,default_fall);
 (        I2 +=> Z) = (default_rise,default_fall);
 (        I3 +=> Z) = (default_rise,default_fall);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
