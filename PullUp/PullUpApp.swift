//
//  PullUpApp.swift
//  PullUp
//
//  Created by Marcus Kim on 7/1/25.
//

import SwiftUI

@main
struct PullUpApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
