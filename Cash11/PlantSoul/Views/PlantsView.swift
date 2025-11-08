import SwiftUI

struct PlantsView: View {
    @ObservedObject var plantViewModel: PlantViewModel
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var showingAddPlant = false
    @State private var selectedPlant: Plant?
    
    var body: some View {
        ZStack {
            ColorScheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBarView
                
                plantsListView
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showingAddPlant = true }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(ColorScheme.white)
                            .frame(width: 56, height: 56)
                            .background(
                                Circle()
                                    .fill(ColorScheme.accent)
                                    .shadow(
                                        color: ColorScheme.accent.opacity(0.3),
                                        radius: 8,
                                        x: 0,
                                        y: 4
                                    )
                            )
                    }
                    .padding(.trailing, DesignConstants.largePadding)
                    .padding(.bottom, 80)
                }
            }
        }
        .sheet(isPresented: $showingAddPlant) {
            AddPlantView(plantViewModel: plantViewModel)
        }
        .sheet(item: $selectedPlant) { plant in
            PlantDetailView(plant: plant, plantViewModel: plantViewModel, taskViewModel: taskViewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Plants")
                .font(FontManager.title)
                .fontWeight(.bold)
                .foregroundColor(ColorScheme.lightText)
            
            Spacer()
        }
        .padding(.horizontal, DesignConstants.largePadding)
        .padding(.vertical, DesignConstants.mediumPadding)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ColorScheme.mediumGray)
            
            TextField("", text: $plantViewModel.searchText)
                .font(FontManager.body)
                .foregroundColor(ColorScheme.primaryText)
                .overlay(
                    HStack {Text("Search plants...")
                            .font(FontManager.body)
                            .foregroundColor(.gray)
                            .opacity(plantViewModel.searchText.isEmpty ? 1 : 0)
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
    
    private var plantsListView: some View {
        Group {
            if plantViewModel.filteredPlants.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVStack(spacing: DesignConstants.mediumPadding) {
                        ForEach(plantViewModel.filteredPlants) { plant in
                            PlantRowView(
                                plant: plant,
                                plantViewModel: plantViewModel,
                                taskViewModel: taskViewModel
                            ) {
                                selectedPlant = plant
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
            Image(systemName: "leaf.fill")
                .font(.system(size: 60))
                .foregroundColor(ColorScheme.accent.opacity(0.6))
            
            Text("No plants yet")
                .font(FontManager.headline)
                .foregroundColor(ColorScheme.lightText)
            
            Text("Add your first plant to start tracking care tasks")
                .font(FontManager.body)
                .foregroundColor(ColorScheme.lightText.opacity(0.7))
                .multilineTextAlignment(.center)
            
            Button(action: { showingAddPlant = true }) {
                Text("Add Plant")
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
}

struct PlantRowView: View {
    let plant: Plant
    @ObservedObject var plantViewModel: PlantViewModel
    @ObservedObject var taskViewModel: TaskViewModel
    let onTap: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingArchiveConfirmation = false
    
    var body: some View {
        HStack(spacing: DesignConstants.mediumPadding) {
            RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                .fill(ColorScheme.accent.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "leaf.fill")
                        .font(.title2)
                        .foregroundColor(ColorScheme.accent)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(plant.name)
                        .font(FontManager.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(ColorScheme.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        plantViewModel.toggleFavorite(plant)
                    }) {
                        Image(systemName: plant.isFavorite ? "heart.fill" : "heart")
                            .font(.title3)
                            .foregroundColor(plant.isFavorite ? ColorScheme.accent : ColorScheme.mediumGray)
                    }
                }
                
                Text(plant.category.displayName)
                    .font(FontManager.caption)
                    .foregroundColor(ColorScheme.secondaryText)
                
                if let nextTask = upcomingTasksText {
                    Text(nextTask)
                        .font(FontManager.caption)
                        .foregroundColor(ColorScheme.accent)
                        .lineLimit(2)
                }
                
                if !plant.notes.isEmpty {
                    Text(plant.notes)
                        .font(FontManager.caption)
                        .foregroundColor(ColorScheme.secondaryText)
                        .lineLimit(1)
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
            onTap()
        }
        .alert("Archive Plant", isPresented: $showingArchiveConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Archive", role: .destructive) {
                plantViewModel.deletePlant(plant)
            }
        } message: {
            Text("This plant and all its tasks will be moved to the archive.")
        }
    }
    
    private var upcomingTasksText: String? {
        let upcomingTasks = taskViewModel.tasks.filter { task in
            task.plantId == plant.id && !task.isCompleted && !task.isArchived && task.date >= Date()
        }.sorted { $0.date < $1.date }
        
        if let nextTask = upcomingTasks.first {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .abbreviated
            let relativeDate = formatter.localizedString(for: nextTask.date, relativeTo: Date())
            return "Next: \(nextTask.type.rawValue) \(relativeDate)"
        }
        
        return nil
    }
}

#Preview {
    PlantsView(plantViewModel: PlantViewModel(), taskViewModel: TaskViewModel())
}

