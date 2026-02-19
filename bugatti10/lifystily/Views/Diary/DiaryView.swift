import SwiftUI

struct DiaryView: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel
    @State private var showingNewEntry = false
    @State private var selectedEntryId: EntryIdItem?
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Diary")
                        .font(.ubuntuTitle())
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    Button(action: { showingNewEntry = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(ColorTheme.primaryBlue)
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
                
                SearchAndFilterSection(diaryViewModel: diaryViewModel)
                
                if diaryViewModel.filteredEntries.isEmpty {
                    EmptyStateView(showingNewEntry: $showingNewEntry)
                } else {
                    EntriesListView(
                        entries: diaryViewModel.filteredEntries,
                        selectedEntryId: $selectedEntryId,
                        diaryViewModel: diaryViewModel
                    )
                }
            }
        }
        .sheet(isPresented: $showingNewEntry) {
            NewEntryView(diaryViewModel: diaryViewModel)
        }
        .sheet(item: $selectedEntryId) { item in
            EntryDetailView(entryId: item.id, diaryViewModel: diaryViewModel)
        }
    }
}

struct SearchAndFilterSection: View {
    @ObservedObject var diaryViewModel: DiaryViewModel
    @State private var showingMoodFilter = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(ColorTheme.secondaryText)
                
                TextField("Search your thoughts...", text: $diaryViewModel.searchText)
                    .font(.ubuntuBody())
                
                if !diaryViewModel.searchText.isEmpty {
                    Button(action: { diaryViewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                }
            }
            .padding(12)
            .background(Color.white.opacity(0.8))
            .cornerRadius(12)
            
            HStack {
                Button(action: { showingMoodFilter.toggle() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(ColorTheme.primaryBlue)
                        
                        Text(diaryViewModel.selectedMoodFilter?.displayName ?? "Filter by mood")
                            .font(.ubuntuBody())
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .foregroundColor(ColorTheme.secondaryText)
                            .rotationEffect(.degrees(showingMoodFilter ? 180 : 0))
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(12)
                }
                
                if diaryViewModel.selectedMoodFilter != nil {
                    Button("Clear") {
                        diaryViewModel.selectedMoodFilter = nil
                    }
                    .font(.ubuntuCaption())
                    .foregroundColor(ColorTheme.primaryBlue)
                }
            }
            
            if showingMoodFilter {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    ForEach(MoodType.allCases, id: \.self) { mood in
                        Button(action: {
                            diaryViewModel.selectedMoodFilter = mood
                            showingMoodFilter = false
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: mood.icon)
                                    .font(.caption)
                                    .foregroundColor(mood.color)
                                
                                Text(mood.displayName)
                                    .font(.ubuntuCaption())
                                    .foregroundColor(ColorTheme.primaryText)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8)
                        }
                    }
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(ColorTheme.cardBackground)
        .animation(.easeInOut(duration: 0.3), value: showingMoodFilter)
    }
}

struct EntriesListView: View {
    let entries: [DiaryEntry]
    @Binding var selectedEntryId: EntryIdItem?
    @ObservedObject var diaryViewModel: DiaryViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(entries) { entry in
                    EntryCardView(
                        entry: entry,
                        onTap: { selectedEntryId = EntryIdItem(id: entry.id) },
                        onToggleFavorite: { diaryViewModel.toggleFavorite(entry) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .padding(.bottom, 120)
        }
    }
}

struct EntryCardView: View {
    let entry: DiaryEntry
    let onTap: () -> Void
    let onToggleFavorite: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.formattedDate)
                            .font(.ubuntuCaption())
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        if let mood = entry.mood {
                            HStack(spacing: 6) {
                                Image(systemName: mood.icon)
                                    .font(.caption)
                                    .foregroundColor(mood.color)
                                
                                Text(mood.displayName)
                                    .font(.ubuntuCaption())
                                    .foregroundColor(ColorTheme.primaryText)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: onToggleFavorite) {
                        Image(systemName: entry.isFavorite ? "heart.fill" : "heart")
                            .font(.title3)
                            .foregroundColor(entry.isFavorite ? ColorTheme.softPink : ColorTheme.secondaryText)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text(entry.preview)
                    .font(.ubuntuBody())
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                if !entry.emotions.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(entry.emotions.prefix(4), id: \.self) { emotion in
                            HStack(spacing: 4) {
                                Image(systemName: emotion.icon)
                                    .font(.caption2)
                                    .foregroundColor(emotion.color)
                                
                                Text(emotion.displayName)
                                    .font(.system(size: 10))
                                    .foregroundColor(ColorTheme.primaryText)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(emotion.color.opacity(0.2))
                            .cornerRadius(8)
                        }
                        
                        if entry.emotions.count > 4 {
                            Text("+\(entry.emotions.count - 4)")
                                .font(.system(size: 10))
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                    }
                }
                
                if entry.photoData != nil {
                    HStack {
                        Image(systemName: "photo")
                            .font(.caption)
                            .foregroundColor(ColorTheme.primaryBlue)
                        
                        Text("Photo attached")
                            .font(.ubuntuCaption())
                            .foregroundColor(ColorTheme.secondaryText)
                        
                        Spacer()
                    }
                }
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .cornerRadius(16)
            .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyStateView: View {
    @Binding var showingNewEntry: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.primaryBlue)
            
            VStack(spacing: 12) {
                Text("Your thoughts will appear here")
                    .font(.ubuntuHeadline())
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Start with your first entry")
                    .font(.ubuntuBody())
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingNewEntry = true }) {
                Text("Create First Entry")
                    .font(.ubuntuHeadline())
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(ColorTheme.primaryBlue)
                    .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    DiaryView()
        .environmentObject(DiaryViewModel())
}
