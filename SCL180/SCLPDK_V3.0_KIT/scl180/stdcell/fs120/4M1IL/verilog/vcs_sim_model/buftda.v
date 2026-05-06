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
// Filename     	: buftda.v
// Description          : Non-inverting 3-State Buffer with Output Enable Bar, 10X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//


module buftda (EN,I,Z);

output  Z;
input   EN,I;

bufif0 #1 (Z,I,EN);

`ifdef functional
`else
specify
// Parameter declarations
 specparam en_lh_z_lz=0,en_hl_z_zl=0,i_lh_z_lh=0,en_lh_z_hz=0,
 en_hl_z_zh=0,i_hl_z_hl=0;
// Delays
 (        EN  => Z) = (en_lh_z_lz,en_lh_z_hz,en_lh_z_lz,en_hl_z_zh,en_lh_z_hz,en_hl_z_zl);
 (        I  +=> Z) = (i_lh_z_lh,i_hl_z_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
