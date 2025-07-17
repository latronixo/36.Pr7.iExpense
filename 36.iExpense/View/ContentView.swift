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
    private var filteredItems: [ExpenseItem] {
        expenses.filter{ $0.type == filter}
                .sorted(using: sortOrder)
    }
    private var businessItems: [ExpenseItem] {
        expenses.filter{ $0.type == "Business"}
                .sorted(using: sortOrder)
    }
    
    @State private var filter = "Personal"
    
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.amount)
    ]
    
    var body: some View {
        NavigationStack {
            List {
                // Секция личных расходов
                Section("Expenses") {
                    ForEach(filteredItems) { item in
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
                ToolbarItem {
                    Menu("Filter", systemImage: "arrow.up.arrow.down") {
                        Picker("Filter", selection: $filter) {
                            Text("Only Personal")
                                .tag("Personal")
                            Text("Only Business")
                                .tag("Business")
                        }
                    }
                }
                
                ToolbarItem {
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Sort By Name")
                            .tag([
                                SortDescriptor(\ExpenseItem.name),
                                SortDescriptor(\ExpenseItem.amount)
                            ])
                        Text("Sort by Amount")
                            .tag([
                                SortDescriptor(\ExpenseItem.amount),
                                SortDescriptor(\ExpenseItem.name)
                            ])
                    }
                }
            }
            
            ToolbarItem {
                    Button("Add Expense", systemImage: "plus") {
                        showingAddExpense = true
                    }
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
    let container = try! ModelContainer(for: ExpenseItem.self, configurations: config)
    let context = container.mainContext
    let exampleExpenseItem = ExpenseItem(name: "Покупка б/у мака", type: "Personal", amount: 50000.0)
    let exampleExpenseItem2 = ExpenseItem(name: "Аренда офиса за июль", type: "Business", amount: 40000.0)
    context.insert(exampleExpenseItem2)
    context.insert(exampleExpenseItem)
    return ContentView()
        .modelContainer(container)
}
