# 
# Synthesis run script generated by Vivado
# 

create_project -in_memory -part xc7z020clg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/xilinx_lab_project/lab1HW/project_2/project_2.cache/wt [current_project]
set_property parent.project_path C:/xilinx_lab_project/lab1HW/project_2/project_2.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
set_property ip_output_repo c:/xilinx_lab_project/lab1HW/project_2/project_2.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib C:/xilinx_lab_project/lab1HW/project_2/project_2.srcs/sources_1/imports/lab1/led.v
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/xilinx_lab_project/lab1HW/project_2/project_2.srcs/constrs_1/new/led.xdc
set_property used_in_implementation false [get_files C:/xilinx_lab_project/lab1HW/project_2/project_2.srcs/constrs_1/new/led.xdc]


synth_design -top led -part xc7z020clg484-1


write_checkpoint -force -noxdef led.dcp

catch { report_utilization -file led_utilization_synth.rpt -pb led_utilization_synth.pb }
