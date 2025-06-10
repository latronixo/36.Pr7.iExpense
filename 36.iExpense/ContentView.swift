//
//  ContentView.swift
//  36.iExpense
//
//  Created by Валентин on 07.06.2025.
//

import SwiftUI

struct User: Codable {
    let firstName: String
    let secondName: String
}

struct ContentView: View {
    @State private var user = User(firstName: "Valentin", secondName: "Kartoshkin")
    
    var body: some View {
        Button("Save user") {
            let encoder = JSONEncoder()
            
            if let data = try? encoder.encode(user) {
                UserDefaults.standard.set(data, forKey: "UserData")
            }
        }
    }
}

#Preview {
    ContentView()
}
