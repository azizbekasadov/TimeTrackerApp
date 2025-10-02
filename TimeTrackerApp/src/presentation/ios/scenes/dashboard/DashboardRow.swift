//
//  DashboardRow.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import SwiftUI

struct DashboardRow: View {
    let project: Project
    let minutes: Int
    let maxMinutes: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(project.name)
                    .font(.headline)
                
                Spacer()
                
                Text(TimeFormat.hhmm(from: minutes))
                    .monospacedDigit()
                    .font(.subheadline)
            }
            
            ProgressView(
                value: Double(minutes),
                total: Double(max(maxMinutes, 1))
            )
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DashboardRow(
        project: .init(name: "Some project"),
        minutes: 10,
        maxMinutes: 300
    )
    .padding()
}
