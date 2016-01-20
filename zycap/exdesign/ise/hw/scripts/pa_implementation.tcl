create_project zycap_test ./zycap_test -part xc7z020clg484-1 -force
cd zycap_test
set_property board zedBoard [current_project]
set_property design_mode GateLvl [current_fileset]
set_property name config_1 [current_run]
set_property is_partial_reconfig true [current_project]
import_files -norecurse {../xps/implementation/system.ngc ../xps/implementation/system_axi4lite_0_wrapper.ngc ../xps/implementation/system_axi_interconnect_1_wrapper.ngc ../xps/implementation/system_axi_interconnect_1_wrapper_fifo_generator_v9_1_1.ngc ../xps/implementation/system_axi_interconnect_1_wrapper_fifo_generator_v9_1_2.ngc ../xps/implementation/system_axi_interconnect_1_wrapper_fifo_generator_v9_1_3.ngc ../xps/implementation/system_axi_timer_0_wrapper.ngc ../xps/implementation/system_btns_5bits_wrapper.ngc ../xps/implementation/system_partial_led_test_0_wrapper.ngc ../xps/implementation/system_processing_system7_0_wrapper.ngc ../xps/implementation/system_sws_8bits_wrapper.ngc ../xps/implementation/system_zycap_0_wrapper.ngc}
import_files -fileset constrs_1 {../xps/implementation/system_axi4lite_0_wrapper.ncf ../xps/implementation/system_axi_interconnect_1_wrapper.ncf ../xps/implementation/system_processing_system7_0_wrapper.ncf}
import_files -fileset constrs_1 ./top_io.ucf
link_design -name netlist_1
#Add Blacbox
create_reconfig_module -name module_1 -cell partial_led_test_0/partial_led_test_0/USER_LOGIC_I -blackbox
save_constraints
load_reconfig_modules -reconfig_modules partial_led_test_0/partial_led_test_0/USER_LOGIC_I:module_1
#Add RM1
create_reconfig_module -name module_2 -cell partial_led_test_0/partial_led_test_0/USER_LOGIC_I
set_property edif_top_file D:/SHS/Research/zycap_master_repo/zycap/exdesign/ise/hw/modes/mode1/partial_led_test_0.ngc [get_filesets partial_led_test_0~partial_led_test_0~USER_LOGIC_I#module_2]
import_files -fileset partial_led_test_0~partial_led_test_0~USER_LOGIC_I#module_2 -force -norecurse D:/SHS/Research/zycap_master_repo/zycap/exdesign/ise/hw/modes/mode1/partial_led_test_0.ngc
#Add RM2
create_reconfig_module -name module_3 -cell partial_led_test_0/partial_led_test_0/USER_LOGIC_I
set_property edif_top_file D:/SHS/Research/zycap_master_repo/zycap/exdesign/ise/hw/modes/mode2/partial_led_test_0.ngc [get_filesets partial_led_test_0~partial_led_test_0~USER_LOGIC_I#module_3]
import_files -fileset partial_led_test_0~partial_led_test_0~USER_LOGIC_I#module_3 -force -norecurse D:/SHS/Research/zycap_master_repo/zycap/exdesign/ise/hw/modes/mode2/partial_led_test_0.ngc
#Size Pblock
resize_pblock pblock_partial_led_test_0_USER_LOGIC_I -add SLICE_X36Y75:SLICE_X47Y99 -locs keep_all -replace
save_constraints
#Setup Run1
config_partition -run config_1 -cell partial_led_test_0/partial_led_test_0/USER_LOGIC_I -reconfig_module module_2 -implement
#Run Run1
launch_runs config_1
wait_on_run config_1 -timeout 60
#Promote Partition
promote_run -run config_1 -partition_names {system partial_led_test_0/partial_led_test_0/USER_LOGIC_I}
#Create Run2
create_run config_2 -flow {ISE 14} -strategy {ISE Defaults}
#Setup Run2
config_partition -run config_2 -import -import_dir ./zycap_test.promote/Xconfig_1 -preservation routing
config_partition -run config_2 -cell partial_led_test_0/partial_led_test_0/USER_LOGIC_I -reconfig_module module_3 -implement
#Launch Run2
launch_runs config_2
wait_on_run config_2
#Verify Configurations
verify_config -runs {  config_1 config_2 } -file ./pr_verify.log
#Run Bitgen - You can run the two commands below in parallel.
launch_runs config_1 -to_step Bitgen
wait_on_run config_1
launch_runs config_2 -to_step Bitgen
wait_on_run config_2
close_project
#Copy the bitstreams
# md bitstreams
# cp zycap_test.runs/config_1/*.bit bitstreams/
# cp zycap_test.runs/config_2/*.bit bitstreams/
# mv bitstreams/config_1_partial*.bit bitstreams/config_1_partial.bit
# mv bitstreams/config_2_partial*.bit bitstreams/config_2_partial.bit
