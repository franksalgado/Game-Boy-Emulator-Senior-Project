//
//  Joypad.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 5/9/23.
//

import Foundation

/*
 WASD - UPDOWNLEFTRIGHT
 START - RETURN
 SELECT = RIGHTSHIFT
 */

enum GameBoyButtons: CUnsignedShort {
    case UP = 0x0D;
    case DOWN = 0x01;
    case LEFT = 0x00;
    case RIGHT = 0x02;
    case A = 0x26;
    case B = 0x28;
    case SELECT = 0x3C;
    case START = 0x24;
}
//init gamepad
// button selected bool
/*
 directional button selected
 button selected struct full of bools for each button
 gamepad state button direction and controller bools struct
 
 */


struct JoypadButtons {
    var up = false;
    var down = false;
    var left = false;
    var right = false;
    var a = false;
    var b = false;
    var select = false;
    var start = false;
}

class Joypad {
    let bitMask:UInt8 = 0x30
    var registerValue: UInt8 = 0xCF
    var temp: UInt8 = 0x0;
    var buttonSelect: Bool = false;
    var DPadSelect: Bool = false;
    var buttons = JoypadButtons();
    func JoypadWrite(value: UInt8) {
        self.buttonSelect = isBitSet(bitPosition: 5, in: value);
        self.DPadSelect = isBitSet(bitPosition: 4, in: value);
        //print(self.registerValue, value & self.bitMask)
        //self.registerValue |= value & 0x30;
    }
    func JoypadRead() -> UInt8 {
        self.registerValue = 0xCF;
        if !self.buttonSelect {
            //print( self.registerValue, self.temp, (self.registerValue) ^ self.temp)
            //self.registerValue ^= self.temp;
            if buttons.start {
                self.setBitJoypad(bitPosition: 3, bitValue: 0);
            }
            if buttons.select {
                self.setBitJoypad(bitPosition: 2, bitValue: 0);
            }
            if buttons.b {
                self.setBitJoypad(bitPosition: 1, bitValue: 0);
            }
            if buttons.a {
                self.setBitJoypad(bitPosition: 0, bitValue: 0);
            }
        }
        if !self.DPadSelect {
            //self.registerValue ^= self.temp;
            if buttons.down {
                self.setBitJoypad(bitPosition: 3, bitValue: 0);
            }
            if buttons.up {
                self.setBitJoypad(bitPosition: 2, bitValue: 0);
            }
            if buttons.left {
                self.setBitJoypad(bitPosition: 1, bitValue: 0);
            }
            if buttons.right {
                self.setBitJoypad(bitPosition: 0, bitValue: 0);
            }
        }
        //print("before return", self.registerValue)
        return self.registerValue;
    }
    
    func setBitJoypad(bitPosition: UInt8, bitValue: UInt8) -> Void {
        if bitValue == 1 {
            self.registerValue |= (1 << bitPosition);
            return;
        }
        else if bitValue == 0 {
            self.registerValue &= ~(1 << bitPosition);
        }
    }
}

var JoypadInstance = Joypad();

