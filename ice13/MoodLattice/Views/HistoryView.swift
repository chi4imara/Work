import SwiftUI

struct HistoryView: View {
    @ObservedObject var dataManager: MoodDataManager
    @State private var searchText = ""
    @State private var sheetItem: SheetItem?
    
    enum SheetItem: Identifiable {
        case moodDetails(date: Date)
        
        var id: String {
            switch self {
            case .moodDetails(let date):
                return "moodDetails_\(date.timeIntervalSince1970)"
            }
        }
    }
    
    private var filteredEntries: [MoodEntry] {
        dataManager.searchEntries(query: searchText)
    }
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 0) {
                searchBarView
                
                if filteredEntries.isEmpty {
                    emptyStateView
                } else {
                    entriesListView
                }
            }
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .moodDetails(let date):
                MoodDetailsView(dataManager: dataManager, entryDate: date)
            }
        }
    }
    
    private var searchBarView: some View {
        VStack(spacing: 15) {
            Text("History")
                .font(FontManager.ubuntu(size: 28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Find by note...", text: $searchText)
                    .font(FontManager.ubuntu(size: 16, weight: .regular))
                    .foregroundColor(AppColors.primaryText)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.secondaryText.opacity(0.3), lineWidth: 1)
                    }
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
    }
    
    private var entriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredEntries) { entry in
                    HistoryEntryRow(entry: entry) {
                        sheetItem = .moodDetails(date: entry.date)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            if searchText.isEmpty {
                VStack(spacing: 15) {
                    Image(systemName: "clock")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(AppColors.secondaryText.opacity(0.6))
                    
                    Text("History will appear after the first mood entry")
                        .font(FontManager.ubuntu(size: 18, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            } else {
                VStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 60, weight: .light))
                        .foregroundColor(AppColors.secondaryText.opacity(0.6))
                    
                    Text("Nothing found")
                        .font(FontManager.ubuntu(size: 20, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Try a different search term")
                        .font(FontManager.ubuntu(size: 16, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Button {
                        searchText = ""
                    } label: {
                        Text("Reset")
                            .font(FontManager.ubuntu(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(AppColors.accent)
                            .cornerRadius(20)
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct HistoryEntryRow: View {
    let entry: MoodEntry
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.dateString)
                        .font(FontManager.ubuntu(size: 14, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(entry.dayOfWeek)
                        .font(FontManager.ubuntu(size: 12, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(width: 80, alignment: .leading)
                
                Text(entry.mood.rawValue)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.mood.name)
                        .font(FontManager.ubuntu(size: 14, weight: .bold))
                        .foregroundColor(moodColor)
                    
                    Text(entry.shortNote)
                        .font(FontManager.ubuntu(size: 14, weight: .regular))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText.opacity(0.6))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.shadowColor, radius: 5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var moodColor: Color {
        switch entry.mood {
        case .happy:
            return AppColors.happyMood
        case .calm:
            return AppColors.calmMood
        case .neutral:
            return AppColors.neutralMood
        case .sad:
            return AppColors.sadMood
        case .angry:
            return AppColors.angryMood
        }
    }
}

#Preview {
    HistoryView(dataManager: MoodDataManager())
}
