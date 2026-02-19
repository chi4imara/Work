import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: DeviceViewModel
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    overviewCards
                    
                    categoryStats
                    
                    improvementStats
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
    }
    
    private var overviewCards: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    title: "Total Devices",
                    value: "\(viewModel.devices.count)",
                    icon: "desktopcomputer",
                    color: ColorTheme.accentYellow
                )
                
                StatCard(
                    title: "Total Improvements",
                    value: "\(viewModel.allImprovements.count)",
                    icon: "wrench.and.screwdriver",
                    color: ColorTheme.info
                )
            }
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Planned",
                    value: "\(plannedCount)",
                    icon: "clock.fill",
                    color: ColorTheme.warning
                )
                
                StatCard(
                    title: "Completed",
                    value: "\(completedCount)",
                    icon: "checkmark.circle.fill",
                    color: ColorTheme.success
                )
            }
        }
    }
    
    private var categoryStats: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Devices by Category")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                ForEach(DeviceCategory.allCases, id: \.self) { category in
                    CategoryStatRow(
                        category: category,
                        count: viewModel.deviceCount(for: category),
                        total: viewModel.devices.count
                    )
                }
            }
            .cardStyle()
        }
    }
    
    private var improvementStats: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Improvement Progress")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 16) {
                ProgressBar(
                    title: "Completion Rate",
                    progress: completionRate,
                    color: ColorTheme.success
                )
                
                if !viewModel.devices.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Top Devices")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        ForEach(topDevices.prefix(3), id: \.id) { device in
                            DeviceStatRow(device: device)
                        }
                    }
                    .padding(16)
                    .cardStyle()
                }
            }
        }
    }
    
    private var plannedCount: Int {
        viewModel.allImprovements.filter { $0.status == .planned }.count
    }
    
    private var completedCount: Int {
        viewModel.allImprovements.filter { $0.status == .completed }.count
    }
    
    private var completionRate: Double {
        let total = viewModel.allImprovements.count
        guard total > 0 else { return 0 }
        return Double(completedCount) / Double(total)
    }
    
    private var topDevices: [Device] {
        viewModel.devices.sorted { $0.improvements.count > $1.improvements.count }
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
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 20)
        .cardStyle()
    }
}

struct CategoryStatRow: View {
    let category: DeviceCategory
    let count: Int
    let total: Int
    
    var body: some View {
        HStack {
            Image(systemName: categoryIcon)
                .font(.system(size: 20))
                .foregroundColor(ColorTheme.accentYellow)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.rawValue)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                if total > 0 {
                    Text("\(Int((Double(count) / Double(total)) * 100))% of total")
                        .font(.ubuntu(12))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            
            Spacer()
            
            Text("\(count)")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.accentYellow)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    private var categoryIcon: String {
        switch category {
        case .pc:
            return "desktopcomputer"
        case .console:
            return "gamecontroller"
        case .peripherals:
            return "keyboard"
        case .accessories:
            return "cable.connector"
        }
    }
}

struct ProgressBar: View {
    let title: String
    let progress: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ColorTheme.cardBackground)
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(progress), height: 12)
                }
            }
            .frame(height: 12)
        }
        .padding(16)
        .cardStyle()
    }
}

struct DeviceStatRow: View {
    let device: Device
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("\(device.improvements.count) improvement\(device.improvements.count == 1 ? "" : "s")")
                    .font(.ubuntu(12))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            let completed = device.improvements.filter { $0.status == .completed }.count
            let total = device.improvements.count
            if total > 0 {
                Text("\(completed)/\(total)")
                    .font(.ubuntu(14, weight: .bold))
                    .foregroundColor(ColorTheme.accentYellow)
            }
        }
    }
}

#Preview {
    StatisticsView(viewModel: DeviceViewModel())
}
