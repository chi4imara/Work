import SwiftUI

struct MainTabView: View {
    @StateObject private var shoesViewModel = ShoesViewModel()
    @StateObject private var notesViewModel = NotesViewModel()
    @State private var selectedTab = 0
    @State private var isReady = false
    
    var body: some View {
        Group {
            if isReady {
                TabView(selection: $selectedTab) {
            MyShoesView()
                .environmentObject(shoesViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "shoe.2.fill" : "shoe.2")
                    Text("Shoes")
                }
                .tag(0)
            
            CategoriesView()
                .environmentObject(shoesViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "square.grid.2x2.fill" : "square.grid.2x2")
                    Text("Categories")
                }
                .tag(1)
            
            NotesView()
                .environmentObject(notesViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "note.text" : "note.text")
                    Text("Notes")
                }
                .tag(2)
            
            StatisticsView()
                .environmentObject(shoesViewModel)
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "chart.bar.fill" : "chart.bar")
                    Text("Stats")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(4)
                }
                .accentColor(Color.orange)
                .preferredColorScheme(.dark)
            } else {
                ColorTheme.primaryBackground
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isReady = true
            }
        }
    }
}

#Preview {
    MainTabView()
}
