//
//  LiquidCrystalDisplay.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 4/23/23.
//

import Foundation
import SpriteKit

enum LCDMode: UInt8 {
    case HBLANK,
    VBLANK,
    OAM,
    XFER
}

enum StatSRC: UInt8 {
    case HBlANK = 0b00001000,
    VBLANK = 0b00010000,
    OAM = 0b00100000,
    LYC = 0b01000000
}

struct LCDState {
    //0xFF40
    /*
     7    LCD and PPU enable    0=Off, 1=On
     6    Window tile map area    0=9800-9BFF, 1=9C00-9FFF
     5    Window enable    0=Off, 1=On
     4    BG and Window tile data area    0=8800-97FF, 1=8000-8FFF
     3    BG tile map area    0=9800-9BFF, 1=9C00-9FFF
     2    OBJ size    0=8x8, 1=8x16
     1    OBJ enable    0=Off, 1=On
     0    BG and Window enable/priority    0=Off, 1=On
     */
    var LCDControl: UInt8;
    //0xFF41
    var LCDStatus: UInt8;
    var yScroll: UInt8;
    var xScroll: UInt8;
    //0xFF44 LCD Y coordinate
    var LY: UInt8;
    //0xFF45
    var LYCompare: UInt8;
    
    var DMA: UInt8;
    //0xFF47
    /*
     Bit 7-6 - Color for index 3 darkest
     Bit 5-4 - Color for index 2
     Bit 3-2 - Color for index 1
     Bit 1-0 - Color for index 0 light
     */
    var backGroundPaletteData: UInt8;
    var objectPalette: [UInt8];
    var windowY: UInt8;
    var windowX: UInt8;
    
    var backGroundColors: [SKColor];
    var Sprite1Colors: [SKColor];
    var Sprite2Colors: [SKColor];
    func SetLCDStatusMode(LCDmode: UInt8) -> Void{
        LCDStateInstance.LCDStatus = ( LCDStateInstance.LCDStatus & ~0b11) | LCDmode;
    }
    init() {
        LCDControl = 0x91;
        //LCD Status starts out with every bit set except the first
        LCDStatus = ~0b1;
        yScroll = 0;
        xScroll = 0;
        LY = 0;
        //0xFF45
        LYCompare = 0;
        DMA = 0xFF;
        backGroundPaletteData = 0xFC;
        objectPalette = Array<UInt8>(repeating: 0xFF, count: 2);
        windowX = 0;
        windowY = 0;
        backGroundColors = GreenColors;
        Sprite1Colors = GreenColors;
        Sprite1Colors[0] = Sprite1Colors[0].withAlphaComponent(0);
        Sprite2Colors = GreenColors;
        Sprite2Colors[0] = Sprite1Colors[0].withAlphaComponent(0);
    }
}
var LCDStateInstance = LCDState();


//todo BG Palette data update func

func LCDRead(address: UInt16) -> UInt8{
    switch address - 0xFF40 {
    case 0:
        return LCDStateInstance.LCDControl;
    case 1:
        return LCDStateInstance.LCDStatus;
    case 2:
           return LCDStateInstance.yScroll;
    case 3:
        return LCDStateInstance.xScroll;
    case 4:
        return LCDStateInstance.LY;
    case 5:
        return LCDStateInstance.LYCompare;
    case 6:
        return LCDStateInstance.DMA;
    case 7:
        return LCDStateInstance.backGroundPaletteData;
    case 8:
        return LCDStateInstance.objectPalette[0];
    case 9:
        return LCDStateInstance.objectPalette[1];
    case 10:
        return LCDStateInstance.windowY;
    case 11:
        return LCDStateInstance.windowX;
    default:
        print("invalid lcd reead");
        exit(-5);
    }
}

func LCDWrite(address: UInt16, value: UInt8) -> Void{
    switch address - 0xFF40   {
    case 0:
        LCDStateInstance.LCDControl = value;
    case 1:
        LCDStateInstance.LCDStatus = value;
    case 2:
           LCDStateInstance.yScroll = value;
    case 3:
        LCDStateInstance.xScroll = value;
    case 4:
        LCDStateInstance.LY = value;
    case 5:
        LCDStateInstance.LYCompare = value;
    case 6:
        LCDStateInstance.DMA = value;
        InitializeDMAState(start: value);
    case 7:
        LCDStateInstance.backGroundPaletteData = value;
        var i: UInt8 = 0
        while i < 4 {
            //print("za")
            //print(GreenColors[Int( (value >> (i * 2) ) & 0b11) ])
            LCDStateInstance.backGroundColors[Int(i)] = GreenColors[Int( (value >> (i * 2) ) & 0b11) ];
            i += 1;
        }
       // print("😹")
    case 8:
        LCDStateInstance.objectPalette[0] = value;
        let temp = LCDStateInstance.Sprite1Colors;
        var i: UInt8 = 0
        while i < 4 {
            LCDStateInstance.Sprite1Colors[Int(i)] = temp[Int( (value >> (i * 2) ) & 0b11) ];
            i += 1;
        }
    case 9:
        LCDStateInstance.objectPalette[1] = value;
        let temp = LCDStateInstance.Sprite2Colors;
        var i: UInt8 = 0
        while i < 4 {
            LCDStateInstance.Sprite2Colors[Int(i)] = temp[Int( (value >> (i * 2) ) & 0b11) ];
            i += 1;
        }
    case 10:
        LCDStateInstance.windowY = value;
    case 11:
        LCDStateInstance.windowX = value;
    //update pallete value
    default:
        print("invalid lcd write");
        exit(-5);
    }
}

