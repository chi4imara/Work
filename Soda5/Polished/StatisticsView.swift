import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var manicureStore: ManicureStore
    @State private var showCharts = false
    
    private var totalManicures: Int {
        manicureStore.manicures.count
    }
    
    private var uniqueColors: Int {
        Set(manicureStore.manicures.map { $0.color.lowercased() }).count
    }
    
    private var uniqueSalons: Int {
        Set(manicureStore.manicures.compactMap { salon in
            salon.salon.isEmpty ? nil : salon.salon.lowercased()
        }).count
    }
    
    private var mostUsedColor: String? {
        let colorCounts = Dictionary(grouping: manicureStore.manicures) { $0.color.lowercased() }
        return colorCounts.max { $0.value.count < $1.value.count }?.key.capitalized
    }
    
    private var averagePerMonth: Double {
        guard !manicureStore.manicures.isEmpty else { return 0 }
        
        let dates = manicureStore.manicures.map { $0.date }
        let calendar = Calendar.current
        
        guard let earliest = dates.min(),
              let latest = dates.max() else { return 0 }
        
        let components = calendar.dateComponents([.month], from: earliest, to: latest)
        let months = max(components.month ?? 1, 1)
        
        return Double(totalManicures) / Double(months)
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("Statistics")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    if !manicureStore.manicures.isEmpty {
                        Button(action: { showCharts.toggle() }) {
                            Image(systemName: showCharts ? "list.bullet" : "chart.pie")
                                .font(.title3)
                                .foregroundColor(AppColors.yellowAccent)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if manicureStore.manicures.isEmpty {
                    emptyStateView
                } else if showCharts {
                    ChartsView()
                } else {
                    statisticsContent
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText.opacity(0.6))
            
            VStack(spacing: 16) {
                Text("No statistics yet")
                    .font(.playfairDisplay(22, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add some manicure records to see your statistics.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(AppColors.blueText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    StatCard(
                        title: "Total Manicures",
                        value: "\(totalManicures)",
                        icon: "paintbrush.fill",
                        color: AppColors.purpleGradient
                    )
                    
                    StatCard(
                        title: "Unique Colors",
                        value: "\(uniqueColors)",
                        icon: "paintpalette.fill",
                        color: AppColors.accentGradient
                    )
                    
                    StatCard(
                        title: "Salons Visited",
                        value: "\(uniqueSalons)",
                        icon: "location.fill",
                        color: LinearGradient(
                            colors: [AppColors.softPink, AppColors.lavender],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    
                    StatCard(
                        title: "Avg per Month",
                        value: String(format: "%.1f", averagePerMonth),
                        icon: "calendar.badge.clock",
                        color: LinearGradient(
                            colors: [AppColors.mintGreen, AppColors.blueText],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                }
                
                if let mostUsed = mostUsedColor {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Most Used Color")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                        
                        HStack {
                            Circle()
                                .fill(AppColors.purpleGradient)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(String(mostUsed.prefix(2)).uppercased())
                                        .font(.playfairDisplay(14, weight: .bold))
                                        .foregroundColor(AppColors.contrastText)
                                )
                            
                            Text(mostUsed)
                                .font(.playfairDisplay(20, weight: .medium))
                                .foregroundColor(AppColors.blueText)
                            
                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(AppColors.backgroundWhite.opacity(0.8))
                    .cornerRadius(16)
                    .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: LinearGradient
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(AppColors.contrastText)
                .frame(width: 40, height: 40)
                .background(color)
                .clipShape(Circle())
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(.playfairDisplay(12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.backgroundWhite.opacity(0.8))
        .cornerRadius(16)
        .shadow(color: AppColors.primaryPurple.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
