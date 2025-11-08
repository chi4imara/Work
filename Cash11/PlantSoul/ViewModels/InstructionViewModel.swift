import Foundation
import SwiftUI

class InstructionViewModel: ObservableObject {
    @Published var instructions: [Instruction] = []
    @Published var searchText: String = ""
    @Published var selectedTypes: Set<TaskType> = Set(TaskType.allCases)
    @Published var showingInstructionDetail = false
    
    private let dataManager = DataManager.shared
    
    var filteredInstructions: [Instruction] {
        var filtered = instructions.filter { !$0.isArchived }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { instruction in
                instruction.title.localizedCaseInsensitiveContains(searchText) ||
                instruction.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if !selectedTypes.isEmpty && selectedTypes.count < TaskType.allCases.count {
            filtered = filtered.filter { selectedTypes.contains($0.type) }
        }
        
        return filtered.sorted { $0.title < $1.title }
    }
    
    var favoriteInstructions: [Instruction] {
        return instructions.filter { $0.isFavorite && !$0.isArchived }
    }
    
    var archivedInstructions: [Instruction] {
        return instructions.filter { $0.isArchived }
    }
    
    init() {
        loadInstructions()
    }
    
    func addInstruction(_ instruction: Instruction) {
        instructions.append(instruction)
        saveInstructions()
    }
    
    func updateInstruction(_ instruction: Instruction) {
        if let index = instructions.firstIndex(where: { $0.id == instruction.id }) {
            instructions[index] = instruction
            saveInstructions()
        }
    }
    
    func toggleFavorite(_ instruction: Instruction) {
        if let index = instructions.firstIndex(where: { $0.id == instruction.id }) {
            instructions[index].isFavorite.toggle()
            saveInstructions()
        }
    }
    
    func archiveInstruction(_ instruction: Instruction) {
        if let index = instructions.firstIndex(where: { $0.id == instruction.id }) {
            instructions[index].isArchived = true
            saveInstructions()
        }
    }
    
    func restoreInstruction(_ instruction: Instruction) {
        if let index = instructions.firstIndex(where: { $0.id == instruction.id }) {
            instructions[index].isArchived = false
            saveInstructions()
        }
    }
    
    func deleteInstruction(_ instruction: Instruction) {
        instructions.removeAll { $0.id == instruction.id }
        saveInstructions()
    }
    
    func permanentDeleteInstruction(_ instruction: Instruction) {
        instructions.removeAll { $0.id == instruction.id }
        saveInstructions()
    }
    
    func resetFilters() {
        searchText = ""
        selectedTypes = Set(TaskType.allCases)
    }
    
    private func saveInstructions() {
        dataManager.saveInstructions(instructions)
    }
    
    private func loadInstructions() {
        let savedInstructions = dataManager.loadInstructions()
        
        if savedInstructions.isEmpty {
            loadDefaultInstructions()
        } else {
            instructions = savedInstructions
        }
    }
    
    private func loadDefaultInstructions() {
        instructions = Instruction.defaultInstructions
        saveInstructions()
    }
}

