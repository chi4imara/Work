import SwiftUI

struct FavoritesView: View {
    @ObservedObject var dreamStore: DreamStore
    @State private var dreamToRemove: Dream?
    @State private var showingRemoveAlert = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Favorite Dreams")
                        .font(.dreamTitle)
                        .foregroundColor(.dreamWhite)
                    
                    Spacer()
                    
                    if !dreamStore.favoriteDreams.isEmpty {
                        Text("\(dreamStore.favoriteDreams.count)")
                            .font(.dreamSubheadline)
                            .foregroundColor(.dreamYellow)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.dreamYellow.opacity(0.2))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                if dreamStore.favoriteDreams.isEmpty {
                    FavoritesEmptyStateView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(dreamStore.favoriteDreams) { dream in
                                NavigationLink(destination: DreamDetailView(dreamStore: dreamStore, dreamId: dream.id)) {
                                    FavoriteDreamCardView(dream: dream)
                                }
                                .buttonStyle(PlainButtonStyle())
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button("Remove") {
                                            dreamToRemove = dream
                                            showingRemoveAlert = true
                                        }
                                        .tint(.red)
                                    }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
        }
        .alert("Remove from Favorites", isPresented: $showingRemoveAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Remove", role: .destructive) {
                if let dream = dreamToRemove {
                    dreamStore.toggleFavorite(for: dream.id)
                }
            }
        } message: {
            Text("Are you sure you want to remove this dream from your favorites?")
        }
    }
}

struct FavoriteDreamCardView: View {
    let dream: Dream
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(dream.date, style: .date)
                    .font(.dreamSubheadline)
                    .foregroundColor(.dreamWhite)
                
                Spacer()
                
                Image(systemName: "star.fill")
                    .foregroundColor(.dreamYellow)
                    .font(.caption)
                
                if let favoriteDate = dream.favoriteDate {
                    Text("Added \(favoriteDate, style: .relative)")
                        .font(.dreamSmall)
                        .foregroundColor(.dreamWhite.opacity(0.6))
                }
            }
            
            Text(dream.description)
                .font(.dreamBody)
                .foregroundColor(.dreamWhite.opacity(0.9))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            if !dream.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(dream.tags, id: \.self) { tag in
                            TagBadgeView(tag: tag)
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.horizontal, -15)
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    Color.dreamYellow.opacity(0.1),
                    Color.cardBackground
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.dreamYellow.opacity(0.3), lineWidth: 1)
        )
    }
}

struct FavoritesEmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "star")
                .font(.system(size: 60))
                .foregroundColor(.dreamYellow.opacity(0.6))
            
            Text("No Favorite Dreams Yet")
                .font(.dreamHeadline)
                .foregroundColor(.dreamWhite)
            
            Text("Mark your most meaningful dreams as favorites to keep them easily accessible")
                .font(.dreamBody)
                .foregroundColor(.dreamWhite.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button("Browse Dreams") {
            }
            .font(.dreamSubheadline)
            .foregroundColor(.black)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.dreamYellow)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    FavoritesView(dreamStore: DreamStore())
}
