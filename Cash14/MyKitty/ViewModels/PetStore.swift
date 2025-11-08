import Foundation
import SwiftUI

class PetStore: ObservableObject {
    @Published var pets: [Pet] = []
    @Published var vaccinations: [Vaccination] = []
    @Published var procedures: [Procedure] = []
    @Published var notes: [Note] = []
    
    @Published var filterSpecies: Set<String> = []
    @Published var filterGender: Pet.Gender?
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .name
    
    enum SortOption: String, CaseIterable {
        case name = "Name A-Z"
        case nameReverse = "Name Z-A"
        case dateAdded = "Date Added"
        case birthDate = "Birth Date"
    }
    
    init() {
        loadData()
    }
    
    func addPet(_ pet: Pet) {
        pets.append(pet)
        saveData()
    }
    
    func updatePet(_ pet: Pet) {
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets[index] = pet
            saveData()
        }
    }
    
    func archivePet(_ pet: Pet) {
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets[index].isArchived = true
            pets[index].archivedDate = Date()
            
            for i in vaccinations.indices {
                if vaccinations[i].petId == pet.id {
                    vaccinations[i].isArchived = true
                    vaccinations[i].archivedDate = Date()
                }
            }
            
            for i in procedures.indices {
                if procedures[i].petId == pet.id {
                    procedures[i].isArchived = true
                    procedures[i].archivedDate = Date()
                }
            }
            
            for i in notes.indices {
                if notes[i].petId == pet.id {
                    notes[i].isArchived = true
                    notes[i].archivedDate = Date()
                }
            }
            
            saveData()
        }
    }
    
    func restorePet(_ pet: Pet) {
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets[index].isArchived = false
            pets[index].archivedDate = nil
            saveData()
        }
    }
    
    func deletePetPermanently(_ pet: Pet) {
        pets.removeAll { $0.id == pet.id }
        vaccinations.removeAll { $0.petId == pet.id }
        procedures.removeAll { $0.petId == pet.id }
        notes.removeAll { $0.petId == pet.id }
        saveData()
    }
    
    func addVaccination(_ vaccination: Vaccination) {
        vaccinations.append(vaccination)
        saveData()
    }
    
    func updateVaccination(_ vaccination: Vaccination) {
        if let index = vaccinations.firstIndex(where: { $0.id == vaccination.id }) {
            vaccinations[index] = vaccination
            saveData()
        }
    }
    
    func archiveVaccination(_ vaccination: Vaccination) {
        if let index = vaccinations.firstIndex(where: { $0.id == vaccination.id }) {
            vaccinations[index].isArchived = true
            vaccinations[index].archivedDate = Date()
            saveData()
        }
    }
    
    func restoreVaccination(_ vaccination: Vaccination) {
        if let index = vaccinations.firstIndex(where: { $0.id == vaccination.id }) {
            vaccinations[index].isArchived = false
            vaccinations[index].archivedDate = nil
            saveData()
        }
    }
    
    func deleteVaccinationPermanently(_ vaccination: Vaccination) {
        vaccinations.removeAll { $0.id == vaccination.id }
        saveData()
    }
    
    func addProcedure(_ procedure: Procedure) {
        procedures.append(procedure)
        saveData()
    }
    
    func updateProcedure(_ procedure: Procedure) {
        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
            procedures[index] = procedure
            saveData()
        }
    }
    
    func archiveProcedure(_ procedure: Procedure) {
        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
            procedures[index].isArchived = true
            procedures[index].archivedDate = Date()
            saveData()
        }
    }
    
    func restoreProcedure(_ procedure: Procedure) {
        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
            procedures[index].isArchived = false
            procedures[index].archivedDate = nil
            saveData()
        }
    }
    
    func deleteProcedurePermanently(_ procedure: Procedure) {
        procedures.removeAll { $0.id == procedure.id }
        saveData()
    }
    
    func addNote(_ note: Note) {
        notes.append(note)
        saveData()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            saveData()
        }
    }
    
    func archiveNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].isArchived = true
            notes[index].archivedDate = Date()
            saveData()
        }
    }
    
    func restoreNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].isArchived = false
            notes[index].archivedDate = nil
            saveData()
        }
    }
    
    func deleteNotePermanently(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveData()
    }
    
    var activePets: [Pet] {
        let filtered = pets.filter { !$0.isArchived }
        return filteredAndSortedPets(filtered)
    }
    
    var archivedPets: [Pet] {
        return pets.filter { $0.isArchived }.sorted { $0.archivedDate ?? Date() > $1.archivedDate ?? Date() }
    }
    
    var activeVaccinations: [Vaccination] {
        return vaccinations.filter { !$0.isArchived }.sorted { $0.date > $1.date }
    }
    
    var archivedVaccinations: [Vaccination] {
        return vaccinations.filter { $0.isArchived }.sorted { $0.archivedDate ?? Date() > $1.archivedDate ?? Date() }
    }
    
    var activeProcedures: [Procedure] {
        return procedures.filter { !$0.isArchived }.sorted { $0.date > $1.date }
    }
    
    var archivedProcedures: [Procedure] {
        return procedures.filter { $0.isArchived }.sorted { $0.archivedDate ?? Date() > $1.archivedDate ?? Date() }
    }
    
    var activeNotes: [Note] {
        return notes.filter { !$0.isArchived }.sorted { $0.date > $1.date }
    }
    
    var archivedNotes: [Note] {
        return notes.filter { $0.isArchived }.sorted { $0.archivedDate ?? Date() > $1.archivedDate ?? Date() }
    }
    
    private func filteredAndSortedPets(_ pets: [Pet]) -> [Pet] {
        var filtered = pets
        
        if !filterSpecies.isEmpty {
            filtered = filtered.filter { filterSpecies.contains($0.species) }
        }
        
        if let gender = filterGender {
            filtered = filtered.filter { $0.gender == gender }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        switch sortOption {
        case .name:
            filtered.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .nameReverse:
            filtered.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case .dateAdded:
            filtered.sort { $0.id.uuidString < $1.id.uuidString }
        case .birthDate:
            filtered.sort { $0.birthDate < $1.birthDate }
        }
        
        return filtered
    }
    
    func clearFilters() {
        filterSpecies.removeAll()
        filterGender = nil
        searchText = ""
    }
    
    func clearArchive() {
        pets.removeAll { $0.isArchived }
        vaccinations.removeAll { $0.isArchived }
        procedures.removeAll { $0.isArchived }
        notes.removeAll { $0.isArchived }
        saveData()
    }
    
    private func saveData() {
        let encoder = JSONEncoder()
        
        if let petsData = try? encoder.encode(pets) {
            UserDefaults.standard.set(petsData, forKey: "pets")
        }
        
        if let vaccinationsData = try? encoder.encode(vaccinations) {
            UserDefaults.standard.set(vaccinationsData, forKey: "vaccinations")
        }
        
        if let proceduresData = try? encoder.encode(procedures) {
            UserDefaults.standard.set(proceduresData, forKey: "procedures")
        }
        
        if let notesData = try? encoder.encode(notes) {
            UserDefaults.standard.set(notesData, forKey: "notes")
        }
    }
    
    private func loadData() {
        let decoder = JSONDecoder()
        
        if let petsData = UserDefaults.standard.data(forKey: "pets"),
           let decodedPets = try? decoder.decode([Pet].self, from: petsData) {
            self.pets = decodedPets
        }
        
        if let vaccinationsData = UserDefaults.standard.data(forKey: "vaccinations"),
           let decodedVaccinations = try? decoder.decode([Vaccination].self, from: vaccinationsData) {
            self.vaccinations = decodedVaccinations
        }
        
        if let proceduresData = UserDefaults.standard.data(forKey: "procedures"),
           let decodedProcedures = try? decoder.decode([Procedure].self, from: proceduresData) {
            self.procedures = decodedProcedures
        }
        
        if let notesData = UserDefaults.standard.data(forKey: "notes"),
           let decodedNotes = try? decoder.decode([Note].self, from: notesData) {
            self.notes = decodedNotes
        }
    }
    
    func getVaccinations(for petId: UUID) -> [Vaccination] {
        return vaccinations.filter { $0.petId == petId && !$0.isArchived }.sorted { $0.date > $1.date }
    }
    
    func getProcedures(for petId: UUID) -> [Procedure] {
        return procedures.filter { $0.petId == petId && !$0.isArchived }.sorted { $0.date > $1.date }
    }
    
    func getNotes(for petId: UUID) -> [Note] {
        return notes.filter { $0.petId == petId && !$0.isArchived }.sorted { $0.date > $1.date }
    }
}
