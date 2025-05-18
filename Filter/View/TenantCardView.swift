//
//  TenantCardView.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 18/05/25.
//

import SwiftUI

struct TenantCardView: View {
    @State var tenantName: String
    @State var tenantId: String = ""
    @State var tenantCategory: String
        
    var body: some View {
        HStack {
            Circle()
                .fill(Color.sageGreen.opacity(0.5))
                .frame(width: 54, height: 54)
                .padding(.trailing, 6)
            
            Spacer()
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(tenantName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(tenantCategory)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.4), radius: 2, x: 1, y: 2)
    }
}

#Preview {
    TenantCardView(tenantName: "Tenant A", tenantCategory: "Korean")
}
