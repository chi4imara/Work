import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var makeupStore: MakeupStore
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if makeupStore.favoriteIdeas.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    favoritesList
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Favorites")
                .font(.bauhausBold(28))
                .foregroundColor(AppColors.white)
            
            Spacer()
            
            if !makeupStore.favoriteIdeas.isEmpty {
                Text("\(makeupStore.favoriteIdeas.count)")
                    .font(.bauhausMedium(16))
                    .foregroundColor(AppColors.purple)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(AppColors.white.opacity(0.9))
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart")
                .font(.system(size: 60))
                .foregroundColor(AppColors.white.opacity(0.6))
            
            Text("No favorite ideas yet.")
                .font(.bauhausMedium(18))
                .foregroundColor(AppColors.white)
                .multilineTextAlignment(.center)
            
            Text("Add ideas to favorites by tapping the heart icon in idea details.")
                .font(.bauhausLight(14))
                .foregroundColor(AppColors.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(makeupStore.favoriteIdeas) { idea in
                    NavigationLink(destination: IdeaDetailView(ideaId: idea.id)) {
                        FavoriteIdeaCard(idea: idea)
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

struct FavoriteIdeaCard: View {
    let idea: MakeupIdea
    @EnvironmentObject var makeupStore: MakeupStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                if let image = idea.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .clipped()
                        .cornerRadius(12)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.mediumGray.opacity(0.3))
                        .frame(height: 120)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 30))
                                .foregroundColor(AppColors.mediumGray)
                        )
                }
                
                Button(action: { makeupStore.toggleFavorite(idea) }) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.purple)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(AppColors.white.opacity(0.9))
                        )
                }
                .padding(8)
            }
            
            Text(idea.title)
                .font(.bauhausMedium(16))
                .foregroundColor(AppColors.darkGray)
                .lineLimit(2)
            
            if !idea.displayTags.isEmpty {
                HStack {
                    ForEach(idea.displayTags, id: \.self) { tag in
                        Text(tag)
                            .font(.bauhausLight(12))
                            .foregroundColor(AppColors.purple)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.purple.opacity(0.1))
                            )
                    }
                    Spacer()
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.darkGray.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
            .environmentObject(MakeupStore())
    }
}
