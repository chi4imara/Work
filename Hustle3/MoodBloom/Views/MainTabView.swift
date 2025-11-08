import SwiftUI

struct MainTabView: View {
    @StateObject private var moodViewModel = MoodViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    @StateObject private var settings = AppSettings()
    
    @State private var selectedTab: TabItem = .calendar
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .calendar:
                    CalendarView(moodViewModel: moodViewModel, settings: settings)
                case .analytics:
                    AnalyticsView(moodViewModel: moodViewModel)
                case .notes:
                    NotesView(notesViewModel: notesViewModel)
                case .settings:
                    AppSettingsView()
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct AppContainer: View {
    @StateObject private var settings = AppSettings()
    @State private var showingOnboarding = true
    
    var body: some View {
        ZStack {
            if showingOnboarding {
                OnboardingView {
                    settings.hasCompletedOnboarding = true
                    showingOnboarding = false
                }
            } else {
                MainTabView()
                    .environmentObject(settings)
            }
        }
        .onAppear {
            FontManager.shared.registerFonts()
        }
    }
}

#Preview {
    AppContainer()
}
