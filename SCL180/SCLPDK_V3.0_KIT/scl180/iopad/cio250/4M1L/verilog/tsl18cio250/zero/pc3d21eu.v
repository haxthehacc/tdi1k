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
// Filename     	: pc3d21eu.v
// Description  	: Schmitt Input Only with Enable controlled Pull-up
// Library      	: tsl18cio250
// Programmer   	: LOGIN
// Product version	: PRODUCT_VERSION 
// Master version	: MASTER_VERSION
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


module pc3d21eu (PAD,CIN,RENB);

output  CIN;
input   PAD,RENB;
tri1 up;

buf #0.01 (CIN,PAD);
bufif0 (pull0,pull1) #0.01 (PAD,up,RENB);

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_cin_lh=0,pad_hl_cin_hl=0,
 renb_hl_pad_zh=0,renb_lh_pad_hz=0;
// Delays
 (        PAD +=> CIN) = (pad_lh_cin_lh,pad_hl_cin_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
