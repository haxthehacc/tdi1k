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
// Filename     	: pc3x12.v
// Description  	: Crystal Oscillator Circuit With Enable Pin, Intermediate Frequency
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


module pc3x12 (XIN,XOUT,Z,EN);

output  Z;
input   XIN,EN;
inout	XOUT;

  not                  G2(N2,EN);
  notif1               G3(XOUT,XIN,N2);
  nand                 G5(Z,XOUT,N2);

`ifdef functional
`else
specify
// Parameter declarations
 specparam en_lh_z_lh_1=0,en_lh_xout_hz=0,en_hl_z_hl=0,
 en_hl_xout_zh=0,xin_lh_xout_hl=0,en_lh_xout_lz=0,
 en_hl_xout_zl=0,xin_hl_z_hl=0,xin_hl_xout_lh=0,xin_lh_z_lh=0;
// Delays
 (        EN   => XOUT) = (en_lh_xout_lz,en_lh_xout_hz,en_lh_xout_lz,en_hl_xout_zh,en_lh_xout_hz,en_hl_xout_zl);
 (        EN  +=> Z   ) = (en_lh_z_lh_1,en_hl_z_hl);
 (        XIN -=> XOUT) = (xin_hl_xout_lh,xin_lh_xout_hl);
 (        XIN +=> Z   ) = (xin_lh_z_lh,xin_hl_z_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 10ps

