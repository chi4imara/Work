import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(title: "Home", icon: "house", tag: 0),
        TabItem(title: "Random", icon: "shuffle", tag: 1),
        TabItem(title: "History", icon: "clock", tag: 2),
        TabItem(title: "Notes", icon: "note.text", tag: 3),
        TabItem(title: "Settings", icon: "gear", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab.tag
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.95))
                .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 10, x: 0, y: 5)
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
                            .fill(AppGradients.buttonGradient)
                            .frame(width: 40, height: 40)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .white : AppColors.textSecondary)
                }
                
                Text(tab.title)
                    .font(.playfairDisplay(10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct TabItem {
    let title: String
    let icon: String
    let tag: Int
}

#Preview {
    VStack {
        Spacer()
        CustomTabBar(selectedTab: .constant(0))
    }
    .background(AnimatedBackground())
}
