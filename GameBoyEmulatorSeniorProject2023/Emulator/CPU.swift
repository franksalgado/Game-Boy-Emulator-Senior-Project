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
    
    //stack pointer and register counter are both 16 bit registers
    var sp: UInt16;
    var pc: UInt16;
    init() {
        //find better way to do this;(
        a = 0x01;
        f = 0;
        b = 0;
        c = 0;
        d = 0;
        e = 0;
        h = 0;
        l = 0;
        sp = 0;
        pc = 0x100;
    }
    
}

struct CPUContext {
    var registersState = CPURegisters();
    
    //current fetch
    var fetchData: UInt16;
    var memoryDestination: UInt16;
    var destinationIsMemory: Bool;
    var currentOpcode: UInt8;
    
    var currentInstruction: UnsafeMutablePointer<Instruction>?;
    var halted: Bool;
    var stepping: Bool;
    var intMasterEnabled: Bool;
    /* init(){
    fetchData: 0, memoryDestination: 0, currentOpcode: 0, currentInstruction: NULL, halted: false, stepping: false
    }*/
}




var Context = CPUContext(fetchData: 0, memoryDestination: 0, currentOpcode: 0, halted: false, stepping: false);
func CPUInitialze() {

}

func CPUStep {
    
}

func CPUReadRegister(RegisterType: RegisterType) -> UInt16 {
    
}

//void cou init
//voud cpu step function not implemented yet
