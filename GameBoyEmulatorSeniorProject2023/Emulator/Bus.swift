//
//  Bus.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 1/1/23.
//

import Foundation


// 0x0000 - 0x3FFF : ROM Bank 0
// 0x4000 - 0x7FFF : ROM Bank 1 - Switchable
// 0x8000 - 0x97FF : CHR RAM
// 0x9800 - 0x9BFF : BG Map 1
// 0x9C00 - 0x9FFF : BG Map 2
// 0xA000 - 0xBFFF : Cartridge RAM
// 0xC000 - 0xCFFF : RAM Bank 0
// 0xD000 - 0xDFFF : RAM Bank 1-7 - switchable - Color only
// 0xE000 - 0xFDFF : Reserved - Echo RAM
// 0xFE00 - 0xFE9F : Object Attribute Memory
// 0xFEA0 - 0xFEFF : Reserved - Unusable
// 0xFF00 - 0xFF7F : I/O Registers
// 0xFF80 - 0xFFFE : Zero Page

func BusRead(address: UInt16) -> UInt8 {
    if address < 0x8000 {
        return CartridgeRead(address: address);
    }
    else if address < 0xA000 {
        return PPUStateInstance.vram[Int(address) - 0x8000];
    }
    else if address < 0xC000 {
        return CartridgeRead(address: address);
    }
    else if address < 0xE000 {
        let workingRAMAddress = address &- 0xC000;
        if workingRAMAddress >= 0x2000 {
            print("invalid");
            exit(-5)
        }
        return RAMStateInstance.workingRAM[Int(workingRAMAddress)];
    }
    else if address < 0xFE00 {
        //implement
    }
    else if address < 0xFEA0 {
       // ppu
        if DMATransferring() {
            return 0xFF;
        }
        return PPUOAMread(address: address);
    }
    else if address < 0xFF00 {
        //unusable
    }
    else if address < 0xFF80 {
        return IORead(address: address);
    }
    else if address == 0xFFFF {
        return GetInterruptEnableRegister();
    }
    return RAMStateInstance.highRAM[Int(address &- 0xFF80)];
}

func BusWrite(address: UInt16, value: UInt8) {
    if (address < 0x8000) {
        CartridgeWrite(address: address, value: value);
    }
    else if address < 0xA000 {
        PPUStateInstance.vram[Int(address) - 0x8000] = value;
    }
    else if address < 0xC000 {
        CartridgeWrite(address: address, value: value);
    }
    else if address < 0xE000 {
        RAMStateInstance.workingRAM[Int(address &- 0xC000)] = value;
    }
    else if address < 0xFE00 {
        //implement
    }
    else if address < 0xFEA0 {
        //ppu
        if DMATransferring() {
            return;
        }
        PPUOAMWrite(address: address, value: value);
    }
    else if address < 0xFF00 {
        //unusable
    }
    else if address < 0xFF80 {
        IOWrite(address: address, value: value);
    }
    else if address == 0xFFFF {
        SetInterruptEnableRegister(value: value);
    }
    else{
        RAMStateInstance.highRAM[Int(address &- 0xFF80)] = value;
    }
}

var SerialData: [UInt8] = [UInt8](repeating: 0, count: 2);

func BusRead16Bit(address: UInt16) -> UInt16 {
    let lowByte: UInt16 = UInt16(BusRead(address: address));
    let highByte: UInt16 = UInt16(BusRead(address: address + 1));
    return lowByte | (highByte << 8);
}

func BusWrite16Bit(address: UInt16, value: UInt16) {
    BusWrite(address: address + 1, value: UInt8(value >> 8));
    BusWrite(address: address, value: UInt8(value & 0xFF));
}

struct RAMState {
    var workingRAM: [UInt8] = Array<UInt8>(repeating: 0 , count: 0x2000);
    var highRAM: [UInt8] = Array<UInt8>(repeating: 0 , count: 0x80);
}

var RAMStateInstance = RAMState();


