//
//  FilterIntents.swift
//  FilterIntents
//
//  Created by Marcelinus Gerardo on 13/05/25.
//

import Foundation
import AppIntents
import SwiftData
import SwiftUI

struct FilterIntents: AppIntent {
    static var title: LocalizedStringResource = "Find Menu"
    static var description = IntentDescription("Find menu based on ingredient")
    static var openAppWhenRun = false
    
    @Parameter(title: "")
    var ingredient: Ingredient
    
    static var parameterSummary: some ParameterSummary {
        Summary("Find menu with \(\.$ingredient)")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        let modelContext = ModelContext.getContextForAppIntents()
        let fetchDescriptor = FetchDescriptor<Menu>()
        let allMenus = try modelContext.fetch(fetchDescriptor)
        
        let filteredMenus: [Menu]
        let selectedIngredient = ingredient.rawValue
        
        filteredMenus = allMenus.filter { $0.ingredient == selectedIngredient }
        let displayCount = filteredMenus.count < 5 ? filteredMenus.count : 5
        
        let dialogMessage: IntentDialog
        if filteredMenus.isEmpty {
            dialogMessage = .init("No result found for \(selectedIngredient).")
        } else {
            dialogMessage = .init("Showing \(displayCount) of \(filteredMenus.count) results for \(selectedIngredient).")
        }
        
        return .result(
            dialog: dialogMessage,
            view:
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(filteredMenus.prefix(5), id: \.id) { menu in
                        IntentCardView(menu: menu)
                    }
                    if displayCount < filteredMenus.count{
                        HStack {
                            Spacer()
                            Text("Open app to view more")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                    }
                }
                .padding()
        )
    }
}
