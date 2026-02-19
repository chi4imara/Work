import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(title: "Collection", icon: "square.grid.2x2", tag: 0),
        TabItem(title: "New Idea", icon: "plus.circle", tag: 1),
        TabItem(title: "Collections", icon: "folder", tag: 2),
        TabItem(title: "Filters", icon: "line.3.horizontal.decrease.circle", tag: 3),
        TabItem(title: "Settings", icon: "gearshape", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab.tag
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.cardBorder, lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabItem {
    let title: String
    let icon: String
    let tag: Int
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
                    .foregroundColor(isSelected ? AppColors.accentYellow : AppColors.secondaryText)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(FontManager.playfairDisplay(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.accentYellow : AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? AppColors.accentYellow.opacity(0.1) : Color.clear)
            )
        }
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}

#Preview {
    ZStack {
        BackgroundView()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(0))
        }
    }
}
