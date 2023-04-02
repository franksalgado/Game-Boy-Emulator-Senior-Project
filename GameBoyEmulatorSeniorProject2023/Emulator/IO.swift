//
//  IO.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 4/1/23.
//

import Foundation
var SerialData: [UInt8] = [UInt8](repeating: 0, count: 2);
func IORead(address: UInt16) -> UInt8 {
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
    return 0;
}

func IOWrite(address: UInt16, value: UInt8) {
    if address == 0xFF01 {
        SerialData[0] = value;
    }
    else if address == 0xFF02 {
        SerialData[1] = value;
    }
    else if address >= 0xFF04 && address <= 0xFF07 {
        TimerWrite(address: address, value: value);
    }
    else if address == 0xFF0F {
        SetInterruptFlags(value: value);
    }
}

