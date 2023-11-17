//
//  EnergyTreckApp.swift
//  EnergyTreck
//
//  Created by Artem Leschenko on 12.11.2023.
//

import SwiftUI

@main
struct EnergyTreckApp: App {
    @StateObject private var vm = MainViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(vm)
        }
    }
}

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
