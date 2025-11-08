import SwiftUI

enum TabItem: String, CaseIterable {
    case list = "List"
    case collections = "Collections"
    case progress = "Progress"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .list:
            return "list.bullet"
        case .collections:
            return "folder"
        case .progress:
            return "chart.pie"
        case .settings:
            return "gearshape"
        }
    }
    
    var selectedIconName: String {
        switch self {
        case .list:
            return "list.bullet.circle.fill"
        case .collections:
            return "folder.fill"
        case .progress:
            return "chart.pie.fill"
        case .settings:
            return "gearshape.fill"
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
        .frame(height: 70)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.95),
                            Color.white.opacity(0.9)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: AppColors.cardShadow, radius: 15, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.blueGradient)
                            .frame(width: 40, height: 40)
                            .shadow(color: AppColors.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 2)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIconName : tab.iconName)
                        .font(.system(size: 20, weight: isSelected ? .semibold : .medium))
                        .foregroundColor(isSelected ? .white : AppColors.secondaryText)
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                
                Text(tab.rawValue)
                    .font(AppFonts.caption)
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.secondaryText)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.list))
    }
    .background(AppColors.backgroundGradient)
}
