//
//  SplashView.swift
//  TimeTrackerApp
//
//  Created by Azizbek Asadov on 02.10.2025.
//

import SwiftUI

public struct SplashView: View {
    @State private var viewModel: SplashViewModelable
    
    init(viewModel: SplashViewModelable) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            
            AppLogoView()
                .opacity(viewModel.isLoaded ? 1 : 0)
            
            FooterView()
                .opacity(viewModel.isLoaded ? 1 : 0)
        }
        .onChange(of: viewModel.error, { oldValue, newValue in
            if newValue != nil {
                viewModel.shouldShowError = true
            }
        })
        .onAppear {
            Task {
                await viewModel.onAppear()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation(.smooth) {
                    viewModel.didFinishLoading()
                }
            }
        }
        .task {
            await viewModel.bootstrap()
        }
    }
    
    @ViewBuilder
    private func FooterView() -> some View {
        VStack {
            Spacer()
            
            Text("Crafted by Azizbek Asadov. Zürich 2025®")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.65))
                .padding(.bottom, 12)
        }
    }
    
    @ViewBuilder
    private func AppLogoView() -> some View {
        VStack {
            Spacer()
            AppLogoImageView()
            Spacer()
        }
    }
    
    @ViewBuilder
    private func AppLogoImageView() -> some View {
        Image(Constants.Images.appLogo)
            .resizable()
            .scaledToFill()
            .frame(
                width: Constants.Sizes.appLogoSize.width,
                height: Constants.Sizes.appLogoSize.height
            )
            .clipShape(
                RoundedRectangle(
                    cornerSize: Constants.Sizes.appLogoCornerRadius
                )
            )
    }
}

extension SplashView {
    private enum Constants {
        enum Images {
            static let appLogo = "Splash/applogo"
        }
        
        enum Sizes {
            static let appLogoSize: CGSize = .init(
                width: 120,
                height: 120
            )
            static let appLogoCornerRadius: CGSize = .init(
                width: 20,
                height: 20
            )
        }
    }
}
