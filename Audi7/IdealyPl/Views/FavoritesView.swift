import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: IdeasViewModel
    @State private var selectedIdeaId: UUID?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Favorites")
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            if viewModel.hasFavoriteIdeas {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.favoriteIdeas) { idea in
                            FavoriteIdeaCard(idea: idea, viewModel: viewModel) {
                                selectedIdeaId = idea.id
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            } else {
                VStack(spacing: 30) {
                    Spacer()
                    
                    Image(systemName: "heart")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.accentYellow.opacity(0.6))
                    
                    VStack(spacing: 16) {
                        Text("No favorite ideas yet")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Tap the heart icon on any idea to add it to your favorites.")
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
            }
        }
        .sheet(isPresented: Binding(
            get: { selectedIdeaId != nil },
            set: { if !$0 { selectedIdeaId = nil } }
        )) {
            if let ideaId = selectedIdeaId {
                IdeaDetailView(ideaId: ideaId, viewModel: viewModel)
            }
        }
    }
}

struct FavoriteIdeaCard: View {
    let idea: Idea
    @ObservedObject var viewModel: IdeasViewModel
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                withAnimation {
                    viewModel.toggleFavorite(ideaId: idea.id)
                }
            }) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.accentYellow)
            }
            
            Button(action: onTap) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(idea.preview)
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        
                        Text(idea.formattedDate)
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(16)
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.accentYellow.opacity(0.3), lineWidth: 1)
        )
    }
}
