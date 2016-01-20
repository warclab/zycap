open_checkpoint ./checkpoints/top_mode1_routed.dcp

write_bitstream -force ./bitstreams/mode1.bit

close_design

open_checkpoint ./checkpoints/top_mode2_routed.dcp

write_bitstream -force ./bitstreams/mode2.bit

close_design