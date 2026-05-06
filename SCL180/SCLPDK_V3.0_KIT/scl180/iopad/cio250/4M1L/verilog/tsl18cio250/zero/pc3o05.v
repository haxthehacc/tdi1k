//////////////////////////////////////////////////////////////////
//                                                              //
// Copyright (c) 2003 Synopsys, Inc.  All Rights Reserved       //
// This information is provided pursuant to a license agreement //
// that grants limited rights of access/use and requires that   //
// the information be treated as confidential.                  //
//                                                              //
//////////////////////////////////////////////////////////////////


//  --    SYNOPSYS Verilog Models

// 
// Model type   	: zero timing
// Filename     	: pc3o05.v
// Description  	: CMOS Output Only Buffer, 5X Drive
// Library      	: tsl18cio250
// Programmer   	: chli
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//
`celldefine
`suppress_faults
`enable_portfaults

`ifdef functional
 `timescale 1ns / 1ns
 `delay_mode_distributed
 `delay_mode_unit
`else
 `timescale 1ns / 10ps
 `delay_mode_path
`endif 


module pc3o05 (PAD,I);

output  PAD;
input   I;

buf #0.01 (PAD,I);

`ifdef functional
`else
specify
// Parameter declarations
 specparam i_lh_pad_lh=0,i_hl_pad_hl=0;
// Delays
 (        I +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
