//
//  FavoriteView.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 18/05/25.
//

import SwiftUI
import SwiftData

struct FavoriteView: View {
    @Query(filter: #Predicate<Menu> { $0.isFavorite == true }) private var favoriteMenus: [Menu]
    
    var groupedFavorites: [Tenant: [Menu]] {
        Dictionary(grouping: favoriteMenus) { $0.tenant! }
    }
    
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
                ForEach(groupedFavorites.keys.sorted(by: { $0.name < $1.name }), id: \.id) { tenant in
                    if let menus = groupedFavorites[tenant]{
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

