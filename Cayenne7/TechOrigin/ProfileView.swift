import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: DeviceViewModel
    
    var body: some View {
        ZStack {
            AppColors.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(AppColors.cardGradient)
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 50, weight: .medium))
                                .foregroundColor(AppColors.accentBlue)
                        }
                        
                        VStack(spacing: 8) {
                            Text("Tech Collector")
                                .font(FontManager.playfairDisplay(size: 24, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Managing your digital life")
                                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 16) {
                        Text("Collection Overview")
                            .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ProfileStatCard(
                                title: "Total Devices",
                                value: "\(viewModel.devices.count)",
                                icon: "laptopcomputer.and.iphone",
                                color: AppColors.accentBlue
                            )
                            
                            ProfileStatCard(
                                title: "Categories",
                                value: "\(viewModel.categoryCounts.count)",
                                icon: "folder.fill",
                                color: AppColors.accentOrange
                            )
                            
                            ProfileStatCard(
                                title: "New Condition",
                                value: "\(newDevicesCount)",
                                icon: "sparkles",
                                color: AppColors.accentGreen
                            )
                            
                            ProfileStatCard(
                                title: "Need Repair",
                                value: "\(repairNeededCount)",
                                icon: "wrench.fill",
                                color: AppColors.buttonDanger
                            )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Activity")
                            .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                        
                        if viewModel.devices.isEmpty {
                            Text("No devices added yet")
                                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                .foregroundColor(AppColors.secondaryText)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.vertical, 20)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(recentDevices.prefix(3), id: \.id) { device in
                                    RecentActivityCard(device: device)
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private var newDevicesCount: Int {
        viewModel.devices.filter { $0.condition == .new }.count
    }
    
    private var repairNeededCount: Int {
        viewModel.devices.filter { $0.condition == .needsRepair }.count
    }
    
    private var recentDevices: [Device] {
        viewModel.devices.sorted { $0.purchaseDate > $1.purchaseDate }
    }
}

struct ProfileStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(FontManager.playfairDisplay(size: 18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Text(title)
                    .font(FontManager.playfairDisplay(size: 11, weight: .medium))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardGradient)
        .cornerRadius(12)
    }
}

struct RecentActivityCard: View {
    let device: Device
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(categoryColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(categoryColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(FontManager.playfairDisplay(size: 14, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Added \(timeAgo)")
                    .font(FontManager.playfairDisplay(size: 12, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            Spacer()
            
            Text(device.condition.rawValue)
                .font(FontManager.playfairDisplay(size: 10, weight: .medium))
                .foregroundColor(conditionColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(conditionColor.opacity(0.2))
                .cornerRadius(6)
        }
        .padding(12)
        .background(AppColors.cardGradient)
        .cornerRadius(10)
    }
    
    private var categoryColor: Color {
        switch device.category {
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
    
    private var categoryIcon: String {
        switch device.category {
        case .phones:
            return "iphone"
        case .computers:
            return "laptopcomputer"
        case .electronics:
            return "tv"
        case .tools:
            return "hammer"
        case .other:
            return "questionmark.circle"
        }
    }
    
    private var conditionColor: Color {
        switch device.condition {
        case .new:
            return AppColors.accentGreen
        case .good:
            return AppColors.accentBlue
        case .used:
            return AppColors.accentOrange
        case .needsRepair:
            return AppColors.buttonDanger
        }
    }
    
    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: device.purchaseDate, relativeTo: Date())
    }
}

#Preview {
    ProfileView(viewModel: DeviceViewModel())
}
