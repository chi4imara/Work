import SwiftUI

enum TabItem: CaseIterable {
    case discoveries
    case categories
    case notes
    case statistics
    case settings
    
    var title: String {
        switch self {
        case .discoveries:
            return "Discoveries"
        case .categories:
            return "Categories"
        case .notes:
            return "Notes"
        case .statistics:
            return "Statistics"
        case .settings:
            return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .discoveries:
            return "sparkles"
        case .categories:
            return "folder.fill"
        case .notes:
            return "note.text"
        case .statistics:
            return "chart.bar.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    private let colorManager = ColorManager.shared
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    selectedTab = tab
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(colorManager.cardGradient)
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
    
    private let colorManager = ColorManager.shared
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(colorManager.accentGradient)
                            .frame(width: 40, height: 40)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? colorManager.primaryWhite : colorManager.accentText)
                }
                
                Text(tab.title)
                    .font(.custom("PlayfairDisplay-Medium", size: 10))
                    .foregroundColor(isSelected ? colorManager.accentText : colorManager.secondaryText.opacity(0.6))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.discoveries))
    }
    .background(ColorManager.shared.backgroundGradient)
}
