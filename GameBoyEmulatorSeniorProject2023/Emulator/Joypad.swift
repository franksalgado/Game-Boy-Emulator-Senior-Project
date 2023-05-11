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

class Joypad {
    var registerValue: UInt8 = 0xCF
    var buttonsArray: [UInt8] = [1, (1 << 1), (1 << 2), (1 << 3)];
    var DPadArray: [UInt8] = [1, (1 << 1), (1 << 2), (1 << 3)];
    var buttonSelect: Bool = false;
    var DPadSelect: Bool = false;
    func JoypadWrite(value: UInt8) {
        self.buttonSelect = isBitSet(bitPosition: 5, in: value);
        self.DPadSelect = isBitSet(bitPosition: 4, in: value);
    }
    func JoypadRead() -> UInt8 {
        self.registerValue = 0xCF;
        if !self.buttonSelect {
            var i: UInt8 = 0;
            for button in buttonsArray{
                if button == 0{
                    self.setBitJoypad(bitPosition: i, bitValue: 0);
                }
                i += 1;
            }
        }
        if !self.DPadSelect {
            var i: UInt8 = 0;
            for button in DPadArray{
                if button == 0{
                    self.setBitJoypad(bitPosition: i, bitValue: button);
                }
                i += 1;
            }
        }
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

