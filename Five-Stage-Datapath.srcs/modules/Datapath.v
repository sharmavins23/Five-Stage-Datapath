`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Datapath
//
// Description: Module that combines together all other individual datapath
//              modules. This module will expose all important signals to the
//              testbench.
////////////////////////////////////////////////////////////////////////////////


module Datapath(
    // Inputs
    input clock,
    // Outputs
    output [31:0] currentPC
    );
    
    // Wire instantiation
    wire [31:0] nextPC;
    // Module instantiation
    ProgramCounter ProgramCounter(clock, nextPC, currentPC);
    PCAdder PCAdder(currentPC, nextPC);
endmodule
