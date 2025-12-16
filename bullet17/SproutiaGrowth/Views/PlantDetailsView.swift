import SwiftUI
import Combine

struct PlantDetailsView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.presentationMode) var presentationMode
    @State private var currentPlant: PlantModel
    
    init(plant: PlantModel) {
        self._currentPlant = State(initialValue: plant)
    }
    
    @State private var showingAddEntry = false
    @State private var selectedEntry: EntryModel?
    @State private var showingEditEntry = false
    @State private var entryToDelete: EntryModel?
    @State private var showingDeleteAlert = false
    @State private var expandedEntryId: UUID?
    
    private var entries: [EntryModel] {
        dataManager.getEntries(for: currentPlant.id)
    }
    
    private var weeklyGrowth: String {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let recentEntries = entries.filter { $0.date >= weekAgo && $0.height > 0 }
        
        guard recentEntries.count >= 2 else { return "—" }
        
        let latest = recentEntries.first!.height
        let earliest = recentEntries.last!.height
        let growth = latest - earliest
        
        return growth > 0 ? "+\(String(format: "%.1f", growth)) cm" : "\(String(format: "%.1f", growth)) cm"
    }
    
    private var monthlyGrowth: String {
        let monthAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let recentEntries = entries.filter { $0.date >= monthAgo && $0.height > 0 }
        
        guard recentEntries.count >= 2 else { return "—" }
        
        let latest = recentEntries.first!.height
        let earliest = recentEntries.last!.height
        let growth = latest - earliest
        
        return growth > 0 ? "+\(String(format: "%.1f", growth)) cm" : "\(String(format: "%.1f", growth)) cm"
    }
    
    private var weeklyFrequency: String {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let recentEntries = entries.filter { $0.date >= weekAgo }
        let uniqueDays = Set(recentEntries.map { Calendar.current.startOfDay(for: $0.date) })
        
        guard !uniqueDays.isEmpty else { return "0/week" }
        
        let frequency = Double(recentEntries.count) / Double(uniqueDays.count)
        return "\(String(format: "%.1f", frequency))/week"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        summarySection
                        
                        if !entries.isEmpty {
                            miniDynamicsSection
                            entriesSection
                        } else {
                            emptyEntriesSection
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .navigationTitle(currentPlant.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEntry = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(AppColors.primaryBlue)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddEntry) {
            AddPlantEntryView(mode: .newEntry(plant: currentPlant, selectedDate: nil))
        }
        .sheet(item: $selectedEntry) { entry in
            AddPlantEntryView(mode: .editEntry(entry: entry))
        }
        .alert("Delete Entry", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let entry = entryToDelete {
                    deleteEntry(entry)
                }
            }
        } message: {
            Text("Are you sure you want to delete this entry?")
        }
        .onReceive(dataManager.$plants) { plants in
            if let updatedPlant = plants.first(where: { $0.id == currentPlant.id }) {
                currentPlant = updatedPlant
            }
        }
    }
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    if let lastDate = currentPlant.lastRecordDate {
                        Text("Last record: \(formatDate(lastDate))")
                            .font(.playfair(.regular, size: 14))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    let measurement = currentPlant.lastMeasurement
                    if measurement.height != nil || measurement.leaves != nil {
                        HStack {
                            if let height = measurement.height {
                                Text("Height: \(String(format: "%.1f", height)) cm")
                                    .font(.playfair(.medium, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                            }
                            
                            if let leaves = measurement.leaves {
                                if measurement.height != nil {
                                    Text("•")
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                Text("Leaves: \(leaves)")
                                    .font(.playfair(.medium, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                            }
                        }
                    } else {
                        Text("No measurements yet")
                            .font(.playfair(.regular, size: 16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                Spacer()
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Status")
                        .font(.playfair(.medium, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Menu {
                        ForEach(PlantStatus.allCases, id: \.self) { status in
                            Button(status.displayName) {
                                var updatedPlant = currentPlant
                                updatedPlant.status = status
                                currentPlant = updatedPlant
                                dataManager.updatePlant(updatedPlant)
                            }
                        }
                    } label: {
                        HStack {
                            Text(currentPlant.status.displayName)
                                .font(.playfair(.medium, size: 16))
                                .foregroundColor(statusColor)
                            
                            Image(systemName: "chevron.down")
                                .font(.caption)
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(statusColor.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                if let location = currentPlant.location, !location.isEmpty {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Location")
                            .font(.playfair(.medium, size: 14))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(location)
                            .font(.playfair(.regular, size: 16))
                            .foregroundColor(AppColors.primaryText)
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 4, x: 0, y: 2)
        )
    }
    
    private var miniDynamicsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Growth Dynamics")
                .font(.playfair(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Week")
                        .font(.playfair(.medium, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(weeklyGrowth)
                        .font(.playfair(.semiBold, size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(weeklyFrequency)
                        .font(.playfair(.regular, size: 12))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Month")
                        .font(.playfair(.medium, size: 14))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(monthlyGrowth)
                        .font(.playfair(.semiBold, size: 16))
                        .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 4, x: 0, y: 2)
        )
    }
    
    private var entriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Entry History")
                .font(.playfair(.semiBold, size: 18))
                .foregroundColor(AppColors.primaryText)
            
            LazyVStack(spacing: 12) {
                ForEach(entries, id: \.id) { entry in
                    EntryRowView(
                        entry: entry,
                        isExpanded: expandedEntryId == entry.id,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                expandedEntryId = expandedEntryId == entry.id ? nil : entry.id
                            }
                        },
                        onEdit: {
                            selectedEntry = entry
                            showingEditEntry = true
                        },
                        onDelete: {
                            entryToDelete = entry
                            showingDeleteAlert = true
                        }
                    )
                }
            }
        }
    }
    
    private var emptyEntriesSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text")
                .font(.system(size: 50))
                .foregroundColor(AppColors.lightBlue)
            
            VStack(spacing: 8) {
                Text("No entries yet")
                    .font(.playfair(.semiBold, size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Start tracking this plant's growth")
                    .font(.playfair(.regular, size: 14))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Button(action: { showingAddEntry = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add First Entry")
                }
                .font(.playfair(.semiBold, size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(AppColors.primaryBlue)
                .cornerRadius(20)
            }
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.3), radius: 4, x: 0, y: 2)
        )
    }
    
    private var statusColor: Color {
        switch currentPlant.status {
        case .healthy:
            return AppColors.healthyGreen
        case .needsCare:
            return AppColors.warningOrange
        case .monitoring:
            return AppColors.alertRed
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func deleteEntry(_ entry: EntryModel) {
        withAnimation {
            dataManager.deleteEntry(entry)
        }
    }
}

struct EntryRowView: View {
    let entry: EntryModel
    let isExpanded: Bool
    let onTap: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(formatDate(entry.date))
                            .font(.playfair(.medium, size: 16))
                            .foregroundColor(AppColors.primaryText)
                        
                        if !entry.shortSummary.isEmpty {
                            Text(entry.shortSummary)
                                .font(.playfair(.regular, size: 14))
                                .foregroundColor(AppColors.secondaryText)
                                .lineLimit(isExpanded ? nil : 2)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(AppColors.secondaryText)
                        .font(.caption)
                }
                .padding(16)
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .background(AppColors.lightBlue)
                    
                    if let note = entry.note, !note.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Note")
                                .font(.playfair(.medium, size: 14))
                                .foregroundColor(AppColors.secondaryText)
                            
                            Text(note)
                                .font(.playfair(.regular, size: 14))
                                .foregroundColor(AppColors.primaryText)
                        }
                    }
                    
                    HStack(spacing: 16) {
                        Button(action: onEdit) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit")
                            }
                            .font(.playfair(.medium, size: 14))
                            .foregroundColor(AppColors.primaryBlue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(AppColors.lightBlue.opacity(0.2))
                            .cornerRadius(8)
                        }
                        
                        Button(action: onDelete) {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete")
                            }
                            .font(.playfair(.medium, size: 14))
                            .foregroundColor(AppColors.alertRed)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(AppColors.alertRed.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.lightBlue.opacity(0.2), radius: 2, x: 0, y: 1)
        )
    }
}

#Preview {
    let plant = PlantModel(name: "Sample Plant")
    
    return PlantDetailsView(plant: plant)
        .environmentObject(DataManager.shared)
}
