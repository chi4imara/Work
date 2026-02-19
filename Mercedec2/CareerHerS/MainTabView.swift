import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    CoursesView()
                case 1:
                    SkillsView()
                case 2:
                    ProgressScreen()
                case 3:
                    ProfileView()
                default:
                    CoursesView()
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

#Preview {
    MainTabView()
}
