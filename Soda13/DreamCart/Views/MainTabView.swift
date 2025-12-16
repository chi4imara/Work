import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: BeautyDiaryViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    DiaryView(viewModel: viewModel)
                case 1:
                    NotesView(viewModel: viewModel)
                case 2:
                    FavoritesView(viewModel: viewModel)
                case 3:
                    CalendarView(viewModel: viewModel)
                case 4:
                    SettingsView()
                default:
                    DiaryView(viewModel: viewModel)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(BeautyDiaryViewModel())
}
