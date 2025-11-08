import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @State private var tabOffset: CGFloat = 0
    
    private let tabs = [
        TabItem(icon: "book", selectedIcon: "book.fill", title: "Ideas", color: .blue),
        TabItem(icon: "star", selectedIcon: "star.fill", title: "Favorites", color: .yellow),
        TabItem(icon: "tag", selectedIcon: "tag.fill", title: "Tags", color: .green),
        TabItem(icon: "questionmark.circle", selectedIcon: "questionmark.circle.fill", title: "Wheel", color: .purple),
        TabItem(icon: "gearshape", selectedIcon: "gearshape.fill", title: "Settings", color: .gray)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabButton(
                    tab: tabs[index],
                    isSelected: selectedTab == index,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = index
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(LinearGradient(
                    colors: [
                        Color.white.opacity(0.4),
                        Color.white.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.elementBorder, lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(tab.color.opacity(0.2))
                            .frame(width: 50, height: 50)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 20, weight: isSelected ? .semibold : .medium))
                        .foregroundColor(isSelected ? tab.color : AppColors.primaryText.opacity(0.6))
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }
}

struct TabItem {
    let icon: String
    let selectedIcon: String
    let title: String
    let color: Color
}

struct FloatingTabBar: View {
    @Binding var selectedTab: Int
    @State private var dragOffset: CGSize = .zero
    
    private let tabs = [
        TabItem(icon: "book", selectedIcon: "book.fill", title: "Ideas", color: .blue),
        TabItem(icon: "star", selectedIcon: "star.fill", title: "Favorites", color: .yellow),
        TabItem(icon: "tag", selectedIcon: "tag.fill", title: "Tags", color: .green),
        TabItem(icon: "questionmark.circle", selectedIcon: "questionmark.circle.fill", title: "Wheel", color: .purple),
        TabItem(icon: "gearshape", selectedIcon: "gearshape.fill", title: "Settings", color: .gray)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                FloatingTabButton(
                    tab: tabs[index],
                    isSelected: selectedTab == index,
                    action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedTab = index
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(AppColors.elementBorder.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .offset(dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { _ in
                    withAnimation(.spring()) {
                        dragOffset = .zero
                    }
                }
        )
    }
}

struct FloatingTabButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var bounceOffset: CGFloat = 0
    
    var body: some View {
        Button(action: {
            action()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                bounceOffset = -10
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    bounceOffset = 0
                }
            }
        }) {
            VStack(spacing: 8) {
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(tab.color.opacity(0.15))
                            .frame(width: 60, height: 50)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 22, weight: isSelected ? .bold : .medium))
                        .foregroundColor(isSelected ? tab.color : AppColors.primaryText.opacity(0.7))
                        .scaleEffect(isSelected ? 1.2 : 1.0)
                        .offset(y: bounceOffset)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: bounceOffset)
                }
                
                Text(tab.title)
                    .font(.nunito(.semiBold, size: 10))
                    .foregroundColor(isSelected ? tab.color : AppColors.primaryText.opacity(0.7))
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(
            minimumDuration: 0,
            maximumDistance: .infinity,
            pressing: { pressing in
                isPressed = pressing
            },
            perform: {}
        )
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            
            CustomTabBar(selectedTab: .constant(0))
                .background(AppColors.backgroundGradient)
            
            Spacer()
            
            FloatingTabBar(selectedTab: .constant(1))
                .background(AppColors.backgroundGradient)
        }
    }
}
