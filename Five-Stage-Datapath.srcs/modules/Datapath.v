`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Module Name: Datapath
//
// Description: Module that combines together all other individual datapath
//              modules. This module will expose all important signals (mostly
//              the pipeline saved data signals) to the testbench for simplified
//              waveform analysis.
////////////////////////////////////////////////////////////////////////////////

// TODO: Rewire everything here
module Datapath(
    // Inputs
    input clock,
    // Outputs
    output [31:0] currentPC, // Program Counter
    output [31:0] savedInstruction, // Instruction Fetch/Instruction Decode
    output eregisterWrite, // Instruction Decode/Execution
    output ememoryToRegister,
    output ememoryWrite,
    output [3:0] ealuControl,
    output ealuImmediate,
    output [4:0] edestination,
    output [31:0] eregisterQA,
    output [31:0] eregisterQB,
    output [31:0] eimmediateExtended,
    output mregisterWrite, // Execution/Memory Access
    output mmemoryToRegister,
    output mmemoryWrite,
    output [4:0] mdestination,
    output [31:0] maluOut,
    output [31:0] mloadedRegister,
    output wregisterWrite, // Memory Access/Write Back
    output wmemoryToRegister,
    output [4:0] wdestination,
    output [31:0] waluOut,
    output [31:0] wloadedData,
    output [31:0] wDataWritten // Write Back feedback signal
    );
    
    // Wire instantiation //////////////////////////////////////////////////////
    // Wires that are assigned are taking the values from the output of the
    //  datapath module, or the signals output from the pipeline registers.

    // Pipeline
    wire [31:0] nextPC;
    wire [31:0] immediateExtended;
    wire registerWrite;
    wire memoryToRegister;
    wire memoryWrite;
    wire [3:0] aluControl;
    wire aluImmediate;
    wire destinationRegisterRT;
    wire [31:0] registerQA;
    wire [31:0] registerQB;
    wire [4:0] destination;

    // Instruction Fetch
    wire [31:0] loadedInstruction;

    // Instruction Decode
    wire [5:0] opCode;
    assign opCode = savedInstruction[31:26];
    wire [5:0] funct;
    assign funct = savedInstruction[5:0];
    wire [4:0] rs;
    assign rs = savedInstruction[25:21];
    wire [4:0] rt;
    assign rt = savedInstruction[20:16];
    wire [4:0] rd;
    assign rd = savedInstruction[15:11];
    wire [4:0] shamt;
    assign shamt = savedInstruction[10:6];
    wire [15:0] immediate;
    assign immediate = savedInstruction[15:0];

    // Execution
    wire ewreg;
    assign ewreg = eregisterWrite;
    wire em2reg;
    assign em2reg = ememoryToRegister;
    wire ewmem;
    assign ewmem = ememoryWrite;
    wire [3:0] ealuc;
    assign ealuc = ealuControl;
    wire ealuimm;
    assign ealuimm = ealuImmediate;
    wire [4:0] edest;
    assign edest = edestination;
    wire [31:0] eqa;
    assign eqa = eregisterQA;
    wire [31:0] eqb;
    assign eqb = eregisterQB;
    wire [31:0] eimm;
    assign eimm = eimmediateExtended;
    wire [31:0] chosenRegister;
    wire [31:0] aluOut;

    // Memory Access
    wire mwreg;
    assign mwreg = mregisterWrite;
    wire mm2reg;
    assign mm2reg = mmemoryToRegister;
    wire mwmem;
    assign mwmem = mmemoryWrite;
    wire [4:0] mdest;
    assign mdest = mdestination;
    wire [31:0] mALU;
    assign mALU = maluOut;
    wire [31:0] mdataIn;
    assign mdataIn = mloadedRegister;
    wire [31:0] mdataMemOut;

    // Write Back
    wire wwreg;
    assign wwreg = wregisterWrite;
    wire wm2reg;
    assign wm2reg = wmemoryToRegister;
    wire [4:0] wdest;
    assign wdest = wdestination;
    wire [31:0] wAlu;
    assign wAlu = waluOut;
    wire [31:0] wData;
    assign wData = wloadedData;
    wire [31:0] writeData;
    assign writeData = wDataWritten;

    // Module instantiation ////////////////////////////////////////////////////

    // Pipeline
    ProgramCounter ProgramCounter(clock, nextPC, currentPC);
    IF_ID IF_ID(clock, loadedInstruction, savedInstruction);
    ID_EXE ID_EXE(
        clock,
        registerWrite,
        memoryToRegister,
        memoryWrite,
        aluControl,
        aluImmediate,
        destination,
        registerQA,
        registerQB,
        immediateExtended,
        eregisterWrite,
        ememoryToRegister,
        ememoryWrite,
        ealuControl,
        ealuImmediate,
        edestination,
        eregisterQA,
        eregisterQB,
        eimmediateExtended
    );
    EXE_MEM EXE_MEM(
        clock,
        ewreg,
        em2reg,
        ewmem,
        edest,
        aluOut,
        eqb,
        mregisterWrite,
        mmemoryToRegister,
        mmemoryWrite,
        mdestination,
        maluOut,
        mloadedRegister
    );
    MEM_WB MEM_WB(
        clock,
        mwreg,
        mm2reg,
        mdest,
        mALU,
        mdataMemOut,
        wregisterWrite,
        wmemoryToRegister,
        wdestination,
        waluOut,
        wloadedData
    );

    // Instruction Fetch
    PCAdder PCAdder(currentPC, nextPC);
    InstructionMemory InstructionMemory(currentPC, loadedInstruction);

    // Instruction Decode
    ControlUnit ControlUnit(
        opCode,
        funct,
        registerWrite,
        memoryToRegister,
        memoryWrite,
        aluControl,
        aluImmediate,
        destinationRegisterRT
        );
    DestinationMux DestinationMux(rd, rt, destinationRegisterRT, destination);
    RegistryMemory RegistryMemory(
        clock,
        wwreg,
        rs,
        rt,
        wdest,
        writeData,
        registerQA,
        registerQB
        );
    SignExtension SignExtension(immediate, immediateExtended);

    // Execution
    ALUImmediateMux ALUImmediateMux(ealuimm, eqb, eimm, chosenRegister);
    ArithmeticLogicUnit ArithmeticLogicUnit(ealuc, eqa, chosenRegister, aluOut);

    // Memory Access
    DataMemory DataMemory(mwmem, mALU, mdataIn, mdataMemOut);

    // Write Back
    RegWriteMux RegWriteMux(wm2reg, wAlu, wData, wDataWritten);
endmodule
