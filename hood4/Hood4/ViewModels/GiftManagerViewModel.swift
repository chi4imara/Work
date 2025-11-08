import Foundation
import Combine

class GiftManagerViewModel: ObservableObject {
    @Published var people: [Person] = []
    @Published var giftIdeas: [GiftIdea] = []
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let peopleKey = "SavedPeople"
    private let giftIdeasKey = "SavedGiftIdeas"
    
    init() {
        loadData()
    }
    
    func loadData() {
        loadPeople()
        loadGiftIdeas()
    }
    
    func saveData() {
        savePeople()
        saveGiftIdeas()
        objectWillChange.send()
    }
    
    private func loadPeople() {
        if let data = userDefaults.data(forKey: peopleKey),
           let decodedPeople = try? JSONDecoder().decode([Person].self, from: data) {
            people = decodedPeople
        }
    }
    
    private func savePeople() {
        if let encoded = try? JSONEncoder().encode(people) {
            userDefaults.set(encoded, forKey: peopleKey)
        }
    }
    
    private func loadGiftIdeas() {
        if let data = userDefaults.data(forKey: giftIdeasKey),
           let decodedIdeas = try? JSONDecoder().decode([GiftIdea].self, from: data) {
            giftIdeas = decodedIdeas
        }
    }
    
    private func saveGiftIdeas() {
        if let encoded = try? JSONEncoder().encode(giftIdeas) {
            userDefaults.set(encoded, forKey: giftIdeasKey)
        }
    }
    
    func addPerson(name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let person = Person(name: trimmedName)
        people.append(person)
        saveData()
    }
    
    func deletePerson(_ person: Person) {
        giftIdeas.removeAll { $0.personId == person.id }
        
        people.removeAll { $0.id == person.id }
        
        saveData()
    }
    
    func updatePerson(_ person: Person, newName: String) {
        let trimmedName = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        if let index = people.firstIndex(where: { $0.id == person.id }) {
            people[index].name = trimmedName
            saveData()
        }
    }
    
    func getPerson(by id: UUID) -> Person? {
        return people.first { $0.id == id }
    }
    
    func addGiftIdea(_ giftIdea: GiftIdea) {
        giftIdeas.append(giftIdea)
        saveData()
    }
    
    func updateGiftIdea(_ giftIdea: GiftIdea) {
        if let index = giftIdeas.firstIndex(where: { $0.id == giftIdea.id }) {
            giftIdeas[index] = giftIdea
            saveData()
        }
    }
    
    func deleteGiftIdea(_ giftIdea: GiftIdea) {
        giftIdeas.removeAll { $0.id == giftIdea.id }
        saveData()
    }
    
    func getGiftIdeas(for personId: UUID) -> [GiftIdea] {
        return giftIdeas.filter { $0.personId == personId }
    }
    
    func changeGiftIdeaStatus(_ giftIdea: GiftIdea) {
        if let index = giftIdeas.firstIndex(where: { $0.id == giftIdea.id }) {
            let currentStatus = giftIdeas[index].status
            let nextStatus: GiftStatus
            
            switch currentStatus {
            case .idea:
                nextStatus = .purchased
            case .purchased:
                nextStatus = .gifted
            case .gifted:
                nextStatus = .idea
            }
            
            giftIdeas[index].status = nextStatus
            saveData()
        }
    }
    
    func updateGiftIdeaStatus(_ giftIdea: GiftIdea, to status: GiftStatus) {
        if let index = giftIdeas.firstIndex(where: { $0.id == giftIdea.id }) {
            giftIdeas[index].status = status
            saveData()
        }
    }
    
    func getPersonStats(_ person: Person) -> (ideas: Int, purchased: Int, gifted: Int, nextEventDate: Date?) {
        let personIdeas = getGiftIdeas(for: person.id)
        
        let ideas = personIdeas.filter { $0.status == .idea }.count
        let purchased = personIdeas.filter { $0.status == .purchased }.count
        let gifted = personIdeas.filter { $0.status == .gifted }.count
        
        let nextEventDate = personIdeas
            .compactMap { $0.eventDate }
            .filter { $0 >= Date() }
            .sorted()
            .first
        
        return (ideas, purchased, gifted, nextEventDate)
    }
    
    func getTotalStats(for personId: UUID? = nil) -> (ideas: Int, purchased: Int, gifted: Int) {
        let filteredIdeas = personId != nil ? getGiftIdeas(for: personId!) : giftIdeas
        
        let ideas = filteredIdeas.filter { $0.status == .idea }.count
        let purchased = filteredIdeas.filter { $0.status == .purchased }.count
        let gifted = filteredIdeas.filter { $0.status == .gifted }.count
        
        return (ideas, purchased, gifted)
    }
    
    func getBudgetStats(for personId: UUID? = nil) -> (total: Double, average: Double, max: Double, min: Double, count: Int) {
        let filteredIdeas = personId != nil ? getGiftIdeas(for: personId!) : giftIdeas
        let budgetIdeas = filteredIdeas.compactMap { $0.budget }
        
        guard !budgetIdeas.isEmpty else {
            return (0, 0, 0, 0, 0)
        }
        
        let total = budgetIdeas.reduce(0, +)
        let average = total / Double(budgetIdeas.count)
        let max = budgetIdeas.max() ?? 0
        let min = budgetIdeas.min() ?? 0
        
        return (total, average, max, min, budgetIdeas.count)
    }
    
    func getEventStats(for personId: UUID? = nil) -> [EventType: Int] {
        let filteredIdeas = personId != nil ? getGiftIdeas(for: personId!) : giftIdeas
        var stats: [EventType: Int] = [:]
        
        for eventType in EventType.allCases {
            stats[eventType] = filteredIdeas.filter { $0.eventType == eventType }.count
        }
        
        return stats
    }
}
