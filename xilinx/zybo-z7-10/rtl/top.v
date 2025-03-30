`timescale 1ns / 1ps

`include "pmod_ssd.v"
`include "mmcm.v"
`include "aresetn.v"
`include "../../../als-pmod-controller.v"

`default_nettype none

module top
(
  input  wire i_clock_125MHz,
  output wire o_seg_a,
  output wire o_seg_b,
  output wire o_seg_c,
  output wire o_seg_d,
  output wire o_seg_e,
  output wire o_seg_f,
  output wire o_seg_g,
  output wire o_seg_sel,

  output wire o_sck,
  output wire o_cs,
  input  wire i_sdo
);

  wire [7:0] als_value;
  wire aresetn;

  wire sys_clock_ibuf;
  wire system_clock;
  wire locked;

  mmcm mmcm0(.i_sys_clock_125MHz ( i_clock_125MHz ),
             .o_clock_12MHz      ( system_clock   ),
             .o_locked           ( locked         ));

  aresetn aresetn0(.i_clock  ( system_clock ),
                   .i_launch ( locked       ),
                   .o_resetn ( aresetn      ));

  als_controller #(.DIV_FACTOR(4)) als_controller0(.i_system_clock ( system_clock ),
                                                   .i_aresetn      ( aresetn      ),
                                                   .o_sck          ( o_sck        ),
                                                   .o_cs           ( o_cs         ),
                                                   .i_sdo          ( i_sdo        ),
                                                   .o_value        ( als_value    ));

  pmod_ssd pmod_ssd0(.i_clock_125MHz ( system_clock ),
                     .i_data         ( als_value    ),
                     .o_seg_a        ( o_seg_a      ),
                     .o_seg_b        ( o_seg_b      ),
                     .o_seg_c        ( o_seg_c      ),
                     .o_seg_d        ( o_seg_d      ),
                     .o_seg_e        ( o_seg_e      ),
                     .o_seg_f        ( o_seg_f      ),
                     .o_seg_g        ( o_seg_g      ),
                     .o_seg_sel      ( o_seg_sel    ));
endmodule
