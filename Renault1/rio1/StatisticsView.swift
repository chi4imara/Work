import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var store: AppDataStore
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack(spacing: 16) {
                            StatBlock(
                                title: "Current Streak",
                                value: "\(store.streakCount())",
                                subtitle: "days",
                                icon: "flame.fill",
                                color: AppColors.secondary
                            )
                            
                            StatBlock(
                                title: "This Week",
                                value: "\(Int(store.completionRate(period: .week) * 100))%",
                                subtitle: "completed",
                                icon: "chart.bar.fill",
                                color: AppColors.primary
                            )
                        }
                        
                        VStack(spacing: 16) {
                            HStack {
                                Text("Completion Rates")
                                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                                    .foregroundColor(AppColors.text)
                                Spacer()
                            }
                            
                            VStack(spacing: 12) {
                                PeriodStatRow(period: "Week", rate: store.completionRate(period: .week))
                                PeriodStatRow(period: "Month", rate: store.completionRate(period: .month))
                                PeriodStatRow(period: "Year", rate: store.completionRate(period: .year))
                            }
                        }
                        .padding(20)
                        .background(AppColors.cardGradient)
                        .cornerRadius(16)
                        .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
                        
                        MoodDistributionSection(distribution: store.moodDistribution())
                        
                        RitualsStatsSection(rituals: store.rituals)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

struct StatBlock: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
            
            Text(value)
                .font(FontManager.playfairDisplay(size: 32, weight: .bold))
                .foregroundColor(AppColors.text)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(FontManager.playfairDisplay(size: 14, weight: .medium))
                    .foregroundColor(AppColors.text)
                
                Text(subtitle)
                    .font(FontManager.playfairDisplay(size: 12))
                    .foregroundColor(AppColors.text.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct PeriodStatRow: View {
    let period: String
    let rate: Double
    
    var body: some View {
        HStack(spacing: 12) {
            Text(period)
                .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                .foregroundColor(AppColors.text)
                .lineLimit(1)
                .frame(minWidth: 44, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.lightGray)
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.secondary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, rate * geometry.size.width), height: 8)
                        .animation(.easeInOut(duration: 0.8), value: rate)
                }
            }
            .frame(height: 8)
            
            Text("\(Int(rate * 100))%")
                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(AppColors.text)
                .lineLimit(1)
                .frame(minWidth: 36, alignment: .trailing)
        }
    }
}

struct MoodDistributionSection: View {
    let distribution: [String: Int]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Mood Distribution")
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.text)
                Spacer()
            }
            
            if distribution.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.pie")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.primary.opacity(0.5))
                    
                    Text("No mood data yet")
                        .font(FontManager.playfairDisplay(size: 16))
                        .foregroundColor(AppColors.text.opacity(0.6))
                }
                .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(distribution.keys.sorted()), id: \.self) { name in
                        HStack {
                            if let mood = Mood.allMoods.first(where: { $0.name == name }) {
                                Text(mood.emoji)
                                    .font(.system(size: 20))
                            }
                            
                            Text(name)
                                .font(FontManager.playfairDisplay(size: 16))
                                .foregroundColor(AppColors.text)
                            
                            Spacer()
                            
                            Text("\(distribution[name] ?? 0)")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct RitualsStatsSection: View {
    let rituals: [Ritual]
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Rituals Overview")
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.text)
                Spacer()
            }
            
            if rituals.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "leaf")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.primary.opacity(0.5))
                    
                    Text("No rituals created yet")
                        .font(FontManager.playfairDisplay(size: 16))
                        .foregroundColor(AppColors.text.opacity(0.6))
                }
                .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    HStack(spacing: 16) {
                        StatMiniCard(
                            title: "Total Rituals",
                            value: "\(rituals.count)",
                            color: AppColors.primary
                        )
                        
                        StatMiniCard(
                            title: "Best Streak",
                            value: "\(rituals.map(\.streakCount).max() ?? 0)",
                            color: AppColors.secondary
                        )
                    }
                    
                    let categoryCount = Dictionary(grouping: rituals, by: \.category)
                        .mapValues { $0.count }
                    
                    ForEach(RitualCategory.allCases, id: \.self) { category in
                        if let count = categoryCount[category], count > 0 {
                            HStack {
                                Image(systemName: category.icon)
                                    .font(.system(size: 16))
                                    .foregroundColor(category.color)
                                    .frame(width: 24)
                                
                                Text(category.rawValue)
                                    .font(FontManager.playfairDisplay(size: 14))
                                    .foregroundColor(AppColors.text)
                                
                                Spacer()
                                
                                Text("\(count)")
                                    .font(FontManager.playfairDisplay(size: 14, weight: .semibold))
                                    .foregroundColor(category.color)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppColors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct StatMiniCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(FontManager.playfairDisplay(size: 24, weight: .bold))
                .foregroundColor(color)
            
            Text(title)
                .font(FontManager.playfairDisplay(size: 12))
                .foregroundColor(AppColors.text.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

#Preview {
    StatisticsView()
        .environmentObject(AppDataStore())
}
