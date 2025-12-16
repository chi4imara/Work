import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(icon: "calendar", title: "Calendar", index: 0),
        TabItem(icon: "plus.circle.fill", title: "Add", index: 1),
        TabItem(icon: "clock", title: "History", index: 2),
        TabItem(icon: "chart.bar", title: "Stats", index: 3),
        TabItem(icon: "gearshape", title: "Settings", index: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.index,
                    action: { selectedTab = tab.index }
                )
            }
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: AppColors.shadowColor, radius: 15, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                action()
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.accent)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isSelected ? 1.0 : 0.8)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: tab.index == 1 ? 24 : 20, weight: .medium))
                        .foregroundColor(isSelected ? .white : AppColors.primaryText.opacity(0.6))
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .offset(y: animationOffset)
                }
                
                Text(tab.title)
                    .font(FontManager.ubuntu(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accent : AppColors.primaryText.opacity(0.6))
                    .opacity(isSelected ? 1.0 : 0.7)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
        .onChange(of: isSelected) { selected in
            if selected {
                withAnimation(.easeOut(duration: 0.1)) {
                    animationOffset = -3
                }
                withAnimation(.easeOut(duration: 0.2).delay(0.1)) {
                    animationOffset = 0
                }
            }
        }
    }
}

struct TabItem {
    let icon: String
    let title: String
    let index: Int
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0))
    }
    .background(GradientBackground())
}
