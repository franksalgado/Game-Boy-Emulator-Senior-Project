//
//  Cartridge.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 12/29/22.
//

import Foundation

struct RomHeader {
    var entry: [UInt8] = [];
    var logo: [UInt8] = [];
    var title: CChar;
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
}

//cartload bool functioncall

func CartridgeRead(address: UInt16) -> UInt8 {
    //for now only rom tyoe supported
    print("NOT YET IMPLEMENTED");
}

func CartridgeWrite(address: UInt16, value: UInt8) {
    print("NOT YET IMPLEMENTED");
}
