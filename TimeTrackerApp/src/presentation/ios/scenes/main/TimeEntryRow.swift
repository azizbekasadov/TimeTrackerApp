//
//  TimeEntryRow.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import SwiftUI

struct TimeEntryRow: View {
    let entry: TimeEntry
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading) {
                Text(entry.project?.name ?? "—").font(.headline)
                if let c = entry.comment, !c.isEmpty {
                    Text(c).font(.subheadline).foregroundStyle(.secondary).lineLimit(1)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(TimeFormat.hhmm(from: entry.minutes)).monospacedDigit()
                Text(entry.date, style: .date).font(.caption).foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    TimeEntryRow(
        entry: .Root(
            date: Date(),
            minutes: 100,
            project: .init(name: "Cool Project"),
            employee: Employee(
                name: "John Doe",
                username: "john.doe123",
                password: "123123"
            )
        )
    )
}
