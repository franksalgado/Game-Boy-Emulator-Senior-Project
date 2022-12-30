//
//  cartridge.swift
//  gameboy
//
//  Created by Frank Salgado on 12/29/22.
//

import Foundation

struct RomHeader {
    var entry: [UInt8] = [];
    var logo: [UInt8] = [];
    var title: CChar;
    var newLicenseCode: UInt16;
    
}
