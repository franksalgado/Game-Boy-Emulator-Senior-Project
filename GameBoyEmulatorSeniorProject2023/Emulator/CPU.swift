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
    
    //stack pointer and progam counter are both 16 bit registers
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
    
    //current fetch
    //var fetchData: UInt16;
    var memoryDestination: UInt16;
    var destinationIsMemory: Bool;
    var currentOpcode: UInt8;
    var currentInstuction: UnsafeMutableRawPointer;
    //var currentInstruction: UnsafeMutablePointer<Instruction>?;
    var halted: Bool;
    var stepping: Bool;
    var interruptMasterEnable: Bool;
    var enablingIME: Bool;
    var interruptEnableRegister: UInt8;
     init(){
         //fetchData = 0;
         memoryDestination = 0;
         destinationIsMemory = false;
         currentOpcode = 0;
         halted = false;
         stepping = false;
         interruptMasterEnable = false;
         interruptEnableRegister = 0;
    }
}




var CPUStateInstance = CPUState();


func CPUStep(CPUStateInstance: CPUState ) -> Bool{
    if !CPUStateInstance.halted {
        CPUStateInstance.currentOpcode = BusRead(address: CPUStateInstance.registersState.pc);
        CPUStateInstance.registersState.pc+=1;
        //set equal to the function address in Instruction struct at [CPUStateInstance.currentOpcode]
        //CPUStateInstance.currentInstuction =
    }
    return false;
}

func GetInterruptEnableRegister() -> UInt8 {
    return CPUStateInstance.interruptEnableRegister;
}

func SetInterruptEnableRegister(value: UInt8) -> Void {
    CPUStateInstance.interruptEnableRegister = value;
}

//void cou init
//voud cpu step function not implemented yet


//set bits
func SetFlagsRegister(z: UInt8, n: UInt8, h: UInt8, c: UInt8) -> Void {
    var flagsArray: [UInt8] = [z, n, h, c];
    var sum: UInt8 = 7;
    for bit in flagsArray {
        if bit == 1 {
            CPUStateInstance.registersState.f |= (1 << sum);
        }
        else if bit == 0 {
            CPUStateInstance.registersState.f &= ~(1 << sum);
        }
        sum-=1;
    }
}
