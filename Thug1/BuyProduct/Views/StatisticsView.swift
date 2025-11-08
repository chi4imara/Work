import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var purchaseStore: PurchaseStore
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            VStack {
                HStack(alignment: .top) {
                    Text("Statistics")
                        .font(.titleLarge)
                        .foregroundColor(.primaryWhite)
                    
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
                
                if purchaseStore.totalPurchases == 0 {
                    EmptyStateView(
                        icon: "chart.bar",
                        title: "No data for statistics",
                        description: "Add some purchases to see statistics",
                        buttonTitle: "Add Purchase",
                        buttonAction: {
                            selectedTab = .purchases
                        }
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            OverviewStatsView()
                            
                            CategoryChartView()
                            
                            StatusChartView()
                            
                            ServiceLifeChartView()
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
}

struct OverviewStatsView: View {
    @EnvironmentObject var purchaseStore: PurchaseStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.titleMedium)
                .foregroundColor(.primaryWhite)
                .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                StatCard(
                    title: "Total Purchases",
                    value: "\(purchaseStore.totalPurchases)",
                    icon: "bag.fill",
                    color: .primaryYellow
                )
                
                StatCard(
                    title: "Favorites",
                    value: "\(purchaseStore.favoriteCount)",
                    icon: "star.fill",
                    color: .accentPurple
                )
                
                StatCard(
                    title: "Normal Status",
                    value: "\(purchaseStore.purchasesByStatus[.normal] ?? 0)",
                    icon: "checkmark.circle.fill",
                    color: .statusNormal
                )
                
                StatCard(
                    title: "Need Attention",
                    value: "\((purchaseStore.purchasesByStatus[.soonReplacement] ?? 0) + (purchaseStore.purchasesByStatus[.overdue] ?? 0))",
                    icon: "exclamationmark.triangle.fill",
                    color: .statusWarning
                )
            }
            .padding(.horizontal, 20)
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
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.titleMedium)
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.bodySmall)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

struct CategoryChartView: View {
    @EnvironmentObject var purchaseStore: PurchaseStore
    
    var chartData: [ChartData] {
        purchaseStore.purchasesByCategory.map { category, count in
            ChartData(
                name: category.rawValue,
                value: Double(count),
                color: colorForCategory(category)
            )
        }.sorted { $0.value > $1.value }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Categories")
                .font(.titleMedium)
                .foregroundColor(.primaryWhite)
                .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                PieChartView(data: chartData)
                    .frame(height: 200)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                    ForEach(chartData, id: \.name) { item in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(item.color)
                                .frame(width: 12, height: 12)
                            
                            Text("\(item.name) (\(Int(item.value)))")
                                .font(.bodySmall)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .padding(.horizontal, 20)
        }
    }
    
    private func colorForCategory(_ category: PurchaseCategory) -> Color {
        switch category {
        case .furniture:
            return .brown
        case .appliances:
            return .blue
        case .electronics:
            return .purple
        case .other:
            return .gray
        }
    }
}

struct StatusChartView: View {
    @EnvironmentObject var purchaseStore: PurchaseStore
    
    var chartData: [ChartData] {
        purchaseStore.purchasesByStatus.map { status, count in
            ChartData(
                name: status.rawValue,
                value: Double(count),
                color: colorForStatus(status)
            )
        }.sorted { $0.value > $1.value }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Status Distribution")
                .font(.titleMedium)
                .foregroundColor(.primaryWhite)
                .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                BarChartView(data: chartData)
                    .frame(height: 150)
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .padding(.horizontal, 20)
        }
    }
    
    private func colorForStatus(_ status: PurchaseStatus) -> Color {
        switch status {
        case .normal:
            return .statusNormal
        case .soonReplacement:
            return .statusWarning
        case .overdue:
            return .statusDanger
        }
    }
}

struct ServiceLifeChartView: View {
    @EnvironmentObject var purchaseStore: PurchaseStore
    
    var chartData: [ChartData] {
        purchaseStore.purchasesByServiceLife.map { range, count in
            ChartData(
                name: range,
                value: Double(count),
                color: colorForRange(range)
            )
        }.sorted { order(for: $0.name) < order(for: $1.name) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Service Life Distribution")
                .font(.titleMedium)
                .foregroundColor(.primaryWhite)
                .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                BarChartView(data: chartData)
                    .frame(height: 150)
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .padding(.horizontal, 20)
        }
    }
    
    private func colorForRange(_ range: String) -> Color {
        switch range {
        case "1-3 years":
            return .red
        case "4-6 years":
            return .orange
        case "7+ years":
            return .green
        default:
            return .gray
        }
    }
    
    private func order(for range: String) -> Int {
        switch range {
        case "1-3 years":
            return 0
        case "4-6 years":
            return 1
        case "7+ years":
            return 2
        default:
            return 3
        }
    }
}

struct ChartData {
    let name: String
    let value: Double
    let color: Color
}

struct PieChartView: View {
    let data: [ChartData]
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2 - 20
            
            ZStack {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    PieSlice(
                        startAngle: startAngle(for: index),
                        endAngle: endAngle(for: index),
                        center: center,
                        radius: radius
                    )
                    .fill(item.color)
                }
            }
        }
    }
    
    private func startAngle(for index: Int) -> Angle {
        let total = data.reduce(0) { $0 + $1.value }
        let previousSum = data.prefix(index).reduce(0) { $0 + $1.value }
        return Angle(degrees: (previousSum / total) * 360 - 90)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let total = data.reduce(0) { $0 + $1.value }
        let currentSum = data.prefix(index + 1).reduce(0) { $0 + $1.value }
        return Angle(degrees: (currentSum / total) * 360 - 90)
    }
}

struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let center: CGPoint
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}

struct BarChartView: View {
    let data: [ChartData]
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.map { $0.value }.max() ?? 1
            let barWidth = (geometry.size.width - CGFloat(data.count + 1) * 8) / CGFloat(data.count)
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                    VStack(spacing: 4) {
                        Rectangle()
                            .fill(item.color)
                            .frame(width: barWidth, height: (item.value / maxValue) * (geometry.size.height - 30))
                        
                        Text(item.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(width: barWidth)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
    }
}
