//
//  Instructions.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 1/2/23.
//

import Foundation


struct Instruction {
    var name: String;
    //returns void. Pointer to address when called this function will execute
    var instructionFunction:
    /*
    init() {
        instructionType = InstructionType.IN_NOP;
        addressMode = AddressMode.AM_IMP;
        registerOne = RegisterType.RT_NONE;
        registerTwo = RegisterType.RT_NONE;
        condition = ConditionType.CT_NONE;
        parameter = 0;
    }
     */
}
//https://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html
//This is an array containing every Game Boy CPU instruction. Position is according to the table found at the site above
func GenerateOpcodes() -> [Instruction] {
    var table = Array(repeating: Instruction(), count: 0x100)
    table[0x00] = Instruction(name: "NOP", instructionFunction: <#T##_#>);
    
    table[0x01] =
    
    return table;
}

var InstructionsTable = GenerateOpcodes();


//maybe delete
/*
func InstructionByOpcode(opcode: UInt8) -> UnsafeMutablePointer<Instruction> {
    let addressOfInstruction = UnsafeMutablePointer<Instruction>.allocate(capacity: 1);
    addressOfInstruction.initialize(to: InstructionsTable[Int(opcode)]);
    return addressOfInstruction;
}
 */

//Data fetching instructions
//Fetch 16 bit address to jump to. Since 8 bit value is stored at an address we have to combine the two bytes by
func FetchD16(CPUContextInstance: CPUContext) -> UInt16 {
    var lowByte: UInt16 = UInt16(BusRead(address: CPUContextInstance.registersState.pc));
    emulator cycle
    var highByte: UInt16 = UInt16(BusRead(address: CPUContextInstance.registersState.pc+1));
    emulator cycle
    CPUContextInstance.registersState.pc+=2;
    return lowByte | (highByte << 8);
}











//Performs no operation
func NOP(CPUContextInstance: CPUContext) -> Void {
    
}
// This instruction Decrements the B register by 1 0x05
func DecB(CPUContextInstance: CPUContext) -> Void {
    //We may fetch data from a 16 bit register. In this case we are fetching from an 8 bit register so we have to convert to UInt16. fetchdata is of type UInt16
    CPUContextInstance.fetchData = UInt16(CPUContextInstance.registersState.b);
    
    TODO
}

//
func LDBCA(CPUContextInstance: CPUContext) -> Void {
    
    emulator cycles 1
    buswrite16
    
}


func XORB(CPUContextInstance: CPUContext) -> Void {
    if CPUContextInstance.registersState.a == CPUContextInstance.registersState.b {
        CPUContextInstance.registersState.a = 0;
        CPUContextInstance.registersState.f = 0b1000000;
    } else {
        CPUContextInstance.registersState.a ^= CPUContextInstance.registersState.b;
        CPUContextInstance.registersState.f = 0;
    }
}

func XORC(CPUContextInstance: CPUContext) -> Void {
    if CPUContextInstance.registersState.a == CPUContextInstance.registersState.c {
        CPUContextInstance.registersState.a = 0;
        CPUContextInstance.registersState.f = 0b1000000;
    } else {
        CPUContextInstance.registersState.a ^= CPUContextInstance.registersState.c;
        CPUContextInstance.registersState.f = 0;
    }
}

func XORD(CPUContextInstance: CPUContext) -> Void {
    if CPUContextInstance.registersState.a == CPUContextInstance.registersState.d {
        CPUContextInstance.registersState.a = 0;
        CPUContextInstance.registersState.f = 0b1000000;
    } else {
        CPUContextInstance.registersState.a ^= CPUContextInstance.registersState.d;
        CPUContextInstance.registersState.f = 0;
    }
}

func XORE(CPUContextInstance: CPUContext) -> Void {
    if CPUContextInstance.registersState.a == CPUContextInstance.registersState.e {
        CPUContextInstance.registersState.a = 0;
        CPUContextInstance.registersState.f = 0b1000000;
    } else {
        CPUContextInstance.registersState.a ^= CPUContextInstance.registersState.e;
        CPUContextInstance.registersState.f = 0;
    }
}

func XORH(CPUContextInstance: CPUContext) -> Void {
    if CPUContextInstance.registersState.a == CPUContextInstance.registersState.h {
        CPUContextInstance.registersState.a = 0;
        CPUContextInstance.registersState.f = 0b1000000;
    } else {
        CPUContextInstance.registersState.a ^= CPUContextInstance.registersState.h;
        CPUContextInstance.registersState.f = 0;
    }
}

func XORL(CPUContextInstance: CPUContext) -> Void {
    if CPUContextInstance.registersState.a == CPUContextInstance.registersState.l {
        CPUContextInstance.registersState.a = 0;
        CPUContextInstance.registersState.f = 0b1000000;
    } else {
        CPUContextInstance.registersState.a ^= CPUContextInstance.registersState.l;
        CPUContextInstance.registersState.f = 0;
    }
}

// XOR the value at register A by itself. This always results in 0 so I just hard coded it to always be 0. It also resets the flags register. 0xAF
func XORA(CPUContextInstance: CPUContext) -> Void {
    CPUContextInstance.registersState.a = 0;
    //CPUContextInstance.registersState.a ^= CPUContextInstance.registersState.a & 0xFF;
    CPUContextInstance.registersState.f = 0b1000000;
}


//Jump To Address A16 If Z Flag Is Reset 0xC2
func JPNZa16(CPUContextInstance: CPUContext) -> Void {
    TODO
}

// Jump to address a16 0xC3
func JPa16(CPUContextInstance: CPUContext) -> Void {
    CPUContextInstance.registersState.pc = FetchD16(CPUContextInstance: CPUContextInstance);
    emulator cycle
    
}







