`ifndef _ARESET_V_
`define _ARESET_V_

`default_nettype none

`timescale 1ns / 1ps

module aresetn
(
  input  wire i_clock,
  input  wire i_launch,
  output wire o_resetn
);

  reg [3:0] reg_reset = 4'b0000;
  wire reset;

  always @(posedge i_clock)
    if (i_launch)
      reg_reset <= {reg_reset[2:0], 1'b1};
    else
      reg_reset <= 4'b0000;

  assign reset = ~(&reg_reset) & i_launch;
  assign o_resetn = ~reset;

endmodule

`endif /* _ARESET_V_ */
