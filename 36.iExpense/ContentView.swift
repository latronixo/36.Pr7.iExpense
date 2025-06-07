//
//  ContentView.swift
//  36.iExpense
//
//  Created by Валентин on 07.06.2025.
//

import SwiftUI

struct User {
    var firstName = "Valentin"
    var secondName = "Kartoshkin"
}

struct ContentView: View {
    @State private var user = User()
    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.secondName)")
            
            TextField("First name", text: $user.firstName)
            TextField("Second name", text: $user.secondName)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
