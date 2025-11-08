import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: InteriorIdeasViewModel
    @State private var selectedIdea: InteriorIdea?
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("Favorite Ideas")
                            .font(AppFonts.title1())
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        if !viewModel.favoriteIdeas.isEmpty {
                            Text("\(viewModel.favoriteIdeas.count)")
                                .font(AppFonts.subheadline())
                                .foregroundColor(AppColors.primaryOrange)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(AppColors.primaryOrange.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                    if viewModel.favoriteIdeas.isEmpty {
                        EmptyFavoritesView(selectedTab: $selectedTab)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.favoriteIdeas) { idea in
                                    FavoriteIdeaCardView(
                                        idea: idea,
                                        onTap: { selectedIdea = idea },
                                        onRemoveFromFavorites: { 
                                            viewModel.toggleFavorite(for: idea)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $selectedIdea) { idea in
            IdeaDetailView(viewModel: viewModel, idea: idea)
        }
    }
}

struct FavoriteIdeaCardView: View {
    let idea: InteriorIdea
    let onTap: () -> Void
    let onRemoveFromFavorites: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingRemoveAlert = false
    @State private var isSwiped = false
    
    private let swipeThreshold: CGFloat = 80
    private let maxSwipeDistance: CGFloat = 120
    
    var body: some View {
        ZStack {
            if offset.width < 0 {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "star.slash")
                            .font(.system(size: 20, weight: .medium))
                        Text("Remove")
                            .font(AppFonts.caption())
                    }
                    .foregroundColor(.white)
                    .frame(width: 80)
                    .padding(.trailing, 16)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppColors.primaryOrange.opacity(0.8))
                .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(idea.title)
                            .font(AppFonts.headline())
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(1)
                        
                        Text(idea.category.rawValue)
                            .font(AppFonts.caption())
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.primaryOrange)
                }
                
                if !idea.notePreview.isEmpty {
                    Text(idea.notePreview)
                        .font(AppFonts.body())
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.tertiaryText)
                    
                    Text("Added \(formatRelativeDate(idea.dateModified))")
                        .font(AppFonts.caption2())
                        .foregroundColor(AppColors.tertiaryText)
                    
                    Spacer()
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppGradients.cardGradient)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.cardBorder, lineWidth: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.primaryOrange.opacity(0.3), lineWidth: 2)
            )
            .offset(x: offset.width, y: 0)
            .contentShape(Rectangle())
            .highPriorityGesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .onChanged { value in
                        withAnimation(.interactiveSpring(response: 0.3)) {
                            offset.width = min(value.translation.width, 0)
                            if offset.width < -maxSwipeDistance {
                                offset.width = -maxSwipeDistance
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if value.translation.width < -swipeThreshold {
                                offset.width = -maxSwipeDistance
                                isSwiped = true
                                showingRemoveAlert = true
                            } else {
                                resetCard()
                            }
                        }
                    }
            )
            .onTapGesture {
                if isSwiped {
                    resetCard()
                } else {
                    onTap()
                }
            }
        }
        .alert("Remove from Favorites", isPresented: $showingRemoveAlert) {
            Button("Cancel", role: .cancel) {
                resetCard()
            }
            Button("Remove", role: .destructive) {
                onRemoveFromFavorites()
                resetCard()
            }
        } message: {
            Text("Are you sure you want to remove this idea from favorites?")
        }
        .onChange(of: showingRemoveAlert) { showing in
            if !showing && isSwiped {
                resetCard()
            }
        }
    }
    
    private func resetCard() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            offset = .zero
            isSwiped = false
        }
    }
    
    private func formatRelativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct EmptyFavoritesView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardBackground)
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(AppColors.cardBorder, lineWidth: 1)
                    )
                
                Image(systemName: "star")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            VStack(spacing: 12) {
                Text("No Favorite Ideas")
                    .font(AppFonts.title2())
                    .foregroundColor(AppColors.primaryText)
                
                Text("You haven't marked any ideas as favorites yet. Tap the star icon on any idea to add it here.")
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            Button {
                selectedTab = 0
            } label: {
                Text("Browse Ideas")
                    .font(AppFonts.button())
                    .foregroundColor(AppColors.primaryWhite)
                    .frame(width: 200, height: 50)
                    .background(AppGradients.buttonGradient)
                    .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}
