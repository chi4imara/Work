import SwiftUI

enum TabItem: String, CaseIterable {
    case today = "Today"
    case practices = "My Practices"
    case history = "History"
    case statistics = "Statistics"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .today: return "house.fill"
        case .practices: return "heart.fill"
        case .history: return "calendar"
        case .statistics: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var index: Int {
        switch self {
        case .today: return 0
        case .practices: return 1
        case .history: return 2
        case .statistics: return 3
        case .settings: return 4
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var animationOffset: CGFloat = 0
    
    private let tabCount = TabItem.allCases.count
    
    var body: some View {
        GeometryReader { geometry in
            let tabWidth = geometry.size.width / CGFloat(tabCount)
            let capsuleWidth = tabWidth - 4
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(AppColors.cardGradient)
                    .frame(height: 80)
                    .shadow(color: AppColors.primaryNavy.opacity(0.15), radius: 20, x: 0, y: -5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(AppColors.primaryWhite.opacity(0.5), lineWidth: 1)
                    )
                
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [AppColors.primaryOrange, AppColors.lightBlue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: capsuleWidth, height: 62)
                    .offset(x: CGFloat(selectedTab.index) * tabWidth + 4)
                    .shadow(color: AppColors.primaryOrange.opacity(0.3), radius: 10, x: 0, y: 5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: selectedTab)
                
                HStack(spacing: 0) {
                    ForEach(TabItem.allCases, id: \.self) { tab in
                        TabBarItem(
                            tab: tab,
                            isSelected: selectedTab == tab,
                            action: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    selectedTab = tab
                                }
                            }
                        )
                        .frame(width: tabWidth)
                    }
                }
            }
        }
        .frame(height: 90)
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarItem: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: tab.icon)
                    .font(.system(size: isSelected ? 22 : 18, weight: .medium))
                    .foregroundColor(isSelected ? .white : AppColors.primaryNavy.opacity(0.6))
                    .scaleEffect(isPressed ? 0.9 : 1.0)
                
                Text(tab.rawValue)
                    .font(.playfairRegular(size: 10))
                    .foregroundColor(isSelected ? .white : AppColors.primaryNavy.opacity(0.6))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct FloatingTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                FloatingTabItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(AppColors.cardGradient)
                .shadow(color: AppColors.primaryNavy.opacity(0.2), radius: 15, x: 0, y: 8)
        )
        .padding(.horizontal, 30)
        .padding(.bottom, 20)
    }
}

struct FloatingTabItem: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.primaryOrange)
                            .frame(width: 40, height: 40)
                            .shadow(color: AppColors.primaryOrange.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .white : AppColors.primaryNavy.opacity(0.6))
                }
                
                Text(tab.rawValue)
                    .font(.playfairRegular(size: 10))
                    .foregroundColor(isSelected ? AppColors.primaryOrange : AppColors.primaryNavy.opacity(0.6))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CurvedTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            CurvedTabShape()
                .fill(AppColors.cardGradient)
                .frame(height: 90)
                .shadow(color: AppColors.primaryNavy.opacity(0.15), radius: 20, x: 0, y: -8)
            
            HStack(spacing: 0) {
                ForEach(TabItem.allCases, id: \.self) { tab in
                    CurvedTabItem(
                        tab: tab,
                        isSelected: selectedTab == tab,
                        action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                selectedTab = tab
                            }
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 15)
        }
    }
}

struct CurvedTabItem: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [AppColors.primaryOrange, AppColors.lightBlue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                            .shadow(color: AppColors.primaryOrange.opacity(0.4), radius: 12, x: 0, y: 6)
                            .scaleEffect(1.1)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: isSelected ? 24 : 20, weight: .medium))
                        .foregroundColor(isSelected ? .white : AppColors.primaryNavy.opacity(0.7))
                }
                
                Text(tab.rawValue)
                    .font(.playfairRegular(size: isSelected ? 12 : 10))
                    .foregroundColor(isSelected ? AppColors.primaryOrange : AppColors.primaryNavy.opacity(0.6))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CurvedTabShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let curveHeight: CGFloat = 20
        let curveWidth: CGFloat = 60
        let centerX = rect.midX
        
        path.move(to: CGPoint(x: 0, y: curveHeight))
        
        path.addLine(to: CGPoint(x: centerX - curveWidth, y: curveHeight))
        path.addQuadCurve(
            to: CGPoint(x: centerX + curveWidth, y: curveHeight),
            control: CGPoint(x: centerX, y: 0)
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: curveHeight))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()
        
        return path
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBar(selectedTab: .constant(.today))
        }
        .background(AppColors.backgroundGradient)
    }
}
