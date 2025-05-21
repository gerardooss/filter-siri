//
//  FavoriteViewModel.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 21/05/25.
//

import Foundation
import SwiftData
import Combine

class FavoriteViewModel: ObservableObject {
    @Published var favoriteMenus: [Menu] = []
    @Published var groupedFavoriteMenus: [Tenant: [Menu]] = [:]
    
    init() {}
    
    func updateFavoriteMenus(_ menus: [Menu]) {
        self.favoriteMenus = menus
        self.processGroupedFavorites()
    }
    
    private func processGroupedFavorites() {
        let menusWithTenant = favoriteMenus.filter { $0.tenant != nil }
        
        self.groupedFavoriteMenus = Dictionary(grouping: menusWithTenant) { $0.tenant! }
    }
}
