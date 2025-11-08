import SwiftUI
import UIKit

struct MainTabView: View {
    @StateObject private var ideaStore = IdeaStore()
    @StateObject private var appState = AppState()
    @State private var selectedTab = 0
    @AppStorage("useFloatingTabBar") private var useFloatingTabBar = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                ZStack {
                switch selectedTab {
                case 0:
                    IdeasListView()
                        .environmentObject(ideaStore)
                        .environmentObject(appState)
                case 1:
                    FavoritesView()
                        .environmentObject(ideaStore)
                case 2:
                    TagsView()
                        .environmentObject(ideaStore)
                case 3:
                    WheelOfFortuneView()
                        .environmentObject(ideaStore)
                case 4:
                    SettingsView()
                default:
                    IdeasListView()
                        .environmentObject(ideaStore)
                        .environmentObject(appState)
                }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .sheet(isPresented: $appState.showingAddEditView) {
            AddEditIdeaView(ideaToEdit: appState.selectedIdeaForEdit)
                .environmentObject(ideaStore)
                .onDisappear {
                    appState.dismissAddEditView()
                }
        }
    }
    }

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
