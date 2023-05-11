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
    switch address {
        case 0x0000..<0x8000:
            return CartridgeRead(address: address);
        case 0x8000..<0xA000:
                return PPUStateInstance.vram[Int(address) - 0x8000];
        case 0xA000..<0xC000:
            return CartridgeRead(address: address)
        case 0xC000..<0xE000:
            let workingRAMAddress = address &- 0xC000;
                if workingRAMAddress >= 0x2000 {
                    print("invalid wram read");
                    exit(-5);
                }
            return RAMStateInstance.workingRAM[Int(workingRAMAddress)];
        case 0xE000..<0xFE00:
            //implement
            break;
        case 0xFE00..<0xFEA0:
            // ppu
            if DMATransferring() {
                return 0xFF;
            }
            return PPUOAMread(address: address);
        case 0xFEA0..<0xFF00:
            //unusable
            break
        case 0xFF00..<0xFF80:
            if address == 0xFF00 {
                //print("reading from joypad", JoypadInstance.JoypadRead())
                return JoypadInstance.JoypadRead();
            }
            if address == 0xFF01 {
                return SerialData[0];
            }
            if address == 0xFF02 {
                return SerialData[1];
            }
            if address >= 0xFF04 && address <= 0xFF07 {
                return TimerRead(address: address);
            }
            if address == 0xFF0F {
                return GetInterruptFlags();
            }
            if address >= 0xFF40 && address <= 0xFF4B {
                return LCDRead(address: address);
            }
            print("Invalid IO Read")
            return 0;
        case 0xFF80:
            return RAMStateInstance.highRAM[0];
        case 0xFF81..<0xFFFF:
            return RAMStateInstance.highRAM[Int(address &- 0xFF80)];
        case 0xFFFF:
            return GetInterruptEnableRegister()
        default:
            fatalError("Invalid address \(address)");
    }
    return 0;
}


func BusWrite(address: UInt16, value: UInt8) {
    switch address {
    case 0x0000..<0x8000:
        CartridgeWrite(address: address, value: value);
    case 0x8000..<0xA000:
        PPUStateInstance.vram[Int(address &- 0x8000)] = value;
    case 0xA000..<0xC000:
        CartridgeWrite(address: address, value: value);
    case 0xC000..<0xE000:
        RAMStateInstance.workingRAM[Int(address &- 0xC000)] = value;
    case 0xE000..<0xFE00:
        // implement
        break;
    case 0xFE00..<0xFEA0:
        // ppu
        if DMATransferring() {
            return;
        }
        PPUOAMWrite(address: address, value: value);
    case 0xFEA0..<0xFF00:
        // unusable
        break;
    case 0xFF00..<0xFF80:
        if address == 0xFF00 {
            //print("writing to joypad", value)
            JoypadInstance.JoypadWrite(value: value);
        }
        if address == 0xFF01 {
            SerialData[0] = value;
        }
         if address == 0xFF02 {
            SerialData[1] = value;
        }
         if address >= 0xFF04 && address <= 0xFF07 {
            TimerWrite(address: address, value: value);
        }
        if address == 0xFF0F {
            SetInterruptFlags(value: value);
        }
        if address >= 0xFF40 && address <= 0xFF4B {
            LCDWrite(address: address, value: value);
        }
    case 0xFF80:
        RAMStateInstance.highRAM[0] = value;
    case 0xFF81..<0xFFFF:
        RAMStateInstance.highRAM[Int(address &- 0xFF80)] = value;
    case 0xFFFF:
        SetInterruptEnableRegister(value: value);
    default:
        break;
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


