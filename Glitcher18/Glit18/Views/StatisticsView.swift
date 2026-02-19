import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.playfairDisplay(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(AppColors.accentGradient)
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 40, weight: .medium))
                                    .foregroundColor(AppColors.deepPurple)
                            }
                            
                            Text("Your Style Statistics")
                                .font(.playfairDisplay(size: 28, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Track your collection and style insights")
                                .font(.playfairDisplay(size: 16, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .glassCard()
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            StatCard(
                                title: "Total Accessories",
                                value: "\(dataManager.accessories.count)",
                                icon: "sparkles",
                                color: AppColors.accentYellow
                            )
                            StatCard(
                                title: "Total Outfits",
                                value: "\(dataManager.outfits.count)",
                                icon: "tshirt.fill",
                                color: AppColors.accentYellow
                            )
                            StatCard(
                                title: "Categories",
                                value: "\(dataManager.categories.count)",
                                icon: "folder.fill",
                                color: AppColors.accentYellow
                            )
                            StatCard(
                                title: "Combinations",
                                value: "\(totalCombinations)",
                                icon: "heart.fill",
                                color: AppColors.accentYellow
                            )
                        }
                        
                        if !categoryBreakdown.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Category Breakdown")
                                    .font(.playfairDisplay(size: 22, weight: .bold))
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal)
                                
                                ForEach(categoryBreakdown, id: \.category) { item in
                                    CategoryStatRow(
                                        category: item.category,
                                        count: item.count,
                                        percentage: item.percentage
                                    )
                                }
                            }
                            .padding()
                            .glassCard()
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Recent Activity")
                                .font(.playfairDisplay(size: 22, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            if let recentAccessory = dataManager.accessories.sorted(by: { $0.createdAt > $1.createdAt }).first {
                                HStack(spacing: 16) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 24))
                                        .foregroundColor(AppColors.accentYellow)
                                        .frame(width: 40, height: 40)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Latest Accessory")
                                            .font(.playfairDisplay(size: 14, weight: .medium))
                                            .foregroundColor(AppColors.secondaryText)
                                        
                                        Text(recentAccessory.name)
                                            .font(.playfairDisplay(size: 16, weight: .semibold))
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(timeAgoString(from: recentAccessory.createdAt))
                                        .font(.playfairDisplay(size: 12, weight: .regular))
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                .padding()
                                .glassCard()
                            }
                            
                            if let recentOutfit = dataManager.outfits.sorted(by: { $0.createdAt > $1.createdAt }).first {
                                HStack(spacing: 16) {
                                    Image(systemName: "tshirt.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(AppColors.accentYellow)
                                        .frame(width: 40, height: 40)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Latest Outfit")
                                            .font(.playfairDisplay(size: 14, weight: .medium))
                                            .foregroundColor(AppColors.secondaryText)
                                        
                                        Text(recentOutfit.name)
                                            .font(.playfairDisplay(size: 16, weight: .semibold))
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(timeAgoString(from: recentOutfit.createdAt))
                                        .font(.playfairDisplay(size: 12, weight: .regular))
                                        .foregroundColor(AppColors.secondaryText)
                                }
                                .padding()
                                .glassCard()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .glassCard()
                    }
                    .padding()
                }
            }
        }
    }
    
    private var totalCombinations: Int {
        dataManager.accessories.reduce(0) { $0 + $1.outfitIds.count }
    }
    
    private var categoryBreakdown: [(category: String, count: Int, percentage: Double)] {
        let total = dataManager.accessories.count
        guard total > 0 else { return [] }
        
        let categoryCounts = Dictionary(grouping: dataManager.accessories, by: { $0.category })
            .mapValues { $0.count }
        
        return categoryCounts.map { category, count in
            let percentage = (Double(count) / Double(total)) * 100
            return (category: category, count: count, percentage: percentage)
        }.sorted { $0.count > $1.count }
    }
    
    private func timeAgoString(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .hour, .minute], from: date, to: now)
        
        if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        } else if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        } else if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        } else {
            return "Just now"
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
                .font(.system(size: 28))
                .foregroundColor(color)
            
            Text(value)
                .font(.playfairDisplay(size: 32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(.playfairDisplay(size: 14, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .glassCard()
    }
}

struct CategoryStatRow: View {
    let category: String
    let count: Int
    let percentage: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category)
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(count)")
                    .font(.playfairDisplay(size: 16, weight: .bold))
                    .foregroundColor(AppColors.accentYellow)
                
                Text(String(format: "%.0f%%", percentage))
                    .font(.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.cardBorder)
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.accentYellow)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    StatisticsView()
}

