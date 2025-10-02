//
//  TimeFormat.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation

struct TimeFormat {
    static func parse(_ raw: String) -> Int? {
        let str = raw.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        .replacingOccurrences(of: ",", with: ".")
        
        if str.isEmpty || str.contains("::") {
            return nil
        }

        if str.contains(":") {
            let parts = str.split(separator: ":").map(String.init)
            
            guard
                parts.count == 2,
                let h = Int(parts[0]),
                let m = Int(parts[1]), (0..<60).contains(m)
            else {
                return nil
            }
            
            return h * 60 + m
        }

        if let f = Double(str) {
            if f <= 10 {
                return Int((f * 60).rounded())
            }
        }

        if let v = Int(str) {
            if v <= 10 {
                return v * 60
            }
            
            if v < 100 {
                return v
            }
            
            return v
        }
        return nil
    }

    static func hhmm(from minutes: Int) -> String {
        let h = minutes / 60
        let m = minutes % 60
        return String(format: "%02d:%02d", h, m)
    }
}
