//
//  IntentCard.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 14/05/25.
//

import SwiftUI

struct IntentCardView: View {
    var menu: Menu
    
    var body: some View {
        Link(destination: URL(string: "filterapp://menu/\(menu.id)")!)
        {
            HStack {
                ZStack {
                    Image(menu.id)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(30)
                        .padding(.vertical, 8)
                    
                    Color(.black.opacity(0.05))
                        .frame(width: 60, height: 60)
                        .cornerRadius(30)
                }
                .padding(.leading, 8)
                
                VStack(alignment: .leading,spacing: 3) {
                    Text(menu.name)
                        .font(.system(size: 17, weight: .bold))
                        .multilineTextAlignment(.leading)
                    
                    Text("\(menu.ingredient) | \(menu.taste)")
                        .font(.system(size: 13))
                        .foregroundColor(Color.gray)
                }
                .padding(.vertical, 8)
                .padding(.leading, 8)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 78)
            .background(Color.gray.opacity(0.12))
            .cornerRadius(52)
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 1, y: 2)
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
    
    IntentCardView(menu: sampleMenu)
}
