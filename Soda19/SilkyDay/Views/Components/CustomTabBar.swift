import SwiftUI

enum TabItem: String, CaseIterable {
    case journal = "journal"
    case products = "products"
    case analytics = "analytics"
    case tips = "tips"
    case settings = "settings"
    
    var title: String {
        switch self {
        case .journal:
            return "Journal"
        case .products:
            return "Products"
        case .analytics:
            return "Analytics"
        case .settings:
            return "Settings"
        case .tips:
            return "Tips"
        }
    }
    
    var icon: String {
        switch self {
        case .journal:
            return "book.fill"
        case .products:
            return "drop.fill"
        case .analytics:
            return "chart.bar.fill"
        case .settings:
            return "gearshape.fill"
        case .tips:
            return "lightbulb.fill"
        }
    }
}

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
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.yellow.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.yellow : AppColors.primaryText.opacity(0.6))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(AppFonts.tabBar)
                    .foregroundColor(isSelected ? AppColors.yellow : AppColors.primaryText.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? AppColors.yellow.opacity(0.15) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        AppColors.backgroundGradient
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.journal))
        }
    }
}
