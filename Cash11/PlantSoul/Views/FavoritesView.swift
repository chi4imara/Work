import SwiftUI

struct FavoritesView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var searchText = ""
    @State private var selectedSection: FavoriteSection = .plants
    @State private var selectedItems: Set<String> = []
    @State private var isSelectionMode = false
    
    enum FavoriteSection: String, CaseIterable {
        case plants = "Plants"
        case instructions = "Instructions"
    }
    
    var favorites: (plants: [Plant], instructions: [Instruction]) {
        return appViewModel.allFavorites
    }
    
    var filteredPlants: [Plant] {
        let plants = favorites.plants
        if searchText.isEmpty {
            return plants
        }
        return plants.filter { plant in
            plant.name.localizedCaseInsensitiveContains(searchText) ||
            plant.category.displayName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var filteredInstructions: [Instruction] {
        let instructions = favorites.instructions
        if searchText.isEmpty {
            return instructions
        }
        return instructions.filter { instruction in
            instruction.title.localizedCaseInsensitiveContains(searchText) ||
            instruction.description.localizedCaseInsensitiveContains(searchText) ||
            instruction.type.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ZStack {
            ColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                sectionSelectorView
                
                contentView
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            if isSelectionMode {
                Button("Cancel") {
                    isSelectionMode = false
                    selectedItems.removeAll()
                }
                .foregroundColor(ColorScheme.lightText)
            } else {
                Text("Favorites")
                    .font(FontManager.title)
                    .fontWeight(.bold)
                    .foregroundColor(ColorScheme.lightText)
            }
            
            Spacer()
            
            if isSelectionMode {
                Button("Remove Selected") {
                    removeSelectedItems()
                }
                .foregroundColor(ColorScheme.error)
                .disabled(selectedItems.isEmpty)
            } else {
                Button("Select") {
                    isSelectionMode = true
                }
                .foregroundColor(ColorScheme.lightText)
                .opacity(hasItems ? 1.0 : 0.5)
                .disabled(!hasItems)
            }
        }
        .padding(.horizontal, DesignConstants.largePadding)
        .padding(.vertical, DesignConstants.mediumPadding)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorScheme.mediumGray)
            
            TextField("", text: $searchText)
                .font(FontManager.body)
                .foregroundColor(ColorScheme.primaryText)
                .overlay(
                    HStack {
                        Text("Search favorites...")
                            .font(FontManager.body)
                            .foregroundColor(.gray)
                            .opacity(searchText.isEmpty ? 1 : 0)
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
    
    private var sectionSelectorView: some View {
        HStack(spacing: 0) {
            ForEach(FavoriteSection.allCases, id: \.self) { section in
                Button(action: {
                    selectedSection = section
                    selectedItems.removeAll()
                }) {
                    VStack(spacing: 4) {
                        Text(section.rawValue)
                            .font(FontManager.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedSection == section ? ColorScheme.accent : ColorScheme.lightText.opacity(0.7))
                        
                        Text("\(countForSection(section))")
                            .font(FontManager.poppinsLight(size: 10))
                            .foregroundColor(selectedSection == section ? ColorScheme.accent : ColorScheme.lightText.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignConstants.mediumPadding)
                    .background(
                        Rectangle()
                            .fill(selectedSection == section ? ColorScheme.accent.opacity(0.1) : Color.clear)
                    )
                    .overlay(
                        Rectangle()
                            .fill((selectedSection == section) ? ColorScheme.accent : Color.clear)
                            .frame(height: 2),
                        alignment: .bottom
                    )
                    .cornerRadius(DesignConstants.cornerRadius)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.cardGradient.opacity(0.3))
        )
        .padding(.horizontal, DesignConstants.largePadding)
        .padding(.bottom, DesignConstants.mediumPadding)
        .cornerRadius(DesignConstants.cornerRadius)
    }
    
    private var contentView: some View {
        Group {
            if !hasItems {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: DesignConstants.mediumPadding) {
                        if selectedSection == .plants {
                            ForEach(filteredPlants) { plant in
                                FavoritePlantRowView(
                                    plant: plant,
                                    appViewModel: appViewModel,
                                    isSelected: selectedItems.contains("plant_\(plant.id)"),
                                    isSelectionMode: isSelectionMode
                                ) { plantId in
                                    toggleSelection("plant_\(plantId)")
                                }
                            }
                        } else {
                            ForEach(filteredInstructions) { instruction in
                                FavoriteInstructionRowView(
                                    instruction: instruction,
                                    appViewModel: appViewModel,
                                    isSelected: selectedItems.contains("instruction_\(instruction.id)"),
                                    isSelectionMode: isSelectionMode
                                ) { instructionId in
                                    toggleSelection("instruction_\(instructionId)")
                                }
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
            Image(systemName: "heart.fill")
                .font(.system(size: 60))
                .foregroundColor(ColorScheme.accent.opacity(0.6))
            
            Text("No favorites yet")
                .font(FontManager.headline)
                .foregroundColor(ColorScheme.lightText)
            
            Text("Add plants and instructions to favorites to see them here")
                .font(FontManager.body)
                .foregroundColor(ColorScheme.lightText.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(DesignConstants.largePadding)
    }
    
    private var hasItems: Bool {
        return !favorites.plants.isEmpty || !favorites.instructions.isEmpty
    }
    
    private func countForSection(_ section: FavoriteSection) -> Int {
        switch section {
        case .plants:
            return favorites.plants.count
        case .instructions:
            return favorites.instructions.count
        }
    }
    
    private func toggleSelection(_ itemId: String) {
        if selectedItems.contains(itemId) {
            selectedItems.remove(itemId)
        } else {
            selectedItems.insert(itemId)
        }
    }
    
    private func removeSelectedItems() {
        for itemId in selectedItems {
            if itemId.hasPrefix("plant_") {
                let plantIdString = String(itemId.dropFirst(6))
                if let plantId = UUID(uuidString: plantIdString) {
                    if let plant = appViewModel.plantViewModel.plants.first(where: { $0.id == plantId }) {
                        appViewModel.plantViewModel.toggleFavorite(plant)
                    }
                }
            } else if itemId.hasPrefix("instruction_") {
                let instructionIdString = String(itemId.dropFirst(12))
                if let instructionId = UUID(uuidString: instructionIdString) {
                    if let instruction = appViewModel.instructionViewModel.instructions.first(where: { $0.id == instructionId }) {
                        appViewModel.instructionViewModel.toggleFavorite(instruction)
                    }
                }
            }
        }
        selectedItems.removeAll()
        isSelectionMode = false
    }
}

struct FavoritePlantRowView: View {
    let plant: Plant
    @ObservedObject var appViewModel: AppViewModel
    let isSelected: Bool
    let isSelectionMode: Bool
    let onSelectionToggle: (UUID) -> Void
    
    @State private var showingPlantDetail = false
    
    var body: some View {
        HStack(spacing: DesignConstants.mediumPadding) {
            if isSelectionMode {
                Button(action: { onSelectionToggle(plant.id) }) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(isSelected ? ColorScheme.accent : ColorScheme.mediumGray)
                }
            }
            
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.accent.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "leaf.fill")
                        .font(.title3)
                        .foregroundColor(ColorScheme.accent)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(plant.name)
                    .font(FontManager.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(ColorScheme.primaryText)
                
                Text(plant.category.displayName)
                    .font(FontManager.caption)
                    .foregroundColor(ColorScheme.secondaryText)
                
                if !plant.notes.isEmpty {
                    Text(plant.notes)
                        .font(FontManager.caption)
                        .foregroundColor(ColorScheme.secondaryText)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            if !isSelectionMode {
                Button(action: {
                    appViewModel.plantViewModel.toggleFavorite(plant)
                }) {
                    Image(systemName: "heart.fill")
                        .font(.title3)
                        .foregroundColor(ColorScheme.accent)
                }
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
            if !isSelectionMode {
                showingPlantDetail = true
            }
        }
        .sheet(isPresented: $showingPlantDetail) {
            PlantDetailView(plant: plant, plantViewModel: appViewModel.plantViewModel, taskViewModel: appViewModel.taskViewModel)
        }
    }
}

struct FavoriteInstructionRowView: View {
    let instruction: Instruction
    @ObservedObject var appViewModel: AppViewModel
    let isSelected: Bool
    let isSelectionMode: Bool
    let onSelectionToggle: (UUID) -> Void
    
    @State private var showingInstructionDetail = false
    
    var body: some View {
        HStack(spacing: DesignConstants.mediumPadding) {
            if isSelectionMode {
                Button(action: { onSelectionToggle(instruction.id) }) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(isSelected ? ColorScheme.accent : ColorScheme.mediumGray)
                }
            }
            
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
                    .lineLimit(2)
                
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
            
            if !isSelectionMode {
                Button(action: {
                    appViewModel.instructionViewModel.toggleFavorite(instruction)
                }) {
                    Image(systemName: "heart.fill")
                        .font(.title3)
                        .foregroundColor(ColorScheme.accent)
                }
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
            if !isSelectionMode {
                showingInstructionDetail = true
            }
        }
        .sheet(isPresented: $showingInstructionDetail) {
            InstructionDetailView(instruction: instruction, instructionViewModel: appViewModel.instructionViewModel)
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

#Preview {
    FavoritesView(appViewModel: AppViewModel())
}

