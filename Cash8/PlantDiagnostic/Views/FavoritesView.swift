import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var appState: AppState
    @State private var favoritePlants: [Plant] = []
    @State private var isLoading = true
    @State private var selectedPlants: Set<String> = []
    @State private var isSelectionMode = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if isLoading {
                        loadingView
                    } else if favoritePlants.isEmpty {
                        emptyStateView
                    } else {
                        plantsListView
                    }
                    
                    if isSelectionMode {
                        selectionToolbar
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            loadFavorites()
        }
        .onChange(of: appState.favoriteIds) { _ in
            loadFavorites()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Favorites")
                .font(.titleLarge)
                .foregroundColor(.primaryText)
            
            Spacer()
            
            if !favoritePlants.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSelectionMode.toggle()
                        selectedPlants.removeAll()
                    }
                }) {
                    Text(isSelectionMode ? "Cancel" : "Select")
                        .font(.bodyMedium)
                        .foregroundColor(.accentBlue)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.accentGreen)
            
            Text("Loading favorites...")
                .font(.bodyMedium)
                .foregroundColor(.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart")
                .font(.system(size: 60))
                .foregroundColor(.secondaryText)
            
            Text("No favorite plants yet")
                .font(.titleMedium)
                .foregroundColor(.primaryText)
            
            Text("Add plants to your favorites from the catalog to see them here.")
                .font(.bodyMedium)
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            NavigationLink(destination: PlantCatalogView()) {
                Text("Browse Catalog")
                    .font(.buttonText)
                    .foregroundColor(.buttonText)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(AppGradients.buttonGradient)
                    .cornerRadius(20)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var plantsListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(favoritePlants) { plant in
                    if isSelectionMode {
                        SelectablePlantCardView(
                            plant: plant,
                            isSelected: selectedPlants.contains(plant.id)
                        ) {
                            toggleSelection(plant.id)
                        }
                    } else {
                        SwipeablePlantCardView(plant: plant) {
                            removeFavorite(plant.id)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, isSelectionMode ? 80 : 20)
        }
    }
    
    private var selectionToolbar: some View {
        HStack {
            Text("\(selectedPlants.count) selected")
                .font(.bodyMedium)
                .foregroundColor(.primaryText)
            
            Spacer()
            
            Button("Remove Selected") {
                removeSelectedFavorites()
            }
            .font(.buttonText)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.red)
            .cornerRadius(16)
            .disabled(selectedPlants.isEmpty)
            .opacity(selectedPlants.isEmpty ? 0.5 : 1.0)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background( AppGradients.backgroundGradient)
        .padding(.vertical, 16)
        .shadow(color: Color.cardShadow, radius: 4, x: 0, y: -2)
    }
    
    private func loadFavorites() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            favoritePlants = PlantDataManager.shared.getFavoritePlants(favoriteIds: appState.favoriteIds)
            isLoading = false
        }
    }
    
    private func removeFavorite(_ plantId: String) {
        withAnimation(.easeInOut(duration: 0.3)) {
            appState.toggleFavorite(plantId)
        }
    }
    
    private func toggleSelection(_ plantId: String) {
        if selectedPlants.contains(plantId) {
            selectedPlants.remove(plantId)
        } else {
            selectedPlants.insert(plantId)
        }
    }
    
    private func removeSelectedFavorites() {
        withAnimation(.easeInOut(duration: 0.3)) {
            for plantId in selectedPlants {
                appState.toggleFavorite(plantId)
            }
            selectedPlants.removeAll()
            isSelectionMode = false
        }
    }
}

struct SwipeablePlantCardView: View {
    let plant: Plant
    let onRemove: () -> Void
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                Button(action: onRemove) {
                    VStack {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 20))
                        Text("Remove")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
            .cornerRadius(16)
            
            NavigationLink(destination: PlantDetailView(plant: plant)) {
                PlantCardView(plant: plant)
            }
            .buttonStyle(PlainButtonStyle())
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            offset = value.translation
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if value.translation.width < -100 {
                                offset = CGSize(width: -80, height: 0)
                            } else {
                                offset = .zero
                            }
                        }
                    }
            )
        }
    }
}

struct SelectablePlantCardView: View {
    let plant: Plant
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .accentGreen : .secondaryText)
                
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppGradients.cardGradient)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.accentGreen)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(plant.name)
                            .font(.titleSmall)
                            .foregroundColor(.primaryText)
                            .lineLimit(1)
                        
                        if let latinName = plant.latinName {
                            Text(latinName)
                                .font(.bodySmall)
                                .foregroundColor(.secondaryText)
                                .italic()
                                .lineLimit(1)
                        }
                        
                        HStack {
                            Text(plant.type.rawValue)
                                .font(.caption)
                                .foregroundColor(.accentBlue)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.accentBlue.opacity(0.1))
                                .cornerRadius(6)
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(12)
            .background(isSelected ? Color.accentGreen.opacity(0.1) : Color.cardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.accentGreen : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FavoritesView()
        .environmentObject(AppState())
}


