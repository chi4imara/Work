import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var selectedTab: TabItem = .today
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .today:
                    TodayView()
                case .goals:
                    GoalsView()
                case .history:
                    HistoryView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                            selectedTab = tab
                        }
                    }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(AppGradients.tabBar)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: AppColors.shadow, radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10) 
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.secondary)
                            .frame(width: 40, height: 40)
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: isSelected ? .bold : .medium))
                        .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                }
                
                Text(tab.rawValue)
                    .font(.ubuntu(10, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? AppColors.textPrimary : AppColors.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppViewModel())
}
