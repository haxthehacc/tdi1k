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
// Filename     	: pvdi.v
// Description  	: VDD for Core
// Library      	: tsl18cio250
// Programmer   	: cly
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module pvdi (VDD);

   output VDD;
   pullup               G2(VDD);

   parameter ExtLoad = 50.0 ;

`ifdef NOTIMING
`else
   specify
      specparam cell_count    = 0.000000;
      specparam Transistors   = 0 ;

   endspecify
`endif

endmodule

`nosuppress_faults
`disable_portfaults
`endcelldefine
