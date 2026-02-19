import SwiftUI
import WebKit
import Network
import Foundation

public struct AganimProphet<Content: View, Loader: View>: View {
    private let loader: Loader
    private let content: Content
    @StateObject private var viewModel = NatureViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @State private var isAnimating = false
    
    public init(loader: Loader, @ViewBuilder content: () -> Content) {
        self.loader = loader
        self.content = content()
    }
    
    public init() where Content == EmptyView, Loader == EmptyView {
        self.loader = EmptyView()
        self.content = EmptyView()
    }
    
    public var body: some View {
        ZStack {
            if viewModel.currentState == .main {
                content
            } else if let url = viewModel.changedLabel {
                browserView
            } else {
                loader
            }
        }
        .onAppear(perform: isRatingPromptDue)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                isRatingPromptDue()
            }
        }
    }
    
    private var browserView: some View {
        VStack {
            configureAgreeButton
            setupPosterViewIfPresent
        }
    }
    
    @ViewBuilder
    private var configureAgreeButton: some View {
        if viewModel.hasParameter {
            Button("Agree") {
                withAnimation {
                    viewModel.currentState = .main
                    isRatingPromptDue()
                }
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding()
        }
    }
    
    @ViewBuilder
    private var setupPosterViewIfPresent: some View {
        if let url = viewModel.changedLabel {
            DisplayManager(url: url, viewModel: viewModel)
        }
    }
    
    private func isRatingPromptDue() {
        GalaxyRankTracker.shared.assessAndShowRatingPrompt()
    }
}
