//
//  _6_iExpenseApp.swift
//  36.iExpense
//
//  Created by Валентин on 07.06.2025.
//

import SwiftData
import SwiftUI

@main
struct _6_iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Expenses.self)
    }
}
