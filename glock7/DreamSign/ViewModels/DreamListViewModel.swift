import Foundation
import Combine

class DreamListViewModel: ObservableObject {
    @Published var filteredDreams: [Dream] = []
    @Published var isFilterActive = false
    @Published var sortOption: SortOption = .dateNewest
    
    @Published var selectedStatuses: Set<DreamStatus> = Set(DreamStatus.allCases)
    @Published var selectedTags: Set<String> = []
    @Published var dateFilter: DateFilter = .all
    @Published var customStartDate: Date = Date()
    @Published var customEndDate: Date = Date()
    @Published var deadlineFilter: Date?
    
    private var dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption: String, CaseIterable {
        case dateNewest = "Date (Newest)"
        case dateOldest = "Date (Oldest)"
        case deadlineNearest = "Deadline (Nearest)"
        case statusWaiting = "Status (Waiting First)"
        
        var displayName: String { rawValue }
    }
    
    enum DateFilter: String, CaseIterable {
        case all = "All Time"
        case today = "Today"
        case week = "This Week"
        case month = "This Month"
        case custom = "Custom Range"
        
        var displayName: String { rawValue }
    }
    
    init() {
        setupBindings()
        applyFiltersAndSort()
    }
    
    private func setupBindings() {
        dataManager.$dreams
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.applyFiltersAndSort()
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest4(
            $selectedStatuses,
            $selectedTags,
            $dateFilter,
            $sortOption
        )
        .sink { [weak self] _, _, _, _ in
            self?.applyFiltersAndSort()
        }
        .store(in: &cancellables)
        
        Publishers.CombineLatest3(
            $customStartDate,
            $customEndDate,
            $deadlineFilter
        )
        .sink { [weak self] _, _, _ in
            self?.applyFiltersAndSort()
        }
        .store(in: &cancellables)
    }
    
    func applyFiltersAndSort() {
        print("applyFiltersAndSort called")
        var dreams = dataManager.dreams
        print("Initial dreams count: \(dreams.count)")
        
        dreams = dreams.filter { selectedStatuses.contains($0.status) }
        print("After status filter: \(dreams.count)")
        
        if !selectedTags.isEmpty {
            dreams = dreams.filter { dream in
                !Set(dream.tags).isDisjoint(with: selectedTags)
            }
            print("After tags filter: \(dreams.count)")
        }
        
        dreams = applyDateFilter(to: dreams)
        print("After date filter: \(dreams.count)")
        
        if let deadline = deadlineFilter {
            dreams = dreams.filter { $0.checkDeadline <= deadline }
            print("After deadline filter: \(dreams.count)")
        }
        
        dreams = applySorting(to: dreams)
        print("After sorting: \(dreams.count)")
        
        DispatchQueue.main.async { [weak self] in
            self?.filteredDreams = dreams
            self?.updateFilterActiveStatus()
            print("UI updated with \(dreams.count) dreams")
        }
    }
    
    private func applyDateFilter(to dreams: [Dream]) -> [Dream] {
        let calendar = Calendar.current
        let now = Date()
        
        switch dateFilter {
        case .all:
            return dreams
        case .today:
            return dreams.filter { calendar.isDate($0.dreamDate, inSameDayAs: now) }
        case .week:
            let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            return dreams.filter { $0.dreamDate >= weekStart }
        case .month:
            let monthStart = calendar.dateInterval(of: .month, for: now)?.start ?? now
            return dreams.filter { $0.dreamDate >= monthStart }
        case .custom:
            return dreams.filter { 
                $0.dreamDate >= customStartDate && $0.dreamDate <= customEndDate 
            }
        }
    }
    
    private func applySorting(to dreams: [Dream]) -> [Dream] {
        print("Applying sort: \(sortOption.rawValue)")
        let sortedDreams: [Dream]
        
        switch sortOption {
        case .dateNewest:
            sortedDreams = dreams.sorted { $0.dreamDate > $1.dreamDate }
        case .dateOldest:
            sortedDreams = dreams.sorted { $0.dreamDate < $1.dreamDate }
        case .deadlineNearest:
            sortedDreams = dreams.sorted { $0.checkDeadline < $1.checkDeadline }
        case .statusWaiting:
            sortedDreams = dreams.sorted { dream1, dream2 in
                if dream1.status == .waiting && dream2.status != .waiting {
                    return true
                } else if dream1.status != .waiting && dream2.status == .waiting {
                    return false
                } else {
                    return dream1.dreamDate > dream2.dreamDate
                }
            }
        }
        
        print("Sorted \(dreams.count) dreams, result: \(sortedDreams.count)")
        return sortedDreams
    }
    
    private func updateFilterActiveStatus() {
        isFilterActive = selectedStatuses.count != DreamStatus.allCases.count ||
                        !selectedTags.isEmpty ||
                        dateFilter != .all ||
                        deadlineFilter != nil
    }
    
    func resetFilters() {
        selectedStatuses = Set(DreamStatus.allCases)
        selectedTags = []
        dateFilter = .all
        deadlineFilter = nil
        sortOption = .dateNewest
    }
    
    func deleteDream(_ dream: Dream) {
        dataManager.deleteDream(dream)
    }
    
    func updateDreamStatus(_ dream: Dream, status: DreamStatus, outcomeDate: Date?, comment: String?) {
        var updatedDream = dream
        updatedDream.updateStatus(status, outcomeDate: outcomeDate, comment: comment)
        dataManager.updateDream(updatedDream)
    }
}
