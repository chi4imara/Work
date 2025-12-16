import Foundation
import Combine

enum SortOption: CaseIterable {
    case dateNewest
    case dateOldest
    case plantNameAZ
    case plantNameZA
    
    var displayName: String {
        switch self {
        case .dateNewest:
            return "By date: newest → oldest"
        case .dateOldest:
            return "By date: oldest → newest"
        case .plantNameAZ:
            return "By plant: A → Z"
        case .plantNameZA:
            return "By plant: Z → A"
        }
    }
}

enum FilterPeriod: CaseIterable {
    case all
    case today
    case week
    case month
    case custom
    
    var displayName: String {
        switch self {
        case .all:
            return "All"
        case .today:
            return "Today"
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .custom:
            return "Custom period"
        }
    }
}

@MainActor
class RepotJournalViewModel: ObservableObject {
    @Published var records: [RepotRecord] = []
    @Published var filteredRecords: [RepotRecord] = []
    @Published var searchText: String = ""
    @Published var selectedSort: SortOption = .dateNewest
    @Published var selectedPeriod: FilterPeriod = .all
    @Published var selectedPlant: String = "Any"
    @Published var customStartDate: Date = Date()
    @Published var customEndDate: Date = Date()
    @Published var isFilterActive: Bool = false
    @Published var highlightedRecordId: UUID?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let saved = RepotStorage.loadRecords()
        self.records = saved
        self.filteredRecords = records
        
        $records
            .sink { newRecords in
                RepotStorage.saveRecords(newRecords)
            }
            .store(in: &cancellables)
        
        setupReactiveFiltering()
        
        applyFiltersAndSort()
    }
    
    private func setupReactiveFiltering() {
        Publishers.CombineLatest4(
            $searchText.debounce(for: .milliseconds(300), scheduler: RunLoop.main),
            $selectedSort,
            $selectedPeriod,
            $selectedPlant
        )
        .sink { [weak self] _, _, _, _ in
            self?.applyFiltersAndSort()
        }
        .store(in: &cancellables)
        
        $records
            .sink { [weak self] _ in
                self?.applyFiltersAndSort()
            }
            .store(in: &cancellables)
    }
    
    func applyFiltersAndSort() {
        var filtered = records
        
        if !searchText.isEmpty {
            filtered = filtered.filter { record in
                record.plantName.localizedCaseInsensitiveContains(searchText) ||
                (record.careNote?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        filtered = applyPeriodFilter(to: filtered)
        
        if selectedPlant != "Any" {
            filtered = filtered.filter { $0.normalizedPlantName == selectedPlant.lowercased() }
        }
        
        filtered = applySorting(to: filtered)
        
        filteredRecords = filtered
        updateFilterActiveState()
    }
    
    private func applyPeriodFilter(to records: [RepotRecord]) -> [RepotRecord] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .all:
            return records
        case .today:
            return records.filter { calendar.isDate($0.repotDate, inSameDayAs: now) }
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return records.filter { $0.repotDate >= weekAgo }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return records.filter { $0.repotDate >= monthAgo }
        case .custom:
            return records.filter { record in
                record.repotDate >= customStartDate && record.repotDate <= customEndDate
            }
        }
    }
    
    private func applySorting(to records: [RepotRecord]) -> [RepotRecord] {
        switch selectedSort {
        case .dateNewest:
            return records.sorted { $0.repotDate > $1.repotDate }
        case .dateOldest:
            return records.sorted { $0.repotDate < $1.repotDate }
        case .plantNameAZ:
            return records.sorted { $0.plantName < $1.plantName }
        case .plantNameZA:
            return records.sorted { $0.plantName > $1.plantName }
        }
    }
    
    private func updateFilterActiveState() {
        isFilterActive = !searchText.isEmpty || selectedPeriod != .all || selectedPlant != "Any"
    }
    
    func clearFilters() {
        searchText = ""
        selectedPeriod = .all
        selectedPlant = "Any"
    }
    
    func addRecord(_ record: RepotRecord) {
        records.append(record)
        highlightedRecordId = record.id
        applyFiltersAndSort()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.highlightedRecordId = nil
        }
    }
    
    func updateRecord(_ record: RepotRecord) {
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            records[index] = record
            applyFiltersAndSort()
        }
    }
    
    func deleteRecord(_ record: RepotRecord) {
        records.removeAll { $0.id == record.id }
        applyFiltersAndSort()
    }
    
    func deleteRecord(at indexSet: IndexSet) {
        for index in indexSet {
            let record = filteredRecords[index]
            deleteRecord(record)
        }
    }
    
    var uniquePlantNames: [String] {
        let names = Set(records.map { $0.normalizedPlantName })
        return ["Any"] + Array(names).sorted()
    }
    
    var filterDescription: String {
        var parts: [String] = []
        
        if selectedPeriod != .all {
            parts.append(selectedPeriod.displayName)
        }
        
        if selectedPlant != "Any" {
            parts.append(selectedPlant)
        }
        
        if !searchText.isEmpty {
            parts.append("Search: \(searchText)")
        }
        
        return parts.isEmpty ? "" : "Showing records: " + parts.joined(separator: " • ")
    }
}
