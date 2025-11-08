import SwiftUI

struct PlantCatalogView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var selectedType: Plant.PlantType? = nil
    @State private var selectedDifficulty: Plant.Difficulty? = nil
    @State private var showingFilters = false
    
    private let samplePlants = PlantDataManager.shared.getAllPlants()
    
    private var filteredPlants: [Plant] {
        var plants = samplePlants
        
        if !searchText.isEmpty {
            plants = plants.filter { plant in
                plant.name.localizedCaseInsensitiveContains(searchText) ||
                plant.latinName?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
        
        if let selectedType = selectedType {
            plants = plants.filter { $0.type == selectedType }
        }
        
        if let selectedDifficulty = selectedDifficulty {
            plants = plants.filter { $0.difficulty == selectedDifficulty }
        }
        
        return plants
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchBarView
                    
                    if showingFilters {
                        filterBarView
                    }
                    
                    plantsGridView
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var headerView: some View {
        HStack {
            Text("Plant Catalog")
                .font(.titleLarge)
                .foregroundColor(.primaryText)
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showingFilters.toggle()
                }
            }) {
                Image(systemName: showingFilters ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle")
                    .font(.system(size: 24))
                    .foregroundColor(.accentGreen)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondaryText)
            
            TextField("Search plants...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.bodyMedium)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.cardBackground)
        .cornerRadius(25)
        .padding(.horizontal, 20)
        .padding(.top, 15)
    }
    
    private var filterBarView: some View {
        VStack(spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterChip(
                        title: "All Types",
                        isSelected: selectedType == nil
                    ) {
                        selectedType = nil
                    }
                    
                    ForEach(Plant.PlantType.allCases, id: \.self) { type in
                        FilterChip(
                            title: type.rawValue,
                            isSelected: selectedType == type
                        ) {
                            selectedType = selectedType == type ? nil : type
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterChip(
                        title: "All Levels",
                        isSelected: selectedDifficulty == nil
                    ) {
                        selectedDifficulty = nil
                    }
                    
                    ForEach(Plant.Difficulty.allCases, id: \.self) { difficulty in
                        FilterChip(
                            title: difficulty.rawValue,
                            isSelected: selectedDifficulty == difficulty
                        ) {
                            selectedDifficulty = selectedDifficulty == difficulty ? nil : difficulty
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 15)
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
    
    private var plantsGridView: some View {
        ScrollView(showsIndicators: false) {
            if filteredPlants.isEmpty {
                emptyStateView
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ], spacing: 15) {
                    ForEach(filteredPlants) { plant in
                        NavigationLink(destination: PlantDetailView(plant: plant)) {
                            PlantCardView(plant: plant)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "leaf")
                .font(.system(size: 60))
                .foregroundColor(.secondaryText)
            
            Text("No plants found")
                .font(.titleMedium)
                .foregroundColor(.primaryText)
            
            Text("Try adjusting your search or filters")
                .font(.bodyMedium)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.bodySmall)
                .foregroundColor(isSelected ? .buttonText : .primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.accentGreen : Color.cardBackground)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PlantCatalogView()
        .environmentObject(AppState())
}
