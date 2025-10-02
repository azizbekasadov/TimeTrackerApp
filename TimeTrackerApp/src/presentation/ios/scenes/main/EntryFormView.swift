//
//  EntryFormView.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import SwiftUI
import Factory
import SwiftData

struct EntryFormView: View {
    @Query(filter: #Predicate<Project> { $0.isActive == true }, sort: [SortDescriptor(\.name)]) private var projects: [Project]

    @State var viewModel: EntryFormViewModel

    var body: some View {
        NavigationStack {
            Form {
                TopPicker()
                
                MiddlePartView()
                
                BottomView()
            }
            .navigationTitle(viewModel.existingEntry == nil ? "New Entry" : "Edit Entry")
            .toolbar {
                Button("Dismiss") {
                    viewModel.dismiss()
                }
            }
            .overlay {
                if viewModel.isLoading {
                    Color.secondary.opacity(0.3)
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
    
    @ViewBuilder
    private func TopPicker() -> some View {
        DatePicker(
            "Date",
            selection: $viewModel.date,
            displayedComponents: .date
        )
    }
    
    @ViewBuilder
    private func MiddlePartView() -> some View {
        Picker(
            "Project",
            selection: Binding(
                get: {
                    viewModel.project?.id
                },
                set: {
                    id in viewModel.project = projects.first { $0.id == id } }
            )
        ) {
            ForEach(projects) { p in
                Text(p.name)
                    .tag(p.id as UUID?)
            }
        }
        
        HStack {
            TextField("Time (e.g., 2, 8.5, 15, 150)", text: $viewModel.timeRaw)
                .keyboardType(.decimalPad)
                .onSubmit { viewModel.onBlurFormat() }
                .onChange(of: viewModel.timeRaw) { _, _ in }
            
            Button("Format") {
                viewModel.onBlurFormat()
            }
        }
    }
    
    @ViewBuilder
    private func BottomView() -> some View {
        TextField(
            "Comment (optional)",
            text: $viewModel.comment,
            axis: .vertical
        )
        
        if let error = viewModel.error {
            Text(error).foregroundStyle(.red)
        }
        
        Button {
            viewModel.save()
        } label: {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(Color.white)
                    .foregroundStyle(.white)
            } else {
                Text(viewModel.existingEntry == nil ? "Save" : "Update")
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    EntryFormView(
        viewModel: EntryFormViewModel(
            router: AppRouter(),
            container: Container(),
            existing: nil
        )
    )
}
