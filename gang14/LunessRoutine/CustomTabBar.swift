import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(title: "Home", icon: "house.fill", tag: 0),
        TabItem(title: "Archive", icon: "text.book.closed.fill", tag: 1),
        TabItem(title: "Statistics", icon: "chart.bar.fill", tag: 2),
        TabItem(title: "Settings", icon: "gearshape.fill", tag: 3)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab.tag
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.15), radius: 12, x: 0, y: -4)
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
                Image(systemName: tab.icon)
                    .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.primaryYellow : ColorTheme.textLight)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                
                Text(tab.title)
                    .font(.ubuntu(10, weight: isSelected ? .medium : .regular))
                    .foregroundColor(isSelected ? ColorTheme.primaryBlue : ColorTheme.textLight)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? ColorTheme.primaryYellow.opacity(0.1) : Color.clear)
                    .scaleEffect(isSelected ? 1.0 : 0.8)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct TabItem {
    let title: String
    let icon: String
    let tag: Int
}

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showingSplash = true
    @State private var showingOnboarding = true
    
    var body: some View {
        ZStack {
            if !UserDefaults.standard.bool(forKey: "hasSeenOnboarding") && showingOnboarding {
                OnboardingView {
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    showingOnboarding = false
                }
            }
            else {
                VStack(spacing: 0) {
                    Group {
                        switch selectedTab {
                        case 0:
                            MainView(selectedTab: $selectedTab)
                        case 1:
                            ArchiveNavigationView()
                        case 2:
                            StatisticsView()
                        case 3:
                            SettingsView()
                        default:
                            MainView(selectedTab: $selectedTab)
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
        }
    }
}

struct PracticeNavigationView: View {
    @State private var showingPractice = false
    
    @Binding var selectedTab: Int
    
    var body: some View {
        BackgroundContainer {
            VStack(spacing: 40) {
                Spacer()
                
                Image(systemName: "leaf.fill")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(ColorTheme.primaryBlue)
                
                VStack(spacing: 16) {
                    Text("Practice \"Let Go of the Day\"")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("Start your evening ritual to gently end the day.")
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary)
                        .multilineTextAlignment(.center)
                }
                
                Button(action: {
                    showingPractice = true
                }) {
                    Text("Start Practice")
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(ColorTheme.backgroundWhite)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [ColorTheme.primaryBlue, ColorTheme.accentPurple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingPractice) {
            PracticeView(onComplete: {}, action: {
                withAnimation {
                    selectedTab = 2
                }
            })
        }
    }
}

struct ArchiveNavigationView: View {
    @StateObject private var mainViewModel = MainViewModel()
    
    var body: some View {
        ArchiveView(viewModel: mainViewModel)
    }
}

#Preview {
    MainTabView()
}
