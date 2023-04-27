//
//  PictureProcessingUnit.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 4/5/23.
//
//PPU has 3 layers. Objects, Window, and Background.
/*red
 #8BAC0F (dark green)
 #9BBC0F (medium green)
 #306230 (light green)
 #0F380F (very light green)
 */
import Foundation
import SpriteKit
enum SelectPixelColors {
    case shadesOfGreen
    case shadesOfBlue
    case shadesOfBlackAndWhite
    
    var colors: [SKColor] {
        switch self {
        case .shadesOfGreen:
            return [
                SKColor(red: 0.757, green: 0.875, blue: 0.757, alpha: 1.0),
                SKColor(red: 0.561, green: 0.765, blue: 0.561, alpha: 1.0),
                SKColor(red: 0.278, green: 0.659, blue: 0.278, alpha: 1.0),
                SKColor(red: 0.149, green: 0.357, blue: 0.149, alpha: 1.0)
            ]
            
        case .shadesOfBlue:
            return [
                SKColor(red: 0.749, green: 0.839, blue: 0.914, alpha: 1.0),
                SKColor(red: 0.525, green: 0.631, blue: 0.718, alpha: 1.0),
                SKColor(red: 0.349, green: 0.439, blue: 0.533, alpha: 1.0),
                SKColor(red: 0.196, green: 0.267, blue: 0.353, alpha: 1.0)
            ]
            
        case .shadesOfBlackAndWhite:
            return [
                SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                SKColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1.0),
                SKColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0),
                SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            ]
        }
    }
}
let GreenColors = SelectPixelColors.shadesOfBlue.colors;
let BlueColors = SelectPixelColors.shadesOfBlue.colors;
let BlackAndWhiteColors = SelectPixelColors.shadesOfBlackAndWhite.colors;
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


//Used in GameScene class to get the bytes to render all 8 pixels for a tile.
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


struct OAMSpriteAttributes {
    var y: UInt8;
    var x: UInt8;
    var tileIndex: UInt8;
    var attributesAndFlags: UInt8;
}

struct PPUState {
    var OAMSprite: [OAMSpriteAttributes] = Array<OAMSpriteAttributes>(repeating: OAMSpriteAttributes(y: 0, x: 0, tileIndex: 0, attributesAndFlags: 0), count: 40);
    var vram: [UInt8] = Array<UInt8>(repeating: 0, count: 0x2000);
    var currentFrame: UInt32 = 0;
    var lineTicks: UInt32 = 0;
}
var PPUStateInstance = PPUState();

func PPUOAMWrite(address: UInt16, value: UInt8) -> Void {
    var sprite = address;
    if address >= 0xFE00 {
        sprite -= 0xFE00;
    }
    sprite /= 4;
    switch address & 0b11 {
    case 0:
        PPUStateInstance.OAMSprite[Int(sprite)].y = value;
    case 1:
        PPUStateInstance.OAMSprite[Int(sprite)].x = value;
    case 2:
        PPUStateInstance.OAMSprite[Int(sprite)].tileIndex = value;
    case 3:
        PPUStateInstance.OAMSprite[Int(sprite)].attributesAndFlags = value;
    default:
        print("Invalid PPUOAM write");
        exit(-5);
    }
}

func PPUOAMread(address: UInt16) -> UInt8 {
    var sprite = address;
    if address >= 0xFE00 {
        sprite -= 0xFE00;
    }
    sprite /= 4;
    switch address & 0b11 {
    case 0:
        return PPUStateInstance.OAMSprite[Int(sprite)].y;
    case 1:
        return PPUStateInstance.OAMSprite[Int(sprite)].x;
    case 2:
        return PPUStateInstance.OAMSprite[Int(sprite)].tileIndex;
    case 3:
        return PPUStateInstance.OAMSprite[Int(sprite)].attributesAndFlags;
    default:
        print("Invalid PPUOAM read");
        exit(-5);
    }
}
func PPUTick() -> Void {
    PPUStateInstance.lineTicks += 1;
    switch LCDStateInstance.LCDStatus & 0b11 {
    case 0:
        if PPUStateInstance.lineTicks >= 80 {
            LCDStateInstance.SetLCDStatusMode(LCDMode: .XFER);
        }
        break;
    case 1:
        if PPUStateInstance.lineTicks >= 80 + 172{
            LCDStateInstance.SetLCDStatusMode(LCDMode: .HBLANK);
        }
        break;
    case 2:
        if PPUStateInstance.lineTicks >= 456{
            LCDStateInstance.LY += 1;
            if LCDStateInstance.LY == LCDStateInstance.LYCompare {
                LCDStateInstance.LCDStatus |= (1 << 2);
            } else {
                LCDStateInstance.LCDStatus &= ~(1 << 2);
            }
            if LCDStateInstance.LY >= 154 {
                LCDStateInstance.SetLCDStatusMode(LCDMode: .OAM);
                LCDStateInstance.LY = 0;
            }
            PPUStateInstance.lineTicks = 0;
        }
        break;
    case 3:
        if PPUStateInstance.lineTicks >= 456 {
            LCDStateInstance.LY += 1;
            if LCDStateInstance.LY == LCDStateInstance.LYCompare {
                LCDStateInstance.LCDStatus |= (1 << 2);
            } else {
                LCDStateInstance.LCDStatus &= ~(1 << 2);
            }
            if LCDStateInstance.LY >= 144 {
                LCDStateInstance.SetLCDStatusMode(LCDMode: .VBLANK);
                RequestInterrupt(InterruptTypes: .VBLANK);
                if (LCDStateInstance.LCDStatus & StatSRC.VBLANK.rawValue) != 0 {
                    RequestInterrupt(InterruptTypes: .LCDSTAT)
                }
                PPUStateInstance.currentFrame += 1;
            }
        } else {
            LCDStateInstance.SetLCDStatusMode(LCDMode: .OAM);
        }
        PPUStateInstance.lineTicks = 0;
        break;
    default:
        print("Inval pputick")
    }
}

//PPU states func
