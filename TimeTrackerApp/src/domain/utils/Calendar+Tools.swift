//
//  Calendar+Tools.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation

extension Calendar {
    func range(
        for period: Period,
        containing date: Date
    ) -> (start: Date, end: Date) {
        switch period {
        case .day:
            let start = startOfDay(for: date)
            let end = self.date(byAdding: .day, value: 1, to: start)?.addingTimeInterval(-1) ?? Date.distantPast
            return (start, end)
        case .week:
            let start = dateInterval(of: .weekOfYear, for: date)?.start ?? .distantPast
            let end = self.date(byAdding: .day, value: 7, to: start)?.addingTimeInterval(-1) ?? Date.distantPast
            return (start, end)
        case .month:
            let start = dateInterval(of: .month, for: date)?.start ?? .distantPast
            let end = self.date(byAdding: .month, value: 1, to: start)?.addingTimeInterval(-1) ?? Date.distantPast
            return (start, end)
        case .year:
            let start = dateInterval(of: .year, for: date)?.start ?? .distantPast
            let end = self.date(byAdding: .year, value: 1, to: start)?.addingTimeInterval(-1) ?? Date.distantPast
            return (start, end)
        }
    }
}
