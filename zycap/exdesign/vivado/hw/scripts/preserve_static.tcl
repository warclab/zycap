
update_design -cell system_i/partial_led_test_0 -black_box

lock_design -level routing

write_checkpoint -force ./checkpoints/static_routed.dcp

close_design