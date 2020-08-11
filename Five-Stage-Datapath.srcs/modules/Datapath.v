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
    output reg [31:0] currentPC, // Program Counter
    output reg [31:0] savedInstruction, // Instruction Fetch/Instruction Decode
    output stall,
    output reg eregisterWrite, // Instruction Decode/Execution
    output reg ememoryToRegister,
    output reg ememoryWrite,
    output reg ejalInstruction,
    output reg [3:0] ealuControl,
    output reg ealuImmediate,
    output reg eShiftRegister,
    output reg [31:0] enextPC,
    output reg [31:0] eregisterQA,
    output reg [31:0] eregisterQB,
    output reg [31:0] eimmediateExtended,
    output reg [4:0] edestination,
    output reg mregisterWrite, // Execution/Memory Access
    output reg mmemoryToRegister,
    output reg mmemoryWrite,
    output reg [31:0] maluOut,
    output reg [31:0] mloadedRegister,
    output reg [4:0] mdestination,
    output reg wregisterWrite, // Memory Access/Write Back
    output reg wmemoryToRegister,
    output reg [31:0] wloadedData,
    output reg [31:0] waluOut,
    output reg [4:0] wdestination,
    output reg [31:0] wDataWritten // Write Back feedback signal
    );
    
    // Wire instantiation //////////////////////////////////////////////////////
    // Wires that are assigned are taking the values from the output of the
    //  datapath module, or the signals output from the pipeline registers.

    // Instruction Fetch
    wire [31:0] npc;
    wire [1:0] pcsrc;
    wire wpcir;
    wire [31:0] pc;
    wire [31:0] pc4;
    wire [31:0] ins;

    // Instruction Decode
    wire [31:0] inst;
    wire [5:0] op;
    assign op = inst[31:26];
    wire [5:0] func;
    assign func = inst[5:0];
    wire [4:0] rs;
    assign rs = inst[25:21];
    wire [4:0] rt;
    assign rt = inst[20:16];
    wire [25:0] addr;
    assign addr = inst[25:0];
    wire [15:0] imm;
    assign imm = inst[15:0];
    wire [4:0] rd;
    assign rd = inst[15:11];
    wire wreg;
    wire m2reg;
    wire wmem;
    wire jal;
    wire [3:0] aluc;
    wire aluimm;
    wire shift;
    wire regrt;
    wire rsrtequ;
    wire sext;
    wire [1:0] fwdb;
    wire [1:0] fwda;
    wire [27:0] jpc;
    wire [31:0] dpc4;
    wire [17:0] bimm;
    wire [31:0] bpc;
    wire [31:0] qa;
    wire [31:0] qb;
    wire [31:0] jpcTotal;
    assign jpcTotal = {dpc4[31:28], jpc};
    wire [31:0] da;
    wire [31:0] db;
    wire [31:0] dimm;
    wire [4:0] drn;

    // Execution
    wire ewreg;
    wire em2reg;
    wire ewmem;
    wire ejal;
    wire [3:0] ealuc;
    wire ealuimm;
    wire eshift;
    wire [31:0] epc4;
    wire [31:0] ea;
    wire [31:0] eb;
    wire [31:0] eimm;
    wire [4:0] ern0;
    wire sa;
    assign sa = eimm[10:6];
    wire [31:0] epc8;
    wire [31:0] a;
    wire [31:0] b;
    wire [31:0] alu;
    wire [31:0] ealu;
    wire [4:0] ern;

    // Memory Access
    wire mwreg;
    wire mm2reg;
    wire mwmem;
    wire [31:0] malu;
    wire [31:0] mb;
    wire [4:0] mrn;
    wire [31:0] mmo;

    // Write Back
    wire wwreg;
    wire wm2reg;
    wire [31:0] wmo;
    wire [31:0] walu;
    wire [4:0] wrn;
    wire [31:0] wdi;

    // Module instantiation ////////////////////////////////////////////////////

    // Pipeline
    ProgramCounter ProgramCounter(clock, wpcir, npc, pc);
    IF_ID IF_ID(clock, wpcir, pc4, ins, dpc4, inst);
    ID_EXE ID_EXE(
        clock,
        wreg,
        m2reg,
        wmem,
        jal,
        aluc,
        aluimm,
        shift,
        dpc4,
        da,
        db,
        dimm,
        drn,
        ewreg,
        em2reg,
        ewmem,
        ejal,
        ealuc,
        ealuimm,
        eshift,
        epc4,
        ea,
        eb,
        eimm,
        ern0
    );
    EXE_MEM EXE_MEM(
        clock,
        ewreg,
        em2reg,
        ewmem,
        ealu,
        eb,
        ern,
        mwreg,
        mm2reg,
        mwmem,
        malu,
        mb,
        mrn
    );
    MEM_WB MEM_WB(
        clock,
        mwreg,
        mm2reg,
        mmo,
        malu,
        mrn,
        wwreg,
        wm2reg,
        wmo,
        walu,
        wrn
    );

    // Instruction Fetch
    NextPCMux NextPCMux(pcsrc, pc4, bpc, da, jpcTotal);
    PCAdder PCAdder(pc, pc4);
    InstructionMemory InstructionMemory(pc, ins);

    // Instruction Decode
    ControlUnit ControlUnit(
        op,
        func,
        rs,
        rt,
        mrn,
        mm2reg,
        mwreg,
        ern,
        em2reg,
        ewreg,
        rsrtequ,
        stall,
        pcsrc,
        wpcir,
        wreg,
        m2reg,
        wmem,
        jal,
        aluc,
        aluimm,
        shift,
        regrt,
        sext,
        fwdb,
        fwda
    );
    JumpAddressShift JumpAddressShift(addr, jpc);
    BranchAddressShift BranchAddressShift(imm, bimm);
    BranchPCAdder BranchPCAdder(dpc4, bimm, bpc);
    RegistryMemory RegistryMemory(
        clock,
        rs,
        rt,
        wwreg,
        wdi,
        wrn,
        qa,
        qb
    );
    ForwardMux ForwardMuxA(
        fwda,
        qa,
        ealu,
        malu,
        mmo
    );
    ForwardMux ForwardMuxB(
        fwdb,
        qb,
        ealu,
        malu,
        mmo
    );
    ALUInEqualCheck ALUInEqualCheck(
        da,
        db,
        rsrtequ
    );
    SignExtension SignExtension(imm, sext, dimm);
    DestinationMux DestinationMux(regrt, rd, rt, drn);

    // Execution
    JALPCAdder JALPCAdder(epc4, epc8);
    ALUShiftMux ALUShiftMux(eshift, sa, ea, a);
    ALUImmediateMux ALUImmediateMux(ealuimm, eimm, eb, b);
    ArithmeticLogicUnit ArithmeticLogicUnit(ealuc, a, b, alu);
    JalALUMux JalALUMux(ejal, epc8, alu, ealu);
    JalDestSwitch JalDestSwitch(ejal, ern0, ern);

    // Execution
    ALUImmediateMux ALUImmediateMux(ealuimm, eqb, eimm, chosenRegister);
    ArithmeticLogicUnit ArithmeticLogicUnit(ealuc, eqa, chosenRegister, aluOut);

    // Memory Access
    DataMemory DataMemory(mwmem, mALU, mdataIn, mdataMemOut);

    // Write Back
    RegWriteMux RegWriteMux(wm2reg, wAlu, wData, wDataWritten);

    always @(*) begin
        // Output assignments
        currentPC = pc;
        savedInstruction = inst;
        // Stall is already assigned
        eregisterWrite = ewreg;
        ememoryToRegister = em2reg;
        ememoryWrite = ewmem;
        ejalInstruction = ejal;
        ealuControl = ealuc;
        ealuImmediate = ealuimm;
        eShiftRegister = eshift;
        enextPC = epc4;
        eregisterQA = ea;
        eregisterQB = eb;
        eimmediateExtended = eimm;
        edestination = ern0;
        mregisterWrite = mwreg;
        mmemoryToRegister = mm2reg;
        mmemoryWrite = mwmem;
        maluOut = malu;
        mloadedRegister = mmo;
        mdestination = mrn;
        wregisterWrite = wwreg;
        wmemoryToRegister = wm2reg;
        wloadedData = wmo;
        waluOut = walu;
        wdestination = wrn;
        wDataWritten = wdi;
    end
endmodule
