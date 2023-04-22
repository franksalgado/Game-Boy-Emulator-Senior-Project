//
//  Cartridge.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 12/29/22.
//

import Foundation
//Use later implement functions to get this shit. 
struct RomHeaderAndCartDataData {
    var fileURL: URL;
    var entry: [UInt8] = Array<UInt8>(repeating: 0 , count: 4);
    //logo has size 0x30
    var logo: [UInt8] = Array<UInt8>(repeating: 0 , count: 0x30);
    var title: [CChar] = Array<CChar>(repeating: 0 , count: 16);
    var romSize: UInt8;
    var ramSize: UInt8;
   /* init() {
    entry = Array<UInt8>(repeating: 0 , count: 4);
    logo: [UInt8] = Array<UInt8>(repeating: 0 , count: 0x30)
    }*/
}

//func getRomHeaderData()

struct CartridgeState {
    var romSize: UInt32;
    var romDataInArray: [UInt8];
    var romDataInMemory: UnsafeMutablePointer<UInt8>;
}
var fileURL: URL = URL(string: "file:///Users/franksalgado/Documents/roms/tetris.gb")!;

func InitializeCartridgeState(fileURL: URL ) -> CartridgeState {
    /*
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: "file:///Users/franksalgado/Documents/roms/tetris.gb" ) {
        print("File Exists")
    } else {
        print(" not File Exists")
    }

    */
    //Get the data from the rom file

    guard let data = try? Data(contentsOf: fileURL)
    else {
        print("forbidden cartridge read\n");
        exit(-5);
    }

    //Store data in 8 bit array form
    let romDataInArray = [UInt8](data);
    

    var sizeInBytes: UInt32 = 0;
    for _ in romDataInArray {
        sizeInBytes += 1;
    }
    
    let romDataInMemory = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(sizeInBytes));
    romDataInMemory.initialize(from: romDataInArray, count: Int(sizeInBytes));
    //memcpy(romDataInMemory, romDataInArray, Int(sizeInBytes));
    let CartridgeState = CartridgeState(romSize: sizeInBytes, romDataInArray: romDataInArray, romDataInMemory: romDataInMemory);
    return CartridgeState;
}


var CartridgeStateInstance = InitializeCartridgeState(fileURL: fileURL);


func CartridgeRead(address: UInt16) -> UInt8 {
    return CartridgeStateInstance.romDataInMemory[Int(address)];
}

func CartridgeWrite(address: UInt16, value: UInt8) {
    print("NOT YET IMPLEMENTED");
    
}
