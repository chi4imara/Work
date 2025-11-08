import Foundation

struct Instruction: Identifiable, Codable, Equatable {
    let id = UUID()
    var title: String
    var description: String
    var type: TaskType
    var requiredItems: [String]
    var steps: [InstructionStep]
    var isFavorite: Bool
    var isArchived: Bool
    var dateCreated: Date
    
    init(title: String, description: String, type: TaskType, requiredItems: [String] = [], steps: [InstructionStep] = []) {
        self.title = title
        self.description = description
        self.type = type
        self.requiredItems = requiredItems
        self.steps = steps
        self.isFavorite = false
        self.isArchived = false
        self.dateCreated = Date()
    }
}

struct InstructionStep: Identifiable, Codable, Equatable {
    let id = UUID()
    var stepNumber: Int
    var title: String
    var description: String
    var isCompleted: Bool
    
    init(stepNumber: Int, title: String, description: String) {
        self.stepNumber = stepNumber
        self.title = title
        self.description = description
        self.isCompleted = false
    }
}

extension Instruction {
    static let defaultInstructions: [Instruction] = [
        Instruction(
            title: "Basic Plant Watering",
            description: "Learn the proper way to water your plants",
            type: .watering,
            requiredItems: ["Watering can", "Clean water", "Drainage tray"],
            steps: [
                InstructionStep(stepNumber: 1, title: "Check soil moisture", description: "Insert finger 1-2 inches into soil"),
                InstructionStep(stepNumber: 2, title: "Prepare water", description: "Use room temperature, filtered water"),
                InstructionStep(stepNumber: 3, title: "Water slowly", description: "Pour water slowly around the base of the plant"),
                InstructionStep(stepNumber: 4, title: "Check drainage", description: "Ensure excess water drains from the bottom")
            ]
        ),
        Instruction(
            title: "Plant Fertilizing Guide",
            description: "How to properly fertilize your plants",
            type: .fertilizing,
            requiredItems: ["Liquid fertilizer", "Measuring cup", "Water"],
            steps: [
                InstructionStep(stepNumber: 1, title: "Choose fertilizer", description: "Select appropriate fertilizer for your plant type"),
                InstructionStep(stepNumber: 2, title: "Mix solution", description: "Dilute fertilizer according to package instructions"),
                InstructionStep(stepNumber: 3, title: "Apply to soil", description: "Pour fertilizer solution onto moist soil"),
                InstructionStep(stepNumber: 4, title: "Water lightly", description: "Follow with a small amount of plain water")
            ]
        ),
        Instruction(
            title: "Plant Repotting",
            description: "Step-by-step guide to repotting plants",
            type: .repotting,
            requiredItems: ["New pot", "Fresh potting soil", "Gloves", "Trowel"],
            steps: [
                InstructionStep(stepNumber: 1, title: "Prepare new pot", description: "Choose a pot 1-2 inches larger than current"),
                InstructionStep(stepNumber: 2, title: "Remove plant", description: "Gently remove plant from old pot"),
                InstructionStep(stepNumber: 3, title: "Clean roots", description: "Remove old soil and trim dead roots"),
                InstructionStep(stepNumber: 4, title: "Plant in new pot", description: "Place plant in new pot with fresh soil")
            ]
        ),
        Instruction(
            title: "Plant Cleaning",
            description: "Keep your plants clean and healthy",
            type: .cleaning,
            requiredItems: ["Soft cloth", "Spray bottle", "Mild soap solution"],
            steps: [
                InstructionStep(stepNumber: 1, title: "Dust leaves", description: "Gently wipe leaves with damp cloth"),
                InstructionStep(stepNumber: 2, title: "Check for pests", description: "Inspect leaves and stems for insects"),
                InstructionStep(stepNumber: 3, title: "Clean pot", description: "Wipe down the exterior of the pot"),
                InstructionStep(stepNumber: 4, title: "Trim dead parts", description: "Remove any dead or yellowing leaves")
            ]
        )
    ]
}

