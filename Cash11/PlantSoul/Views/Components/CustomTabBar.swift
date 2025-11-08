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
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, DesignConstants.mediumPadding)
        .padding(.vertical, DesignConstants.smallPadding)
        .background(
            RoundedRectangle(cornerRadius: DesignConstants.largeCornerRadius)
                .fill(ColorScheme.cardGradient)
                .shadow(
                    color: ColorScheme.darkBlue.opacity(DesignConstants.shadowOpacity),
                    radius: DesignConstants.shadowRadius,
                    x: 0,
                    y: -2
                )
        )
        .padding(.horizontal, DesignConstants.mediumPadding)
        .padding(.bottom, DesignConstants.smallPadding)
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
                    .font(.system(size: 15, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? ColorScheme.accent : ColorScheme.mediumGray)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(FontManager.caption)
                    .foregroundColor(isSelected ? ColorScheme.accent : ColorScheme.mediumGray)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, DesignConstants.smallPadding)
            .background(
                RoundedRectangle(cornerRadius: DesignConstants.cornerRadius)
                    .fill(isSelected ? ColorScheme.accent.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: DesignConstants.animationDuration), value: isSelected)
    }
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(.calendar))
    }
    .background(ColorScheme.backgroundGradient)
}

