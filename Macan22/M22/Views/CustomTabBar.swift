import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .frame(height: 70)
        .background(
            ZStack {
                AppColors.cardGradient
                    .blur(radius: 20)
                
                RoundedRectangle(cornerRadius: 35)
                    .fill(AppColors.deepBlue.opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 35)
                            .stroke(AppColors.yellow.opacity(0.2), lineWidth: 1)
                    )
            }
        )
        .cornerRadius(35)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .shadow(color: AppColors.deepBlue.opacity(0.3), radius: 15, x: 0, y: -5)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.buttonGradient)
                            .frame(width: 32, height: 32)
                            .shadow(color: AppColors.yellow.opacity(0.4), radius: 8, x: 0, y: 2)
                    }
                    
                    Image(systemName: tab.iconName)
                        .font(.system(size: isSelected ? 16 : 18, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.white : AppColors.white.opacity(0.6))
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.title)
                    .font(.playfairDisplay(.medium, size: 10))
                    .foregroundColor(isSelected ? AppColors.white : AppColors.white.opacity(0.6))
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}

enum TabItem: CaseIterable {
    case collection
    case categories
    case filters
    case statistics
    case settings
    
    var title: String {
        switch self {
        case .collection: return "Collection"
        case .categories: return "Categories"
        case .filters: return "Filters"
        case .statistics: return "Statistics"
        case .settings: return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .collection: return "house.fill"
        case .categories: return "square.grid.2x2"
        case .filters: return "line.3.horizontal.decrease"
        case .statistics: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.collection))
    }
    .background(AppBackground())
}
