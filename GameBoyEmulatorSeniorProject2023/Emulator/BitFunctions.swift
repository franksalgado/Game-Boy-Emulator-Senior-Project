//
//  BitFunctions.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 5/9/23.
//

import Foundation

func isBitSet(bitPosition: UInt8, in value: UInt8) -> Bool {
    let mask: UInt8 = 1 << bitPosition
    return (value & mask) != 0
}

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
