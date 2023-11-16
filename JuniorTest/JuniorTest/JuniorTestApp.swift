//
//  JuniorTestApp.swift
//  JuniorTest
//
//  Created by Ihor on 15.11.2023.
//

import SwiftUI

@main
struct JuniorTestApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            JTHomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(networkMonitor)
        }
    }
}
