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
       // implement
    }
    else if address < 0xC000 {
        return CartridgeRead(address: address);
    }
    else if address < 0xE000 {
        return WorkingRAMRead(address: address)
    }
    else if address < 0xFE00 {
        //implement
    }
    else if address < 0xFEA0 {
       // ppu
    }
    else if address < 0xFF00 {
        //unusable
    }
    else if address < 0xFF80 {
        //unusable
    }
    else if address == 0xFFFF {
        return GetInterruptEnableRegister();
    }
    return HighRAMRead(address: address);
}

func BusWrite(address: UInt16, value: UInt8) {
    if (address < 0x8000) {
        CartridgeWrite(address: address, value: value);
    }
    else if address < 0xA000 {
        //implement
    }
    else if address < 0xC000 {
        CartridgeWrite(address: address, value: value);
    }
    else if address < 0xE000 {
        WorkingRAMWrite(address: address, value: value);
    }
    else if address < 0xFE00 {
        //implement
    }
    else if address < 0xFEA0 {
        ////ppu
    }
    else if address < 0xFF00 {
        //unusable
    }
    else if address < 0xFF80 {
        //unusable
    }
    else if address == 0xFFFF {
        SetInterruptEnableRegister(value: value);
    }
    else{
        return HighRAMWrite(address: address, value: value);
    }
}

func BusRead16Bit(address: UInt16) -> UInt16 {
    let lowByte: UInt16 = UInt16(BusRead(address: address));
    let highByte: UInt16 = UInt16(BusRead(address: address+1));
    return lowByte | (highByte << 8);
}

func BusWrite16Bit(address: UInt16, value: UInt16) {
    BusWrite(address: address, value: UInt8(value & 0xFF));
    BusWrite(address: address + 1, value: UInt8(value >> 8));
}
