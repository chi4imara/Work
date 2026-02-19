import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: BagViewModel
    
    private var favoriteBags: [Bag] {
        viewModel.favoriteBags()
    }
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                HStack {
                    Text("Favorites")
                        .font(.bellGothicBold(size: 32))
                        .foregroundColor(Color.theme.textWhite)
                    
                    Spacer()
                    
                    if !favoriteBags.isEmpty {
                        Text("\(favoriteBags.count)")
                            .font(.bellGothicBold(size: 16))
                            .foregroundColor(Color.theme.darkBlue)
                            .frame(width: 30, height: 30)
                            .background(Color.theme.accentYellow)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                
                if favoriteBags.isEmpty {
                    EmptyFavoritesView()
                } else {
                    FavoritesBagsList(bags: favoriteBags, viewModel: viewModel)
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
                .font(.system(size: 80, weight: .light))
                .foregroundColor(Color.theme.textGray)
            
            VStack(spacing: 15) {
                Text("No favorite bags yet")
                    .font(.bellGothicBold(size: 24))
                    .foregroundColor(Color.theme.textWhite)
                
                Text("You haven't added any bags to favorites yet")
                    .font(.bellGothicRegular(size: 16))
                    .foregroundColor(Color.theme.textGray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
}

struct FavoritesBagsList: View {
    let bags: [Bag]
    @ObservedObject var viewModel: BagViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(bags) { bag in
                    NavigationLink(destination: BagDetailView(bagId: bag.id, viewModel: viewModel)) {
                        FavoriteBagCardView(bag: bag)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 120)
        }
    }
}

struct FavoriteBagCardView: View {
    let bag: Bag
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(bag.name)
                        .font(.bellGothicBold(size: 18))
                        .foregroundColor(Color.theme.textWhite)
                    
                    HStack {
                        Image(systemName: bag.scenario.icon)
                            .font(.system(size: 12))
                            .foregroundColor(Color.theme.accentYellow)
                        
                        Text(bag.scenario.displayName)
                            .font(.bellGothicRegular(size: 14))
                            .foregroundColor(Color.theme.accentYellow)
                    }
                }
                
                Spacer()
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color.theme.errorRed)
            }
            
            if !bag.comment.isEmpty {
                Text(bag.comment)
                    .font(.bellGothicRegular(size: 14))
                    .foregroundColor(Color.theme.textGray)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.theme.cardBackground,
                    Color.theme.errorRed.opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.theme.errorRed.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    FavoritesView(viewModel: BagViewModel())
}
