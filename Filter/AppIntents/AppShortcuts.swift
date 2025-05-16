//
//  FilterShotcuts.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 13/05/25.
//
import AppIntents

struct AppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: FilterIntents(),
            phrases: [
                "Find a menu with \(.applicationName)",
                "Find a menu using \(.applicationName)",
                "Find me a menu using \(.applicationName)",
                "Search menu using \(.applicationName)"
            ],
            shortTitle: "Filter Menu",
            systemImageName: "fork.knife.circle"
        )
    }
}
