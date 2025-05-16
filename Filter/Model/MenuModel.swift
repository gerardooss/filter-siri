//
//  MenuModel.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 03/05/25.
//

import Foundation
import SwiftData
import AppIntents

@Model
class Menu: Identifiable {
    @Attribute(.unique) var id: String
    var name: String
    var category: String
    var ingredient: String
    var taste: String
    var price: Double
    var tenant: Tenant?
    var isFavorite: Bool = false
    var popularity: Int
    
    init (
        id: String,
        name: String,
        category: String,
        ingredient: String,
        taste: String,
        price: Double,
        tenant: Tenant? ,
        isFavorite: Bool,
        popularity: Int
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.ingredient = ingredient
        self.taste = taste
        self.price = price
        self.tenant = tenant
        self.isFavorite = isFavorite
        self.popularity = popularity
    }
}

enum Ingredient: String, Codable, CaseIterable, AppEnum {
    case chicken = "Chicken"
    case beef = "Beef"
    case fish = "Fish"
    case egg = "Egg"
    case rice = "Rice"
    case noodles = "Noodles"
    case vegetables = "Vegetables"
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Ingredient"
    
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .chicken: DisplayRepresentation(title: "Chicken"),
        .beef: DisplayRepresentation(title: "Beef"),
        .fish: DisplayRepresentation(title: "Fish"),
        .egg: DisplayRepresentation(title: "Egg"),
        .rice: DisplayRepresentation(title: "Rice"),
        .noodles: DisplayRepresentation(title: "Noodles"),
        .vegetables: DisplayRepresentation(title: "Vegetables")
    ]
    
    var title: String {
        switch self {
        case .chicken:
            return "Chicken"
        case .beef:
            return "Beef"
        case .fish:
            return "Fish"
        case .egg:
            return "Egg"
        case .rice:
            return "Rice"
        case .noodles:
            return "Noodles"
        case .vegetables:
            return "Vegetables"
        }
    }
}

struct IngredientEntity: AppEntity, Identifiable, Hashable {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Ingredients"
    static var defaultQuery = IngredientQuery()
    
    var id: String
    var name: String
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

struct IngredientQuery: EntityQuery {
    func entities(for identifiers: [String]) async throws -> [IngredientEntity] {
        allIngredients.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [IngredientEntity] {
        allIngredients
    }
    
    private var allIngredients: [IngredientEntity] {
        [
            .init(id: "chicken", name: "Chicken"),
            .init(id: "beef", name: "Beef"),
            .init(id: "fish", name: "Fish"),
            .init(id: "egg", name: "Egg"),
            .init(id: "rice", name: "Rice"),
            .init(id: "noodles", name: "Noodles"),
            .init(id: "vegetables", name: "Vegetables")
        ]
    }
}

