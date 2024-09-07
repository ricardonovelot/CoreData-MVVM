//
//  CoreData_MVVMApp.swift
//  CoreData+MVVM
//
//  Created by Ricardo on 06/09/24.
//

import SwiftUI

@main
struct CoreData_MVVMApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
