//
//  Instructions.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 1/2/23.
//

import Foundation

enum AddressMode {
    case AM_IMP,
    AM_R_D16,
    AM_R_R,
    AM_MR_R,
    AM_R,
    AM_R_D8,
    AM_R_MR,
    AM_R_HLI,
    AM_R_HLD,
    AM_HLI_R,
    AM_HLD_R,
    AM_R_A8,
    AM_A8_R,
    AM_HL_SPR,
    AM_D16,
    AM_D8,
    AM_D16_R,
    AM_MR_D8,
    AM_MR,
    AM_A16_R,
    AM_R_A16
}

enum RegisterType {
    case RT_NONE,
    RT_A,
    RT_F,
    RT_B,
    RT_C,
    RT_D,
    RT_E,
    RT_H,
    RT_L,
    RT_AF,
    RT_BC,
    RT_DE,
    RT_HL,
    RT_SP,
    RT_PC
}

enum InstructionType {
    case IN_NONE,
    IN_NOP,
    IN_LD,
    IN_INC,
    IN_DEC,
    IN_RLCA,
    IN_ADD,
    IN_RRCA,
    IN_STOP,
    IN_RLA,
    IN_JR,
    IN_RRA,
    IN_DAA,
    IN_CPL,
    IN_SCF,
    IN_CCF,
    IN_HALT,
    IN_ADC,
    IN_SUB,
    IN_SBC,
    IN_AND,
    IN_XOR,
    IN_OR,
    IN_CP,
    IN_POP,
    IN_JP,
    IN_PUSH,
    IN_RET,
    IN_CB,
    IN_CALL,
    IN_RETI,
    IN_LDH,
    IN_JPHL,
    IN_DI,
    IN_EI,
    IN_RST,
    IN_ERR,
    //CB instructions
    IN_RLC,
    IN_RRC,
    IN_RL,
    IN_RR,
    IN_SLA,
    IN_SRA,
    IN_SWAP,
    IN_SRL,
    IN_BIT,
    IN_RES,
    IN_SET
}

enum ConditionType {
    case CT_NONE, CT_NZ, CT_Z, CT_NC, CT_C
}

struct Instruction {
    var type: InstructionType;
    var mode: AddressMode;
    var registerOne: RegisterType;
    var registerTwo: RegisterType;
    var condition: ConditionType;
    var parameter: UInt8;
    init() {
        type = InstructionType.IN_NOP;
        mode = AddressMode.AM_IMP;
        registerOne = RegisterType.RT_NONE;
        registerTwo = RegisterType.RT_NONE;
        condition = ConditionType.CT_NONE;
        parameter = 0;
    }
}
//Array Instructions
var Instructions = Array<Instruction>(repeating: Instruction.init() , count: 0x100);
//Gameboy CPU (LR35902) instruction set
//https://www.pastraiser.com/cpu/gameboy/gameboy_opcodes.html
func SetInstructions() {
   // var Instructions = Array<Instruction>(repeating: Instruction.init() , count: 0x100);
    Instructions[0x00].type = InstructionType.IN_NOP;
    Instructions[0x00].mode = AddressMode.AM_IMP;
    
    Instructions[0x01].type = InstructionType.IN_LD;
    Instructions[0x01].mode = AddressMode.AM_R_D16;
    Instructions[0x01].registerOne = RegisterType.RT_BC;
    
    Instructions[0x05].type = InstructionType.IN_DEC;
    Instructions[0x05].mode = AddressMode.AM_R;
    Instructions[0x05].registerOne = RegisterType.RT_B;
    
    Instructions[0x0E].type = InstructionType.IN_LD;
    Instructions[0x0E].mode = AddressMode.AM_R_D8;
    Instructions[0x0E].registerOne = RegisterType.RT_C;
}
