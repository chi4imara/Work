import SwiftUI

struct InstructionsView: View {
    @ObservedObject var instructionViewModel: InstructionViewModel
    @State private var selectedInstruction: Instruction?
    @State private var showingFilters = false
    
    var body: some View {
        ZStack {
            ColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                filterButtonsView
                
                instructionsListView
            }
        }
        .sheet(item: $selectedInstruction) { instruction in
            InstructionDetailView(instruction: instruction, instructionViewModel: instructionViewModel)
        }
        .actionSheet(isPresented: $showingFilters) {
            filterActionSheet
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Instructions")
                .font(FontManager.title)
                .fontWeight(.bold)
                .foregroundColor(ColorScheme.lightText)
            
            Spacer()
            
            Button(action: { showingFilters = true }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title2)
                    .foregroundColor(ColorScheme.lightText)
            }
        }
        .padding(.horizontal, DesignConstants.largePadding)
        .padding(.vertical, DesignConstants.mediumPadding)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorScheme.mediumGray)
            
            TextField("", text: $instructionViewModel.searchText)
                .font(FontManager.body)
                .foregroundColor(ColorScheme.primaryText)
                .overlay(
                    HStack {
                        Text("Search instructions...")
                            .font(FontManager.body)
                            .foregroundColor(.gray)
                            .opacity(instructionViewModel.searchText.isEmpty ? 1 : 0)
                            .allowsHitTesting(false)
                        
                        Spacer()
                    }
                )
        }
        .padding(DesignConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient)
        )
        .padding(.horizontal, DesignConstants.largePadding)
        .padding(.bottom, DesignConstants.mediumPadding)
    }
    
    private var filterButtonsView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DesignConstants.smallPadding) {
                ForEach(TaskType.allCases, id: \.self) { taskType in
                    FilterButton(
                        title: taskType.rawValue,
                        icon: taskType.icon,
                        isSelected: instructionViewModel.selectedTypes.contains(taskType)
                    ) {
                        if instructionViewModel.selectedTypes.contains(taskType) {
                            instructionViewModel.selectedTypes.remove(taskType)
                        } else {
                            instructionViewModel.selectedTypes.insert(taskType)
                        }
                    }
                }
            }
            .padding(.horizontal, DesignConstants.largePadding)
        }
        .padding(.bottom, DesignConstants.mediumPadding)
    }
    
    private var instructionsListView: some View {
        Group {
            if instructionViewModel.filteredInstructions.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: DesignConstants.mediumPadding) {
                        ForEach(instructionViewModel.filteredInstructions) { instruction in
                            InstructionRowView(
                                instruction: instruction,
                                instructionViewModel: instructionViewModel
                            ) {
                                selectedInstruction = instruction
                            }
                        }
                    }
                    .padding(.horizontal, DesignConstants.largePadding)
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: DesignConstants.largePadding) {
            Image(systemName: "book.fill")
                .font(.system(size: 60))
                .foregroundColor(ColorScheme.accent.opacity(0.6))
            
            Text("No instructions found")
                .font(FontManager.headline)
                .foregroundColor(ColorScheme.lightText)
            
            Text("Try adjusting your search or filters")
                .font(FontManager.body)
                .foregroundColor(ColorScheme.lightText.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button(action: {
                instructionViewModel.resetFilters()
            }) {
                Text("Reset Filters")
                    .font(FontManager.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorScheme.white)
                    .padding(.horizontal, DesignConstants.largePadding)
                    .padding(.vertical, DesignConstants.mediumPadding)
                    .background(
                        RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                            .fill(ColorScheme.accent)
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(DesignConstants.largePadding)
    }
    
    private var filterActionSheet: ActionSheet {
        ActionSheet(
            title: Text("Filter Options"),
            buttons: [
                .default(Text("Reset All Filters")) {
                    instructionViewModel.resetFilters()
                },
                .cancel()
            ]
        )
    }
}

struct FilterButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                
                Text(title)
                    .font(FontManager.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, DesignConstants.mediumPadding)
            .padding(.vertical, DesignConstants.smallPadding)
            .background(
                RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                    .fill(isSelected ? AnyShapeStyle(ColorScheme.accent) : AnyShapeStyle(ColorScheme.cardGradient))
            )
            .foregroundColor(isSelected ? ColorScheme.white : ColorScheme.primaryText)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InstructionRowView: View {
    let instruction: Instruction
    @ObservedObject var instructionViewModel: InstructionViewModel
    let onTap: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingArchiveConfirmation = false
    
    var body: some View {
        HStack(spacing: DesignConstants.mediumPadding) {
            Image(systemName: instruction.type.icon)
                .font(.title2)
                .foregroundColor(colorForTaskType(instruction.type))
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(colorForTaskType(instruction.type).opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(instruction.title)
                    .font(FontManager.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorScheme.primaryText)
                    .lineLimit(2)
                
                Text(instruction.description)
                    .font(FontManager.caption)
                    .foregroundColor(ColorScheme.secondaryText)
                    .lineLimit(3)
                
                Text(instruction.type.rawValue)
                    .font(FontManager.caption)
                    .foregroundColor(colorForTaskType(instruction.type))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(colorForTaskType(instruction.type).opacity(0.2))
                    )
            }
            
            Spacer()
            
            Button(action: {
                instructionViewModel.toggleFavorite(instruction)
            }) {
                Image(systemName: instruction.isFavorite ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundColor(instruction.isFavorite ? ColorScheme.accent : ColorScheme.mediumGray)
            }
        }
        .padding(DesignConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient)
                .shadow(
                    color: ColorScheme.darkBlue.opacity(DesignConstants.shadowOpacity),
                    radius: DesignConstants.shadowRadius / 2,
                    x: 0,
                    y: 2
                )
        )
        .onTapGesture {
            onTap()
        }
        .alert("Archive Instruction", isPresented: $showingArchiveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Archive", role: .destructive) {
                instructionViewModel.archiveInstruction(instruction)
            }
        } message: {
            Text("This instruction will be moved to the archive.")
        }
    }
    
    private func colorForTaskType(_ type: TaskType) -> Color {
        switch type {
        case .watering:
            return ColorScheme.softGreen
        case .fertilizing:
            return ColorScheme.softGreen
        case .repotting:
            return ColorScheme.warmYellow
        case .cleaning:
            return ColorScheme.warmYellow
        case .generalCare:
            return ColorScheme.softGreen
        }
    }
}

struct InstructionDetailView: View {
    let instruction: Instruction
    @ObservedObject var instructionViewModel: InstructionViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var localInstruction: Instruction
    @State private var showingArchiveConfirmation = false
    
    init(instruction: Instruction, instructionViewModel: InstructionViewModel) {
        self.instruction = instruction
        self.instructionViewModel = instructionViewModel
        self._localInstruction = State(initialValue: instruction)
    }
    
    private func updateLocalInstruction() {
        if let updatedInstruction = instructionViewModel.instructions.first(where: { $0.id == instruction.id }) {
            localInstruction = updatedInstruction
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorScheme.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: DesignConstants.largePadding) {
                        headerSection
                        
                        if !localInstruction.requiredItems.isEmpty {
                        }
                        
                        if !localInstruction.steps.isEmpty {
                            stepsSection
                        }
                        

                        actionButtonsSection
                    }
                    .padding(DesignConstants.largePadding)
                }
            }
            .navigationTitle("Instruction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(ColorScheme.lightText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            instructionViewModel.toggleFavorite(localInstruction)
                            updateLocalInstruction()
                        }
                    }) {
                        Image(systemName: localInstruction.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(localInstruction.isFavorite ? ColorScheme.accent : ColorScheme.lightText)
                    }
                }
            }
        }
        .alert("Archive Instruction", isPresented: $showingArchiveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Archive", role: .destructive) {
                instructionViewModel.archiveInstruction(localInstruction)
                dismiss()
            }
        } message: {
            Text("This instruction will be moved to the archive.")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: DesignConstants.mediumPadding) {
            HStack {
                Image(systemName: localInstruction.type.icon)
                    .font(.title)
                    .foregroundColor(colorForTaskType(localInstruction.type))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(localInstruction.title)
                        .font(FontManager.headline)
                        .fontWeight(.bold)
                        .foregroundColor(ColorScheme.lightText)
                    
                    Text(localInstruction.type.rawValue)
                        .font(FontManager.subheadline)
                        .foregroundColor(ColorScheme.lightText.opacity(0.8))
                }
                
                Spacer()
            }
            
            HStack {
                Text(localInstruction.description)
                    .font(FontManager.body)
                    .foregroundColor(ColorScheme.lightText.opacity(0.8))
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
        }
        .padding(DesignConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.3))
        )
    }
    
    private var requiredItemsSection: some View {
        VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
            Text("What You'll Need")
                .font(FontManager.headline)
                .fontWeight(.semibold)
                .foregroundColor(ColorScheme.lightText)
            
            ForEach(Array(localInstruction.requiredItems.enumerated()), id: \.offset) { index, item in
                HStack(spacing: DesignConstants.mediumPadding) {
                    Image(systemName: "circle")
                        .font(.title3)
                        .foregroundColor(ColorScheme.mediumGray)
                    
                    Text(item)
                        .font(FontManager.body)
                        .foregroundColor(ColorScheme.lightText)
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
        }
        .padding(DesignConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.3))
        )
    }
    
    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: DesignConstants.mediumPadding) {
            Text("Step-by-Step Guide")
                .font(FontManager.headline)
                .fontWeight(.semibold)
                .foregroundColor(ColorScheme.lightText)
            
            ForEach(Array(localInstruction.steps.enumerated()), id: \.offset) { index, step in
                HStack(alignment: .top, spacing: DesignConstants.mediumPadding) {
                    Text("\(step.stepNumber)")
                        .font(FontManager.body)
                        .fontWeight(.bold)
                        .foregroundColor(ColorScheme.accent)
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(ColorScheme.accent.opacity(0.2))
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.title)
                            .font(FontManager.body)
                            .fontWeight(.semibold)
                            .foregroundColor(ColorScheme.lightText)
                        
                        if !step.description.isEmpty {
                            Text(step.description)
                                .font(FontManager.caption)
                                .foregroundColor(ColorScheme.lightText.opacity(0.8))
                        }
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
        }
        .padding(DesignConstants.mediumPadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.3))
        )
    }
    
    private var actionButtonsSection: some View {
        HStack(spacing: DesignConstants.mediumPadding) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    instructionViewModel.toggleFavorite(localInstruction)
                    updateLocalInstruction()
                }
            }) {
                HStack {
                    Image(systemName: localInstruction.isFavorite ? "heart.fill" : "heart")
                    Text(localInstruction.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                }
                .font(Font.custom("Poppins-Medium", size: 13))
                .fontWeight(.semibold)
                .foregroundColor(localInstruction.isFavorite ? ColorScheme.error : ColorScheme.accent)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignConstants.mediumPadding)
                .background(
                    RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                        .stroke(localInstruction.isFavorite ? ColorScheme.error : ColorScheme.accent, lineWidth: 1)
                )
            }
            
            Button(action: {
                showingArchiveConfirmation = true
            }) {
                HStack {
                    Image(systemName: "archivebox")
                    Text("Move to Archive")
                }
                .font(Font.custom("Poppins-Medium", size: 13))
                .fontWeight(.semibold)
                .foregroundColor(ColorScheme.error)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DesignConstants.mediumPadding)
                .background(
                    RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                        .stroke(ColorScheme.error, lineWidth: 1)
                )
            }
        }
    }
    
    private func colorForTaskType(_ type: TaskType) -> Color {
        switch type {
        case .watering:
            return ColorScheme.lightBlue
        case .fertilizing:
            return ColorScheme.softGreen
        case .repotting:
            return ColorScheme.warmYellow
        case .cleaning:
            return ColorScheme.lightBlue
        case .generalCare:
            return ColorScheme.softGreen
        }
    }
}

#Preview {
    InstructionsView(instructionViewModel: InstructionViewModel())
}

