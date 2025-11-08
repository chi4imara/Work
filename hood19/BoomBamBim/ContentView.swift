import SwiftUI

struct MainAppView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    @State private var showSplash = false
    @State private var showOnboarding = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    @State private var selectedSidebarItem: SideBarItem = .calendar
    @State private var isShowingSidebar = false
    
    var body: some View {
        ZStack {
        if showOnboarding {
                OnboardingView(showOnboarding: $showOnboarding)
                    .transition(.slide)
                    .onDisappear {
                        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                    }
            } else {
                mainContent
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
        .animation(.easeInOut(duration: 0.5), value: showOnboarding)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                showSplash = false
            }
        }
    }
    
    private var mainContent: some View {
        ZStack {
            StaticBackground()
            
            Group {
                switch selectedSidebarItem {
                case .calendar:
                    CalendarView(viewModel: taskViewModel)
                case .tasks:
                    TaskListView(viewModel: taskViewModel)
                case .progress:
                    ProjectProgressView(viewModel: taskViewModel)
                case .settings:
                    SettingsView()
                }
            }
            .overlay {
                VStack {
                    HStack {
                        Button(action: {
                            HapticFeedback.light()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isShowingSidebar.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(AppColors.primaryBlue)
                                .frame(width: 44, height: 44)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.9))
                                        .shadow(color: AppColors.primaryBlue.opacity(0.2), radius: 4, x: 0, y: 2)
                                )
                        }
                        .padding(.leading, 20)
                        .padding(.top, 15)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            
            if isShowingSidebar {
                CustomSideBar(
                    selectedItem: $selectedSidebarItem,
                    isShowingSidebar: $isShowingSidebar
                )
                .transition(.move(edge: .leading))
                .zIndex(1)
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        MainAppView()
    }
}

#Preview {
    MainAppView()
}
