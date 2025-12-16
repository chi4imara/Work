import Foundation
import SwiftUI
import Combine

class StatisticsViewModel: ObservableObject {
    @Published var dreamCount: Int = 0
    @Published var tagCount: Int = 0
    @Published var dreamsByDate: [DreamDateData] = []
    @Published var tagFrequencies: [(String, Int)] = []
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        dataManager.$dreams
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.calculateStatistics()
            }
            .store(in: &cancellables)
        
        dataManager.$tags
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.calculateStatistics()
            }
            .store(in: &cancellables)
        
        calculateStatistics()
    }
    
    func calculateStatistics() {
        dreamCount = dataManager.getDreamCount()
        tagCount = dataManager.getTagCount()
        dreamsByDate = dataManager.getDreamsByDate().suffix(30).map { $0 }
        tagFrequencies = dataManager.getTagFrequencies().prefix(10).map { $0 }
    }
    
    func hasEnoughData() -> Bool {
        return dreamCount >= 2
    }
}
