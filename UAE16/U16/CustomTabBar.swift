import SwiftUI

enum TabItem: String, CaseIterable {
    case journal = "Journal"
    case progress = "Progress"
    case profile = "Achievements"
    case stats = "Stats"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .journal:
            return "book.fill"
        case .progress:
            return "chart.line.uptrend.xyaxis"
        case .settings:
            return "gearshape.fill"
        case .profile:
            return "trophy.fill"
        case .stats:
            return "chart.bar.fill"
        }
    }
    
    var displayName: String {
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
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
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
                Image(systemName: tab.iconName)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.lightBlue : AppColors.gray)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.displayName)
                    .font(.ubuntu(size: 9, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.lightBlue : AppColors.gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? AppColors.lightBlue.opacity(0.2) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.journal))
    }
    .background(AppColors.backgroundGradient)
}
