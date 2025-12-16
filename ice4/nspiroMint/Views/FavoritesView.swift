import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: HobbyIdeaViewModel
    @State private var selectedIdea: HobbyIdea?
    @State private var showingIdeaDetails = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Favorites")
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                if viewModel.favoriteIdeas.isEmpty {
                    emptyStateView
                } else {
                    favoritesList
                }
            }
        }
        .sheet(item: Binding<IdeaIDWrapper?>(
            get: { selectedIdea.map(IdeaIDWrapper.init) },
            set: { selectedIdea = $0?.idea }
        )) { wrapper in
            IdeaDetailsView(viewModel: viewModel, ideaId: wrapper.id)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "heart")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.accentPink)
            
            VStack(spacing: 16) {
                Text("No favorite ideas yet")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Mark your most inspiring ideas as favorites to find them here")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.sortedFavorites) { idea in
                    FavoriteIdeaCard(idea: idea) {
                        selectedIdea = idea
                    } onRemove: {
                        viewModel.removeFavorite(idea)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

struct FavoriteIdeaCard: View {
    let idea: HobbyIdea
    let onTap: () -> Void
    let onRemove: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var dragStartOffset: CGFloat = 0
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if offset < 0 {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showingDeleteConfirmation = true
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "star.slash.fill")
                                .font(.system(size: 20, weight: .semibold))
                            Text("Unfavorite")
                                .font(.playfairDisplay(12, weight: .semibold))
                        }
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 80)
                        .frame(maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(AppColors.primaryYellow.opacity(0.9))
                        )
                    }
                    .padding(.trailing, 16)
                    .opacity(min(abs(offset) / 100.0, 1.0))
                }
            }
            
            HStack(spacing: 16) {
                VStack {
                    Image(systemName: idea.hobby.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppColors.primaryYellow)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(idea.hobby.displayName)
                            .font(.playfairDisplay(14, weight: .semibold))
                            .foregroundColor(AppColors.primaryYellow)
                        
                        Spacer()
                        
                        Text(formatDate(idea.dateCreated))
                            .font(.playfairDisplay(12, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Text(idea.title)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(2)
                    
                    Text(idea.description)
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(AppColors.secondaryText)
                        .lineLimit(3)
                    
                    HStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 12, weight: .regular))
                            .foregroundColor(AppColors.accentPink)
                        
                        Text(idea.mood)
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(AppColors.accentPink)
                        
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardGradient)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .offset(x: offset, y: 0)
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        if dragStartOffset == 0 {
                            dragStartOffset = offset
                        }
                        let newOffset = dragStartOffset + value.translation.width
                        if newOffset <= 0 {
                            offset = max(newOffset, -100)
                        }
                    }
                    .onEnded { value in
                        dragStartOffset = 0
                        if offset < -50 {
                            withAnimation(.spring()) {
                                offset = -100
                            }
                        } else {
                            withAnimation(.spring()) {
                                offset = 0
                            }
                        }
                    }
            )
            .onTapGesture {
                if offset == 0 {
                    onTap()
                } else {
                    withAnimation(.spring()) {
                        offset = 0
                    }
                }
            }
        }
        .alert("Remove from Favorites", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {
                withAnimation(.spring()) {
                    offset = 0
                }
            }
            Button("Remove", role: .destructive) {
                onRemove()
            }
        } message: {
            Text("Are you sure you want to remove this idea from favorites?")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    FavoritesView(viewModel: HobbyIdeaViewModel())
}
