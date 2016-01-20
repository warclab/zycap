
open_checkpoint ./checkpoints/static_routed.dcp

read_checkpoint -cell system_i/partial_led_test_0 ../modes/mode2.dcp

write_checkpoint ./checkpoints/top_link_mode2.dcp -force

opt_design

place_design

route_design

write_checkpoint ./checkpoints/top_mode2_routed.dcp -force