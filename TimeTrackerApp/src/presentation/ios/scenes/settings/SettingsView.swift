//
//  SettingsView.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Settings") {
                    Link("Contact Us", destination: URL(string: "mailto:greencoreapps@gmail.com")!)
                    
                    NavigationLink("Terms of Use") {
                        Text("Terms of Use…")
                            .foregroundStyle(.primary)
                    }
                    
                    NavigationLink("Privacy Policy") {
                        Text("Privacy Policy…")
                            .foregroundStyle(.primary)
                    }
                    NavigationLink("User Account") {
                        Text("Your Account…")
                            .foregroundStyle(.primary)
                    }
                }
                .foregroundStyle(.secondary)
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Dismiss") {
                    viewModel.dismiss()
                }
            }
        }
    }
}
