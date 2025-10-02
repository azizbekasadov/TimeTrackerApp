//
//  AuthView.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import Foundation
import SwiftUI
import SwiftData

struct AuthView: View {
    @Environment(\.modelContext) var modelContext: ModelContext
    
    @State private var viewModel: AuthViewModel
    
    init(
        viewModel: AuthViewModel
    ) {
        self.viewModel = viewModel
    }
    
    @ViewBuilder
    private func TextFieldsView() -> some View {
        VStack {
            TextField(text: $viewModel.username) {
                Text("Username")
            }
            .textFieldStyle(.plain)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.secondary.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            SecureField(text: $viewModel.password) {
                Text("Password")
            }
            .textFieldStyle(.plain)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.secondary.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    @ViewBuilder
    private func TitlesView() -> some View {
        VStack(alignment: .leading) {
            Text("Let's get started!")
                .font(.title2)
                .foregroundStyle(.primary)
                .bold()
            
            Text("Enter your username and password to log in")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private func SignInButtonView() -> some View {
        Button {
            
        } label: {
            Text("Sign in")
                .font(.headline)
                .bold()
                .foregroundStyle(Color.white)
                .padding(12)
        }
        .frame(maxWidth: .infinity)
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))

    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.violet,
                    Color.white,
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Image("Splash/applogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(radius: 10)
                
                Spacer()
                
                ZStack {
                    Color.white
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            TitlesView()
                            TextFieldsView()
                            SignInButtonView()
                                                    
                            Text("By tapping Sign in, you agree to our Terms of Service and Privacy Policy.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical)
                        .padding(.horizontal, 16)
                    }
                }
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )
                .padding()
                .padding(.bottom, 40)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}


