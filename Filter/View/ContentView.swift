//
//  ContentView.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 03/05/25.
//

import SwiftUI
import SwiftData
import SwiftUIFlow
import WARangeSlider

struct ContentView: View {
    @State private var selectedIndex = 0
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottom) {
                Group {
                    switch selectedIndex {
                    case 0:
                        HomeView()
                    case 1:
                        TenantListView()
                    case 2:
                        FavoriteView()
                    default:
                        HomeView()
                    }
                }
                
                LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.4), .clear]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                        .frame(height: 120) // hanya area bawah
                        .ignoresSafeArea(edges: .bottom) // biar sampai ke tepi bawah
                        .zIndex(0)
                
                // Bottom bar
                HStack {
                    TabBarButton(
                        systemIcon: "popcorn",
                        btnName: "Menus",
                        isSelected: selectedIndex == 0) {
                            selectedIndex = 0
                        }
                    Spacer()
                    TabBarButton(
                        systemIcon: "storefront",
                        btnName: "Tenants",
                        isSelected: selectedIndex == 1) {
                            selectedIndex = 1
                        }
                    Spacer()
                    TabBarButton(
                        systemIcon: "heart",
                        btnName: "Favorite",
                        isSelected: selectedIndex == 2) {
                            selectedIndex = 2
                        }
                }
                .padding(8)
                .background(.white)
                .clipShape(Capsule())
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
                .shadow(radius: 5)
                
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct TabBarButton: View {
    var systemIcon: String
    var btnName: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: -1) {
                Image(systemName: systemIcon)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(isSelected ? .sageGreen : .gray)
                    .padding(10)
                
                if (isSelected) {
                    Text(btnName)
                        .padding(.trailing, 12)
                        .foregroundColor(.sageGreen)
                }
            }
            .background(isSelected ? Color.sageGreen.opacity(0.1) : Color.clear)
            .clipShape(Capsule())
        }
    }
}

#Preview {
    ContentView()
}
