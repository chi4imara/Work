import SwiftUI

struct ArchiveView: View {
    @ObservedObject var dataManager: EmotionDataManager
    @State private var showDeleteAlert = false
    @State private var entryToDelete: EmotionEntry?
    @State private var selectedEntry: EmotionEntry?
    @State private var showFiltersView = false
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Emotion Archive")
                        .font(.poppinsBold(size: 24))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        showFiltersView = true
                    }) {
                        Text("Filters")
                            .font(.poppinsMedium(size: 16))
                            .foregroundColor(AppColors.primaryBlue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(AppColors.accentYellow)
                            .cornerRadius(20)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                if dataManager.filteredEntries.isEmpty {
                    EmptyStateView(isFiltered: dataManager.isFiltered) {
                        dataManager.clearFilters(useArchived: true)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(dataManager.filteredEntries) { entry in
                                EmotionEntryCard(entry: entry) {
                                    selectedEntry = entry
                                } onDelete: {
                                    entryToDelete = entry
                                    showDeleteAlert = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedEntry) { entry in
            EntryDetailView(entry: entry, dataManager: dataManager)
        }
        .sheet(isPresented: $showFiltersView) {
            FiltersView(dataManager: dataManager)
        }
        .onAppear {
            dataManager.clearFilters(useArchived: true)
        }
        .alert("Delete Entry", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete Permanently", role: .destructive) {
                if let entry = entryToDelete {
                    dataManager.deleteFromArchive(entry)
                    dataManager.clearFilters(useArchived: true)
                    entryToDelete = nil
                }
            }
        } message: {
            Text("This will permanently delete the entry from the archive. This action cannot be undone.")
        }
    }
}

struct EmotionEntryCard: View {
    let entry: EmotionEntry
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: entry.emotion.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(AppColors.accentYellow)
                    .frame(width: 40, height: 40)
                    .background(AppColors.accentYellow.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(DateFormatter.displayFormatter.string(from: entry.date))
                        .font(.poppinsMedium(size: 16))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(entry.emotion.title)
                        .font(.poppinsRegular(size: 14))
                        .foregroundColor(AppColors.accentYellow)
                    
                    Text(entry.reason)
                        .font(.poppinsRegular(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.primaryText.opacity(0.6))
            }
            .padding(16)
            .background(AppColors.cardBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct EmptyStateView: View {
    let isFiltered: Bool
    let onClearFilters: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "archivebox")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryText.opacity(0.6))
            
            VStack(spacing: 12) {
                Text(isFiltered ? "No Matching Entries" : "No Entries Yet")
                    .font(.poppinsBold(size: 20))
                    .foregroundColor(AppColors.primaryText)
                
                Text(isFiltered ? "No entries found for the selected filters" : "You haven't added any emotion entries yet")
                    .font(.poppinsRegular(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            if isFiltered {
                Button(action: onClearFilters) {
                    Text("Clear Filters")
                        .font(.poppinsMedium(size: 16))
                        .foregroundColor(AppColors.primaryBlue)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppColors.accentYellow)
                        .cornerRadius(20)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    ArchiveView(dataManager: EmotionDataManager(), selectedTab: .constant(.archive))
}
