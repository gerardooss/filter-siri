//
//  FavoriteCardView.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 18/05/25.
//

import SwiftUI

struct FavoriteCardView: View {
    var menu: Menu
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(menu.id)
                .resizable()
                .frame(width: 164, height: 118)
                .cornerRadius(12)
                .background(
                    RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.2))
                )
                .padding(.horizontal, 8)
                .padding(.top, 8)
            
            Spacer().frame(height: 4)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(menu.name)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: menu.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
                .padding(.top, 1)
                
                Text(menu.ingredient)
                    .font(.system(size: 13))
                    .foregroundColor(Color.gray)
                
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .frame(width: 180, height: 175)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 1, y: 2)
    }
}

#Preview {
    let sampleTenant = Tenant(id: "t1", name: "Sample Tenant", category: "Cafe", phone: "123456", desc: "Sample Desc")
    let sampleMenu = Menu(
        id: "57",
        name: "Leppy",
        category: "Food",
        ingredient: "Choco",
        taste: "Sweet",
        price: 5000,
        tenant: sampleTenant,
        isFavorite: true,
        popularity: 6
    )
    
    FavoriteCardView(menu: sampleMenu)
}
