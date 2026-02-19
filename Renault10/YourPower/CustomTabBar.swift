import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItem(title: "Today", icon: "house.fill", selectedIcon: "house.fill"),
        TabItem(title: "Habits", icon: "heart", selectedIcon: "heart.fill"),
        TabItem(title: "Stats", icon: "chart.bar", selectedIcon: "chart.bar.fill"),
        TabItem(title: "History", icon: "calendar", selectedIcon: "calendar"),
        TabItem(title: "Settings", icon: "gearshape", selectedIcon: "gearshape.fill")
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                TabBarButton(
                    tab: tabs[index],
                    isSelected: selectedTab == index
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = index
                    }
                    
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        ColorManager.backgroundWhite.opacity(0.95),
                        ColorManager.lightBlue.opacity(0.8)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
        )
        .cornerRadius(12)
        .shadow(
            color: .black.opacity(0.1),
            radius: 10,
            x: 0,
            y: -5
        )
        .padding(.horizontal, 20)
    }
}

struct TabItem {
    let title: String
    let icon: String
    let selectedIcon: String
}

struct TabBarButton: View {
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
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        ColorManager.primaryBlue,
                                        ColorManager.primaryBlue.opacity(0.8)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 36, height: 36)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                            .transition(.scale.combined(with: .opacity))
                    }
                    
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(
                            isSelected ? .white : ColorManager.darkGray.opacity(0.6)
                        )
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                .frame(width: 44, height: 36)
                
                Text(tab.title)
                    .font(FontManager.medium(size: 11))
                    .foregroundColor(
                        isSelected ? ColorManager.primaryBlue : ColorManager.darkGray.opacity(0.6)
                    )
                    .scaleEffect(isPressed ? 0.95 : 1.0)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct CustomTabBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let cornerRadius: CGFloat = 24
        let topCurveHeight: CGFloat = 8
        
        path.move(to: CGPoint(x: cornerRadius, y: topCurveHeight))
        
        path.addQuadCurve(
            to: CGPoint(x: rect.width - cornerRadius, y: topCurveHeight),
            control: CGPoint(x: rect.width / 2, y: -topCurveHeight)
        )
        
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: topCurveHeight + cornerRadius),
            control: CGPoint(x: rect.width, y: topCurveHeight)
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        
        path.addQuadCurve(
            to: CGPoint(x: rect.width - cornerRadius, y: rect.height),
            control: CGPoint(x: rect.width, y: rect.height)
        )
        
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height - cornerRadius),
            control: CGPoint(x: 0, y: rect.height)
        )
        
        path.addLine(to: CGPoint(x: 0, y: topCurveHeight + cornerRadius))
        
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: topCurveHeight),
            control: CGPoint(x: 0, y: topCurveHeight)
        )
        
        return path
    }
}

struct MainTabView: View {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some View {
        ZStack {
            Group {
                switch appViewModel.selectedTab {
                case 0:
                    TodayView()
                case 1:
                    HabitsView()
                case 2:
                    StatisticsView()
                case 3:
                    HistoryView()
                case 4:
                    SettingsView()
                default:
                    TodayView()
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBar(selectedTab: $appViewModel.selectedTab)
            }
        }
    }
}

#Preview {
    MainTabView()
}
