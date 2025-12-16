import SwiftUI

struct OutfitListView: View {
    @StateObject private var viewModel = OutfitListViewModel()
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddOutfit = false
    @State private var showingFilterSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.mainBackgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        HStack {
                            Text("My Outfits")
                                .font(.ubuntu(32, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Button(action: { showingAddOutfit = true }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(AppColors.primaryPurple)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(AppColors.primaryYellow)
                                    )
                            }
                        }
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(AppColors.secondaryText)
                            
                            TextField("Search by name or description...", text: $viewModel.searchText)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.primaryText)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardBackground)
                        )
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(OutfitFilter.allCases, id: \.self) { filter in
                                    FilterChip(
                                        title: filter.displayName,
                                        isSelected: viewModel.selectedFilter == filter
                                    ) {
                                        viewModel.selectedFilter = filter
                                        if filter == .season || filter == .mood {
                                            showingFilterSheet = true
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.horizontal, -20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if viewModel.filteredOutfits.isEmpty {
                        EmptyStateView(
                            icon: "tshirt",
                            title: dataManager.outfits.isEmpty ? "No Outfits Yet" : "No Results",
                            description: dataManager.outfits.isEmpty ?
                            "Add your first outfit — the one you always feel comfortable in!" :
                                "Try adjusting your search or filters"
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.filteredOutfits) { outfit in
                                    NavigationLink(destination: OutfitDetailView(outfit: outfit)) {
                                        OutfitCard(outfit: outfit, viewModel: viewModel)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 120)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddOutfit) {
            AddEditOutfitView()
        }
        .sheet(isPresented: $showingFilterSheet) {
            FilterSheet(viewModel: viewModel)
        }
    }
}

struct OutfitCard: View {
    let outfit: Outfit
    let viewModel: OutfitListViewModel
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(outfit.name)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                    
                    HStack(spacing: 8) {
                        Text(outfit.mood.displayName)
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(AppColors.primaryPurple)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(AppColors.primaryYellow.opacity(0.3))
                            )
                        
                        Text(outfit.season.displayName)
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                Spacer()
                
                Button(action: { viewModel.toggleFavorite(outfit) }) {
                    Image(systemName: outfit.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 20))
                        .foregroundColor(outfit.isFavorite ? AppColors.favoriteHeart : AppColors.secondaryText)
                }
            }
            
            if !outfit.comment.isEmpty {
                Text(outfit.comment)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .contextMenu {
            Button(action: { viewModel.toggleFavorite(outfit) }) {
                Label(outfit.isFavorite ? "Remove from Favorites" : "Add to Favorites", 
                      systemImage: outfit.isFavorite ? "heart.slash" : "heart")
            }
            
            Button(action: { showingDeleteAlert = true }) {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Delete Outfit", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteOutfit(outfit)
            }
        } message: {
            Text("Are you sure you want to delete this outfit?")
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(14, weight: isSelected ? .medium : .regular))
                .foregroundColor(isSelected ? AppColors.primaryPurple : AppColors.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? AppColors.primaryYellow : AppColors.cardBackground)
                )
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

struct FilterSheet: View {
    @ObservedObject var viewModel: OutfitListViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if viewModel.selectedFilter == .season {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Select Season")
                            .font(.ubuntu(20, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(Season.allCases, id: \.self) { season in
                                Button(action: { viewModel.selectedSeason = season }) {
                                    Text(season.displayName)
                                        .font(.ubuntu(16))
                                        .foregroundColor(viewModel.selectedSeason == season ? AppColors.primaryPurple : AppColors.primaryText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(viewModel.selectedSeason == season ? AppColors.primaryYellow : AppColors.cardBackground)
                                        )
                                }
                            }
                        }
                    }
                } else if viewModel.selectedFilter == .mood {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Select Mood")
                            .font(.ubuntu(20, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(Mood.allCases, id: \.self) { mood in
                                Button(action: { viewModel.selectedMood = mood }) {
                                    Text(mood.displayName)
                                        .font(.ubuntu(16))
                                        .foregroundColor(viewModel.selectedMood == mood ? AppColors.primaryPurple : AppColors.primaryText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(viewModel.selectedMood == mood ? AppColors.primaryYellow : AppColors.cardBackground)
                                        )
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding(20)
            .background(AppColors.mainBackgroundGradient.ignoresSafeArea())
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                }
            }
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 12) {
                Text(title)
                    .font(.ubuntu(24, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text(description)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    OutfitListView()
        .environmentObject(DataManager.shared)
}
