import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var animateChart = false
    @State private var animateStats = false
    
    var body: some View {
        ZStack {
            StaticBackground()
        
                if !viewModel.statistics.hasData {
                    emptyStateView
                } else {
                    statisticsContentView
                }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateStats = true
            }
            
            withAnimation(.easeOut(duration: 1.0).delay(0.5)) {
                animateChart = true
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            HStack {
                Text("Statistics")
                    .font(.theme.title1)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top)
            
            Spacer()
            
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.lightBlue)
            
            VStack(spacing: 12) {
                Text("No Data Yet")
                    .font(.theme.title2)
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("Start using the app to see your statistics here")
                    .font(.theme.body)
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            VStack(spacing: 12) {
                Button(action: {
                    viewModel.selectedTab = 1
                }) {
                    HStack {
                        Image(systemName: "circle.grid.cross.fill")
                        Text("Spin the Wheel")
                    }
                    .font(.theme.callout)
                    .foregroundColor(ColorTheme.textLight)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(ColorTheme.buttonGradient)
                    .cornerRadius(22)
                }
                
                Button(action: {
                    viewModel.selectedTab = 2
                }) {
                    HStack {
                        Image(systemName: "theatermasks.fill")
                        Text("Generate Theme")
                    }
                    .font(.theme.callout)
                    .foregroundColor(ColorTheme.accentPurple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .fill(ColorTheme.backgroundWhite)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(ColorTheme.accentPurple, lineWidth: 2)
                    )
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var statisticsContentView: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("Statistics")
                    .font(.theme.title1)
                    .foregroundColor(.black)
                
                statsOverviewSection
                
                chartSection
                
                detailedStatsSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    private var statsOverviewSection: some View {
        VStack(spacing: 16) {
            Text("Activity Overview")
                .font(.theme.title3)
                .foregroundColor(ColorTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Wheel Spins",
                    value: "\(viewModel.statistics.wheelSpins)",
                    icon: "circle.grid.cross.fill",
                    color: ColorTheme.primaryBlue,
                    isAnimated: animateStats
                )
                
                StatCard(
                    title: "Themes",
                    value: "\(viewModel.statistics.themesGenerated)",
                    icon: "theatermasks.fill",
                    color: ColorTheme.accentPurple,
                    isAnimated: animateStats
                )
                
                StatCard(
                    title: "Favorites",
                    value: "\(viewModel.favorites.count)",
                    icon: "heart.fill",
                    color: ColorTheme.accentPink,
                    isAnimated: animateStats
                )
            }
        }
        .opacity(animateStats ? 1.0 : 0.0)
        .offset(y: animateStats ? 0 : 20)
    }
    
    private var chartSection: some View {
        VStack(spacing: 16) {
            Text("Usage Distribution")
                .font(.theme.title3)
                .foregroundColor(ColorTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            BarChartView(
                data: [
                    ChartData(label: "Wheel", value: viewModel.statistics.wheelSpins, color: ColorTheme.primaryBlue),
                    ChartData(label: "Themes", value: viewModel.statistics.themesGenerated, color: ColorTheme.accentPurple),
                    ChartData(label: "Favorites", value: viewModel.favorites.count, color: ColorTheme.accentPink)
                ],
                isAnimated: animateChart
            )
            .frame(height: 200)
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.backgroundWhite)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .opacity(animateChart ? 1.0 : 0.0)
        .offset(y: animateChart ? 0 : 30)
    }
    
    private var detailedStatsSection: some View {
        VStack(spacing: 16) {
            Text("Detailed Statistics")
                .font(.theme.title3)
                .foregroundColor(ColorTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                DetailedStatRow(
                    title: "Total Actions",
                    value: "\(viewModel.statistics.totalActions)",
                    subtitle: "All interactions combined"
                )
                
                DetailedStatRow(
                    title: "Current Tasks",
                    value: "\(viewModel.tasks.count)",
                    subtitle: "Available wheel tasks"
                )
                
                DetailedStatRow(
                    title: "Current Favorites",
                    value: "\(viewModel.favorites.count)",
                    subtitle: "Items currently saved"
                )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.backgroundWhite)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
        .opacity(animateStats ? 1.0 : 0.0)
        .offset(y: animateStats ? 0 : 20)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let isAnimated: Bool
    
    @State private var animateValue = false
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
                .scaleEffect(animateValue ? 1.1 : 1.0)
            
            Text(value)
                .font(.theme.title2)
                .foregroundColor(ColorTheme.textPrimary)
                .scaleEffect(animateValue ? 1.0 : 0.8)
            
            Text(title)
                .font(.theme.caption1)
                .foregroundColor(ColorTheme.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .onChange(of: isAnimated) { animated in
            if animated {
                withAnimation(.easeOut(duration: 0.6).delay(0.1)) {
                    animateValue = true
                }
            }
        }
    }
}

struct ChartData {
    let label: String
    let value: Int
    let color: Color
}

struct BarChartView: View {
    let data: [ChartData]
    let isAnimated: Bool
    
    private var maxValue: Int {
        data.map { $0.value }.max() ?? 1
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 20) {
            ForEach(data.indices, id: \.self) { index in
                let item = data[index]
                
                VStack(spacing: 8) {
                    Text("\(item.value)")
                        .font(.theme.caption1)
                        .foregroundColor(ColorTheme.textPrimary)
                        .opacity(isAnimated ? 1.0 : 0.0)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(item.color)
                        .frame(width: 40)
                        .frame(height: isAnimated ? CGFloat(item.value) / CGFloat(maxValue) * 120 : 0)
                        .animation(.easeOut(duration: 0.8).delay(Double(index) * 0.1), value: isAnimated)
                    
                    Text(item.label)
                        .font(.theme.caption2)
                        .foregroundColor(ColorTheme.textSecondary)
                        .opacity(isAnimated ? 1.0 : 0.0)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct DetailedStatRow: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.theme.callout)
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text(subtitle)
                    .font(.theme.caption2)
                    .foregroundColor(ColorTheme.textSecondary)
            }
            
            Spacer()
            
            Text(value)
                .font(.theme.title3)
                .foregroundColor(ColorTheme.primaryBlue)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    StatisticsView(viewModel: AppViewModel())
}
