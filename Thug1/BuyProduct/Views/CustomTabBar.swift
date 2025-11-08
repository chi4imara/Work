import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var animateIcons = false
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.primaryBlue.opacity(0.9),
                        Color.lightBlue.opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.primaryYellow.opacity(0.1))
                        .frame(width: CGFloat.random(in: 20...40))
                        .position(
                            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                            y: CGFloat.random(in: 0...80)
                        )
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 3...5))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.8),
                            value: animateIcons
                        )
                }
            }
        )
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: -5)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animateIcons = true
            }
        }
    }
}

enum TabItem: String, CaseIterable {
    case purchases = "Purchases"
    case favorites = "Favorites"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .purchases:
            return "house.fill"
        case .favorites:
            return "star.fill"
        case .statistics:
            return "chart.bar.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .purchases:
            return .blue
        case .favorites:
            return .yellow
        case .statistics:
            return .purple
        case .settings:
            return .green
        }
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var animateIcon = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(
                            isSelected ? 
                            LinearGradient(
                                gradient: Gradient(colors: [tab.color, tab.color.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: isSelected ? 50 : 40, height: isSelected ? 50 : 40)
                        .scaleEffect(animateIcon && isSelected ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateIcon)
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: isSelected ? 20 : 18, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .primaryWhite.opacity(0.7))
                        .scaleEffect(isPressed ? 0.8 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                }
                
                Text(tab.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundColor(isSelected ? .primaryWhite : .primaryWhite.opacity(0.7))
                    .scaleEffect(isSelected ? 1.0 : 0.9)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            }
            .frame(maxWidth: .infinity)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            if isSelected {
                withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
                    animateIcon = true
                }
            }
        }
        .onChange(of: isSelected) { newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
                    animateIcon = true
                }
            } else {
                animateIcon = false
            }
        }
    }
}

#Preview {
    ZStack {
        Color.backgroundPrimary
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            
            CustomTabBar(selectedTab: .constant(.purchases))
        }
    }
}
