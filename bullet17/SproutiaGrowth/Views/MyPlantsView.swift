import SwiftUI

struct MyPlantsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var showingAddPlant = false
    @State private var showingFilterMenu = false
    @State private var selectedPlant: PlantModel?
    @State private var selectedPlantEntry: PlantModel?
    @State private var showingPlantDetails = false
    @State private var showingAddEntry = false
    @State private var plantToDelete: PlantModel?
    @State private var showingDeleteAlert = false
    
    @State private var sortOption: SortOption = .lastRecord
    @State private var filterStatus: PlantStatus? = nil
    
    enum SortOption: String, CaseIterable {
        case name = "Name"
        case lastRecord = "Last Record"
        case height = "Height"
        
        var displayName: String {
            return self.rawValue
        }
    }
    
    var filteredAndSortedPlants: [PlantModel] {
        var result = dataManager.getPlantsWithEntries()
        
        if let filterStatus = filterStatus {
            result = result.filter { $0.status == filterStatus }
        }
        
        switch sortOption {
        case .name:
            result.sort { $0.name < $1.name }
        case .lastRecord:
            result.sort { ($0.lastRecordDate ?? Date.distantPast) > ($1.lastRecordDate ?? Date.distantPast) }
        case .height:
            result.sort { ($0.lastMeasurement.height ?? 0) > ($1.lastMeasurement.height ?? 0) }
        }
        
        return result
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: { showingFilterMenu = true }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.primaryBlue)
                    }
                    .confirmationDialog("Filter & Sort", isPresented: $showingFilterMenu) {
                        Button("Sort by Name") { sortOption = .name }
                        Button("Sort by Last Record") { sortOption = .lastRecord }
                        Button("Sort by Height") { sortOption = .height }
                        Button("Filter: Healthy") { filterStatus = .healthy }
                        Button("Filter: Needs Care") { filterStatus = .needsCare }
                        Button("Filter: Monitoring") { filterStatus = .monitoring }
                        Button("Show All") { filterStatus = nil }
                        Button("Cancel", role: .cancel) { }
                    }
                    
                    Spacer()
                    
                    Text("My Plants")
                        .font(.playfair(.bold, size: 28))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    
                    Button(action: { showingAddPlant = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.primaryBlue)
                    }
                }
                
                if filteredAndSortedPlants.isEmpty {
                    emptyStateView
                } else {
                    plantsListView
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $showingAddPlant) {
            AddPlantEntryView(mode: .newPlant)
        }
        .sheet(item: $selectedPlantEntry) { plant in
            AddPlantEntryView(mode: .newEntry(plant: plant, selectedDate: nil))
        }
        .sheet(item: $selectedPlant) { plant in
            PlantDetailsView(plant: plant)
        }
        .alert("Delete Plant", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let plant = plantToDelete {
                    deletePlant(plant)
                }
            }
        } message: {
            Text("Are you sure you want to delete this plant and all its records?")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "leaf.fill")
                .font(.system(size: 80))
                .foregroundColor(AppColors.softGreen)
            
            VStack(spacing: 12) {
                Text("No Plants Yet")
                    .font(.playfair(.bold, size: 24))
                    .foregroundColor(AppColors.primaryText)
                
                Text("You haven't added any plants yet")
                    .font(.playfair(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddPlant = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Plant")
                }
                .font(.playfair(.semiBold, size: 18))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .background(AppColors.primaryBlue)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private var plantsListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(filteredAndSortedPlants, id: \.id) { plant in
                    PlantCardView(plant: plant)
                        .onTapGesture {
                            selectedPlant = plant
                            showingPlantDetails = true
                        }
                        .contextMenu {
                            Button(action: {
                                selectedPlantEntry = plant
                                showingAddEntry = true
                            }) {
                                Label("Add Entry", systemImage: "plus.circle")
                            }
                            
                            Button(role: .destructive, action: {
                                plantToDelete = plant
                                showingDeleteAlert = true
                            }) {
                                Label("Delete Plant", systemImage: "trash")
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
    
    
    private func deletePlant(_ plant: PlantModel) {
        withAnimation {
            dataManager.deletePlant(plant)
        }
    }
}

struct PlantCardView: View {
    let plant: PlantModel
    
    private var lastMeasurementText: String {
        let measurement = plant.lastMeasurement
        var components: [String] = []
        
        if let height = measurement.height {
            components.append("Height: \(String(format: "%.1f", height)) cm")
        }
        
        if let leaves = measurement.leaves {
            components.append("Leaves: \(leaves)")
        }
        
        return components.isEmpty ? "No measurements yet" : components.joined(separator: " • ")
    }
    
    private var lastRecordText: String {
        if let date = plant.lastRecordDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return "No records yet"
    }
    
    private var statusColor: Color {
        switch plant.status {
        case .healthy:
            return AppColors.healthyGreen
        case .needsCare:
            return AppColors.warningOrange
        case .monitoring:
            return AppColors.alertRed
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(plant.name)
                        .font(.playfair(.semiBold, size: 18))
                        .foregroundColor(AppColors.primaryText)
                    
                    if let location = plant.location, !location.isEmpty {
                        Text(location)
                            .font(.playfair(.regular, size: 14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                Spacer()
                
                Text(plant.status.displayName)
                    .font(.playfair(.medium, size: 12))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(statusColor)
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lastMeasurementText)
                    .font(.playfair(.regular, size: 14))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Last record: \(lastRecordText)")
                    .font(.playfair(.regular, size: 12))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    MyPlantsView()
        .environmentObject(DataManager.shared)
}
