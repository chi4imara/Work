import SwiftUI

struct StatisticsView: View {
    @ObservedObject var viewModel: PlacesViewModel
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    if viewModel.totalPlaces == 0 {
                        emptyStateView
                    } else {
                        overviewCards
                        categoryBreakdown
                        recentActivity
                        timeBasedStats
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            print("StatisticsView appeared. Total places: \(viewModel.totalPlaces)")
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(FontManager.largeTitle)
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(viewModel.totalPlaces)")
                    .font(FontManager.title2)
                    .foregroundColor(ColorTheme.primaryBlue)
                
                Text("Total Places")
                    .font(FontManager.caption)
                    .foregroundColor(ColorTheme.secondaryText)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.lightBlue)
            
            VStack(spacing: 12) {
                Text("No Data Yet")
                    .font(FontManager.title2)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Add some places to see your statistics")
                    .font(FontManager.body)
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var overviewCards: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    title: "Categories",
                    value: "\(viewModel.totalCategories)",
                    icon: "folder.fill",
                    color: ColorTheme.primaryBlue
                )
                
                StatCard(
                    title: "Favorites",
                    value: "\(viewModel.totalFavorites)",
                    icon: "heart.fill",
                    color: ColorTheme.accentOrange
                )
                
                StatCard(
                    title: "This Week",
                    value: "\(viewModel.placesAddedThisWeek)",
                    icon: "calendar.badge.plus",
                    color: ColorTheme.lightBlue
                )
                
                StatCard(
                    title: "This Month",
                    value: "\(viewModel.placesAddedThisMonth)",
                    icon: "calendar",
                    color: ColorTheme.blueText
                )
            }
        }
    }
    
    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category Breakdown")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                ForEach(viewModel.categoryStatistics, id: \.0) { category, count in
                    CategoryStatRow(
                        category: category,
                        count: count,
                        total: viewModel.totalPlaces
                    )
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
    }
    
    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 8) {
                ForEach(viewModel.recentPlaces) { place in
                    RecentPlaceRow(place: place)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
    }
    
    private var timeBasedStats: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(FontManager.headline)
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                InsightRow(
                    icon: "star.fill",
                    title: "Most Popular Category",
                    value: viewModel.mostPopularCategory,
                    color: ColorTheme.accentOrange
                )
                
                InsightRow(
                    icon: "chart.bar.fill",
                    title: "Average per Category",
                    value: String(format: "%.1f", viewModel.averagePlacesPerCategory),
                    color: ColorTheme.primaryBlue
                )
                
                if viewModel.totalFavorites > 0 {
                    InsightRow(
                        icon: "heart.fill",
                        title: "Favorite Rate",
                        value: "\(Int((Double(viewModel.totalFavorites) / Double(viewModel.totalPlaces)) * 100))%",
                        color: ColorTheme.accentOrange
                    )
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
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
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(value)
                .font(FontManager.title2)
                .foregroundColor(ColorTheme.primaryText)
            
            Text(title)
                .font(FontManager.caption)
                .foregroundColor(ColorTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: color.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct CategoryStatRow: View {
    let category: String
    let count: Int
    let total: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total) * 100
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(category)
                    .font(FontManager.subheadline)
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("\(count) place\(count == 1 ? "" : "s")")
                    .font(FontManager.caption)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(percentage))%")
                    .font(FontManager.subheadline)
                    .foregroundColor(ColorTheme.primaryBlue)
                
                ProgressView(value: percentage, total: 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: ColorTheme.primaryBlue))
                    .frame(width: 60)
            }
        }
    }
}

struct RecentPlaceRow: View {
    let place: Place
    
    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: place.dateAdded, relativeTo: Date())
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "location.fill")
                .font(.system(size: 16))
                .foregroundColor(ColorTheme.primaryBlue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(place.name)
                    .font(FontManager.subheadline)
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(1)
                
                Text(place.category)
                    .font(FontManager.caption)
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(timeAgo)
                    .font(FontManager.caption)
                    .foregroundColor(ColorTheme.blueText)
                
                if place.isFavorite {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12))
                        .foregroundColor(ColorTheme.accentOrange)
                }
            }
        }
    }
}

struct InsightRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
                .frame(width: 20)
            
            Text(title)
                .font(Font.custom("Poppins-Medium", size: 11))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Text(value)
                .font(FontManager.subheadline)
                .foregroundColor(ColorTheme.primaryBlue)
                .fontWeight(.medium)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView(viewModel: PlacesViewModel())
    }
}
