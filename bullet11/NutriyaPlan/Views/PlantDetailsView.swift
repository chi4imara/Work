import SwiftUI

struct PlantDetailsView: View {
    @ObservedObject var appViewModel: AppViewModel
    let plantId: UUID
    let onBack: () -> Void
    
    @State private var showingEditPlant = false
    @State private var showingDeleteConfirmation = false
    @State private var showingAllHistory = false
    
    private var plant: Plant? {
        appViewModel.plants.first { $0.id == plantId }
    }
    
    private var plantHistory: [FertilizationEntry] {
        appViewModel.getHistoryForPlant(plantId, limit: 20)
    }
    
    var body: some View {
        Group {
            if let plant = plant {
                ZStack {
                    AppTheme.backgroundGradient
                        .ignoresSafeArea()
                    
                    GridBackgroundView()
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        PlantDetailsHeaderView(
                            plantName: plant.name,
                            onBack: onBack,
                            onEdit: { showingEditPlant = true },
                            onDelete: { showingDeleteConfirmation = true }
                        )
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                PlantInfoCardView(plant: plant)
                                
                                StatusMessageView(plant: plant)
                                
                                ActionButtonsView(
                                    onFertilizeToday: {
                                        appViewModel.fertilizePlantToday(plant)
                                    }
                                )
                                
                                HistorySectionView(
                                    history: plantHistory,
                                    onShowAll: { showingAllHistory = true },
                                    onDeleteEntry: { entry in
                                        appViewModel.deleteHistoryEntry(entry)
                                    }
                                )
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 100)
                        }
                    }
                }
                .sheet(isPresented: $showingEditPlant) {
                    AddPlantView(appViewModel: appViewModel, plant: plant, showingSidebar: .constant(false)) {
                        showingEditPlant = false
                    }
                }
                .sheet(isPresented: $showingAllHistory) {
                    HistoryView(appViewModel: appViewModel, selectedPlantId: plant.id, showingSidebar: .constant(false))
                }
                .alert("Delete Plant", isPresented: $showingDeleteConfirmation) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        appViewModel.deletePlant(plant)
                        onBack()
                    }
                } message: {
                    Text("Are you sure you want to delete \(plant.name)? This will also delete all fertilization history for this plant.")
                }
            } else {
                ZStack {
                    AppTheme.backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Plant not found")
                            .font(.screenTitle)
                            .foregroundColor(AppTheme.primaryWhite)
                        
                        Button("Back") {
                            onBack()
                        }
                        .foregroundColor(AppTheme.primaryYellow)
                        .padding()
                    }
                }
            }
        }
    }
}

struct PlantDetailsHeaderView: View {
    let plantName: String
    let onBack: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppTheme.primaryWhite)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(AppTheme.primaryYellow.opacity(0.2))
                    )
            }
            
            Spacer()
            
            Text(plantName)
                .font(.screenTitle)
                .foregroundColor(AppTheme.primaryWhite)
                .lineLimit(1)
            
            Spacer()
            
            Menu {
                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                }
                
                Button(action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppTheme.primaryWhite)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(AppTheme.primaryYellow.opacity(0.2))
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
}

struct PlantInfoCardView: View {
    let plant: Plant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(plant.status.emoji)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(plant.status.displayName)
                        .font(.cardTitle)
                        .foregroundColor(statusColor(for: plant.status))
                    
                    Text("Days passed: \(plant.daysPassed) of \(plant.intervalDays)")
                        .font(.appCaption)
                        .foregroundColor(AppTheme.darkBlue.opacity(0.7))
                }
                
                Spacer()
            }
            
            Divider()
                .background(AppTheme.darkBlue.opacity(0.2))
            
            VStack(spacing: 12) {
                InfoRowView(
                    title: "Fertilizer Type",
                    value: plant.fertilizerType.displayName
                )
                
                InfoRowView(
                    title: "Interval",
                    value: "Every \(plant.intervalDays) days"
                )
                
                InfoRowView(
                    title: "Last Fertilized",
                    value: plant.lastFertilizedDate.formatted(date: .abbreviated, time: .omitted)
                )
                
                InfoRowView(
                    title: "Next Fertilization",
                    value: plant.nextFertilizeDate.formatted(date: .abbreviated, time: .omitted)
                )
                
                if !plant.comment.isEmpty {
                    InfoRowView(
                        title: "Comment",
                        value: plant.comment
                    )
                }
            }
        }
        .padding(20)
        .background(AppTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppTheme.shadowColor, radius: 8, x: 0, y: 4)
    }
    
    private func statusColor(for status: PlantStatus) -> Color {
        switch status {
        case .recentlyFertilized:
            return AppTheme.statusGreen
        case .soonToFertilize:
            return AppTheme.statusYellow
        case .needsFertilizing:
            return AppTheme.statusRed
        }
    }
}

struct InfoRowView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.appCaption)
                .foregroundColor(AppTheme.darkBlue.opacity(0.7))
                .frame(width: 120, alignment: .leading)
            
            Text(value)
                .font(.appBody)
                .foregroundColor(AppTheme.darkBlue)
            
            Spacer()
        }
    }
}

struct StatusMessageView: View {
    let plant: Plant
    
    var body: some View {
        HStack {
            Image(systemName: statusIcon)
                .font(.system(size: 16))
                .foregroundColor(AppTheme.primaryWhite)
            
            Text(plant.statusMessage)
                .font(.appBody)
                .foregroundColor(AppTheme.primaryWhite)
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(statusColor.opacity(0.1))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                    .stroke(statusColor.opacity(0.3), lineWidth: 1)
                }
        )
    }
    
    private var statusIcon: String {
        switch plant.status {
        case .recentlyFertilized:
            return "checkmark.circle.fill"
        case .soonToFertilize:
            return "clock.fill"
        case .needsFertilizing:
            return "exclamationmark.triangle.fill"
        }
    }
    
    private var statusColor: Color {
        switch plant.status {
        case .recentlyFertilized:
            return AppTheme.statusGreen
        case .soonToFertilize:
            return AppTheme.statusYellow
        case .needsFertilizing:
            return AppTheme.statusRed
        }
    }
}

struct ActionButtonsView: View {
    let onFertilizeToday: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: onFertilizeToday) {
                HStack {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 18))
                    
                    Text("Fertilized Today")
                        .font(.buttonMedium)
                }
                .foregroundColor(AppTheme.darkBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(AppTheme.yellowGradient)
                .cornerRadius(12)
                .shadow(color: AppTheme.shadowColor, radius: 5, x: 0, y: 2)
            }
        }
    }
}

struct HistorySectionView: View {
    let history: [FertilizationEntry]
    let onShowAll: () -> Void
    let onDeleteEntry: (FertilizationEntry) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Fertilization History")
                    .font(.cardTitle)
                    .foregroundColor(AppTheme.primaryWhite)
                
                Spacer()
            }
            
            if history.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock.circle")
                        .font(.system(size: 40))
                        .foregroundColor(AppTheme.primaryWhite.opacity(0.5))
                    
                    Text("No fertilization history yet")
                        .font(.appBody)
                        .foregroundColor(AppTheme.primaryWhite.opacity(0.7))
                    
                    Text("Mark your first fertilization manually")
                        .font(.appCaption)
                        .foregroundColor(AppTheme.primaryWhite.opacity(0.5))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppTheme.primaryWhite.opacity(0.1))
                )
            } else {
                VStack(spacing: 8) {
                    ForEach(history) { entry in
                        HistoryEntryView(
                            entry: entry,
                            onDelete: { onDeleteEntry(entry) }
                        )
                    }
                }
            }
        }
    }
}

struct HistoryEntryView: View {
    let entry: FertilizationEntry
    let onDelete: () -> Void
    
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.appBody)
                    .foregroundColor(AppTheme.darkBlue)
                
                Text(entry.fertilizerType.displayName)
                    .font(.appCaption)
                    .foregroundColor(AppTheme.darkBlue.opacity(0.7))
                
                if !entry.comment.isEmpty {
                    Text(entry.comment)
                        .font(.appCaption)
                        .foregroundColor(AppTheme.darkBlue.opacity(0.6))
                        .italic()
                }
            }
            
            Spacer()
            
            Button(action: { showingDeleteConfirmation = true }) {
                Image(systemName: "trash")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.statusRed)
            }
        }
        .padding(12)
        .background(AppTheme.cardGradient)
        .cornerRadius(8)
        .alert("Delete Entry", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this fertilization entry?")
        }
    }
}

#Preview {
    let appViewModel = AppViewModel()
    let plant = Plant(
        name: "Monstera Deliciosa",
        intervalDays: 14,
        lastFertilizedDate: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
        fertilizerType: .universal,
        comment: "Water thoroughly after fertilizing"
    )
    appViewModel.addPlant(plant)
    
    return PlantDetailsView(
        appViewModel: appViewModel,
        plantId: plant.id,
        onBack: { }
    )
}
