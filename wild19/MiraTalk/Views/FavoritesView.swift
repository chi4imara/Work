import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selectedFavorite: FavoriteQuestion?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if viewModel.favorites.isEmpty {
                        emptyStateView
                    } else {
                        favoritesListView
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(item: $selectedFavorite) { favorite in
            FavoriteQuestionDetailView(favorite: favorite, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Favorites")
                .font(.playfairDisplay(size: 28, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            if !viewModel.favorites.isEmpty {
                Text("\(viewModel.favorites.count) saved")
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.lightGray)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var favoritesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.favorites) { favorite in
                    FavoriteQuestionCard(
                        favorite: favorite,
                        onTap: {
                            selectedFavorite = favorite
                        },
                        onDelete: {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                viewModel.removeFromFavorites(favorite: favorite)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .padding(.bottom, 80)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "heart")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.accentPink.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No Favorites Yet")
                    .font(.playfairDisplay(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Questions you save will appear here. Start by exploring questions and adding your favorites!")
                    .font(.playfairDisplay(size: 16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FavoriteQuestionCard: View {
    let favorite: FavoriteQuestion
    let onTap: () -> Void
    let onDelete: () -> Void
    @State private var showingDeleteConfirmation = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: favorite.question.category.icon)
                        .font(.system(size: 12, weight: .medium))
                    Text(favorite.question.category.displayName)
                        .font(.playfairDisplay(size: 12, weight: .medium))
                    
                    Spacer()
                    
                    Text("Added \(dateFormatter.string(from: favorite.dateAdded))")
                        .font(.playfairDisplay(size: 11, weight: .regular))
                        .foregroundColor(AppColors.secondaryText.opacity(0.7))
                }
                .foregroundColor(AppColors.primaryBlue)
                
                Text(favorite.question.text)
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                HStack(spacing: 12) {
                    Button(action: {
                        UIPasteboard.general.string = favorite.question.text
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "doc.on.clipboard")
                                .font(.system(size: 12, weight: .medium))
                            Text("Copy")
                                .font(.playfairDisplay(size: 12, weight: .medium))
                        }
                        .foregroundColor(AppColors.primaryBlue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppColors.primaryBlue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.accentPink)
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .confirmationDialog("Delete Favorite", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to remove this question from your favorites?")
        }
    }
}

struct FavoriteQuestionDetailView: View {
    let favorite: FavoriteQuestion
    @ObservedObject var viewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    VStack(spacing: 16) {
                        HStack {
                            Image(systemName: favorite.question.category.icon)
                                .font(.system(size: 16, weight: .medium))
                            Text(favorite.question.category.displayName)
                                .font(.playfairDisplay(size: 16, weight: .medium))
                        }
                        .foregroundColor(AppColors.primaryBlue)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(AppColors.primaryBlue.opacity(0.1))
                        .cornerRadius(25)
                        
                        Text("Added on \(dateFormatter.string(from: favorite.dateAdded))")
                            .font(.playfairDisplay(size: 14, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Text(favorite.question.text)
                        .font(.playfairDisplay(size: 28, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            UIPasteboard.general.string = favorite.question.text
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "doc.on.clipboard")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Copy Question")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                            }
                            .foregroundColor(AppColors.primaryWhite)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.primaryYellow, AppColors.primaryYellow.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(28)
                            .shadow(color: AppColors.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        
                        Button(action: {
                            viewModel.removeFromFavorites(favorite: favorite)
                            dismiss()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "heart.slash")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Remove from Favorites")
                                    .font(.playfairDisplay(size: 18, weight: .semibold))
                            }
                            .foregroundColor(AppColors.accentPink)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.primaryWhite)
                            .overlay(
                                RoundedRectangle(cornerRadius: 28)
                                    .stroke(AppColors.accentPink.opacity(0.3), lineWidth: 1)
                            )
                            .cornerRadius(28)
                            .shadow(color: AppColors.accentPink.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.top, 40)
                .padding(.bottom, 40)
            }
            .navigationTitle("Favorite Question")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
    }
}

#Preview {
    FavoritesView(viewModel: AppViewModel())
}
