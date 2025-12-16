import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var itemStore: ItemStore
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack(spacing: 0) {
                HeaderView()
                
                StatisticsContentView()
            }
        }
    }
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Text("Statistics")
                .font(.playfairTitleLarge(28))
                .foregroundColor(.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    @ViewBuilder
    private func StatisticsContentView() -> some View {
        ScrollView {
            VStack(spacing: 24) {
                OverviewSection()
                
                CategoriesDistributionSection()
                
                StoriesSection()
                
                RecentActivitySection()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    @ViewBuilder
    private func OverviewSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.playfairHeading(22))
                .foregroundColor(.textPrimary)
            
            HStack(spacing: 16) {
                StatCard(
                    icon: "archivebox.fill",
                    iconColor: .primaryYellow,
                    title: "Total Items",
                    value: "\(itemStore.items.count)",
                    subtitle: itemStore.items.count == 1 ? "item" : "items"
                )
                
                StatCard(
                    icon: "tag.fill",
                    iconColor: .accentGreen,
                    title: "Categories",
                    value: "\(itemStore.categories.count)",
                    subtitle: itemStore.categories.count == 1 ? "category" : "categories"
                )
            }
            
            StatCard(
                icon: "book.fill",
                iconColor: .accentPurple,
                title: "Items with Stories",
                value: "\(itemsWithStoriesCount)",
                subtitle: itemsWithStoriesCount == 1 ? "item" : "items"
            )
        }
    }
    
    @ViewBuilder
    private func CategoriesDistributionSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Categories Distribution")
                .font(.playfairHeading(22))
                .foregroundColor(.textPrimary)
            
            if itemStore.categories.isEmpty {
                EmptyCategoryStatsView()
            } else {
                VStack(spacing: 12) {
                    ForEach(itemStore.categories.sorted(by: { 
                        itemStore.itemCount(for: $0) > itemStore.itemCount(for: $1) 
                    }).prefix(5), id: \.id) { category in
                        CategoryStatRow(category: category)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.cardBorder, lineWidth: 1)
                        )
                )
            }
        }
    }
    
    @ViewBuilder
    private func StoriesSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Stories")
                .font(.playfairHeading(22))
                .foregroundColor(.textPrimary)
            
            VStack(spacing: 12) {
                StatInfoRow(
                    icon: "doc.text.fill",
                    iconColor: .accentOrange,
                    title: "Items with Stories",
                    value: "\(itemsWithStoriesCount)"
                )
                
                Divider()
                    .background(Color.cardBorder)
                
                StatInfoRow(
                    icon: "doc.text",
                    iconColor: .textTertiary,
                    title: "Items without Stories",
                    value: "\(itemsWithoutStoriesCount)"
                )
                
                Divider()
                    .background(Color.cardBorder)
                
                StatInfoRow(
                    icon: "percent",
                    iconColor: .primaryYellow,
                    title: "Coverage",
                    value: storiesCoveragePercentage
                )
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
            )
        }
    }
    
    @ViewBuilder
    private func RecentActivitySection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.playfairHeading(22))
                .foregroundColor(.textPrimary)
            
            if itemStore.items.isEmpty {
                EmptyActivityView()
            } else {
                VStack(spacing: 12) {
                    let recentItems = itemStore.items.sorted(by: { $0.dateAdded > $1.dateAdded }).prefix(3)
                    
                    ForEach(Array(recentItems), id: \.id) { item in
                        RecentItemRow(item: item)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.cardBorder, lineWidth: 1)
                        )
                )
            }
        }
    }
    
    private var itemsWithStoriesCount: Int {
        itemStore.items.filter { !$0.story.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }.count
    }
    
    private var itemsWithoutStoriesCount: Int {
        itemStore.items.count - itemsWithStoriesCount
    }
    
    private var storiesCoveragePercentage: String {
        guard itemStore.items.count > 0 else { return "0%" }
        let percentage = (Double(itemsWithStoriesCount) / Double(itemStore.items.count)) * 100
        return String(format: "%.0f%%", percentage)
    }
}

struct StatCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.playfairTitleLarge(32))
                    .foregroundColor(.textPrimary)
                
                Text(title)
                    .font(.playfairCaptionMedium(12))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.playfairSmall(10))
                    .foregroundColor(.textTertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct CategoryStatRow: View {
    @EnvironmentObject var itemStore: ItemStore
    let category: Category
    
    private var itemCount: Int {
        itemStore.itemCount(for: category)
    }
    
    private var percentage: Double {
        guard itemStore.items.count > 0 else { return 0 }
        return (Double(itemCount) / Double(itemStore.items.count)) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category.name)
                    .font(.playfairBody(16))
                    .foregroundColor(.textPrimary)
                
                Spacer()
                
                Text("\(itemCount)")
                    .font(.playfairHeading(18))
                    .foregroundColor(.primaryYellow)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.cardBorder)
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.primaryYellow)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                }
            }
            .frame(height: 6)
            
            Text(String(format: "%.0f%%", percentage))
                .font(.playfairSmall(11))
                .foregroundColor(.textTertiary)
        }
    }
}

struct StatInfoRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            Text(title)
                .font(.playfairBody(16))
                .foregroundColor(.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(.playfairHeading(18))
                .foregroundColor(.primaryYellow)
        }
        .padding(.vertical, 4)
    }
}

struct RecentItemRow: View {
    let item: Item
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock.fill")
                .font(.system(size: 14))
                .foregroundColor(.textTertiary)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.playfairBody(15))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                
                Text(DateFormatter.displayDate.string(from: item.dateAdded))
                    .font(.playfairSmall(12))
                    .foregroundColor(.textTertiary)
            }
            
            Spacer()
            
            Text(item.category)
                .font(.playfairCaption(12))
                .foregroundColor(.primaryYellow)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.primaryYellow.opacity(0.2))
                )
        }
        .padding(.vertical, 4)
    }
}

struct EmptyCategoryStatsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(.textTertiary)
            
            Text("No categories yet")
                .font(.playfairBody(14))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct EmptyActivityView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(.textTertiary)
            
            Text("No items yet")
                .font(.playfairBody(14))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.cardBorder, lineWidth: 1)
                )
        )
    }
}

#Preview {
    StatisticsView()
        .environmentObject(ItemStore())
}
