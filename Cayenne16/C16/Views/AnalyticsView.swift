import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Analytics")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 24)
                
                if dataManager.sneakers.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "chart.bar.xaxis")
                            .font(.system(size: 60))
                            .foregroundColor(ColorManager.secondaryText)
                        
                        Text("No data available")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            totalStatsCard
                            
                            mostWornCard
                            
                            conditionDistributionCard
                            
                            recentActivityCard
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
    
    private var totalStatsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Total Statistics")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            HStack(spacing: 20) {
                StatItem(
                    title: "Total Pairs",
                    value: "\(dataManager.sneakers.count)",
                    icon: "shippingbox.fill"
                )
                
                StatItem(
                    title: "Total Days Worn",
                    value: "\(totalDaysWorn)",
                    icon: "calendar"
                )
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
    }
    
    private var mostWornCard: some View {
        let mostWorn = dataManager.sneakers
            .filter { !$0.wearingDates.isEmpty }
            .max(by: { $0.wearingCount < $1.wearingCount })
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Most Worn")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            if let sneaker = mostWorn {
                VStack(alignment: .leading, spacing: 8) {
                    Text(sneaker.model)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                    
                    HStack {
                        Text("Days worn:")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorManager.secondaryText)
                        
                        Spacer()
                        
                        Text("\(sneaker.wearingCount)")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(ColorManager.lightBlue)
                    }
                }
            } else {
                Text("No wearing data yet")
                    .font(.ubuntu(16))
                    .foregroundColor(ColorManager.secondaryText)
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
    }
    
    private var conditionDistributionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Condition Distribution")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            VStack(spacing: 12) {
                ForEach(SneakerCondition.allCases, id: \.self) { condition in
                    let count = dataManager.sneakers.filter { $0.condition == condition }.count
                    if count > 0 {
                        HStack {
                            Text(condition.rawValue)
                                .font(.ubuntu(14))
                                .foregroundColor(ColorManager.primaryText)
                            
                            Spacer()
                            
                            Text("\(count)")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(ColorManager.lightBlue)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
    }
    
    private var recentActivityCard: some View {
        let recentDates = dataManager.getAllWearingDates()
            .prefix(5)
        
        return VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            if recentDates.isEmpty {
                Text("No recent activity")
                    .font(.ubuntu(16))
                    .foregroundColor(ColorManager.secondaryText)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(recentDates), id: \.wearingDate.id) { item in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.sneaker.model)
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(ColorManager.primaryText)
                                
                                Text(dateFormatter.string(from: item.wearingDate.date))
                                    .font(.ubuntu(12))
                                    .foregroundColor(ColorManager.secondaryText)
                            }
                            
                            Spacer()
                        }
                        
                        if item.wearingDate.id != recentDates.last?.wearingDate.id {
                            Divider()
                                .background(ColorManager.secondaryText.opacity(0.3))
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
    }
    
    private var totalDaysWorn: Int {
        return dataManager.sneakers.reduce(0) { $0 + $1.wearingCount }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(ColorManager.lightBlue)
            
            Text(value)
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Text(title)
                .font(.ubuntu(12))
                .foregroundColor(ColorManager.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    AnalyticsView()
        .environmentObject(DataManager.shared)
}
