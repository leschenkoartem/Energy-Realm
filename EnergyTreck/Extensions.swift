//
//  Extensions.swift
//  EnergyTreck
//
//  Created by Artem Leschenko on 12.11.2023.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    func customMenu(horPadding: Bool = true) -> some View {
        self
            .foregroundColor(.white)
            .padding(5)
            .padding(.horizontal, horPadding ? 16: 0)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray5))
            .cornerRadius(5)
    }
}

extension Color {
    static var main = Color.orange
}
