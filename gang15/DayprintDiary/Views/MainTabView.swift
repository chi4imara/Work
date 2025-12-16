import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var entryToEdit: DiaryEntry?
    @State private var showingTips = false
    @State private var showingRandom = false
    @State private var showingArchive = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(
                onNavigateToTips: { showingTips = true },
                onNavigateToRandom: { showingRandom = true },
                onNavigateToArchive: { showingArchive = true },
                onNavigateToEdit: { entry in
                    entryToEdit = entry
                },
                selectedTab: $selectedTab
            )
            .tabItem {
                Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                Text("Home")
            }
            .tag(0)
            
            ArchiveView(
                onNavigateToEdit: { entry in
                    entryToEdit = entry
                },
                onDismiss: { selectedTab = 0 }
            )
            .tabItem {
                Image(systemName: selectedTab == 1 ? "book.fill" : "book")
                Text("Archive")
            }
            .tag(1)
            
            RandomMemoryView(
                onDismiss: { selectedTab = 0 }
            )
            .tabItem {
                Image(systemName: selectedTab == 2 ? "sparkles" : "sparkles")
                Text("Random")
            }
            .tag(2)
            
            WritingTipsView(
                onDismiss: { selectedTab = 0 }
            )
            .tabItem {
                Image(systemName: selectedTab == 3 ? "lightbulb.fill" : "lightbulb")
                Text("Tips")
            }
            .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "gearshape.fill" : "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(AppTheme.Colors.primaryPurple)
        .sheet(item: $entryToEdit) { entry in
            EditEntryView(
                entry: entry,
                onSave: {
                    entryToEdit = nil
                },
                onCancel: {
                    entryToEdit = nil
                }
            )
        }
        .sheet(isPresented: $showingTips) {
            WritingTipsView(onDismiss: { showingTips = false })
        }
        .sheet(isPresented: $showingRandom) {
            RandomMemoryView(onDismiss: { showingRandom = false })
        }
        .sheet(isPresented: $showingArchive) {
            ArchiveView(
                onNavigateToEdit: { entry in
                    showingArchive = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        entryToEdit = entry
                    }
                },
                onDismiss: { showingArchive = false }
            )
        }
    }
}

#Preview {
    MainTabView()
}
