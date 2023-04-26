//
//  DirectMemoryAccess.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 4/23/23.
//

import Foundation

struct DMAState {
    var active: Bool;
    var byte: UInt8;
    var value: UInt8;
    var startDelay: UInt8;
    init() {
        active = true;
        byte = 0;
        value = 2;
        startDelay = 0;
    }
}
func InitializeDMAState(start: UInt8) {
    DMAStateInstance.startDelay = start;
}
var DMAStateInstance = DMAState();

func DMATick() -> Void {
    if !DMAStateInstance.active {
        return;
    }
    if DMAStateInstance.startDelay != 0 {
        DMAStateInstance.startDelay -= 1;
        return;
    }
    PPUOAMWrite(address: UInt16(DMAStateInstance.byte), value: BusRead(address: UInt16( ( UInt16(DMAStateInstance.value) * 0x100) + UInt16(DMAStateInstance.byte))) );
    DMAStateInstance.byte += 1;
    DMAStateInstance.active = DMAStateInstance.byte < 0xA0;
}

func DMATransferring() -> Bool {
    return DMAStateInstance.active;
}
