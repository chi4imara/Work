import SwiftUI

struct InstructionDetailView: View {
    let instruction: RepairInstruction
    
    @ObservedObject var viewModel: RepairInstructionViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingArchiveConfirmation = false
    @State private var localInstruction: RepairInstruction
    
    init(instruction: RepairInstruction, viewModel: RepairInstructionViewModel) {
        self.instruction = instruction
        self.viewModel = viewModel
        self._localInstruction = State(initialValue: instruction)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        headerSection
                        
                        toolsSection
                        
                        stepsSection
                        
                        if !instruction.tips.isEmpty {
                            tipsSection
                        }
                        
                        actionButtons
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(.primaryBlue)
                }
            }
        }
        .onDisappear {
            syncLocalChangesWithViewModel()
        }
        .onReceive(viewModel.objectWillChange) {
            if let updatedInstruction = viewModel.instructions.first(where: { $0.id == instruction.id }) {
                localInstruction = updatedInstruction
            }
        }
        .alert("Archive Instruction", isPresented: $showingArchiveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Archive", role: .destructive) {
                viewModel.archiveInstruction(instruction)
                dismiss()
            }
        } message: {
            Text("This instruction will be moved to the archive and removed from the handbook.")
        }
    }
    
    private func syncLocalChangesWithViewModel() {
        if let vmIndex = viewModel.instructions.firstIndex(where: { $0.id == instruction.id }) {
            if viewModel.instructions[vmIndex].isFavorite != localInstruction.isFavorite {
                viewModel.instructions[vmIndex].isFavorite = localInstruction.isFavorite
            }
            
            for (index, isChecked) in localInstruction.toolsChecked.enumerated() {
                if index < viewModel.instructions[vmIndex].toolsChecked.count {
                    viewModel.instructions[vmIndex].toolsChecked[index] = isChecked
                }
            }
            
            for (index, isCompleted) in localInstruction.stepsCompleted.enumerated() {
                if index < viewModel.instructions[vmIndex].stepsCompleted.count {
                    viewModel.instructions[vmIndex].stepsCompleted[index] = isCompleted
                }
            }
            
            viewModel.updateFilteredInstructions()
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [Color.primaryBlue.opacity(0.3), Color.darkBlue.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)
                
                Image(systemName: instruction.category.icon)
                    .font(.system(size: 60))
                    .foregroundColor(.primaryBlue)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(instruction.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Text(instruction.category.rawValue)
                    .font(.headline)
                    .foregroundColor(.textSecondary)
                
                Text(instruction.shortDescription)
                    .font(.body)
                    .foregroundColor(.textSecondary)
                    .lineLimit(nil)
            }
        }
    }
    
    private var toolsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("What You'll Need")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 10) {
                ForEach(Array(instruction.tools.enumerated()), id: \.offset) { index, tool in
                    HStack {
                        Button(action: {
                            let newValue = !localInstruction.toolsChecked[index]
                            localInstruction.toolsChecked[index] = newValue
                            viewModel.updateToolChecked(
                                for: instruction.id,
                                toolIndex: index,
                                isChecked: newValue
                            )
                        }) {
                            Image(systemName: localInstruction.toolsChecked[index] ? "checkmark.square.fill" : "square")
                                .font(.title3)
                                .foregroundColor(localInstruction.toolsChecked[index] ? .accentGreen : .textSecondary)
                        }
                        
                        Text(tool)
                            .font(.body)
                            .foregroundColor(.textPrimary)
                            .strikethrough(localInstruction.toolsChecked[index])
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
        }
    }
    
    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Step-by-Step Instructions")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                if localInstruction.stepsCompleted.allSatisfy({ $0 }) && !localInstruction.steps.isEmpty {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.accentGreen)
                        Text("Completed!")
                            .font(.caption)
                            .foregroundColor(.accentGreen)
                    }
                }
            }
            
            VStack(spacing: 15) {
                ForEach(Array(instruction.steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 15) {
                        VStack {
                                                    Button(action: {
                            let newValue = !localInstruction.stepsCompleted[index]
                            localInstruction.stepsCompleted[index] = newValue
                            viewModel.updateStepCompleted(
                                for: instruction.id,
                                stepIndex: index,
                                isCompleted: newValue
                            )
                        }) {
                            ZStack {
                                Circle()
                                    .fill(localInstruction.stepsCompleted[index] ? Color.accentGreen : Color.primaryBlue)
                                    .frame(width: 30, height: 30)
                                
                                if localInstruction.stepsCompleted[index] {
                                    Image(systemName: "checkmark")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                } else {
                                    Text("\(index + 1)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(step.title)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.textPrimary)
                                .strikethrough(localInstruction.stepsCompleted[index])
                            
                            Text(step.description)
                                .font(.body)
                                .foregroundColor(.textSecondary)
                                .strikethrough(localInstruction.stepsCompleted[index])
                        }
                        
                        Spacer()
                    }
                    .padding(16)
                    .background(
                        Color.cardBackground.opacity(localInstruction.stepsCompleted[index] ? 0.5 : 1.0)
                    )
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Tips & Safety")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 10) {
                ForEach(Array(instruction.tips.enumerated()), id: \.offset) { index, tip in
                    HStack(alignment: .top) {
                        Image(systemName: "lightbulb.fill")
                            .font(.body)
                            .foregroundColor(.accentOrange)
                        
                        Text(tip)
                            .font(.body)
                            .foregroundColor(.textPrimary)
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(16)
            .background(Color.accentOrange.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                localInstruction.isFavorite.toggle()
                viewModel.toggleFavorite(for: instruction)
            }) {
                HStack {
                    Image(systemName: localInstruction.isFavorite ? "star.slash.fill" : "star.fill")
                    Text(localInstruction.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(localInstruction.isFavorite ? Color.textSecondary : Color.accentOrange)
                .cornerRadius(12)
            }
            
            Button(action: {
                showingArchiveConfirmation = true
            }) {
                HStack {
                    Image(systemName: "archivebox.fill")
                    Text("Move to Archive")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentRed)
                .cornerRadius(12)
            }
        }
    }
}

#Preview {
    InstructionDetailView(
        instruction: RepairInstruction(
            title: "Fix Leaking Faucet",
            category: .plumbing,
            shortDescription: "How to repair a dripping tap in your kitchen or bathroom",
            imageName: "faucet",
            tools: ["Adjustable wrench", "Screwdriver", "Plumber's tape"],
            steps: [
                RepairStep(title: "Turn off water supply", description: "Locate the shut-off valve under the sink and turn it clockwise."),
                RepairStep(title: "Remove faucet handle", description: "Use a screwdriver to remove the screw holding the handle.")
            ],
            tips: ["Always turn off water supply before starting", "Keep track of small parts"]
        ),
        viewModel: RepairInstructionViewModel()
    )
}

