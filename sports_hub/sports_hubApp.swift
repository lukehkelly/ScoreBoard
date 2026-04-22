//
//  sports_hubApp.swift
//  sports_hub
//
//  Created by Luke Kelly on 4/7/26.
//

import SwiftUI
import SwiftData

@main
struct sports_hubApp: App {
    let container: ModelContainer

    init() {
        container = Self.makeContainer()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(container)
    }

    private static func makeContainer() -> ModelContainer {
        do {
            return try ModelContainer(for: FavoriteTeam.self)
        } catch {

            let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            let storeURL = support.appending(path: "default.store")
            try? FileManager.default.removeItem(at: storeURL)
            try? FileManager.default.removeItem(at: storeURL.appendingPathExtension("shm"))
            try? FileManager.default.removeItem(at: storeURL.appendingPathExtension("wal"))
            do {
                return try ModelContainer(for: FavoriteTeam.self)
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }
}
