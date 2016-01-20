# Make sure that this script is run from the project folder (zycap_test)

open_checkpoint ./checkpoints/top_synth.dcp
set_property HD.RECONFIGURABLE true [get_cells system_i/partial_led_test_0]

read_xdc ./constraints/top_io.xdc

read_checkpoint ../modes/mode1.dcp -cell system_i/partial_led_test_0
# Floor plan
startgroup
create_pblock pblock_partial_led_test_0
resize_pblock pblock_partial_led_test_0 -add SLICE_X36Y75:SLICE_X47Y99
add_cells_to_pblock pblock_partial_led_test_0 [get_cells [list system_i/partial_led_test_0]] -clear_locs
endgroup

write_xdc ./constraints/top_fplan.xdc -force
write_checkpoint ./checkpoints/top_link_mode1.dcp -force

# DRC for PR
create_drc_ruledeck ruledeck_1
add_drc_checks -ruledeck ruledeck_1 [get_drc_checks {HDPR-42 HDPR-38 HDPR-37 HDPR-36 HDPR-35 HDPR-34 HDPR-32 HDPR-31 HDPR-29 HDPR-28 HDPR-27 HDPR-26 HDPR-25 HDPR-23 HDPR-22 HDPR-19 HDPR-18 HDPR-17 HDPR-16 HDPR-15 HDPR-14 HDPR-13 HDPR-12 HDPR-11 HDPR-10 HDPR-9 HDPR-8 HDPR-7 HDPR-6 HDPR-5 HDPR-4 HDPR-3 HDPR-2 HDPR-1}]
report_drc -name drc_1 -ruledeck ruledeck_1

# Errors should appear now, if any
delete_drc_ruledeck ruledeck_1

# Proceed if there are no errors 

opt_design

place_design 

route_design 

write_checkpoint ./checkpoints/top_mode1_routed.dcp -force 



