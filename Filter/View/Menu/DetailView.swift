//
//  DetailView.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 15/05/25.
//

import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.modelContext) private var context
    @Query private var tenantsFromLocal: [Tenant]
    @Query private var menusFromLocal: [Menu]
    var menuId: String
    
    var menu: Menu {menusFromLocal.findMenu(byId: menuId) ?? menusFromLocal.first!}
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var selectedTenant: [Tenant] {
        tenantsFromLocal .filter { $0.id == menu.tenant?.id }
    }
    
    var body: some View {
        ScrollView {
            Image(menu.id)
                .resizable()
                .frame(width:370, height:270)
                .clipShape (RoundedRectangle(cornerRadius:15))
                .background(
                    RoundedRectangle(cornerRadius: 15).fill(Color.black.opacity(0.2))
                )
                .overlay(RoundedRectangle(cornerRadius:15).stroke(Color.black.opacity(0.2), lineWidth: 1))
                .padding(.horizontal, 15)
            
            imageDescContent()
        }
        .background(Color.theme)
    }
    
    private func imageDescContent() -> some View {
        VStack(alignment:.leading) {
            HStack {
                Text(menu.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                
                Spacer()
                
                Button {
                    toggleFavorite()
                } label: {
                    Image(systemName: menu.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .font(.system(size: 24))
                }
            }
            .padding(.bottom, -1)
            
            HStack(spacing: 4) {
                Image(systemName: "tag.fill")
                    .foregroundColor(.sageGreen)
                    .font(.system(size: 14))
                Text(menu.category)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.trailing, 10)
                
                Image(systemName: "carrot.fill")
                    .foregroundColor(.sageGreen)
                    .font(.system(size: 14))
                Text(menu.ingredient)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.trailing, 10)
                
                Image(systemName: "flask.fill")
                    .foregroundColor(.sageGreen)
                    .font(.system(size: 14))
                Text(menu.taste)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .italic()
                
                Spacer()
                
                
            }
            
            HStack {
                Circle()
                        .fill(Color.sageGreen.opacity(0.5))
                        .frame(width: 48, height: 48)
                
                Text(selectedTenant.first?.name ?? "Not found")
                    .font(.subheadline)
                    .fontWeight(.bold)
            }
            .padding(.top, 12)
        }
        .padding(.horizontal)
    }
    
    private func toggleFavorite() {
        menu.isFavorite.toggle()
        do {
            try context.save()
        } catch {
            print("Error saving: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let sampleTenant = Tenant(id: "t1", name: "Sample Tenant", category: "Cafe", phone: "123456", desc: "Sample Desc")
    
    let sampleMenu = Menu(
        id: "88",
        name: "Sample Menu",
        category: "Food",
        ingredient: "Ingredients",
        taste: "Sweet",
        price: 10.0,
        tenant: sampleTenant,
        isFavorite: false,
        popularity: 6
    )
    
    DetailView(menuId: sampleMenu.id)
}

