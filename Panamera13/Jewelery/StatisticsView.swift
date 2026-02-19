import SwiftUI

struct StatisticsView: View {
    @ObservedObject var jewelryStore: JewelryStore
    @ObservedObject var setsStore: SetsStore
    @State private var selectedJewelryId: UUID?
    
    var statistics: Statistics {
        Statistics(
            totalJewelry: jewelryStore.jewelries.count,
            totalSets: setsStore.sets.count,
            jewelryByType: calculateJewelryByType(),
            recentAdditions: Array(jewelryStore.jewelries.sorted { $0.dateCreated > $1.dateCreated }.prefix(5))
        )
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HeaderView(
                    title: "Statistics",
                    showAddButton: false,
                    onAddTapped: nil
                )
                
                ScrollView {
                    VStack(spacing: 20) {
                        OverviewCards(statistics: statistics)
                        
                        StatisticsSection(title: "By Type") {
                            TypeDistributionView(jewelryByType: statistics.jewelryByType)
                        }
                        
                        if !statistics.recentAdditions.isEmpty {
                            StatisticsSection(title: "Recent Additions") {
                                RecentAdditionsView(
                                    recentJewelries: statistics.recentAdditions,
                                    onJewelryTap: { id in
                                        selectedJewelryId = id
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(item: Binding(
            get: { selectedJewelryId.flatMap { jewelryStore.getJewelry(by: $0) } },
            set: { _ in selectedJewelryId = nil }
        )) { jewelry in
            JewelryDetailView(jewelryId: jewelry.id, jewelryStore: jewelryStore, setsStore: setsStore)
        }
    }
    
    private func calculateJewelryByType() -> [JewelryType: Int] {
        var counts: [JewelryType: Int] = [:]
        
        for jewelry in jewelryStore.jewelries {
            counts[jewelry.type, default: 0] += 1
        }
        
        return counts
    }
}

struct Statistics {
    let totalJewelry: Int
    let totalSets: Int
    let jewelryByType: [JewelryType: Int]
    let recentAdditions: [Jewelry]
}

struct OverviewCards: View {
    let statistics: Statistics
    
    var body: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Total Jewelry",
                value: "\(statistics.totalJewelry)",
                icon: "sparkles",
                color: ColorTheme.accentYellow
            )
            
            StatCard(
                title: "Total Sets",
                value: "\(statistics.totalSets)",
                icon: "square.stack.3d.up",
                color: Color.green
            )
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(color)
            
            Text(value)
                .font(.lumierepolis(28, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Text(title)
                .font(.lumierepolis(12))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct StatisticsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .font(.lumierepolis(18, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ColorTheme.cardBorder, lineWidth: 1)
                    )
            )
        }
    }
}

struct TypeDistributionView: View {
    let jewelryByType: [JewelryType: Int]
    
    var sortedTypes: [(JewelryType, Int)] {
        jewelryByType.sorted { $0.value > $1.value }
    }
    
    var maxCount: Int {
        jewelryByType.values.max() ?? 1
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(sortedTypes, id: \.0) { type, count in
                TypeDistributionRow(
                    type: type,
                    count: count,
                    maxCount: maxCount
                )
            }
        }
        .padding(.vertical, 12)
    }
}

struct TypeDistributionRow: View {
    let type: JewelryType
    let count: Int
    let maxCount: Int
    
    var percentage: CGFloat {
        maxCount > 0 ? CGFloat(count) / CGFloat(maxCount) : 0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: type.icon)
                        .font(.system(size: 16))
                        .foregroundColor(ColorTheme.accentYellow)
                    
                    Text(type.rawValue)
                        .font(.lumierepolis(14, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                }
                
                Spacer()
                
                Text("\(count)")
                    .font(.lumierepolis(14, weight: .bold))
                    .foregroundColor(ColorTheme.accentYellow)
            }
            .padding(.horizontal, 16)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorTheme.cardBorder.opacity(0.3))
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(ColorTheme.accentYellow)
                        .frame(width: geometry.size.width * percentage, height: 6)
                }
            }
            .frame(height: 6)
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
    }
}

struct RecentAdditionsView: View {
    let recentJewelries: [Jewelry]
    let onJewelryTap: (UUID) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(recentJewelries) { jewelry in
                Button(action: {
                    onJewelryTap(jewelry.id)
                }) {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(ColorTheme.cardBackground)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: jewelry.type.icon)
                                .font(.system(size: 16))
                                .foregroundColor(ColorTheme.accentYellow)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(jewelry.name)
                                .font(.lumierepolis(14, weight: .bold))
                                .foregroundColor(ColorTheme.primaryText)
                                .lineLimit(1)
                            
                            Text(jewelry.dateCreated.formatted(date: .abbreviated, time: .omitted))
                                .font(.lumierepolis(12))
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                
                if jewelry.id != recentJewelries.last?.id {
                    Divider()
                        .background(ColorTheme.cardBorder)
                        .padding(.horizontal, 16)
                }
            }
        }
    }
}

#Preview {
    StatisticsView(jewelryStore: JewelryStore(), setsStore: SetsStore())
}
