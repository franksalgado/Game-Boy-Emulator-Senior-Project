//
//  PictureProcessingUnit.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 4/5/23.
//

import Foundation


var num1: UInt8 = 0b11111111
var num2: UInt8 = 0b00000000

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
        return first | second;
    }
}
