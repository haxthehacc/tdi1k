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
// Filename     	: mx08d4.v
// Description  	:  8-to-1 Multiplexer, 4X Drive
// Library      	: tsl18fs120
// Programmer   	: ycui
// Date                 : 08-Oct-2003
// Product version	: Rev. main.1 
// Master version	: Rev. main.4
//
//


module mx08d4 (I0,I1,I2,I3,I4,I5,I6,I7,S0,S1,S2,Z);

output  Z;
input   I0,I1,I2,I3,I4,I5,I6,I7,S0,S1,S2;

buf b_I0 (I0_buf,I0);
buf b_I1 (I1_buf,I1);
buf b_I2 (I2_buf,I2);
buf b_I3 (I3_buf,I3);
buf b_I4 (I4_buf,I4);
buf b_I5 (I5_buf,I5);
buf b_I6 (I6_buf,I6);
buf b_I7 (I7_buf,I7);
buf b_S0 (S0_buf,S0);
buf b_S1 (S1_buf,S1);
buf b_S2 (S2_buf,S2);

`ifdef udp_input_ge_10
U_MUX_8_3 (Z,I0_buf,I1_buf,I2_buf,I3_buf,I4_buf,I5_buf,I6_buf,
                       I7_buf,S0_buf,S1_buf,S2_buf);
`else

s_mx08d4 g1_s_mx08d4_1(I0_buf,I1_buf,I2_buf,I3_buf,I4_buf,I5_buf,I6_buf,
                       I7_buf,S0_buf,S1_buf,S2_buf,Z);
                       
`endif

`ifdef functional
`else
specify
// Parameter declarations
 specparam i0_lh_z_lh=0,i0_hl_z_hl_1=0,s0_lh_z_lh=0,s0_hl_z_hl=0,
 s1_lh_z_lh=0,s1_hl_z_hl_1=0,s2_lh_z_lh=0,s2_hl_z_hl=0,i1_lh_z_lh=0,
 i1_hl_z_hl=0,i3_lh_z_lh=0,i3_hl_z_hl=0,i2_lh_z_lh=0,i2_hl_z_hl=0,
 i6_lh_z_lh=0,i6_hl_z_hl=0,i7_lh_z_lh=0,i7_hl_z_hl=0,i5_lh_z_lh=0,
 i5_hl_z_hl=0,i4_lh_z_lh=0,i4_hl_z_hl=0;
// Delays
 (        S0  => Z) = (s0_lh_z_lh,s0_hl_z_hl);
 (        S1  => Z) = (s1_lh_z_lh,s1_hl_z_hl_1);
 (        S2  => Z) = (s2_lh_z_lh,s2_hl_z_hl);
 (        I0 +=> Z) = (i0_lh_z_lh,i0_hl_z_hl_1);
 (        I1 +=> Z) = (i1_lh_z_lh,i1_hl_z_hl);
 (        I3 +=> Z) = (i3_lh_z_lh,i3_hl_z_hl);
 (        I2 +=> Z) = (i2_lh_z_lh,i2_hl_z_hl);
 (        I6 +=> Z) = (i6_lh_z_lh,i6_hl_z_hl);
 (        I7 +=> Z) = (i7_lh_z_lh,i7_hl_z_hl);
 (        I5 +=> Z) = (i5_lh_z_lh,i5_hl_z_hl);
 (        I4 +=> Z) = (i4_lh_z_lh,i4_hl_z_hl);
endspecify
`endif

endmodule
`endcelldefine
`disable_portfaults
`nosuppress_faults
`timescale 1ns / 1ps

`ifdef udp_input_ge_10
`else
module s_mx08d4 (I0,I1,I2,I3,I4,I5,I6,I7,S0,S1,S2,Z);

output    Z;
input     I0,I1,I2,I3,I4,I5,I6,I7,S0,S1,S2;
reg       reg_Z,xreg_Z,flag_Z;
buf #0.01 (Z,reg_Z);

always @ (S2 or S1 or S0 or I7 or I6 or I5 or I4 or I3 or I2 or I1 or 
          I0) begin
 if ((S2===0) && (S1===0) && (S0===0)) reg_Z=I0;
 else if ((S2===0) && (S1===0) && (S0===1)) reg_Z=I1;
 else if ((S2===0) && (S1===1) && (S0===1)) reg_Z=I3;
 else if ((S2===0) && (S1===1) && (S0===0)) reg_Z=I2;
 else if ((S2===1) && (S1===1) && (S0===0)) reg_Z=I6;
 else if ((S2===1) && (S1===1) && (S0===1)) reg_Z=I7;
 else if ((S2===1) && (S1===0) && (S0===1)) reg_Z=I5;
 else if ((S2===1) && (S1===0) && (S0===0)) reg_Z=I4;
 else if ((S2===1'bx) || (S1===1'bx) || (S0===1'bx)) begin
  flag_Z=1;
  if (((S2===0) || (S2===1'bx)) && ((S1===0) || (S1===1'bx)) && 
          ((S0===0) || (S0===1'bx))) begin
   xreg_Z=I0;
   flag_Z=0;
  end
  if (((S2===0) || (S2===1'bx)) && ((S1===0) || (S1===1'bx)) && 
          ((S0===1) || (S0===1'bx))) begin
   if (flag_Z) xreg_Z=I1;
   else if (xreg_Z!==I1) xreg_Z=1'bx;
   flag_Z=0;
  end
  if (((S2===0) || (S2===1'bx)) && ((S1===1) || (S1===1'bx)) && 
          ((S0===1) || (S0===1'bx))) begin
   if (flag_Z) xreg_Z=I3;
   else if (xreg_Z!==I3) xreg_Z=1'bx;
   flag_Z=0;
  end
  if (((S2===0) || (S2===1'bx)) && ((S1===1) || (S1===1'bx)) && 
          ((S0===0) || (S0===1'bx))) begin
   if (flag_Z) xreg_Z=I2;
   else if (xreg_Z!==I2) xreg_Z=1'bx;
   flag_Z=0;
  end
  if (((S2===1) || (S2===1'bx)) && ((S1===1) || (S1===1'bx)) && 
          ((S0===0) || (S0===1'bx))) begin
   if (flag_Z) xreg_Z=I6;
   else if (xreg_Z!==I6) xreg_Z=1'bx;
   flag_Z=0;
  end
  if (((S2===1) || (S2===1'bx)) && ((S1===1) || (S1===1'bx)) && 
          ((S0===1) || (S0===1'bx))) begin
   if (flag_Z) xreg_Z=I7;
   else if (xreg_Z!==I7) xreg_Z=1'bx;
   flag_Z=0;
  end
  if (((S2===1) || (S2===1'bx)) && ((S1===0) || (S1===1'bx)) && 
          ((S0===1) || (S0===1'bx))) begin
   if (flag_Z) xreg_Z=I5;
   else if (xreg_Z!==I5) xreg_Z=1'bx;
   flag_Z=0;
  end
  if (((S2===1) || (S2===1'bx)) && ((S1===0) || (S1===1'bx)) && 
          ((S0===0) || (S0===1'bx))) begin
   if (flag_Z) xreg_Z=I4;
   else if (xreg_Z!==I4) xreg_Z=1'bx;
   flag_Z=0;
  end
  reg_Z=xreg_Z;
 end
end

endmodule
`endif
