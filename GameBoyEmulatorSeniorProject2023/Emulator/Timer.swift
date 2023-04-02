//
//  Timer.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 4/2/23.
//

import Foundation


struct TimerState {
    var div: UInt16;
    var tima: UInt8;
    var tma: UInt8;
    var tac: UInt8;
    init() {
        //reset div to 0xAC00
        div = 0xAC00;
        tima = 0;
        tma = 0;
        tac = 0;
    }
}

var TimerStateInstance = TimerState();

func timerTick() -> Void {
    var previousDiv = TimerStateInstance.div;
    TimerStateInstance.div += 1;
    var timerUpdate: Bool = false;
    switch TimerStateInstance.tac & 0b11 {
    case 0b00:
        timerUpdate = (previousDiv & (1 << 9)) != 0 && (TimerStateInstance.div & (1 << 9)) == 0;
    case 0b01:
        timerUpdate = (previousDiv & (1 << 3)) != 0 && (TimerStateInstance.div & (1 << 3)) == 0;
    case 0b10:
        timerUpdate = (previousDiv & (1 << 5)) != 0 && (TimerStateInstance.div & (1 << 5)) == 0;
    case 0b11:
        timerUpdate = (previousDiv & (1 << 7)) != 0 && (TimerStateInstance.div & (1 << 7)) == 0;
    default:
        break;
    }

    if timerUpdate && (TimerStateInstance.tac & (1 << 2)) != 0 {
        TimerStateInstance.tima += 1;

        if TimerStateInstance.tima == 0xFF {
            TimerStateInstance.tima = TimerStateInstance.tma;
            RequestInterrupt(InterruptTypes: .TIMER);
        }
    }
}


func TimerRead(address: UInt16) -> UInt8 {
    switch(address) {
    case 0xFF04:
        return UInt8(TimerStateInstance.div >> 8);
    case 0xFF05:
        return TimerStateInstance.tima;
    case 0xFF06:
        return TimerStateInstance.tma;
    case 0xFF07:
        return TimerStateInstance.tac;
    default:
        return 0; 
    }
}

func TimerWrite(address: UInt16, value: UInt8) -> Void {
    switch(address) {
    case 0xFF04:

        TimerStateInstance.div = 0;
    case 0xFF05:
        TimerStateInstance.tima = value;
    case 0xFF06:
        TimerStateInstance.tma = value;
    case 0xFF07:

        TimerStateInstance.tac = value;
    default:
        break;
    }
}
