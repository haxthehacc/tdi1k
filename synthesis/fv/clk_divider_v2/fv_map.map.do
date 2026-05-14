
//input ports
add mapped point clk_50m clk_50m -type PI PI
add mapped point rst_n rst_n -type PI PI

//output ports
add mapped point clk_line clk_line -type PO PO
add mapped point clk_line_pulse clk_line_pulse -type PO PO

//inout ports




//Sequential Pins
add mapped point cnt[12]/q cnt_reg[12]/Q -type DFF DFF
add mapped point cnt[11]/q cnt_reg[11]/Q -type DFF DFF
add mapped point cnt[10]/q cnt_reg[10]/Q -type DFF DFF
add mapped point cnt[9]/q cnt_reg[9]/Q -type DFF DFF
add mapped point cnt[8]/q cnt_reg[8]/Q -type DFF DFF
add mapped point cnt[7]/q cnt_reg[7]/Q -type DFF DFF
add mapped point cnt[6]/q cnt_reg[6]/Q -type DFF DFF
add mapped point cnt[5]/q cnt_reg[5]/Q -type DFF DFF
add mapped point clk_line/q clk_line_reg/Q -type DFF DFF
add mapped point cnt[3]/q cnt_reg[3]/Q -type DFF DFF
add mapped point cnt[4]/q cnt_reg[4]/Q -type DFF DFF
add mapped point clk_line_pulse/q clk_line_pulse_reg/Q -type DFF DFF
add mapped point cnt[2]/q cnt_reg[2]/Q -type DFF DFF
add mapped point cnt[1]/q cnt_reg[1]/Q -type DFF DFF
add mapped point cnt[0]/q cnt_reg[0]/QN -type DFF DFF
add mapped point rst_n_sync/q rst_n_sync_reg/Q -type DFF DFF
add mapped point rst_sync_meta/q rst_sync_meta_reg/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
