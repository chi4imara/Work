import SwiftUI

struct FavoritesView: View {
    @ObservedObject private var viewModel = JewelryViewModel.shared
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.favoriteJewelries.isEmpty {
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
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "heart")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.accent)
            
            Text("No favorite jewelry yet.")
                .font(.playfairDisplay(20, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
            
            Text("Mark jewelry pieces as favorites to see them here.")
                .font(.playfairDisplay(16))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.favoriteJewelries) { jewelry in
                    NavigationLink(destination: JewelryDetailView(jewelry: jewelry, viewModel: viewModel)) {
                        FavoriteJewelryCard(jewelry: jewelry)
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

struct FavoriteJewelryCard: View {
    let jewelry: Jewelry
    
    var body: some View {
        HStack(spacing: 16) {
            VStack {
                Image(systemName: "heart.fill")
                    .font(.title2)
                    .foregroundColor(ColorTheme.orange)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(jewelry.name)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(1)
                
                HStack {
                    Text(jewelry.style)
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(ColorTheme.accentText)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(ColorTheme.lightBlue.opacity(0.2))
                        .cornerRadius(8)
                    
                    Text(jewelry.type.displayName)
                        .font(.playfairDisplay(14))
                        .foregroundColor(ColorTheme.secondaryText)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(ColorTheme.orange.opacity(0.2))
                        .cornerRadius(8)
                }
                
                if !jewelry.note.isEmpty {
                    Text(jewelry.note)
                        .font(.playfairDisplay(14))
                        .foregroundColor(ColorTheme.secondaryText)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(ColorTheme.secondaryText)
                .font(.system(size: 14))
        }
        .padding(16)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.orange.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    FavoritesView()
}
