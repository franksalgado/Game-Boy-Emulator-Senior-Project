//
//  Stack.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 3/23/23.
//

import Foundation

func StackPush(data: UInt8) -> Void {
    CPUStateInstance.registersState.sp &-= 1;
    BusWrite(address: CPUStateInstance.registersState.sp, value: data);
}
//First we push the high byte to the stack so we just shift right 8 bits and convert to UInt8.
//Next we shift the bottom 8 bits of data to the right 8 and back 8. This gives us 8 0s in the high byte and the low byte.
func StackPush16Bit(data: UInt16) -> Void {
    let highByte = UInt8(data >> 8);
    let lowByte = UInt8( (data << 8) >> 8 )
    StackPush(data: highByte);
    StackPush(data: lowByte);
}

func StackPop() -> UInt8 {
    CPUStateInstance.registersState.sp += 1;
    return BusRead(address: (CPUStateInstance.registersState.sp &- 1))
}

func StackPop16Bit() -> UInt16 {
    let lowByte: UInt16 = UInt16(StackPop());
    let highByte: UInt16 = UInt16(StackPop()) << 8;
    return highByte | lowByte;
}
