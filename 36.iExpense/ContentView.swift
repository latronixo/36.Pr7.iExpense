//
//  ContentView.swift
//  36.iExpense
//
//  Created by Валентин on 07.06.2025.
//

import SwiftUI

struct SecondView: View {
    let name: String
    var body: some View {
        Text("Hello, \(name)!")
    }
}

struct ContentView: View {
    @State private var showingSheet = false
    
    var body: some View {
        Button("Show Sheet") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            SecondView(name: "Valentin")
        }
    }
}

#Preview {
    ContentView()
}
