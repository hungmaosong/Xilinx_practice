connect -url tcp:127.0.0.1:3121
source C:/xilinx_lab_project/lab2/project_1/project_1.sdk/design_1_wrapper_hw_platform_0/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248650432"} -index 0
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zed 210248650432" && level==0} -index 1
fpga -file C:/xilinx_lab_project/lab2/project_1/project_1.sdk/design_1_wrapper_hw_platform_0/design_1_wrapper.bit
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248650432"} -index 0
loadhw -hw C:/xilinx_lab_project/lab2/project_1/project_1.sdk/design_1_wrapper_hw_platform_0/system.hdf -mem-ranges [list {0x40000000 0xbfffffff}]
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248650432"} -index 0
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed 210248650432"} -index 0
dow C:/xilinx_lab_project/lab2/project_1/project_1.sdk/lab2_gpio_test/Debug/lab2_gpio_test.elf
configparams force-mem-access 0
bpadd -addr &main
