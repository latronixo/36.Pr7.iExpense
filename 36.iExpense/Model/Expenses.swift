//
//  Expenses.swift
//  36.iExpense
//
//  Created by Валентин on 17.07.2025.
//

import Foundation
import SwiftData

@Model
class Expenses {
    @Relationship(deleteRule: .cascade) var items: [ExpenseItem]
    
    var personalItems: [ExpenseItem] {
        items.filter { $0.type == "Personal" }
    }
    
    var businessItems: [ExpenseItem] {
        items.filter { $0.type == "Business" }
    }
    
    init(items: [ExpenseItem]) {
        self.items = items
    }
}

