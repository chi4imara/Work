import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel
    @State private var selectedEntryId: EntryIdItem?
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
            
            VStack {
                HStack {
                    Text("Favorites")
                        .font(.ubuntuTitle())
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if diaryViewModel.favoriteEntries.isEmpty {
                    EmptyFavoritesView()
                } else {
                    FavoritesListView(
                        entries: diaryViewModel.favoriteEntries,
                        selectedEntryId: $selectedEntryId,
                        diaryViewModel: diaryViewModel
                    )
                }
            }
        }
        .sheet(item: $selectedEntryId) { item in
            EntryDetailView(entryId: item.id, diaryViewModel: diaryViewModel)
        }
    }
}

struct FavoritesListView: View {
    let entries: [DiaryEntry]
    @Binding var selectedEntryId: EntryIdItem?
    @ObservedObject var diaryViewModel: DiaryViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text("Your Special Moments")
                        .font(.ubuntuHeadline())
                        .foregroundColor(ColorTheme.accentText)
                    
                    Text("\(entries.count) favorite \(entries.count == 1 ? "entry" : "entries")")
                        .font(.ubuntuCaption())
                        .foregroundColor(ColorTheme.secondaryText)
                }
                .padding(.top, 20)
                
                LazyVStack(spacing: 12) {
                    ForEach(entries) { entry in
                        FavoriteEntryCard(
                            entry: entry,
                            onTap: { selectedEntryId = EntryIdItem(id: entry.id) },
                            onToggleFavorite: { diaryViewModel.toggleFavorite(entry) }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 120)
        }
    }
}

struct FavoriteEntryCard: View {
    let entry: DiaryEntry
    let onTap: () -> Void
    let onToggleFavorite: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
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
                        Image(systemName: "heart.fill")
                            .font(.title2)
                            .foregroundColor(ColorTheme.softPink)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(entry.preview)
                        .font(.ubuntuBody())
                        .foregroundColor(ColorTheme.primaryText)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4)
                    
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                            .foregroundColor(ColorTheme.primaryYellow)
                        
                        Text("Special moment")
                            .font(.ubuntuCaption())
                            .foregroundColor(ColorTheme.accentText)
                        
                        Spacer()
                    }
                }
                
                if !entry.emotions.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(entry.emotions.prefix(3), id: \.self) { emotion in
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
                        
                        if entry.emotions.count > 3 {
                            Text("+\(entry.emotions.count - 3)")
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
            .padding(20)
            .background(
                LinearGradient(
                    colors: [
                        ColorTheme.cardBackground,
                        ColorTheme.softPink.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(ColorTheme.softPink.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.softPink)
            
            VStack(spacing: 12) {
                Text("No favorites yet")
                    .font(.ubuntuHeadline())
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Save your most meaningful thoughts and moments here")
                    .font(.ubuntuBody())
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            VStack(spacing: 16) {
                Text("To add favorites:")
                    .font(.ubuntuBody())
                    .foregroundColor(ColorTheme.accentText)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Image(systemName: "1.circle.fill")
                            .foregroundColor(ColorTheme.primaryBlue)
                        Text("Create or view an entry")
                            .font(.ubuntuCaption())
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    
                    HStack(spacing: 12) {
                        Image(systemName: "2.circle.fill")
                            .foregroundColor(ColorTheme.primaryBlue)
                        Text("Tap the heart icon")
                            .font(.ubuntuCaption())
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    
                    HStack(spacing: 12) {
                        Image(systemName: "3.circle.fill")
                            .foregroundColor(ColorTheme.primaryBlue)
                        Text("Find it here in your favorites")
                            .font(.ubuntuCaption())
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(ColorTheme.cardBackground)
            .cornerRadius(16)
            .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    FavoritesView()
        .environmentObject(DiaryViewModel())
}
