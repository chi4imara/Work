import SwiftUI

enum TabItem: String, CaseIterable {
    case care = "Care"
    case products = "Products"
    case calendar = "Calendar"
    case history = "History"
    case settings = "Settings"
    
    var iconName: String {
        switch self {
        case .care:
            return "scissors"
        case .products:
            return "drop"
        case .calendar:
            return "calendar"
        case .history:
            return "clock"
        case .settings:
            return "gearshape"
        }
    }
    
    var title: String {
        return self.rawValue
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
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(ColorManager.cardGradient)
                
                RoundedRectangle(cornerRadius: 25)
                    .stroke(ColorManager.accent.opacity(0.2), lineWidth: 1)
            }
            .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: -8)
            .shadow(color: ColorManager.accent.opacity(0.1), radius: 10, x: 0, y: -4)
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
                    if isSelected {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                    }
                    
                    Image(systemName: tab.iconName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? ColorManager.primaryText : ColorManager.tertiaryText)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.title)
                    .font(FontManager.ubuntu(10, weight: .medium))
                    .foregroundColor(isSelected ? Color.orange : ColorManager.tertiaryText)
                    .opacity(isSelected ? 1.0 : 0.7)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.care))
    }
    .background(ColorManager.backgroundGradient)
}
