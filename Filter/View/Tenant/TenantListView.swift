//
//  TenantListView.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 18/05/25.
//

import SwiftUI
import SwiftData

struct TenantListView: View {
    @Environment(\.modelContext) private var context
    @Query private var tenantsFromLocal: [Tenant]
    
    @FocusState private var isSearchFieldFocused: Bool
    @State private var searchText = ""
    @State private var isNavigating = false
    @State private var tempSearch = ""
    
    var columns: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        let sortedTenants = tenantsFromLocal.sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
        
        VStack(spacing: 0) {
            HStack {
                Text("Tenant List")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 16)
                Spacer()
            }
            .padding(.top, 8)
            
            Divider()
                .background(Color.gray.opacity(0.5))
                .padding(.top, 6)
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    tenantsListView(tenants: sortedTenants)
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)
            }
        }
        .background(Color.theme)
    }
    
    private func tenantsListView(tenants: [Tenant]) -> some View {
        VStack{
            ForEach(tenants) { tenant in
                TenantCardView(tenantName: tenant.name, tenantId: tenant.id, tenantCategory: tenant.category).padding(.bottom, 4)
            }
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: 100, height: 100)
        }
    }
}

#Preview {
    TenantListView()
}
