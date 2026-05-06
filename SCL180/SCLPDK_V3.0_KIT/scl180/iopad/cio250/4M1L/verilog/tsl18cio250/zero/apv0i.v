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
// Filename     	: apv0i.v
// Description  	: VSS for Analog Core
// Library      	: tsl18cio250
// Programmer   	: oleg
// Product version	: Rev. main.1 
// Master version	: Rev. main.5
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module apv0i (AVSS);

   output AVSS;
   pulldown             G2(AVSS);

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
