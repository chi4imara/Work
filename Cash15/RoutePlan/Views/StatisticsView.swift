import SwiftUI

struct StatisticsView: View {
    @StateObject private var dataManager = DataManager.shared
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            VStack(spacing: 2) {
                headerView
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            tripStatisticsSection
                            
                            wishlistStatisticsSection
                            
                            travelInsightsSection
                            

                            recentActivitySection
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(FontManager.title)
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(ColorTheme.accent)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var tripStatisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Trip Statistics")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(
                    title: "Total Trips",
                    value: "\(dataManager.trips.count)",
                    icon: "suitcase.fill",
                    color: ColorTheme.accent
                )
                
                StatCard(
                    title: "Active Trips",
                    value: "\(dataManager.getActiveTrips().count)",
                    icon: "airplane",
                    color: .blue
                )
                
                StatCard(
                    title: "Deleted",
                    value: "\(dataManager.trips.filter { $0.isArchived }.count)",
                    icon: "trash.fill",
                    color: .red
                )
                
                StatCard(
                    title: "Countries",
                    value: "\(uniqueCountriesCount)",
                    icon: "globe",
                    color: .green
                )
            }
        }
        .padding(20)
        .background(
            ColorTheme.cardGradient
                .cornerRadius(16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
    
    private var wishlistStatisticsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Wishlist Statistics")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCard(
                    title: "Total Items",
                    value: "\(dataManager.wishlistItems.count)",
                    icon: "heart.fill",
                    color: .red
                )
                
                StatCard(
                    title: "Priority Items",
                    value: "\(dataManager.wishlistItems.filter { $0.isPriority }.count)",
                    icon: "star.fill",
                    color: ColorTheme.accent
                )
            }
        }
        .padding(20)
        .background(
            ColorTheme.cardGradient
                .cornerRadius(16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
    
    private var travelInsightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Travel Insights")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                if let mostVisitedCountry = mostVisitedCountry {
                    InsightRow(
                        title: "Most Visited Country",
                        value: mostVisitedCountry,
                        icon: "flag.fill"
                    )
                }
                
                if let longestTrip = longestTrip {
                    InsightRow(
                        title: "Longest Trip",
                        value: "\(longestTrip.title) (\(longestTrip.duration) days)",
                        icon: "calendar"
                    )
                }
                
                if let upcomingTrip = nextUpcomingTrip {
                    InsightRow(
                        title: "Next Trip",
                        value: upcomingTrip.title,
                        icon: "clock.fill"
                    )
                }
                
                InsightRow(
                    title: "Total Travel Days",
                    value: "\(totalTravelDays) days",
                    icon: "timer"
                )
            }
        }
        .padding(20)
        .background(
            ColorTheme.cardGradient
                .cornerRadius(16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 8) {
                ForEach(recentTrips.prefix(3), id: \.id) { trip in
                    HStack {
                        Image(systemName: "airplane.circle.fill")
                            .foregroundColor(ColorTheme.accent)
                            .font(.system(size: 16))
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(trip.title)
                                .font(FontManager.body)
                                .foregroundColor(ColorTheme.primaryText)
                            
                            Text("Added \(formatRelativeDate(trip.createdAt))")
                                .font(FontManager.small)
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
                
                if recentTrips.isEmpty {
                    Text("No recent activity")
                        .font(FontManager.body)
                        .foregroundColor(ColorTheme.secondaryText)
                        .italic()
                        .padding(.vertical, 8)
                }
            }
        }
        .padding(20)
        .background(
            ColorTheme.cardGradient
                .cornerRadius(16)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
    
    private var uniqueCountriesCount: Int {
        let countries = Set(dataManager.trips.map { $0.country })
        return countries.count
    }
    
    private var mostVisitedCountry: String? {
        let countryCounts = Dictionary(grouping: dataManager.trips, by: { $0.country })
            .mapValues { $0.count }
        return countryCounts.max(by: { $0.value < $1.value })?.key
    }
    
    private var longestTrip: Trip? {
        return dataManager.trips.max(by: { $0.duration < $1.duration })
    }
    
    private var nextUpcomingTrip: Trip? {
        let now = Date()
        return dataManager.getActiveTrips()
            .filter { $0.startDate > now }
            .min(by: { $0.startDate < $1.startDate })
    }
    
    private var totalTravelDays: Int {
        return dataManager.trips.reduce(0) { total, trip in
            total + trip.duration
        }
    }
    
    private var recentTrips: [Trip] {
        return dataManager.trips
            .sorted { $0.createdAt > $1.createdAt }
    }
    
    private func formatRelativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
                .fontWeight(.bold)
            
            Text(title)
                .font(FontManager.small)
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            ColorTheme.cardBackground
                .cornerRadius(12)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorTheme.borderColor.opacity(0.5), lineWidth: 1)
        )
    }
}

struct InsightRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(ColorTheme.accent)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(FontManager.small)
                    .foregroundColor(ColorTheme.secondaryText)
                
                Text(value)
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.primaryText)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

extension Trip {
    var duration: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return max(1, components.day ?? 1)
    }
}

#Preview {
    StatisticsView()
}
