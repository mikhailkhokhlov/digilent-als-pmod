## Zybo Z7 board external clock signal 125MHz
set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [ get_ports { i_clock_125MHz } ]; #IO_L12P_T1_MRCC_35 Sch=sysclk
create_clock -add -name clk_125MHz -period 8.00 -waveform {0 4} [ get_ports { i_clock_125MHz } ]

## Derived clock pins and source pins
set pin_mmcm_input    [ get_pins mmcm0/mmcm_adv_inst/CLKIN1  ]
set pin_mmcm_out      [ get_pins mmcm0/mmcm_adv_inst/CLKOUT0 ]
set pin_clock_divider [ get_pins als_controller0/clock_divider0/o_div_clock_reg/Q ]

## MMCM output clock 12 MHz
create_generated_clock -name clk_12MHz -master_clock [get_clocks clk_125MHz] -source $pin_mmcm_input $pin_mmcm_out

## SPI serial clock
create_generated_clock -name clk_spi -source $pin_mmcm_out -divide_by 4 $pin_clock_divider

## SPI clock period
set Tsck [get_property PERIOD [get_clocks clk_spi]]

#Tcs_su (ADC081S021 datasheet)
set Tcs_su 10

#Tcs_h (ADC081S021 datasheet)
set Tcs_h 1

set_output_delay -max $Tcs_su -clock clk_spi [get_ports o_cs]
set_output_delay -min -$Tcs_h -clock clk_spi [get_ports o_cs]

set_multicycle_path 4 -setup -start -from [get_clocks clk_12MHz] -through [get_ports o_cs] -to [get_clocks clk_spi]
set_multicycle_path 3 -hold  -start -from [get_clocks clk_12MHz] -through [get_ports o_cs] -to [get_clocks clk_spi]

## Tacc (ADC081S021 datasheet)
set Tacc_max 40
set Tacc_min 0
set Tadc_co_max [expr $Tsck / 2 + $Tacc_max]
set Tadc_co_min [expr $Tsck / 2 + $Tacc_min]

set_input_delay -max $Tadc_co_max -clock clk_spi [get_ports i_sdo]
set_input_delay -min $Tadc_co_min -clock clk_spi [get_ports i_sdo]

set_multicycle_path 4 -setup -end -from [get_clocks clk_spi] -through [get_ports i_sdo] -to [get_clocks clk_12MHz]
set_multicycle_path 3 -hold  -end -from [get_clocks clk_spi] -through [get_ports i_sdo] -to [get_clocks clk_12MHz]

set_false_path -from [get_clocks clk_12MHz] -to [get_ports o_seg_a]
set_false_path -from [get_clocks clk_12MHz] -to [get_ports o_seg_b]
set_false_path -from [get_clocks clk_12MHz] -to [get_ports o_seg_c]
set_false_path -from [get_clocks clk_12MHz] -to [get_ports o_seg_d]
set_false_path -from [get_clocks clk_12MHz] -to [get_ports o_seg_e]
set_false_path -from [get_clocks clk_12MHz] -to [get_ports o_seg_f]
set_false_path -from [get_clocks clk_12MHz] -to [get_ports o_seg_g]
set_false_path -from [get_clocks clk_12MHz] -to [get_ports o_seg_sel]

set_output_delay 0 [get_ports o_seg_a]
set_output_delay 0 [get_ports o_seg_b]
set_output_delay 0 [get_ports o_seg_c]
set_output_delay 0 [get_ports o_seg_d]
set_output_delay 0 [get_ports o_seg_e]
set_output_delay 0 [get_ports o_seg_f]
set_output_delay 0 [get_ports o_seg_g]

set_false_path -from [get_clocks clk_12MHz] -to [get_ports o_sck]
set_output_delay 0 [get_ports o_sck]

## Pmod Header JC - Seven segments indicator
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33     } [get_ports { o_seg_a }]; #IO_L10P_T1_34 Sch=jc_p[1]
set_property -dict { PACKAGE_PIN W15   IOSTANDARD LVCMOS33     } [get_ports { o_seg_b }]; #IO_L10N_T1_34 Sch=jc_n[1]
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33     } [get_ports { o_seg_c }]; #IO_L1P_T0_34 Sch=jc_p[2]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33     } [get_ports { o_seg_d }]; #IO_L1N_T0_34 Sch=jc_n[2]

## Pmod Header JD - Seven segmets indicator
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33     } [get_ports { o_seg_e }]; #IO_L5P_T0_34 Sch=jd_p[1]
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33     } [get_ports { o_seg_f }]; #IO_L5N_T0_34 Sch=jd_n[1]
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33     } [get_ports { o_seg_g }]; #IO_L6P_T0_34 Sch=jd_p[2]
set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33     } [get_ports { o_seg_sel }]; #IO_L6N_T0_VREF_34 Sch=jd_n[2]

##Pmod Header JE - Digilent ALS PMOD
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { o_cs }]; #IO_L4P_T0_34 Sch=je[1]
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { i_sdo }]; #IO_25_35 Sch=je[3]
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { o_sck }]; #IO_L19P_T3_35 Sch=je[4]
