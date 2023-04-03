//
//  Instructions.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 1/2/23.
//

import Foundation

struct Instruction {
    var name: String;
    //Void function cooresponding to the isntruction
    var instructionFunction: (()->Void);
}
//https://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html
//This is an array containing every Game Boy CPU instruction. Position is according to the table found at the site above
func GenerateOpcodes() -> [Instruction] {
    var table = Array(repeating: Instruction(name: "Empty Spot", instructionFunction: EmptySpot), count: 0x100);
    table[0x00] = Instruction(name: "NOP", instructionFunction: NOP);
    table[0x01] = Instruction(name: "LDBCd16", instructionFunction: LDBCd16);
    table[0x02] = Instruction(name: "LDBCA", instructionFunction: LDBCA);
    table[0x03] = Instruction(name: "INCBC", instructionFunction: INCBC);
    table[0x04] = Instruction(name: "INCB", instructionFunction: INCB);
    table[0x05] = Instruction(name: "DECB", instructionFunction: DECB);
    table[0x06] = Instruction(name: "LDBd8", instructionFunction: LDBd8);
    table[0x07] = Instruction(name: "RLCA", instructionFunction: RLCA);
    table[0x08] = Instruction(name: "LDa16SP", instructionFunction: LDa16SP);
    table[0x09] = Instruction(name: "ADDHLBC", instructionFunction: { ADDHLnn(register: GetBCRegister()) });
    table[0x0a] = Instruction(name: "LDAAddressBC", instructionFunction: { LDAnn(register: GetBCRegister()) });
    table[0x0b] = Instruction(name: "DECBC", instructionFunction: DECBC);
    table[0x0c] = Instruction(name: "INCC", instructionFunction: INCC);
    table[0x0d] = Instruction(name: "DECC", instructionFunction: DECC);
    table[0x0e] = Instruction(name: "LDCd8", instructionFunction: LDCd8);
    table[0x0f] = Instruction(name: "RRCA", instructionFunction: RRCA);
    table[0x10] = Instruction(name: "STOP0", instructionFunction: STOP0);
    table[0x11] = Instruction(name: "LDDEd16", instructionFunction: LDDEd16);
    table[0x12] = Instruction(name: "LDDEA", instructionFunction: LDDEA);
    table[0x13] = Instruction(name: "INCDE", instructionFunction: INCDE);
    table[0x14] = Instruction(name: "INCD", instructionFunction: INCD);
    table[0x15] = Instruction(name: "DECD", instructionFunction: DECD);
    table[0x16] = Instruction(name: "LDDd8", instructionFunction: LDDd8);
    table[0x17] = Instruction(name: "RLA", instructionFunction: RLA);
    table[0x18] = Instruction(name: "JRr8", instructionFunction: JRr8);
    table[0x19] = Instruction(name: "ADDHLDE", instructionFunction: { ADDHLnn(register: GetDERegister()) });
    table[0x1a] = Instruction(name: "LDAAddressDE", instructionFunction: { LDAnn(register: GetDERegister()) });
    table[0x1b] = Instruction(name: "DECDE", instructionFunction: DECDE);
    table[0x1c] = Instruction(name: "INCE", instructionFunction: INCE);
    table[0x1d] = Instruction(name: "DECE", instructionFunction: DECE);
    table[0x1e] = Instruction(name: "LDEd8", instructionFunction: LDEd8);
    table[0x1f] = Instruction(name: "RRA", instructionFunction: RRA);
    table[0x20] = Instruction(name: "JRNZr8", instructionFunction: JRNZr8);
    table[0x21] = Instruction(name: "LDHLd16", instructionFunction: LDHLd16);
    table[0x22] = Instruction(name: "LDHLIncA", instructionFunction: LDHLIncA);
    table[0x23] = Instruction(name: "INCHL", instructionFunction: INCHL);
    table[0x24] = Instruction(name: "INCH", instructionFunction: INCH);
    table[0x25] = Instruction(name: "DECH", instructionFunction: DECH);
    table[0x26] = Instruction(name: "LDHd8", instructionFunction: LDHd8);
    table[0x27] = Instruction(name: "DAA", instructionFunction: DAA);
    table[0x28] = Instruction(name: "JRZr8", instructionFunction: JRZr8);
    table[0x29] = Instruction(name: "ADDHLHL", instructionFunction: { ADDHLnn(register: GetHLRegister()) });
    table[0x2a] = Instruction(name: "LDAAddressHLInc", instructionFunction: { LDAnn(register: GetHLRegister()) });
    table[0x2b] = Instruction(name: "DECHL", instructionFunction: DECHL);
    table[0x2c] = Instruction(name: "INCL", instructionFunction: INCL);
    table[0x2d] = Instruction(name: "DECL", instructionFunction: DECL);
    table[0x2e] = Instruction(name: "LDLd8", instructionFunction: LDLd8);
    table[0x2f] = Instruction(name: "CPL", instructionFunction: CPL);
    table[0x30] = Instruction(name: "JRNCr8", instructionFunction: JRNCr8);
    table[0x31] = Instruction(name: "LDSPa16", instructionFunction: LDSPa16);
    table[0x32] = Instruction(name: "LDHLDecA", instructionFunction: LDHLDecA);
    table[0x33] = Instruction(name: "INCSP", instructionFunction: INCSP);
    table[0x34] = Instruction(name: "INCHL0x34", instructionFunction: INCHL0x34);
    table[0x35] = Instruction(name: "DECHL0x35", instructionFunction: DECHL0x35);
    table[0x36] = Instruction(name: "LDHLd8", instructionFunction: LDHLd8);
    table[0x37] = Instruction(name: "SCF", instructionFunction: SCF);
    table[0x38] = Instruction(name: "JRCr8", instructionFunction: JRCr8);
    table[0x39] = Instruction(name: "ADDHLSP", instructionFunction: { ADDHLnn(register: CPUStateInstance.registersState.sp) });
    table[0x3a] = Instruction(name: "LDAAddressHLDec", instructionFunction: { LDAnn(register: GetHLRegister()) });
    table[0x3b] = Instruction(name: "DECSP", instructionFunction: DECSP);
    table[0x3c] = Instruction(name: "INCA", instructionFunction: INCA);
    table[0x3d] = Instruction(name: "DECA", instructionFunction: DECA);
    table[0x3e] = Instruction(name: "LDAd8", instructionFunction: LDAd8);
    table[0x3f] = Instruction(name: "CCF", instructionFunction: CCF);
    table[0x40] = Instruction(name: "LDBB", instructionFunction: LDBB);
    table[0x41] = Instruction(name: "LDBC", instructionFunction: LDBC);
    table[0x42] = Instruction(name: "LDBD", instructionFunction: LDBD);
    table[0x43] = Instruction(name: "LDBE", instructionFunction: LDBE);
    table[0x44] = Instruction(name: "LDBEH", instructionFunction: LDBEH);
    table[0x45] = Instruction(name: "LDBL", instructionFunction: LDBL);
    table[0x46] = Instruction(name: "LDBHL", instructionFunction: LDBHL);
    table[0x47] = Instruction(name: "LDBA", instructionFunction: LDBA);
    table[0x48] = Instruction(name: "LDCB", instructionFunction: LDCB);
    table[0x49] = Instruction(name: "LDCC", instructionFunction: LDCC);
    table[0x4a] = Instruction(name: "LDCD", instructionFunction: LDCD);
    table[0x4b] = Instruction(name: "LDCE", instructionFunction: LDCE);
    table[0x4c] = Instruction(name: "LDCH", instructionFunction: LDCH);
    table[0x4d] = Instruction(name: "LDCL", instructionFunction: LDCL);
    table[0x4e] = Instruction(name: "LDCHL", instructionFunction: LDCHL);
    table[0x4f] = Instruction(name: "LDCA", instructionFunction: LDCA);
    table[0x50] = Instruction(name: "LDDB", instructionFunction: LDDB);
    table[0x51] = Instruction(name: "LDDC", instructionFunction: LDDC);
    table[0x52] = Instruction(name: "LDDD", instructionFunction: LDDD);
    table[0x53] = Instruction(name: "LDDE", instructionFunction: LDDE);
    table[0x54] = Instruction(name: "LDDH", instructionFunction: LDDH);
    table[0x55] = Instruction(name: "LDDL", instructionFunction: LDDL);
    table[0x56] = Instruction(name: "LDDHL", instructionFunction: LDDHL);
    table[0x57] = Instruction(name: "LDDA", instructionFunction: LDDA);
    table[0x58] = Instruction(name: "LDEB", instructionFunction: LDEB);
    table[0x59] = Instruction(name: "LDEC", instructionFunction: LDEC);
    table[0x5a] = Instruction(name: "LDED", instructionFunction: LDED);
    table[0x5b] = Instruction(name: "LDEE", instructionFunction: LDEE);
    table[0x5c] = Instruction(name: "LDEH", instructionFunction: LDEH);
    table[0x5d] = Instruction(name: "LDEL", instructionFunction: LDEL);
    table[0x5e] = Instruction(name: "LDEHL", instructionFunction: LDEHL);
    table[0x5f] = Instruction(name: "LDEA", instructionFunction: LDEA);
    table[0x60] = Instruction(name: "LDHB", instructionFunction: LDHB);
    table[0x61] = Instruction(name: "LDHC", instructionFunction: LDHC);
    table[0x62] = Instruction(name: "LDHD", instructionFunction: LDHD);
    table[0x63] = Instruction(name: "LDHE", instructionFunction: LDHE);
    table[0x64] = Instruction(name: "LDHH", instructionFunction: LDHH);
    table[0x65] = Instruction(name: "LDHL", instructionFunction: LDHL);
    table[0x66] = Instruction(name: "LDHHL", instructionFunction: LDHHL);
    table[0x67] = Instruction(name: "LDHA", instructionFunction: LDHA);
    table[0x68] = Instruction(name: "LDLB", instructionFunction: LDLB);
    table[0x69] = Instruction(name: "LDLC", instructionFunction: LDLC);
    table[0x6a] = Instruction(name: "LDLD", instructionFunction: LDLD);
    table[0x6b] = Instruction(name: "LDLE", instructionFunction: LDLE);
    table[0x6c] = Instruction(name: "LDLH", instructionFunction: LDLH);
    table[0x6d] = Instruction(name: "LDLL", instructionFunction: LDLL);
    table[0x6e] = Instruction(name: "LDLHL", instructionFunction: LDLHL);
    table[0x6f] = Instruction(name: "LDLA", instructionFunction: LDLA);
    table[0x70] = Instruction(name: "LDHLB", instructionFunction: {LDHLn(register: CPUStateInstance.registersState.b) });
    table[0x71] = Instruction(name: "LDHLC", instructionFunction: {LDHLn(register: CPUStateInstance.registersState.c) });
    table[0x72] = Instruction(name: "LDHLD", instructionFunction: {LDHLn(register: CPUStateInstance.registersState.d) });
    table[0x73] = Instruction(name: "LDHLE", instructionFunction: {LDHLn(register: CPUStateInstance.registersState.e) });
    table[0x74] = Instruction(name: "LDHLH", instructionFunction: {LDHLn(register: CPUStateInstance.registersState.h) });
    table[0x75] = Instruction(name: "LDHLL", instructionFunction: {LDHLn(register: CPUStateInstance.registersState.l) });
    table[0x76] = Instruction(name: "HALT", instructionFunction: HALT);
    table[0x77] = Instruction(name: "LDHLA", instructionFunction: {LDHLn(register: CPUStateInstance.registersState.a) });
    table[0x78] = Instruction(name: "LDAB", instructionFunction: LDAB);
    table[0x79] = Instruction(name: "LDAC", instructionFunction: LDAC);
    table[0x7a] = Instruction(name: "LDAD", instructionFunction: LDAD);
    table[0x7b] = Instruction(name: "LDAE", instructionFunction: LDAE);
    table[0x7c] = Instruction(name: "LDAH", instructionFunction: LDAH);
    table[0x7d] = Instruction(name: "LDAL", instructionFunction: LDAL);
    table[0x7e] = Instruction(name: "LDAHL", instructionFunction: LDAHL);
    table[0x7f] = Instruction(name: "LDAA", instructionFunction: LDAA);
    table[0x80] = Instruction(name: "ADDAB", instructionFunction: ADDAB);
    table[0x81] = Instruction(name: "ADDAC", instructionFunction: ADDAC);
    table[0x82] = Instruction(name: "ADDAD", instructionFunction: ADDAD);
    table[0x83] = Instruction(name: "ADDAE", instructionFunction: ADDAE);
    table[0x84] = Instruction(name: "ADDAH", instructionFunction: ADDAH);
    table[0x85] = Instruction(name: "ADDAL", instructionFunction: ADDAL);
    table[0x86] = Instruction(name: "ADDAHL", instructionFunction: ADDAHL);
    table[0x87] = Instruction(name: "ADDAA", instructionFunction: ADDAA);
    table[0x88] = Instruction(name: "ADCAB", instructionFunction: {ADCA8Bit(register: CPUStateInstance.registersState.b)});
    table[0x89] = Instruction(name: "ADCAC", instructionFunction: {ADCA8Bit(register: CPUStateInstance.registersState.c)});
    table[0x8a] = Instruction(name: "ADCAD", instructionFunction: {ADCA8Bit(register: CPUStateInstance.registersState.d)});
    table[0x8b] = Instruction(name: "ADCAE", instructionFunction: {ADCA8Bit(register: CPUStateInstance.registersState.e)});
    table[0x8c] = Instruction(name: "ADCAH", instructionFunction: {ADCA8Bit(register: CPUStateInstance.registersState.h)});
    table[0x8d] = Instruction(name: "ADCAL", instructionFunction: {ADCA8Bit(register: CPUStateInstance.registersState.l)});
    table[0x8e] = Instruction(name: "ADCAB", instructionFunction: {ADCA8Bit(register: BusRead(address: GetHLRegister()))});
    table[0x8f] = Instruction(name: "ADCAA", instructionFunction: {ADCA8Bit(register: CPUStateInstance.registersState.a)});
    table[0x90] = Instruction(name: "SUBB", instructionFunction: SUBB);
    table[0x91] = Instruction(name: "SUBC", instructionFunction: SUBC);
    table[0x92] = Instruction(name: "SUBD", instructionFunction: SUBD);
    table[0x93] = Instruction(name: "SUBE", instructionFunction: SUBE);
    table[0x94] = Instruction(name: "SUBH", instructionFunction: SUBH);
    table[0x95] = Instruction(name: "SUBL", instructionFunction: SUBL);
    table[0x96] = Instruction(name: "SUBHL", instructionFunction: SUBHL);
    table[0x97] = Instruction(name:"SUBA", instructionFunction: SUBA);
    table[0x98] = Instruction(name: "SBCAB", instructionFunction: {SBCAn(register: CPUStateInstance.registersState.b)});
    table[0x99] = Instruction(name: "SBCAC", instructionFunction: {SBCAn(register: CPUStateInstance.registersState.c)});
    table[0x9a] = Instruction(name: "SBCAD", instructionFunction: {SBCAn(register: CPUStateInstance.registersState.d)});
    table[0x9b] = Instruction(name: "SBCAE", instructionFunction: {SBCAn(register: CPUStateInstance.registersState.e)});
    table[0x9c] = Instruction(name: "SBCAH", instructionFunction: {SBCAn(register: CPUStateInstance.registersState.h)});
    table[0x9d] = Instruction(name: "SBCAL", instructionFunction: {SBCAn(register: CPUStateInstance.registersState.l)});
    table[0x9e] = Instruction(name: "SBCAAddressHL", instructionFunction: {SBCAn(register: BusRead(address: GetHLRegister()))});
    table[0x9f] = Instruction(name: "SBCAA", instructionFunction: {SBCAn(register: CPUStateInstance.registersState.a)});
    table[0xa0] = Instruction(name: "ANDB", instructionFunction: ANDB);
    table[0xa1] = Instruction(name: "ANDC", instructionFunction: ANDC);
    table[0xa2] = Instruction(name: "ANDD", instructionFunction: ANDD);
    table[0xa3] = Instruction(name: "ANDE", instructionFunction: ANDE);
    table[0xa4] = Instruction(name: "ANDH", instructionFunction: ANDH);
    table[0xa5] = Instruction(name: "ANDL", instructionFunction: ANDL);
    table[0xa6] = Instruction(name: "ANDHL", instructionFunction: ANDHL);
    table[0xa7] = Instruction(name: "ANDA", instructionFunction: ANDA);
    table[0xa8] = Instruction(name: "XORB", instructionFunction: XORB);
    table[0xa9] = Instruction(name: "XORC", instructionFunction: XORC);
    table[0xaa] = Instruction(name: "XORD", instructionFunction: XORD);
    table[0xab] = Instruction(name: "XORE", instructionFunction: XORE);
    table[0xac] = Instruction(name: "XORH", instructionFunction: XORH);
    table[0xad] = Instruction(name: "XORL", instructionFunction: XORL);
    table[0xae] = Instruction(name: "XORHL", instructionFunction: XORHL);
    table[0xaf] = Instruction(name: "XORA", instructionFunction: XORA);
    table[0xb0] = Instruction(name: "ORB", instructionFunction: ORB);
    table[0xb1] = Instruction(name: "ORC", instructionFunction: ORC);
    table[0xb2] = Instruction(name: "ORD", instructionFunction: ORD);
    table[0xb3] = Instruction(name: "ORE", instructionFunction: ORE);
    table[0xb4] = Instruction(name: "ORH", instructionFunction: ORH);
    table[0xb5] = Instruction(name: "ORL", instructionFunction: ORL);
    table[0xb6] = Instruction(name: "ORHL", instructionFunction: ORHL);
    table[0xb7] = Instruction(name: "ORA", instructionFunction: ORA);
    table[0xb8] = Instruction(name: "CPB", instructionFunction: CPB);
    table[0xb9] = Instruction(name: "CPC", instructionFunction: CPC);
    table[0xba] = Instruction(name: "CPD", instructionFunction: CPD);
    table[0xbb] = Instruction(name: "CPE", instructionFunction: CPE);
    table[0xbc] = Instruction(name: "CPH", instructionFunction: CPH);
    table[0xbd] = Instruction(name: "CPLBD", instructionFunction: CPLBD);
    table[0xbe] = Instruction(name: "CPLHL", instructionFunction: CPLHL);
    table[0xbf] = Instruction(name: "CPA", instructionFunction: CPA);
    table[0xc0] = Instruction(name: "RETNZ", instructionFunction: RETNZ);
    table[0xc1] = Instruction(name: "POPBC", instructionFunction: POPBC);
    table[0xc2] = Instruction(name: "JPNZa16", instructionFunction: JPNZa16);
    table[0xc3] = Instruction(name: "JPa16", instructionFunction: JPa16);
    table[0xc4] = Instruction(name: "CALLNZa16", instructionFunction: CALLNZa16);
    table[0xc5] = Instruction(name: "PUSHBC", instructionFunction: PUSHBC);
    table[0xc6] = Instruction(name: "ADDAd8", instructionFunction: ADDAd8);
    table[0xc7] = Instruction(name: "RST00H", instructionFunction: {RSTnH(address: 0x00)});
    table[0xc8] = Instruction(name: "RETZ", instructionFunction: RETZ);
    table[0xc9] = Instruction(name: "RET", instructionFunction: RET);
    table[0xca] = Instruction(name: "JPZa16", instructionFunction: JPZa16);
    table[0xcb] = Instruction(name: "PREFIXCB", instructionFunction: PREFIXCB);
    table[0xcc] = Instruction(name: "CALLZa16", instructionFunction: CALLZa16);
    table[0xcd] = Instruction(name: "CALLa16", instructionFunction: CALLa16);
    table[0xce] = Instruction(name: "ADCAd8", instructionFunction: ADCAd8);
    table[0xcf] = Instruction(name: "RST08H", instructionFunction: {RSTnH(address: 0x08)});
    table[0xd0] = Instruction(name: "RETNC", instructionFunction: RETNC);
    table[0xd1] = Instruction(name: "POPDE", instructionFunction: POPDE);
    table[0xd2] = Instruction(name: "JPNCa16", instructionFunction: JPNCa16);
    table[0xd4] = Instruction(name: "CALLNCa16", instructionFunction: CALLNCa16);
    table[0xd5] = Instruction(name: "PUSHDE", instructionFunction: PUSHDE);
    table[0xd6] = Instruction(name: "SUBd8", instructionFunction: SUBd8);
    table[0xd7] = Instruction(name: "RST10H", instructionFunction: {RSTnH(address: 0x10)});
    table[0xd8] = Instruction(name: "RETC", instructionFunction: RETC);
    table[0xd9] = Instruction(name: "RETI", instructionFunction: RETI);
    table[0xda] = Instruction(name: "JPCa16", instructionFunction: JPCa16);
    table[0xdc] = Instruction(name: "CALLCa16", instructionFunction: CALLCa16);
    table[0xde] = Instruction(name: "SBCAd8", instructionFunction: SBCAd8);
    table[0xdf] = Instruction(name: "RST18H", instructionFunction: {RSTnH(address: 0x18)});
    table[0xe0] = Instruction(name: "LDHa8A", instructionFunction: LDHa8A);
    table[0xe1] = Instruction(name: "POPHL", instructionFunction: POPHL);
    table[0xe2] = Instruction(name: "LDCAE2", instructionFunction: LDCAE2);
    table[0xe5] = Instruction(name: "PUSHHL", instructionFunction: PUSHHL);
    table[0xe6] = Instruction(name: "", instructionFunction: ANDd8);
    table[0xe7] = Instruction(name: "RST20H", instructionFunction: {RSTnH(address: 0x20)});
    table[0xe8] = Instruction(name: "ADDSPr8", instructionFunction: ADDSPr8);
    table[0xe9] = Instruction(name: "JPHL", instructionFunction: JPHL);
    table[0xea] = Instruction(name: "LDa16A", instructionFunction: LDa16A);
    table[0xee] = Instruction(name: "XORd8", instructionFunction: XORd8);
    table[0xef] = Instruction(name: "RST28H", instructionFunction: {RSTnH(address: 0x28)});
    table[0xf0] = Instruction(name: "LDHAa8", instructionFunction: LDHAa8);
    table[0xf1] = Instruction(name: "POPAF", instructionFunction: POPAF);
    table[0xf2] = Instruction(name: "LDACF2", instructionFunction: LDACF2);
    table[0xf3] = Instruction(name: "DI", instructionFunction: DI);
    table[0xf5] = Instruction(name: "PUSHAF", instructionFunction: PUSHAF);
    table[0xf6] = Instruction(name: "ORd8", instructionFunction: ORd8);
    table[0xf7] = Instruction(name: "RST30H", instructionFunction: {RSTnH(address: 0x30)});
    table[0xf8] = Instruction(name: "LDHLSPPlusR8", instructionFunction: LDHLSPPlusR8);
    table[0xf9] = Instruction(name: "LDSPHL", instructionFunction: LDSPHL);
    table[0xfa] = Instruction(name: "LDAa16", instructionFunction: LDAa16);
    table[0xfb] = Instruction(name: "FI", instructionFunction: FI);
    table[0xfe] = Instruction(name: "", instructionFunction: CPd8);
    table[0xff] = Instruction(name: "RST38H", instructionFunction: {RSTnH(address: 0x38)});
    
    return table;
}

var InstructionsTable = GenerateOpcodes();

//set bits
func SetFlagsRegister(z: UInt8, n: UInt8, h: UInt8, c: UInt8) -> Void {
    let flagsArray: [UInt8] = [z, n, h, c];
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

//Data fetching instructions
//Fetch 16 bit address to jump to. Since 8 bit value is stored at an address we have to combine the two bytes by
func FetchD16() -> UInt16 {
    let lowByte: UInt16 = UInt16(BusRead(address: CPUStateInstance.registersState.pc));
    EmulatorCycles(CPUCycles: 1);
    let highByte: UInt16 = UInt16(BusRead(address: CPUStateInstance.registersState.pc + 1));
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc &+= 2;
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
    let lowByte: UInt16 = UInt16(CPUStateInstance.registersState.c);
    let highByte: UInt16 = UInt16(CPUStateInstance.registersState.b);
    return lowByte | (highByte << 8);
}

func SetBCRegister(value: UInt16) -> Void {
    CPUStateInstance.registersState.c = UInt8(value & 0xFF);
    CPUStateInstance.registersState.b = UInt8((value >> 8) & 0xFF);
}

// GetAFRegister - Gets the value of the AF register
func GetAFRegister() -> UInt16 {
    let lowByte: UInt16 = UInt16(CPUStateInstance.registersState.f);
    let highByte: UInt16 = UInt16(CPUStateInstance.registersState.a);
    return lowByte | (highByte << 8);
}

// SetAFRegister - Sets the value of the AF register
func SetAFRegister(value: UInt16) -> Void {
    CPUStateInstance.registersState.f = UInt8(value & 0xFF);
    CPUStateInstance.registersState.a = UInt8((value >> 8) & 0xFF);
}

// GetHLRegister - Gets the value of the HL register
func GetHLRegister() -> UInt16 {
    let lowByte: UInt16 = UInt16(CPUStateInstance.registersState.l);
    let highByte: UInt16 = UInt16(CPUStateInstance.registersState.h);
    return lowByte | (highByte << 8);
}

// SetHLRegister - Sets the value of the HL register
func SetHLRegister(value: UInt16) -> Void {
    CPUStateInstance.registersState.l = UInt8(value & 0xFF);
    CPUStateInstance.registersState.h = UInt8(value >> 8);
}

// GetDERegister - Gets the value of the DE register
func GetDERegister() -> UInt16 {
    let lowByte: UInt16 = UInt16(CPUStateInstance.registersState.e);
    let highByte: UInt16 = UInt16(CPUStateInstance.registersState.d);
    return lowByte | (highByte << 8);
}

// SetDERegister - Sets the value of the DE register
func SetDERegister(value: UInt16) -> Void {
    CPUStateInstance.registersState.e = UInt8(value & 0xFF);
    CPUStateInstance.registersState.d = UInt8((value >> 8) & 0xFF);
}


//used to initialize the instruction table and fill in spots that are not used
func EmptySpot() -> Void {
    print("😳\n");
    exit(-5);
}

// Performs no operation 0x00
func NOP() -> Void {
    
}

//0x01 Set the value of tjhe BC Register equal to 16 bytes read from the memory bus
func LDBCd16() -> Void {
    SetBCRegister(value: FetchD16());
}

//0x02 Set the address (BC) equal to the value of register a
func LDBCA() -> Void {
    BusWrite(address: GetBCRegister(), value: CPUStateInstance.registersState.a);
    EmulatorCycles(CPUCycles: 1);
}

//0x03 Increment the BC register by 1
func INCBC() -> Void {
    let value = GetBCRegister() &+ 1;
    SetBCRegister(value: value);
    EmulatorCycles(CPUCycles: 1);
}

// This function increments B register by 1. 0x04
func INCB() -> Void {
    CPUStateInstance.registersState.b &+= 1;
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.b == 0 {
        equalToZero = 1;
    }
    var halfCarry: UInt8 = 0;
    
    if CPUStateInstance.registersState.b & 0x0F == 0 {
        halfCarry = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2);
}

// This instruction Decrements the B register by 1 0x05
func DECB() -> Void {
    CPUStateInstance.registersState.b &-= 1;
    let value = CPUStateInstance.registersState.b;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    var halfCarry: UInt8 = 0;
    if value & 0x0F == 0x0F {
        halfCarry = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: 2)
}

//0x06 Set the value of register b to the value from the bus at address (pc)
func LDBd8() -> Void {
    CPUStateInstance.registersState.b = BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc &+= 1;
}

//0x07 Rotate left. The old 7th bit will be put in teh carry flag
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

//0x08 Write sp value to address (a16
func LDa16SP() -> Void {
    BusWrite16Bit(address: FetchD16(), value: CPUStateInstance.registersState.sp);
    EmulatorCycles(CPUCycles: 1);
    EmulatorCycles(CPUCycles: 1);
}

//0x09 0x19 0x29 0x39 Add 16 bit register value to carry flag
func ADDHLnn(register: UInt16) -> Void {
    let value: UInt32 = UInt32(GetHLRegister()) + UInt32(register);
    var halfCarry: UInt8 = 0;
    var carryFlag: UInt8 = 0;
    if (GetHLRegister() & 0xFFF) + (register & 0xFFF) >= 0x1000 {
        halfCarry = 1;
    }
    if UInt32(GetHLRegister()) + UInt32(register) >= 0x10000 {
        carryFlag = 1;
    }
    EmulatorCycles(CPUCycles: 1);
    SetHLRegister(value: UInt16(value & 0xFFFF));
    SetFlagsRegister(z: 2, n: 0, h: halfCarry, c: carryFlag);
}

//0x0A 0x1A 0x2A 0x3A Set a register equal to value from bus.
//Opcodes 0x2A and 0x3A increment hl or dec hl as well
func LDAnn(register: UInt16) -> Void {
    CPUStateInstance.registersState.a = BusRead(address: register);
    EmulatorCycles(CPUCycles: 1);
    if CPUStateInstance.currentOpcode == 0x2A {
        let value = register &+ 1;
        SetHLRegister(value: value);
    }
    if CPUStateInstance.currentOpcode == 0x3A {
        let value = register &- 1;
        SetHLRegister(value: value);
    }
}

//0x0B
func DECBC() -> Void {
    let value = GetBCRegister() &- 1;
    SetBCRegister(value: value);
    EmulatorCycles(CPUCycles: 1);
}


// This function increments C register by 1. 0x0C
func INCC() -> Void {
    CPUStateInstance.registersState.c &+= 1;
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.c == 0 {
        equalToZero = 1;
    }
    var halfCarry: UInt8 = 0;
    
    if CPUStateInstance.registersState.c & 0x0F == 0 {
        halfCarry = 1;
    }
    
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2);
}

// This instruction Decrements the C register by 1 0x0D
func DECC() -> Void {
    CPUStateInstance.registersState.c &-= 1;
    let value = CPUStateInstance.registersState.c;
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

//0x0E
func LDCd8() -> Void {
    CPUStateInstance.registersState.c = BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc += 1;
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
    //maybe change
    SetFlagsRegister(z: equalToZero, n: 0, h: 0, c: carryFlag);
}

//0x10
func STOP0() -> Void {
    print("stopping 🥶");
    exit(-5);
}

//0x11
func LDDEd16() -> Void {
    SetDERegister(value: FetchD16());
}

//0x12
func LDDEA() -> Void {
    BusWrite(address: GetDERegister(), value: CPUStateInstance.registersState.a);
    EmulatorCycles(CPUCycles: 1);
}

//0x13
func INCDE() -> Void {
    let value = GetDERegister() &+ 1;
    SetDERegister(value: value);
    EmulatorCycles(CPUCycles: 1);
}

// This function increments D register by 1. 0x14
func INCD() -> Void {
    CPUStateInstance.registersState.d &+= 1;
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.d == 0 {
        equalToZero = 1;
    }
    var halfCarry: UInt8 = 0;
    if CPUStateInstance.registersState.d & 0x0F == 0 {
        halfCarry = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2);
}

// This instruction Decrements the D register by 1 0x15
func DECD() -> Void {
    CPUStateInstance.registersState.d &-= 1;
    let value = CPUStateInstance.registersState.d;
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

//0x16
func LDDd8() -> Void {
    CPUStateInstance.registersState.d = BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc += 1;
}

//0x17
func RLA() -> Void {
    let carryFlag: UInt8 = CPUStateInstance.registersState.a & (1 << 7);
    CPUStateInstance.registersState.a <<= 1;
    if IsCFlagSet() {
        //carryFlag = 1;
        CPUStateInstance.registersState.a |= 1;
    }
    SetFlagsRegister(z: 0, n: 0, h: 0, c: carryFlag);

}

//0x18 Add BusRead(address: CPUStateInstance.registersState.pc) to pc address and jump to it. convert to signed 8 bit immediate value
func JRr8() -> Void {
    var fetchedData = Int8(bitPattern: BusRead(address: CPUStateInstance.registersState.pc));
    CPUStateInstance.registersState.pc += 1
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc = UInt16(truncatingIfNeeded: Int(CPUStateInstance.registersState.pc) + Int(fetchedData));
    EmulatorCycles(CPUCycles: 1);
}

//0x1B
func DECDE() -> Void {
    let value = GetDERegister() &- 1;
    SetDERegister(value: value);
    EmulatorCycles(CPUCycles: 1);
}
// This function increments E register by 1. 0x1C
func INCE() -> Void {
    CPUStateInstance.registersState.e &+= 1;
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.e == 0 {
        equalToZero = 1;
    }
    var halfCarry: UInt8 = 0;
    if CPUStateInstance.registersState.e & 0x0F == 0 {
        halfCarry = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2)
}

// This instruction Decrements the E register by 1 0x1D
func DECE() -> Void {
    CPUStateInstance.registersState.e &-= 1;
    let value = CPUStateInstance.registersState.e;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    var halfCarry: UInt8 = 0;
    
    if value & 0x0F == 0x0F {
        halfCarry = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: 2)
}

//0x1E
func LDEd8() -> Void {
    CPUStateInstance.registersState.e = BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc += 1;
}

//0x1F
func RRA() -> Void {
    let carryFlag: UInt8 = CPUStateInstance.registersState.a & 1;
    CPUStateInstance.registersState.a >>= 1;
    if IsCFlagSet() {
        //carryFlag = 1;
        CPUStateInstance.registersState.a |= (1 << 7);
    }
    SetFlagsRegister(z: 0, n: 0, h: 0, c: carryFlag);
    
}

//0x20 Add BusRead(address: CPUStateInstance.registersState.pc) to pc address and jump to it. convert to signed 8 bit immediate value
func JRNZr8() -> Void {
    var fetchedData = Int8(bitPattern: BusRead(address: CPUStateInstance.registersState.pc));
    CPUStateInstance.registersState.pc += 1
    EmulatorCycles(CPUCycles: 1);
    if !IsZFlagSet() {
        CPUStateInstance.registersState.pc = UInt16(truncatingIfNeeded: Int(CPUStateInstance.registersState.pc) + Int(fetchedData));
        EmulatorCycles(CPUCycles: 1);
    }
}

//0x21
func LDHLd16() -> Void {
    SetHLRegister(value: FetchD16());
}

//0x22
func LDHLIncA() -> Void {
    BusWrite(address: GetHLRegister(), value: CPUStateInstance.registersState.a)
    EmulatorCycles(CPUCycles: 1);
    let value = GetHLRegister() + 1;
           SetHLRegister(value: value);
}

//0x23
func INCHL() -> Void {
    let value = GetHLRegister() &+ 1;
    SetHLRegister(value: value);
    EmulatorCycles(CPUCycles: 1);
}

// This function increments H register by 1. 0x24
func INCH() -> Void {
    CPUStateInstance.registersState.h &+= 1;
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.h == 0 {
        equalToZero = 1;
    }
    var halfCarry: UInt8 = 0;
    
    if CPUStateInstance.registersState.h & 0x0F == 0 {
        halfCarry = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2);
}

// This instruction Decrements the H register by 1 0x25
func DECH() -> Void {
    CPUStateInstance.registersState.h &-= 1;
    let value = CPUStateInstance.registersState.h;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    else{
        equalToZero = 0;
    }
    var halfCarry: UInt8 = 0;
    if value & 0x0F == 0x0F {
        halfCarry = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: 2);
}

//0x26
func LDHd8() -> Void {
    CPUStateInstance.registersState.h = BusRead(address: CPUStateInstance.registersState.pc);
    //emulator cycles
    CPUStateInstance.registersState.pc &+= 1;
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
        CPUStateInstance.registersState.a =  CPUStateInstance.registersState.a &- u;
    }
    else {
        CPUStateInstance.registersState.a &+= u;
    }
    if CPUStateInstance.registersState.a == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero, n: 2, h: 0, c: carryFlag);
}

//0x28 Add BusRead(address: CPUStateInstance.registersState.pc) to pc address and jump to it. convert to signed 8 bit immediate value
func JRZr8() -> Void {
    var fetchedData = Int8(bitPattern: BusRead(address: CPUStateInstance.registersState.pc));
    CPUStateInstance.registersState.pc += 1;
    EmulatorCycles(CPUCycles: 1);
    if IsZFlagSet() {
        CPUStateInstance.registersState.pc = UInt16(truncatingIfNeeded: Int(CPUStateInstance.registersState.pc) + Int(fetchedData));
        EmulatorCycles(CPUCycles: 1);
    }
}

//0x2B
func DECHL() -> Void {
    let value = GetHLRegister() &- 1;
    SetHLRegister(value: value);
    EmulatorCycles(CPUCycles: 1);
}


// This function increments L register by 1. 0x2C
func INCL() -> Void {
    CPUStateInstance.registersState.l &+= 1;
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.l == 0 {
        equalToZero = 1;
    }
    var halfCarry: UInt8 = 0;
    if CPUStateInstance.registersState.l & 0x0F == 0 {
        halfCarry = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2);
}

// This instruction Decrements the L register by 1 0x2D
func DECL() -> Void {
    CPUStateInstance.registersState.l &-= 1;
    let value = CPUStateInstance.registersState.l;
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

//0x2E
func LDLd8() -> Void {
    CPUStateInstance.registersState.l = BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc += 1;
}

//0x2F. This is the complement of A register
func CPL() -> Void {
    CPUStateInstance.registersState.a = ~CPUStateInstance.registersState.a;
}

//0x30 Add BusRead(address: CPUStateInstance.registersState.pc) to pc address and jump to it. convert to signed 8 bit immediate value
func JRNCr8() -> Void {
    var fetchedData = Int8(bitPattern: BusRead(address: CPUStateInstance.registersState.pc));
    CPUStateInstance.registersState.pc += 1
    EmulatorCycles(CPUCycles: 1);
    if !IsCFlagSet() {
        CPUStateInstance.registersState.pc = UInt16(truncatingIfNeeded: Int(CPUStateInstance.registersState.pc) + Int(fetchedData));
        EmulatorCycles(CPUCycles: 1);
    }
}
//0x31
func LDSPa16() -> Void {
    CPUStateInstance.registersState.sp = FetchD16();
    EmulatorCycles(CPUCycles: 1);
}

//0x32
func LDHLDecA() -> Void {
    BusWrite(address: GetHLRegister(), value: CPUStateInstance.registersState.a)
    EmulatorCycles(CPUCycles: 1);
    let value = GetHLRegister() &- 1;
           SetHLRegister(value: value);
}

//0x33
func INCSP() -> Void {
    CPUStateInstance.registersState.sp += 1;
}

//0x34
func INCHL0x34() -> Void {
    let value = BusRead(address: GetHLRegister()) &+ 1;
    EmulatorCycles(CPUCycles: 2);
    BusWrite(address: GetHLRegister(), value: value);
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    var halfCarry: UInt8 = 0;
    if value & 0x0F == 0 {
        halfCarry = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2);
}
//0x35
func DECHL0x35() -> Void {
    let value:UInt32 = UInt32(BusRead(address: GetHLRegister())) &- 1;
    EmulatorCycles(CPUCycles: 2);
    BusWrite(address: GetHLRegister(), value: UInt8(value & 0xFF));
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
//0x36
func LDHLd8() -> Void {
    let value = BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc += 1;
    BusWrite(address: GetHLRegister(), value: value);
    EmulatorCycles(CPUCycles: 1);
}


//0x37 Set carry flag
func SCF() -> Void {
    SetFlagsRegister(z: 2, n: 0, h: 0, c: 1);
}

//0x38 Add BusRead(address: CPUStateInstance.registersState.pc) to pc address and jump to it. convert to signed 8 bit immediate value
func JRCr8() -> Void {
    var fetchedData = Int8(bitPattern: BusRead(address: CPUStateInstance.registersState.pc));
    CPUStateInstance.registersState.pc += 1
    EmulatorCycles(CPUCycles: 1);
    if IsCFlagSet() {
        CPUStateInstance.registersState.pc = UInt16(truncatingIfNeeded: Int(CPUStateInstance.registersState.pc) + Int(fetchedData));
        EmulatorCycles(CPUCycles: 1);
    }
}

// This instruction Decrements the stack pointer register by 1 0x3B
func DECSP() -> Void {
    CPUStateInstance.registersState.sp &-= 1;
    EmulatorCycles(CPUCycles: 1);
    let value = CPUStateInstance.registersState.sp;
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
    CPUStateInstance.registersState.a &+= 1;
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.a == 0 {
        equalToZero = 1;
    }
    var halfCarry: UInt8 = 0;
    if CPUStateInstance.registersState.a & 0x0F == 0 {
        halfCarry = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: 2);
}

// This instruction Decrements the A register by 1 0x3D
func DECA() -> Void {
    CPUStateInstance.registersState.a &-= 1;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    var halfCarry: UInt8 = 0;
    if value & 0x0F == 0 {
        halfCarry = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: 2);
}

//0x3E
func LDAd8() -> Void {
    CPUStateInstance.registersState.a = BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc += 1;
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

//0x46
func LDBHL() -> Void {
    CPUStateInstance.registersState.b = BusRead(address: GetHLRegister());
    EmulatorCycles(CPUCycles: 1);
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
    EmulatorCycles(CPUCycles: 1);
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

//0x56
func LDDHL() -> Void {
    CPUStateInstance.registersState.d = BusRead(address: GetHLRegister());
    EmulatorCycles(CPUCycles: 1);
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
    EmulatorCycles(CPUCycles: 1);
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

//0x66
func LDHHL() -> Void {
    CPUStateInstance.registersState.h = BusRead(address: GetHLRegister());
    EmulatorCycles(CPUCycles: 1);
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
    EmulatorCycles(CPUCycles: 1);
}
// Put the value of A into L register 0x6F
func LDLA() -> Void {
    CPUStateInstance.registersState.l = CPUStateInstance.registersState.a;
}

//0x70-0x75, 0x77
func LDHLn(register: UInt8) {
    BusWrite(address: GetHLRegister(), value: register);
    EmulatorCycles(CPUCycles: 1);
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
    EmulatorCycles(CPUCycles: 1);
}

//Put the value of A into A register 0x7F
func LDAA() -> Void {
    CPUStateInstance.registersState.a = CPUStateInstance.registersState.a;
}

//Add the value stored in B register to A register. 0x80
func ADDAB() -> Void {
    var halfCarry: UInt8 = 0;
    if ((CPUStateInstance.registersState.a & 0xF) + (CPUStateInstance.registersState.b & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(CPUStateInstance.registersState.b & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &+= CPUStateInstance.registersState.b;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag);
}
//Add the value stored in C register to A register. 0x81
func ADDAC() -> Void {
    var halfCarry: UInt8 = 0;
    let add = CPUStateInstance.registersState.c;
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &+= add;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag);
}

//Add the value stored in D register to A register. 0x82
func ADDAD() -> Void {
    var halfCarry: UInt8 = 0;
    let add = CPUStateInstance.registersState.d;
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &+= add;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag);
}

//Add the value stored in E register to A register. 0x83
func ADDAE() -> Void {
    var halfCarry: UInt8 = 0;
    let add = CPUStateInstance.registersState.e;
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &+= add;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
}

//Add the value stored in H register to A register. 0x84
func ADDAH() -> Void {
    var halfCarry: UInt8 = 0;
    let add = CPUStateInstance.registersState.h;
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &+= add;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
}

//Add the value stored in L register to A register. 0x85
func ADDAL() -> Void {
    var halfCarry: UInt8 = 0;
    let add = CPUStateInstance.registersState.l;
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &+= add;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
}

//0x86
func ADDAHL() -> Void {
    var halfCarry: UInt8 = 0;
    let add = BusRead(address: GetHLRegister());
    EmulatorCycles(CPUCycles: 1);
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &+= add;
    
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
}

//Add the value stored in A register to A register. 0x87
func ADDAA() -> Void {
    var halfCarry: UInt8 = 0;
    let add = CPUStateInstance.registersState.a;
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &+= add;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
}

//0x88-0x8D. 0x8E 0x8F, 0xCE
func ADCA8Bit(register: UInt8) -> Void {
    var halfCarry: UInt8 = 0;
    var carryFlag: UInt8 = 0;
    //var add = CPUStateInstance.registersState.d;
    var carryFlagValue: UInt8 = (1 << 4);
    if  CPUStateInstance.registersState.f & carryFlagValue != carryFlagValue{
        carryFlagValue = 0;
    }
    if (CPUStateInstance.registersState.a & 0xF) +
        (register & 0xF) + carryFlagValue > 0xF {
        halfCarry = 1;
    }
    if (Int(CPUStateInstance.registersState.a) + Int(register) + Int(carryFlagValue))  > 0xFF {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &+=  register &+ carryFlagValue;
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.a == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero, n: 0, h: halfCarry, c: carryFlag);
}



//Subtract the value stored in B register from value in A register. 0x90
func SUBB() -> Void {
    var halfCarry: UInt8 = 0;
    let subtract = CPUStateInstance.registersState.b;
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &-= subtract;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//Subtract the value stored in C register from value in A register. 0x91
func SUBC() -> Void {
    var halfCarry: UInt8 = 0;
    let subtract = CPUStateInstance.registersState.c;
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &-= subtract;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//Subtract the value stored in D register from value in A register. 0x92
func SUBD() -> Void {
    var halfCarry: UInt8 = 0;
    let subtract = CPUStateInstance.registersState.d;
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &-= subtract;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//Subtract the value stored in E register from value in A register. 0x93
func SUBE() -> Void {
    var halfCarry: UInt8 = 0;
    let subtract = CPUStateInstance.registersState.e;
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &-= subtract;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag);
}

// Subtract the value stored in H register from value in A register. 0x94
func SUBH() -> Void {
    var halfCarry: UInt8 = 0
    let subtract = CPUStateInstance.registersState.h
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &-= subtract
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero, n: 1, h: halfCarry, c: carryFlag)
}


//Subtract the value stored in L register from value in A register. 0x95
func SUBL() -> Void {
    var halfCarry: UInt8 = 0;
    let subtract = CPUStateInstance.registersState.l;
    
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &-= subtract;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//0x96
func SUBHL() -> Void {
    var halfCarry: UInt8 = 0;
    let subtract = BusRead(address: GetHLRegister());
    EmulatorCycles(CPUCycles: 1);
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &-= subtract;
    let value = CPUStateInstance.registersState.a;
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
    SetFlagsRegister(z: 1 , n: 1, h: 0, c: 0);
}

//0x98 - 0x9F
func SBCAn(register: UInt8 ) -> Void {
    var halfCarry: UInt8 = 0;
    var carryFlag: UInt8 = 0;
    //var subtract = CPUStateInstance.registersState.b;
    var carryFlagValue: UInt8 = (1 << 4);
    if  CPUStateInstance.registersState.f & carryFlagValue != carryFlagValue{
        carryFlagValue = 0;
    }
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(register & 0xF) - Int(carryFlagValue)) < 0x0 {
        halfCarry = 1;
    }
    if (Int(CPUStateInstance.registersState.a) - Int(register) - Int(carryFlagValue)) < 0x0 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &-=  register &+ carryFlagValue;
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
    EmulatorCycles(CPUCycles: 1);
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
    EmulatorCycles(CPUCycles: 1);
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
    EmulatorCycles(CPUCycles: 1);
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
    let subtract = CPUStateInstance.registersState.b;
    let value = Int(CPUStateInstance.registersState.a) - Int(subtract);
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
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag);
}

//0xB9
func CPC() -> Void {
    let subtract = CPUStateInstance.registersState.c;
    let value = Int(CPUStateInstance.registersState.a) - Int(subtract);
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
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag);
}

//0xBA
func CPD() -> Void {
    let subtract = CPUStateInstance.registersState.d;
    let value = Int(CPUStateInstance.registersState.a) - Int(subtract);
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
    
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag);
}

//0xBB
func CPE() -> Void {
    let subtract = CPUStateInstance.registersState.e;
    let value = Int(CPUStateInstance.registersState.a) - Int(subtract);
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
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag);
}

//0xBC
func CPH() -> Void {
    let subtract = CPUStateInstance.registersState.h;
    let value = Int(CPUStateInstance.registersState.a) - Int(subtract);
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
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag);
}

//0xBD
func CPLBD() -> Void {
    let subtract = CPUStateInstance.registersState.l;
    let value = Int(CPUStateInstance.registersState.a) - Int(subtract);
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
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag);
}

//0xBE
func CPLHL() -> Void {
    let subtract = BusRead(address: GetHLRegister());
    EmulatorCycles(CPUCycles: 1);
    let value = Int(CPUStateInstance.registersState.a) - Int(subtract);
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
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag);
}

//0xBF
func CPA() -> Void {
    let subtract = CPUStateInstance.registersState.a;
    let value = Int(CPUStateInstance.registersState.a) - Int(subtract);
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
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag);
}

//0xC0
func RETNZ() -> Void {
    EmulatorCycles(CPUCycles: 1);
    if !IsZFlagSet() {
        let lowByte: UInt16 = UInt16(StackPop());
        EmulatorCycles(CPUCycles: 1);
        let highByte: UInt16 = UInt16(StackPop());
        EmulatorCycles(CPUCycles: 1);
        CPUStateInstance.registersState.pc = (highByte << 8) | lowByte;
    }
}

//0xC1
func POPBC() -> Void {
    SetBCRegister(value: StackPop16Bit());
    EmulatorCycles(CPUCycles: 2);
}

//Jump To Address A16 If Z Flag Is Reset 0xC2
func JPNZa16() -> Void {
    if !IsZFlagSet() {
        JPa16()
    }
    else {
        EmulatorCycles(CPUCycles: 2);
        CPUStateInstance.registersState.pc += 2;
    }
}

// Jump to address a16 0xC3
func JPa16() -> Void {
    CPUStateInstance.registersState.pc = FetchD16();
    EmulatorCycles(CPUCycles: 1);
}

//0xC4
func CALLNZa16() -> Void {
    if !IsZFlagSet() {
        CALLa16();
    }
    else {
        EmulatorCycles(CPUCycles: 2);
        CPUStateInstance.registersState.pc += 2;
    }
}

//0xC5
func PUSHBC() -> Void {
    StackPush16Bit(data: GetBCRegister());
    EmulatorCycles(CPUCycles: 3);
}

//Add 8 bit value from BusRead to register to A register. 0xC6
func ADDAd8() -> Void {
    var halfCarry: UInt8 = 0;
    let add = BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 3);
    CPUStateInstance.registersState.pc += 1;
    if ((CPUStateInstance.registersState.a & 0xF) + (add & 0xF)) >= 0x10 {
        halfCarry = 1;
    }
    
    var carryFlag: UInt8 = 0;
    
    if (Int(CPUStateInstance.registersState.a & 0xFF) + Int(add & 0xFF)) >= 0x100 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &+= add;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 0, h: halfCarry, c: carryFlag)
}
//0xC7, 0xD7, 0xE7, 0xF7, 0xCF, 0xDF, 0xEF, 0xFF,
func RSTnH(address: UInt16) -> Void {
    EmulatorCycles(CPUCycles: 2);
    StackPush16Bit(data: CPUStateInstance.registersState.pc);
    CPUStateInstance.registersState.pc = address;
    EmulatorCycles(CPUCycles: 1);
}

//0xC8
func RETZ() -> Void {
    //emu cyc
    if IsZFlagSet() {
        let lowByte: UInt16 = UInt16(StackPop());
        EmulatorCycles(CPUCycles: 1);
        let highByte: UInt16 = UInt16(StackPop());
        EmulatorCycles(CPUCycles: 1);
        CPUStateInstance.registersState.pc = (highByte << 8) | lowByte;
    }
}

//0xC9
func RET() -> Void {
    let lowByte: UInt16 = UInt16(StackPop());
    EmulatorCycles(CPUCycles: 1);
    let highByte: UInt16 = UInt16(StackPop());
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc = (highByte << 8) | lowByte;
}

//0xCA
func JPZa16() -> Void {
    if IsZFlagSet() {
        JPa16()
    }
    else {
        EmulatorCycles(CPUCycles: 2);
        CPUStateInstance.registersState.pc += 2;
    }
}

//CB instruction table functions
func GetRegisterValueCB(register: String) -> UInt8 {
    if register == "b" {
        return CPUStateInstance.registersState.b;
    } else if register == "c" {
        return CPUStateInstance.registersState.c;
    } else if register == "d" {
        return CPUStateInstance.registersState.d;
    } else if register == "e" {
        return CPUStateInstance.registersState.e;
    } else if register == "h" {
        return CPUStateInstance.registersState.h;
    } else if register == "l" {
        return CPUStateInstance.registersState.l;
    } else if register == "(hl)" {
        return BusRead(address: GetHLRegister());
    } else {
        return CPUStateInstance.registersState.a;
    }

}
func SetRegisterValueCB(register: String, value: UInt8) -> Void {
    switch register {
    case "b":
        CPUStateInstance.registersState.b = value;
    case "c":
        CPUStateInstance.registersState.c = value;
    case "d":
        CPUStateInstance.registersState.d = value;
    case "e":
        CPUStateInstance.registersState.e = value;
    case "h":
        CPUStateInstance.registersState.h = value;
    case "l":
        CPUStateInstance.registersState.l = value;
    case "(hl)":
        BusWrite(address: GetHLRegister(), value: value);
    default:
        CPUStateInstance.registersState.a = value;
    }
}

func RLCCB(register: String) -> Void {
    var carryFlag: UInt8 = 0;
    var equalToZero: UInt8 = 0;
    var value: UInt8 = GetRegisterValueCB(register: register);
    if value & (1 << 7) == (1 << 7) {
        carryFlag = 1;
    }
    value <<= 1;
    value |= carryFlag;
    if value == 0 {
        equalToZero = 1;
    }
    SetRegisterValueCB(register: register, value: value);
    SetFlagsRegister(z: equalToZero, n: 0, h: 0, c: carryFlag);
}

func RRCCB(register: String) -> Void {
    var carryFlag: UInt8 = 0;
    var equalToZero: UInt8 = 0;
    var value: UInt8 = GetRegisterValueCB(register: register);
    if value & 1 == 1 {
        carryFlag = 1;
    }
    value >>= 1;
    value |= (carryFlag << 7);
    if value == 0 {
        equalToZero = 1;
    }
    SetRegisterValueCB(register: register, value: value);
    SetFlagsRegister(z: equalToZero, n: 0, h: 0, c: carryFlag);
}

func RLCB(register: String) -> Void {
    var carryFlag: UInt8 = 0;
    var equalToZero: UInt8 = 0;
    var value: UInt8 = GetRegisterValueCB(register: register);
    if value & (1 << 7) == (1 << 7) {
        carryFlag = 1;
    }
    value <<= 1;
    if IsCFlagSet() {
        value |= 1;
    }
    if value == 0 {
        equalToZero = 1;
    }
    SetRegisterValueCB(register: register, value: value);
    SetFlagsRegister(z: equalToZero, n: 0, h: 0, c: carryFlag);
}

func RRCB(register: String) -> Void {
    var carryFlag: UInt8 = 0;
    var equalToZero: UInt8 = 0;
    var value: UInt8 = GetRegisterValueCB(register: register);
    if value & 1 == 1 {
        carryFlag = 1;
    }
    value >>= 1;
    if IsCFlagSet() {
        value |= (1 << 7);
    }
    if value == 0 {
        equalToZero = 1;
    }
    SetRegisterValueCB(register: register, value: value);
    SetFlagsRegister(z: equalToZero, n: 0, h: 0, c: carryFlag);
}

func SLACB(register: String) -> Void {
    var carryFlag: UInt8 = 0;
    var equalToZero: UInt8 = 0;
    var value: UInt8 = GetRegisterValueCB(register: register);
    if value & (1 << 7) == (1 << 7) {
        carryFlag = 1;
    }
    value <<= 1;
    if value == 0 {
        equalToZero = 1;
    }
    SetRegisterValueCB(register: register, value: value);
    SetFlagsRegister(z: equalToZero, n: 0, h: 0, c: carryFlag);
}

func SRACB(register: String) -> Void {
    var carryFlag: UInt8 = 0;
    var equalToZero: UInt8 = 0;
    var value: UInt8 = GetRegisterValueCB(register: register);
    if value & 1 == 1 {
        carryFlag = 1;
    }
    value >>= 1;
    if value == 0 {
        equalToZero = 1;
    }
    SetRegisterValueCB(register: register, value: value);
    SetFlagsRegister(z: equalToZero, n: 0, h: 0, c: carryFlag);
}

func SWAPCB(register: String) -> Void {
    var equalToZero: UInt8 = 0;
    let value: UInt8 = ((GetRegisterValueCB(register: register) & 0xF0) >> 4) | ((GetRegisterValueCB(register: register) & 0x0F) << 4);
    if value == 0 {
        equalToZero = 1;
    }
    SetRegisterValueCB(register: register, value: value);
    SetFlagsRegister(z: equalToZero, n: 0, h: 0, c: 0);
}

func SRLCB(register: String) -> Void {
    var carryFlag: UInt8 = 0;
    var equalToZero: UInt8 = 0;
    var value: UInt8 = GetRegisterValueCB(register: register);
    if value & 1 == 1 {
        carryFlag = 1;
    }
    value >>= 1;
    if value == 0 {
        equalToZero = 1;
    }
    SetRegisterValueCB(register: register, value: value);
    SetFlagsRegister(z: equalToZero, n: 0, h: 0, c: carryFlag);
}

func BITCB(bit: UInt8, register: String) -> Void {
    var bitValue: UInt8 = 1;
    let value: UInt8 = GetRegisterValueCB(register: register);
    if value & (1 << bit) == (1 << bit) {
        bitValue = 0;
    }
    SetFlagsRegister(z: bitValue, n: 0, h: 1, c: 2);
}

func RESCB(bit: UInt8, register: String) -> Void {
    let value: UInt8 = GetRegisterValueCB(register: register) & ~(1 << bit);
    SetRegisterValueCB(register: register, value: value);
}

func SETCB(bit: UInt8, register: String) -> Void {
    let value: UInt8 = GetRegisterValueCB(register: register) | (1 << bit);
    SetRegisterValueCB(register: register, value: value);
}

func GetRegisterCB(opcode: UInt8) -> String {
    var register: String;
    if opcode & 0b111 == 0x00 {
        register = "b";
    }
    else if opcode & 0b111 == 0x01 {
        register = "c";
    }
    else if opcode & 0b111 == 0x02 {
        register = "d";
    }
    else if opcode & 0b111 == 0x03 {
        register = "e";
    }
    else if opcode & 0b111 == 0x04 {
        register = "h";
    }
    else if opcode & 0b111 == 0x05 {
        register = "l";
    }
    else if opcode & 0b111 == 0x06 {
        EmulatorCycles(CPUCycles: 2);
        register = "(hl)";
        //address = BusRead(address: GetHLRegister());
    }
    else {
        register = "a";
    }
    return register;
}

//0xCB
func PREFIXCB() -> Void {
    let opcode = BusRead(address: CPUStateInstance.registersState.pc);
    //emu cyc maybe
    CPUStateInstance.registersState.pc += 1;
    var register: String = GetRegisterCB(opcode: opcode);
    //var address: UInt8?;
    var bit: UInt8 = (opcode >> 3) & 0b111;
    EmulatorCycles(CPUCycles: 1);
    if opcode <= 0x07 {
        RLCCB(register: register);
    }
    else if opcode <= 0x0F {
        RRCCB(register: register);
    }
    else if opcode <= 0x17 {
        RLCB(register: register);
    }
    else if opcode <= 0x1F {
        RRCB(register: register);
    }
    else if opcode <= 0x27 {
        SLACB(register: register);
    }
    else if opcode <= 0x2F {
        SRACB(register: register);
    }
    else if opcode <= 0x37 {
        SWAPCB(register: register);
    }
    else if opcode <= 0x3F {
        SRLCB(register: register);
    }
    else if opcode <= 0x7F {
        BITCB(bit: bit, register: register);
    }
    else if opcode <= 0xBF {
        RESCB(bit: bit, register: register);
    }
    else if opcode <= 0xFF {
        SETCB(bit: bit, register: register);
    }
    
}
//0xCC
func CALLZa16() -> Void {
    if IsZFlagSet() {
        CALLa16();
    }
    else {
        EmulatorCycles(CPUCycles: 2);
        CPUStateInstance.registersState.pc += 2;
    }
}

//0xCD
func CALLa16() -> Void {
    let fetchedD16 = FetchD16();
    EmulatorCycles(CPUCycles: 2);
    StackPush16Bit(data: CPUStateInstance.registersState.pc);
    CPUStateInstance.registersState.pc = fetchedD16;
    EmulatorCycles(CPUCycles: 1);
}

//0xCE
func ADCAd8() -> Void {
    var halfCarry: UInt8 = 0;
    var carryFlag: UInt8 = 0;
    let add = BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc += 1;
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
    CPUStateInstance.registersState.a &+=  add &+ carryFlagValue;
    var equalToZero: UInt8 = 0;
    if CPUStateInstance.registersState.a == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero, n: 0, h: halfCarry, c: carryFlag);
}

//0xD0
func RETNC() -> Void {
    EmulatorCycles(CPUCycles: 1);
    if !IsCFlagSet() {
        let lowByte: UInt16 = UInt16(StackPop());
        EmulatorCycles(CPUCycles: 1);
        let highByte: UInt16 = UInt16(StackPop());
        EmulatorCycles(CPUCycles: 1);
        CPUStateInstance.registersState.pc = (highByte << 8) | lowByte;
    }
}

//0xD1
func POPDE() -> Void {
    SetDERegister(value: StackPop16Bit());
    EmulatorCycles(CPUCycles: 2);
}

//Jump To Address A16 If Z Flag Is Reset 0xD2
func JPNCa16() -> Void {
    if !IsCFlagSet() {
        JPa16()
    }
    else {
        EmulatorCycles(CPUCycles: 2);
        CPUStateInstance.registersState.pc += 2;
    }
}

//0xD4
func CALLNCa16() -> Void {
    if !IsCFlagSet() {
        CALLa16();
    }
    else {
        EmulatorCycles(CPUCycles: 2);
        CPUStateInstance.registersState.pc += 2;
    }
}

//0xD5
func PUSHDE() -> Void {
    StackPush16Bit(data: GetDERegister());
    EmulatorCycles(CPUCycles: 3);
}

//Subtract the value BusRead from value in A register. 0xD6
func SUBd8() -> Void {
    var halfCarry: UInt8 = 0;
    let subtract = BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc += 1;
    
    if (Int(CPUStateInstance.registersState.a & 0xF) - Int(subtract & 0xF)) < 0x0 {
        halfCarry = 1;
    }
    var carryFlag: UInt8 = 0;
    if (Int(CPUStateInstance.registersState.a) - Int(subtract)) < 0 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.a &-= subtract;
    let value = CPUStateInstance.registersState.a;
    var equalToZero: UInt8 = 0;
    if value == 0 {
        equalToZero = 1;
    }
    SetFlagsRegister(z: equalToZero , n: 1, h: halfCarry, c: carryFlag)
}

//0xD8
func RETC() -> Void {
    EmulatorCycles(CPUCycles: 1);
    if IsCFlagSet() {
        let lowByte: UInt16 = UInt16(StackPop());
        EmulatorCycles(CPUCycles: 1);
        let highByte: UInt16 = UInt16(StackPop());
        EmulatorCycles(CPUCycles: 1);
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
        EmulatorCycles(CPUCycles: 2);
        CPUStateInstance.registersState.pc += 2;
    }
}

//0xDC
func CALLCa16() -> Void {
    if IsCFlagSet() {
        CALLa16();
    }
    else {
        EmulatorCycles(CPUCycles: 2);
        CPUStateInstance.registersState.pc += 2;
    }
}

//0xDE
func SBCAd8( ) -> Void {
    var halfCarry: UInt8 = 0;
    var carryFlag: UInt8 = 0;
    let subtract = BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc &+= 1;
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
    CPUStateInstance.registersState.a &-=  subtract &+ carryFlagValue;
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
    let value: UInt16 = CPUStateInstance.registersState.pc
    var address: UInt16 = UInt16(BusRead(address: value)) | 0xFF00;
    EmulatorCycles(CPUCycles: 1);
    BusWrite(address: address, value: CPUStateInstance.registersState.a);
    CPUStateInstance.registersState.pc += 1;
    EmulatorCycles(CPUCycles: 1);
}

//0xE1
func POPHL() -> Void {
    SetHLRegister(value: StackPop16Bit());
    EmulatorCycles(CPUCycles: 2);
}

//0xE2
func LDCAE2() -> Void {
    //can also be addition?
    var address = 0xFF00 | UInt16(CPUStateInstance.registersState.c);
    BusWrite(address: address , value: CPUStateInstance.registersState.a);
    EmulatorCycles(CPUCycles: 1);
}

//0xE5
func PUSHHL() -> Void {
    StackPush16Bit(data: GetHLRegister());
    EmulatorCycles(CPUCycles: 3);
}

//0xE6
func ANDd8() -> Void {
    CPUStateInstance.registersState.a &= BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc &+= 1;
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
    CPUStateInstance.registersState.sp = UInt16(Int(CPUStateInstance.registersState.sp) + Int(Int8(BusRead(address:  CPUStateInstance.registersState.sp))));
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.sp += 1;
    EmulatorCycles(CPUCycles: 1);
    SetFlagsRegister(z: 0, n: 0, h: halfCarry, c: carryFlag);
}

//0xE9
func JPHL() -> Void {
    CPUStateInstance.registersState.pc = GetHLRegister();
    //emu cyc maybe double check
}

//0xEA
func LDa16A() -> Void {
    BusWrite(address: FetchD16(), value: CPUStateInstance.registersState.a);
    EmulatorCycles(CPUCycles: 1);
}

//0xEE
func XORd8() -> Void {
    let value = BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc &+= 1;
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
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.a = BusRead(address: 0xFF00 | fetchedData);
    CPUStateInstance.registersState.pc += 1;
    EmulatorCycles(CPUCycles: 1);
}

//0xF1 lower 4 bits of f reg are not used and w FFF0
func POPAF() -> Void {
    SetAFRegister(value: StackPop16Bit() & 0xFFF0);
    EmulatorCycles(CPUCycles: 1);
}

//0xF2
func LDACF2() -> Void {
    //can also be addition?
    var address = 0xFF00 | UInt16(CPUStateInstance.registersState.c);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.a = BusRead(address: address);
    EmulatorCycles(CPUCycles: 1);
}

//0xF3
func DI() -> Void {
    CPUStateInstance.interruptMasterEnable = false;
}

//0xF5
func PUSHAF() -> Void {
    StackPush16Bit(data: GetAFRegister());
    EmulatorCycles(CPUCycles: 3);
}

//0xF6
func ORd8() -> Void {
    CPUStateInstance.registersState.a |= BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc += 1;
    if CPUStateInstance.registersState.a == 0 {
        CPUStateInstance.registersState.f = 0b10000000;
    }
    else {
        CPUStateInstance.registersState.f = 0b00000000;
    }
}

//0xF8
func LDHLSPPlusR8() -> Void {
    EmulatorCycles(CPUCycles: 2);
    //emu cyc may be 1 cycle instead of 2
    let value = BusRead(address: CPUStateInstance.registersState.pc);
    var halfCarry: UInt8 = 0;
    var carryFlag: UInt8 = 0;
    if (CPUStateInstance.registersState.sp & 0xF) + UInt16(value & 0xF) > 0x10 {
        halfCarry = 1;
    }
    if UInt16(CPUStateInstance.registersState.sp & 0xFF) + UInt16(value & 0xFF) >= 0x100 {
        carryFlag = 1;
    }
    CPUStateInstance.registersState.pc += 1;
    SetHLRegister(value: UInt16(Int(Int8(value)) + Int(CPUStateInstance.registersState.sp)));
    SetFlagsRegister(z: 0, n: 0, h: halfCarry, c: carryFlag);
}

//0xF9
func LDSPHL() -> Void {
    CPUStateInstance.registersState.sp = GetHLRegister();
    EmulatorCycles(CPUCycles: 1);
}

//0xFA
func LDAa16() -> Void {
    CPUStateInstance.registersState.a = BusRead(address: FetchD16());
    EmulatorCycles(CPUCycles: 1);
}
//0xFB
func FI() -> Void {
    CPUStateInstance.enablingIME = true;
}

//0xFE
func CPd8() -> Void {
    let subtract = BusRead(address: CPUStateInstance.registersState.pc);
    EmulatorCycles(CPUCycles: 1);
    CPUStateInstance.registersState.pc &+= 1;
    let value = Int(CPUStateInstance.registersState.a) - Int(subtract);
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
