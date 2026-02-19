import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var store: JewelryStore

    var totalItems: Int {
        store.items.count
    }
    
    var wornItems: Int {
        store.items.filter { $0.hasBeenWorn }.count
    }
    
    var unwornItems: Int {
        store.items.filter { !$0.hasBeenWorn }.count
    }
    
    var categoryStats: [(String, Int)] {
        store.getCategoryCounts().sorted { $0.1 > $1.1 }
    }
    
    var mostWornItem: JewelryItem? {
        store.items
            .filter { $0.hasBeenWorn }
            .sorted { ($0.lastWornDate ?? Date.distantPast) > ($1.lastWornDate ?? Date.distantPast) }
            .first
    }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    HStack {
                        Text("Statistics")
                            .font(.bauhausBold(size: 28))
                            .foregroundColor(AppColors.primaryWhite)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    
                    if totalItems == 0 {
                        EmptyStatisticsView()
                    } else {
                        VStack(spacing: 24) {
                            HStack(spacing: 16) {
                                StatCard(
                                    title: "Total",
                                    value: "\(totalItems)",
                                    icon: "sparkles",
                                    color: AppColors.accentYellow
                                )
                                
                                StatCard(
                                    title: "Worn",
                                    value: "\(wornItems)",
                                    icon: "checkmark.circle.fill",
                                    color: AppColors.lightBlue
                                )
                            }
                            
                            StatCard(
                                title: "Never Worn",
                                value: "\(unwornItems)",
                                icon: "circle",
                                color: AppColors.secondaryPink,
                                isFullWidth: true
                            )
                            
                            if !categoryStats.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("By Category")
                                        .font(.bauhausBold(size: 20))
                                        .foregroundColor(AppColors.darkGray)
                                    
                                    ForEach(categoryStats, id: \.0) { category, count in
                                        CategoryStatRow(categoryName: category, count: count, total: totalItems)
                                    }
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppColors.cardBackground)
                                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                            }
                            
                            if let mostWorn = mostWornItem {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Most Recently Worn")
                                        .font(.bauhausBold(size: 20))
                                        .foregroundColor(AppColors.darkGray)
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text(mostWorn.name)
                                                .font(.bauhausBold(size: 18))
                                                .foregroundColor(AppColors.darkGray)
                                            
                                            Text(mostWorn.displayCategory)
                                                .font(.bauhausRegular(size: 14))
                                                .foregroundColor(AppColors.darkGray.opacity(0.7))
                                            
                                            if let date = mostWorn.lastWornDate {
                                                Text("Last worn: \(formatDate(date))")
                                                    .font(.bauhausLight(size: 12))
                                                    .foregroundColor(AppColors.darkGray.opacity(0.6))
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(AppColors.accentYellow)
                                    }
                                }
                                .padding(20)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(AppColors.cardBackground)
                                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 120)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var isFullWidth: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.bauhausBold(size: 32))
                .foregroundColor(AppColors.darkGray)
            
            Text(title)
                .font(.bauhausRegular(size: 14))
                .foregroundColor(AppColors.darkGray.opacity(0.7))
        }
        .frame(maxWidth: isFullWidth ? .infinity : nil)
        .frame(height: 140)
        .frame(maxWidth: isFullWidth ? .infinity : .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

struct CategoryStatRow: View {
    let categoryName: String
    let count: Int
    let total: Int
    
    var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(categoryName)
                    .font(.bauhausBold(size: 16))
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
                
                Text("\(count)")
                    .font(.bauhausBold(size: 16))
                    .foregroundColor(AppColors.accentYellow)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.darkGray.opacity(0.1))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColors.accentYellow)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 8)
                }
            }
            .frame(height: 8)
            
            Text("\(Int(percentage))%")
                .font(.bauhausLight(size: 12))
                .foregroundColor(AppColors.darkGray.opacity(0.6))
        }
    }
}

struct EmptyStatisticsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentYellow)
            
            Text("No statistics yet")
                .font(.bauhausBold(size: 20))
                .foregroundColor(AppColors.primaryWhite)
                .multilineTextAlignment(.center)
            
            Text("Add jewelry to see statistics")
                .font(.bauhausRegular(size: 16))
                .foregroundColor(AppColors.primaryWhite.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .padding(.top, 100)
    }
}

#Preview {
    StatisticsView()
}
