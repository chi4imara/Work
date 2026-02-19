import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        selectedTab = tab
                    }
                )
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.theme.cardBorder, lineWidth: 1)
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
                Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? Color.theme.accentYellow : Color.theme.textGray)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.rawValue)
                    .font(.bellGothicRegular(size: 10))
                    .foregroundColor(isSelected ? Color.theme.accentYellow : Color.theme.textGray)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color.theme.accentYellow.opacity(0.1) : Color.clear)
            )
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.home))
    }
    .background(Color.theme.backgroundGradient)
}