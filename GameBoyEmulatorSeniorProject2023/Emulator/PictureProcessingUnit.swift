//
//  PictureProcessingUnit.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 4/5/23.
//
//PPU has 3 layers. Objects, Window, and Bakcground.
/*red
 #8BAC0F (dark green)
 #9BBC0F (medium green)
 #306230 (light green)
 #0F380F (very light green)
 */
import Foundation
var darkest: UInt32 = 0x8BAC0F;
var darker: UInt32 = 0x9BBC0F;
var dark: UInt32 = 0x306230;
var light: UInt32 = 0x0F380F;

enum PixelColors {
    case blackAndWhite
    case shadesOfGreen(darkest: UInt32, darker: UInt32, dark: UInt32, light: UInt32)
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


struct OAMSpriteAttribute {
    var y: UInt8;
    var x: UInt8;
    var tileIndex: UInt8;
    var AttributesAndFlags: UInt8
}
let binaryNumbers: [UInt8] = [0b10000000, 0b01000000, 0b00100000, 0b00010000, 0b00001000, 0b00000100, 0b00000010, 0b00000001];
func GetTileLineBytes(firstByte: UInt8, secondByte: UInt8) -> [UInt8] {
    var i = 0;
    var number: UInt8 = 0;
    var array: [UInt8] = Array<UInt8>(repeating: 0 , count: 8);
    while i < 8 {
        number = 0;
        if firstByte & binaryNumbers[i] != 0 {
            number |= (1 <<  1);
        }
        if secondByte & binaryNumbers[i] != 0 {
            number |= 1;
        }
        array[i] = number
        i += 1;
    }
    return array;
}
