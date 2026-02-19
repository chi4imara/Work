import SwiftUI

enum TabItem: String, CaseIterable {
    case catalog = "Catalog"
    case categories = "Categories"
    case add = "Add"
    case filters = "Filters"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .catalog:
            return "list.bullet"
        case .categories:
            return "square.grid.2x2"
        case .filters:
            return "line.3.horizontal.decrease.circle"
        case .settings:
            return "gearshape"
        case .add:
            return "plus.circle.fill"
        }
    }
    
    var title: String {
        return rawValue
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
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
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
                ZStack {
                    if tab == .add {
                        Circle()
                            .fill(AppColors.primaryPurple)
                            .frame(width: 50, height: 50)
                            .shadow(color: AppColors.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
                        
                        Image(systemName: tab.icon)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(AppColors.primaryWhite)
                    } else {
                        Image(systemName: tab.icon)
                            .font(.system(size: isSelected ? 22 : 20, weight: isSelected ? .medium : .regular))
                            .foregroundColor(isSelected ? AppColors.primaryWhite : AppColors.primaryWhite.opacity(0.6))
                            .scaleEffect(isSelected ? 1.1 : 1.0)
                    }
                }
                
                if tab != .add {
                    Text(tab.title)
                        .font(.ubuntu(10, weight: isSelected ? .medium : .regular))
                        .foregroundColor(isSelected ? AppColors.primaryWhite : AppColors.primaryWhite.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.catalog))
    }
    .background(AppColors.backgroundGradient)
}
