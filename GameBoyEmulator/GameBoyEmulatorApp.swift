//
//  GameBoyEmulatorApp.swift
//  GameBoyEmulator
//
//  Created by Frank Salgado on 1/2/23.
//

import SwiftUI

@main
struct GameBoyEmulatorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
