////////////////////////////////////////////////////////////////////
// Copyright (c) 2003 Synopsys, Inc.  All Rights Reserved       //
// This information is provided pursuant to a license agreement //
// that grants limited rights of access/use and requires that   //
// the information be treated as confidential.                  //
////////////////////////////////////////////////////////////////////

// ************* UDP For Synopsys Verilog Models ************ 
// **********************************************************

// Filename             : synopsys_UDP.v
// Library              : tsl18fs120
// Programmer           : ycui
// Date                 : 08-Oct-2003
// Product version      : Rev. main.1 
// Master version       : Rev. main.4


// V1.0   : Jul,2002   Initial Version Create by Haimin Hua
//                     Support to Tetra-MAX


primitive U_AO3 (CO, A, B, CI);

    input A, B, CI ;
    output CO;

// FUNCTION : CARRY GENERATOR TERM
 
  table
 
// A      B      CI :  CO
   
   1      1      ?  :  1;
   1      ?      1  :  1;
   ?      1      1  :  1;
 
   0      0      ?  :  0;
   0      ?      0  :  0;
   ?      0      0  :  0;

   endtable
endprimitive  

primitive U_ADDR2_C   (CO, A, B, CI);
    output CO;
    input A, B, CI;

// FUNCTION :  FULL ADDER CARRY OUT TERM

    table
    //  A   B   CI  :   CO
        1   1   ?   :   1 ;
        1   ?   1   :   1 ;
        ?   1   1   :   1 ;
        0   0   ?   :   0 ;
        0   ?   0   :   0 ;
        ?   0   0   :   0 ;

    endtable
endprimitive   

primitive U_ADDR2_S (S, A, B, CI);
    output S;
    input A, B, CI;

// FUNCTION :  FULL ADDER SUM TERM

    table
    //  A   B   CI  :   S
        0   0   0   :   0 ;
        0   0   1   :   1 ;
        0   1   0   :   1 ;
        0   1   1   :   0 ;
        1   0   0   :   1 ;
        1   0   1   :   0 ;
        1   1   0   :   0 ;
        1   1   1   :   1 ;

    endtable
endprimitive 

primitive U_FD_EN_P (Q,CP,EN,D);

    output Q;
    reg    Q;
    input  CP,EN,D;

//FUNCTION : Posedge Trigger D Flip-Flop with Buffered Enabled EN ( Q output) 

table
// CP  ENN   D  : - : Q;

   r     0   1  : ? : 1;
   r     0   0  : ? : 0;
   r     1   ?  : 0 : -;
   r     1   ?  : 1 : -;
   p     ?   1  : 1 : 1;
   p     ?   0  : 0 : 0;
   p     1   ?  : ? : -;
   n     ?   ?  : ? : -;
   ?     ?   *  : ? : -;
   ?     *   ?  : ? : -;

endtable
endprimitive

primitive U_FD_EN_P_NO (Q,CP,EN,D,NOT_REG);

    output Q;
    reg    Q;
    input  CP,EN,D,NOT_REG;

//FUNCTION : Posedge Trigger D Flip-Flop with Buffered Enabled EN ( Q output) 

table
// CP  ENN D  NOT_REG : - : Q;

   r     0   1    ?   : ? : 1;
   r     0   0    ?   : ? : 0;
   r     1   ?    ?   : 0 : -;
   r     1   ?    ?   : 1 : -;
   p     ?   1    ?   : 1 : 1;
   p     ?   0    ?   : 0 : 0;
   p     1   ?    ?   : ? : -;
   n     ?   ?    ?   : ? : -;
   ?     ?   *    ?   : ? : -;
   ?     *   ?    ?   : ? : -;
   ?     ?   ?    *   : ? : x;
endtable
endprimitive

primitive U_FD_EN_N_RB (Q,CPN,EN,RB,D);

   output Q;
   reg Q;
   input CPN,EN,RB,D;

//FUNCTION : Negedge trigger D Flip-Flop With Buffered Enabled and Clear, Q only

table
// CPN  EN    RB    D  : -  :  Q;

    ?    ?     0    ?  : ?  :  0;

    f    0     1    1  : ?  :  1;
    f    0     1    0  : ?  :  0;
    f    1     1    ?  : ?  :  -;

    f    ?     1    0  : 0  :  0;
    f    ?     1    1  : 1  :  1;
    f    ?     ?    0  : 0  :  0;
    f    0     x    0  : ?  :  0;
    f    1     x    ?  : 0  :  0;

  (1x)   0     1    1  : 1  :  1;
  (1x)   0     1    0  : 0  :  0;
  (1x)   1     1    ?  : ?  :  -;

  (1x)   x     1    0  : 0  :  0;
  (1x)   x     1    1  : 1  :  1;
  (1x)   x     x    0  : 0  :  0;
  (1x)   0     x    0  : 0  :  0;
  (1x)   1     x    ?  : 0  :  0;

    p    ?     1    ?  : ?  :  -;
    1    ?     x    ?  : 0  :  0;
    ?    ?    (?1)  ?  : ?  :  -;
    ?    *     1    ?  : ?  :  -;
    ?    ?     1    *  : ?  :  -;
    ?    *     x    0  : 0  :  0;
    ?    1     x    *  : 0  :  0;
    ?    ?    (?x)  ?  : 0  :  0;

endtable
endprimitive

primitive U_FD_EN_N_RB_NO (Q,CPN,EN,RB,D,NOT_REG);

   output Q;
   reg Q;
   input CPN,EN,RB,D,NOT_REG;

//FUNCTION : Negedge trigger D Flip-Flop With Buffered Enabled and Clear, Q only

table
// CPN  EN    RB    D  NOT_REG  : -  :  Q;

    ?    ?     0    ?    ?      : ?  :  0;

    f    0     1    1    ?      : ?  :  1;
    f    0     1    0    ?      : ?  :  0;
    f    1     1    ?    ?      : ?  :  -;

    f    ?     1    0    ?      : 0  :  0;
    f    ?     1    1    ?      : 1  :  1;
    f    ?     ?    0    ?      : 0  :  0;
    f    0     x    0    ?      : ?  :  0;
    f    1     x    ?    ?      : 0  :  0;

  (1x)   0     1    1    ?      : 1  :  1;
  (1x)   0     1    0    ?      : 0  :  0;
  (1x)   1     1    ?    ?      : ?  :  -;

  (1x)   x     1    0    ?      : 0  :  0;
  (1x)   x     1    1    ?      : 1  :  1;
  (1x)   x     x    0    ?      : 0  :  0;
  (1x)   0     x    0    ?      : 0  :  0;
  (1x)   1     x    ?    ?      : 0  :  0;
   
    p    ?     1    ?    ?      : ?  :  -;
    1    ?     x    ?    ?      : 0  :  0;
    ?    *     1    ?    ?      : ?  :  -;
    ?    ?     1    *    ?      : ?  :  -;
    ?    *     x    0    ?      : 0  :  0;
    ?    1     x    *    ?      : 0  :  0;
    ?    ?    (?1)  ?    ?      : ?  :  -;
    ?    ?    (?x)  ?    ?      : 0  :  0;

    ?    ?     ?    ?    *      : ?  :  x;
endtable
endprimitive

primitive U_FD_EN_P_RB (Q,CP,EN,RB,D);

   output Q;
   reg Q;
   input CP,EN,RB,D;

//FUNCTION : Posedge trigger D Flip-Flop With Buffered Enabled and Clear, Q only

table
// CP   EN    RB    D  : -  :  Q;

    ?    ?     0    ?  : ?  :  0;

    r    0     1    1  : ?  :  1;
    r    0     1    0  : ?  :  0;
    r    1     1    ?  : ?  :  -;

    r    ?     1    0  : 0  :  0;
    r    ?     1    1  : 1  :  1;
    r    ?     ?    0  : 0  :  0;
    r    0     x    0  : ?  :  0;
    r    1     x    ?  : 0  :  0;

  (0x)   0     1    1  : 1  :  1;
  (0x)   0     1    0  : 0  :  0;
  (0x)   1     1    ?  : ?  :  -;

  (0x)   x     1    0  : 0  :  0;
  (0x)   x     1    1  : 1  :  1;
  (0x)   x     x    0  : 0  :  0;
  (0x)   0     x    0  : 0  :  0;
  (0x)   1     x    ?  : 0  :  0;

    n    ?     1    ?  : ?  :  -;
    0    ?     x    ?  : 0  :  0;
    ?    ?    (?1)  ?  : ?  :  -;
    ?    *     1    ?  : ?  :  -;
    ?    ?     1    *  : ?  :  -;
    ?    *     x    0  : 0  :  0;
    ?    1     x    *  : 0  :  0;
    ?    ?    (?x)  ?  : 0  :  0;

endtable
endprimitive

primitive U_FD_EN_P_RB_NO (Q,CP,EN,RB,D,NOT_REG);

   output Q;
   reg Q;
   input CP,EN,RB,D,NOT_REG;

//FUNCTION : Posedge trigger D Flip-Flop With Buffered Enabled and Clear, Q only

table
// CP   EN    RB    D  NOT_REG  : -  :  Q;

    ?    ?     0    ?    ?      : ?  :  0;

    r    0     1    1    ?      : ?  :  1;
    r    0     1    0    ?      : ?  :  0;
    r    1     1    ?    ?      : ?  :  -;

    r    ?     1    0    ?      : 0  :  0;
    r    ?     1    1    ?      : 1  :  1;
    r    ?     ?    0    ?      : 0  :  0;
    r    0     x    0    ?      : ?  :  0;
    r    1     x    ?    ?      : 0  :  0;

  (0x)   0     1    1    ?      : 1  :  1;
  (0x)   0     1    0    ?      : 0  :  0;
  (0x)   1     1    ?    ?      : ?  :  -;

  (0x)   x     1    0    ?      : 0  :  0;
  (0x)   x     1    1    ?      : 1  :  1;
  (0x)   x     x    0    ?      : 0  :  0;
  (0x)   0     x    0    ?      : 0  :  0;
  (0x)   1     x    ?    ?      : 0  :  0;

    n    ?     1    ?    ?      : ?  :  -;
    0    ?     x    ?    ?      : 0  :  0;
    ?    *     1    ?    ?      : ?  :  -;
    ?    ?     1    *    ?      : ?  :  -;
    ?    *     x    0    ?      : 0  :  0;
    ?    1     x    *    ?      : 0  :  0;
    ?    ?    (?1)  ?    ?      : ?  :  -;
    ?    ?    (?x)  ?    ?      : 0  :  0;

    ?    ?     ?    ?    *      : ?  :  x;

endtable
endprimitive

primitive U_FD_EN_N_SB (Q,CPN,EN,SB,D);

   output Q;
   reg Q;
   input CPN,EN,SB,D;

//FUNCTION : Negedge trigger D Flip-Flop With Buffered Enabled and Set, Q only

table
// CPN  EN    SB    D  : -  :  Q;

    ?    ?     0    ?  : ?  :  1;

    f    0     1    1  : ?  :  1;
    f    0     1    0  : ?  :  0;
    f    1     1    ?  : ?  :  -;

    f    ?     1    0  : 0  :  0;
    f    ?     1    1  : 1  :  1;
    f    ?     ?    1  : 1  :  1;
    f    0     ?    1  : ?  :  1;
    f    1     x    ?  : 1  :  1;

  (1x)   0     1    1  : 1  :  1;
  (1x)   0     1    0  : 0  :  0;
  (1x)   1     1    ?  : ?  :  -;

  (1x)   x     1    0  : 0  :  0;
  (1x)   x     1    1  : 1  :  1;
  (1x)   x     x    1  : 1  :  1;
  (1x)   0     x    1  : 1  :  1;
  (1x)   1     x    ?  : 1  :  1;

    p    ?     1    ?  : ?  :  -;
    1    ?     x    ?  : 1  :  1;
    ?    ?    (?1)  ?  : ?  :  -;
    ?    *     1    ?  : ?  :  -;
    ?    ?     1    *  : ?  :  -;
    ?    *     x    1  : 1  :  1;
    ?    1     x    *  : 1  :  1;
    ?    ?    (?x)  ?  : 1  :  1;

endtable
endprimitive

primitive U_FD_EN_N_SB_NO (Q,CPN,EN,SB,D,NOT_REG);

   output Q;
   reg Q;
   input CPN,EN,SB,D,NOT_REG;

//FUNCTION : Negedge trigger D Flip-Flop With Buffered Enabled and Set, Q only

table
// CPN  EN    SB    D  NOT_REG  : -  :  Q;

    ?    ?     ?    ?    *      : ?  :  x;
    
    ?    ?     0    ?    ?      : ?  :  1;

    f    0     1    1    ?      : ?  :  1;
    f    0     1    0    ?      : ?  :  0;
    f    1     1    ?    ?      : ?  :  -;

    f    ?     1    0    ?      : 0  :  0;
    f    ?     1    1    ?      : 1  :  1;
    f    ?     ?    1    ?      : 1  :  1;
    f    0     ?    1    ?      : ?  :  1;
    f    1     x    ?    ?      : 1  :  1;

  (1x)   0     1    1    ?      : 1  :  1;
  (1x)   0     1    0    ?      : 0  :  0;
  (1x)   1     1    ?    ?      : ?  :  -;

  (1x)   x     1    0    ?      : 0  :  0;    
  (1x)   x     1    1    ?      : 1  :  1;
  (1x)   x     x    1    ?      : 1  :  1;
  (1x)   0     x    1    ?      : 1  :  1;
  (1x)   1     x    ?    ?      : 1  :  1;

    p    ?     1    ?    ?      : ?  :  -;
    1    ?     x    ?    ?      : 1  :  1;
    ?    *     1    ?    ?      : ?  :  -;
    ?    ?     1    *    ?      : ?  :  -;
    ?    ?    (?1)  ?    ?      : ?  :  -;
    ?    *     x    1    ?      : 1  :  1;
    ?    1     x    *    ?      : 1  :  1;
    ?    ?    (?x)  ?    ?      : 1  :  1;

endtable
endprimitive

primitive U_FD_EN_P_SB (Q,CP,EN,SB,D);

   output Q;
   reg Q;
   input CP,EN,SB,D;

//FUNCTION : Posedge trigger D Flip-Flop With Buffered Enabled and Set, Q only

table
// CP   EN    SB    D   : -  :  Q;

    ?    ?     0    ?  : ?  :  1;

    r    0     1    1  : ?  :  1;
    r    0     1    0  : ?  :  0;
    r    1     1    ?  : ?  :  -;

    r    ?     1    0  : 0  :  0;
    r    ?     1    1  : 1  :  1;
    r    ?     ?    1  : 1  :  1;
    r    0     ?    1  : ?  :  1;
    r    1     x    ?  : 1  :  1;

  (0x)   0     1    1  : 1  :  1;
  (0x)   0     1    0  : 0  :  0;
  (0x)   1     1    ?  : ?  :  -;

  (0x)   x     1    0  : 0  :  0;
  (0x)   x     1    1  : 1  :  1;
  (0x)   x     x    1  : 1  :  1;
  (0x)   0     x    1  : 1  :  1;
  (0x)   1     x    ?  : 1  :  1;

    n    ?     1    ?  : ?  :  -;
    0    ?     x    ?  : 1  :  1;
    ?    ?    (?1)  ?  : ?  :  -;
    ?    *     1    ?  : ?  :  -;
    ?    ?     1    *  : ?  :  -;
    ?    *     x    1  : 1  :  1;
    ?    1     x    *  : 1  :  1;
    ?    ?    (?x)  ?  : 1  :  1;

endtable
endprimitive

primitive U_FD_EN_P_SB_NO (Q,CP,EN,SB,D,NOT_REG);

   output Q;
   reg Q;
   input CP,EN,SB,D,NOT_REG;

//FUNCTION : Posedge trigger D Flip-Flop With Buffered Enabled and Set, Q only

table
// CP   EN    SB    D  NOT_REG  : -  :  Q;

    ?    ?     ?    ?    *      : ?  :  x;

    ?    ?     0    ?    ?      : ?  :  1;

    r    0     1    1    ?      : ?  :  1;
    r    0     1    0    ?      : ?  :  0;
    r    1     1    ?    ?      : ?  :  -;

    r    ?     1    0    ?      : 0  :  0;
    r    ?     1    1    ?      : 1  :  1;
    r    ?     ?    1    ?      : 1  :  1;
    r    0     ?    1    ?      : ?  :  1;
    r    1     x    ?    ?      : 1  :  1;

  (0x)   0     1    1    ?      : 1  :  1;
  (0x)   0     1    0    ?      : 0  :  0;
  (0x)   1     1    ?    ?      : ?  :  -;

  (0x)   x     1    0    ?      : 0  :  0;
  (0x)   x     1    1    ?      : 1  :  1;
  (0x)   x     x    1    ?      : 1  :  1;
  (0x)   0     x    1    ?      : 1  :  1;
  (0x)   1     x    ?    ?      : 1  :  1;

    n    ?     1    ?    ?      : ?  :  -;
    0    ?     x    ?    ?      : 1  :  1;
    ?    *     1    ?    ?      : ?  :  -;
    ?    ?     1    *    ?      : ?  :  -;
    ?    ?    (?1)  ?    ?      : ?  :  -;
    ?    *     x    1    ?      : 1  :  1;
    ?    1     x    *    ?      : 1  :  1;
    ?    ?    (?x)  ?    ?      : 1  :  1;

endtable
endprimitive

primitive U_FD_N  (Q, D, CP);

    output Q;  
    input  D, CP;
    reg    Q;  

// FUNCTION :  NEGATIVE EDGE TRIGGERED D FLIP-FLOP ( Q OUTPUT UDP ).

    table
 
    //  D   CP        :   Qt  :   Qt+1

        1   (10)      :   ?   :   1;  // clocked data
        0   (10)      :   ?   :   0;
                                                           
        1   (1x)      :   1   :   1;  // reducing pessimism
        0   (1x)      :   0   :   0;                          
        1   (x0)      :   1   :   1;  
        0   (x0)      :   0   :   0; 
        
        ?   (0x)      :   ?   :   -;  // no change on rising edge 
        ?   (?1)      :   ?   :   -;  

        *    ?        :   ?   :   -;  // ignore edges on data

    endtable
endprimitive

primitive U_FD_N_NO (Q, D, CP , NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP;
    reg    Q;  

// FUNCTION :  NEGATIVE EDGE TRIGGERED D FLIP-FLOP ( Q OUTPUT UDP ).


    table
 
    //  D   CP           NOTIFIER_REG  :   Qt  :   Qt+1

        1   (10)            ?          :   ?   :   1;  // clocked data
        0   (10)            ?          :   ?   :   0;
                                                           
        1   (1x)            ?          :   1   :   1;  // reducing pessimism
        0   (1x)            ?          :   0   :   0;                          
        1   (x0)            ?          :   1   :   1;  
        0   (x0)            ?          :   0   :   0; 
        
        ?   (0x)            ?          :   ?   :   -;  // no change on rising edge 
        ?   (?1)            ?          :   ?   :   -;  

        *    ?              ?          :   ?   :   -;  // ignore edges on data
        
        ?    ?              *          :   ?   :   x;
    endtable
endprimitive

primitive U_FD_N_RB_NO (Q, D, CP, RB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, RB;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR ( Q OUTPUT UDP ).


    table
 
    //  D   CP      RB     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (10)    1         ?          :   ?   :   1;  // clocked data
        0   (10)    1         ?          :   ?   :   0;

        0   (10)    x         ?          :   ?   :   0;  // pessimism
        0    ?      x         ?          :   0   :   0;  // pessimism

        1    1      x         ?          :   0   :   0;  // pessimism
        1    x    (?x)        ?          :   0   :   0;  // pessimism
        1    0    (?x)        ?          :   0   :   0;  // pessimism

        x    1      x         ?          :   0   :   0;  // pessimism
        x    x    (?x)        ?          :   0   :   0;  // pessimism
        x    0    (?x)        ?          :   0   :   0;  // pessimism

        1   (1x)    1         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    1         ?          :   0   :   0;                          
        0   (1x)    x         ?          :   0   :   0;                          
        1   (x0)    1         ?          :   1   :   1;  
        0   (x0)    1         ?          :   0   :   0;  


        ?   ?       0         ?          :   ?   :   0;  // asynchronous clear

        ?   (?1)    1         ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    1         ?          :   ?   :   -;  // ignore falling clock
        *    ?      1         ?          :   ?   :   -;  // ignore the edges on data

        ?    ?    (?1)        ?          :   ?   :   -;  // ignore the edges on clear 

        ?    ?      ?         *          :   ?   :   x;
 
    endtable
endprimitive

primitive U_FD_N_RB_SB  (Q, D, CP, RB, SB);

    output Q;  
    input  D, CP, RB, SB;
    reg    Q; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ( Q OUTPUT UDP ).

    table
 
    //  D    CP     RB  SB  :   Qt  :   Qt+1

        1   (10)    1   1   :   ?   :   1;  // clocked data
        1   (10)    1   x   :   ?   :   1;  // pessimism

        1    ?      1   x   :   1   :   1;  // pessimism

        0    1      1   x   :   1   :   1;  // pessimism
        0    x      1 (?x)  :   1   :   1;  // pessimism
        0    0      1 (?x)  :   1   :   1;  // pessimism

        x    1      1   x   :   1   :   1;  // pessimism
        x    x      1 (?x)  :   1   :   1;  // pessimism
        x    0      1 (?x)  :   1   :   1;  // pessimism


        0   (10)    1   1   :   ?   :   0;  // clocked data
        0   (10)    x   1   :   ?   :   0;  // pessimism

        0    ?      x   1   :   0   :   0;  // pessimism

        1    1      x   1   :   0   :   0;  // pessimism
        1    x    (?x)  1   :   0   :   0;  // pessimism
        1    0    (?x)  1   :   0   :   0;  // pessimism

        x    1      x   1   :   0   :   0;  // pessimism
        x    x    (?x)  1   :   0   :   0;  // pessimism
        x    0    (?x)  1   :   0   :   0;  // pessimism
                                                           
        1   (1x)    1   1   :   1   :   1;  // reducing pessimism
        0   (1x)    1   1   :   0   :   0;                          

        0   (1x)    x   1   :   0   :   0;                          
        1   (1x)    1   x   :   1   :   1;  // reducing pessimism

        1   (x0)    1   1   :   1   :   1;  
        0   (x0)    1   1   :   0   :   0;  

        ?    ?      0   ?   :   ?   :   0;  // asynchronous clear
        ?    ?      1   0   :   ?   :   1;  // asynchronous set

        ?   (?1)    1   1   :   ?   :   -;  // ignore rising clock
        ?   (0x)    1   1   :   ?   :   -;  // ignore rising clock
        *    ?      1   1   :   ?   :   -;  // ignore data edges 

        ?    ?     (?1) 1   :   ?   :   -;  // ignore the edges on 
        ?    ?      1  (?1) :   ?   :   -;  // set and clear                  

    endtable
endprimitive

primitive U_FD_N_R_S_NO_QN (QN, D, CP, R, S, NOTIFIER_REG); 

    output QN;  
    input  NOTIFIER_REG,
           D, CP, R, S;
    reg    QN; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE HIGH
//            ASYNCHRONOUS SET AND RESET.  ( QN OUTPUT UDP )
        

     table
 
    //  D   CP      R   S      NOTIFIER_REG  :   Qtn :   Qtn+1

        1   (10)    0   0         ?          :   ?   :   0;  // clocked data
        1   (10)    0   x         ?          :   ?   :   0;  // pessimism

        1    ?      0   x         ?          :   0   :   0;  // pessimism

        0    1      0   x         ?          :   0   :   0;  // pessimism
        0    x      0 (?x)        ?          :   0   :   0;  // pessimism
        0    0      0 (?x)        ?          :   0   :   0;  // pessimism

        x    1      0   x         ?          :   0   :   0;  // pessimism
        x    x      0 (?x)        ?          :   0   :   0;  // pessimism
        x    0      0 (?x)        ?          :   0   :   0;  // pessimism


        0   (10)    0   0         ?          :   ?   :   1;  // clocked data
        0   (10)    x   0         ?          :   ?   :   1;  // pessimism

        0    ?      x   0         ?          :   1   :   1;  // pessimism

        1    1      x   0         ?          :   1   :   1;  // pessimism
        1    x    (?x)  0         ?          :   1   :   1;  // pessimism
        1    0    (?x)  0         ?          :   1   :   1;  // pessimism

        x    1      x   0         ?          :   1   :   1;  // pessimism
        x    x    (?x)  0         ?          :   1   :   1;  // pessimism
        x    0    (?x)  0         ?          :   1   :   1;  // pessimism
                                                           
        ?   ?       1   0         ?          :   ?   :   1;  // asynchronous clear
        ?   ?       ?   1         ?          :   ?   :   0;  // asynchronous set

        ?   (?1)    0   0         ?          :   ?   :   -;  // ignore rising clock

        0   (1x)    0   0         ?          :   1   :   1;  
        1   (1x)    0   0         ?          :   0   :   0;  
        1   (1x)    0   x         ?          :   0   :   0;  
        0   (1x)    x   0         ?          :   1   :   1;  

        *    ?      0   0         ?          :   ?   :   -;  // ignore data edges 

        ?   ?     (?0)  0         ?          :   ?   :   -;  // ignore the edges on 
        ?   ?       0  (?0)       ?          :   ?   :   -;  // set and clear                  
        
        ?   ?       ?   ?         *          :   ?   :   x;

    endtable
endprimitive

primitive U_FD_N_RB_SB_NO  (Q, D, CP, RB, SB, NOTIFY_REG);

    output Q;  
    input  D, CP, RB, SB, NOTIFY_REG;
    reg    Q; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ( Q OUTPUT UDP ).

    table
 
    //  D    CP     RB  SB  NOTIFY_REG  :   Qt  :   Qt+1

        1   (10)    1   1      ?        :   ?   :   1;  // clocked data
        1   (10)    1   x      ?        :   ?   :   1;  // pessimism

        1    ?      1   x      ?        :   1   :   1;  // pessimism

        0    1      1   x      ?        :   1   :   1;  // pessimism
        0    x      1 (?x)     ?        :   1   :   1;  // pessimism
        0    0      1 (?x)     ?        :   1   :   1;  // pessimism

        x    1      1   x      ?        :   1   :   1;  // pessimism
        x    x      1 (?x)     ?        :   1   :   1;  // pessimism
        x    0      1 (?x)     ?        :   1   :   1;  // pessimism


        0   (10)    1   1      ?        :   ?   :   0;  // clocked data
        0   (10)    x   1      ?        :   ?   :   0;  // pessimism

        0    ?      x   1      ?        :   0   :   0;  // pessimism

        1    1      x   1      ?        :   0   :   0;  // pessimism
        1    x    (?x)  1      ?        :   0   :   0;  // pessimism
        1    0    (?x)  1      ?        :   0   :   0;  // pessimism

        x    1      x   1      ?        :   0   :   0;  // pessimism
        x    x    (?x)  1      ?        :   0   :   0;  // pessimism
        x    0    (?x)  1      ?        :   0   :   0;  // pessimism
                                                           
        1   (1x)    1   1      ?        :   1   :   1;  // reducing pessimism
        0   (1x)    1   1      ?        :   0   :   0;                          

        1   (1x)    1   x      ?        :   1   :   1;  // reducing pessimism
        0   (1x)    x   1      ?        :   0   :   0;                          

        1   (x0)    1   1      ?        :   1   :   1;  
        0   (x0)    1   1      ?        :   0   :   0;  

        ?    ?      0   ?      ?        :   ?   :   0;  // asynchronous clear
        ?    ?      1   0      ?        :   ?   :   1;  // asynchronous set

        ?   (?1)    1   1      ?        :   ?   :   -;  // ignore rising clock
        ?   (0x)    1   1      ?        :   ?   :   -;  // ignore rising clock
        *    ?      1   1      ?        :   ?   :   -;  // ignore data edges 

        ?    ?     (?1) 1      ?        :   ?   :   -;  // ignore the edges on 
        ?    ?      1  (?1)    ?        :   ?   :   -;  // set and clear                  
        ?    ?      ?   ?      *        :   ?   :   x;  

    endtable
endprimitive

primitive U_FD_N_RB_SB_QN (QN, D, CP, RB, SB);

    output QN;  
    input  D, CP, RB, SB;
    reg    QN; 

// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR .  ( QN OUTPUT UDP ).

    table
 
    //  D    CP     RB  SB  :   Qtn :   Qtn+1

        1   (10)    1   1   :   ?   :   0;  // clocked data
        1   (10)    1   x   :   ?   :   0;  // pessimism

        1    ?      1   x   :   0   :   0;  // pessimism

        0    1      1   x   :   0   :   0;  // pessimism
        0    x      1 (?x)  :   0   :   0;  // pessimism
        0    0      1 (?x)  :   0   :   0;  // pessimism

        x    1      1   x   :   0   :   0;  // pessimism
        x    x      1 (?x)  :   0   :   0;  // pessimism
        x    0      1 (?x)  :   0   :   0;  // pessimism


        0   (10)    1   1   :   ?   :   1;  // clocked data
        0   (10)    x   1   :   ?   :   1;  // pessimism

        0    ?      x   1   :   1   :   1;  // pessimism
                        
        1    1      x   1   :   1   :   1;  // pessimism
        1    x    (?x)  1   :   1   :   1;  // pessimism
        1    0    (?x)  1   :   1   :   1;  // pessimism
                        
        x    1      x   1   :   1   :   1;  // pessimism
        x    x    (?x)  1   :   1   :   1;  // pessimism
        x    0    (?x)  1   :   1   :   1;  // pessimism

        ?    ?      0   1   :   ?   :   1;  // asynchronous clear
        ?    ?      ?   0   :   ?   :   0;  // asynchronous set

        ?   (?1)    1   1   :   ?   :   -;  // ignore rising clock

        0   (1x)    1   1   :   1   :   1;  
        1   (1x)    1   1   :   0   :   0; 
        1   (1x)    1   x   :   0   :   0;
        0   (1x)    x   1   :   1   :   1;

        *    ?      1   1   :   ?   :   -;  // ignore data edges 

        ?    ?     (?1) 1   :   ?   :   -;  // ignore the edges on 
        ?    ?      1  (?1) :   ?   :   -;  // set and clear                  

    endtable
endprimitive

primitive U_FD_N_SB_NO (Q, D, CP, SB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, SB;
    reg    Q; 
    
// FUNCTION : NEGATIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET ( Q OUTPUT UDP )


    table
 
    //  D   CP      SB     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (10)    1         ?          :   ?   :   1;  // clocked data
        0   (10)    1         ?          :   ?   :   0;
        1   (10)    x         ?          :   ?   :   1;  // reducing pessimism
        1    ?      x         ?          :   1   :   1;  // pessimism

        0    1      x         ?          :   1   :   1;  // pessimism
        0    x    (?x)        ?          :   1   :   1;  // pessimism
        0    0    (?x)        ?          :   1   :   1;  // pessimism

        x    1      x         ?          :   1   :   1;  // pessimism
        x    x    (?x)        ?          :   1   :   1;  // pessimism
        x    0    (?x)        ?          :   1   :   1;  // pessimism

        1   (1x)    1         ?          :   1   :   1;  // reducing pessimism
        0   (1x)    1         ?          :   0   :   0;                          
        1   (1x)    x         ?          :   1   :   1;  // reducing pessimism

        1   (x0)    1         ?          :   1   :   1;  
        0   (x0)    1         ?          :   0   :   0;  

        ?    ?      0         ?          :   ?   :   1;  // asynchronous clear

        ?   (?1)    1         ?          :   ?   :   -;  // ignore falling clock
        ?   (0x)    1         ?          :   ?   :   -;  // ignore falling clock
        *    ?      1         ?          :   ?   :   -;  // ignore the data edges

        ?   ?     (?1)        ?          :   ?   :   -;  // ignore the edges on set
        
        ?   ?       ?         *          :   ?   :   x;

    endtable
endprimitive

primitive U_FD_P_RB  (Q, D, CP, RB);

    output Q;  
    input  D, CP, RB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR ( Q OUTPUT UDP ).

    table
 
    //  D   CP      RB  :   Qt  :   Qt+1

        1   (01)    1   :   ?   :   1;  // clocked data
        0   (01)    1   :   ?   :   0;

        0   (01)    x   :   ?   :   0;  // pessimism

        0    ?      x   :   0   :   0;  // pessimism
                       
        1    0      x   :   0   :   0;  // pessimism
        1    x    (?x)  :   0   :   0;  // pessimism
        1    1    (?x)  :   0   :   0;  // pessimism
                       
        x    0      x   :   0   :   0;  // pessimism
        x    x    (?x)  :   0   :   0;  // pessimism
        x    1    (?x)  :   0   :   0;  // pessimism

        1   (x1)    1   :   1   :   1;  // reducing pessimism
        0   (x1)    1   :   0   :   0;                          
        1   (0x)    1   :   1   :   1;  
        0   (0x)    1   :   0   :   0;  
        0   (0x)    x   :   0   :   0;  


        ?   ?       0   :   ?   :   0;  // asynchronous clear

        ?   (?0)    1   :   ?   :   -;  // ignore falling clock
        ?   (1x)    1   :   ?   :   -;  // ignore falling clock
        *    ?      1   :   ?   :   -;  // ignore the edges on data

        ?    ?    (?1)  :   ?   :   -;  // ignore the edges on clear 


    endtable
endprimitive

primitive U_FD_P_RB_NO (Q, D, CP, RB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, RB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS CLEAR ( Q OUTPUT UDP ).


    table
 
    //  D   CP      RB     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    1         ?          :   ?   :   1;  // clocked data
        0   (01)    1         ?          :   ?   :   0;

        0   (01)    x         ?          :   ?   :   0;  // pessimism

        0    ?      x         ?          :   0   :   0;  // pessimism

        1    0      x         ?          :   0   :   0;  // pessimism
        1    x    (?x)        ?          :   0   :   0;  // pessimism
        1    1    (?x)        ?          :   0   :   0;  // pessimism

        x    0      x         ?          :   0   :   0;  // pessimism
        x    x    (?x)        ?          :   0   :   0;  // pessimism
        x    1    (?x)        ?          :   0   :   0;  // pessimism

        1   (x1)    1         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    1         ?          :   0   :   0;                          
        1   (0x)    1         ?          :   1   :   1;  
        0   (0x)    1         ?          :   0   :   0;  
        0   (0x)    x         ?          :   0   :   0;  


        ?   ?       0         ?          :   ?   :   0;  // asynchronous clear

        ?   (?0)    1         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    1         ?          :   ?   :   -;  // ignore falling clock
        *    ?      1         ?          :   ?   :   -;  // ignore the edges on data

        ?    ?    (?1)        ?          :   ?   :   -;  // ignore the edges on clear 

        ?    ?      ?         *          :   ?   :   x;
 
    endtable
endprimitive

primitive U_FD_P_RB_SB  (Q, D, CP, RB, SB);

    output Q;  
    input  D, CP, RB, SB;
    reg    Q; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ( Q OUTPUT UDP ).

    table
 
    //  D   CP      RB  SB  :   Qt  :   Qt+1

        1   (01)    1   1   :   ?   :   1;  // clocked data
        1   (01)    1   x   :   ?   :   1;  // pessimism

        1    ?      1   x   :   1   :   1;  // pessimism

        0    0      1   x   :   1   :   1;  // pessimism
        0    x      1 (?x)  :   1   :   1;  // pessimism
        0    1      1 (?x)  :   1   :   1;  // pessimism

        x    0      1   x   :   1   :   1;  // pessimism
        x    x      1 (?x)  :   1   :   1;  // pessimism
        x    1      1 (?x)  :   1   :   1;  // pessimism

        0   (01)    1   1   :   ?   :   0;  // clocked data
        0   (01)    x   1   :   ?   :   0;  // pessimism
 
        0    ?      x   1   :   0   :   0;  // pessimism

        1    0      x   1   :   0   :   0;  // pessimism
        1    x    (?x)  1   :   0   :   0;  // pessimism
        1    1    (?x)  1   :   0   :   0;  // pessimism

        x    0      x   1   :   0   :   0;  // pessimism
        x    x    (?x)  1   :   0   :   0;  // pessimism
        x    1    (?x)  1   :   0   :   0;  // pessimism
                                                           
        ?   ?       0   ?   :   ?   :   0;  // asynchronous clear
        ?   ?       1   0   :   ?   :   1;  // asynchronous set

        ?   (?0)    1   1   :   ?   :   -;  // ignore falling clock
        1   (?x)    1   1   :   1   :   1;  
        0   (?x)    1   1   :   0   :   0;  
        1   (?x)    1   x   :   1   :   1;  
        0   (?x)    x   1   :   0   :   0;  
        *    ?      1   1   :   ?   :   -;  // ignore data edges 

        ?   ?     (?1)  1   :   ?   :   -;  // ignore the edges on 
        ?   ?       1  (?1) :   ?   :   -;  //       set and clear                  

    endtable
endprimitive

primitive U_FD_P_RB_SB_NO (Q, D, CP, RB, SB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, RB, SB;
    reg    Q; 

// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND CLEAR. ( Q OUTPUT UDP ).


    table
 
    //  D   CP      RB  SB     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    1   1         ?          :   ?   :   1;  // clocked data
        1   (01)    1   x         ?          :   ?   :   1;  // pessimism
 
        1    ?      1   x         ?          :   1   :   1;  // pessimism

        0    0      1   x         ?          :   1   :   1;  // pessimism
        0    x      1 (?x)        ?          :   1   :   1;  // pessimism
        0    1      1 (?x)        ?          :   1   :   1;  // pessimism

        x    0      1   x         ?          :   1   :   1;  // pessimism
        x    x      1 (?x)        ?          :   1   :   1;  // pessimism
        x    1      1 (?x)        ?          :   1   :   1;  // pessimism

        0   (01)    1   1         ?          :   ?   :   0;  // clocked data
        0   (01)    x   1         ?          :   ?   :   0;  // pessimism

        0    ?      x   1         ?          :   0   :   0;  // pessimism

        1    0      x   1         ?          :   0   :   0;  // pessimism
        1    x    (?x)  1         ?          :   0   :   0;  // pessimism
        1    1    (?x)  1         ?          :   0   :   0;  // pessimism

        x    0      x   1         ?          :   0   :   0;  // pessimism
        x    x    (?x)  1         ?          :   0   :   0;  // pessimism
        x    1    (?x)  1         ?          :   0   :   0;  // pessimism

        ?   ?       0   ?         ?          :   ?   :   0;  // asynchronous clear
        ?   ?       1   0         ?          :   ?   :   1;  // asynchronous set

        ?   (?0)    1   1         ?          :   ?   :   -;  // ignore falling clock

        1   (?x)    1   1         ?          :   1   :   1;  // ignore falling clock
        0   (?x)    1   1         ?          :   0   :   0;  // ignore falling clock
        1   (?x)    1   x         ?          :   1   :   1;  // ignore falling clock
        0   (?x)    x   1         ?          :   0   :   0;  // ignore falling clock

        *    ?      1   1         ?          :   ?   :   -;  // ignore data edges 

        ?   ?     (?1)  1         ?          :   ?   :   -;  // ignore the edges on 
        ?   ?       1  (?1)       ?          :   ?   :   -;  //       set and clear                  
       
        ?   ?       ?   ?         *          :   ?   :   x;


    endtable
endprimitive

primitive U_FD_P_SB (Q, D, CP, SB);

    output Q;  
    input  D, CP, SB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET ( Q OUTPUT UDP )

    table
 
    //  D   CP      SB  :   Qt  :   Qt+1

        1   (01)    1   :   ?   :   1;  // clocked data
        0   (01)    1   :   ?   :   0;
        1   (01)    x   :   ?   :   1;  // reducing pessimism

        1    ?      x   :   1   :   1;  // pessimism

        0    0      x   :   1   :   1;  // pessimism
        0    x    (?x)  :   1   :   1;  // pessimism
        0    1    (?x)  :   1   :   1;  // pessimism

        x    0      x   :   1   :   1;  // pessimism
        x    x    (?x)  :   1   :   1;  // pessimism
        x    1    (?x)  :   1   :   1;  // pessimism
                                                           
        1   (x1)    1   :   1   :   1;  // reducing pessimism
        0   (x1)    1   :   0   :   0;                          
        1   (0x)    1   :   1   :   1;  
        0   (0x)    1   :   0   :   0;  
        1   (0x)    x   :   1   :   1;  


        ?    ?      0   :   ?   :   1;  // asynchronous clear

        ?   (?0)    1   :   ?   :   -;  // ignore falling clock
        ?   (1x)    1   :   ?   :   -;  // ignore falling clock
        *    ?      1   :   ?   :   -;  // ignore the data edges

        ?   ?     (?1)  :   ?   :   -;  // ignore the edges on set

    endtable
endprimitive

primitive U_FD_P_SB_NO (Q, D, CP, SB, NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP, SB;
    reg    Q; 
    
// FUNCTION : POSITIVE EDGE TRIGGERED D FLIP-FLOP WITH ACTIVE LOW
//            ASYNCHRONOUS SET ( Q OUTPUT UDP )


    table
 
    //  D   CP      SB     NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)    1         ?          :   ?   :   1;  // clocked data
        0   (01)    1         ?          :   ?   :   0;
        1   (01)    x         ?          :   ?   :   1;  // reducing pessimism
        1    ?      x         ?          :   1   :   1;  // pessimism

        0    0      x         ?          :   1   :   1;  // pessimism
        0    x    (?x)        ?          :   1   :   1;  // pessimism
        0    1    (?x)        ?          :   1   :   1;  // pessimism

        x    0      x         ?          :   1   :   1;  // pessimism
        x    x    (?x)        ?          :   1   :   1;  // pessimism
        x    1    (?x)        ?          :   1   :   1;  // pessimism

        1   (x1)    1         ?          :   1   :   1;  // reducing pessimism
        0   (x1)    1         ?          :   0   :   0;                          
        1   (0x)    1         ?          :   1   :   1;  
        0   (0x)    1         ?          :   0   :   0;  
        1   (0x)    x         ?          :   1   :   1;  

        ?    ?      0         ?          :   ?   :   1;  // asynchronous clear

        ?   (?0)    1         ?          :   ?   :   -;  // ignore falling clock
        ?   (1x)    1         ?          :   ?   :   -;  // ignore falling clock
        *    ?      1         ?          :   ?   :   -;  // ignore the data edges

        ?   ?     (?1)        ?          :   ?   :   -;  // ignore the edges on set
        
        ?   ?       ?         *          :   ?   :   x;

    endtable
endprimitive

primitive U_FD_SC_EN_P (Q,CP,ENN,SC,D,SD);

   output Q;
   reg    Q;
   input  CP,ENN,SC,D,SD;

//FUNCTION : Muxed Scan D Flip-Flop With Enable, Q Only

table
// CP   ENN  SC   D   SD  : - : Q;

   r    ?    1    ?    1  : ? : 1;
   r    ?    1    ?    0  : ? : 0;
   r    0    0    1    ?  : ? : 1;
   r    0    0    0    ?  : ? : 0;
   r    x    0    0    ?  : 0 : -;
   r    x    0    1    ?  : 1 : -;
   r    0    x    0    0  : ? : 0;
   r    0    x    1    1  : ? : 1;
   r    1    x    ?    0  : 0 : -;
   r    1    x    ?    1  : 1 : -;
   r    x    x    0    0  : 0 : -;
   r    x    x    1    1  : 1 : -;

  (?x)  ?    0    0    ?  : 0 : 0;
  (?x)  ?    0    1    ?  : 1 : 1;
  (?x)  x    x    0    0  : 0 : 0;
  (?x)  x    x    1    1  : 1 : 1;
  (?x)  0    x    0    0  : 0 : 0;
  (?x)  0    x    1    1  : 1 : 1;
  (?x)  1    x    ?    1  : 1 : 1;
  (?x)  1    x    ?    0  : 0 : 0;
  (?x)  ?    1    ?    0  : 0 : 0;
  (?x)  ?    1    ?    1  : 1 : 1;

  (?0)  ?    ?    ?    ?  : ? : -;

   *    1    0    ?    ?  : ? : -;
   ?    *    ?    ?    ?  : ? : -;
   ?    ?    *    ?    ?  : ? : -;
   ?    ?    ?    *    ?  : ? : -;
   ?    ?    ?    ?    *  : ? : -;

endtable
endprimitive

primitive U_FD_SC_EN_P_NO (Q,CP,ENN,SC,D,SD,NOT_REG);

   output Q;
   reg    Q;
   input  CP,ENN,SC,D,SD,NOT_REG;

//FUNCTION : Muxed Scan D Flip-Flop With Enable, Q Only

table
// CP   ENN  SC   D   SD NOT_REG : - : Q;

   r    ?    1    ?    1    ?   : ? : 1;
   r    ?    1    ?    0    ?   : ? : 0;
   r    0    0    1    ?    ?   : ? : 1;
   r    0    0    0    ?    ?   : ? : 0;
   r    x    0    0    ?    ?   : 0 : -;
   r    x    0    1    ?    ?   : 1 : -;
   r    0    x    0    0    ?   : ? : 0;
   r    0    x    1    1    ?   : ? : 1;
   r    1    x    ?    0    ?   : 0 : -;
   r    1    x    ?    1    ?   : 1 : -;
   r    x    x    0    0    ?   : 0 : -;
   r    x    x    1    1    ?   : 1 : -;

  (?x)  ?    0    0    ?    ?   : 0 : 0;
  (?x)  ?    0    1    ?    ?   : 1 : 1;
  (?x)  x    x    0    0    ?   : 0 : 0;
  (?x)  x    x    1    1    ?   : 1 : 1;
  (?x)  0    x    0    0    ?   : 0 : 0;
  (?x)  0    x    1    1    ?   : 1 : 1;
  (?x)  1    x    ?    1    ?   : 1 : 1;
  (?x)  1    x    ?    0    ?   : 0 : 0;
  (?x)  ?    1    ?    0    ?   : 0 : 0;
  (?x)  ?    1    ?    1    ?   : 1 : 1;

  (?0)  ?    ?    ?    ?    ?   : ? : -;

   *    1    0    ?    ?    ?   : ? : -;
   ?    *    ?    ?    ?    ?   : ? : -;
   ?    ?    *    ?    ?    ?   : ? : -;
   ?    ?    ?    *    ?    ?   : ? : -;
   ?    ?    ?    ?    *    ?   : ? : -;

   ?    ?    ?    ?    ?    *   : ? : x;

endtable
endprimitive

primitive U_FD_SC_EN_P_RB (Q,CP,ENN,SC,CDN,D,SD);

   output Q;
   reg    Q;
   input  CP,ENN,SC,CDN,D,SD;

//FUNCTION : Muxed Scan D Flip-Flop with Clear and Enable,Q only

table
// CP   ENN  SC   CDN  D   SD  : - : Q;

   ?    ?    ?    0    ?    ?  : ? : 0;

   r    ?    1    1    ?    0  : ? : 0;
   r    ?    1    1    ?    1  : ? : 1;
   r    0    0    1    0    ?  : ? : 0;
   r    0    0    1    1    ?  : ? : 1;
   r    ?    0    ?    0    ?  : 0 : -;
   r    ?    0    1    1    ?  : 1 : -;

   r    0    x    1    0    0  : ? : 0;
   r    0    x    1    1    1  : ? : 1;
   r    1    x    1    ?    0  : 0 : -;
   r    1    x    1    ?    1  : 1 : -;
   r    ?    1    x    ?    0  : ? : 0;
   r    0    0    x    0    ?  : ? : 0;
   r    1    0    x    ?    ?  : 0 : 0;
   r    0    x    x    0    0  : ? : 0;
   r    1    x    x    ?    0  : 0 : 0;
   r    ?    ?    ?    0    0  : 0 : 0;
   r    ?    ?    1    1    1  : 1 : 1;

  (?x)  ?    1    1    ?    0  : 0 : 0;
  (?x)  ?    1    1    ?    1  : 1 : 1;
  (?x)  ?    0    ?    0    ?  : 0 : -;
  (?x)  ?    0    1    1    ?  : 1 : -;

  (?x)  0    x    1    0    0  : 0 : 0;
  (?x)  0    x    1    1    1  : 1 : 1;
  (?x)  1    x    1    ?    0  : 0 : -;
  (?x)  1    x    1    ?    1  : 1 : -;
  (?x)  x    x    ?    0    0  : 0 : 0;
  (?x)  ?    ?    1    1    1  : 1 : 1;
  (?x)  1    0    x    ?    ?  : 0 : 0;
  (?x)  ?    1    x    ?    0  : 0 : 0;
  (?x)  0    x    x    0    0  : 0 : 0;
  (?x)  1    x    x    ?    0  : 0 : 0;

   0    ?    ?    x    ?    ?  : 0 : 0;
   ?    ?    ?   (?x)  ?    ?  : 0 : 0;

   n    ?    ?    1    ?    ?  : ? : -;

   *    1    0    1    ?    ?  : ? : -;
   ?    *    ?    1    ?    ?  : ? : -;
   ?    *    0    x    0    ?  : 0 : 0;
   ?    *    1    x    ?    0  : 0 : 0;
   ?    *    x    x    0    0  : 0 : 0;
   ?    ?    *    1    ?    ?  : ? : -;
   ?    ?    *    x    0    0  : 0 : 0;
   ?    1    *    x    ?    0  : 0 : 0;
   ?    ?    ?   (?1)  ?    ?  : ? : -;
   ?    ?    ?    1    *    ?  : ? : -;
   ?    1    ?    x    *    ?  : 0 : 0;
   ?    ?    ?    1    ?    *  : ? : -;
   ?    ?    0    x    ?    *  : 0 : 0;

endtable
endprimitive

primitive U_FD_SC_EN_P_RB_NO (Q,CP,ENN,SC,CDN,D,SD,NOT_REG);

   output Q;
   reg    Q;
   input  CP,ENN,SC,CDN,D,SD,NOT_REG;

//FUNCTION : Muxed Scan D Flip-Flop with Clear and Enable,Q only

table
// CP   ENN  SC   CDN  D   SD NOT_REG : - : Q;

   ?    ?    ?    0    ?    ?    ?   : ? : 0;

   r    ?    1    1    ?    0    ?   : ? : 0;
   r    ?    1    1    ?    1    ?   : ? : 1;
   r    0    0    1    0    ?    ?   : ? : 0;
   r    0    0    1    1    ?    ?   : ? : 1;
   r    ?    0    ?    0    ?    ?   : 0 : -;
   r    ?    0    1    1    ?    ?   : 1 : -;

   r    0    x    1    0    0    ?   : ? : 0;
   r    0    x    1    1    1    ?   : ? : 1;
   r    1    x    1    ?    0    ?   : 0 : -;
   r    1    x    1    ?    1    ?   : 1 : -;
   r    ?    1    x    ?    0    ?   : ? : 0;
   r    0    0    x    0    ?    ?   : ? : 0;
   r    1    0    x    ?    ?    ?   : 0 : 0;
   r    0    x    x    0    0    ?   : ? : 0;
   r    1    x    x    ?    0    ?   : 0 : 0;
   r    ?    ?    ?    0    0    ?   : 0 : 0;
   r    ?    ?    1    1    1    ?   : 1 : 1;

  (?x)  ?    1    1    ?    0    ?   : 0 : 0;
  (?x)  ?    1    1    ?    1    ?   : 1 : 1;
  (?x)  ?    0    ?    0    ?    ?   : 0 : -;
  (?x)  ?    0    1    1    ?    ?   : 1 : -;

  (?x)  0    x    1    0    0    ?   : 0 : 0;
  (?x)  0    x    1    1    1    ?   : 1 : 1;
  (?x)  1    x    1    ?    0    ?   : 0 : -;
  (?x)  1    x    1    ?    1    ?   : 1 : -;
  (?x)  x    x    ?    0    0    ?   : 0 : 0;
  (?x)  ?    ?    1    1    1    ?   : 1 : 1;
  (?x)  1    0    x    ?    ?    ?   : 0 : 0;
  (?x)  ?    1    x    ?    0    ?   : 0 : 0;
  (?x)  0    x    x    0    0    ?   : 0 : 0;
  (?x)  1    x    x    ?    0    ?   : 0 : 0;

   0    ?    ?    x    ?    ?    ?   : 0 : 0;
   ?    ?    ?   (?x)  ?    ?    ?   : 0 : 0;

   n    ?    ?    1    ?    ?    ?   : ? : -;

   *    1    0    1    ?    ?    ?   : ? : -;
   ?    *    ?    1    ?    ?    ?   : ? : -;
   ?    *    0    x    0    ?    ?   : 0 : 0;
   ?    *    1    x    ?    0    ?   : 0 : 0;
   ?    *    x    x    0    0    ?   : 0 : 0;
   ?    ?    *    1    ?    ?    ?   : ? : -;
   ?    ?    *    x    0    0    ?   : 0 : 0;
   ?    1    *    x    ?    0    ?   : 0 : 0;
   ?    ?    ?   (?1)  ?    ?    ?   : ? : -;
   ?    ?    ?    1    *    ?    ?   : ? : -;
   ?    1    ?    x    *    ?    ?   : 0 : 0;
   ?    ?    ?    1    ?    *    ?   : ? : -;
   ?    ?    0    x    ?    *    ?   : 0 : 0;

   ?    ?    ?    ?    ?    ?    *   : ? : x;

endtable
endprimitive

primitive U_FD_SC_EN_P_SB (Q,CP,ENN,SC,SDN,D,SD);

   output Q;
   reg    Q;
   input  CP,ENN,SC,SDN,D,SD;

//FUNCTION : Muxed Scan D Flip-Flop with Set and Enable,Q only

table
// CP   ENN  SC   SDN  D   SD  : - : Q;

   ?    ?    ?    0    ?    ?  : ? : 1;

   r    ?    1    1    ?    0  : ? : 0;
   r    ?    1    1    ?    1  : ? : 1;
   r    0    0    1    0    ?  : ? : 0;
   r    0    0    1    1    ?  : ? : 1;
   r    ?    0    ?    1    ?  : 1 : -;
   r    ?    0    1    0    ?  : 0 : -;

   r    0    x    1    0    0  : ? : 0;
   r    0    x    1    1    1  : ? : 1;
   r    1    x    1    ?    0  : 0 : -;
   r    1    x    1    ?    1  : 1 : -;
   r    ?    1    x    ?    1  : ? : 1;
   r    0    0    x    1    ?  : ? : 1;
   r    1    0    x    ?    ?  : 1 : 1;
   r    0    x    x    1    1  : ? : 1;
   r    1    x    x    ?    1  : 1 : 1;
   r    ?    ?    ?    1    1  : 1 : 1;
   r    ?    ?    1    0    0  : 0 : 0;

  (?x)  ?    1    1    ?    0  : 0 : 0;
  (?x)  ?    1    1    ?    1  : 1 : 1;
  (?x)  ?    0    ?    1    ?  : 1 : -;
  (?x)  ?    0    1    0    ?  : 0 : -;

  (?x)  0    x    1    0    0  : 0 : 0;
  (?x)  0    x    1    1    1  : 1 : 1;
  (?x)  1    x    1    ?    0  : 0 : -;
  (?x)  1    x    1    ?    1  : 1 : -;
  (?x)  x    x    ?    1    1  : 1 : 1;
  (?x)  ?    ?    1    0    0  : 0 : 0;
  (?x)  1    0    x    ?    ?  : 1 : 1;
  (?x)  ?    1    x    ?    1  : 1 : 1;
  (?x)  0    x    x    1    1  : 1 : 1;
  (?x)  1    x    x    ?    1  : 1 : 1;

   0    ?    ?    x    ?    ?  : 1 : 1;
   ?    ?    ?   (?x)  ?    ?  : 1 : 1;

   n    ?    ?    1    ?    ?  : ? : -;

   *    1    0    1    ?    ?  : ? : -;
   ?    *    ?    1    ?    ?  : ? : -;
   ?    *    0    x    1    ?  : 1 : 1;
   ?    *    1    x    ?    1  : 1 : 1;
   ?    *    x    x    1    1  : 1 : 1;
   ?    ?    *    1    ?    ?  : ? : -;
   ?    ?    *    x    1    1  : 1 : 1;
   ?    1    *    x    ?    1  : 1 : 1;
   ?    ?    ?   (?1)  ?    ?  : ? : -;
   ?    ?    ?    1    *    ?  : ? : -;
   ?    1    ?    x    *    ?  : 1 : 1;
   ?    ?    ?    1    ?    *  : ? : -;
   ?    ?    0    x    ?    *  : 1 : 1;

endtable
endprimitive

primitive U_FD_SC_EN_P_SB_NO (Q,CP,ENN,SC,SDN,D,SD,NOT_REG);

   output Q;
   reg    Q;
   input  CP,ENN,SC,SDN,D,SD,NOT_REG;

//FUNCTION : Muxed Scan D Flip-Flop with Set and Enable,Q only

table
// CP   ENN  SC   SDN  D   SD NOT_REG : - : Q;

   ?    ?    ?    0    ?    ?    ?   : ? : 1;

   r    ?    1    1    ?    0    ?   : ? : 0;
   r    ?    1    1    ?    1    ?   : ? : 1;
   r    0    0    1    0    ?    ?   : ? : 0;
   r    0    0    1    1    ?    ?   : ? : 1;
   r    ?    0    ?    1    ?    ?   : 1 : -;
   r    ?    0    1    0    ?    ?   : 0 : -;

   r    0    x    1    0    0    ?   : ? : 0;
   r    0    x    1    1    1    ?   : ? : 1;
   r    1    x    1    ?    0    ?   : 0 : -;
   r    1    x    1    ?    1    ?   : 1 : -;
   r    ?    1    x    ?    1    ?   : ? : 1;
   r    0    0    x    1    ?    ?   : ? : 1;
   r    1    0    x    ?    ?    ?   : 1 : 1;
   r    0    x    x    1    1    ?   : ? : 1;
   r    1    x    x    ?    1    ?   : 1 : 1;
   r    ?    ?    ?    1    1    ?   : 1 : 1;
   r    ?    ?    1    0    0    ?   : 0 : 0;

  (?x)  ?    1    1    ?    0    ?   : 0 : 0;
  (?x)  ?    1    1    ?    1    ?   : 1 : 1;
  (?x)  ?    0    ?    1    ?    ?   : 1 : -;
  (?x)  ?    0    1    0    ?    ?   : 0 : -;

  (?x)  0    x    1    0    0    ?   : 0 : 0;
  (?x)  0    x    1    1    1    ?   : 1 : 1;
  (?x)  1    x    1    ?    0    ?   : 0 : -;
  (?x)  1    x    1    ?    1    ?   : 1 : -;
  (?x)  x    x    ?    1    1    ?   : 1 : 1;
  (?x)  ?    ?    1    0    0    ?   : 0 : 0;
  (?x)  1    0    x    ?    ?    ?   : 1 : 1;
  (?x)  ?    1    x    ?    1    ?   : 1 : 1;
  (?x)  0    x    x    1    1    ?   : 1 : 1;
  (?x)  1    x    x    ?    1    ?   : 1 : 1;

   0    ?    ?    x    ?    ?    ?   : 1 : 1;
   ?    ?    ?   (?x)  ?    ?    ?   : 1 : 1;

   n    ?    ?    1    ?    ?    ?   : ? : -;

   *    1    0    1    ?    ?    ?   : ? : -;
   ?    *    ?    1    ?    ?    ?   : ? : -;
   ?    *    0    x    1    ?    ?   : 1 : 1;
   ?    *    1    x    ?    1    ?   : 1 : 1;
   ?    *    x    x    1    1    ?   : 1 : 1;
   ?    ?    *    1    ?    ?    ?   : ? : -;
   ?    ?    *    x    1    1    ?   : 1 : 1;
   ?    1    *    x    ?    1    ?   : 1 : 1;
   ?    ?    ?   (?1)  ?    ?    ?   : ? : -;
   ?    ?    ?    1    *    ?    ?   : ? : -;
   ?    1    ?    x    *    ?    ?   : 1 : 1;
   ?    ?    ?    1    ?    *    ?   : ? : -;
   ?    ?    0    x    ?    *    ?   : 1 : 1;

   ?    ?    ?    ?    ?    ?    *   : ? : x;

endtable
endprimitive

primitive U_LD_N (Q, D, GN); 

//
// FUNCTION :  D-LATCH, GATED  ACTIVE LOW / STANDARD DRIVE ( Q OUTPUT UDP )
//

    output Q; 
    reg    Q;                               
    input  D, 
           GN;       // Gate- active low

    table
     //  D     GN    : Qt  :   Qt+1

         ?      1    :  ?  :    -   ;   //clock disabled

         0      0    :  ?  :    0   ;  //clock enabled transparent
         1      0    :  ?  :    1   ;  //data

         1      x    :  1  :    1   ;  //reducing pessimism
         0      x    :  0  :    0   ; 
         
   endtable
endprimitive

primitive U_LD_N_NO (Q, D, GN, NOTI_REG); 

    output Q; 
    reg    Q;                               
    input  D,                // data
           GN,                // clock
           NOTI_REG;         // NOTIFY_REG
// FUNCTION :  D-LATCH, GATED  ACTIVE LOW / STANDARD DRIVE ( Q OUTPUT UDP )
//


   table
     //  D       GN    NOTI_REG        : Qt  :   Qt+1

         ?      (?1)    ?             :  ?  :    -   ;

         *       1      ?             :  ?  :    -   ;

       (?0)      0      ?             :  ?  :    0   ;
       (?1)      0      ?             :  ?  :    1   ; 
        0       (10)    ?             :  ?  :    0   ;
        1       (10)    ?             :  ?  :    1   ; 

         1      x      ?             :  1  :    1   ;    // Reducing pessimism.
         0      x      ?             :  0  :    0   ; 

         0      (1x)    ?             :  0  :    0   ;   // Reducing pessimism.
         1      (1x)    ?             :  1  :    1   ;
         0      (x0)    ?             :  ?  :    0   ;
         1      (x0)    ?             :  ?  :    1   ;
         
         ?       ?      *             :  ?  :    x   ;

   endtable
endprimitive

primitive U_FD_P  (Q, D, CP);

    output Q;  
    input  D, CP;
    reg    Q;  

// FUNCTION :  POSITIVE EDGE TRIGGERED D FLIP-FLOP ( Q OUTPUT UDP ).

    table
 
    //  D   CP        :   Qt  :   Qt+1

        1   (01)      :   ?   :   1;  // clocked data
        0   (01)      :   ?   :   0;
                                                           
        1   (x1)      :   1   :   1;  // reducing pessimism
        0   (x1)      :   0   :   0;                          
        1   (0x)      :   1   :   1;  
        0   (0x)      :   0   :   0; 
        
        ?   (1x)      :   ?   :   -;  // no change on falling edge 
        ?   (?0)      :   ?   :   -;  

        *    ?        :   ?   :   -;  // ignore edges on data

    endtable
endprimitive

primitive U_FD_P_NO (Q, D, CP , NOTIFIER_REG); 

    output Q;  
    input  NOTIFIER_REG,
           D, CP;
    reg    Q;  

// FUNCTION :  POSITIVE EDGE TRIGGERED D FLIP-FLOP ( Q OUTPUT UDP ).


    table
 
    //  D   CP           NOTIFIER_REG  :   Qt  :   Qt+1

        1   (01)            ?          :   ?   :   1;  // clocked data
        0   (01)            ?          :   ?   :   0;
                                                           
        1   (x1)            ?          :   1   :   1;  // reducing pessimism
        0   (x1)            ?          :   0   :   0;                          
        1   (0x)            ?          :   1   :   1;  
        0   (0x)            ?          :   0   :   0; 
        
        ?   (1x)            ?          :   ?   :   -;  // no change on falling edge 
        ?   (?0)            ?          :   ?   :   -;  

        *    ?              ?          :   ?   :   -;  // ignore edges on data
        
        ?    ?              *          :   ?   :   x;
    endtable
endprimitive

primitive U_LD_N_RB (Q, D, GN, RB); 

//
// FUNCTION : D-LATCH, CLEAR DIRECT( ACTIVE LOW ), GATE ACTIVE LOW 
//             STANDARD DRIVE ( Q OUTPUT UDP )


    output Q; 
    reg    Q;                               
    input  D,
           GN,                                      // Gate- active low
           RB;                                      // Clear- active low

    table
     //  D     GN      RB      : Qt  :   Qt+1
   
         ?      1      1       :  ?  :    -   ;     // latch state

         0      0      1       :  ?  :    0   ;     // latch data
         1      0      1       :  ?  :    1   ;            

         1      x      1       :  1  :    1   ;     // Reducing pessimism.
         0      x      1       :  0  :    0   ;     // Reducing pessimism.

         ?      ?      0       :  ?  :    0   ;    // clear    
     
         ?      1      x       :  0  :    0   ;      // Reducing pessimism.
         0      0      x       :  ?  :    0   ;      // Reducing pessimism.
         0      ?      x       :  0  :    0   ;      // Reducing pessimism.

    endtable
endprimitive

primitive U_LD_P (Q, D, G); 

//
// FUNCTION : DLATCH, GATED  STANDARD DRIVE / ACTIVE HIGH ( Q OUTPUT UDP )
//

    output Q; 
    reg    Q;                               
    input  D, G;

   table
     //  D      G    : Qt  :   Qt+1

         ?      0    :  ?  :    -   ;    // clock disabled   

         0      1    :  ?  :    0   ;  //clock enabled 
         1      1    :  ?  :    1   ;  //transparent data 

         1      x    :  1  :    1   ;  // Reducing pessimism.
         0      x    :  0  :    0   ; 
                                       
   endtable
endprimitive

primitive U_LD_P_NO (Q, D, G, NOTI_REG); 

    output Q; 
    reg    Q;                               
    input  D,              // data
           G,              // clock
           NOTI_REG;       
// FUNCTION : DLATCH, GATED  STANDARD DRIVE / ACTIVE HIGH ( Q OUTPUT UDP )
//

   table
     //  D       G    NOTI_REG        : Qtn :   Qtn+1

         *       0      ?             :  ?  :    -   ;
         ?      (?0)    ?             :  ?  :    -   ;
	 0      (0x)    ?             :  0  :    0   ;
         1      (0x)    ?             :  1  :    1   ;
         0      (x1)    ?             :  ?  :    0   ;
         1      (x1)    ?             :  ?  :    1   ;
        (?0)     1      ?             :  ?  :    0   ;
        (?1)     1      ?             :  ?  :    1   ; 
         0      (01)    ?             :  ?  :    0   ;
         1      (01)    ?             :  ?  :    1   ; 
         1      x      ?             :  1  :    1   ;    // Reducing pessimism.
         0      x      ?             :  0  :    0   ; 
         
         ?       ?      *             :  ?  :    x   ;

   endtable
endprimitive

primitive U_LD_P_RB (Q, D, G, RB); 

//
// FUNCTION : D-LATCH, GATED  CLEAR DIRECT /GATE ACTIVE HIGH ( Q OUTPUT UDP ) 
//

    output Q; 
    reg    Q;                               
    input  D,
           G,                                       // Gate- active high
           RB;                                      // Clear-active low

    table
     //  D      G     RB       : Qt  :   Qt+1

         ?      0      1       :  ?  :    -   ;     // latch state 

         0      1      1       :  ?  :    0   ;     // latch data
         1      1      1       :  ?  :    1   ;            

         1      x      1       :  1  :    1   ;     // Reducing pessimism.
         0      x      1       :  0  :    0   ;     // Reducing pessimism
       
         ?      ?      0       :  ?  :    0   ;      // Clear

         0      1      x       :  ?  :    0   ;      // Reducing pessimism.
         0      ?      x       :  0  :    0   ;      // Reducing pessimism.
         
         ?      0      x       :  0  :    0   ;      // Reducing pessimism 
   
      endtable
endprimitive

primitive U_LD_P_RB_NO (Q, D, G, RB, NOTI_REG); 

    output Q; 
    reg    Q;                               
    input  D,               // DATA
           G,               // CLOCK
           RB,              // CLEAR ACTIVE LOW
           NOTI_REG;        // NOTIFY REG
// FUNCTION : D-LATCH, GATED  CLEAR DIRECT /GATE ACTIVE HIGH ( Q OUTPUT UDP ) 
//

   table
     //  D       G      RB    NOTI_REG       : Qt  :   Qt+1

         *       0      1      ?             :  ?  :    -   ;

         ?       ?      0      ?             :  ?  :    0   ; // asynchro clear

         ?      (?0)    1      ?             :  ?  :    -   ; //AB

         0      (0x)    1      ?             :  0  :    0   ;
         1      (0x)    1      ?             :  1  :    1   ;
         0      (x1)    1      ?             :  ?  :    0   ;
         1      (x1)    1      ?             :  ?  :    1   ;

        (?0)     1      1      ?             :  ?  :    0   ;
        (?1)     1      1      ?             :  ?  :    1   ; 
         0      (01)    1      ?             :  ?  :    0   ;
         1      (01)    1      ?             :  ?  :    1   ; 

         ?       0      x      ?             :  0  :    0   ;   // Reducing pessimism.//AB

        (?0)     x      x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       x      *      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0      (0x)    x      ?             :  0  :    0   ;   // Reducing pessimism.//AB
         
         0      (?1)    x      ?             :  ?  :    0   ;   // Reducing pessimism.
        (?0)     1      x      ?             :  ?  :    0   ;   // Reducing pessimism.
         0       1     (?x)    ?             :  ?  :    0   ;   // Reducing pessimism.//AB

         ?       0     (?1)    ?             :  ?  :    -   ;   // ignore edge on clear
         0       1     (?1)    ?             :  ?  :    0   ;   // pessimism .
         1       1     (?1)    ?             :  ?  :    1   ;  

         1       x      1      ?             :  1  :    1   ;   // Reducing pessimism.
         0       x      1      ?             :  0  :    0   ;   // Reducing pessimism.
         
         ?       ?      ?      *             :  ?  :    x   ;

   endtable
endprimitive

primitive U_LD_P_SB_RB ( Q, D, CK, RB, SB );

   output Q; 
   reg    Q;
   input  D,  CK, RB, SB;

// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET ( Q OUTPUT UDP ).

table
    //  D   CK  RB  SB  :   Qt  :   Qt+1

        1   1   1   1   :   ?   :   1;  // clock enabled transparent data.
        0   1   1   1   :   ?   :   0;

        1   x   1   1   :   1   :   1;  // possible enabled clock.
        0   x   1   1   :   0   :   0;

        ?   ?   0   1   :   ?   :   0;  // asynchronous reset.
        ?   ?   ?   0   :   ?   :   1;  // asynchronous set override.

        ?   0   1   1   :   ?   :   -;  // clock disabled.

        0   1   x   1   :   ?   :   0;  // pessimism 
        0   ?   x   1   :   0   :   0;  // pessimism 
        1   1   1   x   :   ?   :   1;  // pessimism 
        1   ?   1   x   :   1   :   1;  // pessimism                       

        ?   0   x   1   :   0  :    0;  // set inactive                    
        ?   0   1   x   :   1  :    1;  // reset inactive    
  
   endtable  
endprimitive

primitive U_LD_P_SB_RB_NO (Q, D, G, RB, SB, NOTI_REG); 

    output Q; 
    reg    Q;                               
    input  D,               // DATA
           G,               // CLOCK
           RB,              // CLEAR ACTIVE LOW
           SB,              // SET ACTIVE LOW
           NOTI_REG;        // NOTIFY_REG
// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET.  ( Q OUTPUT UDP ).


   table
     //  D       G      RB    SB   NOTI_REG       : Qt  :   Qt+1
                                  

         *       0      1     1     ?             :  ?  :    -   ;

         ?       ?      0     1     ?             :  ?  :    0   ; // asynchro clear
         ?       ?      ?     0     ?             :  ?  :    1   ; // asynch set
                                                                    // occurs 
         ?      (?0)    1     1     ?             :  ?  :    -   ;  //AB

         0       x      1     1     ?             :  0  :    0   ;
         1       x      1     1     ?             :  1  :    1   ;

         1       1      1     1     ?             :  ?  :    1   ;
         0       1      1     1     ?             :  ?  :    0   ;

         ?       0      x     1     ?             :  0  :    0   ;   // Reducing pessimism.//AB
         0       ?      x     1     ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0       x      *     1     ?             :  0  :    0   ;   // Reducing pessimism.//AB

         0       1      ?     1     ?             :  ?  :    0   ; // When SB=1 D=0 and G=1,no matter what RB is,Q=0.

         ?       0      1     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB

         1       x      1     x     ?             :  1  :    1   ;   // Reducing pessimism.//AB
         1       x      1     *     ?             :  1  :    1   ;   // Reducing pessimism.//AB

         1       1      1     x     ?             :  ?  :    1   ; // Reducing pessimism.

         ?       0     (?1)   1     ?             :  ?  :    -   ;   // ignore edge on clear
         ?       0      1    (?1)   ?             :  ?  :    -   ;   // ignore edge on set

         ?       ?      ?     ?     *             :  ?  :    x   ;

   endtable
endprimitive

primitive U_LD_P_SB_RB_QN ( QN, D, CK, RB, SB );

   output QN; 
   reg    QN;
   input  D,  CK,  RB, SB;

// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET ( QN OUTPUT UDP ).

table
    //  D   CK  RB  SB  :   Qtn : Qtn+1

        1   1   1   1   :   ?   :   0;  // clock enabled transparent data.
        0   1   1   1   :   ?   :   1;

        1   x   1   1   :   0   :   0;  // possible enabled clock.
        0   x   1   1   :   1   :   1;

        ?   ?   1   0   :   ?   :   0;  // asynchronous set 
        ?   ?   0   ?   :   ?  :    1;  // asynchronous reset

        ?   0   1   1   :   ?   :   -;  // clock disabled.

        0   1   x   1   :   ?   :   1;  // pessimism 
        0   ?   x   1   :   1   :   1;  // pessimism 
        1   1   1   x   :   ?   :   0;  // pessimism 
        1   ?   1   x   :   0   :   0;  // pessimism                       

        ?   0   x   1   :   1  :    1;  // set inactive                    
        ?   0   1   x   :   0  :    0;  // reset inactive    
  
   endtable  
endprimitive

primitive U_LD_P_SB_RB_QN_NO ( QN, D, CK, RB, SB, NOTIFIER_REG );
   output QN; 
   reg    QN;
   input  D, 
         CK, 
         RB, 
         SB,
	 NOTIFIER_REG;

// FUNCTION : POSITIVE LEVEL SENSITIVE D-TYPE LATCH WITH ACTIVE LOW
//            ASYNCHRONOUS SET AND RESET ( QN OUTPUT UDP ).


table
    //  D   CK  RB  SB  NOTIFIER_REG  :   Qtn : Qtn+1

        1   1   1   1     ?           :   ?   :   0;  // clock enabled transparent data.
        0   1   1   1     ?           :   ?   :   1;

        1   x   1   1     ?           :   0   :   0;  // possible enabled clock.
        0   x   1   1     ?           :   1   :   1;

        ?   ?   0   ?     ?           :   ?  :    1; // asynchronous reset
        ?   ?   1   0     ?           :   ?   :   0;  // asynchronous set 
        *   0   1   1     ?           :   ?   :   -;
        ?   0   r   1     ?           :   ?   :   -;
        ?   0   1   r     ?           :   ?   :   -;

        0   1   x   1     ?           :   ?   :   1;  // pessimism 
        0   ?   x   1     ?           :   1   :   1;  // pessimism 
        1   1   1   x     ?           :   ?   :   0;  // pessimism 
        1   ?   1   x     ?           :   0   :   0;  // pessimism                       

        ?   0   x   1     ?           :   1  :    1;  // set inactive                    
        ?   0   1   x     ?           :   0  :    0;  // reset inactive    

        ?  (?0) 1   1     ?           :   ?  :    -;
        ?   ?   ?   ?     *           :   ?  :    x;

   endtable  
endprimitive

primitive U_MUX_2_1 (Q, A, B, SL);
    output Q;
    input A, B, SL;

// FUNCTION :  TWO TO ONE MULTIPLEXER

    table
    //  A   B   SL  :   Q
        0   0   ?   :   0 ;
        1   1   ?   :   1 ;

        0   ?   0   :   0 ;
        1   ?   0   :   1 ;

        ?   0   1   :   0 ;
        ?   1   1   :   1 ;

    endtable
endprimitive    

primitive U_MUX_4_2 (Y, D0, D1, D2, D3, S0, S1);

    input D0, D1, D2, D3, S0, S1;
    output Y;
   
// FUNCTION :  FOUR TO ONE MULTIPLEXER WITH 2 SELECT CONTROLS

    table

//   D0  D1  D2 D3  S0  S1 : Y
                       
     0   ?   ?  ?    0  0  : 0 ; 
     1   ?   ?  ?    0  0  : 1 ; 
                                 
     ?   0   ?  ?    1  0  : 0 ; 
     ?   1   ?  ?    1  0  : 1 ; 
                                 
     ?   ?   0  ?    0  1  : 0 ; 
     ?   ?   1  ?    0  1  : 1 ; 
                                 
     ?   ?   ?  0    1  1  : 0 ; 
     ?   ?   ?  1    1  1  : 1 ; 
                                 
                                 
     0   0   0   0   ?  ?  : 0 ; 
                       
     1   1   1   1   ?  ?  : 1 ; 

     0   0   ?   ?   ?  0  : 0 ;    
     1   1   ?   ?   ?  0  : 1 ; 

     ?   ?   0   0   ?  1  : 0 ; 
     ?   ?   1   1   ?  1  : 1 ; 

     0   ?   0   ?   0  ?  : 0 ; 
     1   ?   1   ?   0  ?  : 1 ; 

     ?   0   ?   0   1  ?  : 0 ; 
     ?   1   ?   1   1  ?  : 1 ; 
                 
     endtable
endprimitive

primitive U_L_SB_RB_NO ( Q, SB, RB, NOTI_REG);
      output Q;	
      reg Q;
      input SB, RB, NOTI_REG;

// FUNCTION : CROSS-COUPLED NAND LATCH.  SET AND RESET ARE ACTIVE LOW.  RESET IS
//            DOMINANT ( Q OUTPUT UDP ).

//  This model does not reflect the data ambiguity when set and
//  reset are both active and simultaneously change to inactive.

table
  //   SB   RB  NOTI_REG  :  Qt  :  Qt+1                                   
                                                                
        1   (?1)     ?    :   ?  :     -;  // Latch state.                
       (?1)  1       ?    :   ?  :     -;  // Latch state.                
        1    0       ?    :   ?  :     0;  // Reset state.                
        0    1       ?    :   ?  :     1;  // set state.                  
        0    0       ?    :   ?  :     0;  // Set overrided by reset.        
                                                                
        x    0       ?    :   ?  :     0;                                 
                                                                
        1    x       ?    :   0  :     0;  // Indeterminate set and reset.
        x    1       ?    :   1  :     1;

        ?    ?       *    :   ?  :     x;  

endtable
endprimitive

primitive U_L_SB_RB_QN_NO (QN, SB, RB, NOTI_REG);
      output QN;
      reg QN;
      input SB, RB, NOTI_REG;

// FUNCTION : CROSS-COUPLED NAND LATCH.  SET AND RESET ARE ACTIVE LOW.  SET IS
//            DOMINANT ( QN OUTPUT UDP ).

//  This model does not reflect the data ambiguity when set and
//  reset are both active and simultaneously change to inactive.

table
  //   SB   RB  NOTI_REG  :  QNt  :  QNt+1                                   
                                                                
        1   (?1)    ?    :   ?  :     -;  // Latch state.                
       (?1)  1      ?    :   ?  :     -;  // Latch state.                
        1    0      ?     :   ?  :     1;  // Reset state.                
        0    1      ?     :   ?  :     0;  // set state.                  
        0    0      ?     :   ?  :     0;  // Set overrides reset.        
                                                                
        0    x      ?     :   ?  :     0;                                 
                                                                
        1    x      ?     :   1  :     1;  // Indeterminate set and reset.
        x    1      ?     :   0  :     0;

        ?    ?      *     :   ?  :     x;

endtable
endprimitive

primitive U_L_SB_RB ( Q, SB, RB);
      output Q;	
      reg Q;
      input SB, RB;

// FUNCTION : CROSS-COUPLED NAND LATCH.  SET AND RESET ARE ACTIVE LOW.  RESET IS
//            DOMINANT ( Q OUTPUT UDP ).

//  This model does not reflect the data ambiguity when set and
//  reset are both active and simultaneously change to inactive.

table
  //   SB   RB  :  Qt  :  Qt+1                                   
                                                                
        1    1  :   ?  :     -;  // Latch state.                
        1    0  :   ?  :     0;  // Reset state.                
        0    1  :   ?  :     1;  // set state.                  
        0    0  :   ?  :     0;  // Set overrided by reset.        
                                                                
        x    0  :   ?  :     0;                                 
                                                                
        1    x  :   0  :     0;  // Indeterminate set and reset.
        x    1  :   1  :     1;

endtable
endprimitive

primitive U_L_SB_RB_QN (QN, SB, RB);
      output QN;
      reg QN;
      input SB, RB;

// FUNCTION : CROSS-COUPLED NAND LATCH.  SET AND RESET ARE ACTIVE LOW.  SET IS
//            DOMINANT ( QN OUTPUT UDP ).

//  This model does not reflect the data ambiguity when set and
//  reset are both active and simultaneously change to inactive.

table
  //   SB   RB  :  QNt  :  QNt+1                                   
                                                                
        1    1  :   ?  :     -;  // Latch state.                
        1    0  :   ?  :     1;  // Reset state.                
        0    1  :   ?  :     0;  // set state.                  
        0    0  :   ?  :     0;  // Set overrides reset.        
                                                                
        0    x  :   ?  :     0;                                 
                                                                
        1    x  :   1  :     1;  // Indeterminate set and reset.
        x    1  :   0  :     0;

endtable
endprimitive

primitive U_MUX_2_1_INV (Y, D0, D1, S);

    input D0, D1, S;
    output Y;
   
// FUNCTION :  TWO TO ONE MULTIPLEXER  WITH INVERTING OUTPUT

    table
//   D0  D1  S  : Y
  
     0   ?   0  : 1 ;
     1   ?   0  : 0 ;

     ?   0   1  : 1 ;
     ?   1   1  : 0 ;

     0   0   ?  : 1 ;
     1   1   ?  : 0 ;

     endtable
endprimitive

primitive U_SUB2_C (CO, A, B, CI);

    output CO;
    input CI, A, B;
          
// FUNCTION : 1-bit SUBTRACTOR (A - B) carry out term 

// Conventions :  CI = BORROW IN , CO = BORROW OUT
// CI = 0 implies borrow is on  i.e. previous stage is 
// borrowing from this stage and CI =  1 implies  
// no borrow 
// CO = 0 implies borrow out is on  i.e. this stage
// will borrow from next stage  
                                      

    table
    //  A   B   CI  :   CO
        0   ?   0   :   0 ;  // A < B , so borrow from next stage  

        ?   0   1   :   1 ;  // no borrow in and A >= B ,
                             // so don't borrow from next stage

        0   1   ?   :   0 ;  // A < B , so borrow from next stage

        1   0   ?   :   1 ;  // A > B , NO borrow from next stage

        ?   1   0   :   0 ;  // A <= B and borrow in is on , so
                             // borrow from next stage   

        1   ?   1   :   1 ;  // A >= B , and no borrow in ,
                             // so don't borrow from next stage
  
    endtable
endprimitive   

primitive U_SUB2_D (S, A, B, CI);

    output S;
    input CI, A, B;
          
// FUNCTION : 1-bit SUBTRACTOR Difference ( A - B) out term 

// Conventions :  CI = BORROW IN , S = DIFFERENCE 
// CI = 0 implies borrow is on i.e. previous stage is 
// borrowing from this stage and CI =  1 implies
// no borrow

    table
    //  A   B   CI  :   S           Operation performed
        0   0   0   :   1 ;     //  S =  10  - 1 - 0 
        0   0   1   :   0 ;     //  S =  0 - 0
        0   1   0   :   0 ;     //  S =  10 - 1 - 1 
        0   1   1   :   1 ;     //  S =  10 - 1 
        1   0   0   :   0 ;     //  S =  1 - 1 - 0
        1   0   1   :   1 ;     //  S =  1 - 0
        1   1   0   :   1 ;     //  S =  11 - 1 - 1
        1   1   1   :   0 ;     //  S =  1 - 1

    endtable
endprimitive   
