import SwiftUI

struct ContentView: View {
    @EnvironmentObject var inventoryViewModel: InventoryViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            GridBackgroundView()
            
            Group {
                switch selectedTab {
                case 0:
                    InventoryView()
                case 1:
                    CalendarView()
                case 2:
                    SearchView()
                case 3:
                    StatisticsView()
                case 4:
                    SettingsView()
                default:
                    InventoryView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 0) {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(InventoryViewModel())
}
