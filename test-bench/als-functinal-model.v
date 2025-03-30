`ifndef _ALS_FUNCTIONAL_MODEL_V_
`define _ALS_FUNCTIONAL_MODEL_V_

`default_nettype none

`timescale 1ns/1ps

module als_functional_model #(parameter PAYLOAD=8'b1100_0011)
(
    input  wire i_sclk,
    input  wire i_cs,
    output wire o_sdo
);

  localparam IDLE = 1'b0;
  localparam SEND = 1'b1;

  reg [ 7:0] payload;
  reg [14:0] data;
  reg [ 3:0] count;
  reg sdo;

  reg state;

  reg cs_delay;
  wire cs_fall;

  initial begin
    payload = PAYLOAD;
    sdo = 1'bz;
    count = 4'b0000;
    state = IDLE;
    cs_delay = 1'b0;
  end

  always @(negedge i_sclk)
    cs_delay <= i_cs;

  assign cs_fall = (~i_cs & cs_delay);

  always @(negedge i_sclk) begin
    case (state)
      IDLE: state <= (cs_fall) ? SEND : state;
      SEND: state <= (&count)  ? IDLE : state;
    endcase
  end

  always @(negedge i_sclk or posedge i_cs)
    if (~i_cs) begin
      {sdo, data} <= {data, 1'b0};
      count       <= count + 1'b1;
    end else begin
      {sdo, data} <= {1'b0, {3'b000, payload, 4'b0000}};
      count <= 1'b0;
    end

  assign o_sdo = (state == SEND) ? sdo : 1'bz;

endmodule

module als_fmodel_tb();

  reg       clock;
  reg       cs;
  wire      sdo;
  reg [4:0] counter;

  initial cs = 1'b1;
  initial counter = 5'b0;

  initial begin
    clock = 0;
    forever
      #5 clock = ~clock;
  end

  initial begin
    #15  cs = 1'b0;
    #160 cs = 1'b1;
    #40 $finish;
  end

    always @(posedge clock)
      if (~cs) begin
        counter <= counter + 1;
      end

  als_functional_model dut( .i_sclk (clock),
                            .i_cs   (cs   ),
                            .o_sdo  (sdo  ));

  initial begin
    $dumpfile("als_fmodel.vcd");
    $dumpvars(0, als_fmodel_tb);
  end

endmodule

`endif // _ALS_FUNCTIONAL_MODEL_V_
