//
//  HomeView.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 18/05/25.
//

import SwiftUI
import SwiftData
import SwiftUIFlow
import WARangeSlider

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @Query private var menusFromLocal: [Menu]
    @Query private var tenantsFromLocal: [Tenant]
    
    @StateObject private var viewModel = HomeViewModel()
    
    var columns: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            VStack {
                // Searchbar & filter
                headerContent()
                
                // Main content
                ScrollView {
                    
                    popularMenuContent()
                    menuPerTenantContent(menusPerTenant: viewModel.menusPerTenant)
                }
            }
            .background(Color.theme)
            .onAppear {
                viewModel.updateDataSource(menus: menusFromLocal, tenants: tenantsFromLocal)
            }
            .onAppear {
                viewModel.updateDataSource(menus: menusFromLocal, tenants: tenantsFromLocal)
            }
            .onChange(of: menusFromLocal) { oldMenus, newMenus in
                viewModel.updateDataSource(menus: newMenus, tenants: tenantsFromLocal)
            }
            .onChange(of: tenantsFromLocal) { oldTenants, newTenants in
                viewModel.updateDataSource(menus: menusFromLocal, tenants: newTenants)
            }
        }
    }
    
    // =========================================== View Components
    
    private func headerContent() -> some View {
        HStack {
            ZStack(alignment: .trailing) {
                TextField("",
                          text: $viewModel.searchText,
                          prompt: Text("Search").foregroundColor(.darkGreen))
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .foregroundColor(Color.darkGreen)
                .background(Color.sageGreen.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.sageGreen, lineWidth: 1)
                )
                
                if(viewModel.searchText.isEmpty) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.darkGreen)
                    .padding(.trailing, 8)}
            }
            
            Button(action: {
                viewModel.isFilterModalOpen = true
            }) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(Color.sageGreen)
            }
            .font(.title2)
            .sheet(isPresented: $viewModel.isFilterModalOpen) { filterModal() }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .tint(Color.black.opacity(0.4))
    }
    
    private func popularMenuContent() -> some View {
        VStack{
            HStack {
                Text("Popular Menus")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("View all")
                    .font(.subheadline)
                    .foregroundColor(Color.sageGreen)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.popularMenus) { menu in
                        NavigationLink(
                            destination: DetailView(menuId: menu.id),
                            label: { PopularCardView(menu: menu) }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 16)
        }
    }
    
    private func menuPerTenantContent(menusPerTenant: [Tenant: [Menu]]) -> some View {
        VStack {
            ForEach(
                menusPerTenant.sorted(by: { $0.key.name < $1.key.name }),
                id: \.key.id
            ) { (tenant, menus) in
                VStack {
                    HStack {
                        Text(tenant.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                        Text("View all")
                            .font(.subheadline)
                            .foregroundColor(Color.sageGreen)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    LazyVStack {
                        ForEach(menus) { menu in
                            MenuCardView(menu: menu)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, -2)
                }
            }
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: 100, height: 100)
        }
    }
    
    private func filterModal() -> some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3)
                .frame(width: 120, height: 5)
                .foregroundColor(Color.gray.opacity(0.5))
                .padding(.top, 8)
                .frame(maxWidth: .infinity)
            
            ScrollView {
                Group {
                    FilterButton(
                        segmentTitle: "Tenant",
                        itemTitle: ["Ahza Snack and Beverage",
                                    "Mama Djempol",
                                    "Wong Jowo",
                                    "Bakso Bakwan Malang Josss",
                                    "Mie Ayam Kriuk",
                                    "Kedai Soto Pak Gembul",
                                    "La Ding",
                                    "Kedai 2 Nyonya",
                                    "Kantin Kasturi",
                                    "Mustafa Minang",
                                    "Kedai Laris Manis"],
                        translateId: true,
                        tenants: tenantsFromLocal,
                        selectedItems: $viewModel.selectedTenants,
                    )
                    
                    FilterButton(
                        segmentTitle: "Category",
                        itemTitle: ["Main dish", "Side dish", "Snack", "Dessert", "Drink", "Other"],
                        tenants: tenantsFromLocal,
                        selectedItems: $viewModel.selectedCategories
                    )
                    
                    FilterButton(
                        segmentTitle: "Main Ingredients",
                        itemTitle: ["Chicken", "Beef", "Fish", "Shrimp", "Egg", "Rice", "Noodles", "Veggies", "Other"],
                        tenants: tenantsFromLocal,
                        selectedItems: $viewModel.selectedIngredients
                    )
                    
                    FilterButton(
                        segmentTitle: "Taste",
                        itemTitle: ["Sweet", "Savoury", "Spicy", "Other"],
                        tenants: tenantsFromLocal,
                        selectedItems: $viewModel.selectedTastes
                    )
                    
                    VStack(alignment: .leading) {
                        Text("Price")
                            .font(.headline)
                            .padding(.top, 6)
                        
                        HStack {
                            Text("Rp\(currencyFormat(viewModel.minPrice))")
                            Spacer()
                            Text("Rp\(currencyFormat(viewModel.maxPrice))")
                        }
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        
                        RangeSliderView(
                            lowerValue: $viewModel.minPrice,
                            upperValue: $viewModel.maxPrice,
                            minimumValue: 0,
                            maximumValue: 50_000
                        )
                        .frame(height: 40)
                    }
                    .padding(.top, 6)
                }
                .padding(.top, 12)
                .padding(.horizontal)
                
                ZStack(alignment: .bottom) {
                    Color.clear.frame(height: 80)
                    
                    if (viewModel.isFilterActive) {
                        Text("Show \(viewModel.foodFilteredView.count) results")
                            .foregroundColor(.gray)
                            .italic()
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                HStack(spacing: 12) {
                    Button(action: {
                        viewModel.resetFilters()
                    }) {
                        Text("Reset")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.red)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.red, lineWidth: 3)
                            )
                            .cornerRadius(8)
                    }
                    
                    
                    Button(action: {
                        viewModel.applyFilters()
                    }) {
                        Text("Done")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(viewModel.isFilterActive ? .white : Color.dkGray)
                            .background(viewModel.isFilterActive ? Color.sageGreen : Color.chipGray)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color.white)
    }
    
    // Chip component
    struct FilterButton: View {
        var segmentTitle: String
        var itemTitle: [String]
        var translateId: Bool = false
        let tenants: [Tenant]
        @Binding var selectedItems: Set<String>
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(segmentTitle)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 6)
                
                Flow(.vertical, alignment: .topLeading, spacing: 8) {
                    ForEach(itemTitle, id: \.self) { item in
                        if translateId {
                            let id = tenants.findId(byName: item) ?? ""
                            
                            Text(item)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(
                                    selectedItems.contains(id) ? Color.sageGreen : Color.chipGray
                                )
                                .foregroundColor(selectedItems.contains(id) ? .white : .dkGray)
                                .cornerRadius(16)
                                .onTapGesture {
                                    if selectedItems.contains(id) {
                                        selectedItems.remove(id)
                                    } else {
                                        selectedItems.insert(id)
                                    }
                                }
                            
                        } else {
                            Text(item)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(
                                    selectedItems.contains(item) ? Color.sageGreen : Color.chipGray
                                )
                                .foregroundColor(selectedItems.contains(item) ? .white : .dkGray)
                                .cornerRadius(16)
                                .onTapGesture {
                                    if selectedItems.contains(item) {
                                        selectedItems.remove(item)
                                    } else {
                                        selectedItems.insert(item)
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
    
    // Double slider component
    struct RangeSliderView: UIViewRepresentable {
        @Binding var lowerValue: Double
        @Binding var upperValue: Double
        var minimumValue: Double
        var maximumValue: Double
        
        func makeUIView(context: Context) -> RangeSlider {
            let rangeSlider = RangeSlider(frame: .zero)
            rangeSlider.minimumValue = minimumValue
            rangeSlider.maximumValue = maximumValue
            rangeSlider.lowerValue = lowerValue
            rangeSlider.upperValue = upperValue
            
            rangeSlider.trackTintColor = UIColor(named: "ChipGray") ?? .gray
            rangeSlider.trackHighlightTintColor = UIColor(named: "SageGreen") ?? .systemGreen
            
            rangeSlider.addTarget(
                context.coordinator,
                action: #selector(Coordinator.rangeSliderValueChanged(_:)),
                for: .valueChanged
            )
            return rangeSlider
        }
        
        
        func updateUIView(_ uiView: RangeSlider, context: Context) {
            uiView.lowerValue = lowerValue
            uiView.upperValue = upperValue
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject {
            var parent: RangeSliderView
            
            init(_ parent: RangeSliderView) {
                self.parent = parent
            }
            
            @objc func rangeSliderValueChanged(_ sender: RangeSlider) {
                parent.lowerValue = round(sender.lowerValue / 1000) * 1000
                parent.upperValue = round(sender.upperValue / 1000) * 1000
            }
        }
    }
    
    func currencyFormat(_ value: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = "."
        return numberFormatter.string(from: NSNumber(value: Int(value))) ?? "\(Int(value))"
    }
}

//#Preview {
//    ContentView()
//}
