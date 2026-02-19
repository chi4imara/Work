import SwiftUI

struct MainTabView: View {
    @StateObject private var tripViewModel = TripViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NewTripView(viewModel: tripViewModel)
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("New")
                }
                .tag(0)
            
            TripJournalView(viewModel: tripViewModel)
                .tabItem {
                    Image(systemName: "book")
                    Text("Entries")
                }
                .tag(1)
            
            CategoriesView(viewModel: tripViewModel)
                .tabItem {
                    Image(systemName: "folder")
                    Text("Categories")
                }
                .tag(2)
            
            StatisticsView(viewModel: tripViewModel)
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Stats")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(4)
        }
        .accentColor(.lightBlue)
    }
}

struct StatisticsView: View {
    @ObservedObject var viewModel: TripViewModel
    
    var body: some View {
        ZStack {
            RadialGradientBackground()
            
            VStack(spacing: 0) {
                Text("Statistics")
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(.pureWhite)
                    .padding(.vertical, 30)
                
                if viewModel.trips.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "chart.bar")
                            .font(.system(size: 60))
                            .foregroundColor(.pureWhite.opacity(0.6))
                        
                        Text("No data to display yet.")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(.pureWhite.opacity(0.8))
                            .multilineTextAlignment(.center)
                        
                        Text("Add some trips to see your statistics!")
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(.pureWhite.opacity(0.6))
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            StatCard(
                                title: "Total Trips",
                                value: "\(viewModel.trips.count)",
                                icon: "location.circle",
                                color: .lightBlue
                            )
                            
                            let categories = viewModel.getTripCategories()
                            ForEach(categories, id: \.type) { category in
                                StatCard(
                                    title: category.type.displayName,
                                    value: "\(category.count)",
                                    icon: category.type.icon,
                                    color: .brightOrange
                                )
                            }
                            
                            if let recentTrip = viewModel.trips.sorted(by: { $0.date > $1.date }).first {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Most Recent Trip")
                                        .font(.ubuntu(18, weight: .medium))
                                        .foregroundColor(.pureWhite)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(recentTrip.type.displayName)
                                            .font(.ubuntu(16, weight: .medium))
                                            .foregroundColor(.lightBlue)
                                        
                                        Text(recentTrip.route)
                                            .font(.ubuntu(14, weight: .regular))
                                            .foregroundColor(.pureWhite.opacity(0.8))
                                        
                                        Text(recentTrip.formattedDate)
                                            .font(.ubuntu(12, weight: .regular))
                                            .foregroundColor(.pureWhite.opacity(0.6))
                                    }
                                    .padding(16)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.pureWhite.opacity(0.1))
                                    )
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(.pureWhite.opacity(0.8))
                
                Text(value)
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(.pureWhite)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.pureWhite.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    MainTabView()
}
