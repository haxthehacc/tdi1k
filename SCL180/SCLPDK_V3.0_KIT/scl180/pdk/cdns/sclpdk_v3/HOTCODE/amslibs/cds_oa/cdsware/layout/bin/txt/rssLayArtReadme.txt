
                           TowerJazz ARTIFACT GENERATORS


--------------------------------------------------------------------------------
                                   OVERVIEW
--------------------------------------------------------------------------------

The following artifact generators are available in Cadence Virtuoso -> TowerJazz -> 
Artifacts:

     Legal Requirements:

          Copyright, Maskright, Year Generator

     Wafer Fab Requirements:

          Part Number Generator
          Layer Number and Revision Letter Generator

          (NOTE: ROM code generation is not available)

     Customer Requirements:

          Text Generator


--------------------------------------------------------------------------------
                                  TOOL SETUP
--------------------------------------------------------------------------------

The followings are required for artifact generators:

1. Load SKILL code in .cdsinit, so TowerJazz menu appears in Virtuoso:

   rdscdsinit = getShellEnvVar("RDS_CDS_INIT_FILES")
   load(strcat(rdscdsinit "/system.cdsinit"))

2. The library "cds_generic" is required for the Copyright generator. This library
   is not available in all design kits. It contains only the (

--------------------------------------------------------------------------------
                              SUPPORTED PROCESSES
--------------------------------------------------------------------------------

The following processes are currently supported:

  B25M BC35 BC35QX SBC35 SBC35QX

If you need to have generators in other processes, please contact Technical Support


--------------------------------------------------------------------------------
                              GENERAL INFORMATION
--------------------------------------------------------------------------------

The artifacts for legal requirements should be placed together with company name such as:

          (LOGO)   (M) (C) 2000


The  artifacts required for wafer fab should be grouped together.  They may  or
may not be near the legal artifacts.

A text generator is provided for customer part numbers or other requirements.

All  artifacts should be placed so that they are easily identifiable and do  not
interfere with any circuitry.  Any text, such as customer part number, should be
kept  away  from the fab part number and layer revisions so  fab  operators  can
easily distinguish the latter.

CAUTION:   Care  must be used in placing any custom  customer  artifacts.  This
includes  part  numbers,  logos,  designers initials,  cute pictures,  etc.  All
artifacts  must  be  easily  identifiable as an artifact at  any  stage  of  the
fabrication process.  Some complex artifacts have been mistaken for  process or
mask  defects,  causing  significant delay in fabrication.  Cute  pictures  and
unusual text should be avoided.  If you must include a picture (such as a logo),
it  should  be  recognizable  on every layer used and  should not  be  near  any
circuitry.  It  should also not create any DRC errors;  these  can
cause  fine "stringers" of photoresist that break loose to become defects on the
real circuit.

All of the generators have a scale.  The minimum scale (except for text generator) 
is 0.5 and is generally meet the minimum dimension for a given process.  The scale 
is rounded off to the nearest 0.25 so if you try to fine  tune you may not see any 
change in the result.  The minimum scale for text generator is 0.1. The text size 
is the same for all generators (except the Copyright generator) 
when the same scale is used.  For example, the part number text and the layer number
/revision text  will  be  the  same  size if they use the  the  same  scale.  

An exception to being able to specify the scale is the size of text on the  
pad-opening layer  (as occurs in both the part number and  layer  revision
generators).  Because the mask dimension to finished dimension is large for this
layer,  the minimum linewidth is 7um to maintain readability on both the  mask
and final product.  The generators automatically increase text on the pad-opening
layer to the minimum dimension required regardless of the scale entered.

All text input is case insensitive, all text output is upper case, and all extra
leading and trailing spaces are ignored.  Certain letters are not allowed in the
part  numbers  and layer revisions.  The letters I, O, Q, S, V and Z are not
allowed because they may be confused with other letters or numbers (I vs 1, 2 vs
Z, 0 vs O, for example).  Also, the  revision  letters M and W are not supported
because  of  the  extra width required to implement  them.  Only  alpha-numeric
symbols  are  allowed for part numbers and revision letters.  There  are  checks
with explanatory error messages to enforce these restrictions.


--------------------------------------------------------------------------------
                         USING THE ARTIFACT GENERATORS
--------------------------------------------------------------------------------


For each generator, there is a form popuping up, asking for library name, cell 
name, process, scale and marking layer.  After all the fields are properly filled,
a layout view specified by library name / cell name will be generated, and the
tool prompts user for placement location.


Copyright, Maskright, Year
--------------------------

This generator makes copyright and maskright symbols and a 4-digit year on metal1
and second top level metal.  The copyright  symbol is an encircled "C", maskright 
is an encircled "M".  The year is the first year of commercial exploitation,  a 
mask registration requirement.  Marking layer is put over the area.


Part Number Generator
---------------------

This generator creates a part number on all mask layers, and put marking layer
over the area.  The part number must be assigned by DCD.

The  part number is shown twice, once with all mask layers  except  pad-opening,
the other with the pad-opening layer on top metal shield.   This  is to  ensure  a
good moisture seal at openings in the protective overcoat (for reliability).

The part number has two orientations:

     Horizontal   -->    [LAYERS_w/o_PAD]  [PAD_LAYER]

     Vertical     -->    [PAD_LAYER]
                         [LAYERS_w/o_PAD]


Layer Numbers and Revision Letter Generator
-------------------------------------------

This  generator  creates a list of mask layer numbers and  their corresponding
revision letters (using Cadence DFII layer number convention),  and put marking layer
over the area.

The number of rows may be 1, 2, 3, 4, 5, or 6.  A number of rows of 6 puts all
the layers and their revisions on one column:


Layer Numbers and Revision Letter Example, number_of_rows = 1:

                                         //////
     1A 2A 3A 4A 5A 6A 11A 7A 8A 17A 18A //9A//
                                         ////// <--- Top Metal shield

The default number_of_rows is 3.


Text Generator
-----------------------

The text generator allows you to add any extra text you need.  Supported characters
are "a-z", "0-9", "-", and "_".
