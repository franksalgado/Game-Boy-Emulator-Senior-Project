//
//  AppDelegate.swift
//  GameBoyEmulatorSeniorProject2023
//
//  Created by Frank Salgado on 2/21/23.
//


import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        _ = CartridgeStateInstance
        DispatchQueue.global().async {
            // Call the StartEmulator function with the necessary arguments
            StartEmulator(CartridgeStateInstance: CartridgeStateInstance, CPUStateInstance: CPUStateInstance, SerialData: SerialData, RAMStateInstance: RAMStateInstance, TestRomMessage: TestRomMessage, MessageSize: MessageSize, TimerStateInstance: TimerStateInstance, PPUStateInstance:  PPUStateInstance, DMAStateInstance: DMAStateInstance, LCDStateInstance: LCDStateInstance);
        }
    }
    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    
}
