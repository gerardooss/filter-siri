//
//  TenantExtension.swift
//  Filter
//
//  Created by Marcelinus Gerardo on 07/05/25.
//

import Foundation
import SwiftData

extension Array where Element == Tenant {
    func findId(byName name: String) -> String? {
        return first { $0.name == name }?.id
    }
}

extension Array where Element == Menu {
    func findMenu(byId id: String) -> Menu? {
        return first { $0.id == id }
    }
}
