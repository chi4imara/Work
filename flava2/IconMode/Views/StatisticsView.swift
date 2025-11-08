import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject var viewModel: VictoryViewModel
    @State private var selectedPeriod: StatsPeriod = .month
    @State private var animateCharts = false
    
    enum StatsPeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackgroundView()
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                if viewModel.victories.isEmpty {
                    emptyStateView
                } else {
                    statisticsContentView
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var statisticsContentView: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerView
                
                keyMetricsView
                
                periodSelectorView
                
                if viewModel.victories.count >= 3 {
                    chartsView
                } else {
                    insufficientDataView
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Statistics")
                    .font(AppFonts.title1)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Your victory insights")
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(AppColors.primary)
        }
    }
    
    private var keyMetricsView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Victories",
                    value: "\(viewModel.totalVictories)",
                    icon: "trophy.fill",
                    color: AppColors.accent
                )
                
                StatCard(
                    title: "Favorites",
                    value: "\(viewModel.totalFavorites)",
                    icon: "star.fill",
                    color: AppColors.secondary
                )
            }
            
            StatCard(
                title: "Most Active Month",
                value: viewModel.mostActiveMonth,
                icon: "calendar.badge.plus",
                color: AppColors.primary,
                isWide: true
            )
            
            if viewModel.totalVictories > 0 {
                StatCard(
                    title: "Favorite Rate",
                    value: String(format: "%.1f%%", viewModel.favoritePercentage),
                    icon: "percent",
                    color: AppColors.success,
                    isWide: true
                )
            }
        }
    }
    
    private var periodSelectorView: some View {
        HStack(spacing: 8) {
            ForEach(StatsPeriod.allCases, id: \.self) { period in
                Button(action: { selectedPeriod = period }) {
                    Text(period.rawValue)
                        .font(AppFonts.pixelCaption)
                        .foregroundColor(selectedPeriod == period ? AppColors.textLight : AppColors.textPrimary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedPeriod == period ? AnyShapeStyle(AppColors.buttonGradient) : AnyShapeStyle(Color.white))
                        .cornerRadius(0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(AppColors.primary, lineWidth: 1)
                        )
                }
            }
            Spacer()
        }
    }
    
    private var chartsView: some View {
        VStack(spacing: 20) {
            if viewModel.totalVictories > 0 {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Victory Distribution")
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.textPrimary)
                    
                    FavoritePieChart(
                        favoriteCount: viewModel.totalFavorites,
                        totalCount: viewModel.totalVictories,
                        animate: animateCharts
                    )
                    .frame(height: 200)
                }
                .padding(20)
                .background(AppColors.cardGradient)
                .cornerRadius(0)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).delay(0.3)) {
                animateCharts = true
            }
        }
    }
    
    private var insufficientDataView: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(AppColors.textSecondary.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("More Data Needed")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Add more victories to see detailed charts and trends. Charts will appear after you have at least 3 victories.")
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
        .background(AppColors.cardGradient)
        .cornerRadius(0)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 64, weight: .light))
                .foregroundColor(AppColors.textSecondary.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No Statistics Yet")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Start adding victories to see your progress and statistics. Your journey begins with the first victory!")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var chartData: [(Date, Int)] {
        let calendar = Calendar.current
        let now = Date()
        
        let startDate: Date
        switch selectedPeriod {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        }
        
        let interval = DateInterval(start: startDate, end: now)
        return viewModel.victoriesCountByDay(for: interval)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var isWide: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(color)
                
                if !isWide {
                    Spacer()
                }
            }
            
            VStack(alignment: isWide ? .leading : .center, spacing: 4) {
                Text(value)
                    .font(AppFonts.pixelTitle)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(title)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(isWide ? .leading : .center)
            }
            .frame(maxWidth: .infinity, alignment: isWide ? .leading : .center)
        }
        .padding(16)
        .background(AppColors.cardGradient)
        .cornerRadius(0)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(color.opacity(0.3), lineWidth: 2)
        )
    }
}

struct VictoryLineChart: View {
    let data: [(Date, Int)]
    let period: StatisticsView.StatsPeriod
    let animate: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .bottom, spacing: 4) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    VStack {
                        Spacer()
                        
                        Rectangle()
                            .fill(AppColors.buttonGradient)
                            .frame(width: 8, height: CGFloat(item.1 * 20 + 10))
                            .cornerRadius(0)
                            .scaleEffect(y: animate ? 1.0 : 0.1, anchor: .bottom)
                            .animation(.easeInOut(duration: 0.8).delay(Double(index) * 0.1), value: animate)
                        
                        Spacer(minLength: 10)
                        
                        Text("\(Calendar.current.component(.day, from: item.0))")
                            .font(AppFonts.caption2)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct FavoritePieChart: View {
    let favoriteCount: Int
    let totalCount: Int
    let animate: Bool
    
    private var favoritePercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(favoriteCount) / Double(totalCount)
    }
    
    var body: some View {
        HStack(spacing: 32) {
            ZStack {
                Circle()
                    .stroke(AppColors.textSecondary.opacity(0.2), lineWidth: 20)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: animate ? favoritePercentage : 0)
                    .stroke(AppColors.accent, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.5), value: animate)
                
                VStack(spacing: 2) {
                    Text("\(Int(favoritePercentage * 100))%")
                        .font(AppFonts.pixelTitle)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Favorites")
                        .font(AppFonts.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Circle()
                        .fill(AppColors.accent)
                        .frame(width: 12, height: 12)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Favorites")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("\(favoriteCount) victories")
                            .font(AppFonts.caption1)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                HStack {
                    Circle()
                        .fill(AppColors.textSecondary.opacity(0.4))
                        .frame(width: 12, height: 12)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Regular")
                            .font(AppFonts.callout)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("\(totalCount - favoriteCount) victories")
                            .font(AppFonts.caption1)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    StatisticsView()
        .environmentObject(VictoryViewModel())
}
