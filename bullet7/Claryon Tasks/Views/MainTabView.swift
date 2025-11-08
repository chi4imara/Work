import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: CleaningZoneViewModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ZonesListView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "house")
                    Text("Zones")
                }
                .tag(0)
            
            CategoriesView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "folder")
                    Text("Categories")
                }
                .tag(1)
            
            CleaningTipsView()
                .tabItem {
                    Image(systemName: "lightbulb")
                    Text("Tips")
                }
                .tag(2)
            
            ProgressView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Progress")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(.accentYellow)
        .onAppear {
            setupTabBarAppearance()
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.primaryPurple.opacity(0.9))
        
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.accentYellow)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.accentYellow)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.black)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.black)
        ]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct ProgressView: View {
    @ObservedObject var viewModel: CleaningZoneViewModel
    
    var completedZones: Int {
        viewModel.zones.filter { $0.isCompleted }.count
    }
    
    var totalZones: Int {
        viewModel.zones.count
    }
    
    var completionPercentage: Double {
        guard totalZones > 0 else { return 0 }
        return Double(completedZones) / Double(totalZones)
    }
    
    var body: some View {
        ZStack {
            Color.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    HStack {
                        Text("Progress")
                            .font(Font.titleLarge)
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                    }
                    .padding()
                    
                    ZStack {
                        Circle()
                            .stroke(Color.primaryWhite.opacity(0.2), lineWidth: 12)
                            .frame(width: 200, height: 200)
                        
                        Circle()
                            .trim(from: 0, to: completionPercentage)
                            .stroke(Color.accentYellow, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 1), value: completionPercentage)
                        
                        VStack {
                            Text("\(Int(completionPercentage * 100))%")
                                .font(.titleLarge)
                                .foregroundColor(.primaryWhite)
                            
                            Text("Complete")
                                .font(.bodyMedium)
                                .foregroundColor(.secondaryText)
                        }
                    }
                    
                    VStack(spacing: 16) {
                        HStack {
                            StatCard(title: "Total Zones", value: "\(totalZones)")
                            StatCard(title: "Completed", value: "\(completedZones)")
                        }
                        
                        HStack {
                            StatCard(title: "Remaining", value: "\(totalZones - completedZones)")
                            StatCard(title: "Categories", value: "\(viewModel.categories.count)")
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 100)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.titleMedium)
                .foregroundColor(.accentYellow)
            
            Text(title)
                .font(.bodySmall)
                .foregroundColor(.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    MainTabView()
        .environmentObject(CleaningZoneViewModel())
}
