import Foundation
import SwiftUI
import Combine

class TestsViewModel: ObservableObject {
    @Published var tests: [TestModel] = []
    @Published var searchText = ""
    @Published var selectedCategory: Category?
    @Published var selectedSkinType: SkinType?
    @Published var selectedStatus: TestStatus?
    @Published var sortOption: SortOption = .date
    @Published var isAscending = false
    
    private let userDefaults = UserDefaults.standard
    private let testsKey = "SavedTests"
    
    init() {
        loadTests()
    }
    
    var filteredTests: [TestModel] {
        var filtered = tests
        
        if !searchText.isEmpty {
            filtered = filtered.filter { test in
                test.productName.localizedCaseInsensitiveContains(searchText) ||
                test.brand.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        if let selectedSkinType = selectedSkinType {
            filtered = filtered.filter { $0.skinType == selectedSkinType }
        }
        
        if let selectedStatus = selectedStatus {
            filtered = filtered.filter { $0.status == selectedStatus }
        }
        
        filtered = sortTests(filtered)
        
        return filtered
    }
    
    var testsByCategory: [Category: [TestModel]] {
        Dictionary(grouping: tests) { $0.category }
    }
    
    var categoryStats: [Category: Int] {
        testsByCategory.mapValues { $0.count }
    }
    
    func addTest(_ test: TestModel) {
        tests.append(test)
        saveTests()
    }
    
    func updateTest(_ test: TestModel) {
        if let index = tests.firstIndex(where: { $0.id == test.id }) {
            tests[index] = test
            saveTests()
        }
    }
    
    func deleteTest(_ test: TestModel) {
        tests.removeAll { $0.id == test.id }
        saveTests()
    }
    
    func clearFilters() {
        selectedCategory = nil
        selectedSkinType = nil
        selectedStatus = nil
        searchText = ""
    }
    
    private func sortTests(_ tests: [TestModel]) -> [TestModel] {
        switch sortOption {
        case .date:
            return isAscending ? tests.sorted { $0.testDate < $1.testDate } : tests.sorted { $0.testDate > $1.testDate }
        case .brand:
            return isAscending ? tests.sorted { $0.brand < $1.brand } : tests.sorted { $0.brand > $1.brand }
        case .category:
            return isAscending ? tests.sorted { $0.category.displayName < $1.category.displayName } : tests.sorted { $0.category.displayName > $1.category.displayName }
        case .rating:
            return isAscending ? tests.sorted { $0.rating < $1.rating } : tests.sorted { $0.rating > $1.rating }
        }
    }
    
    private func saveTests() {
        if let encoded = try? JSONEncoder().encode(tests) {
            userDefaults.set(encoded, forKey: testsKey)
        }
    }
    
    private func loadTests() {
        if let data = userDefaults.data(forKey: testsKey),
           let decoded = try? JSONDecoder().decode([TestModel].self, from: data) {
            tests = decoded
        }
    }
}
