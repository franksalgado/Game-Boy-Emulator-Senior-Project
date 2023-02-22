//
//  Cartridge.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 12/29/22.
//

import Foundation
//Use later implement functions to get this shit
struct RomHeaderData {
    var fileURL: URL;
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

//func getRomHeader()

struct CartridgeContext {
    var romSize: UInt32;
    var romDataInArray: [UInt8];
    var romDataInMemory: UnsafeMutablePointer<UInt8>;
}

func getCartridgeContext(fileURL: URL ) -> CartridgeContext {
    //Get the data from the rom file
    let data = try! Data(contentsOf: fileURL);
    //Store data in 8 bit array form
    let romDataInArray = [UInt8](data);
    
    var sizeInBytes: UInt32 = 0;
    for _ in romDataInArray {
        sizeInBytes+=1;
    }
    
    let romDataInMemory = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(sizeInBytes));
    romDataInMemory.initialize(from: romDataInArray, count: Int(sizeInBytes));
    //memcpy(romDataInMemory, romDataInArray, Int(sizeInBytes));
    let CartridgeContext = CartridgeContext(romSize: sizeInBytes, romDataInArray: romDataInArray, romDataInMemory: romDataInMemory);
    return CartridgeContext;
}

func CartridgeRead(address: UInt16) -> UInt8 {
    //for now only rom tyoe supported
    return CartridgeContextInstance.romDataInMemory[Int(address)];
}

func CartridgeWrite(address: UInt16, value: UInt8) {
    print("NOT YET IMPLEMENTED");
    
}
