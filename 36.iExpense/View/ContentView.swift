//
//  ContentView.swift
//  36.iExpense
//
//  Created by Валентин on 07.06.2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var expenses: Expenses
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationStack {
            List {
                // Секция личных расходов
                Section("Personal Expenses") {
                    ForEach(expenses.personalItems) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            let expenseItem = expenses.personalItems[offset]
                            modelContext.delete(expenseItem)
                        }
                    }
                }
                
                // Секция деловых расходов
                Section("Business Expenses") {
                    ForEach(expenses.businessItems) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            let expenseItem = expenses.businessItems[offset]
                            modelContext.delete(expenseItem)
                        }
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button("Add Expense", systemImage: "plus") {
                    showingAddExpense = true
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
}

struct ExpenseRow: View {
    let item: ExpenseItem
    
    var amountColor: Color {
        switch item.amount {
        case ...10: return .yellow
        case ...100: return .green
        default: return .blue
        }
    }
    
    var body: some View {
        HStack {
            Text(item.name)
                .font(.headline)
            
            Spacer()
            
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
            .foregroundColor(amountColor)
        }
    }
}
    
#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Expenses.self, configurations: config)
        let exampleExpenseItem = ExpenseItem(name: "Покупка б/у мака", type: "Personal", amount: 50,000.0)
        let example = Expenses(items: [exampleExpenseItem])
        ContentView(expenses: example)
            .modelContainer(container)
    } catch {
        Text("Failed to create preview: \(error.LocalizedDescription)")
    }
}
