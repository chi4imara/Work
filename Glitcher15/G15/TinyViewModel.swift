import Network
import Foundation
import Combine

@MainActor
final class TinyViewModel: ObservableObject {
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
            guard let configUrl = URL(string: RaceManger.set(RaceManger.token, key: RaceManger.key)) else { 
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
