//
//  Ram.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 3/23/23.
//

import Foundation

struct RAMState {
    var workingRAM: [UInt8] = Array<UInt8>(repeating: 0 , count: 0x2000);
    var highRAM: [UInt8] = Array<UInt8>(repeating: 0 , count: 0x80);
}

var RAMStateInstance = RAMState();

func WorkingRAMRead(address: UInt16) -> UInt8 {
    let workingRAMAddress = address &- 0xC000;
    if workingRAMAddress >= 0x2000 {
        print("invalid");
    }
    return RAMStateInstance.workingRAM[Int(workingRAMAddress)];
}

func WorkingRAMWrite(address: UInt16, value: UInt8) -> Void {
    let workingRAMAddress = address &- 0xC000;
    RAMStateInstance.workingRAM[Int(workingRAMAddress)] = value;
}

func HighRAMRead(address: UInt16) -> UInt8 {
    let highRAMAddress = address &- 0xFF80;
    return RAMStateInstance.highRAM[Int(highRAMAddress)];
}

func HighRAMWrite(address: UInt16, value: UInt8) -> Void {
    let highRAMAddress = address &- 0xFF80;
    RAMStateInstance.highRAM[Int(highRAMAddress)] = value;
}

