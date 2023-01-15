//
//  Cartridge.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 12/29/22.
//

import Foundation

struct RomHeader {
    var entry: [UInt8] = Array<UInt8>(repeating: 0 , count: 4);
    //logo has size 0x30
    var logo: [UInt8] = Array<UInt8>(repeating: 0 , count: 0x30);
    var title: [CChar] = Array<CChar>(repeating: 0 , count: 16);
    var newLicenseCode: UInt16;
    var sgbFlag: UInt8;
    var type: UInt8;
    var romSize: UInt8;
    var ramSize: UInt8;
    var destinationCode: UInt8;
    var licenseCode: UInt8;
    var version: UInt8;
    var checksum: UInt8;
    var globalChecksum: UInt16;
   /* init() {
    entry = Array<UInt8>(repeating: 0 , count: 4);
    logo: [UInt8] = Array<UInt8>(repeating: 0 , count: 0x30)
    }*/
}
//!!!!!!!!IMPLEMENT
func CartridgeLoad(cartridge: UnsafeMutablePointer<CChar>?) -> Bool {
    
}

func CartridgeRead(address: UInt16) -> UInt8 {
    //for now only rom tyoe supported
    print("NOT YET IMPLEMENTED");
}

func CartridgeWrite(address: UInt16, value: UInt8) {
    print("NOT YET IMPLEMENTED");
}

private let ROM_TYPES: [UnsafeMutablePointer<CChar>]? = [
    "ROM ONLY",
    "MBC1",
    "MBC1+RAM",
    "MBC1+RAM+BATTERY",
    "0x04 ???",
    "MBC2",
    "MBC2+BATTERY",
    "0x07 ???",
    "ROM+RAM 1",
    "ROM+RAM+BATTERY 1",
    "0x0A ???",
    "MMM01",
    "MMM01+RAM",
    "MMM01+RAM+BATTERY",
    "0x0E ???",
    "MBC3+TIMER+BATTERY",
    "MBC3+TIMER+RAM+BATTERY 2",
    "MBC3",
    "MBC3+RAM 2",
    "MBC3+RAM+BATTERY 2",
    "0x14 ???",
    "0x15 ???",
    "0x16 ???",
    "0x17 ???",
    "0x18 ???",
    "MBC5",
    "MBC5+RAM",
    "MBC5+RAM+BATTERY",
    "MBC5+RUMBLE",
    "MBC5+RUMBLE+RAM",
    "MBC5+RUMBLE+RAM+BATTERY",
    "0x1F ???",
    "MBC6",
    "0x21 ???",
    "MBC7+SENSOR+RUMBLE+RAM+BATTERY"
];
