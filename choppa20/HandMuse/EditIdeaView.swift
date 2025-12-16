import SwiftUI

struct EditIdeaView: View {
    let idea: CraftIdea
    @ObservedObject var viewModel: IdeasViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var selectedCraftType: CraftType
    @State private var description: String
    @State private var materialsText: String
    @State private var stepsText: String
    @State private var isCompleted: Bool
    
    init(idea: CraftIdea, viewModel: IdeasViewModel) {
        self.idea = idea
        self.viewModel = viewModel
        
        _title = State(initialValue: idea.title)
        _selectedCraftType = State(initialValue: idea.craftType)
        _description = State(initialValue: idea.description)
        _materialsText = State(initialValue: idea.materials.joined(separator: "\n"))
        _stepsText = State(initialValue: idea.steps.map { $0.title }.joined(separator: "\n"))
        _isCompleted = State(initialValue: idea.isCompleted)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            TextField("Large knit scarf", text: $title)
                                .font(.playfairDisplay(16))
                                .foregroundColor(Color.theme.primaryText)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Craft Type")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Menu {
                                ForEach(CraftType.allCases, id: \.self) { craftType in
                                    Button(craftType.displayName) {
                                        selectedCraftType = craftType
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedCraftType.displayName)
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(Color.theme.secondaryText)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                if description.isEmpty {
                                    Text("Planning to knit a gift for a friend")
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $description)
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(Color.theme.primaryText)
                                    .frame(minHeight: 100)
                                    .scrollContentBackground(.hidden)
                                    .padding(8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.cardBackground)
                                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Materials")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                if materialsText.isEmpty {
                                    Text("Yarn, needles #7, needle\nScissors, measuring tape")
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $materialsText)
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(Color.theme.primaryText)
                                    .frame(minHeight: 120)
                                    .scrollContentBackground(.hidden)
                                    .padding(8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.cardBackground)
                                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Steps")
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                            
                            ZStack(alignment: .topLeading) {
                                if stepsText.isEmpty {
                                    Text("1. Start pattern\n2. Knit 30 cm\n3. Finish edge")
                                        .font(.playfairDisplay(16))
                                        .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $stepsText)
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(Color.theme.primaryText)
                                    .frame(minHeight: 150)
                                    .scrollContentBackground(.hidden)
                                    .padding(8)
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.cardBackground)
                                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                            )
                        }
                        
                        HStack {
                            Toggle("Completed", isOn: $isCompleted)
                                .font(.playfairDisplay(16, weight: .semibold))
                                .foregroundColor(Color.theme.primaryText)
                                .toggleStyle(SwitchToggleStyle(tint: Color.theme.primaryYellow))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 4)
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Idea")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryYellow)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        let materials = materialsText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let newSteps = stepsText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        var updatedSteps: [CraftStep] = []
        for (index, stepTitle) in newSteps.enumerated() {
            if index < idea.steps.count && idea.steps[index].title == stepTitle {
                updatedSteps.append(idea.steps[index])
            } else {
                updatedSteps.append(CraftStep(title: stepTitle))
            }
        }
        
        let updatedIdea = CraftIdea(
            id: idea.id,
            title: title,
            craftType: selectedCraftType,
            description: description,
            materials: materials,
            steps: updatedSteps,
            isCompleted: isCompleted,
            dateCreated: idea.dateCreated,
            dateModified: Date()
        )
        
        viewModel.updateIdea(updatedIdea)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let sampleIdea = CraftIdea(
        title: "Large Knit Scarf",
        craftType: .knitting,
        description: "Planning to knit a gift for a friend",
        materials: ["Yarn", "Needles #7", "Needle"],
        steps: [
            CraftStep(title: "Start pattern"),
            CraftStep(title: "Knit 30 cm"),
            CraftStep(title: "Finish edge")
        ]
    )
    
    EditIdeaView(idea: sampleIdea, viewModel: IdeasViewModel())
}
