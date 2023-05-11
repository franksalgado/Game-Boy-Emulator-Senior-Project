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
            ];
            
        case .shadesOfBlue:
            return [
                SKColor(red: 0.749, green: 0.839, blue: 0.914, alpha: 1.0),
                SKColor(red: 0.525, green: 0.631, blue: 0.718, alpha: 1.0),
                SKColor(red: 0.349, green: 0.439, blue: 0.533, alpha: 1.0),
                SKColor(red: 0.196, green: 0.267, blue: 0.353, alpha: 1.0)
            ];
            
        case .shadesOfBlackAndWhite:
            return [
                SKColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                SKColor(red: 0.667, green: 0.667, blue: 0.667, alpha: 1.0),
                SKColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1.0),
                SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            ];
        }
    }
}

let GreenColors = SelectPixelColors.shadesOfGreen.colors;
let BlueColors = SelectPixelColors.shadesOfBlue.colors;
let BlackAndWhiteColors = SelectPixelColors.shadesOfBlackAndWhite.colors;

struct OAMSpriteAttributes {
    var y: UInt8;
    var x: UInt8;
    var tileIndex: UInt8;
    var attributesAndFlags: UInt8;
}
//Make OAM QUEUE 

struct PPUState {
    var OAMSprite: [OAMSpriteAttributes] = Array<OAMSpriteAttributes>(repeating: OAMSpriteAttributes(y: 0, x: 0, tileIndex: 0, attributesAndFlags: 0), count: 40);
    var vram: [UInt8] = Array<UInt8>(repeating: 0, count: 0x2000);
    var currentFrame: UInt32 = 0;
    var lineTicks: UInt32 = 0;
    var FIFOInstance: FIFO = FIFO();
    var videoBuffer: [SKColor] = Array(repeating: GreenColors[0], count: 160 * 144);
    var OAMFIFOInstance: OAMFIFO = OAMFIFO();
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


func LoadLineSprites() {
    var OBJSize: UInt8 {
        if isBitSet(bitPosition: 2, in: LCDStateInstance.LCDControl) {
            return 1;
        }
        return 0;
    }
    for entry in PPUStateInstance.OAMSprite {
        if PPUStateInstance.OAMFIFOInstance.lineSpriteCount >= 10 {
            break;
        }
        if entry.y <= LCDStateInstance.LY + 16 && entry.y + OBJSize > LCDStateInstance.LY + 16 {
            
        }
    }
}

func OAM() -> Void {
    //print("Inoam")
    if PPUStateInstance.lineTicks >= 80 {
        LCDStateInstance.SetLCDStatusMode(LCDmode: LCDMode.XFER.rawValue);
        PPUStateInstance.FIFOInstance.currentFIFOStep = .GetTile;
        PPUStateInstance.FIFOInstance.lineX = 0;
        PPUStateInstance.FIFOInstance.fetchX = 0;
        PPUStateInstance.FIFOInstance.pushedX = 0;
        PPUStateInstance.FIFOInstance.FIFOX = 0;
        PPUStateInstance.OAMFIFOInstance.fetchedEnteryCount = 0;
        PPUStateInstance.OAMFIFOInstance.OAMFIFOReset();
    }
    if PPUStateInstance.lineTicks == 1 {
        PPUStateInstance.OAMFIFOInstance.OAMFIFOReset();
        PPUStateInstance.OAMFIFOInstance.lineSpriteCount = 0;
        LoadLineSprites();
    }
}
func XFER() -> Void {
    //print("Inxfer")
    PipelinePrcess();
    //print("exited pipelien process")
    //print(PPUStateInstance.FIFOInstance.pushedX)
    //print(PPUStateInstance.FIFOInstance.totalElements, "total elements in queuue")
    //print(LCDStateInstance.xScroll)
    //print(PPUStateInstance.FIFOInstance.lineX, "Linex")
    if PPUStateInstance.FIFOInstance.pushedX >= 160 {
        //print("za")
        PipelineFIFOReset();
        LCDStateInstance.SetLCDStatusMode(LCDmode: LCDMode.HBLANK.rawValue);
        if LCDStateInstance.LCDStatus & StatSRC.HBlANK.rawValue != 0 {
            RequestInterrupt(InterruptTypes: .LCDSTAT);
        }
    }
}

func VBLANLK() {
    //print("vblank")
    if PPUStateInstance.lineTicks >= 456{
       // print("vblankif")
        IncLY();
        if LCDStateInstance.LY >= 154 {
            LCDStateInstance.SetLCDStatusMode(LCDmode: LCDMode.OAM.rawValue);
            LCDStateInstance.LY = 0;
        }
        PPUStateInstance.lineTicks = 0;
    }
}
func HBLANK() {
    if PPUStateInstance.lineTicks >= 456 {
        IncLY();
        if LCDStateInstance.LY >= 144 {
            LCDStateInstance.SetLCDStatusMode(LCDmode: LCDMode.VBLANK.rawValue);
            RequestInterrupt(InterruptTypes: .VBLANK);
            if (LCDStateInstance.LCDStatus & StatSRC.VBLANK.rawValue) != 0 {
                RequestInterrupt(InterruptTypes: .LCDSTAT);
            }
        } else {
            LCDStateInstance.SetLCDStatusMode(LCDmode: LCDMode.OAM.rawValue);
    }
    PPUStateInstance.lineTicks = 0;
    }
}
func PPUTick() -> Void {
    PPUStateInstance.lineTicks += 1;
    switch LCDStateInstance.LCDStatus & 0b11 {
    //case 0:
    case LCDMode.OAM.rawValue:
       // print("o")
        OAM();
        break;
    //case 1:
    case LCDMode.XFER.rawValue:
       // print("x")
        XFER();
        
        break;
   // case 2:
    case LCDMode.VBLANK.rawValue:
        //print("v")
        VBLANLK()
        break;
    //case 3:
    case LCDMode.HBLANK.rawValue:
      //  print("H")
        HBLANK();
        break;
    default:
        //print("Inval pputick")
        exit(-5);
    }
}

func IncLY() {
    //print("IncLY execut")
    LCDStateInstance.LY += 1;
    if LCDStateInstance.LY == LCDStateInstance.LYCompare {
        LCDStateInstance.LCDStatus |= (1 << 2);
        if LCDStateInstance.LCDStatus & StatSRC.LYC.rawValue != 0 {
            RequestInterrupt(InterruptTypes: .LCDSTAT);
        }
    } else {
        LCDStateInstance.LCDStatus &= ~(1 << 2);
    }
}

//PPU states func
