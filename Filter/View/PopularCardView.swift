//
//  TenantListView.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 03/05/25.
//

import SwiftUI

struct PopularCardView: View {
    
    var menu: Menu
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                Image(menu.id)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 240)
                    .clipped()
                    .cornerRadius(16)
                
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.9),
                        Color.black.opacity(0.5),
                        Color.clear,
                        Color.clear
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(menu.name)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    chips([menu.ingredient, menu.taste])
                }
                .padding(10)
                
            }
            .cornerRadius(16)
            .frame(width: 160, height: 240)
        }
    }
    
    private func chips(_ text: [String]) -> some View {
        HStack(spacing: 4) {
            ForEach(text, id: \.self) { item in
                Text(item)
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(.white.opacity(0.5))
                    .cornerRadius(6)
            }
        }
    }
}

#Preview {
    let sampleTenant = Tenant(id: "t1", name: "Sample Tenant", category: "Cafe", phone: "123456", desc: "Sample Desc")
    let sampleMenu = Menu(
        id: "57",
        name: "Teri Sambal",
        category: "Food",
        ingredient: "Fish",
        taste: "Spicy",
        price: 20000,
        tenant: sampleTenant,
        isFavorite: true,
        popularity: 6
    )
    
    PopularCardView(menu: sampleMenu)
}
