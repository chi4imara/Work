import SwiftUI

struct StatisticsView: View {
    @ObservedObject private var viewModel = JewelryViewModel.shared
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.jewelries.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    statisticsContent
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(.playfairDisplay(28, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60))
                .foregroundColor(ColorTheme.accent)
            
            Text("No statistics yet")
                .font(.playfairDisplay(20, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
            
            Text("Add jewelry pieces to see statistics here.")
                .font(.playfairDisplay(16))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                StatCard(
                    icon: "sparkles",
                    title: "Total Jewelry",
                    value: "\(viewModel.jewelries.count)",
                    subtitle: viewModel.jewelries.count == 1 ? "piece" : "pieces",
                    color: ColorTheme.lightBlue
                )
                
                StatCard(
                    icon: "heart.fill",
                    title: "Favorites",
                    value: "\(viewModel.favoriteJewelries.count)",
                    subtitle: viewModel.favoriteJewelries.count == 1 ? "favorite" : "favorites",
                    color: ColorTheme.orange
                )
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("By Style")
                        .font(.playfairDisplay(20, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    VStack(spacing: 12) {
                        ForEach(Array(viewModel.styleGroups.keys.sorted()), id: \.self) { styleName in
                            let count = viewModel.styleGroups[styleName]?.count ?? 0
                            StyleStatRow(styleName: styleName, count: count)
                        }
                    }
                }
                .padding(20)
                .background(ColorTheme.cardGradient)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.accent.opacity(0.2), lineWidth: 1)
                )
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("By Type")
                        .font(.playfairDisplay(20, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    VStack(spacing: 12) {
                        ForEach(JewelryType.allCases, id: \.self) { type in
                            let count = viewModel.jewelries.filter { $0.type == type }.count
                            if count > 0 {
                                TypeStatRow(type: type, count: count)
                            }
                        }
                    }
                }
                .padding(20)
                .background(ColorTheme.cardGradient)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ColorTheme.accent.opacity(0.2), lineWidth: 1)
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
                
                HStack(alignment: .lastTextBaseline, spacing: 8) {
                    Text(value)
                        .font(.playfairDisplay(32, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text(subtitle)
                        .font(.playfairDisplay(14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            
            Spacer()
        }
        .padding(20)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct StyleStatRow: View {
    let styleName: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(styleName)
                .font(.playfairDisplay(16, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Text("\(count)")
                .font(.playfairDisplay(18, weight: .bold))
                .foregroundColor(ColorTheme.lightBlue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(ColorTheme.lightBlue.opacity(0.2))
                .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }
}

struct TypeStatRow: View {
    let type: JewelryType
    let count: Int
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: typeIcon(for: type))
                    .font(.system(size: 18))
                    .foregroundColor(ColorTheme.orange)
                    .frame(width: 24)
                
                Text(type.displayName)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            Spacer()
            
            Text("\(count)")
                .font(.playfairDisplay(18, weight: .bold))
                .foregroundColor(ColorTheme.orange)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(ColorTheme.orange.opacity(0.2))
                .cornerRadius(8)
        }
        .padding(.vertical, 4)
    }
    
    private func typeIcon(for type: JewelryType) -> String {
        switch type {
        case .earrings:
            return "circle"
        case .ring:
            return "circle.fill"
        case .bracelet:
            return "circle.dotted"
        case .necklace:
            return "circle.circle"
        case .choker:
            return "circle.circle.fill"
        case .brooch:
            return "star"
        case .other:
            return "sparkles"
        }
    }
}

#Preview {
    StatisticsView()
}
