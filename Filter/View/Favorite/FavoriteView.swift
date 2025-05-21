//
//  FavoriteView.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 18/05/25.
//

import SwiftUI
import SwiftData

struct FavoriteView: View {
    @StateObject private var viewModel = FavoriteViewModel()
    @Query(filter: #Predicate<Menu> { $0.isFavorite == true })
    private var favoriteMenusFromLocal: [Menu]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My Favorite")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 16)
                Spacer()
            }
            .padding(.top, 8)
            
            Divider()
                .background(Color.gray.opacity(0.5))
                .padding(.top, 6)
            
            ScrollView{
                ForEach(viewModel.groupedFavoriteMenus.keys.sorted(by: { $0.name < $1.name }), id: \.id) { tenant in
                    if let menus = viewModel.groupedFavoriteMenus[tenant], !menus.isEmpty {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(tenant.name)
                                .font(.system(size: 17, weight: .bold))
                                .padding(.horizontal)
                            
                            menuHorizontalScroll(menus: menus)
                        }
                    }
                }
            }
            .padding(.top, 12)
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: 100, height: 100)
        }
        .background(Color.theme)
        .onAppear {
            viewModel.updateFavoriteMenus(favoriteMenusFromLocal)
        }
        .onChange(of: favoriteMenusFromLocal) { oldData, newData in
            viewModel.updateFavoriteMenus(newData)
        }
    }
    
    private func menuHorizontalScroll(menus: [Menu]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(menus) { menu in
                    NavigationLink(
                        destination: DetailView(menuId: menu.id),
                        label: {
                            FavoriteCardView(menu: menu)
                        }
                    )
                }
            }
            .padding()
        }
    }
}

#Preview {
    FavoriteView()
}

