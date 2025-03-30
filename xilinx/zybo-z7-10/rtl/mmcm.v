`ifndef _MMCM_V_
`define _MMCM_V_

`default_nettype none

module mmcm
(
  input  wire i_sys_clock_125MHz,
  output wire o_clock_12MHz,
  output wire o_locked
);

  wire sys_clock_125MHz_ibuf;

  IBUF ibuf (.I ( i_sys_clock_125MHz    ),
             .O ( sys_clock_125MHz_ibuf ));

  wire        clock_12Mhz_mmcm;
  wire        clkfbout;
  wire        clkfbout_bufg;

  MMCME2_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (5),
    .CLKFBOUT_MULT_F      (40.500),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (84.375),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (8.000))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            ( clkfbout              ),
    .CLKFBOUTB           (                       ),
    .CLKOUT0             ( clock_12Mhz_mmcm      ),
    .CLKOUT0B            (                       ),
    .CLKOUT1             (                       ),
    .CLKOUT1B            (                       ),
    .CLKOUT2             (                       ),
    .CLKOUT2B            (                       ),
    .CLKOUT3             (                       ),
    .CLKOUT3B            (                       ),
    .CLKOUT4             (                       ),
    .CLKOUT5             (                       ),
    .CLKOUT6             (                       ),
     // Input clock control
    .CLKFBIN             ( clkfbout_bufg         ),
    .CLKIN1              ( sys_clock_125MHz_ibuf ),
    .CLKIN2              ( 1'b0                  ),
     // Tied to always select the primary input clock
    .CLKINSEL            ( 1'b1                  ),
    // Ports for dynamic reconfiguration
    .DADDR               ( 7'h0                  ),
    .DCLK                ( 1'b0                  ),
    .DEN                 ( 1'b0                  ),
    .DI                  ( 16'h0                 ),
    .DO                  (                       ),
    .DRDY                (                       ),
    .DWE                 ( 1'b0                  ),
    // Ports for dynamic phase shift
    .PSCLK               ( 1'b0                  ),
    .PSEN                ( 1'b0                  ),
    .PSINCDEC            ( 1'b0                  ),
    .PSDONE              (                       ),
    // Other control and status signals
    .LOCKED              (o_locked               ),
    .CLKINSTOPPED        (                       ),
    .CLKFBSTOPPED        (                       ),
    .PWRDWN              ( 1'b0                  ),
    .RST                 ( 1'b0                  ));

  BUFG clkf_buf (.I ( clkfbout      ),
                 .O ( clkfbout_bufg ));

  BUFG clkout_buf (.I ( clock_12Mhz_mmcm ),
                   .O ( o_clock_12MHz    ));

endmodule

`endif // _MMCM_V_
