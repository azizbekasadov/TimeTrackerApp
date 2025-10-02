//
//  UIColor+.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import UIKit
import SwiftUI

public extension Color {
    static var label: Color {
        Color(UIColor.label)
    }
    
    @inlinable nonisolated init(_ hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            self.init(red: 0, green: 0, blue: 0)
            return
        }

        switch length {
        case 3: // RGB (12-bit, e.g. FFF)
            let r = Double((rgb >> 8) & 0xF) / 15.0
            let g = Double((rgb >> 4) & 0xF) / 15.0
            let b = Double(rgb & 0xF) / 15.0
            self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)

        case 6: // RRGGBB (24-bit)
            let r = Double((rgb >> 16) & 0xFF) / 255.0
            let g = Double((rgb >> 8) & 0xFF) / 255.0
            let b = Double(rgb & 0xFF) / 255.0
            self.init(.sRGB, red: r, green: g, blue: b, opacity: 1)

        case 8: // RRGGBBAA (32-bit)
            let r = Double((rgb >> 24) & 0xFF) / 255.0
            let g = Double((rgb >> 16) & 0xFF) / 255.0
            let b = Double((rgb >> 8) & 0xFF) / 255.0
            let a = Double(rgb & 0xFF) / 255.0
            self.init(.sRGB, red: r, green: g, blue: b, opacity: a)

        default:
            self.init(red: 0, green: 0, blue: 0)
        }
    }
}

extension Color {
    static let appPrimary: Color = Color("#88BC42")
    static let appBackground: Color = Color("#191D18")
    static let violet: Color = Color("#8545ED")
}
