//
//  PictureProcessingUnit.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 4/5/23.
//
//PPU has 3 layers. Objects, Window, and Bakcground.
import Foundation

struct BitField {
    var bit0: Bool = false
    var bit1: Bool = false
    var bit2: Bool = false
    var bit3: Bool = false
    
    var rawValue: UInt8 {
        var value: UInt8 = 0
        if bit0 { value |= 0b0000_0001 }
        if bit1 { value |= 0b0000_0010 }
        if bit2 { value |= 0b0000_0100 }
        if bit3 { value |= 0b0000_1000 }
        return value
    }
    
    init(rawValue: UInt8) {
        self.bit0 = (rawValue & 0b0000_0001) != 0
        self.bit1 = (rawValue & 0b0000_0010) != 0
        self.bit2 = (rawValue & 0b0000_0100) != 0
        self.bit3 = (rawValue & 0b0000_1000) != 0
    }
}


struct OAMSpriteAttribute {
    var y: UInt8;
    var x: UInt8;
    var tileIndex: UInt8;
    var AttributesAndFlags: UInt8
}

func generateTileLine(firstByte: UInt8, secondByte: UInt8) -> UInt16 {
    let binaryNumbers: [UInt8] = [0b10000000, 0b01000000, 0b00100000, 0b00010000, 0b00001000, 0b00000100, 0b00000010, 0b00000001];
    var i = 0;
    var first: UInt16 = 0;
    var second: UInt16 = 0;
    while i < 8 {
        if firstByte & binaryNumbers[i] != 0 {
            first |= (1 <<  (i * 2) + 1 );
        }
        if secondByte & binaryNumbers[i] != 0 {
            second |= (1 << (i * 2) );
        }
        i += 1;
        return first | second;
    }
}
