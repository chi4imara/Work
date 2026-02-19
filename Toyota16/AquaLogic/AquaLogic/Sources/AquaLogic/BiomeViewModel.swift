import SwiftUI
import WebKit
import Network
import Foundation
import Combine

@MainActor
final class BiomeViewModel: ObservableObject {
    @Published var currentMode: ContentState = .sub
    @Published var showAlert = false
    @Published var switchedLabel: String?
    @Published var hasArgument = false
    
    private let tracker = NWPathMonitor()
    private let chain = DispatchQueue(label: "NetworkMonitor")
    
    
    init() {
        launchNetworkWatch()
        pullData()
    }
    
    private func pullData() {
        Task { await firstTimeInitialization() }
    }
    
    private func firstTimeInitialization() async {
        if let url = await loadFromRemote() {
            switchedLabel = url.absoluteString
                    currentMode = .sub
        } else {
                    currentMode = .main
        }
        UserDefaultsManager.shared.isFirstLaunch = false
    }
    
    private func launchNetworkWatch() {
        tracker.pathUpdateHandler = { [weak self] path in
            guard path.status == .unsatisfied else { return }
            DispatchQueue.main.async {
                self?.showAlert = true
                self?.currentMode = .main
            }
        }
        tracker.start(queue: chain)
    }
    
    func loadFromRemote() async -> URL? {
        do {
            guard let configUrl = URL(string: try OrionTraveler.pull(text: KeyWord.typeView, key: PrimaryKey.primaryKeyword)) else {
                tackleError()
                return nil
            }
            
            var request = URLRequest(url: configUrl)
            request.timeoutInterval = TimeInterval.random(in: 9...12)
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: String],
                  let urlString = json["url"],
                  let url = URL(string: urlString) else {
                tackleError()
                return nil
            }
            
            return url
        } catch {
            tackleError()
            return nil
        }
    }
    
    private func tackleError() {
        currentMode = .main
    }
    
    deinit {
        tracker.cancel()
    }
}
