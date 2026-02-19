import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    
    var favoriteBags: [Bag] {
        bagViewModel.getFavoriteBags()
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("Favorites")
                        .font(.bellGothic(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if favoriteBags.isEmpty {
                    EmptyFavoritesView()
                    
                    Spacer()
                } else {
                    FavoritesListView(bags: favoriteBags)
                }
            }
        }
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "heart")
                .font(.system(size: 80))
                .foregroundColor(AppColors.yellow.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No favorites yet")
                    .font(.bellGothic(size: 24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add bags to favorites by tapping the heart icon on any bag")
                    .font(.bellGothic(size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
    }
}

struct FavoritesListView: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    let bags: [Bag]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(bags) { bag in
                    NavigationLink(destination: BagDetailView(bagId: bag.id).environmentObject(bagViewModel)) {
                        FavoriteBagCard(bag: bag)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
}

struct FavoriteBagCard: View {
    @EnvironmentObject var bagViewModel: BagViewModel
    let bag: Bag
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: bag.type.icon)
                    .font(.title2)
                    .foregroundColor(AppColors.yellow)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(bag.name.isEmpty ? "Unnamed Bag" : bag.name)
                        .font(.bellGothic(size: 18, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(bag.type.displayName)
                        .font(.bellGothic(size: 14))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Spacer()
                
                Button(action: {
                    bagViewModel.toggleFavorite(bagId: bag.id)
                }) {
                    Image(systemName: bagViewModel.isFavorite(bagId: bag.id) ? "heart.fill" : "heart")
                        .font(.title3)
                        .foregroundColor(bagViewModel.isFavorite(bagId: bag.id) ? AppColors.error : AppColors.secondaryText)
                }
            }
            
            if !bag.description.isEmpty {
                Text(bag.description)
                    .font(.bellGothic(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(2)
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 12))
                    Text("\(bag.items.count) items")
                        .font(.bellGothic(size: 14))
                }
                .foregroundColor(AppColors.secondaryText)
                
                Spacer()
                
                Text("Added \(bag.createdAt.formatted(date: .abbreviated, time: .omitted))")
                    .font(.bellGothic(size: 12))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
        .cornerRadius(12)
    }
}

#Preview {
    FavoritesView()
        .environmentObject(BagViewModel())
}
