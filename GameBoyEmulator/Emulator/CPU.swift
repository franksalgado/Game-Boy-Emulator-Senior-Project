//
//  CPU.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 1/1/23.
//

import Foundation

struct CpuRegisters {
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
    
}

struct CpuContext {
    var fetchData: UInt16;
    var memoryDestination: UInt16;
    var h: UInt8;
}
