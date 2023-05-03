//
//  Cartridge.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 12/29/22.
//

import Foundation
import Cocoa
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


func InitializeCartridgeState() -> CartridgeState {
    _ = FileManager()
    let openPanel = NSOpenPanel()
    openPanel.canChooseFiles = true
    openPanel.canChooseDirectories = false
    
    guard openPanel.runModal() == .OK else {
        exit(-5)
    }
    
    guard let url = openPanel.urls.first else {
        exit(-5)
    }
    
    do {
        let data = try Data(contentsOf: url);
        let romDataInArray = [UInt8](data);
        var sizeInBytes: UInt32 = 0;
            for _ in romDataInArray {
                sizeInBytes += 1;
            }
        let romDataInMemory = UnsafeMutablePointer<UInt8>.allocate(capacity: Int(sizeInBytes));
        romDataInMemory.initialize(from: romDataInArray, count: Int(sizeInBytes));
        let cartridgeState = CartridgeState(romSize: sizeInBytes, romDataInArray: romDataInArray, romDataInMemory: romDataInMemory);
        return cartridgeState;
    } catch {
        print("Error reading file: \(error.localizedDescription)");
        exit(-5)
    }
}

var CartridgeStateInstance = InitializeCartridgeState();

func CartridgeRead(address: UInt16) -> UInt8 {
    return CartridgeStateInstance.romDataInArray[Int(address)];
}

func CartridgeWrite(address: UInt16, value: UInt8) {
    print("NOT YET IMPLEMENTED cart write");
    
}
