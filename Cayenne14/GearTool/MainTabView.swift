import SwiftUI

struct MainTabView: View {
    @StateObject private var toolsViewModel = ToolsViewModel()
    @State private var isReady = false
    
    var body: some View {
        Group {
            if isReady {
                TabView {
                    AddToolView(viewModel: toolsViewModel)
                        .tabItem {
                            Image(systemName: "plus.circle")
                            Text("Add")
                        }
                    
                    CatalogView(viewModel: toolsViewModel)
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("Catalog")
                        }
                    
                    UsageView(viewModel: toolsViewModel)
                        .tabItem {
                            Image(systemName: "chart.bar")
                            Text("Usage")
                        }
                    
                    AnalyticsView(viewModel: toolsViewModel)
                        .tabItem {
                            Image(systemName: "chart.pie")
                            Text("Analytics")
                        }
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                }
                .accentColor(AppColors.lightBlue)
            } else {
                Color.clear
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isReady = true
            }
        }
    }
}

#Preview {
    MainTabView()
}
