`ifndef _ALS_PMOD_CONTROLLER_V_
`define _ALS_PMOD_CONTROLLER_V_

`include "clock-divider.v"

`default_nettype none

`timescale 1ns/1ps

module als_fsm
(
  input  wire       i_system_clock,
  input  wire       i_aresetn,
  input  wire       i_sck_rising_edge,

  output wire       o_cs,
  input  wire       i_sdo,

  output wire [7:0] o_value
);

  localparam STATE_IDLE    = 2'b00;
  localparam STATE_PREFIX  = 2'b01;
  localparam STATE_DATA    = 2'b10;
  localparam STATE_POSTFIX = 2'b11;

  reg [1:0] reg_state;
  reg [1:0] next_state;

  reg [3:0] reg_cnt;
  reg [3:0] next_cnt;

  reg reg_prefix_bus_err;
  reg reg_postfix_bus_err;
  reg next_prefix_bus_err;
  reg next_postfix_bus_err;

  reg [7:0] reg_shift;
  reg [7:0] next_shift;

  reg [7:0] reg_value;
  reg [7:0] next_value;

  always @(posedge i_system_clock, negedge i_aresetn)
    if (~i_aresetn)
      reg_state <= STATE_IDLE;
    else
      reg_state <= next_state;

  always @(*)
    case (reg_state)
      STATE_IDLE   :
        next_state =
            (i_sck_rising_edge) ? STATE_PREFIX : STATE_IDLE;
      STATE_PREFIX :
        if (reg_prefix_bus_err)
          next_state = STATE_IDLE;
        else
          next_state =
              (i_sck_rising_edge & (reg_cnt == 4'd2)) ? STATE_DATA : STATE_PREFIX;
      STATE_DATA   :
        next_state =
            (i_sck_rising_edge & (reg_cnt == 4'd7)) ? STATE_POSTFIX : STATE_DATA;
      STATE_POSTFIX:
        if (reg_postfix_bus_err)
          next_state = STATE_IDLE;
        else
          next_state =
              (i_sck_rising_edge & (reg_cnt == 4'd4)) ? STATE_IDLE : STATE_POSTFIX;
    endcase

  always @(posedge i_system_clock, negedge i_aresetn)
    if (~i_aresetn)
      reg_cnt <= 4'b0000;
    else
      reg_cnt <= next_cnt;

  always @(*) begin
    next_cnt = reg_cnt;
    case (reg_state)
      STATE_IDLE:
        next_cnt = 0;
      STATE_PREFIX:
        if (i_sck_rising_edge)
          next_cnt = (reg_cnt == 4'd2) ? 4'b0 : (reg_cnt + 1);
      STATE_DATA:
        if (i_sck_rising_edge)
          next_cnt = (reg_cnt == 4'd7) ? 4'b0 : (reg_cnt + 1);
      STATE_POSTFIX:
        if (i_sck_rising_edge)
          next_cnt = (reg_cnt == 4'd4) ? 4'b0 : (reg_cnt + 1);
    endcase
  end

  always @(posedge i_system_clock, negedge i_aresetn)
    if (~i_aresetn)
      begin
        reg_prefix_bus_err  <= 1'b0;
        reg_postfix_bus_err <= 1'b0;
      end
    else
      begin
        reg_prefix_bus_err  <= next_prefix_bus_err;
        reg_postfix_bus_err <= next_postfix_bus_err;
      end

  always @(posedge i_system_clock, negedge i_aresetn)
    if (~i_aresetn) begin
        reg_shift <= 8'h00;
        reg_value <= 8'h00;
      end
    else begin
      reg_shift <= next_shift;
      reg_value <= next_value;
    end

  always @(*) begin
    next_prefix_bus_err  = 1'b0;
    next_postfix_bus_err = 1'b0;
    next_shift = reg_shift;
    next_value = reg_value;

    case (reg_state)
      STATE_IDLE:
        next_shift = 8'h00;
      STATE_PREFIX:
        if (i_sck_rising_edge)
          next_prefix_bus_err = (i_sdo) ? 1'b1 : 1'b0;
      STATE_DATA:
        if (i_sck_rising_edge)
          next_shift = {reg_shift[6:0], i_sdo};
      STATE_POSTFIX:
        if (i_sck_rising_edge) begin
          next_postfix_bus_err = (i_sdo) ? 1'b1 : 1'b0;
          next_value = (reg_cnt == 4'd4) ? reg_shift : reg_value;
        end
    endcase
  end

  assign o_value = reg_value;
  assign o_cs = (reg_state == STATE_IDLE) ? 1'b1 : 1'b0;

endmodule

module als_controller #(parameter DIV_FACTOR = 2)
(
    input wire        i_system_clock,
    input wire        i_aresetn,

    output wire       o_sck,
    output wire       o_cs,
    input  wire       i_sdo,

    output wire [7:0] o_value
);

  reg sck_delayed;
  wire sck_rising_edge;

  clock_divider #(DIV_FACTOR) clock_divider0(.i_clock     ( i_system_clock ),
                                             .i_aresetn   ( i_aresetn      ),
                                             .o_div_clock ( o_sck          ));

  always @(posedge i_system_clock)
    sck_delayed <= o_sck;

  assign sck_rising_edge = o_sck & (~sck_delayed);

  als_fsm als_fsm0(.i_system_clock    ( i_system_clock  ),
                   .i_aresetn         ( i_aresetn       ),
                   .i_sck_rising_edge ( sck_rising_edge ),
                   .o_cs              ( o_cs            ),
                   .i_sdo             ( i_sdo           ),
                   .o_value           ( o_value         ));

endmodule

`endif // _ALS_PMOD_CONTROLLER_V_
