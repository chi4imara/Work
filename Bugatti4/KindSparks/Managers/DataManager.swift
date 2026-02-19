import Foundation
import SwiftUI
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var people: [Person] = []
    
    private let userDefaults = UserDefaults.standard
    private let peopleKey = "SavedPeople"
    
    private init() {
        loadPeople()
    }
    
    func loadPeople() {
        if let data = userDefaults.data(forKey: peopleKey),
           let decodedPeople = try? JSONDecoder().decode([Person].self, from: data) {
            self.people = decodedPeople
        }
    }
    
    private func savePeople() {
        if let encodedData = try? JSONEncoder().encode(people) {
            userDefaults.set(encodedData, forKey: peopleKey)
        }
    }
    
    func addPerson(_ person: Person) {
        people.append(person)
        savePeople()
    }
    
    func deletePerson(_ person: Person) {
        people.removeAll { $0.id == person.id }
        savePeople()
    }
    
    func addIdea(_ idea: GiftIdea, to personId: UUID) {
        if let index = people.firstIndex(where: { $0.id == personId }) {
            people[index].ideas.append(idea)
            savePeople()
        }
    }
    
    func updateIdea(_ idea: GiftIdea, for personId: UUID) {
        guard let personIndex = people.firstIndex(where: { $0.id == personId }) else { return }
        var person = people[personIndex]
        guard let ideaIndex = person.ideas.firstIndex(where: { $0.id == idea.id }) else { return }
        person.ideas[ideaIndex] = idea
        people[personIndex] = person
        savePeople()
    }
    
    func deleteIdea(_ idea: GiftIdea, from personId: UUID) {
        guard let personIndex = people.firstIndex(where: { $0.id == personId }) else { return }
        var person = people[personIndex]
        person.ideas.removeAll { $0.id == idea.id }
        people[personIndex] = person
        savePeople()
    }
    
    func getAllIdeas() -> [GiftIdea] {
        return people.flatMap { $0.ideas }
    }
    
    func getPersonName(for personId: UUID) -> String {
        return people.first { $0.id == personId }?.name ?? "Unknown"
    }
    
    func getPerson(by id: UUID) -> Person? {
        return people.first { $0.id == id }
    }
    
    func getIdea(ideaId: UUID) -> GiftIdea? {
        for person in people {
            if let idea = person.ideas.first(where: { $0.id == ideaId }) {
                return idea
            }
        }
        return nil
    }
    
    func getPersonId(for ideaId: UUID) -> UUID? {
        return people.first { person in
            person.ideas.contains { $0.id == ideaId }
        }?.id
    }
    
    func getIdeas(for date: Date) -> [GiftIdea] {
        let calendar = Calendar.current
        return getAllIdeas().filter { idea in
            calendar.isDate(idea.createdAt, inSameDayAs: date)
        }
    }
    
    func hasIdeas(on date: Date) -> Bool {
        !getIdeas(for: date).isEmpty
    }
    
    func loadSampleData() {
        people = SampleData.generate()
        savePeople()
    }
}
