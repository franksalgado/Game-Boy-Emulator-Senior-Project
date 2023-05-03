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
struct FIFO {
    private var pixels: [SKColor] = [];
    
    mutating func enqueue(pixel: SKColor) {
        pixels.append(pixel);
    }
    mutating func dequeue() -> SKColor {
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

let binaryNumbers: [UInt8] = [0b10000000, 0b01000000, 0b00100000, 0b00010000, 0b00001000, 0b00000100, 0b00000010, 0b00000001];
func PipelineFIFOAdd() -> Bool {
    if PPUStateInstance.FIFOInstance.totalElements > 8 {
        return false;
    }
    let x = PPUStateInstance.FIFOInstance.fetchX &- (8 - (LCDStateInstance.xScroll & 8));
    var i = 0;
    var number = 0;
    while i < 8 {
        number = 0;
        if PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[1] & binaryNumbers[i] != 0 {
            number |= (1 <<  1);
        }
        if PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[2] & binaryNumbers[i] != 0 {
            number |= 1;
        }
        let pixel = LCDStateInstance.backGroundColors[number];
        if x >= 0 {
            PPUStateInstance.FIFOInstance.enqueue(pixel: pixel);
            PPUStateInstance.FIFOInstance.FIFOX &+= 1;
        }
        i += 1;
    }
    return true;
}

func PipelineFetch() {
    switch PPUStateInstance.FIFOInstance.currentFIFOStep {
    case .GetTile:
        if isBitSet(bitPosition: 0, in: LCDStateInstance.LCDControl) {
            var address: UInt16 {
                if isBitSet(bitPosition: 3, in: LCDStateInstance.LCDControl) {
                    return 0x9C00 + UInt16(PPUStateInstance.FIFOInstance.mapX / 8) + UInt16((PPUStateInstance.FIFOInstance.mapY / 8) * 32);
                }
                return 0x9800 + UInt16(PPUStateInstance.FIFOInstance.mapX / 8) + UInt16((PPUStateInstance.FIFOInstance.mapY / 8) * 32);
            }
            PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0] = BusRead(address: address);
            if !isBitSet(bitPosition: 4, in: LCDStateInstance.LCDControl) {
                PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0] += 128;
            }
            PPUStateInstance.FIFOInstance.currentFIFOStep = .GetTileDataLow;
            PPUStateInstance.FIFOInstance.fetchX &+= 8;
        }
        break;
    case .GetTileDataLow:
        var address: UInt16 {
            if isBitSet(bitPosition: 4, in: LCDStateInstance.LCDControl) {
                return 0x8000 + UInt16(PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0] * 16) + UInt16(PPUStateInstance.FIFOInstance.tileY);
            }
            return 0x8800 + UInt16(PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0] * 16) + UInt16(PPUStateInstance.FIFOInstance.tileY);
        }
        PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[1] = BusRead(address: address);
        PPUStateInstance.FIFOInstance.currentFIFOStep = .GetTileDataHigh;
        break;
    case .GetTileDataHigh:
        var address: UInt16 {
            if isBitSet(bitPosition: 4, in: LCDStateInstance.LCDControl) {
                return 0x8000 + UInt16(PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0] * 16) + UInt16(PPUStateInstance.FIFOInstance.tileY + 1);
            }
            return 0x8800 + UInt16(PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0] * 16) + UInt16(PPUStateInstance.FIFOInstance.tileY + 1);
        }
        PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[2] = BusRead(address: address);
        PPUStateInstance.FIFOInstance.currentFIFOStep = .Sleep;
        break;
    case .Sleep:
        PPUStateInstance.FIFOInstance.currentFIFOStep = .Push;
        break;
    case .Push:
        if PipelineFIFOAdd() {
            PPUStateInstance.FIFOInstance.currentFIFOStep = .GetTile;
        }
        break;
    }
}

func PipelinePushPixel() {
    if PPUStateInstance.FIFOInstance.totalElements > 8 {
        let pixelColor = PPUStateInstance.FIFOInstance.dequeue();
        if PPUStateInstance.FIFOInstance.lineX >= (LCDStateInstance.xScroll % 8) {
            PPUStateInstance.videoBuffer[Int(PPUStateInstance.FIFOInstance.pushedX + LCDStateInstance.LY * 160)] = pixelColor;
        }
    }
}

func PipelinePrcess() {
    PPUStateInstance.FIFOInstance.mapY = LCDStateInstance.LY + LCDStateInstance.yScroll;
    PPUStateInstance.FIFOInstance.mapX = PPUStateInstance.FIFOInstance.fetchX + LCDStateInstance.xScroll;
    PPUStateInstance.FIFOInstance.tileY = ((LCDStateInstance.LY + LCDStateInstance.yScroll) % 8) * 2;
    if PPUStateInstance.lineTicks & 1 == 0 {
        PipelineFetch();
    }
    PipelinePushPixel();
}

func PipelineFIFOReset() {
    while PPUStateInstance.FIFOInstance.totalElements != 0 {
       _ = PPUStateInstance.FIFOInstance.dequeue();
    }
}
