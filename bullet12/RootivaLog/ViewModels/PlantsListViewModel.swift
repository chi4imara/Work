import Foundation
import Combine

@MainActor
class PlantsListViewModel: ObservableObject {
    @Published var plantSummaries: [PlantSummary] = []
    @Published var filteredSummaries: [PlantSummary] = []
    @Published var searchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private var journalViewModel: RepotJournalViewModel
    
    init(journalViewModel: RepotJournalViewModel) {
        self.journalViewModel = journalViewModel
        
        setupReactiveUpdates()
        updatePlantSummaries()
    }
    
    private func setupReactiveUpdates() {
        journalViewModel.$records
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updatePlantSummaries()
            }
            .store(in: &cancellables)
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.applySearchFilter()
            }
            .store(in: &cancellables)
    }
    
    private func updatePlantSummaries() {
        let records = journalViewModel.records
        let groupedRecords = Dictionary(grouping: records) { $0.normalizedPlantName }
        
        plantSummaries = groupedRecords.map { (plantName, records) in
            let lastDate = records.map { $0.repotDate }.max() ?? Date()
            return PlantSummary(
                plantName: records.first?.plantName ?? plantName,
                recordCount: records.count,
                lastRepotDate: lastDate
            )
        }.sorted { $0.plantName < $1.plantName }
        
        applySearchFilter()
    }
    
    private func applySearchFilter() {
        if searchText.isEmpty {
            filteredSummaries = plantSummaries
        } else {
            filteredSummaries = plantSummaries.filter { summary in
                summary.plantName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func clearSearch() {
        searchText = ""
    }
}
