import SwiftUI

enum TabItem: String, CaseIterable {
    case principles = "Principles"
    case calendar = "Calendar"
    case statistics = "Statistics"
    case dailyFocus = "Focus"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .principles: return "quote.bubble"
        case .calendar: return "calendar"
        case .statistics: return "chart.bar"
        case .dailyFocus: return "target"
        case .settings: return "gearshape"
        }
    }
    
    var selectedIcon: String {
        switch self {
        case .principles: return "quote.bubble.fill"
        case .calendar: return "calendar"
        case .statistics: return "chart.bar.fill"
        case .dailyFocus: return "target"
        case .settings: return "gearshape.fill"
        }
    }
}

struct CustomTabBarView: View {
    @Binding var selectedTab: TabItem
    @State private var animateSelection = false
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                TabBarItemView(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = tab
                            animateSelection = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            animateSelection = false
                        }
                    }
                )
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white, Color.appLightGray.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.appTextBlue.opacity(0.15), radius: 20, x: 0, y: -5)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.appGridBlue.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, 12)
        .padding(.bottom, 10)
    }
}

struct TabBarItemView: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.buttonGradient)
                            .frame(width: 26, height: 26)
                            .shadow(color: Color.appAccentYellow.opacity(0.4), radius: 6, x: 0, y: 2)
                    }
                    Image(systemName: isSelected ? tab.selectedIcon : tab.icon)
                        .font(.system(size: 12, weight: isSelected ? .semibold : .medium))
                        .foregroundColor(isSelected ? .white : Color.appTextBlue.opacity(0.6))
                        .scaleEffect(isPressed ? 0.9 : 1.0)
                }
                
                Text(tab.rawValue)
                    .font(.playfairDisplay(13, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? Color.appTextBlue : Color.appTextBlue.opacity(0.6))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? Color.appTextBlue.opacity(0.1) : Color.clear)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct MainTabView: View {
    @StateObject private var viewModel = PrinciplesViewModel()
    @State private var selectedTab: TabItem = .principles
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            Group {
                switch selectedTab {
                case .principles:
                    PrinciplesListView(viewModel: viewModel)
                case .calendar:
                    CalendarView(viewModel: viewModel)
                case .statistics:
                    StatisticsView(viewModel: viewModel)
                case .dailyFocus:
                    DailyPrincipleView(viewModel: viewModel)
                case .settings:
                    SettingsView(viewModel: viewModel)
                }
            }
            
            VStack(spacing: 0) {
                Spacer()
                
                CustomTabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainTabView()
}
