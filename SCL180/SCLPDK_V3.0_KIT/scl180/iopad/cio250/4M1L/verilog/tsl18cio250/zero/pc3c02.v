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
// Filename     	: pc3c02.v
// Description  	: Core Driven Non-inverting Clock Buffer, 2X Drive
// Library      	: tsl18cio250
// Programmer   	: cly
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


module pc3c02 (CCLK,CP);

output  CP;
input   CCLK;

buf #0.01 (CP,CCLK);

`ifdef functional
`else
specify
// Parameter declarations
 specparam cclk_lh_cp_lh=0,cclk_hl_cp_hl=0;
// Delays
 (        CCLK +=> CP) = (cclk_lh_cp_lh,cclk_hl_cp_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
