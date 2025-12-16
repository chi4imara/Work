import SwiftUI

struct FavoritesView: View {
    @ObservedObject var candleStore: CandleStore
    @State private var showingCandleDetail: Candle?
    @State private var editingCandle: Candle?
    
    var favoriteCandles: [Candle] {
        candleStore.candles.filter { $0.isFavorite }.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if favoriteCandles.isEmpty {
                        emptyStateView
                    } else {
                        favoritesList
                    }
                }
            }
        }
        .sheet(item: $showingCandleDetail) { candle in
            CandleDetailView(candle: candle, candleStore: candleStore)
        }
        .sheet(item: $editingCandle) { candle in
            AddEditCandleView(candleStore: candleStore, editingCandle: candle)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Favorites")
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("\(favoriteCandles.count) favorite scents")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.accentPink.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.accentPink)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(favoriteCandles) { candle in
                    FavoriteCard(candle: candle) {
                        showingCandleDetail = candle
                    } onToggleFavorite: {
                        candleStore.toggleFavorite(for: candle)
                    } onEdit: {
                        editingCandle = candle
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.accentPink.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "heart")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.accentPink.opacity(0.6))
            }
            
            VStack(spacing: 12) {
                Text("No favorites yet")
                    .font(.playfairDisplay(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Mark candles as favorites by tapping the heart icon in their details.")
                    .font(.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding(.bottom, 100)
    }
}

struct FavoriteCard: View {
    let candle: Candle
    let onTap: () -> Void
    let onToggleFavorite: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryYellow.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "flame.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primaryYellow)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(candle.name)
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button(action: onToggleFavorite) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 18))
                                .foregroundColor(AppColors.accentPink)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Text(candle.brand)
                        .font(.playfairDisplay(size: 14, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Text(candle.mood.rawValue)
                            .font(.playfairDisplay(size: 12, weight: .medium))
                            .foregroundColor(AppColors.primaryPurple)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.primaryPurple.opacity(0.1))
                            )
                        
                        Text(candle.season.rawValue)
                            .font(.playfairDisplay(size: 12, weight: .medium))
                            .foregroundColor(AppColors.primaryBlue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.primaryBlue.opacity(0.1))
                            )
                        
                        Spacer()
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.textLight)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(AppColors.accentPink.opacity(0.2), lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
        }
    }
}

#Preview {
    FavoritesView(candleStore: CandleStore())
}
