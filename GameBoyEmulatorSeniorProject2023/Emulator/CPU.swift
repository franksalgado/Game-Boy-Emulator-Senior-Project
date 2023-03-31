//
//  CPU.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 1/1/23.
//

import Foundation

struct CPURegisters {
    //a is accumulator register, f is flag register
    var a: UInt8;
    var f: UInt8;
    
    var b: UInt8;
    var c: UInt8;
    
    var d: UInt8;
    var e: UInt8;
    
    var h: UInt8;
    var l: UInt8;
    
    //stack pointer and progam counter
    var sp: UInt16;
    var pc: UInt16;
    init() {
        a = 0x01;
        f = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        h = 0;
        l = 0;
        sp = 0xFFFE;
        pc = 0x100;
    }
    
}
//class to be mutable and contain same values inside and outide of classes;)
class CPUState {
    var registersState = CPURegisters();
    var currentOpcode: UInt8;
    var halted: Bool;
    var stepping: Bool;
    var interruptMasterEnable: Bool;
    var enablingIME: Bool;
    var interruptEnableRegister: UInt8;
     init(){
         currentOpcode = 0;
         halted = false;
         stepping = false;
         interruptMasterEnable = false;
         enablingIME = false;
         interruptEnableRegister = 0;
    }
}
var CPUStateInstance = CPUState();

func CPUStep(CPUStateInstance: CPUState ) -> Bool{
    if !CPUStateInstance.halted {
        CPUStateInstance.currentOpcode = BusRead(address: CPUStateInstance.registersState.pc);
        CPUStateInstance.registersState.pc+=1;
        InstructionsTable[Int(CPUStateInstance.currentOpcode)].instructionFunction();
    }
    return false;
}

func GetInterruptEnableRegister() -> UInt8 {
    return CPUStateInstance.interruptEnableRegister;
}

func SetInterruptEnableRegister(value: UInt8) -> Void {
    CPUStateInstance.interruptEnableRegister = value;
}
