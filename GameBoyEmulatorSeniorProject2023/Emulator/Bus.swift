//
//  Bus.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 1/1/23.
//

import Foundation

func BusRead(address: UInt16) -> UInt8 {
    if (address < 0x8000) {
        return CartridgeRead(address: address, CartridgeContextInstance: <#CartridgeContext#>);
    }
    print("NOT YET IMPLEMENTED");
}

func BusWrite(address: UInt16, value: UInt8) {
    if (address < 0x8000) {
       // CartridgeWrite(address, value);
        return;
    }
    print("NOT YET IMPLEMENTED");
}

