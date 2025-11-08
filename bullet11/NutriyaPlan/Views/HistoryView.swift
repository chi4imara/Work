import SwiftUI

struct HistoryView: View {
    @ObservedObject var appViewModel: AppViewModel
    var selectedPlantId: UUID? = nil
    
    @State private var showingFilterSheet = false
    @State private var selectedPlantFilter: UUID? = nil
    @State private var selectedPlant: Plant?
    @State private var showingPlantDetails = false
    @Binding var showingSidebar: Bool

    private var filteredHistory: [FertilizationEntry] {
        let allHistory = appViewModel.getAllHistorySorted()
        
        if let plantId = selectedPlantFilter ?? selectedPlantId {
            return allHistory.filter { $0.plantId == plantId }
        }
        
        return allHistory
    }
    
    private var availablePlants: [Plant] {
        return appViewModel.plants.filter { plant in
            appViewModel.fertilizationHistory.contains { $0.plantId == plant.id }
        }
    }
    
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                UniversalHeaderView(
                    title: "Fertilization History",
                    onMenuTap: { showingSidebar = true },
                    rightButton: AnyView(
                        Button(action: { showingFilterSheet = true }) {
                            HStack(spacing: 4) {
                                Image(systemName: "line.3.horizontal.decrease")
                                    .font(.system(size: 16, weight: .medium))
                                
                                if selectedPlantFilter != nil {
                                    Circle()
                                        .fill(AppTheme.statusRed)
                                        .frame(width: 8, height: 8)
                                }
                            }
                            .foregroundColor(AppTheme.primaryWhite)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(AppTheme.primaryYellow.opacity(0.2))
                            )
                        }
                    )
                )
                
                if filteredHistory.isEmpty {
                    EmptyHistoryView()
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            StatisticsSummaryView(
                                history: filteredHistory,
                                plants: appViewModel.plants,
                                selectedPlantId: selectedPlantFilter
                            )
                            
                            HistoryTableView(
                                history: filteredHistory,
                                plants: appViewModel.plants,
                                onEntryTap: { entry in
                                    if let plant = appViewModel.plants.first(where: { $0.id == entry.plantId }) {
                                        selectedPlant = plant
                                        showingPlantDetails = true
                                    }
                                }
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingFilterSheet) {
            HistoryFilterSheet(
                plants: availablePlants,
                selectedPlantId: $selectedPlantFilter
            )
        }
        .sheet(item: $selectedPlant) { plant in
            PlantDetailsView(
                appViewModel: appViewModel,
                plantId: plant.id,
                onBack: {
                    showingPlantDetails = false
                    selectedPlant = nil
                }
            )
        }
        .onAppear {
            if let plantId = selectedPlantId {
                selectedPlantFilter = plantId
            }
        }
    }
}


struct StatisticsSummaryView: View {
    let history: [FertilizationEntry]
    let plants: [Plant]
    let selectedPlantId: UUID?
    
    private var totalFertilizations: Int {
        history.count
    }
    
    private var lastFertilizationDate: Date? {
        history.first?.date
    }
    
    private var mostFertilizedPlant: Plant? {
        let plantCounts = Dictionary(grouping: history, by: { $0.plantId })
            .mapValues { $0.count }
        
        guard let mostFertilizedPlantId = plantCounts.max(by: { $0.value < $1.value })?.key else {
            return nil
        }
        
        return plants.first { $0.id == mostFertilizedPlantId }
    }
    
    private var averageInterval: Double? {
        if let plantId = selectedPlantId {
            let plantEntries = history.filter { $0.plantId == plantId }.sorted { $0.date < $1.date }
            guard plantEntries.count >= 2 else { return nil }
            
            let firstDate = plantEntries.first!.date
            let lastDate = plantEntries.last!.date
            let daysDifference = Calendar.current.dateComponents([.day], from: firstDate, to: lastDate).day ?? 0
            
            return Double(daysDifference) / Double(plantEntries.count - 1)
        } else {
            var plantAverages: [Double] = []
            
            for plant in plants {
                let plantEntries = history.filter { $0.plantId == plant.id }.sorted { $0.date < $1.date }
                if plantEntries.count >= 2 {
                    let firstDate = plantEntries.first!.date
                    let lastDate = plantEntries.last!.date
                    let daysDifference = Calendar.current.dateComponents([.day], from: firstDate, to: lastDate).day ?? 0
                    let average = Double(daysDifference) / Double(plantEntries.count - 1)
                    plantAverages.append(average)
                }
            }
            
            return plantAverages.isEmpty ? nil : plantAverages.reduce(0, +) / Double(plantAverages.count)
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Summary")
                .font(.cardTitle)
                .foregroundColor(AppTheme.darkBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                StatisticRowView(
                    title: "Total Fertilizations",
                    value: "\(totalFertilizations)"
                )
                
                StatisticRowView(
                    title: "Last Fertilization",
                    value: lastFertilizationDate?.formatted(date: .abbreviated, time: .omitted) ?? "—"
                )
                
                if selectedPlantId == nil, let mostFertilized = mostFertilizedPlant {
                    StatisticRowView(
                        title: "Most Fertilized Plant",
                        value: mostFertilized.name
                    )
                }
                
                StatisticRowView(
                    title: "Average Interval",
                    value: averageInterval.map { "\(Int($0.rounded())) days" } ?? "—"
                )
            }
        }
        .padding(20)
        .background(AppTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppTheme.shadowColor, radius: 8, x: 0, y: 4)
    }
}

struct StatisticRowView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.appBody)
                .foregroundColor(AppTheme.darkBlue.opacity(0.7))
                .frame(width: 170, alignment: .leading)
            
            Spacer()
            
            Text(value)
                .font(.appBodyBold)
                .foregroundColor(AppTheme.darkBlue)
                .lineLimit(1)
        }
    }
}

struct HistoryTableView: View {
    let history: [FertilizationEntry]
    let plants: [Plant]
    let onEntryTap: (FertilizationEntry) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("History")
                .font(.cardTitle)
                .foregroundColor(AppTheme.primaryWhite)
            
            VStack(spacing: 8) {
                HStack {
                    Text("Date")
                        .font(.appCaption)
                        .foregroundColor(AppTheme.primaryWhite.opacity(0.7))
                        .frame(width: 80, alignment: .leading)
                    
                    Text("Plant")
                        .font(.appCaption)
                        .foregroundColor(AppTheme.primaryWhite.opacity(0.7))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Type")
                        .font(.appCaption)
                        .foregroundColor(AppTheme.primaryWhite.opacity(0.7))
                        .frame(width: 80, alignment: .leading)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                ForEach(history) { entry in
                    HistoryRowView(
                        entry: entry,
                        plant: plants.first { $0.id == entry.plantId },
                        onTap: { onEntryTap(entry) }
                    )
                }
            }
        }
    }
}

struct HistoryRowView: View {
    let entry: FertilizationEntry
    let plant: Plant?
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                HStack {
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.appCaption)
                        .foregroundColor(AppTheme.darkBlue)
                        .frame(width: 80, alignment: .leading)
                    
                    Text(plant?.name ?? "Unknown Plant")
                        .font(.appBody)
                        .foregroundColor(AppTheme.darkBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                    
                    Text(entry.fertilizerType.displayName)
                        .font(.appCaption)
                        .foregroundColor(AppTheme.darkBlue.opacity(0.7))
                        .frame(width: 80, alignment: .leading)
                        .lineLimit(1)
                }
                
                if !entry.comment.isEmpty {
                    HStack {
                        Text(entry.comment)
                            .font(.appSmall)
                            .foregroundColor(AppTheme.darkBlue.opacity(0.6))
                            .italic()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineLimit(2)
                    }
                    .padding(.leading, 80)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppTheme.cardGradient)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyHistoryView: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: "clock.circle")
                .font(.system(size: 80))
                .foregroundColor(AppTheme.primaryWhite.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No fertilization history")
                    .font(.screenTitle)
                    .foregroundColor(AppTheme.primaryWhite)
                
                Text("History will appear after your first fertilizations")
                    .font(.appBody)
                    .foregroundColor(AppTheme.primaryWhite.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
    }
}

struct HistoryFilterSheet: View {
    let plants: [Plant]
    @Binding var selectedPlantId: UUID?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Filter by Plant")
                            .font(.cardTitle)
                            .foregroundColor(AppTheme.primaryWhite)
                        
                        VStack(spacing: 8) {
                            FilterPlantOptionView(
                                title: "All Plants",
                                isSelected: selectedPlantId == nil,
                                action: {
                                    selectedPlantId = nil
                                }
                            )
                            
                            ForEach(plants) { plant in
                                FilterPlantOptionView(
                                    title: plant.name,
                                    isSelected: selectedPlantId == plant.id,
                                    action: {
                                        selectedPlantId = plant.id
                                    }
                                )
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if selectedPlantId != nil {
                        Button("Reset Filters") {
                            selectedPlantId = nil
                        }
                        .font(.buttonMedium)
                        .foregroundColor(AppTheme.statusRed)
                        .padding(.bottom, 20)
                    }
                }
                .padding(20)
            }
            .navigationTitle("Filter History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct FilterPlantOptionView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.appBody)
                    .foregroundColor(AppTheme.primaryWhite)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.primaryYellow)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppTheme.primaryYellow.opacity(0.1) : Color.clear)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? AppTheme.primaryYellow : Color.gray.opacity(0.3), lineWidth: 1)
                    }
            )
        }
    }
}


