import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: PlacesViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.favoriteePlaces.isEmpty {
                    emptyStateView
                } else {
                    favoritesList
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Favorites")
                .font(FontManager.largeTitle)
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            if !viewModel.favoriteePlaces.isEmpty {
                Text("\(viewModel.favoriteePlaces.count) favorite\(viewModel.favoriteePlaces.count == 1 ? "" : "s")")
                    .font(FontManager.subheadline)
                    .foregroundColor(ColorTheme.secondaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(ColorTheme.lightBlue.opacity(0.3))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.favoriteePlaces) { place in
                    NavigationLink(destination: PlaceDetailView(viewModel: viewModel, place: place)) {
                        FavoriteCardView(place: place, viewModel: viewModel)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.lightBlue)
            
            VStack(spacing: 12) {
                Text("No Favorite Places Yet")
                    .font(FontManager.title2)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("You haven't added any favorite power spots yet")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Text("Mark places as favorites from the main list")
                .font(FontManager.footnote)
                .foregroundColor(ColorTheme.blueText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct FavoriteCardView: View {
    let place: Place
    let viewModel: PlacesViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "heart.fill")
                .font(.system(size: 24))
                .foregroundColor(ColorTheme.accentOrange)
                .frame(width: 40, height: 40)
                .background(ColorTheme.accentOrange.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                Text(place.name)
                    .font(FontManager.headline)
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(1)
                
                Text(place.category)
                    .font(FontManager.caption)
                    .foregroundColor(ColorTheme.secondaryText)
                
                if !place.address.isEmpty {
                    Text(place.address)
                        .font(FontManager.footnote)
                        .foregroundColor(ColorTheme.blueText)
                        .lineLimit(1)
                }
                
                if !place.note.isEmpty {
                    Text(place.note)
                        .font(FontManager.footnote)
                        .foregroundColor(ColorTheme.secondaryText)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.toggleFavorite(for: place)
                }
            }) {
                Image(systemName: "heart.slash")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
                    .padding(8)
                    .background(ColorTheme.backgroundGray)
                    .clipShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(viewModel: PlacesViewModel())
    }
}
