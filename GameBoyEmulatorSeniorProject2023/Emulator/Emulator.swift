//
//  Emulator.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 12/29/22.
//

import Foundation

struct EmulatorContext {
    var paused: Bool;
    var running: Bool;
    var ticks: UInt64;
    init(){
        paused = false;
        running = false;
        ticks = 0;
    }
}
