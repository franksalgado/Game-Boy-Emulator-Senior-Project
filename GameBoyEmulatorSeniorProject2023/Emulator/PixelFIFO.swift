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
    private var pixels: [UInt8] = [];
    
    mutating func enqueue(pixel: UInt8) {
        pixels.append(pixel);
    }
    mutating func dequeue() -> UInt8 {
        guard !pixels.isEmpty
        else {
            fatalError("empty queue");
        }
        return pixels.removeFirst();
    }
    var head : UInt8 {
        guard let head = pixels.first
        else {
            fatalError("empty queue");
        }
        return head;
    }
    var tail : UInt8 {
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
        //let pixel = LCDStateInstance.backGroundColors[number];
        if x >= 0 {
            PPUStateInstance.FIFOInstance.enqueue(pixel: number);
            PPUStateInstance.FIFOInstance.FIFOX += 1;
        }
        i += 1;
    }
    return true;
}

func GetTile() {
    if isBitSet(bitPosition: 0, in: LCDStateInstance.LCDControl) {
        //print("GTif")
        var address: UInt16 {
            if isBitSet(bitPosition: 3, in: LCDStateInstance.LCDControl) {
                return 0x9C00 + UInt16(PPUStateInstance.FIFOInstance.mapX / 8) + UInt16((PPUStateInstance.FIFOInstance.mapY / 8) * 32);
            }
            return UInt16( 0x9800 + Int(PPUStateInstance.FIFOInstance.mapX / 8) + Int(Int(PPUStateInstance.FIFOInstance.mapY / 8) * 32) );
        }
        PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0] = BusRead(address: address);
        if !isBitSet(bitPosition: 4, in: LCDStateInstance.LCDControl) {
            PPUStateInstance.FIFOInstance.BackgroundWindowFetchData[0] &+= 128;
        }
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
    PPUStateInstance.FIFOInstance.currentFIFOStep = .Sleep;
}

func PipelineFetch() {
    switch PPUStateInstance.FIFOInstance.currentFIFOStep {
    case .GetTile:
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
            PPUStateInstance.videoBuffer[Int(PPUStateInstance.FIFOInstance.pushedX) + Int(LCDStateInstance.LY) * 160] = LCDStateInstance.backGroundColors[Int(pixelColor)];
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
