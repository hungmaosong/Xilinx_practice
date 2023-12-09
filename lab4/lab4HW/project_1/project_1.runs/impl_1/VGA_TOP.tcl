proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}


start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  set_param xicom.use_bs_reader 1
  create_project -in_memory -part xc7z020clg484-1
  set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir C:/xilinx_lab_project/lab4HW/project_1/project_1.cache/wt [current_project]
  set_property parent.project_path C:/xilinx_lab_project/lab4HW/project_1/project_1.xpr [current_project]
  set_property ip_output_repo C:/xilinx_lab_project/lab4HW/project_1/project_1.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES XPM_CDC [current_project]
  add_files -quiet C:/xilinx_lab_project/lab4HW/project_1/project_1.runs/synth_1/VGA_TOP.dcp
  read_ip -quiet c:/xilinx_lab_project/lab4HW/project_1/project_1.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci
  set_property is_locked true [get_files c:/xilinx_lab_project/lab4HW/project_1/project_1.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xci]
  read_xdc C:/xilinx_lab_project/lab4HW/project_1/project_1.srcs/constrs_1/new/lab4HW.xdc
  link_design -top VGA_TOP -part xc7z020clg484-1
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force VGA_TOP_opt.dcp
  catch { report_drc -file VGA_TOP_drc_opted.rpt }
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force VGA_TOP_placed.dcp
  catch { report_io -file VGA_TOP_io_placed.rpt }
  catch { report_utilization -file VGA_TOP_utilization_placed.rpt -pb VGA_TOP_utilization_placed.pb }
  catch { report_control_sets -verbose -file VGA_TOP_control_sets_placed.rpt }
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force VGA_TOP_routed.dcp
  catch { report_drc -file VGA_TOP_drc_routed.rpt -pb VGA_TOP_drc_routed.pb -rpx VGA_TOP_drc_routed.rpx }
  catch { report_methodology -file VGA_TOP_methodology_drc_routed.rpt -rpx VGA_TOP_methodology_drc_routed.rpx }
  catch { report_power -file VGA_TOP_power_routed.rpt -pb VGA_TOP_power_summary_routed.pb -rpx VGA_TOP_power_routed.rpx }
  catch { report_route_status -file VGA_TOP_route_status.rpt -pb VGA_TOP_route_status.pb }
  catch { report_clock_utilization -file VGA_TOP_clock_utilization_routed.rpt }
  catch { report_timing_summary -warn_on_violation -max_paths 10 -file VGA_TOP_timing_summary_routed.rpt -rpx VGA_TOP_timing_summary_routed.rpx }
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force VGA_TOP_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

start_step write_bitstream
set ACTIVE_STEP write_bitstream
set rc [catch {
  create_msg_db write_bitstream.pb
  set_property XPM_LIBRARIES XPM_CDC [current_project]
  catch { write_mem_info -force VGA_TOP.mmi }
  write_bitstream -force VGA_TOP.bit 
  catch {write_debug_probes -no_partial_ltxfile -quiet -force debug_nets}
  catch {file copy -force debug_nets.ltx VGA_TOP.ltx}
  close_msg_db -file write_bitstream.pb
} RESULT]
if {$rc} {
  step_failed write_bitstream
  return -code error $RESULT
} else {
  end_step write_bitstream
  unset ACTIVE_STEP 
}

