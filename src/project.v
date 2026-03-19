/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_YannGuidon_TinyScanChain (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

// Plumbing time...

/*
 Bidirectional pins
 uio[0]: "SC_RESET"
 uio[1]: "SC_CLK"
 uio[2]: "SC_GET"
 uio[3]: "SC_SET"
 uio[4]: "SC_DIN"
 uio[5]: "SC_DOUT"
 uio[6]: "DO8"
 uio[7]: "Count_Enable"
*/
  wire SC_RESET, SC_CLK, SC_GET, SC_SET, SC_DIN, SC_DOUT, DO8, Count_Enable;

  assign SC_RESET     = uio_in[0];
  assign SC_CLK       = uio_in[1];
  assign SC_GET       = uio_in[2];
  assign SC_SET       = uio_in[3];
  assign SC_DIN       = uio_in[4];
//assign uio_out[5]   = SC_DOUT;
//assign uio_out[6]   = DO8;
  assign Count_Enable = uio_in[7];

  wire [8:0] DO;
  assign uo_out  = DO[7:0];
  assign uio_out = { 1'b0, DO[8], SC_DOUT, 5'b0 };
  assign uio_oe  = 8'b01100000;

  // The actual "meat" comes here.
  wire [3:0] Latch;
  Johnson8 J8( .CLK(SC_CLK), .RESET(SC_RESET), .Latch(Latch) );

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
