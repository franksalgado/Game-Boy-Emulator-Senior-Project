//
//  gameboyApp.swift
//  gameboy
//
//  Created by Frank Salgado on 12/27/22. ;)
//

import SwiftUI

@main
struct gameboyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
