//
//  MainView.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Factory
import SwiftUI
import SwiftData
import Observation

struct MainView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            FilterBar()
            
            List {
                Section {
                    ForEach(viewModel.filteredEntries) { entry in
                        TimeEntryRow(entry: entry)
                            .onTapGesture {
                                viewModel.showEntryForm(for: entry)
                            }
                    }
                    .onDelete { idx in
                        idx.map {
                            viewModel.filteredEntries[$0]
                        }
                        .forEach(viewModel.delete)
                    }
                }
                Section(
                    footer: Text("Total: \(TimeFormat.hhmm(from: viewModel.totalMinutes(entries: viewModel.filteredEntries)))")
                ) {
                    EmptyView()
                }
            }
            .listStyle(.insetGrouped)

            HStack {
                Button {
                    viewModel.showEntryForm()
                } label: {
                    Label("New Entry", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)

                Spacer()

                Menu {
                    Button("Dashboard") {
                        viewModel.showDashboard()
                    }
                    Button("Settings") {
                        viewModel.showSettings()
                    }
                    
                    if viewModel.isAdmin {
                        Button("Manage Users") {
//                            viewModel.coordinator.push(.adminUsers)
                        }
                        Button("Manage Projects") {
//                            viewModel.coordinator.push(.adminProjects)
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                }
            }
            .padding()
        }
        .navigationTitle("Time Tracker")
        .onAppear {
            viewModel.onAppear()
        }
    }

    @ViewBuilder
    private func FilterBar() -> some View {
        VStack(spacing: 8) {
            HStack {
                Picker("Period", selection: $viewModel.period) {
                    ForEach(Period.allCases) { p in Text(p.rawValue.capitalized).tag(p) }
                }
                .pickerStyle(.segmented)
            }
            .padding(.bottom)

            HStack {
                Button { viewModel.selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: viewModel.selectedDate)! } label: {
                    Image(systemName: "minus.circle")
                }
                
                DatePicker("Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                
                Text(weekDayAbbrev(viewModel.selectedDate))
                    .frame(width: 40)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Menu {
                    Picker(
                        "Project",
                        selection: Binding(
                            get: {
                                viewModel.selectedProject?.id
                            },
                            set: { id in
                                viewModel.selectedProject = viewModel.activeProjects.first { $0.id == id }
                            }
                        )
                    ) {
                        Text("All Projects").tag(UUID?.none)
                        ForEach(viewModel.activeProjects) { project in
                            Text(project.name)
                                .tag(UUID?.some(project.id))
                        }
                    }
                } label: {
                    Label(viewModel.selectedProject?.name ?? "All Projects", systemImage: "folder")
                }
                
                if viewModel.isAdmin {
                    Menu {
                        let employees = viewModel.fetchEmployees()
                        
                        Picker(
                            "Employee",
                            selection: Binding(
                                get: {
                                    viewModel.selectedEmployee?.id
                                },
                                set: { id in
                                    viewModel.selectEmployee(id)
                                }
                            )
                        ) {
                            Text("Me / All")
                                .tag(UUID?.none)
                            ForEach(employees) { e in
                                Text(e.name)
                                    .tag(UUID?.some(e.id))
                            }
                        }
                    } label: {
                        Label(viewModel.selectedEmployee?.name ?? "Employees", systemImage: "person.2")
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }

    private func weekDayAbbrev(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = .current
        f.dateFormat = "E" // e.g., Mon
        return f.string(from: date)
    }
}

#Preview {
    MainView(
        viewModel: MainViewModel(
            container: Container(),
            router: AppRouter()
        )
    )
}
