`ifndef _TB_V_
`define _TB_V_

`default_nettype none

`include "../als-pmod-controller.v"
`include "als-functinal-model.v"

`timescale 1ns/1ps


module dut #(parameter SENSOR_VALUE=8'b11000011)
(
  input wire        i_system_clock,
  input wire        i_aresetn,
  output wire [7:0] o_value
);

  wire sck;
  wire cs;
  wire sdo;

  als_controller #(10) als_controller0(.i_system_clock ( i_system_clock ),
                                       .i_aresetn      ( i_aresetn      ),
                                       .o_sck          ( sck            ),
                                       .o_cs           ( cs             ),
                                       .i_sdo          ( sdo            ),
                                       .o_value        ( o_value        ));

  als_functional_model #(SENSOR_VALUE) als_functional_model0(.i_sclk ( sck ),
                                                             .i_cs   ( cs  ),
                                                             .o_sdo  ( sdo ));

endmodule

module tb();

  parameter SENSOR_VALUE=8'b01010101;

  reg        sys_clock;
  reg        aresetn;
  wire [7:0] als_value;

  dut #(SENSOR_VALUE) dut0(.i_system_clock ( sys_clock ),
                           .i_aresetn      ( aresetn   ),
                           .o_value        ( als_value ));

  initial begin
    sys_clock = 0;
    forever
      #5 sys_clock = ~sys_clock;
  end

  initial begin
    aresetn = 1'b0;
    #20 aresetn = 1'b1;
  end

  initial begin
    @(negedge dut0.cs);
    @(posedge dut0.cs);

    #100

    $display("*******************************************");
    $display("*** Model sensor value:            0x%h ***", SENSOR_VALUE);
    $display("*** ALS controller sensor value:   0x%h ***", als_value);
    $display("*******************************************");

    $finish;
  end

  initial begin
    $dumpfile("als-tb.vcd");
    $dumpvars(0, tb);
  end

endmodule

`endif // _TB_V_
