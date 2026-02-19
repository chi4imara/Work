import SwiftUI

struct DynamicsView: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    @State private var selectedZone: BodyZone = .weight
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Dynamics")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if measurementStore.measurements.isEmpty {
                    EmptyDynamicsView()
                    
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 25) {
                            ZoneSelectorView(selectedZone: $selectedZone)
                            
                            ChartSectionView(zone: selectedZone)
                            
                            StatisticsSectionView(zone: selectedZone)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
    }
}

struct EmptyDynamicsView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.lightBlue.opacity(0.6))
            
            VStack(spacing: 15) {
                Text("No Data for Charts")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Text("Add some measurements to see your progress dynamics")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct ZoneSelectorView: View {
    @Binding var selectedZone: BodyZone
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Select Parameter")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(BodyZone.allCases, id: \.self) { zone in
                        ZoneSelectorButton(
                            zone: zone,
                            isSelected: selectedZone == zone
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedZone = zone
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -20)
        }
    }
}

struct ZoneSelectorButton: View {
    let zone: BodyZone
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: zoneIcon)
                    .font(.system(size: 16, weight: .medium))
                
                Text(zone.rawValue)
                    .font(.ubuntu(14, weight: .medium))
            }
            .foregroundColor(isSelected ? AppColors.white : AppColors.white.opacity(0.7))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? AppColors.buttonGradient : AppColors.cardGradient)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var zoneIcon: String {
        switch zone {
        case .weight:
            return "scalemass"
        case .chest:
            return "figure.arms.open"
        case .arms:
            return "figure.strengthtraining.traditional"
        case .shoulders:
            return "figure.flexibility"
        }
    }
}

struct ChartSectionView: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    let zone: BodyZone
    
    private var chartData: [(Date, Double)] {
        measurementStore.getMeasurements(for: zone).filter { $0.1 > 0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("\(zone.rawValue) Progress")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.white)
                
                Spacer()
                
                Text("(\(zone.unit))")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.white.opacity(0.6))
            }
            
            VStack(spacing: 15) {
                LineChart(dataPoints: chartData, zone: zone)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(AppColors.cardGradient)
            .cornerRadius(20)
            .shadow(color: AppColors.darkBlue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
}

struct StatisticsSectionView: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    let zone: BodyZone
    
    private var statistics: (min: Double, max: Double, count: Int) {
        measurementStore.getStatistics(for: zone)
    }
    
    private var trend: String {
        let data = measurementStore.getMeasurements(for: zone).filter { $0.1 > 0 }
        guard data.count >= 2 else { return "—" }
        
        let recent = data.suffix(3).map { $0.1 }
        let older = data.dropLast(min(3, data.count)).suffix(3).map { $0.1 }
        
        guard !recent.isEmpty && !older.isEmpty else { return "—" }
        
        let recentAvg = recent.reduce(0, +) / Double(recent.count)
        let olderAvg = older.reduce(0, +) / Double(older.count)
        
        let change = recentAvg - olderAvg
        let changePercent = abs(change / olderAvg * 100)
        
        if abs(change) < 0.1 {
            return "Stable"
        } else if change > 0 {
            return "↗ +\(String(format: "%.1f", changePercent))%"
        } else {
            return "↘ -\(String(format: "%.1f", changePercent))%"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Statistics")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.white)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                StatisticCard(
                    title: "Maximum",
                    value: statistics.max > 0 ? String(format: "%.1f", statistics.max) : "—",
                    unit: statistics.max > 0 ? zone.unit : "",
                    icon: "arrow.up.circle",
                    color: AppColors.success
                )
                
                StatisticCard(
                    title: "Minimum",
                    value: statistics.min > 0 ? String(format: "%.1f", statistics.min) : "—",
                    unit: statistics.min > 0 ? zone.unit : "",
                    icon: "arrow.down.circle",
                    color: AppColors.lightBlue
                )
                
                StatisticCard(
                    title: "Measurements",
                    value: "\(statistics.count)",
                    unit: "total",
                    icon: "number.circle",
                    color: AppColors.orange
                )
                
                StatisticCard(
                    title: "Trend",
                    value: trend,
                    unit: "",
                    icon: "chart.line.uptrend.xyaxis.circle",
                    color: AppColors.warning
                )
            }
        }
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.white.opacity(0.7))
                
                HStack(alignment: .bottom, spacing: 2) {
                    Text(value)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(AppColors.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    if !unit.isEmpty {
                        Text(unit)
                            .font(.ubuntu(10))
                            .foregroundColor(AppColors.white.opacity(0.6))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .shadow(color: AppColors.darkBlue.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    DynamicsView()
        .environmentObject(MeasurementStore())
}
