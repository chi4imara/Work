import Foundation
import SwiftUI
import Combine

class ReferenceViewModel: ObservableObject {
    static let shared = ReferenceViewModel()
    
    @Published var references: [MedicineReference] = []
    @Published var searchText = ""
    @Published var isLoading = false
    
    private let dataManager = DataManager.shared
    
    private init() {
        loadReferences()
    }
    
    func loadReferences() {
        references = dataManager.loadReferences()
    }
    
    func addReference(_ reference: MedicineReference) {
        references.append(reference)
        saveReferences()
    }
    
    func updateReference(_ reference: MedicineReference) {
        if let index = references.firstIndex(where: { $0.id == reference.id }) {
            var updatedReference = reference
            updatedReference.lastModified = Date()
            references[index] = updatedReference
            saveReferences()
        }
    }
    
    func deleteReference(_ reference: MedicineReference) {
        references.removeAll { $0.id == reference.id }
        saveReferences()
    }
    
    var filteredReferences: [MedicineReference] {
        if searchText.isEmpty {
            return references.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        } else {
            return references.filter { reference in
                reference.name.localizedCaseInsensitiveContains(searchText) ||
                reference.purpose.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }
    
    private func saveReferences() {
        dataManager.saveReferences(references)
    }
}
