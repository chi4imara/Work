import SwiftUI
import WebKit

public struct RemoteScreen<Content: View>: View {
    private let content: Content
    @StateObject private var viewModel = RemoteViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @State private var isAnimating = false
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public init() where Content == EmptyView {
        self.content = EmptyView()
    }
    
    public var body: some View {
        ZStack {
            if viewModel.currentState == .main {
                content
            } else if let url = viewModel.redirectLink {
                browserContent
            } else {
                loadingView
            }
        }
        .onAppear(perform: checkForRating)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                checkForRating()
            }
        }
    }
    
    private var loadingView: some View {
        ZStack {
            Color.black
                .opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            center: .center
                        ),
                        style: StrokeStyle(
                            lineWidth: 8,
                            lineCap: .round
                        )
                    )
                    .frame(width: 80, height: 80)
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                    .animation(
                        Animation.linear(duration: 1)
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
                
                Text("Loading...")
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .opacity(isAnimating ? 1 : 0.7)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
    
    private var browserContent: some View {
        VStack {
            agreeButtonIfNeeded
            browserViewIfAvailable
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
    private var browserViewIfAvailable: some View {
        if let url = viewModel.redirectLink {
            BrowserView(url: url, viewModel: viewModel)
        }
    }
    
    private func checkForRating() {
        AppRatingManager.shared.checkAndRequestReview()
    }
}