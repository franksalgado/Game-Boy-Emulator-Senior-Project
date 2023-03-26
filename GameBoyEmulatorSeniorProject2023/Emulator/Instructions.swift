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
func FetchD16(CPUStateInstance: CPUState) -> UInt16 {
    var lowByte: UInt16 = UInt16(BusRead(address: CPUStateInstance.registersState.pc));
    // emulator cycle
    var highByte: UInt16 = UInt16(BusRead(address: CPUStateInstance.registersState.pc+1));
    // emulator cycle
    CPUStateInstance.registersState.pc += 2;
    return lowByte | (highByte << 8);
}





// Performs no operation 0x00
func NOP() -> Void {
    
}

//0x02
func LDBCA() -> Void {
    // emulator cycles 1
    BusWrite16Bit(address: <#T##UInt16#>, value: CPUStateInstance.registersState.a)
}

// This function increments B register by 1. 0x04
func INCB() -> Void {
    CPUStateInstance.registersState.b += 1;
    var equalToZero: UInt8;
    if CPUStateInstance.registersState.b == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if CPUStateInstance.registersState.b & 0x0F == 0 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2);
}

// This instruction Decrements the B register by 1 0x05
func DECB() -> Void {
    CPUStateInstance.registersState.b -= 1;
    var value = CPUStateInstance.registersState.b;
    var equalToZero: UInt8;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if value & 0x0F == 0x0F {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: 2)
}




// This function increments C register by 1. 0x0C
func INCC() -> Void {
    CPUStateInstance.registersState.c += 1;
    var equalToZero: UInt8;
    if CPUStateInstance.registersState.c == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if CPUStateInstance.registersState.c & 0x0F == 0 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2)
}

// This instruction Decrements the C register by 1 0x0D
func DECC() -> Void {
    CPUStateInstance.registersState.c -= 1;
    var value = CPUStateInstance.registersState.c;
    var equalToZero: UInt8;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if value & 0x0F == 0x0F {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: 2)
}









// This function increments D register by 1. 0x14
func INCD() -> Void {
    CPUStateInstance.registersState.d += 1;
    var equalToZero: UInt8;
    if CPUStateInstance.registersState.d == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if CPUStateInstance.registersState.d & 0x0F == 0 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2)
}

// This instruction Decrements the D register by 1 0x15
func DECD() -> Void {
    CPUStateInstance.registersState.d -= 1;
    var value = CPUStateInstance.registersState.d;
    var equalToZero: UInt8;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if value & 0x0F == 0x0F {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: 2)
}


// This function increments E register by 1. 0x1C
func INCE() -> Void {
    CPUStateInstance.registersState.e += 1;
    var equalToZero: UInt8;
    if CPUStateInstance.registersState.e == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if CPUStateInstance.registersState.e & 0x0F == 0 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2)
}

// This instruction Decrements the E register by 1 0x1D
func DECE() -> Void {
    CPUStateInstance.registersState.e -= 1;
    var value = CPUStateInstance.registersState.e;
    var equalToZero: UInt8;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if value & 0x0F == 0x0F {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: 2)
}





// This function increments H register by 1. 0x24
func INCH() -> Void {
    CPUStateInstance.registersState.h += 1;
    var equalToZero: UInt8;
    if CPUStateInstance.registersState.h == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if CPUStateInstance.registersState.h & 0x0F == 0 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2)
}

// This instruction Decrements the H register by 1 0x25
func DECH() -> Void {
    CPUStateInstance.registersState.h -= 1;
    var value = CPUStateInstance.registersState.h;
    var equalToZero: UInt8;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if value & 0x0F == 0x0F {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: 2)
}

// This function increments L register by 1. 0x2C
func INCL() -> Void {
    CPUStateInstance.registersState.l += 1;
    var equalToZero: UInt8;
    if CPUStateInstance.registersState.l == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if CPUStateInstance.registersState.l & 0x0F == 0 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2)
}

// This instruction Decrements the L register by 1 0x2D
func DECL() -> Void {
    CPUStateInstance.registersState.l -= 1;
    var value = CPUStateInstance.registersState.l;
    var equalToZero: UInt8;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if value & 0x0F == 0x0F {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: 2)
}


// This function increments A register by 1. 0x3C
func INCA() -> Void {
    CPUStateInstance.registersState.a += 1;
    var equalToZero: UInt8;
    if CPUStateInstance.registersState.a == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if CPUStateInstance.registersState.a & 0x0F == 0 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2)
}

// This instruction Decrements the A register by 1 0x3D
func DECA() -> Void {
    CPUStateInstance.registersState.a -= 1;
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8;
    
    if value & 0x0F == 0 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: 2)
}




//Add the value stored in B register to A register. 0x80
func ADDAB() -> Void {
    var halfCarry: UInt8;
    
    if ((CPUStateInstance.registersState.a & 0xF) + (CPUStateInstance.registersState.b & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    var carryFlag: UInt8;
    
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(CPUStateInstance.registersState.b & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    else{
        carryFlag = 0;
    }
    
    CPUStateInstance.registersState.a += CPUStateInstance.registersState.b
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}


//Add the value stored in C register to A register. 0x81
func ADDAC() -> Void {
    var halfCarry: UInt8;
    var add = CPUStateInstance.registersState.c;
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    var carryFlag: UInt8;
    
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    else{
        carryFlag = 0;
    }
    
    CPUStateInstance.registersState.a += add;
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//Add the value stored in D register to A register. 0x82
func ADDAD() -> Void {
    var halfCarry: UInt8;
    var add = CPUStateInstance.registersState.d;
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    var carryFlag: UInt8;
    
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    else{
        carryFlag = 0;
    }
    
    CPUStateInstance.registersState.a += add;
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//Add the value stored in E register to A register. 0x83
func ADDAE() -> Void {
    var halfCarry: UInt8;
    var add = CPUStateInstance.registersState.e;
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    var carryFlag: UInt8;
    
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    else{
        carryFlag = 0;
    }
    
    CPUStateInstance.registersState.a += add;
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//Add the value stored in H register to A register. 0x84
func ADDAH() -> Void {
    var halfCarry: UInt8;
    var add = CPUStateInstance.registersState.h;
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    var carryFlag: UInt8;
    
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    else{
        carryFlag = 0;
    }
    
    CPUStateInstance.registersState.a += add;
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//Add the value stored in L register to A register. 0x85
func ADDAL() -> Void {
    var halfCarry: UInt8;
    var add = CPUStateInstance.registersState.l;
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    else{
        halfCarry = 0;
    }
    
    var carryFlag: UInt8;
    
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    else{
        carryFlag = 0;
    }
    
    CPUStateInstance.registersState.a += add;
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}





// 0xA8 - 0xAD
func XORB() -> Void {
    if CPUStateInstance.registersState.a == CPUStateInstance.registersState.b {
        CPUStateInstance.registersState.a = 0;
        CPUStateInstance.registersState.f = 0b1000000;
    } else {
        CPUStateInstance.registersState.a ^= CPUStateInstance.registersState.b;
        CPUStateInstance.registersState.f = 0;
    }
}

func XORC() -> Void {
    if CPUStateInstance.registersState.a == CPUStateInstance.registersState.c {
        CPUStateInstance.registersState.a = 0;
        CPUStateInstance.registersState.f = 0b1000000;
    } else {
        CPUStateInstance.registersState.a ^= CPUStateInstance.registersState.c;
        CPUStateInstance.registersState.f = 0;
    }
}

func XORD() -> Void {
    if CPUStateInstance.registersState.a == CPUStateInstance.registersState.d {
        CPUStateInstance.registersState.a = 0;
        CPUStateInstance.registersState.f = 0b1000000;
    } else {
        CPUStateInstance.registersState.a ^= CPUStateInstance.registersState.d;
        CPUStateInstance.registersState.f = 0;
    }
}

func XORE() -> Void {
    if CPUStateInstance.registersState.a == CPUStateInstance.registersState.e {
        CPUStateInstance.registersState.a = 0;
        CPUStateInstance.registersState.f = 0b1000000;
    } else {
        CPUStateInstance.registersState.a ^= CPUStateInstance.registersState.e;
        CPUStateInstance.registersState.f = 0;
    }
}

func XORH() -> Void {
    if CPUStateInstance.registersState.a == CPUStateInstance.registersState.h {
        CPUStateInstance.registersState.a = 0;
        CPUStateInstance.registersState.f = 0b1000000;
    } else {
        CPUStateInstance.registersState.a ^= CPUStateInstance.registersState.h;
        CPUStateInstance.registersState.f = 0;
    }
}

func XORL() -> Void {
    if CPUStateInstance.registersState.a == CPUStateInstance.registersState.l {
        CPUStateInstance.registersState.a = 0;
        CPUStateInstance.registersState.f = 0b1000000;
    } else {
        CPUStateInstance.registersState.a ^= CPUStateInstance.registersState.l;
        CPUStateInstance.registersState.f = 0;
    }
}


// XOR the value at register A by itself. This always results in 0 so I just hard coded it to always be 0. It also resets the flags register. 0xAF
func XORA() -> Void {
    CPUStateInstance.registersState.a = 0;
    //CPUStateInstance.registersState.a ^= CPUStateInstance.registersState.a & 0xFF;
    CPUStateInstance.registersState.f = 0b1000000;
}

//Jump To Address A16 If Z Flag Is Reset 0xC2
func JPNZa16() -> Void {
    //TODO
}

// Jump to address a16 0xC3
func JPa16() -> Void {
    CPUStateInstance.registersState.pc = FetchD16(CPUStateInstance: CPUStateInstance);
    //emulator cycle
    
}


