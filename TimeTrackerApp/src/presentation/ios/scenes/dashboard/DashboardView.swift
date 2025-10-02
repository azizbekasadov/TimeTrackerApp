//
//  DashboardView.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import SwiftUI
import SwiftData
import Factory

struct DashboardView: View {
    @Query(filter: #Predicate<Project> { $0.isActive == true }, sort: [SortDescriptor(\.name)]) private var projects: [Project]
    @Query(sort: [SortDescriptor(\TimeEntry.date, order: .reverse)]) private var allEntries: [TimeEntry]

    @State private var viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }

    private var totals: [(project: Project, minutes: Int)] {
        guard let user = viewModel.currentUser else { return [] }
        let (start, end) = viewModel.dateRange()
        
        let mocks = [
            TimeEntry(date: Date(), minutes: 100, project: .init(name: "Cool Project"), employee: viewModel.currentUser),
            TimeEntry(date: Date(), minutes: 100, project: .init(name: "Cool Project"), employee: viewModel.currentUser),
            TimeEntry(date: Date(), minutes: 100, project: .init(name: "Cool Project"), employee: viewModel.currentUser),
            TimeEntry(date: Date(), minutes: 100, project: .init(name: "Cool Project"), employee: viewModel.currentUser)
        ]
        
        let entries = allEntries.filter { entry in
            entry.employee?.id == user.id && (start...end).contains(entry.date) && entry.project != nil
        }
        
        var byProject: [UUID: Int] = [:]
        
        for entry in entries {
            if let pid = entry.project?.id {
                byProject[pid, default: 0] += entry.minutes
            }
        }
        
        var result: [(Project, Int)] = projects.map {
            ($0, byProject[$0.id] ?? 0)
        }
        
        result.sort { lhs, rhs in
            if lhs.1 != rhs.1 {
                return lhs.1 > rhs.1
            }
            
            return lhs.0.name < rhs.0.name
        }
        return result
    }

    var body: some View {
        VStack(spacing: 8) {
            VStack(alignment: .center, spacing: 8) {
                Picker("Period", selection: $viewModel.period) {
                    ForEach(Period.allCases) { p in
                        Text(p.rawValue.capitalized)
                            .tag(p)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.bottom)
                
                HStack(alignment: .center) {
                    Button {
                        viewModel.selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: viewModel.selectedDate)!
                    } label: {
                        Image(systemName: "minus.circle")
                    }
                    
                    DatePicker("Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                    
                    Text(weekDayAbbrev(viewModel.selectedDate))
                        .frame(width: 50)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)
            }

            List {
                ForEach(totals, id: \.project.id) { item in
                    DashboardRow(project: item.project, minutes: item.minutes, maxMinutes: totals.first?.minutes ?? 1)
                }
            }
            .listStyle(.insetGrouped)
        }
        .padding()
        .navigationTitle("Dashboard")
    }

    private func weekDayAbbrev(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
}

#Preview {
    NavigationStack {
        DashboardView(viewModel: .init(router: AppRouter(), container: Container()))
    }
}
