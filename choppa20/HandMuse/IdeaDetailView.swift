import SwiftUI

struct IdeaDetailItem: Identifiable {
    let id: UUID
}

struct IdeaDetailView: View {
    let ideaId: UUID
    @ObservedObject var viewModel: IdeasViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    @State private var showingEditView = false
    
    private var idea: CraftIdea? {
        viewModel.ideas.first { $0.id == ideaId }
    }
    
    var body: some View {
        Group {
            if let idea = idea {
                NavigationView {
                    ZStack {
                        Color.theme.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 24) {
                                headerSection(idea: idea)
                                
                                if !idea.description.isEmpty {
                                    descriptionSection(idea: idea)
                                }
                                
                                if !idea.materials.isEmpty {
                                    materialsSection(idea: idea)
                                }
                                
                                stepsSection(idea: idea)
                                
                                if !idea.steps.isEmpty {
                                    progressSection(idea: idea)
                                }
                                
                                actionButtonsSection(idea: idea)
                                
                                Spacer(minLength: 100)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                    .navigationTitle(idea.title)
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color.theme.primaryBlue)
                            }
                        }
                    }
                    .alert("Delete Idea", isPresented: $showingDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            if let idea = self.idea {
                                viewModel.deleteIdea(idea)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } message: {
                        Text("Are you sure you want to delete this idea? This action cannot be undone.")
                    }
                    .sheet(isPresented: $showingEditView) {
                        if let idea = self.idea {
                            EditIdeaView(idea: idea, viewModel: viewModel)
                        }
                    }
                }
            }
        }
    }
    
    private func headerSection(idea: CraftIdea) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(idea.craftType.displayName)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(Color.theme.primaryPurple)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.theme.lightPurple.opacity(0.3))
                    )
                
                Spacer()
                
                Text(idea.status)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(idea.isCompleted ? Color.green : Color.theme.primaryBlue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(idea.isCompleted ? Color.green.opacity(0.2) : Color.theme.lightBlue.opacity(0.3))
                    )
            }
        }
    }
    
    private func descriptionSection(idea: CraftIdea) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Text(idea.description)
                .font(.playfairDisplay(16))
                .foregroundColor(Color.theme.secondaryText)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.cardBackground)
                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                )
        }
    }
    
    private func materialsSection(idea: CraftIdea) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Materials")
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(idea.materials.enumerated()), id: \.offset) { index, material in
                    HStack(alignment: .top, spacing: 12) {
                        Circle()
                            .fill(Color.theme.primaryYellow)
                            .frame(width: 6, height: 6)
                            .padding(.top, 6)
                        
                        Text(material)
                            .font(.playfairDisplay(16))
                            .foregroundColor(Color.theme.secondaryText)
                        
                        Spacer()
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
            )
        }
    }
    
    private func stepsSection(idea: CraftIdea) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Steps")
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            if idea.steps.isEmpty {
                Text("No steps added. You can add them later through editing.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.secondaryText.opacity(0.7))
                    .italic()
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.theme.cardBackground)
                            .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                    )
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(idea.steps.enumerated()), id: \.element.id) { index, step in
                        StepRowView(
                            step: step,
                            stepNumber: index + 1,
                            onToggle: {
                                viewModel.toggleStepCompletion(ideaId: idea.id, stepId: step.id)
                            }
                        )
                    }
                }
            }
        }
    }
    
    private func progressSection(idea: CraftIdea) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progress")
                .font(.playfairDisplay(20, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            VStack(spacing: 16) {
                HStack {
                    Text("\(idea.completedStepsCount) of \(idea.totalStepsCount) steps completed")
                        .font(.playfairDisplay(16, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Text("\(Int(idea.progressPercentage * 100))%")
                        .font(.playfairDisplay(16, weight: .bold))
                        .foregroundColor(Color.theme.primaryYellow)
                }
                
                ProgressView(value: idea.progressPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color.theme.primaryYellow))
                    .background(Color.theme.lightBlue.opacity(0.3))
                    .cornerRadius(8)
                    .scaleEffect(y: 2)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
            )
        }
    }
    
    private func actionButtonsSection(idea: CraftIdea) -> some View {
        VStack(spacing: 16) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Idea")
                }
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(Color.theme.buttonText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.theme.buttonBackground)
                        .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
                )
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Idea")
                }
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.red)
                        .shadow(color: Color.red.opacity(0.3), radius: 8, x: 0, y: 4)
                )
            }
        }
    }
}

struct StepRowView: View {
    let step: CraftStep
    let stepNumber: Int
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(step.isCompleted ? Color.theme.primaryYellow : Color.theme.lightBlue.opacity(0.3))
                        .frame(width: 32, height: 32)
                    
                    if step.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color.theme.buttonText)
                    } else {
                        Text("\(stepNumber)")
                            .font(.playfairDisplay(14, weight: .bold))
                            .foregroundColor(Color.theme.primaryText)
                    }
                }
                
                Text(step.title)
                    .font(.playfairDisplay(16))
                    .foregroundColor(step.isCompleted ? Color.theme.secondaryText.opacity(0.7) : Color.theme.primaryText)
                    .strikethrough(step.isCompleted)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let sampleIdea = CraftIdea(
        title: "Large Knit Scarf",
        craftType: .knitting,
        description: "Planning to knit a gift for a friend",
        materials: ["Yarn", "Needles #7", "Needle", "Scissors"],
        steps: [
            CraftStep(title: "Start pattern", isCompleted: true),
            CraftStep(title: "Knit 30 cm", isCompleted: false),
            CraftStep(title: "Finish edge", isCompleted: false)
        ]
    )
    
    IdeaDetailView(ideaId: sampleIdea.id, viewModel: IdeasViewModel())
}
