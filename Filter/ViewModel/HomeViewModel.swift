//
//  HomeViewModel.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 21/05/25.
//

import Foundation
import SwiftData
import Combine

class HomeViewModel: ObservableObject {
    @Published var allMenus: [Menu] = []
    @Published var allTenants: [Tenant] = []
    
    @Published var searchText: String = ""
    @Published var isFilterModalOpen: Bool = false
    
    @Published var selectedCategories: Set<String> = []
    @Published var selectedTenants: Set<String> = []
    @Published var selectedIngredients: Set<String> = []
    @Published var selectedTastes: Set<String> = []
    @Published var minPrice: Double = 0
    @Published var maxPrice: Double = 50000
    
    // MARK: - Computed Properties (Logic dari View akan pindah ke sini)
    // Ini akan di-trigger ulang ketika salah satu @Published property di atas berubah
    
    @Published var foodFilteredView: [Menu] = []
    @Published var popularMenus: [Menu] = []
    @Published var menusPerTenant: [Tenant: [Menu]] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    var selectedPriceRange: ClosedRange<Double> {
        minPrice...maxPrice
    }
    
    var isFilterActive: Bool {
        !selectedCategories.isEmpty ||
        !selectedTenants.isEmpty ||
        !selectedTastes.isEmpty ||
        !selectedIngredients.isEmpty ||
        minPrice != 0 ||
        maxPrice != 50000
    }
    
    // Baru untuk update data
    func updateDataSource(menus: [Menu], tenants: [Tenant]) {
        self.allMenus = menus
        self.allTenants = tenants
    }
    
    func applyFilters() {
        isFilterModalOpen = false
    }
    
    func resetFilters() {
        selectedCategories.removeAll()
        selectedTenants.removeAll()
        selectedIngredients.removeAll()
        selectedTastes.removeAll()
        minPrice = 0
        maxPrice = 50000
    }
    
    // Init
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        Publishers.CombineLatest4(
            $allMenus,
            $searchText,
            $selectedCategories,
            $selectedTenants
        )
        
        $searchText
            .sink { [weak self] _ in self?.updateFilteredResults() }
            .store(in: &cancellables)
        
        $selectedCategories
            .sink { [weak self] _ in self?.updateFilteredResults() }
            .store(in: &cancellables)
        
        $selectedTenants
            .sink { [weak self] _ in self?.updateFilteredResults() }
            .store(in: &cancellables)
        
        $selectedIngredients
            .sink { [weak self] _ in self?.updateFilteredResults() }
            .store(in: &cancellables)
        
        $selectedTastes
            .sink { [weak self] _ in self?.updateFilteredResults() }
            .store(in: &cancellables)
        
        $minPrice
            .sink { [weak self] _ in self?.updateFilteredResults() }
            .store(in: &cancellables)
        
        $maxPrice
            .sink { [weak self] _ in self?.updateFilteredResults() }
            .store(in: &cancellables)
        
        $allMenus
            .sink { [weak self] _ in self?.updateFilteredResults() }
            .store(in: &cancellables)
        
        updateFilteredResults()
    }
    
    private func updateFilteredResults() {
        let filtered = allMenus.filter { menu in
            let matchesSearch = searchText.isEmpty || menu.name.lowercased().contains(searchText.lowercased())
            let matchesCategory = selectedCategories.isEmpty || selectedCategories.contains(menu.category)
            let matchesTenant = selectedTenants.isEmpty || selectedTenants.contains(menu.tenant?.id ?? "")
            let matchesIngredient = selectedIngredients.isEmpty || selectedIngredients.contains(menu.ingredient)
            let matchesTaste = selectedTastes.isEmpty || selectedTastes.contains(menu.taste)
            let matchesPrice = Double(menu.price) >= minPrice && Double(menu.price) <= maxPrice
            
            return matchesSearch && matchesCategory && matchesTenant && matchesIngredient && matchesTaste && matchesPrice
        }
        self.foodFilteredView = filtered
        
        self.popularMenus = Array(filtered
            .sorted { $0.popularity > $1.popularity }
            .prefix(5))
        
        let grouped = Dictionary(grouping: filtered) { $0.tenant! }
        self.menusPerTenant = grouped.mapValues { menusInGroup in
            Array(menusInGroup.prefix(3))
        }
    }
    
    func findTenantIdByName(_ name: String) -> String? {
        return allTenants.first(where: { $0.name == name })?.id
    }
}
