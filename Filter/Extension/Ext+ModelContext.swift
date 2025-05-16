//
//  Ext+ModelContext.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 14/05/25.
//

import SwiftData

enum ModelContextProvider {
    static var context: ModelContext?
}

extension ModelContext {
    static func getContextForAppIntents() -> ModelContext {
        if let context = ModelContextProvider.context {
            return context
        }
        
        let schema = Schema([
            Menu.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            return .init(container)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
