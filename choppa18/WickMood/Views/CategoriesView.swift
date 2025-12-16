import SwiftUI

struct CategoriesView: View {
    @ObservedObject var candleStore: CandleStore
    @State private var selectedTab: CategoryTab = .mood
    @State private var showingCandleDetail: Candle?
    @State private var editingCandle: Candle?
    
    enum CategoryTab: String, CaseIterable {
        case mood = "By Mood"
        case season = "By Season"
    }
    
    var body: some View {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    tabSelector
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            if selectedTab == .mood {
                                moodCategoriesView
                            } else {
                                seasonCategoriesView
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
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
                Text("Scent Categories")
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Explore by mood and season")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(CategoryTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab
                    }
                }) {
                    Text(tab.rawValue)
                        .font(.playfairDisplay(size: 16, weight: .semibold))
                        .foregroundColor(selectedTab == tab ? AppColors.buttonText : AppColors.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedTab == tab ? AppColors.primaryPurple : Color.clear)
                        )
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    private var moodCategoriesView: some View {
        ForEach(Mood.allCases) { mood in
            CategoryCard(
                title: mood.rawValue,
                subtitle: moodSubtitle(for: mood),
                icon: moodIcon(for: mood),
                color: moodColor(for: mood),
                count: candlesCount(for: mood),
                candles: candlesForMood(mood),
                onCandleTap: { candle in
                    showingCandleDetail = candle
                },
                onCandleEdit: { candle in
                    editingCandle = candle
                }
            )
        }
    }
    
    private var seasonCategoriesView: some View {
        ForEach(Season.allCases) { season in
            CategoryCard(
                title: season.rawValue,
                subtitle: seasonSubtitle(for: season),
                icon: seasonIcon(for: season),
                color: seasonColor(for: season),
                count: candlesCount(for: season),
                candles: candlesForSeason(season),
                onCandleTap: { candle in
                    showingCandleDetail = candle
                },
                onCandleEdit: { candle in
                    editingCandle = candle
                }
            )
        }
    }
    
    private func candlesForMood(_ mood: Mood) -> [Candle] {
        candleStore.candles.filter { $0.mood == mood }
    }
    
    private func candlesForSeason(_ season: Season) -> [Candle] {
        candleStore.candles.filter { $0.season == season }
    }
    
    private func candlesCount(for mood: Mood) -> Int {
        candlesForMood(mood).count
    }
    
    private func candlesCount(for season: Season) -> Int {
        candlesForSeason(season).count
    }
    
    private func moodSubtitle(for mood: Mood) -> String {
        switch mood {
        case .cozy: return "Warm and comforting scents"
        case .relaxing: return "Calming and peaceful aromas"
        case .refreshing: return "Clean and invigorating fragrances"
        case .energetic: return "Uplifting and vibrant scents"
        case .romantic: return "Sensual and intimate fragrances"
        }
    }
    
    private func seasonSubtitle(for season: Season) -> String {
        switch season {
        case .spring: return "Fresh and blooming scents"
        case .summer: return "Light and airy fragrances"
        case .autumn: return "Warm and spicy aromas"
        case .winter: return "Rich and cozy scents"
        }
    }
    
    private func moodIcon(for mood: Mood) -> String {
        switch mood {
        case .cozy: return "house.fill"
        case .relaxing: return "leaf.fill"
        case .refreshing: return "wind"
        case .energetic: return "bolt.fill"
        case .romantic: return "heart.fill"
        }
    }
    
    private func seasonIcon(for season: Season) -> String {
        switch season {
        case .spring: return "leaf.fill"
        case .summer: return "sun.max.fill"
        case .autumn: return "leaf.fill"
        case .winter: return "snowflake"
        }
    }
    
    private func moodColor(for mood: Mood) -> Color {
        switch mood {
        case .cozy: return AppColors.accentOrange
        case .relaxing: return AppColors.accentGreen
        case .refreshing: return AppColors.primaryBlue
        case .energetic: return AppColors.primaryYellow
        case .romantic: return AppColors.accentPink
        }
    }
    
    private func seasonColor(for season: Season) -> Color {
        switch season {
        case .spring: return AppColors.accentGreen
        case .summer: return AppColors.primaryYellow
        case .autumn: return AppColors.accentOrange
        case .winter: return AppColors.primaryBlue
        }
    }
}

struct CategoryCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let count: Int
    let candles: [Candle]
    let onCandleTap: (Candle) -> Void
    let onCandleEdit: (Candle) -> Void
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(subtitle)
                            .font(.playfairDisplay(size: 14, weight: .regular))
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("\(count)")
                            .font(.playfairDisplay(size: 16, weight: .bold))
                            .foregroundColor(color)
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.textLight)
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardBackground)
                        .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(spacing: 8) {
                    if candles.isEmpty {
                        emptyStateView
                    } else {
                        ForEach(candles) { candle in
                            CandleMiniCard(
                                candle: candle,
                                onTap: {
                                    onCandleTap(candle)
                                },
                                onEdit: {
                                    onCandleEdit(candle)
                                }
                            )
                        }
                    }
                }
                .padding(.top, 8)
                .animation(.easeInOut(duration: 0.3), value: isExpanded)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "flame")
                .font(.system(size: 24, weight: .light))
                .foregroundColor(AppColors.textLight)
            
            Text("No candles in this category")
                .font(.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
            
            Text("Add suitable scents to your catalog.")
                .font(.playfairDisplay(size: 14, weight: .regular))
                .foregroundColor(AppColors.textLight)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground.opacity(0.5))
        )
    }
}

struct CandleMiniCard: View {
    let candle: Candle
    let onTap: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.primaryYellow)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(candle.name)
                        .font(.playfairDisplay(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Text(candle.brand)
                        .font(.playfairDisplay(size: 12, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                if candle.isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.accentPink)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(AppColors.textLight)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(AppColors.borderColor, lineWidth: 1)
                    )
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
    CategoriesView(candleStore: CandleStore())
}
