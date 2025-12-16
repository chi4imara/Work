import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: BeautyDiaryViewModel
    @State private var selectedEntry: BeautyEntry?
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.hasFavoriteEntries {
                    favoritesListView
                } else {
                    emptyStateView
                }
            }
        }
        .sheet(item: $selectedEntry) { entry in
            EntryDetailView(viewModel: viewModel, entry: entry)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Favorites")
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                if viewModel.hasFavoriteEntries {
                    Text("\(viewModel.favoriteEntries.count)")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(Color.theme.primaryBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.theme.primaryBlue.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            if viewModel.hasFavoriteEntries {
                Text("Your favorite beauty routines")
                    .font(.playfairDisplay(14))
                    .foregroundColor(Color.theme.secondaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 16)
    }
    
    private var favoritesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.favoriteEntries) { entry in
                    FavoriteEntryCardView(
                        entry: entry,
                        viewModel: viewModel
                    ) {
                        selectedEntry = entry
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.lightGray)
            
            Text("No favorites yet")
                .font(.playfairDisplay(24, weight: .semibold))
                .foregroundColor(Color.theme.primaryText)
            
            Text("Mark entries as favorites to see them here. Tap the heart icon on any entry to add it to favorites.")
                .font(.playfairDisplay(16))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct FavoriteEntryCardView: View {
    let entry: BeautyEntry
    @ObservedObject var viewModel: BeautyDiaryViewModel
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(entry.procedureName)
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.toggleFavorite(for: entry)
                        }) {
                            Image(systemName: entry.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 20))
                                .foregroundColor(entry.isFavorite ? Color.theme.accentPink : Color.theme.lightGray)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Text(entry.products)
                        .font(.playfairDisplay(14))
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(2)
                    
                    HStack {
                        Text(entry.formattedDate)
                            .font(.playfairDisplay(12))
                            .foregroundColor(Color.theme.secondaryText)
                        
                        if entry.hasNotes {
                            Text("•")
                                .font(.playfairDisplay(12))
                                .foregroundColor(Color.theme.secondaryText)
                            
                            Text("Has notes")
                                .font(.playfairDisplay(12))
                                .foregroundColor(Color.theme.accentText)
                        }
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(16)
            .background(Color.theme.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.theme.cardShadow, radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FavoritesView(viewModel: BeautyDiaryViewModel())
}
