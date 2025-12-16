import SwiftUI

struct MainTabView: View {
    @StateObject private var appViewModel = AppViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    DailyQuestionView(selectedTab: $selectedTab)
                case 1:
                    RandomQuestionView()
                case 2:
                    HistoryView(selectedTab: $selectedTab)
                case 3:
                    NotesView()
                case 4:
                    SettingsView()
                default:
                    DailyQuestionView(selectedTab: $selectedTab)
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

#Preview {
    MainTabView()
}
