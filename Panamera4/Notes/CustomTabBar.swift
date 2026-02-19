import SwiftUI

enum TabItem: CaseIterable {
    case journal
    case categories
    case analytics
    case settings
    
    var title: String {
        switch self {
        case .journal:
            return "Journal"
        case .categories:
            return "Categories"
        case .analytics:
            return "Analytics"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .journal:
            return "book.fill"
        case .categories:
            return "folder.fill"
        case .analytics:
            return "chart.bar.fill"
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
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
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
                    .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accentYellow : AppColors.darkGray.opacity(0.6))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(.bellGothic(10, weight: .regular))
                    .foregroundColor(isSelected ? AppColors.accentYellow : AppColors.darkGray.opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? AppColors.accentYellow.opacity(0.1) : Color.clear)
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
    .primaryBackground()
}
