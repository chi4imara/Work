import SwiftUI
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("Settings")
                            .font(.bauhausBold(28))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    VStack(spacing: 16) {
                        SettingsCard(
                            icon: "star.fill",
                            title: "Rate App",
                            subtitle: "Share your feedback",
                            color: Color.theme.accentOrange,
                            iconBackground: Color.theme.accentOrange.opacity(0.2),
                            position: .topLeading
                        ) {
                            requestReview()
                        }
                        
                        SettingsCard(
                            icon: "hand.raised.fill",
                            title: "Privacy Policy",
                            subtitle: "How we protect your data",
                            color: Color.theme.accentPink,
                            iconBackground: Color.theme.accentPink.opacity(0.2),
                            position: .topTrailing
                        ) {
                            openURL("https://doc-hosting.flycricket.io/adornia-pairs-privacy-policy/5df0ee6a-3012-4a2c-bd01-aa2f660c245c/privacy")
                        }
                        
                        SettingsCard(
                            icon: "envelope.fill",
                            title: "Contact Us",
                            subtitle: "Get in touch with us",
                            color: Color.theme.primaryBlue,
                            iconBackground: Color.theme.primaryBlue.opacity(0.2),
                            position: .bottomLeading
                        ) {
                            openURL("https://forms.gle/Q31BSj8aSu1f8U7TA")
                        }
                    }
                    .padding(.horizontal, 20)
                }

            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

enum CardPosition {
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
}

struct SettingsCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let iconBackground: Color
    let position: CardPosition
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(iconBackground)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.bauhausBold(18))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text(subtitle)
                        .font(.bauhausRegular(14))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.theme.secondaryText)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: [color.opacity(0.3), color.opacity(0.0)],
                            startPoint: positionToPoint(position),
                            endPoint: oppositePoint(position)
                        ),
                        lineWidth: 2
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .animation(.easeInOut(duration: 0.2), value: isPressed)
    }
    
    private func positionToPoint(_ position: CardPosition) -> UnitPoint {
        switch position {
        case .topLeading: return .topLeading
        case .topTrailing: return .topTrailing
        case .bottomLeading: return .bottomLeading
        case .bottomTrailing: return .bottomTrailing
        }
    }
    
    private func oppositePoint(_ position: CardPosition) -> UnitPoint {
        switch position {
        case .topLeading: return .bottomTrailing
        case .topTrailing: return .bottomLeading
        case .bottomLeading: return .topTrailing
        case .bottomTrailing: return .topLeading
        }
    }
}

struct FavoritesView: View {
    @ObservedObject var combinationStore: CombinationStore
    @State private var selectedCombinationId: UUID?
    
    var favoriteCombinations: [Combination] {
        combinationStore.getFavoriteCombinations()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Favorites")
                        .font(.bauhausBold(28))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    if !favoriteCombinations.isEmpty {
                        Text("\(favoriteCombinations.count)")
                            .font(.bauhausRegular(16))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if favoriteCombinations.isEmpty {
                    VStack(spacing: 30) {
                        Spacer()
                        
                        Image(systemName: "heart")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                        
                        VStack(spacing: 12) {
                            Text("No favorites yet")
                                .font(.bauhausBold(22))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Text("Mark combinations as favorites to see them here")
                                .font(.bauhausRegular(16))
                                .foregroundColor(Color.theme.secondaryText)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(favoriteCombinations) { combination in
                                FavoriteCombinationCard(
                                    combination: combination,
                                    isFavorite: combinationStore.isFavorite(combinationId: combination.id),
                                    onToggleFavorite: {
                                        combinationStore.toggleFavorite(combinationId: combination.id)
                                    },
                                    onTap: {
                                        selectedCombinationId = combination.id
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedCombinationId.flatMap { combinationStore.getCombination(by: $0) } },
            set: { _ in selectedCombinationId = nil }
        )) { combination in
            CombinationDetailView(
                combinationId: combination.id,
                combinationStore: combinationStore
            )
        }
    }
}

struct FavoriteCombinationCard: View {
    let combination: Combination
    let isFavorite: Bool
    let onToggleFavorite: () -> Void
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(combination.name.isEmpty ? "Untitled Combination" : combination.name)
                                .font(.bauhausBold(18))
                                .foregroundColor(Color.theme.primaryText)
                                .lineLimit(1)
                            
                            Text(combination.shortDescription)
                                .font(.bauhausRegular(14))
                                .foregroundColor(Color.theme.secondaryText)
                                .lineLimit(2)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text("\(combination.jewelryCount)")
                                .font(.bauhausBold(20))
                                .foregroundColor(Color.theme.primaryBlue)
                            
                            Text("items")
                                .font(.bauhausRegular(12))
                                .foregroundColor(Color.theme.secondaryText)
                        }
                    }
                    
                    if !combination.jewelries.isEmpty {
                        Text(combination.jewelryList)
                            .font(.bauhausRegular(12))
                            .foregroundColor(Color.theme.accentOrange)
                            .lineLimit(1)
                    }
                }
                
                Button(action: onToggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 24))
                        .foregroundColor(isFavorite ? Color.red : Color.theme.secondaryText)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.theme.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TrendsView: View {
    @ObservedObject var combinationStore: CombinationStore
    @State private var selectedCombinationId: UUID?
    
    var trends: TrendData {
        combinationStore.getTrends()
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.backgroundGradientStart, Color.theme.backgroundGradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("Trends")
                            .font(.bauhausBold(28))
                            .foregroundColor(Color.theme.primaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    
                    if trends.totalCombinations == 0 {
                        VStack(spacing: 30) {
                            Spacer()
                            
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 60, weight: .light))
                                .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                            
                            VStack(spacing: 12) {
                                Text("No data yet")
                                    .font(.bauhausBold(22))
                                    .foregroundColor(Color.theme.primaryText)
                                
                                Text("Create combinations to see trends and statistics")
                                    .font(.bauhausRegular(16))
                                    .foregroundColor(Color.theme.secondaryText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            
                            Spacer()
                        }
                        .frame(height: 400)
                    } else {
                        VStack(spacing: 20) {
                            TrendStatCard(
                                icon: "square.grid.2x2",
                                title: "Total Combinations",
                                value: "\(trends.totalCombinations)",
                                color: Color.theme.primaryBlue
                            )
                            
                            TrendStatCard(
                                icon: "sparkles",
                                title: "Total Jewelry Items",
                                value: "\(trends.totalJewelry)",
                                color: Color.theme.accentOrange
                            )
                            
                            TrendStatCard(
                                icon: "chart.bar",
                                title: "Average Items per Combination",
                                value: String(format: "%.1f", trends.averageJewelryPerCombination),
                                color: Color.theme.accentPink
                            )
                            
                            if let mostPopularType = trends.mostPopularType {
                                TrendStatCard(
                                    icon: mostPopularType.iconName,
                                    title: "Most Popular Type",
                                    value: mostPopularType.displayName,
                                    color: Color.theme.accentGreen
                                )
                            }
                            
                            if let mostPopularCategory = trends.mostPopularCategory {
                                TrendStatCard(
                                    icon: categoryIcon(for: mostPopularCategory),
                                    title: "Most Popular Category",
                                    value: mostPopularCategory.rawValue,
                                    color: Color.theme.primaryYellow
                                )
                            }
                            
                            if !trends.jewelryTypeCounts.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Jewelry Type Distribution")
                                        .font(.bauhausBold(20))
                                        .foregroundColor(Color.theme.primaryText)
                                        .padding(.horizontal, 20)
                                    
                                    ForEach(Array(trends.jewelryTypeCounts.sorted(by: { $0.value > $1.value })), id: \.key) { type, count in
                                        TrendBarItem(
                                            label: type.displayName,
                                            count: count,
                                            total: trends.totalJewelry,
                                            icon: type.iconName
                                        )
                                    }
                                }
                                .padding(.vertical, 16)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(16)
                                .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
                                .padding(.horizontal, 20)
                            }
                            
                            if !trends.categoryCounts.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Category Distribution")
                                        .font(.bauhausBold(20))
                                        .foregroundColor(Color.theme.primaryText)
                                        .padding(.horizontal, 20)
                                    
                                    ForEach(Array(trends.categoryCounts.sorted(by: { $0.value > $1.value })), id: \.key) { category, count in
                                        TrendBarItem(
                                            label: category.rawValue,
                                            count: count,
                                            total: trends.totalCombinations,
                                            icon: categoryIcon(for: category)
                                        )
                                    }
                                }
                                .padding(.vertical, 16)
                                .background(Color.theme.cardBackground)
                                .cornerRadius(16)
                                .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 120)
                    }
                }
            }
        }
    }
    
    private func categoryIcon(for category: CombinationCategory) -> String {
        switch category {
        case .everyday: return "sun.max"
        case .evening: return "moon.stars"
        case .special: return "star"
        case .work: return "briefcase"
        case .casual: return "figure.walk"
        case .formal: return "suit.heart"
        }
    }
}

struct TrendStatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.bauhausRegular(14))
                    .foregroundColor(Color.theme.secondaryText)
                
                Text(value)
                    .font(.bauhausBold(24))
                    .foregroundColor(Color.theme.primaryText)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.theme.cardShadow, radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}

struct TrendBarItem: View {
    let label: String
    let count: Int
    let total: Int
    let icon: String
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.theme.primaryBlue)
                .frame(width: 24)
            
            Text(label)
                .font(.bauhausRegular(14))
                .foregroundColor(Color.theme.primaryText)
                .frame(width: 120, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.theme.secondaryText.opacity(0.1))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(Color.theme.primaryBlue)
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            
            Text("\(count)")
                .font(.bauhausBold(14))
                .foregroundColor(Color.theme.primaryText)
                .frame(width: 40, alignment: .trailing)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }
}
