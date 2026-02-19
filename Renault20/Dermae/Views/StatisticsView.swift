import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: SkinCareViewModel
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    completionStatsSection
                    
                    weeklyOverviewSection
                    
                    skinConditionSection
                    
                    proceduresOverviewSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Statistics")
                .font(.titleLarge)
                .foregroundColor(ColorManager.primaryText)
            
            Text("Your skincare progress")
                .font(.bodyMedium)
                .foregroundColor(ColorManager.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
    
    private var completionStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("This Week")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            let (completed, total) = viewModel.weeklyCompletionStats()
            let percentage = total > 0 ? min(max(Double(completed) / Double(total) * 100, 0), 100) : 0.0
            
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Procedures Completed")
                            .font(.bodyMedium)
                            .foregroundColor(ColorManager.secondaryText)
                        Text("\(completed) / \(total)")
                            .font(.titleLarge)
                            .foregroundColor(ColorManager.primaryText)
                    }
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(ColorManager.primaryBlue.opacity(0.2), lineWidth: 8)
                            .frame(width: 70, height: 70)
                        Circle()
                            .trim(from: 0, to: min(max(percentage / 100, 0), 1))
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [ColorManager.primaryBlue, ColorManager.primaryYellow]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 70, height: 70)
                            .rotationEffect(.degrees(-90))
                        Text("\(Int(percentage))%")
                            .font(.bodyMedium)
                            .foregroundColor(ColorManager.darkText)
                            .fontWeight(.semibold)
                    }
                }
            }
            .padding(20)
            .background(ColorManager.cardBackground)
            .cornerRadius(16)
            .shadow(color: ColorManager.shadowColor, radius: 5, x: 0, y: 3)
        }
    }
    
    private var weeklyOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Last 7 Days")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            HStack(spacing: 8) {
                ForEach(viewModel.lastSevenDaysStats(), id: \.day) { dayStat in
                    VStack(spacing: 8) {
                        Text(dayStat.shortDayName)
                            .font(.caption)
                            .foregroundColor(ColorManager.secondaryText)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(barColor(for: dayStat.percentage))
                            .frame(height: max(20, CGFloat(dayStat.percentage) / 100 * 60))
                        
                        Text("\(Int(dayStat.percentage))%")
                            .font(.caption)
                            .foregroundColor(ColorManager.darkText)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                }
            }
            .padding(16)
            .background(ColorManager.cardBackground)
            .cornerRadius(16)
            .shadow(color: ColorManager.shadowColor, radius: 5, x: 0, y: 3)
        }
    }
    
    private var skinConditionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Skin Diary Summary")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            let conditionCounts = viewModel.skinConditionCounts()
            
            if conditionCounts.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "book.circle")
                        .font(.system(size: 40))
                        .foregroundColor(ColorManager.primaryBlue.opacity(0.6))
                    Text("No skin diary entries yet")
                        .font(.bodyMedium)
                        .foregroundColor(ColorManager.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
            } else {
                VStack(spacing: 12) {
                    ForEach(Array(conditionCounts.keys.sorted()), id: \.self) { condition in
                        HStack {
                            Image(systemName: iconName(forSkinConditionRawValue: condition))
                                .font(.system(size: 18))
                                .foregroundColor(ColorManager.primaryBlue)
                                .frame(width: 24)
                            Text(condition)
                                .font(.bodyMedium)
                                .foregroundColor(ColorManager.darkText)
                            Spacer()
                            Text("\(conditionCounts[condition] ?? 0) entries")
                                .font(.bodySmall)
                                .foregroundColor(ColorManager.secondaryText)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(ColorManager.cardBackground.opacity(0.5))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorManager.shadowColor, radius: 5, x: 0, y: 3)
    }
    
    private func barColor(for percentage: Double) -> Color {
        if percentage >= 100 { return ColorManager.successGreen }
        if percentage > 0 { return ColorManager.primaryYellow }
        return ColorManager.primaryBlue.opacity(0.2)
    }
    
    private func iconName(forSkinConditionRawValue rawValue: String) -> String {
        SkinEntry.SkinCondition(rawValue: rawValue)?.icon ?? "circle"
    }
    
    private var proceduresOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Your Procedures")
                    .font(.titleMedium)
                    .foregroundColor(ColorManager.primaryText)
                Spacer()
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Daily",
                    value: "\(viewModel.getDailyProcedures().count)",
                    icon: "sun.max.fill"
                )
                StatCard(
                    title: "Weekly",
                    value: "\(viewModel.getWeeklyProcedures().count)",
                    icon: "calendar"
                )
                StatCard(
                    title: "Total",
                    value: "\(viewModel.procedures.count)",
                    icon: "list.bullet"
                )
            }
            .padding(16)
            .background(ColorManager.cardBackground)
            .cornerRadius(16)
            .shadow(color: ColorManager.shadowColor, radius: 5, x: 0, y: 3)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(ColorManager.primaryYellow)
            Text(value)
                .font(.titleMedium)
                .foregroundColor(ColorManager.primaryText)
            Text(title)
                .font(.caption)
                .foregroundColor(ColorManager.secondaryText)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StatisticsView(viewModel: SkinCareViewModel())
}
