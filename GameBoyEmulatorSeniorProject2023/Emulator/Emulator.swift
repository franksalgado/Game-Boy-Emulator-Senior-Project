//
//  Emulator.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 12/29/22.
//

import Foundation

struct EmulatorState {
    var paused: Bool;
    var running: Bool;
    var ticks: UInt64;
    init(){
        paused = false;
        running = true;
        ticks = 0;
    }
}

var EmulatorStateInstance = EmulatorState();


func EmulatorCycles(CPUCycles: Int) -> Void {
    var i: Int = 0;
    var n: Int = 0;
    while i < CPUCycles {
        while n < 4 {
            EmulatorStateInstance.ticks += 1;
            TimerTick();
            n += 1;
        }
        i += 1;
    }
}
func StartEmulator( CartridgeStateInstance: CartridgeState, CPUStateInstance: CPUState, SerialData: [UInt8], RAMStateInstance: RAMState, TestRomMessage: [UInt8], MessageSize: Int, TimerStateInstance: TimerState, PPUStateInstance: PPUState) -> Void {
    while EmulatorStateInstance.running {
        print("emurun")
        if !CPUStateInstance.CPUStep() {
            exit(-5);
        }
    }
}

