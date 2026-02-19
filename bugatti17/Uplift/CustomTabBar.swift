import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var tabOffset: CGFloat = 0
    @State private var animateSelection = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            DesignConstants.Colors.white.opacity(0.15),
                            DesignConstants.Colors.white.opacity(0.05)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(DesignConstants.Colors.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            HStack(spacing: 0) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    TabBarItem(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        animateSelection: animateSelection
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab
                            animateSelection = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            animateSelection = false
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 70)
        .padding(.horizontal, DesignConstants.Spacing.lg)
        .padding(.bottom, 10)
    }
}

struct TabBarItem: View {
    let tab: TabItem
    let isSelected: Bool
    let animateSelection: Bool
    let onTap: () -> Void
    
    @State private var bounceScale: CGFloat = 1.0
    @State private var glowOpacity: Double = 0.0
    
    var body: some View {
        Button(action: {
            onTap()
            
            withAnimation(.easeInOut(duration: 0.1)) {
                bounceScale = 0.9
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.2)) {
                    bounceScale = 1.1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        bounceScale = 1.0
                    }
                }
            }
            
            if isSelected {
                withAnimation(.easeInOut(duration: 0.3)) {
                    glowOpacity = 1.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        glowOpacity = 0.0
                    }
                }
            }
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        DesignConstants.Colors.primaryYellow.opacity(glowOpacity * 0.6),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 25
                                )
                            )
                            .frame(width: 50, height: 50)
                    }
                    
                    if isSelected {
                        Circle()
                            .fill(DesignConstants.Colors.primaryYellow)
                            .frame(width: 40, height: 40)
                            .scaleEffect(animateSelection ? 1.2 : 1.0)
                            .animation(.easeOut(duration: 0.2), value: animateSelection)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(
                            isSelected ? DesignConstants.Colors.primaryBlue : DesignConstants.Colors.white.opacity(0.6)
                        )
                        .scaleEffect(bounceScale)
                        .animation(.easeInOut(duration: 0.2), value: bounceScale)
                }
                
                Text(tab.rawValue)
                    .font(.ubuntu(10, weight: isSelected ? .medium : .regular))
                    .foregroundColor(
                        isSelected ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.6)
                    )
                    .scaleEffect(isSelected ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FloatingTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                FloatingTabItem(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            Capsule()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            DesignConstants.Colors.primaryBlue.opacity(0.8),
                            DesignConstants.Colors.darkBlue.opacity(0.9)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 8)
        )
        .offset(dragOffset)
        .scaleEffect(isDragging ? 1.05 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isDragging)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                    isDragging = true
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        dragOffset = .zero
                        isDragging = false
                    }
                }
        )
    }
}

struct FloatingTabItem: View {
    let tab: TabItem
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        Button(action: {
            onTap()
            
            withAnimation(.easeInOut(duration: 0.15)) {
                pulseScale = 1.3
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeOut(duration: 0.25)) {
                    pulseScale = 1.0
                }
            }
        }) {
            ZStack {
                if isSelected {
                    Circle()
                        .fill(DesignConstants.Colors.primaryYellow)
                        .frame(width: 50, height: 50)
                        .scaleEffect(pulseScale)
                }
                
                Image(systemName: tab.icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(
                        isSelected ? DesignConstants.Colors.primaryBlue : DesignConstants.Colors.white
                    )
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MorphingTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var morphOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            DesignConstants.Colors.white.opacity(0.2),
                            DesignConstants.Colors.white.opacity(0.1)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 80)
            
            GeometryReader { geometry in
                let tabWidth = geometry.size.width / CGFloat(TabItem.allCases.count)
                let selectedIndex = TabItem.allCases.firstIndex(of: selectedTab) ?? 0
                let targetOffset = tabWidth * CGFloat(selectedIndex) + tabWidth / 2
                
                MorphingShape()
                    .fill(DesignConstants.Colors.primaryYellow)
                    .frame(width: 60, height: 60)
                    .position(x: targetOffset, y: geometry.size.height / 2)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: selectedTab)
            }
            
            HStack(spacing: 0) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    MorphingTabItem(
                        tab: tab,
                        isSelected: selectedTab == tab
                    ) {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            selectedTab = tab
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: 80)
        .padding(.horizontal, DesignConstants.Spacing.lg)
        .padding(.bottom, 34)
    }
}

struct MorphingShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.addEllipse(in: CGRect(
            x: center.x - radius * 0.8,
            y: center.y - radius * 1.2,
            width: radius * 1.6,
            height: radius * 2.4
        ))
        
        return path
    }
}

struct MorphingTabItem: View {
    let tab: TabItem
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(
                        isSelected ? DesignConstants.Colors.primaryBlue : DesignConstants.Colors.white.opacity(0.7)
                    )
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
                
                if !isSelected {
                    Text(tab.rawValue)
                        .font(.ubuntu(10))
                        .foregroundColor(DesignConstants.Colors.white.opacity(0.6))
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        AnimatedBackgroundView()
        
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.today))
        }
    }
    .ignoresSafeArea()
}
