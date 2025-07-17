//
//  Expense.swift
//  36.iExpense
//
//  Created by Валентин on 17.07.2025.
//

import Foundation
import SwiftData

@Model
class ExpenseItem {
    var id: UUID
    var name: String
    var type: String
    var amount: Double
    
    init(name: String, type: String, amount: Double) {
        self.id = UUID()
        self.name = name
        self.type = type
        self.amount = amount
    }
}

