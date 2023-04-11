//
//  Interrupts.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 4/1/23.
//

import Foundation

enum InterruptTypes: UInt8 {
case VBLANK = 1,//bit 1
     LCDSTAT = 2,
     TIMER = 4,
     SERIAL = 8,
     JOYPAD = 16
}

func InterruptHandle(address: UInt16) -> Void {
    StackPush16Bit(data: CPUStateInstance.registersState.pc);
    CPUStateInstance.registersState.pc = address;
}

func InterruptCheck(address: UInt16, InterruptTypes: InterruptTypes) -> Bool {
    if ((CPUStateInstance.interruptFlags & InterruptTypes.rawValue) != 0) && ((CPUStateInstance.interruptEnableRegister & InterruptTypes.rawValue) != 0) {
        InterruptHandle(address: address);
        CPUStateInstance.interruptFlags &= ~InterruptTypes.rawValue;
        CPUStateInstance.halted = false;
        CPUStateInstance.interruptMasterEnable = false;
        return true;
       }
       
       return false
}

func CPUHandleInterrupts() -> Void {
    if InterruptCheck(address: 0x40, InterruptTypes: .VBLANK) {
            
        }
    else if InterruptCheck(address: 0x48, InterruptTypes: .LCDSTAT) {
            
        }
    else if InterruptCheck(address: 0x50, InterruptTypes: .TIMER) {
            
        }
    else if InterruptCheck(address: 0x58, InterruptTypes: .SERIAL) {
            
        }
    else if InterruptCheck(address: 0x60, InterruptTypes: .JOYPAD) {
            
        }
}
