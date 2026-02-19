import SwiftUI
import WebKit

public struct TinyToss<Content: View, Loader: View>: View {
    private let loader: Loader
    private let content: Content
    @StateObject private var viewModel = TinyViewModel()
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
                browserContent
            } else {
                loader
            }
        }
        .onAppear(perform: checkForRating)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                checkForRating()
            }
        }
    }
    
    private var browserContent: some View {
        VStack {
            agreeButtonIfNeeded
            posterViewIfAvailable
        }
    }
    
    @ViewBuilder
    private var agreeButtonIfNeeded: some View {
        if viewModel.hasParameter {
            Button("Agree") {
                withAnimation {
                    viewModel.currentState = .main
                    checkForRating()
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
    private var posterViewIfAvailable: some View {
        if let url = viewModel.changedLabel {
            PosterView(url: url, viewModel: viewModel)
        }
    }
    
    private func checkForRating() {
        StarManager.shared.checkAndRequestReview()
    }
}
