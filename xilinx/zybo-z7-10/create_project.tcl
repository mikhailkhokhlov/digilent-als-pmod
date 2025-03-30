create_project -force -part xc7z010clg400-1 zybo-z7-als-pmod

add_files -fileset sources_1 rtl/top.v
add_files -fileset sources_1 rtl/pmod_ssd.v
add_files -fileset sources_1 rtl/aresetn.v
add_files -fileset sources_1 rtl/mmcm.v
add_files -fileset sources_1 ../../als-pmod-controller.v
add_files -fileset sources_1 ../../clock-divider.v

add_files -fileset constrs_1 constr/zybo-z7.xdc

exit
