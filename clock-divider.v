`ifndef _CLOCK_DIVIDER_V_
`define _CLOCK_DIVIDER_V_

`default_nettype none

`timescale 1ns/1ps

module clock_divider #(parameter DIV_FACTOR=2)
(
    input  wire i_clock,
    input  wire i_aresetn,
    output reg  o_div_clock
);

  localparam SIZE = $clog2(DIV_FACTOR);

  reg [(SIZE-1):0] reg_counter;

  always @(posedge i_clock, negedge i_aresetn)
    if (~i_aresetn)
      begin
        reg_counter <= {SIZE{1'b0}};
        o_div_clock <= 1'b0;
      end
    else if (reg_counter == (DIV_FACTOR / 2) - 1)
      begin
        o_div_clock <= ~o_div_clock;
        reg_counter <= {SIZE{1'b0}};
      end
    else
      reg_counter <= reg_counter + 1;

endmodule

`endif // _CLOCK_DIVIDER_V_
