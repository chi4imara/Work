import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var reactionsViewModel: ReactionsViewModel
    
    private var statistics: ReactionStatistics {
        reactionsViewModel.getStatistics()
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if statistics.totalCount == 0 {
                    emptyStateView
                } else {
                    statisticsContent
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.ibmPlexMono(28, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.accentPurple.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "chart.bar")
                    .font(.system(size: 50, weight: .medium))
                    .foregroundColor(AppColors.accentPurple.opacity(0.6))
            }
            
            VStack(spacing: 12) {
                Text("No statistics yet")
                    .font(.ibmPlexMono(20, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("No data for statistics yet. Add some reactions to see your patterns.")
                    .font(.ibmPlexMono(14, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                totalCountCard
                
                typeBreakdownSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var totalCountCard: some View {
        VStack(spacing: 16) {
            Text("Total Reactions")
                .font(.ibmPlexMono(16, weight: .semibold))
                .foregroundColor(AppColors.textSecondary)
            
            Text("\(statistics.totalCount)")
                .font(.ibmPlexMono(48, weight: .bold))
                .foregroundColor(AppColors.primaryBlue)
            
            Text("reactions captured")
                .font(.ibmPlexMono(14, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    private var typeBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("By Category")
                .font(.ibmPlexMono(20, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            VStack(spacing: 12) {
                ForEach(ReactionType.allCases, id: \.id) { type in
                    StatisticRow(
                        type: type,
                        count: statistics.count(for: type),
                        total: statistics.totalCount
                    )
                }
            }
        }
    }
}

struct StatisticRow: View {
    let type: ReactionType
    let count: Int
    let total: Int
    
    private var percentage: Double {
        total > 0 ? Double(count) / Double(total) : 0
    }
    
    private var typeColor: Color {
        switch type {
        case .movie: return AppColors.primaryBlue
        case .food: return AppColors.accentOrange
        case .place: return AppColors.accentGreen
        case .person: return AppColors.accentPurple
        case .other: return AppColors.primaryYellow
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(typeColor.opacity(0.1))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: type.iconName)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(typeColor)
                    }
                    
                    Text(type.rawValue)
                        .font(.ibmPlexMono(16, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                }
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(count)")
                        .font(.ibmPlexMono(18, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("\(Int(percentage * 100))%")
                        .font(.ibmPlexMono(12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppColors.textSecondary.opacity(0.1))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(typeColor)
                        .frame(width: geometry.size.width * CGFloat(percentage), height: 6)
                        .cornerRadius(3)
                        .animation(.easeInOut(duration: 0.8), value: percentage)
                }
            }
            .frame(height: 6)
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}
