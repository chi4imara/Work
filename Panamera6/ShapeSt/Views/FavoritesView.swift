import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: StyleViewModel
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Favorites")
                        .font(.lumierepolis(size: 28, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Spacer()
                    
                    if !viewModel.favoriteStyles.isEmpty {
                        Text("\(viewModel.favoriteStyles.count)")
                            .font(.lumierepolis(size: 14, weight: .bold))
                            .foregroundColor(ColorTheme.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(ColorTheme.orange)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                if viewModel.favoriteStyles.isEmpty {
                    EmptyFavoritesView()
                } else {
                    FavoritesList(viewModel: viewModel)
                }
            }
        }
    }
}

struct EmptyFavoritesView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorTheme.orange.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "heart")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(ColorTheme.orange.opacity(0.8))
                }
                
                VStack(spacing: 8) {
                    Text("No Favorite Styles Yet")
                        .font(.lumierepolis(size: 24, weight: .bold))
                        .foregroundColor(ColorTheme.white)
                    
                    Text("Mark styles as favorites to see them here.\nTap the heart icon on any style to add it.")
                        .font(.lumierepolis(size: 16))
                        .foregroundColor(ColorTheme.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct FavoritesList: View {
    @ObservedObject var viewModel: StyleViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.favoriteStyles, id: \.id) { style in
                    NavigationLink(destination: StyleDetailView(styleId: style.id, viewModel: viewModel)) {
                        FavoriteStyleCard(styleId: style.id, viewModel: viewModel)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            viewModel.deleteStyle(byId: style.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct FavoriteStyleCard: View {
    let styleId: UUID
    @ObservedObject var viewModel: StyleViewModel
    
    var style: Style? {
        viewModel.styles.first { $0.id == styleId }
    }
    
    var body: some View {
        Group {
            if let currentStyle = style {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(ColorTheme.orange.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: currentStyle.category == .haircut ? "scissors" : "mustache")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ColorTheme.orange)
                        
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(ColorTheme.orange)
                                    .background(
                                        Circle()
                                            .fill(ColorTheme.white)
                                            .frame(width: 20, height: 20)
                                    )
                            }
                            Spacer()
                        }
                        .frame(width: 50, height: 50)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(currentStyle.name)
                            .font(.lumierepolis(size: 18, weight: .bold))
                            .foregroundColor(ColorTheme.white)
                            .lineLimit(1)
                        
                        HStack {
                            Text(currentStyle.category.displayName)
                                .font(.lumierepolis(size: 14))
                                .foregroundColor(ColorTheme.accent)
                            
                            Text("•")
                                .font(.lumierepolis(size: 14))
                                .foregroundColor(ColorTheme.white.opacity(0.5))
                            
                            Text(currentStyle.length)
                                .font(.lumierepolis(size: 14))
                                .foregroundColor(ColorTheme.white.opacity(0.7))
                        }
                        
                        if !currentStyle.shape.isEmpty {
                            Text(currentStyle.shape)
                                .font(.lumierepolis(size: 12))
                                .foregroundColor(ColorTheme.white.opacity(0.6))
                                .lineLimit(1)
                        }
                        
                        if !currentStyle.description.isEmpty {
                            Text(currentStyle.description)
                                .font(.lumierepolis(size: 12))
                                .foregroundColor(ColorTheme.white.opacity(0.5))
                                .lineLimit(2)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleFavorite(for: currentStyle)
                    }) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ColorTheme.orange)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(ColorTheme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(ColorTheme.orange.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
    }
}
