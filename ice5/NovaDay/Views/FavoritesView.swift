import SwiftUI

struct FavoritesView: View {
    @ObservedObject var memoryStore: MemoryStore
    @Binding var selectedTab: Int
    
    var body: some View {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Favorite Days")
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if memoryStore.favoriteMemories.isEmpty {
                        emptyStateView
                        
                        Spacer()
                    } else {
                        favoritesList
                    }
                }
            }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "star")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow.opacity(0.6))
            
            Text("No favorite days yet")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Text("Mark special memories as favorites to see them here")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                withAnimation {
                    selectedTab = 0
                }
            }) {
                HStack {
                    Image(systemName: "house.fill")
                    Text("Go to Today")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(AppColors.primaryBlue)
                .cornerRadius(20)
            }
            
            Spacer()
        }
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(memoryStore.favoriteMemories) { memory in
                    FavoriteMemoryCardView(memory: memory, memoryStore: memoryStore)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

struct FavoriteMemoryCardView: View {
    let memory: Memory
    @ObservedObject var memoryStore: MemoryStore
    @State private var showingDetails = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        Button(action: { showingDetails = true }) {
            HStack(spacing: 16) {
                Text(memory.mood)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(DateFormatter.mediumDate.string(from: memory.date))
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Text(memory.title)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Text(memory.description)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "star.fill")
                    .foregroundColor(AppColors.primaryYellow)
                    .font(.system(size: 20))
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: { memoryStore.toggleFavorite(memory) }) {
                Label("Remove from Favorites", systemImage: "star.slash")
            }
            
            Button(action: { showingDeleteAlert = true }) {
                Label("Delete Memory", systemImage: "trash")
            }
        }
        .sheet(isPresented: $showingDetails) {
            MemoryDetailView(memoryID: memory.id, memoryStore: memoryStore)
        }
        .alert("Delete Memory", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                memoryStore.deleteMemory(memory)
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this memory? This action cannot be undone.")
        }
    }
}

extension DateFormatter {
    static let mediumDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
}
