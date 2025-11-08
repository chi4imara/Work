import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var viewModel: VictoryViewModel
    @State private var selectedVictory: Victory?
    @State private var showingVictoryDetail = false
    @State private var editingVictory: Victory?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackgroundView()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.favoriteVictories.isEmpty {
                        emptyStateView
                    } else {
                        favoritesListView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $selectedVictory) { victory in
                VictoryDetailView(victory: victory, editingVictory: $editingVictory)
                    .environmentObject(viewModel)
        }
        .sheet(item: $editingVictory) { victory in
            EditVictoryView(victory: victory) {
                editingVictory = nil
            }
            .environmentObject(viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Favorite Victories")
                    .font(AppFonts.title1)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("\(viewModel.favoriteVictories.count) favorites")
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "star.fill")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.accent)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var favoritesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.favoriteVictories) { victory in
                    FavoriteVictoryCard(victory: victory)
                        .onTapGesture {
                            selectedVictory = victory
                            showingVictoryDetail = true
                        }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(AppColors.accent.opacity(0.3), lineWidth: 3)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "star")
                    .font(.system(size: 48, weight: .light))
                    .foregroundColor(AppColors.accent.opacity(0.6))
            }
            
            VStack(spacing: 12) {
                Text("No Favorite Victories")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Mark victories as favorites from your history or calendar to see them here. Tap the star icon on any victory to add it to favorites.")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

struct FavoriteVictoryCard: View {
    let victory: Victory
    @EnvironmentObject var viewModel: VictoryViewModel
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(victory.dateString)
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Victory")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.toggleFavorite(victory)
                    }
                }) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(AppColors.accent)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                }
            }
            
            Text(victory.text)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(nil)
            
            HStack(spacing: 12) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.toggleFavorite(victory)
                    }
                }) {
                    HStack {
                        Image(systemName: "star.slash")
                            .font(.system(size: 14, weight: .bold))
                        Text("Remove")
                            .font(AppFonts.pixelCaption)
                    }
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 0)
                            .stroke(AppColors.textSecondary.opacity(0.3), lineWidth: 1)
                    )
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("Tap to view")
                        .font(AppFonts.caption2)
                        .foregroundColor(AppColors.textSecondary.opacity(0.7))
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(AppColors.textSecondary.opacity(0.7))
                }
            }
        }
        .padding(20)
        .background(
            ZStack {
                AppColors.cardGradient
                
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "star.fill")
                            .font(.system(size: 8))
                            .foregroundColor(AppColors.accent.opacity(0.1))
                            .offset(x: -20, y: 10)
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 6))
                            .foregroundColor(AppColors.accent.opacity(0.1))
                            .offset(x: 20, y: -10)
                        Spacer()
                    }
                }
            }
        )
        .cornerRadius(0)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(
                    LinearGradient(
                        colors: [AppColors.accent.opacity(0.3), AppColors.primary.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: AppColors.accent.opacity(0.1), radius: 8, x: 0, y: 4)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(VictoryViewModel())
}
