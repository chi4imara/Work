import Foundation
import SwiftUI

class QuoteStore: ObservableObject {
    @Published var quotes: [Quote] = []
    @Published var categories: [Category] = []
    
    @Published var selectedType: QuoteType?
    @Published var selectedCategories: Set<String> = []
    @Published var selectedPeriod: FilterPeriod = .all
    @Published var customStartDate: Date = Date()
    @Published var customEndDate: Date = Date()
    @Published var sortOption: SortOption = .dateCreated
    @Published var searchText: String = ""
    
    private let quotesKey = "SavedQuotes"
    private let categoriesKey = "SavedCategories"
    
    init() {
        loadData()
    }
    
    private func saveData() {
        if let quotesData = try? JSONEncoder().encode(quotes) {
            UserDefaults.standard.set(quotesData, forKey: quotesKey)
        }
        
        if let categoriesData = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(categoriesData, forKey: categoriesKey)
        }
    }
    
    private func loadData() {
        if let quotesData = UserDefaults.standard.data(forKey: quotesKey),
           let decodedQuotes = try? JSONDecoder().decode([Quote].self, from: quotesData) {
            quotes = decodedQuotes
        }
        
        if let categoriesData = UserDefaults.standard.data(forKey: categoriesKey),
           let decodedCategories = try? JSONDecoder().decode([Category].self, from: categoriesData) {
            categories = decodedCategories
        }
    }
    
    func addQuote(_ quote: Quote) {
        quotes.append(quote)
        saveData()
        objectWillChange.send()
    }
    
    func updateQuote(_ quote: Quote) {
        if let index = quotes.firstIndex(where: { $0.id == quote.id }) {
            quotes[index] = quote
            saveData()
            objectWillChange.send()
        }
    }
    
    func deleteQuote(_ quote: Quote) {
        quotes.removeAll { $0.id == quote.id }
        saveData()
        objectWillChange.send()
    }
    
    func archiveQuote(_ quote: Quote) {
        if let index = quotes.firstIndex(where: { $0.id == quote.id }) {
            quotes[index].isArchived = true
            quotes[index].dateArchived = Date()
            saveData()
            objectWillChange.send()
        }
    }
    
    func unarchiveQuote(_ quote: Quote) {
        if let index = quotes.firstIndex(where: { $0.id == quote.id }) {
            quotes[index].isArchived = false
            quotes[index].dateArchived = nil
            saveData()
            objectWillChange.send()
        }
    }
    
    func archiveQuotes(_ quotesToArchive: [Quote]) {
        for quote in quotesToArchive {
            archiveQuote(quote)
        }
    }
    
    func deleteQuotes(_ quotesToDelete: [Quote]) {
        for quote in quotesToDelete {
            deleteQuote(quote)
        }
    }
    
    func unarchiveQuotes(_ quotesToUnarchive: [Quote]) {
        for quote in quotesToUnarchive {
            unarchiveQuote(quote)
        }
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
        saveData()
        objectWillChange.send()
    }
    
    func updateCategory(_ category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            let oldName = categories[index].name
            categories[index] = category
            
            for i in quotes.indices {
                if quotes[i].category == oldName {
                    quotes[i].category = category.name
                }
            }
            saveData()
            objectWillChange.send()
        }
    }
    
    func deleteCategory(_ category: Category, moveToCategory: String? = nil) {
        categories.removeAll { $0.id == category.id }
        
        for i in quotes.indices {
            if quotes[i].category == category.name {
                quotes[i].category = moveToCategory
            }
        }
        saveData()
        objectWillChange.send()
    }
    
    func categoryExists(_ name: String) -> Bool {
        return categories.contains { $0.name.lowercased() == name.lowercased() }
    }
    
    func quotesCount(for category: Category) -> Int {
        return quotes.filter { $0.category == category.name }.count
    }
    
    var activeQuotes: [Quote] {
        return filteredAndSortedQuotes(archived: false)
    }
    
    var archivedQuotes: [Quote] {
        return filteredAndSortedQuotes(archived: true)
    }
    
    func quotesForCategory(_ categoryName: String) -> [Quote] {
        return quotes.filter { $0.category == categoryName && !$0.isArchived }
            .sorted { sortQuotes($0, $1) }
    }
    
    private func filteredAndSortedQuotes(archived: Bool) -> [Quote] {
        var filtered = quotes.filter { $0.isArchived == archived }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { quote in
                quote.title.localizedCaseInsensitiveContains(searchText) ||
                quote.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let selectedType = selectedType {
            filtered = filtered.filter { $0.type == selectedType }
        }
        
        if !selectedCategories.isEmpty {
            filtered = filtered.filter { quote in
                guard let category = quote.category else { return false }
                return selectedCategories.contains(category)
            }
        }
        
        filtered = applyPeriodFilter(to: filtered)
        
        return filtered.sorted { sortQuotes($0, $1) }
    }
    
    private func applyPeriodFilter(to quotes: [Quote]) -> [Quote] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .today:
            return quotes.filter { calendar.isDate($0.dateCreated, inSameDayAs: now) }
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return quotes.filter { $0.dateCreated >= weekAgo }
        case .month:
            let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
            return quotes.filter { $0.dateCreated >= startOfMonth }
        case .custom:
            return quotes.filter { $0.dateCreated >= customStartDate && $0.dateCreated <= customEndDate }
        case .all:
            return quotes
        }
    }
    
    private func sortQuotes(_ lhs: Quote, _ rhs: Quote) -> Bool {
        switch sortOption {
        case .dateCreated:
            return lhs.dateCreated > rhs.dateCreated
        case .dateArchived:
            if let lhsArchived = lhs.dateArchived, let rhsArchived = rhs.dateArchived {
                return lhsArchived > rhsArchived
            }
            return lhs.dateCreated > rhs.dateCreated
        case .alphabetical:
            return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
        case .category:
            let lhsCategory = lhs.category ?? ""
            let rhsCategory = rhs.category ?? ""
            if lhsCategory == rhsCategory {
                return lhs.dateCreated > rhs.dateCreated
            }
            return lhsCategory.localizedCaseInsensitiveCompare(rhsCategory) == .orderedAscending
        }
    }
    
    func clearFilters() {
        selectedType = nil
        selectedCategories.removeAll()
        selectedPeriod = .all
        searchText = ""
    }
    
    func hasActiveFilters() -> Bool {
        return selectedType != nil || !selectedCategories.isEmpty || selectedPeriod != .all || !searchText.isEmpty
    }
    
    var totalQuotesCount: Int {
        return quotes.count
    }
    
    var activeQuotesCount: Int {
        return quotes.filter { !$0.isArchived }.count
    }
    
    var archivedQuotesCount: Int {
        return quotes.filter { $0.isArchived }.count
    }
    
    var quotesCount: Int {
        return quotes.filter { $0.type == .quote }.count
    }
    
    var thoughtsCount: Int {
        return quotes.filter { $0.type == .thought }.count
    }
    
    var categoriesCount: Int {
        return categories.count
    }
    
    var quotesWithCategoryCount: Int {
        return quotes.filter { $0.category != nil }.count
    }
    
    var quotesWithoutCategoryCount: Int {
        return quotes.filter { $0.category == nil }.count
    }
    
    var averageQuotesPerCategory: Double {
        guard categoriesCount > 0 else { return 0 }
        return Double(quotesWithCategoryCount) / Double(categoriesCount)
    }
    
    func quotesCreatedInPeriod(_ period: FilterPeriod) -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        switch period {
        case .today:
            return quotes.filter { calendar.isDate($0.dateCreated, inSameDayAs: now) }.count
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return quotes.filter { $0.dateCreated >= weekAgo }.count
        case .month:
            let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
            return quotes.filter { $0.dateCreated >= startOfMonth }.count
        case .all:
            return quotes.count
        case .custom:
            return quotes.filter { $0.dateCreated >= customStartDate && $0.dateCreated <= customEndDate }.count
        }
    }
    
    func quotesArchivedInPeriod(_ period: FilterPeriod) -> Int {
        let calendar = Calendar.current
        let now = Date()
        
        switch period {
        case .today:
            return quotes.filter { 
                guard let dateArchived = $0.dateArchived else { return false }
                return calendar.isDate(dateArchived, inSameDayAs: now)
            }.count
        case .week:
            let weekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
            return quotes.filter { 
                guard let dateArchived = $0.dateArchived else { return false }
                return dateArchived >= weekAgo
            }.count
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return quotes.filter { 
                guard let dateArchived = $0.dateArchived else { return false }
                return dateArchived >= monthAgo
            }.count
        case .all:
            return archivedQuotesCount
        case .custom:
            return quotes.filter { 
                guard let dateArchived = $0.dateArchived else { return false }
                return dateArchived >= customStartDate && dateArchived <= customEndDate
            }.count
        }
    }
    
    var mostPopularCategory: String? {
        guard !categories.isEmpty else { return nil }
        
        let categoryCounts = categories.map { category in
            (category.name, quotesCount(for: category))
        }
        
        return categoryCounts.max(by: { $0.1 < $1.1 })?.0
    }
    
    var oldestQuote: Quote? {
        return quotes.min(by: { $0.dateCreated < $1.dateCreated })
    }
    
    var newestQuote: Quote? {
        return quotes.max(by: { $0.dateCreated < $1.dateCreated })
    }
    
    var daysSinceFirstQuote: Int {
        guard let oldestQuote = oldestQuote else { return 0 }
        return Calendar.current.dateComponents([.day], from: oldestQuote.dateCreated, to: Date()).day ?? 0
    }
    
    var averageQuotesPerDay: Double {
        let days = max(daysSinceFirstQuote, 1)
        return Double(totalQuotesCount) / Double(days)
    }
    
    func categoryDistribution() -> [(String, Int)] {
        let categorizedQuotes = categories.map { category in
            (category.name, quotesCount(for: category))
        }
        
        let uncategorizedCount = quotesWithoutCategoryCount
        var distribution = categorizedQuotes
        
        if uncategorizedCount > 0 {
            distribution.append(("Uncategorized", uncategorizedCount))
        }
        
        return distribution.sorted(by: { $0.1 > $1.1 })
    }
    
    func monthlyQuoteStats() -> [(String, Int)] {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let groupedByMonth = Dictionary(grouping: quotes) { quote in
            calendar.dateInterval(of: .month, for: quote.dateCreated)?.start ?? quote.dateCreated
        }
        
        return groupedByMonth.map { (date, quotes) in
            (dateFormatter.string(from: date), quotes.count)
        }.sorted(by: { $0.0 < $1.0 })
    }
}
