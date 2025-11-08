import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Group {
                    switch selectedTab {
                    case 0:
                        TripsView()
                    case 1:
                        CalendarView()
                    case 2:
                        WishlistView()
                    case 3:
                        StatisticsView()
                    case 4:
                        SettingsView()
                    default:
                        TripsView()
                    }
                }
                
                VStack {
                    Spacer()
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    MainTabView()
}

