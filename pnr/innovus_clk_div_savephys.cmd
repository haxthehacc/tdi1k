#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Thu May  7 04:40:15 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v22.35-s091_1 (64bit) 02/28/2024 12:25 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 22.35-s091_1 NR240223-1321/22_15-UB (database version 18.20.620_1) {superthreading v2.20}
#@(#)CDS: AAE 22.15-s036 (64bit) 02/28/2024 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 22.15-s037_1 () Feb 28 2024 01:27:33 ( )
#@(#)CDS: SYNTECH 22.15-s014_1 () Feb 13 2024 19:37:21 ( )
#@(#)CDS: CPE v22.15-s064
#@(#)CDS: IQuantus/TQuantus 21.2.2-s347 (64bit) Mon Dec 11 17:11:11 PST 2023 (Linux 3.10.0-693.el7.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
restoreDesign work_clk_div_v2/clk_divider_v2_pnr.enc.dat clk_divider_v2
saveNetlist work_clk_div_v2/clk_divider_v2_pnr_netlist_phys.v -includePhysicalCell {feedth feedth3 feedth9 decfq2 decfq4} -includePowerGround
