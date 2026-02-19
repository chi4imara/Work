import Foundation
import Combine

class TermsDataManager: ObservableObject {
    @Published var terms: [Term] = []
    
    private let userDefaults = UserDefaults.standard
    private let termsKey = "SavedTerms"
    
    init() {
        loadTerms()
    }
    
    func addTerm(_ term: Term) {
        terms.append(term)
        saveTerms()
    }
    
    func updateTerm(_ term: Term) {
        if let index = terms.firstIndex(where: { $0.id == term.id }) {
            terms[index] = term
            saveTerms()
        }
    }
    
    func deleteTerm(_ term: Term) {
        terms.removeAll { $0.id == term.id }
        saveTerms()
    }
    
    func getTerm(by id: UUID) -> Term? {
        return terms.first { $0.id == id }
    }
    
    func loadSampleData() {
        let calendar = Calendar.current
        let now = Date()
        
        let sampleTerms: [Term] = [
            Term(
                name: "Algorithm",
                explanation: "A step-by-step procedure or formula for solving a problem. In computing, algorithms are used to process data and perform calculations.",
                dateCreated: calendar.date(byAdding: .day, value: -6, to: now) ?? now,
                dateModified: calendar.date(byAdding: .day, value: -6, to: now) ?? now
            ),
            Term(
                name: "API",
                explanation: "Application Programming Interface. A set of rules and tools that allows different software applications to communicate with each other.",
                dateCreated: calendar.date(byAdding: .day, value: -5, to: now) ?? now,
                dateModified: calendar.date(byAdding: .day, value: -4, to: now) ?? now
            ),
            Term(
                name: "Cache",
                explanation: "A hardware or software component that stores data temporarily so that future requests for that data can be served faster.",
                dateCreated: calendar.date(byAdding: .day, value: -4, to: now) ?? now,
                dateModified: calendar.date(byAdding: .day, value: -4, to: now) ?? now
            ),
            Term(
                name: "Debugging",
                explanation: "The process of finding and resolving defects or problems in software that prevent it from working correctly.",
                dateCreated: calendar.date(byAdding: .day, value: -3, to: now) ?? now,
                dateModified: calendar.date(byAdding: .day, value: -3, to: now) ?? now
            ),
            Term(
                name: "Framework",
                explanation: "A platform or structure that provides a foundation for developing software applications. It includes reusable code and common functionality.",
                dateCreated: calendar.date(byAdding: .day, value: -2, to: now) ?? now,
                dateModified: calendar.date(byAdding: .day, value: -1, to: now) ?? now
            ),
            Term(
                name: "Repository",
                explanation: "A central location where data is stored and managed. In version control, a repo holds project files and revision history.",
                dateCreated: calendar.date(byAdding: .day, value: -1, to: now) ?? now,
                dateModified: calendar.date(byAdding: .day, value: -1, to: now) ?? now
            ),
            Term(
                name: "Syntax",
                explanation: "The set of rules that defines the combinations of symbols that are considered correctly structured in a programming language.",
                dateCreated: now,
                dateModified: now
            ),
            Term(
                name: "Variable",
                explanation: "A named storage location that holds a value. The value can change during program execution.",
                dateCreated: now,
                dateModified: now
            ),
            Term(
                name: "Metadata",
                explanation: "Data that describes other data. It provides information about the content, structure, or context of a resource.",
                dateCreated: calendar.date(byAdding: .day, value: -2, to: now) ?? now,
                dateModified: calendar.date(byAdding: .day, value: -2, to: now) ?? now
            )
        ]
        
        for term in sampleTerms {
            terms.append(term)
        }
        saveTerms()
    }
    
    private func saveTerms() {
        if let encoded = try? JSONEncoder().encode(terms) {
            userDefaults.set(encoded, forKey: termsKey)
        }
    }
    
    private func loadTerms() {
        if let data = userDefaults.data(forKey: termsKey),
           let decoded = try? JSONDecoder().decode([Term].self, from: data) {
            terms = decoded
        }
    }
}
