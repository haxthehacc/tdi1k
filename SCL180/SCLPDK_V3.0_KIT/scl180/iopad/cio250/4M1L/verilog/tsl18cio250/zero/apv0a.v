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
// Filename     	: apv0a.v
// Description  	: VSS for AC section of Analog I/O Circuitry
// Library      	: tsl18cio250
// Programmer   	: oleg
// Product version	: Rev. main.1 
// Master version	: Rev. main.6
//
//

`celldefine
`delay_mode_path
`suppress_faults
`enable_portfaults
`timescale 1 ns / 10 ps

module apv0a (AVSSO);

   output AVSSO;
   pulldown             G2(AVSSO);

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
