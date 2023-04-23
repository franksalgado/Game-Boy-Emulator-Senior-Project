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
        f = 0xB0;
        b = 0b10110000;
        c = 0x13;
        d = 0;
        e = 0xD8;
        h = 0x01;
        l = 0x4d;
        sp = 0xFFFE;
        pc = 0x100;
    }
    
}
//class to be mutable and contain same values inside and outide of classes
class CPUState {
    var registersState = CPURegisters();
    var currentOpcode: UInt8;
    var halted: Bool;
    var stepping: Bool;
    var interruptMasterEnable: Bool;
    var enablingIME: Bool;
    var interruptEnableRegister: UInt8;
    var interruptFlags: UInt8;
    let InstructionsTable = GenerateOpcodes();
     init(){
         currentOpcode = 0;
         halted = false;
         stepping = false;
         interruptMasterEnable = false;
         enablingIME = false;
         interruptEnableRegister = 0;
         interruptFlags = 0;
    }
}
var CPUStateInstance = CPUState();
extension CPUState {
    func CPUStep() -> Bool{
        if !self.halted {
            self.currentOpcode = BusRead(address: self.registersState.pc);
            EmulatorCycles(CPUCycles: 1);
            self.registersState.pc += 1;
            //TestRomWrite();
            //TestRomRead();
            self.InstructionsTable[Int(self.currentOpcode)].instructionFunction();
        }
        else {
            EmulatorCycles(CPUCycles: 1);
            if self.interruptFlags != 0 {
                self.halted = false;
            }
        }
        if self.interruptMasterEnable {
            CPUHandleInterrupts();
            self.enablingIME = false;
        }
        if self.enablingIME {
            self.interruptMasterEnable = true;
        }
        return true;
    }
}


func GetInterruptEnableRegister() -> UInt8 {
    return CPUStateInstance.interruptEnableRegister;
}

func SetInterruptEnableRegister(value: UInt8) -> Void {
    CPUStateInstance.interruptEnableRegister = value;
}

func GetInterruptFlags() -> UInt8 {
    return CPUStateInstance.interruptFlags;
}

func SetInterruptFlags(value: UInt8) -> Void {
    CPUStateInstance.interruptFlags = value;
}

func RequestInterrupt(InterruptTypes: InterruptTypes) {
    CPUStateInstance.interruptFlags |= InterruptTypes.rawValue;
}
