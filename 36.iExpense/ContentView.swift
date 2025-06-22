//
//  ContentView.swift
//  36.iExpense
//
//  Created by Валентин on 07.06.2025.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            saveItems()
        }
    }
    
    var personalItems: [ExpenseItem] {
        items.filter { $0.type == "Personal" }
    }
    
    var businessItems: [ExpenseItem] {
        items.filter { $0.type == "Business" }
    }
    
    init() {
        loadItems()
    }
    
    private func loadItems() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items"),
           let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
            items = decodedItems
        } else {
            items = []
        }
    }
    
    private func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "Items")
        }
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    var body: some View {
        NavigationStack {
            List {
                // Секция личных расходов
                Section("Personal Expenses") {
                    ForEach(expenses.personalItems) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, type: "Personal")
                    }
                }
                
                // Секция деловых расходов
                Section("Business Expenses") {
                    ForEach(expenses.businessItems) { item in
                        ExpenseRow(item: item)
                    }
                    .onDelete { offsets in
                        removeItems(at: offsets, type: "Business")
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink(destination: AddView(expenses: expenses)) {
                    Label("Add Expense", systemImage: "plus")
                }
            }
        }
    }
    
    func removeItems(at offsets: IndexSet, type: String) {
        let itemsToDelete = type == "Personal" ? expenses.personalItems : expenses.businessItems
        let idsToDelete = offsets.map { itemsToDelete[$0].id }
        expenses.items.removeAll { idsToDelete.contains($0.id) }
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
    ContentView()
}
