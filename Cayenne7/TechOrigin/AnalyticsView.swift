import SwiftUI

struct AnalyticsView: View {
    @ObservedObject var viewModel: DeviceViewModel
    
    var totalDevices: Int {
        viewModel.devices.count
    }
    
    var totalValue: String {
        "Analytics Coming Soon"
    }
    
    var mostUsedCategory: DeviceCategory? {
        viewModel.categoryCounts.max(by: { $0.value < $1.value })?.key
    }
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Analytics")
                            .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Insights about your collection")
                            .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            StatCard(
                                title: "Total Devices",
                                value: "\(totalDevices)",
                                icon: "laptopcomputer.and.iphone",
                                color: AppColors.accentBlue
                            )
                            
                            StatCard(
                                title: "Categories",
                                value: "\(viewModel.categoryCounts.count)",
                                icon: "folder",
                                color: AppColors.accentOrange
                            )
                        }
                        
                        if let mostUsed = mostUsedCategory {
                            StatCard(
                                title: "Most Used Category",
                                value: mostUsed.displayName,
                                icon: "chart.bar",
                                color: AppColors.accentPurple,
                                isWide: true
                            )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Device Distribution")
                            .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                        
                        ChartPlaceholder(categoryCounts: viewModel.categoryCounts)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 120)
                .padding(.horizontal, 20)
            }
        }
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
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(FontManager.playfairDisplay(size: isWide ? 18 : 20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(FontManager.playfairDisplay(size: 12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
    }
}

struct ChartPlaceholder: View {
    let categoryCounts: [DeviceCategory: Int]
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(Array(categoryCounts.keys), id: \.self) { category in
                let count = categoryCounts[category] ?? 0
                let maxCount = categoryCounts.values.max() ?? 1
                let percentage = Double(count) / Double(maxCount)
                
                HStack {
                    Text(category.displayName)
                        .font(FontManager.playfairDisplay(size: 14, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 80, alignment: .leading)
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(AppColors.secondaryBackground.opacity(0.3))
                                .frame(height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .fill(categoryColor(for: category))
                                .frame(width: geometry.size.width * percentage, height: 8)
                                .cornerRadius(4)
                        }
                    }
                    .frame(height: 8)
                    
                    Text("\(count)")
                        .font(FontManager.playfairDisplay(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 30, alignment: .trailing)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardGradient)
        .cornerRadius(16)
    }
    
    private func categoryColor(for category: DeviceCategory) -> Color {
        switch category {
        case .phones:
            return AppColors.accentBlue
        case .computers:
            return AppColors.accentPurple
        case .electronics:
            return AppColors.accentOrange
        case .tools:
            return AppColors.accentGreen
        case .other:
            return AppColors.secondaryText
        }
    }
}

#Preview {
    AnalyticsView(viewModel: DeviceViewModel())
}
