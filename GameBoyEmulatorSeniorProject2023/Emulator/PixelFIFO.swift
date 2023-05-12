//
//  PixelFIFO.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 4/27/23.
//

import Foundation
import SpriteKit

enum FIFOStep {
case GetTile,
    GetTileDataLow,
    GetTileDataHigh,
    Sleep,
    Push
}
class FIFO {
    private var pixels: [SKColor] = [];
    
    func enqueue(pixel: SKColor) {
        pixels.append(pixel);
    }
    func dequeue() -> SKColor {
        guard !pixels.isEmpty
        else {
            fatalError("empty queue");
        }
        return pixels.removeFirst();
    }
    var head : SKColor {
        guard let head = pixels.first
        else {
            fatalError("empty queue");
        }
        return head;
    }
    var tail : SKColor {
        guard let head = pixels.last
        else {
            fatalError("empty queue");
        }
        return head;
    }
    var totalElements: Int {
            return pixels.count
        }
    
    var currentFIFOStep: FIFOStep = .GetTile;
    var lineX: UInt8 = 0;
    var pushedX: UInt8 = 0;
    var fetchX: UInt8 = 0;
    var BackgroundWindowFetchData: [UInt8] = Array<UInt8>(repeating: 0, count: 3);
    var fetchEntryData: [UInt8] = Array<UInt8>(repeating: 0, count: 6);
    var mapY: UInt8 = 0;
    var mapX: UInt8 = 0;
    var tileY: UInt8 = 0;
    var FIFOX: UInt8 = 0;
}
struct OAMFIFO {
    private var sprites: [OAMSpriteAttributes] = [];
    
    mutating func enqueue(pixel: OAMSpriteAttributes) {
        sprites.append(pixel);
    }
    mutating func dequeue() -> OAMSpriteAttributes {
        guard !sprites.isEmpty
        else {
            fatalError("empty queue");
        }
        return sprites.removeFirst();
    }
    var head : OAMSpriteAttributes {
        guard let head = sprites.first
        else {
            fatalError("empty queue");
        }
        return head;
    }
    var tail : OAMSpriteAttributes {
        guard let head = sprites.last
        else {
            fatalError("empty queue");
        }
        return head;
    }
    var totalElements: Int {
            return sprites.count
        }
    mutating func OAMFIFOReset() {
        while self.totalElements > 0 {
            _ = self.dequeue();
        }
    }
    let maxSpritesPerScanline = 10;
    var lineSpriteCount: UInt8 = 0;
    var fetchedEnteryCount: UInt8 = 0;
    var fetchedEnteries: [OAMSpriteAttributes] = [];
    let fetchedEnteriesLimit = 3;
}

func FetchSpritePixels(backGroundColor: UInt8, color: SKColor) -> SKColor {
    var newColor = color;
    for entry in 0..<PPUStateInstance.OAMFIFOInstance.fetchedEnteryCount {
        let spriteX = (PPUStateInstance.OAMFIFOInstance.fetchedEnteries[Int(entry)].x - 8) + LCDStateInstance.xScroll % 8;
        if spriteX + 8 < PPUStateInstance.FIFOInstance.FIFOX {
            continue;
        }
        let offset = PPUStateInstance.FIFOInstance.FIFOX - spriteX;
        if offset < 0 || offset > 7 {
            continue;
        }
        var bit = 7 - offset;
        if isBitSet(bitPosition: 5, in: PPUStateInstance.OAMFIFOInstance.fetchedEnteries[Int(entry)].attributesAndFlags) {
            bit = offset;
        }
        var number: UInt8 = 0;
        if PPUStateInstance.FIFOInstance.fetchEntryData[Int(entry) * 2] & (1 << bit) != 0 {
            number |= 1;
        }
        if PPUStateInstance.FIFOInstance.fetchEntryData[(Int(entry) * 2) + 1] & (1 << bit) != 0 {
            number |= (1 << 1);
        }
        if number == 0 {
            continue;
        }
        if !isBitSet(bitPosition: 7, in: PPUStateInstance.OAMFIFOInstance.fetchedEnteries[Int(entry)].attributesAndFlags) || backGroundColor == 0 {
                if isBitSet(bitPosition: 4, in: PPUStateInstance.OAMFIFOInstance.fetchedEnteries[Int(entry)].attributesAndFlags) {
                    newColor =  LCDStateInstance.Sprite2Colors[Int(number)];
                } else {
                    newColor =  LCDStateInstance.Sprite1Colors[Int(number)];
                }
            if number != 0 {
                break;
            }
        }
    }
    return newColor;
}

let binaryNumbers: [UInt8] = [0b10000000, 0b01000000, 0b00100000, 0b00010000, 0b00001000, 0b00000100, 0b00000010, 0b00000001];
func PipelineFIFOAdd() -> Bool {
    if PPUStateInstance.FIFOInstance.totalElements > 8 {
        return false;
    }
    let x = PPUStateInstance.FIFOInstance.fetchX - (8 - (LCDStateInstance.xScroll % 8));
    var i = 0;
    var number: UInt8 = 0;
    while i < 8 {
        number = 0;
        if PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[2] & binaryNumbers[i] != 0 {
            number |= (1 <<  1);
        }
        if PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[1] & binaryNumbers[i] != 0 {
            number |= 1;
        }
        var pixel = LCDStateInstance.backGroundColors[Int(number)];
        if !isBitSet(bitPosition: 0, in: LCDStateInstance.LCDControl) {
            pixel = LCDStateInstance.backGroundColors[0];
        }
        if isBitSet(bitPosition: 1, in: LCDStateInstance.LCDControl) {
            pixel = FetchSpritePixels(backGroundColor: number, color: pixel);
        }
        if x >= 0 {
            PPUStateInstance.FIFOInstance.enqueue(pixel: pixel);
            PPUStateInstance.FIFOInstance.FIFOX += 1;
        }
        i += 1;
    }
    return true;
}

func PipelineLoadSpriteTile() {
    while PPUStateInstance.OAMFIFOInstance.totalElements != 0 {
        let spriteX = (PPUStateInstance.OAMFIFOInstance.head.x - 8) + (LCDStateInstance.xScroll % 8);
        if (spriteX >= PPUStateInstance.FIFOInstance.fetchX && spriteX < PPUStateInstance.FIFOInstance.fetchX + 8) || (
            (spriteX + 8) >= PPUStateInstance.FIFOInstance.fetchX && spriteX + 8 <  PPUStateInstance.FIFOInstance.fetchX + 8) {
            PPUStateInstance.OAMFIFOInstance.fetchedEnteries[Int(PPUStateInstance.OAMFIFOInstance.fetchedEnteryCount)] = PPUStateInstance.OAMFIFOInstance.dequeue();
                PPUStateInstance.OAMFIFOInstance.fetchedEnteryCount += 1;
        }
        if PPUStateInstance.OAMFIFOInstance.fetchedEnteryCount >= 3 { break;}
    }
}

func GetTile() {
    //Determine starting area to get tiles from
    if isBitSet(bitPosition: 0, in: LCDStateInstance.LCDControl) {
        //print("GTif")
        var address: UInt16 {
            if isBitSet(bitPosition: 3, in: LCDStateInstance.LCDControl) {
                return UInt16( 0x9C00 + Int(PPUStateInstance.FIFOInstance.mapX / 8) + Int(Int(PPUStateInstance.FIFOInstance.mapY / 8) * 32) );
            }
            return UInt16( 0x9800 + Int(PPUStateInstance.FIFOInstance.mapX / 8) + Int(Int(PPUStateInstance.FIFOInstance.mapY / 8) * 32) );
        }
        PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0] = BusRead(address: address);
        if !isBitSet(bitPosition: 4, in: LCDStateInstance.LCDControl) {
            PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0] &+= 128;
        }
    }
    if isBitSet(bitPosition: 1, in: LCDStateInstance.LCDControl) && PPUStateInstance.OAMFIFOInstance.totalElements != 0 {
        PipelineLoadSpriteTile();
    }
    PPUStateInstance.FIFOInstance.fetchX += 8;
    PPUStateInstance.FIFOInstance.currentFIFOStep = .GetTileDataLow;
}

func GetTileDataLow() {
    var address: UInt16 {
        if isBitSet(bitPosition: 4, in: LCDStateInstance.LCDControl) {
            return UInt16(0x8000 + Int(PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0]) * 16 + Int(PPUStateInstance.FIFOInstance.tileY) );
        }
        return UInt16( 0x8800 + Int(PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0]) * 16 + Int(PPUStateInstance.FIFOInstance.tileY) );
    }
    PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[1] = BusRead(address: address);
    PipelineLoadSpriteData(offset: 0);
    PPUStateInstance.FIFOInstance.currentFIFOStep = .GetTileDataHigh;
}
func GetTileDataHigh() {
    var address: UInt16 {
        if isBitSet(bitPosition: 4, in: LCDStateInstance.LCDControl) {
            return UInt16(0x8000 + Int(PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0] ) * 16 + Int(PPUStateInstance.FIFOInstance.tileY + 1) );
        }
        return UInt16(0x8800 + Int(PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0] ) * 16 + Int(PPUStateInstance.FIFOInstance.tileY + 1) );
    }
    PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[2] = BusRead(address: address);
    PipelineLoadSpriteData(offset: 1);
    PPUStateInstance.FIFOInstance.currentFIFOStep = .Sleep;
}

func PipelineLoadSpriteData(offset: Int) {
    var spriteHeight: UInt8 {
        if isBitSet(bitPosition: 2, in: LCDStateInstance.LCDControl) {
            return 16;
        }
        return 8;
    }
    for entry in 0..<PPUStateInstance.OAMFIFOInstance.fetchedEnteryCount {
        var tileY = ((LCDStateInstance.LY + 16) - PPUStateInstance.OAMFIFOInstance.fetchedEnteries[Int(entry)].y) * 2;
        if isBitSet(bitPosition: 6, in: PPUStateInstance.OAMFIFOInstance.fetchedEnteries[Int(entry)].attributesAndFlags) {
            tileY = ((spriteHeight * 2) - 2) - tileY;
        }
        var tileIndex = PPUStateInstance.OAMFIFOInstance.fetchedEnteries[Int(entry)].tileIndex;
        if spriteHeight == 16 {
            tileIndex &= ~(1);
        }
        let calculation: UInt16 = UInt16(0x8000 + (Int(tileIndex) * 16) + Int(tileY) + offset);
        PPUStateInstance.FIFOInstance.fetchEntryData[(Int(entry) * 2) + offset] = BusRead(address: calculation);
    }
}
func PipelineFetch() {
    switch PPUStateInstance.FIFOInstance.currentFIFOStep {
    case .GetTile:
        PPUStateInstance.OAMFIFOInstance.fetchedEnteryCount = 0
        //print("gt")
        GetTile();
        break;
    case .GetTileDataLow:
        //print("gtlow")
        GetTileDataLow();
        break;
    case .GetTileDataHigh:
       // print("gthigh")
        GetTileDataHigh();
        break;
    case .Sleep:
        //print("sleep")
        PPUStateInstance.FIFOInstance.currentFIFOStep = .Push;
        break;
    case .Push:
        //print("push")

        if PipelineFIFOAdd() {
            //print("pushif")
            PPUStateInstance.FIFOInstance.currentFIFOStep = .GetTile;
        }
        break;
    }
}

func PipelinePushPixel() {
    if PPUStateInstance.FIFOInstance.totalElements > 8 {
        //print("pushpixlif1")
        let pixelColor = PPUStateInstance.FIFOInstance.dequeue();
        if PPUStateInstance.FIFOInstance.lineX >= (LCDStateInstance.xScroll % 8) {
            //print("pushpixelif2")
            PPUStateInstance.videoBuffer[Int(PPUStateInstance.FIFOInstance.pushedX) + Int(LCDStateInstance.LY) * 160] = pixelColor; //LCDStateInstance.backGroundColors[Int(pixelColor)];
            PPUStateInstance.FIFOInstance.pushedX += 1;
        }
        PPUStateInstance.FIFOInstance.lineX += 1;
    }
}

func PipelinePrcess() {
//print("Piplelineprocess")
    PPUStateInstance.FIFOInstance.mapY = LCDStateInstance.LY &+ LCDStateInstance.yScroll;
    PPUStateInstance.FIFOInstance.mapX = PPUStateInstance.FIFOInstance.fetchX &+ LCDStateInstance.xScroll;
    PPUStateInstance.FIFOInstance.tileY = ((LCDStateInstance.LY &+ LCDStateInstance.yScroll) % 8) * 2;
    if PPUStateInstance.lineTicks & 1 == 0 {
        //print("Piplelineprocess1")

        PipelineFetch();
    }
    //print("Piplelineprocess2")

    PipelinePushPixel();
}
func PipelineFIFOReset() {
    while PPUStateInstance.FIFOInstance.totalElements > 0 {
       _ = PPUStateInstance.FIFOInstance.dequeue();
    }
}
