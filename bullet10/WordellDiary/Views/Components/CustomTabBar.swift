import SwiftUI

enum TabItem: String, CaseIterable {
    case days = "Days"
    case newEntry = "New"
    case themes = "Themes"
    case statistics = "Stats"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .days: return "calendar"
        case .newEntry: return "plus.circle.fill"
        case .themes: return "lightbulb"
        case .statistics: return "chart.bar"
        case .settings: return "gearshape"
        }
    }
    
    var index: Int {
        return TabItem.allCases.firstIndex(of: self) ?? 0
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var tabOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            selectedTab = tab
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.darkGray.opacity(0.1), radius: 10, x: 0, y: -5)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .onChange(of: selectedTab) { newValue in
            updateTabOffset(for: newValue)
        }
        .onAppear {
            updateTabOffset(for: selectedTab)
        }
    }
    
    private func updateTabOffset(for tab: TabItem) {
        let tabWidth: CGFloat = (UIScreen.main.bounds.width - 80) / 5
        let index = CGFloat(tab.index)
        tabOffset = (index * tabWidth) - (tabWidth * 2)
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
                Image(systemName: tab.icon)
                    .font(.system(size: isSelected ? 22 : 20, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.darkGray.opacity(0.6))
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                
                Text(tab.rawValue)
                    .font(AppFonts.small)
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.darkGray.opacity(0.6))
                    .fontWeight(isSelected ? .medium : .regular)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
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
        CustomTabBar(selectedTab: .constant(.days))
    }
    .background(AppColors.mainBackgroundGradient)
}
