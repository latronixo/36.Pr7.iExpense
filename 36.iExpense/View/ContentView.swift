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
    @Query private var expenses: [ExpenseItem]
    @State private var showingAddExpense = false
    var personalItems: [ExpenseItem] {
        expenses.filter{ $0.type == "Personal"}
    }
    var businessItems: [ExpenseItem] {
        expenses.filter{ $0.type == "Business"}
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Секция личных расходов
                Section("Personal Expenses") {
                    ForEach(personalItems) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            let expenseItem = expenses[offset]
                            modelContext.delete(expenseItem)
                        }
                    }
                }
                
                // Секция деловых расходов
                Section("Business Expenses") {
                    ForEach(businessItems) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete { offsets in
                        for offset in offsets {
                            let expenseItem = expenses[offset]
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
                AddView()
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Expenses.self, configurations: config)
    let context = container.mainContext
    let exampleExpenseItem = ExpenseItem(name: "Покупка б/у мака", type: "Personal", amount: 50000.0)
    let exampleExpenseItem2 = ExpenseItem(name: "Аренда офиса за июль", type: "Business", amount: 40000.0)
    context.insert(exampleExpenseItem2)
    context.insert(exampleExpenseItem)
    return ContentView()
        .modelContainer(container)
}
