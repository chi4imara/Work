import SwiftUI

struct UpgradePlanView: View {
    @ObservedObject var viewModel: DeviceViewModel
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                filtersView
                
                if viewModel.filteredImprovements.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    improvementsListView
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Upgrade Plan")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var filtersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterButton(
                    title: "All",
                    isSelected: viewModel.selectedImprovementFilter == nil
                ) {
                    viewModel.selectedImprovementFilter = nil
                }
                
                ForEach(ImprovementStatus.allCases, id: \.self) { status in
                    FilterButton(
                        title: status.rawValue,
                        isSelected: viewModel.selectedImprovementFilter == status
                    ) {
                        viewModel.selectedImprovementFilter = status == viewModel.selectedImprovementFilter ? nil : status
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    private var improvementsListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                summaryCardView
                
                ForEach(viewModel.filteredImprovements) { improvement in
                    NavigationLink(destination: EditImprovementView(improvementId: improvement.id, viewModel: viewModel)) {
                        UpgradePlanRowView(improvement: improvement, deviceName: viewModel.getDeviceName(for: improvement.deviceId))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var summaryCardView: some View {
        let allImprovements = viewModel.allImprovements
        let plannedCount = allImprovements.filter { $0.status == .planned }.count
        let completedCount = allImprovements.filter { $0.status == .completed }.count
        
        return HStack(spacing: 20) {
            VStack(spacing: 4) {
                Text("\(plannedCount)")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorTheme.warning)
                
                Text("Planned")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Divider()
                .frame(height: 40)
                .background(ColorTheme.cardBorder)
            
            VStack(spacing: 4) {
                Text("\(completedCount)")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorTheme.success)
                
                Text("Completed")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Divider()
                .frame(height: 40)
                .background(ColorTheme.cardBorder)
            
            VStack(spacing: 4) {
                Text("\(allImprovements.count)")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorTheme.accentYellow)
                
                Text("Total")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .cardStyle()
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "list.clipboard")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.accentYellow.opacity(0.6))
            
            VStack(spacing: 12) {
                Text(viewModel.allImprovements.isEmpty ? "No planned upgrades" : "No matching upgrades")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(viewModel.allImprovements.isEmpty ? "Add devices and improvements to see your upgrade plan" : "Try adjusting your filters")
                    .font(.ubuntu(16))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct UpgradePlanRowView: View {
    let improvement: Improvement
    let deviceName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(improvement.name)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text(deviceName)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.accentYellow)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(improvement.status.rawValue)
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(statusColor)
                    
                    Text(improvement.updatedAt, style: .date)
                        .font(.ubuntu(10))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
            
            if !improvement.description.isEmpty {
                Text(improvement.description)
                    .font(.ubuntu(14))
                    .foregroundColor(ColorTheme.secondaryText)
                    .lineLimit(3)
            }
        }
        .padding(16)
        .cardStyle()
    }
    
    private var statusColor: Color {
        switch improvement.status {
        case .planned:
            return ColorTheme.warning
        case .completed:
            return ColorTheme.success
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(isSelected ? ColorTheme.primaryPink : ColorTheme.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? ColorTheme.accentYellow : ColorTheme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(isSelected ? ColorTheme.accentYellow : ColorTheme.cardBorder, lineWidth: 1)
                        )
                )
        }
    }
}

#Preview {
    UpgradePlanView(viewModel: DeviceViewModel())
}
