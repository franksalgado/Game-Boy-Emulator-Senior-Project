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
    //var instructionFunction:
    /*
    init() {
     
    }
     */
}
//https://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html
//This is an array containing every Game Boy CPU instruction. Position is according to the table found at the site above
/*
func GenerateOpcodes() -> [Instruction] {
    var table = Array(repeating: Instruction(), count: 0x100)
    table[0x00] = Instruction(name: "NOP", instructionFunction: <#T##_#>);
    
    table[0x01] =
    
    return table;
}

var InstructionsTable = GenerateOpcodes();
*/

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
func FetchD16() -> UInt16 {
    var lowByte: UInt16 = UInt16(BusRead(address: CPUStateInstance.registersState.pc));
    // emulator cycle
    var highByte: UInt16 = UInt16(BusRead(address: CPUStateInstance.registersState.pc+1));
    // emulator cycle
    CPUStateInstance.registersState.pc += 2;
    return lowByte | (highByte << 8);
}



func IsZFlagSet() -> Bool {
    if CPUStateInstance.registersState.f & (1 << 7) == (1 << 7) {
        return true;
    }
    return false;
}

func IsNFlagSet() -> Bool {
    if CPUStateInstance.registersState.f & (1 << 6) == (1 << 6) {
        return true;
    }
    return false;
}

func IsHFlagSet() -> Bool {
    if CPUStateInstance.registersState.f & (1 << 5) == (1 << 5) {
        return true;
    }
    return false;
}

func IsCFlagSet() -> Bool {
    if CPUStateInstance.registersState.f & (1 << 4) == (1 << 4) {
        return true;
    }
    return false;
}

func GetBCRegister() -> UInt16 {
    var lowByte: UInt16 = UInt16(CPUStateInstance.registersState.c);

    var highByte: UInt16 = UInt16(CPUStateInstance.registersState.b);

    CPUStateInstance.registersState.pc += 2;
    return lowByte | (highByte << 8);
}

func SetBCRegister(value: UInt16) -> Void {
    CPUStateInstance.registersState.c = UInt8(value & 0xFF);
    CPUStateInstance.registersState.b = UInt8((value >> 8) & 0xFF);
}

// GetAFRegister - Gets the value of the AF register
func GetAFRegister() -> UInt16 {
    var lowByte: UInt16 = UInt16(CPUStateInstance.registersState.f);
    var highByte: UInt16 = UInt16(CPUStateInstance.registersState.a);
    CPUStateInstance.registersState.pc += 2;
    return lowByte | (highByte << 8);
}

// SetAFRegister - Sets the value of the AF register
func SetAFRegister(value: UInt16) -> Void {
    CPUStateInstance.registersState.f = UInt8(value & 0xFF);
    CPUStateInstance.registersState.a = UInt8((value >> 8) & 0xFF);
}

// GetHLRegister - Gets the value of the HL register
func GetHLRegister() -> UInt16 {
    var lowByte: UInt16 = UInt16(CPUStateInstance.registersState.l);
    var highByte: UInt16 = UInt16(CPUStateInstance.registersState.h);
    CPUStateInstance.registersState.pc += 2;
    return lowByte | (highByte << 8);
}

// SetHLRegister - Sets the value of the HL register
func SetHLRegister(value: UInt16) -> Void {
    CPUStateInstance.registersState.l = UInt8(value & 0xFF);
    CPUStateInstance.registersState.h = UInt8((value >> 8) & 0xFF);
}

// GetDERegister - Gets the value of the DE register
func GetDERegister() -> UInt16 {
    var lowByte: UInt16 = UInt16(CPUStateInstance.registersState.e);
    var highByte: UInt16 = UInt16(CPUStateInstance.registersState.d);
    CPUStateInstance.registersState.pc += 2;
    return lowByte | (highByte << 8);
}

// SetDERegister - Sets the value of the DE register
func SetDERegister(value: UInt16) -> Void {
    CPUStateInstance.registersState.e = UInt8(value & 0xFF);
    CPUStateInstance.registersState.d = UInt8((value >> 8) & 0xFF);
}





// Performs no operation 0x00
func NOP() -> Void {
    
}

//0x01
func LDBCd16() -> Void {
    SetBCRegister(value: FetchD16());
}

//0x02
func LDBCA() -> Void {
    BusWrite(address: GetBCRegister(), value: CPUStateInstance.registersState.a)
    // emulator cycles 1
}

//0x03
func INCBC() -> Void {
    var value = GetBCRegister() + 1;
    SetBCRegister(value: value);
    //emulator cycle
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

//0x06
func LDBd8() -> Void {
    CPUStateInstance.registersState.b = BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cycles
    CPUStateInstance.registersState.pc+=1;
}

//0x07 change for prefix cb to be reused
func RLCA() -> Void {
    var carryFlag: UInt8 = 0;
    if CPUStateInstance.registersState.a & (1 << 7) == (1 << 7) {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a = (CPUStateInstance.registersState.a << 1)
    if carryFlag == 1 {
        CPUStateInstance.registersState.a |= 1;
    }
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.a == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero, n: 0, h: 0, c: carryFlag);
}

//0x08
func LDa16SP() -> Void {
    BusWrite16Bit(address: FetchD16(), value: CPUStateInstance.registersState.sp);
    //emu cyc
    //emu cyc
}

//0x09 0x19 0x29 0x39
func ADDHLnn(_ CPUStateInstance: CPUState, _ register: UInt16) -> Void {
    var value = GetHLRegister() + register;
    var halfCarry: UInt8 = 0;
    var carryFlag: UInt8 = 0;
    if (GetHLRegister() & 0xFFF) + (register & 0xFFF) >= 0x1000 {
        halfCarry = 1;
    }
    if UInt32(GetHLRegister()) + UInt32(register) >= 0x10000 {
        carryFlag = 1;
    }
    //emu cyc
    SetHLRegister(value: value);
    SetFlagsRegister(z: 2, n: 0, h: halfCarry, c: carryFlag);
}

//0x0A 0x1A 0x2A 0x3A
func LDAnn(_ CPUStateInstance: CPUState, _ register: UInt16) -> Void {
    CPUStateInstance.registersState.a = BusRead(address: register);
    //emu cyc
    if CPUStateInstance.currentOpcode == 0x2A {
        let value = register + 1;
        SetHLRegister(value: value);
    }
    if CPUStateInstance.currentOpcode == 0x3A {
        let value = register - 1;
        SetHLRegister(value: value);
    }
}

//0x0B
func DECBC() -> Void {
    var value = GetBCRegister() - 1;
    SetBCRegister(value: value);
    //emulator cycle
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

//0x0E
func LDCd8() -> Void {
    CPUStateInstance.registersState.c = BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cycles
    CPUStateInstance.registersState.pc+=1;
}

func STOP0() -> Void {
    print("stopping")
    exit(-5);
}



//0x0F Rotate A right. Old bit 0 to Carry flag.
func RRCA() -> Void {
    var carryFlag: UInt8 = 0;
    if CPUStateInstance.registersState.a & 1 == 1 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a >>= 1;
    if carryFlag == 1 {
        CPUStateInstance.registersState.a |= (1 << 7);
    }
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.a == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero, n: 0, h: 0, c: carryFlag);
}
//0x11
func LDDEd16() -> Void {
    SetDERegister(value: FetchD16());
}

//0x12
func LDDEA() -> Void {
    BusWrite(address: GetDERegister(), value: CPUStateInstance.registersState.a)
    // emulator cycles 1
}

//0x13
func INCDE() -> Void {
    var value = GetDERegister() + 1;
    SetDERegister(value: value);
    //emulator cycle
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

//0x16
func LDDd8() -> Void {
    CPUStateInstance.registersState.d = BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cycles
    CPUStateInstance.registersState.pc+=1;
}

//0x17
func RLA() -> Void {
    var carryFlag: UInt8 = CPUStateInstance.registersState.a & (1 << 7);
    CPUStateInstance.registersState.a <<= 1;
    if IsCFlagSet() {
        //carryFlag = 1;
        CPUStateInstance.registersState.a |= 1;
    }
    SetFlagsRegister(z: 0, n: 0, h: 0, c: carryFlag);

}

//0x18 Add BusRead(address: CPUStateInstance.registersState.pc) to pc address and jump to it. convert to signed 8 bit immediate value
func JRr8() -> Void {
    var fetchedData = BusRead(address: CPUStateInstance.registersState.pc);
    CPUStateInstance.registersState.pc += 1
    //emu cyc
    CPUStateInstance.registersState.pc += UInt16(Int8(fetchedData));
    //emu cyc
}

//0x1B
func DECDE() -> Void {
    var value = GetDERegister() - 1;
    SetDERegister(value: value);
    //emulator cycle
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

//0x1E
func LDEd8() -> Void {
    CPUStateInstance.registersState.e = BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cycles
    CPUStateInstance.registersState.pc+=1;
}

//0x1F
func RRA() -> Void {
    var carryFlag: UInt8 = CPUStateInstance.registersState.a & 1;
    CPUStateInstance.registersState.a >>= 1;
    if IsCFlagSet() {
        //carryFlag = 1;
        CPUStateInstance.registersState.a |= (1 << 7);
    }
    SetFlagsRegister(z: 0, n: 0, h: 0, c: carryFlag);
    
}

//0x20 Add BusRead(address: CPUStateInstance.registersState.pc) to pc address and jump to it. convert to signed 8 bit immediate value
func JRNZr8() -> Void {
    var fetchedData = BusRead(address: CPUStateInstance.registersState.pc);
    CPUStateInstance.registersState.pc += 1
    //emu cyc
    if !IsZFlagSet() {
        CPUStateInstance.registersState.pc += UInt16(Int8(fetchedData));
        //emu cyc
    }
}

//0x21
func LDHLd16() -> Void {
    SetHLRegister(value: FetchD16());
}

//0x22
func LDHLIncA() -> Void {
    BusWrite(address: GetHLRegister(), value: CPUStateInstance.registersState.a)
    // emulator cycles 1
    let value = GetHLRegister() + 1;
           SetHLRegister(value: value);
}

//0x23
func INCHL() -> Void {
    var value = GetHLRegister() + 1;
    SetHLRegister(value: value);
    //emulator cycle
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

//0x26
func LDHd8() -> Void {
    CPUStateInstance.registersState.h = BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cycles
    CPUStateInstance.registersState.pc+=1;
}

//0x27
func DAA() -> Void {
    var u: UInt8 = 0
    var carryFlag: UInt8 = 0;
    var equalToZero: UInt8 = 0;
    if IsHFlagSet() || (!IsNFlagSet() && (CPUStateInstance.registersState.a & 0xF) > 9) {
            u = 6;
        }

    if IsCFlagSet() || (!IsNFlagSet() && CPUStateInstance.registersState.a > 0x99) {
        u |= 0x60;
        carryFlag = 1;
    }
    if IsNFlagSet() {
        CPUStateInstance.registersState.a -= u;
    }
    else {
        CPUStateInstance.registersState.a += u;
    }
    if CPUStateInstance.registersState.a == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero, n: 2, h: 0, c: carryFlag)
}

//0x28 Add BusRead(address: CPUStateInstance.registersState.pc) to pc address and jump to it. convert to signed 8 bit immediate value
func JRZr8() -> Void {
    var fetchedData = BusRead(address: CPUStateInstance.registersState.pc);
    CPUStateInstance.registersState.pc += 1
    //emu cyc
    if IsZFlagSet() {
        CPUStateInstance.registersState.pc += UInt16(Int8(fetchedData));
        //emu cyc
    }
}

//0x2B
func DECHL() -> Void {
    var value = GetHLRegister() - 1;
    SetHLRegister(value: value);
    //emulator cycle
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

//0x2E
func LDLd8() -> Void {
    CPUStateInstance.registersState.l = BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cycles
    CPUStateInstance.registersState.pc+=1;
}

//0x2F. This is the complement of A register
func CPL() -> Void {
    CPUStateInstance.registersState.a = ~CPUStateInstance.registersState.a;
}

//0x30 Add BusRead(address: CPUStateInstance.registersState.pc) to pc address and jump to it. convert to signed 8 bit immediate value
func JRNCr8() -> Void {
    var fetchedData = BusRead(address: CPUStateInstance.registersState.pc);
    CPUStateInstance.registersState.pc += 1
    //emu cyc
    if !IsCFlagSet() {
        CPUStateInstance.registersState.pc += UInt16(Int8(fetchedData));
        //emu cyc
    }
}
//0x31
func LDSPa16() -> Void {
    CPUStateInstance.registersState.sp = FetchD16();
    //emu cyc
}

//0x32
func LDHLDecA() -> Void {
    BusWrite(address: GetHLRegister(), value: CPUStateInstance.registersState.a)
    // emulator cycles 1
    let value = GetHLRegister() - 1;
           SetHLRegister(value: value);
}

//0x33
func INCSP() -> Void {
    CPUStateInstance.registersState.sp += 1;
}

//0x37 Set carry flag
func SCF() -> Void {
    SetFlagsRegister(z: 2, n: 0, h: 0, c: 1);
}

//0x38 Add BusRead(address: CPUStateInstance.registersState.pc) to pc address and jump to it. convert to signed 8 bit immediate value
func JRCr8() -> Void {
    var fetchedData = BusRead(address: CPUStateInstance.registersState.pc);
    CPUStateInstance.registersState.pc += 1
    //emu cyc
    if IsCFlagSet() {
        CPUStateInstance.registersState.pc += UInt16(Int8(fetchedData));
        //emu cyc
    }
}

// This instruction Decrements the stack pointer register by 1 0x3B
func DECSP() -> Void {
    CPUStateInstance.registersState.sp -= 1;
    //emulator cycles
    var value = CPUStateInstance.registersState.sp;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    var halfCarry: UInt8 = 0;
    
    if value & 0x0F == 0x0F {
        halfCarry = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: 2);
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
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2);
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
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: 2);
}

//0x3E
func LDAd8() -> Void {
    CPUStateInstance.registersState.a = BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cycles
    CPUStateInstance.registersState.pc+=1;
}

//0x3F This instruction complements the carry flag.
func CCF() -> Void {
    var carryFlag: UInt8 = 1;
    if IsCFlagSet() {
        carryFlag = 0;
    }
    SetFlagsRegister(z: 2, n: 0, h: 0, c: carryFlag);
}

//Put the value of B into into B register 0x40
func LDBB() -> Void {
    CPUStateInstance.registersState.b = CPUStateInstance.registersState.b;
}

//Put the value of C into into B register 0x41
func LDBC() -> Void {
    CPUStateInstance.registersState.b = CPUStateInstance.registersState.c;
}

//Put the value of D into into B register 0x42
func LDBD() -> Void {
    CPUStateInstance.registersState.b = CPUStateInstance.registersState.d;
}

//Put the value of E into into B register 0x43
func LDBE() -> Void {
    CPUStateInstance.registersState.b = CPUStateInstance.registersState.e;
}

//Put the value of H into into B register 0x44
func LDBEH() -> Void {
    CPUStateInstance.registersState.b = CPUStateInstance.registersState.h;
}

//Put the value of L into into B register 0x45
func LDBL() -> Void {
    CPUStateInstance.registersState.b = CPUStateInstance.registersState.l;
}

//Put the value of A into into B register 0x47
func LDBA() -> Void {
    CPUStateInstance.registersState.b = CPUStateInstance.registersState.a;
}

//Put the value of B into into C register 0x48
func LDCB() -> Void {
    CPUStateInstance.registersState.c = CPUStateInstance.registersState.b;
}

// Put the value of C into C register 0x49
func LDCC() -> Void {
    CPUStateInstance.registersState.c = CPUStateInstance.registersState.c;
}


// Put the value of D into C register 0x4A
func LDCD() -> Void {
    CPUStateInstance.registersState.c = CPUStateInstance.registersState.d;
}

// Put the value of E into C register 0x4B
func LDCE() -> Void {
    CPUStateInstance.registersState.c = CPUStateInstance.registersState.e;
}

// Put the value of H into C register 0x4C
func LDCH() -> Void {
    CPUStateInstance.registersState.c = CPUStateInstance.registersState.h;
}

// Put the value of L into C register 0x4D
func LDCL() -> Void {
    CPUStateInstance.registersState.c = CPUStateInstance.registersState.l;
}
// 0x4E
func LDCHL() -> Void {
    CPUStateInstance.registersState.c = BusRead(address: GetHLRegister());
    //emu cyc
}

// Put the value of A into C register 0x4F
func LDCA() -> Void {
    CPUStateInstance.registersState.c = CPUStateInstance.registersState.a;
}

// Put the value of B into D register 0x50
func LDDB() -> Void {
    CPUStateInstance.registersState.d = CPUStateInstance.registersState.b;
}

// Put the value of C into D register 0x51
func LDDC() -> Void {
    CPUStateInstance.registersState.d = CPUStateInstance.registersState.c;
}

// Put the value of D into D register 0x52
func LDDD() -> Void {
    CPUStateInstance.registersState.d = CPUStateInstance.registersState.d;
}

// Put the value of E into D register 0x53
func LDDE() -> Void {
    CPUStateInstance.registersState.d = CPUStateInstance.registersState.e;
}

// Put the value of H into D register 0x54
func LDDH() -> Void {
    CPUStateInstance.registersState.d = CPUStateInstance.registersState.h;
}

// Put the value of L into D register 0x55
func LDDL() -> Void {
    CPUStateInstance.registersState.d = CPUStateInstance.registersState.l;
}

// Put the value of A into D register 0x57
func LDDA() -> Void {
    CPUStateInstance.registersState.d = CPUStateInstance.registersState.a;
}

// Put the value of B into E register 0x58
func LDEB() -> Void {
    CPUStateInstance.registersState.e = CPUStateInstance.registersState.b;
}

// Put the value of C into E register 0x59
func LDEC() -> Void {
    CPUStateInstance.registersState.e = CPUStateInstance.registersState.c;
}

// Put the value of D into E register 0x5A
func LDED() -> Void {
    CPUStateInstance.registersState.e = CPUStateInstance.registersState.d;
}

// Put the value of E into E register 0x5B
func LDEE() -> Void {
    CPUStateInstance.registersState.e = CPUStateInstance.registersState.e;
}

// Put the value of H into E register 0x5C
func LDEH() -> Void {
    CPUStateInstance.registersState.e = CPUStateInstance.registersState.h;
}

// Put the value of L into E register 0x5D
func LDEL() -> Void {
    CPUStateInstance.registersState.e = CPUStateInstance.registersState.l;
}

//0x5E
func LDEHL() -> Void {
    CPUStateInstance.registersState.e = BusRead(address: GetHLRegister());
    //emu cyc
}

// Put the value of A into E register 0x5F
func LDEA() -> Void {
    CPUStateInstance.registersState.e = CPUStateInstance.registersState.a;
}

// Put the value of B into H register 0x60
func LDHB() -> Void {
    CPUStateInstance.registersState.h = CPUStateInstance.registersState.b;
}

// Put the value of C into H register 0x61
func LDHC() -> Void {
    CPUStateInstance.registersState.h = CPUStateInstance.registersState.c;
}

// Put the value of D into H register 0x62
func LDHD() -> Void {
    CPUStateInstance.registersState.h = CPUStateInstance.registersState.d;
}

// Put the value of E into H register 0x63
func LDHE() -> Void {
    CPUStateInstance.registersState.h = CPUStateInstance.registersState.e;
}

// Put the value of H into H register 0x64
func LDHH() -> Void {
    CPUStateInstance.registersState.h = CPUStateInstance.registersState.h;
}


// Put the value of L into H register 0x65
func LDHL() -> Void {
    CPUStateInstance.registersState.h = CPUStateInstance.registersState.l;
}

// Put the value of A into H register 0x67
func LDHA() -> Void {
    CPUStateInstance.registersState.h = CPUStateInstance.registersState.a;
}


// Put the value of B into L register 0x68
func LDLB() -> Void {
    CPUStateInstance.registersState.l = CPUStateInstance.registersState.b;
}

// Put the value of C into L register 0x69
func LDLC() -> Void {
    CPUStateInstance.registersState.l = CPUStateInstance.registersState.c;
}

// Put the value of D into L register 0x6A
func LDLD() -> Void {
    CPUStateInstance.registersState.l = CPUStateInstance.registersState.d;
}

// Put the value of E into L register 0x6B
func LDLE() -> Void {
    CPUStateInstance.registersState.l = CPUStateInstance.registersState.e;
}

// Put the value of H into L register 0x6C
func LDLH() -> Void {
    CPUStateInstance.registersState.l = CPUStateInstance.registersState.h;
}

// Put the value of L into L register 0x6D
func LDLL() -> Void {
    CPUStateInstance.registersState.l = CPUStateInstance.registersState.l;
}

//0x6E
func LDLHL() -> Void {
    CPUStateInstance.registersState.l = BusRead(address: GetHLRegister());
    //emu cyc
}
// Put the value of A into L register 0x6F
func LDLA() -> Void {
    CPUStateInstance.registersState.l = CPUStateInstance.registersState.a;
}

//0x70-0x75, 0x77
func LDHLn(_ CPUStateInstance: CPUState, _ register: UInt8) {
    BusWrite(address: GetHLRegister(), value: register);
    //emu cyc
}


//Halts CPU until an interrput occurs 0x76
func HALT() -> Void {
    CPUStateInstance.halted = true;
}


//Put the value of B into into A register 0x78
func LDAB() -> Void {
    CPUStateInstance.registersState.a = CPUStateInstance.registersState.b;
}

//Put the value of C into into A register 0x79
func LDAC() -> Void {
    CPUStateInstance.registersState.a = CPUStateInstance.registersState.c;
}

//Put the value of D into A register 0x7A
func LDAD() -> Void {
    CPUStateInstance.registersState.a = CPUStateInstance.registersState.d;
}

//Put the value of E into A register 0x7B
func LDAE() -> Void {
    CPUStateInstance.registersState.a = CPUStateInstance.registersState.e;
}

//Put the value of H into A register 0x7C
func LDAH() -> Void {
    CPUStateInstance.registersState.a = CPUStateInstance.registersState.h;
}

//Put the value of L into A register 0x7D
func LDAL() -> Void {
    CPUStateInstance.registersState.a = CPUStateInstance.registersState.l;
}

//0x7E
func LDAHL() -> Void {
    CPUStateInstance.registersState.a = BusRead(address: GetHLRegister());
    //emu cyc
}

//Put the value of A into A register 0x7F
func LDAA() -> Void {
    CPUStateInstance.registersState.a = CPUStateInstance.registersState.a;
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
    
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
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
    
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
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
    
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
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
    
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
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
    
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
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
    
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
}

//0x86
func ADDAHL() -> Void {
    var halfCarry: UInt8;
    var add = BusRead(address: GetHLRegister());
    //emu cyc
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
    
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
}

//Add the value stored in A register to A register. 0x87
func ADDAA() -> Void {
    var halfCarry: UInt8;
    var add = CPUStateInstance.registersState.a;
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
    
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
}




//0x88-0x8D. 0x8E 0x8F, 0xCE
func ADCAb8Bit(_ CPUStateInstance: CPUState, add: UInt8) -> Void {
    var halfCarry: UInt8 = 0;
    var carryFlag: UInt8 = 0;
    //var add = CPUStateInstance.registersState.d;
    var carryFlagValue: UInt8 = (1 << 4);
    
    if  CPUStateInstance.registersState.f & carryFlagValue != carryFlagValue{
        carryFlagValue = 0;
    }
    
    if (CPUStateInstance.registersState.a & 0xF) +
        (add & 0xF) + carryFlagValue > 0xF {
        halfCarry = 1;
    }
    
    if (Int(CPUStateInstance.registersState.a) + Int(add) + Int(carryFlagValue))  > 0xFF {
        carryFlag = 1;
    }
    
    CPUStateInstance.registersState.a +=  add + carryFlagValue;
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.a == 0 {
        equalToZero = 1;
    }
    
    SetFlagsRegister(z: equalToZero, n: 0, h: halfCarry, c: carryFlag);
}



//Subtract the value stored in B register from value in A register. 0x90
func SUBB() -> Void {
    var halfCarry: UInt8 = 0;
    var subtract = CPUStateInstance.registersState.b;
    
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    CPUStateInstance.registersState.a -= subtract;
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}


//Subtract the value stored in C register from value in A register. 0x91
func SUBC() -> Void {
    var halfCarry: UInt8 = 0;
    var subtract = CPUStateInstance.registersState.c;
    
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    CPUStateInstance.registersState.a -= subtract;
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//Subtract the value stored in D register from value in A register. 0x92
func SUBD() -> Void {
    var halfCarry: UInt8 = 0;
    var subtract = CPUStateInstance.registersState.d;
    
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    CPUStateInstance.registersState.a -= subtract;
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//Subtract the value stored in E register from value in A register. 0x93
func SUBE() -> Void {
    var halfCarry: UInt8 = 0;
    var subtract = CPUStateInstance.registersState.e;
    
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    CPUStateInstance.registersState.a -= subtract;
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

// Subtract the value stored in H register from value in A register. 0x94
func SUBH() -> Void {
    var halfCarry: UInt8 = 0
    let subtract = CPUStateInstance.registersState.h
    
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1
    }
    
    var carryFlag: UInt8 = 0
    
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1
    }
    
    CPUStateInstance.registersState.a -= subtract
    
    let value = CPUStateInstance.registersState.a
    var equalToZero: UInt8 = 0
    if value == 0 {
        equalToZero = 1
    }
    
    SetFlagsRegister(z: equalToZero, n: 1, h: halfCarry, c: carryFlag)
}


//Subtract the value stored in L register from value in A register. 0x95
func SUBL() -> Void {
    var halfCarry: UInt8 = 0;
    var subtract = CPUStateInstance.registersState.l;
    
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    CPUStateInstance.registersState.a -= subtract;
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//0x96
func SUBHL() -> Void {
    var halfCarry: UInt8 = 0;
    var subtract = BusRead(address: GetHLRegister());
    //emu cyc
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    CPUStateInstance.registersState.a -= subtract;
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//Subtract the value stored in A register from value in A register. 0x97
func SUBA() -> Void {
    CPUStateInstance.registersState.a = 0;
    CPUStateInstance.registersState.f = 0b11000000;
    //SetFlagsRegister(z: 1 , n: 1, h: 0, c: 0)
}







//0x98 - 0x9F
func SBCAn8Bit(_ CPUStateInstance: CPUState, _ subtract: UInt8 ) -> Void {
    var halfCarry: UInt8 = 0;
    var carryFlag: UInt8 = 0;
    //var subtract = CPUStateInstance.registersState.b;
    var carryFlagValue: UInt8 = (1 << 4);
    
    if  CPUStateInstance.registersState.f & carryFlagValue != carryFlagValue{
        carryFlagValue = 0;
    }
    
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF) - Int(carryFlagValue)) < 0x0 {
        halfCarry = 1;
    }
    
    if (Int(CPUStateInstance.registersState.a) - Int(subtract) - Int(carryFlagValue)) < 0x0 {
        carryFlag = 1;
    }
    
    CPUStateInstance.registersState.a -=  subtract + carryFlagValue;
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.a == 0 {
        equalToZero = 1;
    }
    
    /*
     if CPUStateInstance.registersState.a > 0xFF {
     carryFlag = 1;
     }
     */
    SetFlagsRegister(z: equalToZero, n: 1, h: halfCarry, c: carryFlag);
}



// 0xA0 - 0xA5
func ANDB() -> Void {
    CPUStateInstance.registersState.a &= CPUStateInstance.registersState.b;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10100000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00100000;
    }
}

func ANDC() -> Void {
    CPUStateInstance.registersState.a &= CPUStateInstance.registersState.c;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10100000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00100000;
    }
}

func ANDD() -> Void {
    CPUStateInstance.registersState.a &= CPUStateInstance.registersState.d;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10100000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00100000;
    }
}

func ANDE() -> Void {
    CPUStateInstance.registersState.a &= CPUStateInstance.registersState.e;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10100000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00100000;
    }
}

func ANDH() -> Void {
    CPUStateInstance.registersState.a &= CPUStateInstance.registersState.h;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10100000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00100000;
    }
}

func ANDL() -> Void {
    CPUStateInstance.registersState.a &= CPUStateInstance.registersState.l;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10100000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00100000;
    }
}

//0xA6

func ANDHL() -> Void {
    CPUStateInstance.registersState.a &= BusRead(address: GetHLRegister());
    //emu cyc
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10100000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00100000;
    }
}

//0xA7
func ANDA() -> Void {
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10100000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00100000;
    }
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


func XORHL() -> Void {
    let value = BusRead(address: GetHLRegister());
    //emu cyc
    if CPUStateInstance.registersState.a == value {
        CPUStateInstance.registersState.a = 0;
        CPUStateInstance.registersState.f = 0b1000000;
    } else {
        CPUStateInstance.registersState.a ^= value;
        CPUStateInstance.registersState.f = 0;
    }
}

// XOR the value at register A by itself. This always results in 0 so I just hard coded it to always be 0. It also resets the flags register. 0xAF
func XORA() -> Void {
    CPUStateInstance.registersState.a = 0;
    //CPUStateInstance.registersState.a ^= CPUStateInstance.registersState.a & 0xFF;
    CPUStateInstance.registersState.f = 0b1000000;
}


// 0xB0 - 0xB5
func ORB() -> Void {
    CPUStateInstance.registersState.a |= CPUStateInstance.registersState.b;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10000000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00000000;
    }
}

func ORC() -> Void {
    CPUStateInstance.registersState.a |= CPUStateInstance.registersState.c;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10000000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00000000;
    }
}
func ORD() -> Void {
    CPUStateInstance.registersState.a |= CPUStateInstance.registersState.d;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10000000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00000000;
    }
}

func ORE() -> Void {
    CPUStateInstance.registersState.a |= CPUStateInstance.registersState.e;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10000000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00000000;
    }
}

func ORH() -> Void {
    CPUStateInstance.registersState.a |= CPUStateInstance.registersState.h;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10000000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00000000;
    }
}

func ORL() -> Void {
    CPUStateInstance.registersState.a |= CPUStateInstance.registersState.l;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10000000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00000000;
    }
}

//0xB6
func ORHL() -> Void {
    CPUStateInstance.registersState.a |= BusRead(address: GetHLRegister());
    //emu cyc
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10000000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00000000;
    }
}

//0xB7
func ORA() -> Void {
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10000000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00000000;
    }
}
//0xB8
func CPB() -> Void {
    var subtract = CPUStateInstance.registersState.b;
    var value = CPUStateInstance.registersState.a - subtract;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    var halfCarry: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0x0F) - Int(subtract & 0x0F)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//0xB9
func CPC() -> Void {
    var subtract = CPUStateInstance.registersState.c;
    var value = CPUStateInstance.registersState.a - subtract;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    var halfCarry: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0x0F) - Int(subtract & 0x0F)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//0xBA
func CPD() -> Void {
    var subtract = CPUStateInstance.registersState.d;
    var value = CPUStateInstance.registersState.a - subtract;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    var halfCarry: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0x0F) - Int(subtract & 0x0F)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//0xBB
func CPE() -> Void {
    var subtract = CPUStateInstance.registersState.e;
    var value = CPUStateInstance.registersState.a - subtract;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    var halfCarry: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0x0F) - Int(subtract & 0x0F)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//0xBC
func CPH() -> Void {
    var subtract = CPUStateInstance.registersState.h;
    var value = CPUStateInstance.registersState.a - subtract;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    var halfCarry: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0x0F) - Int(subtract & 0x0F)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//0xBD
func CPLBD() -> Void {
    var subtract = CPUStateInstance.registersState.l;
    var value = CPUStateInstance.registersState.a - subtract;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    var halfCarry: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0x0F) - Int(subtract & 0x0F)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//0xBE
func CPLHL() -> Void {
    var subtract = BusRead(address: GetHLRegister());
    //emu cyc
    var value = CPUStateInstance.registersState.a - subtract;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    var halfCarry: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0x0F) - Int(subtract & 0x0F)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//0xBF
func CPA() -> Void {
    var subtract = CPUStateInstance.registersState.a;
    var value = CPUStateInstance.registersState.a - subtract;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    var halfCarry: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0x0F) - Int(subtract & 0x0F)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//0xC0
func RETNZ() -> Void {
    //emu cyc
    if !IsZFlagSet() {
        var lowByte: UInt16 = UInt16(StackPop());
        //emu cyc
        var highByte: UInt16 = UInt16(StackPop());
        //emu cyc
        CPUStateInstance.registersState.pc = (highByte << 8) | lowByte;
    }
}

//0xC1
func POPBC() -> Void {
    SetBCRegister(value: StackPop16Bit());
    //emu cyc
    //emu cyc
}

//Jump To Address A16 If Z Flag Is Reset 0xC2
func JPNZa16() -> Void {
    if !IsZFlagSet() {
        JPa16()
    }
    else {
        // emu cyc 2
        CPUStateInstance.registersState.pc += 2;
    }
}

// Jump to address a16 0xC3
func JPa16() -> Void {
    CPUStateInstance.registersState.pc = FetchD16();
    //emulator cycle
    
}

//0xC4
func CALLNZa16() -> Void {
    if !IsZFlagSet() {
        CALLa16();
    }
    else {
        // emu cyc 2
        CPUStateInstance.registersState.pc += 2;
    }
}

//0xC5
func PUSHBC() -> Void {
    StackPush16Bit(data: GetBCRegister());
    //emu cyc 3
}

//Add 8 bit value from BusRead to register to A register. 0xC6
func ADDAd8() -> Void {
    var halfCarry: UInt8 = 0;
    var add = BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cycles
    CPUStateInstance.registersState.pc+=1;
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    
    CPUStateInstance.registersState.a += add;
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
}
//0xC7, 0xD7, 0xE7, 0xF7, 0xCF, 0xDF, 0xEF, 0xFF,
func RSTn(_ CPUStateInstance: CPUState, _ address: UInt16) -> Void {
    // emulator cycles 2
    StackPush16Bit(data: CPUStateInstance.registersState.pc);
    CPUStateInstance.registersState.pc = address;
    //emu cyc
}

//0xC8
func RETZ() -> Void {
    //emu cyc
    if IsZFlagSet() {
        var lowByte: UInt16 = UInt16(StackPop());
        //emu cyc
        var highByte: UInt16 = UInt16(StackPop());
        //emu cyc
        CPUStateInstance.registersState.pc = (highByte << 8) | lowByte;
    }
}

//0xC9
func RET() -> Void {
    var lowByte: UInt16 = UInt16(StackPop());
    //emu cyc
    var highByte: UInt16 = UInt16(StackPop());
    //emu cyc
    CPUStateInstance.registersState.pc = (highByte << 8) | lowByte;
}

//0xCA
func JPZa16() -> Void {
    if IsZFlagSet() {
        JPa16()
    }
    else {
        // emu cyc 2
        CPUStateInstance.registersState.pc += 2;
    }
}

//0xCC
func CALLZa16() -> Void {
    if IsZFlagSet() {
        CALLa16();
    }
    else {
        // emu cyc 2
        CPUStateInstance.registersState.pc += 2;
    }
}

//0xCD
func CALLa16() -> Void {
    var fetchedD16 = FetchD16();
    //emulator cyc 2
    StackPush16Bit(data: CPUStateInstance.registersState.pc);
    CPUStateInstance.registersState.pc = fetchedD16;
    //emu cyc
}

//0xCE
func ADCAd8() -> Void {
    var halfCarry: UInt8 = 0;
    var carryFlag: UInt8 = 0;
    var add = BusRead(address: CPUStateInstance.registersState.pc);
    //emu cyc
    CPUStateInstance.registersState.pc+=1;
    var carryFlagValue: UInt8 = (1 << 4);
    
    if  CPUStateInstance.registersState.f & carryFlagValue != carryFlagValue{
        carryFlagValue = 0;
    }
    
    if (CPUStateInstance.registersState.a & 0xF) +
        (add & 0xF) + carryFlagValue > 0xF {
        halfCarry = 1;
    }
    
    if (Int(CPUStateInstance.registersState.a) + Int(add) + Int(carryFlagValue))  > 0xFF {
        carryFlag = 1;
    }
    
    CPUStateInstance.registersState.a +=  add + carryFlagValue;
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.a == 0 {
        equalToZero = 1;
    }
    
    SetFlagsRegister(z: equalToZero, n: 0, h: halfCarry, c: carryFlag);
}

//0xD0
func RETNC() -> Void {
    //emu cyc
    if !IsCFlagSet() {
        var lowByte: UInt16 = UInt16(StackPop());
        //emu cyc
        var highByte: UInt16 = UInt16(StackPop());
        //emu cyc
        CPUStateInstance.registersState.pc = (highByte << 8) | lowByte;
    }
}

//0xD1
func POPDE() -> Void {
    SetDERegister(value: StackPop16Bit());
    //emu cyc
    //emu cyc
}

//Jump To Address A16 If Z Flag Is Reset 0xD2
func JPNCa16() -> Void {
    if !IsCFlagSet() {
        JPa16()
    }
    else {
        // emu cyc 2
        CPUStateInstance.registersState.pc += 2;
    }
}

//0xD4
func CALLNCa16() -> Void {
    if !IsCFlagSet() {
        CALLa16();
    }
    else {
        // emu cyc 2
        CPUStateInstance.registersState.pc += 2;
    }
}

//0xD5
func PUSHDE() -> Void {
    StackPush16Bit(data: GetDERegister());
    //emu cyc 3
}

//Subtract the value BusRead from value in A register. 0xD6
func SUBd8() -> Void {
    var halfCarry: UInt8 = 0;
    var subtract = BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cycles
    CPUStateInstance.registersState.pc+=1;
    
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    CPUStateInstance.registersState.a -= subtract;
    
    var value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//0xD8
func RETC() -> Void {
    //emu cyc
    if IsCFlagSet() {
        var lowByte: UInt16 = UInt16(StackPop());
        //emu cyc
        var highByte: UInt16 = UInt16(StackPop());
        //emu cyc
        CPUStateInstance.registersState.pc = (highByte << 8) | lowByte;
    }
}

//0xD9
func RETI() -> Void {
    RET();
    CPUStateInstance.interruptMasterEnable = true;
}

//0xDA
func JPCa16() -> Void {
    if IsCFlagSet() {
        JPa16();
    }
    else {
        // emu cyc 2
        CPUStateInstance.registersState.pc += 2;
    }
}

//0xDC
func CALLCa16() -> Void {
    if IsCFlagSet() {
        CALLa16();
    }
    else {
        // emu cyc 2
        CPUStateInstance.registersState.pc += 2;
    }
}

//0xDE
func SBCAd8( ) -> Void {
    var halfCarry: UInt8 = 0;
    var carryFlag: UInt8 = 0;
    var subtract = BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cycles
    CPUStateInstance.registersState.pc+=1;
    var carryFlagValue: UInt8 = (1 << 4);
    
    if  CPUStateInstance.registersState.f & carryFlagValue != carryFlagValue{
        carryFlagValue = 0;
    }
    
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF) - Int(carryFlagValue)) < 0x0 {
        halfCarry = 1;
    }
    
    if (Int(CPUStateInstance.registersState.a) - Int(subtract) - Int(carryFlagValue)) < 0x0 {
        carryFlag = 1;
    }
    
    CPUStateInstance.registersState.a -=  subtract + carryFlagValue;
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.a == 0 {
        equalToZero = 1;
    }
    
    /*
     if CPUStateInstance.registersState.a > 0xFF {
     carryFlag = 1;
     }
     */
    SetFlagsRegister(z: equalToZero, n: 1, h: halfCarry, c: carryFlag);
}

//0xE0
func LDHa8A() -> Void {
    var address = UInt16(BusRead(address: 0xFF00 | CPUStateInstance.registersState.pc));
    //emu cyc
    BusWrite(address: address, value: CPUStateInstance.registersState.a);
    
    CPUStateInstance.registersState.pc += 1;
    //emu cyc
}

//0xE1
func POPHL() -> Void {
    SetHLRegister(value: StackPop16Bit());
    //emu cyc
    //emu cyc
}

//0xE2
func LDCAE2() -> Void {
    //can also be addition?
    var address = 0xFF00 | UInt16(CPUStateInstance.registersState.c);
    BusWrite(address: address , value: CPUStateInstance.registersState.a);
    //emu cyc
}

//0xE5
func PUSHHL() -> Void {
    StackPush16Bit(data: GetHLRegister());
    //emu cyc 3
}

//0xE6
func ANDd8() -> Void {
    CPUStateInstance.registersState.a &= BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cycles
    CPUStateInstance.registersState.pc+=1;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10100000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00100000;
    }
}

//0xE8
func ADDSPr8() -> Void {
    
    var halfCarry: UInt8 = 0;
    var carryFlag: UInt8 = 0;
    
    if (CPUStateInstance.registersState.sp & 0xF) + UInt16(BusRead(address:  CPUStateInstance.registersState.sp) & 0xF) >= 0x10 {
        halfCarry = 1;
    }
    if Int(CPUStateInstance.registersState.sp & 0xFF) + Int(BusRead(address:  CPUStateInstance.registersState.sp) & 0xFF) >= 0x100 {
        carryFlag = 1;
    }
    
    CPUStateInstance.registersState.sp += UInt16(Int8(BusRead(address:  CPUStateInstance.registersState.sp)));
    //emu cyc
    CPUStateInstance.registersState.sp += 1;
    //emu cyc
    
    SetFlagsRegister(z: 0, n: 0, h: halfCarry, c: carryFlag);
}

//0xEA
func LDa16A() -> Void {
    BusWrite(address: FetchD16(), value: CPUStateInstance.registersState.a);
    //emu cyc
}

//0xEE
func XORd8() -> Void {
    var value = BusRead(address: CPUStateInstance.registersState.pc);
    // emu cyc
    CPUStateInstance.registersState.pc+=1;
    if CPUStateInstance.registersState.a == value {
        CPUStateInstance.registersState.a = 0;
        CPUStateInstance.registersState.f = 0b1000000;
    } else {
        CPUStateInstance.registersState.a ^= value;
        CPUStateInstance.registersState.f = 0;
    }
}

//0xF0
func LDHAa8() -> Void {
    var fetchedData = UInt16(BusRead(address: CPUStateInstance.registersState.pc));
    //emu cyc
    CPUStateInstance.registersState.a = BusRead(address: 0xFF00 | fetchedData);
    CPUStateInstance.registersState.pc += 1;
    //emu cyc
}

//0xF1 lower 4 bits of f reg are not used and w FFF0
func POPAF() -> Void {
    SetAFRegister(value: StackPop16Bit() & 0xFFF0);
    //emu cyc
    //emu cyc
}

//0xF2
func LDACF2() -> Void {
    //can also be addition?
    var address = 0xFF00 | UInt16(CPUStateInstance.registersState.c);
    //emu cyc
    CPUStateInstance.registersState.a = BusRead(address: address);
    //emu cyc
}

//0xF3
func DI() -> Void {
    CPUStateInstance.interruptMasterEnable = false;
}

//0xF5
func PUSHAF() -> Void {
    StackPush16Bit(data: GetAFRegister());
    //emu cyc 3
}

//0xF6
func ORd8() -> Void {
    CPUStateInstance.registersState.a |= BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cycles
    CPUStateInstance.registersState.pc+=1;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10000000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00000000;
    }
}
//0xFA
func LDAa16() -> Void {
    CPUStateInstance.registersState.a = BusRead(address: FetchD16());
    //emu cyc
}
//0xFB
func FI() -> Void {
    CPUStateInstance.enablingIME = true;
}

//0xFE
func CPd8() -> Void {
    var subtract = BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cyc
    CPUStateInstance.registersState.pc+=1;
    var value = CPUStateInstance.registersState.a - subtract;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    
    var halfCarry: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0x0F) - Int(subtract & 0x0F)) < 0x0 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}
