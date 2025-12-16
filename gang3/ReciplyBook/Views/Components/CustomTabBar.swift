import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(icon: "book.fill", title: "Recipes", tag: 0),
        TabItem(icon: "plus.circle.fill", title: "Add", tag: 1),
        TabItem(icon: "folder.fill", title: "Categories", tag: 2),
        TabItem(icon: "lightbulb.fill", title: "Tips", tag: 3),
        TabItem(icon: "gearshape.fill", title: "Settings", tag: 4)
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
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppColors.backgroundWhite)
                .shadow(color: AppColors.primaryBlue.opacity(0.15), radius: 15, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let tag: Int
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.primaryBlue)
                            .frame(width: 50, height: 50)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: isSelected ? 22 : 20, weight: .medium))
                        .foregroundColor(isSelected ? .white : AppColors.primaryBlue.opacity(0.6))
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                .frame(height: 50)
                
                Text(tab.title)
                    .font(.ubuntu(10, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.darkGray.opacity(0.6))
                    .lineLimit(1)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct FloatingTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(icon: "house.fill", title: "Home", tag: 0),
        TabItem(icon: "plus", title: "Add", tag: 1),
        TabItem(icon: "heart.fill", title: "Favorites", tag: 2),
        TabItem(icon: "person.fill", title: "Profile", tag: 3),
        TabItem(icon: "ellipsis", title: "More", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(tabs, id: \.tag) { tab in
                FloatingTabButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab.tag
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .background(
            Capsule()
                .fill(AppColors.backgroundWhite)
                .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal, 30)
        .padding(.bottom, 20)
    }
}

struct FloatingTabButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.system(size: isSelected ? 24 : 20, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.primaryYellow : AppColors.primaryBlue.opacity(0.5))
                    .frame(width: 30, height: 30)
                    .background(
                        Circle()
                            .fill(isSelected ? AppColors.primaryBlue : Color.clear)
                            .scaleEffect(isSelected ? 1.2 : 1.0)
                    )
                
                if isSelected {
                    Text(tab.title)
                        .font(.ubuntu(8, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct MorphingTabBar: View {
    @Binding var selectedTab: Int
    @Namespace private var tabSelection
    
    private let tabs = [
        TabItem(icon: "book.closed.fill", title: "Recipes", tag: 0),
        TabItem(icon: "plus.app.fill", title: "Add", tag: 1),
        TabItem(icon: "square.grid.2x2.fill", title: "Categories", tag: 2),
        TabItem(icon: "star.fill", title: "Tips", tag: 3),
        TabItem(icon: "slider.horizontal.3", title: "Settings", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                MorphingTabButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag,
                    namespace: tabSelection,
                    action: {
                        selectedTab = tab.tag
                    }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(AppColors.backgroundWhite)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(AppColors.primaryBlue.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 15)
    }
}

struct MorphingTabButton: View {
    let tab: TabItem
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: tab.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? .white : AppColors.primaryBlue)
                
                if isSelected {
                    Text(tab.title)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(.white)
                        .transition(.opacity.combined(with: .scale))
                }
            }
            .padding(.horizontal, isSelected ? 16 : 12)
            .padding(.vertical, 10)
            .background(
                Group {
                    if isSelected {
                        Capsule()
                            .fill(AppColors.primaryBlue)
                            .matchedGeometryEffect(id: "selectedTab", in: namespace)
                    } else {
                        Capsule()
                            .fill(Color.clear)
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
    }
}

#Preview {
    VStack(spacing: 50) {
        CustomTabBar(selectedTab: .constant(0))
        FloatingTabBar(selectedTab: .constant(1))
        MorphingTabBar(selectedTab: .constant(2))
    }
    .background(AppColors.backgroundGradient)
}
