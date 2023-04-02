//
//  TestRoms.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 4/2/23.
//

import Foundation

var TestRomMessage: [UInt8] = [UInt8](repeating: 0, count: 1024);
var MessageSize: Int = 0;
func TestRomWrite() -> Void {
    if BusRead(address: 0xFF02) == 0x81 {
        TestRomMessage[MessageSize] = BusRead(address: 0xFF01);
        MessageSize += 1;
        BusWrite(address: 0xFF02, value: 0);
    }
}

func TestRomRead() -> Void {
    if TestRomMessage[0] != 0 {
        let messageString = String(TestRomMessage.map { Character(UnicodeScalar($0)) });
        print(messageString);
    }
}
