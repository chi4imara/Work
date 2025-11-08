import Foundation
import SwiftUI

class RepairInstructionViewModel: ObservableObject {
    @Published var instructions: [RepairInstruction] = []
    @Published var filteredInstructions: [RepairInstruction] = []
    @Published var selectedCategories: Set<RepairCategory> = Set(RepairCategory.allCases)
    @Published var showFavoritesOnly: Bool = false
    @Published var searchText: String = ""
    
    init() {
        loadSampleData()
        updateFilteredInstructions()
    }
    
    private func loadSampleData() {
        instructions = [
            RepairInstruction(
                title: "Fix Leaking Faucet",
                category: .plumbing,
                shortDescription: "How to repair a dripping tap in your kitchen or bathroom",
                imageName: "faucet",
                tools: ["Adjustable wrench", "Screwdriver", "Plumber's tape", "New washers"],
                steps: [
                    RepairStep(title: "Turn off water supply", description: "Locate the shut-off valve under the sink and turn it clockwise to stop water flow."),
                    RepairStep(title: "Remove faucet handle", description: "Use a screwdriver to remove the screw holding the handle in place."),
                    RepairStep(title: "Replace washer", description: "Remove the old washer and replace it with a new one of the same size."),
                    RepairStep(title: "Reassemble faucet", description: "Put all parts back together in reverse order and turn water supply back on.")
                ],
                tips: ["Always turn off water supply before starting", "Keep track of small parts", "Test for leaks after reassembly"]
            ),
            RepairInstruction(
                title: "Replace Light Bulb",
                category: .electrical,
                shortDescription: "Safe way to change a burned-out light bulb",
                imageName: "lightbulb",
                tools: ["New light bulb", "Step ladder", "Gloves"],
                steps: [
                    RepairStep(title: "Turn off power", description: "Switch off the light at the wall switch and wait for bulb to cool down."),
                    RepairStep(title: "Remove old bulb", description: "Carefully unscrew the old bulb by turning counterclockwise."),
                    RepairStep(title: "Install new bulb", description: "Screw in the new bulb by turning clockwise until snug."),
                    RepairStep(title: "Test the light", description: "Turn the power back on and test the new bulb.")
                ],
                tips: ["Never touch bulb with wet hands", "Use appropriate wattage", "Let hot bulbs cool before handling"]
            ),
            RepairInstruction(
                title: "Hang Wall Shelf",
                category: .furniture,
                shortDescription: "How to properly mount a shelf on the wall",
                imageName: "shelf",
                tools: ["Drill", "Level", "Screws", "Wall anchors", "Pencil", "Measuring tape"],
                steps: [
                    RepairStep(title: "Mark position", description: "Use a pencil and level to mark where the shelf brackets will go."),
                    RepairStep(title: "Drill pilot holes", description: "Drill small pilot holes at the marked positions."),
                    RepairStep(title: "Install anchors", description: "Insert wall anchors into the holes if not drilling into studs."),
                    RepairStep(title: "Mount brackets", description: "Attach the shelf brackets using screws."),
                    RepairStep(title: "Install shelf", description: "Place the shelf on the mounted brackets and secure if needed.")
                ],
                tips: ["Use a stud finder for heavy shelves", "Double-check level before drilling", "Choose appropriate anchors for wall type"]
            ),
            RepairInstruction(
                title: "Unclog Drain",
                category: .plumbing,
                shortDescription: "Clear blocked sink or shower drain",
                imageName: "drain",
                tools: ["Plunger", "Drain snake", "Rubber gloves", "Bucket"],
                steps: [
                    RepairStep(title: "Remove visible debris", description: "Pull out any hair or debris you can see at the drain opening."),
                    RepairStep(title: "Try plunging", description: "Use a plunger to create suction and dislodge the blockage."),
                    RepairStep(title: "Use drain snake", description: "If plunging doesn't work, use a drain snake to break up the clog."),
                    RepairStep(title: "Flush with hot water", description: "Run hot water to clear any remaining debris.")
                ],
                tips: ["Wear rubber gloves", "Don't use chemical cleaners with a plunger", "Regular maintenance prevents clogs"]
            ),
            RepairInstruction(
                title: "Fix Squeaky Door",
                category: .furniture,
                shortDescription: "Eliminate annoying door squeaks",
                imageName: "door",
                tools: ["WD-40 or oil", "Cloth", "Screwdriver"],
                steps: [
                    RepairStep(title: "Locate squeak source", description: "Open and close the door to identify which hinge is squeaking."),
                    RepairStep(title: "Clean hinges", description: "Wipe down the hinges with a clean cloth to remove dirt and debris."),
                    RepairStep(title: "Apply lubricant", description: "Spray WD-40 or apply a few drops of oil to the hinge pins."),
                    RepairStep(title: "Work the door", description: "Open and close the door several times to distribute the lubricant.")
                ],
                tips: ["A little lubricant goes a long way", "Clean hinges regularly", "Use household oil if WD-40 isn't available"]
            ),
            RepairInstruction(
                title: "Paint Touch-ups",
                category: .decor,
                shortDescription: "Fix small paint chips and scratches on walls",
                imageName: "paint",
                tools: ["Matching paint", "Small brush", "Sandpaper", "Primer", "Drop cloth"],
                steps: [
                    RepairStep(title: "Prepare area", description: "Clean the damaged area and lightly sand if needed."),
                    RepairStep(title: "Apply primer", description: "If the damage is down to bare wall, apply a small amount of primer."),
                    RepairStep(title: "Paint the spot", description: "Use a small brush to carefully apply matching paint."),
                    RepairStep(title: "Blend edges", description: "Feather the edges to blend with surrounding paint.")
                ],
                tips: ["Test paint color in inconspicuous area first", "Use thin coats", "Keep some original paint for future touch-ups"]
            )
        ]
    }
    
    func updateFilteredInstructions() {
        var filtered = instructions.filter { !$0.isArchived }
        
        if showFavoritesOnly {
            filtered = filtered.filter { $0.isFavorite }
        }
        
        if !selectedCategories.isEmpty && selectedCategories.count < RepairCategory.allCases.count {
            filtered = filtered.filter { selectedCategories.contains($0.category) }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { instruction in
                instruction.title.localizedCaseInsensitiveContains(searchText) ||
                instruction.shortDescription.localizedCaseInsensitiveContains(searchText) ||
                instruction.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filteredInstructions = filtered.sorted { $0.title < $1.title }
    }
    
    func toggleFavorite(for instruction: RepairInstruction) {
        if let index = instructions.firstIndex(where: { $0.id == instruction.id }) {
            instructions[index].isFavorite.toggle()
            updateFilteredInstructions()
        }
    }
    
    func archiveInstruction(_ instruction: RepairInstruction) {
        if let index = instructions.firstIndex(where: { $0.id == instruction.id }) {
            instructions[index].isArchived = true
            instructions[index].dateArchived = Date()
            updateFilteredInstructions()
        }
    }
    
    func restoreInstruction(_ instruction: RepairInstruction) {
        if let index = instructions.firstIndex(where: { $0.id == instruction.id }) {
            instructions[index].isArchived = false
            instructions[index].dateArchived = nil
            updateFilteredInstructions()
        }
    }
    
    func deleteInstruction(_ instruction: RepairInstruction) {
        instructions.removeAll { $0.id == instruction.id }
        updateFilteredInstructions()
    }
    
    func updateToolChecked(for instructionId: UUID, toolIndex: Int, isChecked: Bool) {
        if let index = instructions.firstIndex(where: { $0.id == instructionId }) {
            instructions[index].toolsChecked[toolIndex] = isChecked
            objectWillChange.send()
        }
    }
    
    func updateStepCompleted(for instructionId: UUID, stepIndex: Int, isCompleted: Bool) {
        if let index = instructions.firstIndex(where: { $0.id == instructionId }) {
            instructions[index].stepsCompleted[stepIndex] = isCompleted
            objectWillChange.send()
        }
    }
    
    var archivedInstructions: [RepairInstruction] {
        instructions.filter { $0.isArchived }.sorted { 
            ($0.dateArchived ?? Date.distantPast) > ($1.dateArchived ?? Date.distantPast)
        }
    }
    
    var favoriteInstructions: [RepairInstruction] {
        instructions.filter { $0.isFavorite && !$0.isArchived }
    }
    
    func instructionsByCategory(_ category: RepairCategory) -> [RepairInstruction] {
        instructions.filter { $0.category == category && !$0.isArchived }
    }
}

