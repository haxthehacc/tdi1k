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
// Filename     	: pc3b25eu.v
// Description  	: CMOS I/O Buffer with Enable Controlled Pull-up, 5X Drive
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


module pc3b25eu (PAD,OEN,RENB,I,CIN);

output  CIN;
input   RENB,OEN,I;
inout   PAD;

`ifdef charge_decay_on_bidi
  trireg (small) up;
`else
  tri1 up;
`endif

buf #0.01 (CIN,PAD);
bufif0 (pull0,pull1) #0.01 (PAD,up,RENB);
bufif0 #0.01 (PAD,I,OEN);

`ifdef functional
`else
specify
// Parameter declarations
 specparam pad_lh_cin_lh=0,pad_hl_cin_hl=0,i_lh_pad_lh=0,i_hl_pad_hl=0,
 oen_lh_pad_lz=0,oen_hl_pad_zh=0,oen_lh_pad_hz=0,oen_hl_pad_zl=0,
 renb_hl_pad_zh=0,renb_lh_pad_hz=0;
// Delays
 (        OEN  => PAD) = (oen_lh_pad_lz,oen_lh_pad_hz,oen_lh_pad_lz,oen_hl_pad_zh,oen_lh_pad_hz,oen_hl_pad_zl);
 (        RENB => PAD) = (0,renb_lh_pad_hz,0,renb_hl_pad_zh,renb_lh_pad_hz,0);
 (        PAD +=> CIN) = (pad_lh_cin_lh,pad_hl_cin_hl);
 (        I   +=> PAD) = (i_lh_pad_lh,i_hl_pad_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
