import SwiftUI

struct SeriesProgressView: View {
    @ObservedObject var viewModel: SeriesViewModel
    @State private var selectedSegment: SeriesStatus?
    @State private var selectedSeries: Series?
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Text("Progress")
                        .font(.titleMedium)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.series.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color.lightBlue.opacity(0.3))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: "chart.pie.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.primaryBlue)
                        }
                        
                        VStack(spacing: 8) {
                            Text("No Progress Data")
                                .font(.titleMedium)
                                .foregroundColor(.textPrimary)
                                .multilineTextAlignment(.center)
                            
                            Text("Add some series to see your progress")
                                .font(.bodyLarge)
                                .foregroundColor(.textSecondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Progress Overview")
                                        .font(.titleMedium)
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        Text("\(viewModel.totalSeriesCount) Total")
                                            .font(.bodyMedium)
                                            .foregroundColor(.textSecondary)
                                        
                                        Text("\(viewModel.watchingCount) watching")
                                            .font(.captionMedium)
                                            .foregroundColor(.statusWatching)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.lightBlue.opacity(0.3))
                                    .cornerRadius(12)
                                }
                                
                                ZStack {
                                    Circle()
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.lightBlue.opacity(0.3), Color.lightBlue.opacity(0.1)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 20
                                        )
                                        .frame(width: 220, height: 220)
                                        .scaleEffect(selectedSegment != nil ? 1.05 : 1.0)
                                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedSegment)
                                    
                                    PieChartView(
                                        viewModel: viewModel,
                                        watchingPercentage: viewModel.watchingPercentage,
                                        waitingPercentage: viewModel.waitingPercentage,
                                        onSegmentTap: { status in
                                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                                selectedSegment = selectedSegment == status ? nil : status
                                            }
                                        }
                                    )
                                    .frame(width: 220, height: 220)
                                    .scaleEffect(selectedSegment != nil ? 1.02 : 1.0)
                                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedSegment)
                                }
                                
                                HStack(spacing: 12) {
                                    StatCard(
                                        viewModel: viewModel,
                                        title: "Watching",
                                        value: "\(viewModel.watchingCount)",
                                        color: .statusWatching,
                                        icon: "play.circle.fill",
                                        subtitle: "Currently watching"
                                    )
                                    
                                    StatCard(
                                        viewModel: viewModel,
                                        title: "Waiting",
                                        value: "\(viewModel.waitingCount)",
                                        color: .statusWaiting,
                                        icon: "clock.fill",
                                        subtitle: "For new seasons"
                                    )
                                    
                                    StatCard(
                                        viewModel: viewModel,
                                        title: "Total",
                                        value: "\(viewModel.totalSeriesCount)",
                                        color: .primaryBlue,
                                        icon: "tv.fill",
                                        subtitle: "All series"
                                    )
                                }
                            }
                            .padding(24)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Categories")
                                        .font(.titleMedium)
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    Text("\(viewModel.getAllCategories().count) categories")
                                        .font(.bodyMedium)
                                        .foregroundColor(.textSecondary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.lightBlue.opacity(0.3))
                                        .cornerRadius(12)
                                }
                                
                                let categories = viewModel.getAllCategories()
                                if categories.isEmpty {
                                    VStack(spacing: 16) {
                                        Image(systemName: "folder")
                                            .font(.system(size: 40))
                                            .foregroundColor(.textSecondary)
                                        
                                        Text("No categories yet")
                                            .font(.bodyLarge)
                                            .foregroundColor(.textSecondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                                    .background(Color.lightBlue.opacity(0.1))
                                    .cornerRadius(16)
                                } else {
                                    LazyVGrid(columns: [
                                        GridItem(.flexible()),
                                        GridItem(.flexible())
                                    ], spacing: 12) {
                                        ForEach(categories, id: \.category) { categoryData in
                                            CategoryCard(
                                                category: categoryData.category,
                                                customCategory: categoryData.customCategory,
                                                count: categoryData.count,
                                                totalCount: viewModel.totalSeriesCount
                                            )
                                        }
                                    }
                                }
                            }
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Recent Activity")
                                        .font(Font.poppinsSemiBold(18))
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    Text("Latest additions")
                                        .font(.bodyMedium)
                                        .foregroundColor(.textSecondary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.lightBlue.opacity(0.3))
                                        .cornerRadius(12)
                                }
                                
                                let recentSeries = Array(viewModel.series.sorted { $0.dateAdded > $1.dateAdded }.prefix(3))
                                
                                if recentSeries.isEmpty {
                                    VStack(spacing: 16) {
                                        Image(systemName: "clock.arrow.circlepath")
                                            .font(.system(size: 40))
                                            .foregroundColor(.textSecondary)
                                        
                                        Text("No recent activity")
                                            .font(.bodyLarge)
                                            .foregroundColor(.textSecondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                                    .background(Color.lightBlue.opacity(0.1))
                                    .cornerRadius(16)
                                } else {
                                    VStack(spacing: 12) {
                                        ForEach(recentSeries) { series in
                                            RecentSeriesCard(series: series) {
                                                selectedSeries = series
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("Achievements")
                                        .font(.titleMedium)
                                        .foregroundColor(.textPrimary)
                                    
                                    Spacer()
                                    
                                    Text("Your progress")
                                        .font(.bodyMedium)
                                        .foregroundColor(.textSecondary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.lightBlue.opacity(0.3))
                                        .cornerRadius(12)
                                }
                                
                                let achievements = generateAchievements(for: viewModel)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 12) {
                                    ForEach(achievements, id: \.title) { achievement in
                                        AchievementCard(achievement: achievement)
                                    }
                                }
                            }
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                            
                            if let selectedSegment = selectedSegment {
                                VStack(alignment: .leading, spacing: 16) {
                                    HStack {
                                        Text(selectedSegment.displayName)
                                            .font(.titleMedium)
                                            .foregroundColor(.textPrimary)
                                        
                                        Spacer()
                                        
                                        let filteredSeries = selectedSegment == .watching ? viewModel.watchingSeries : viewModel.waitingSeries
                                        Text("\(filteredSeries.count) series")
                                            .font(.bodyMedium)
                                            .foregroundColor(.textSecondary)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.lightBlue.opacity(0.3))
                                            .cornerRadius(12)
                                    }
                                    
                                    let filteredSeries = selectedSegment == .watching ? viewModel.watchingSeries : viewModel.waitingSeries
                                    
                                    if filteredSeries.isEmpty {
                                        VStack(spacing: 16) {
                                            Image(systemName: selectedSegment == .watching ? "play.circle" : "clock")
                                                .font(.system(size: 40))
                                                .foregroundColor(.textSecondary)
                                            
                                            Text("No \(selectedSegment.displayName.lowercased()) series")
                                                .font(.bodyLarge)
                                                .foregroundColor(.textSecondary)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 40)
                                        .background(Color.lightBlue.opacity(0.1))
                                        .cornerRadius(16)
                                    } else {
                                        LazyVStack(spacing: 12) {
                                            ForEach(filteredSeries) { series in
                                                CompactSeriesCard(series: series) {
                                                    selectedSeries = series
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(20)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(item: $selectedSeries) { series in
            SeriesDetailView(viewModel: viewModel, seriesId: series.id)
        }
    }
}

struct PieChartView: View {
    @ObservedObject var viewModel: SeriesViewModel
    let watchingPercentage: Double
    let waitingPercentage: Double
    let onSegmentTap: (SeriesStatus) -> Void
    @State private var animationProgress: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: waitingPercentage * animationProgress)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.statusWaiting, Color.statusWaiting.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 24, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .onTapGesture {
                    onSegmentTap(.waiting)
                }
                .animation(.easeInOut(duration: 1.2), value: animationProgress)
            
            Circle()
                .trim(from: waitingPercentage * animationProgress, to: (waitingPercentage + watchingPercentage) * animationProgress)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.statusWatching, Color.statusWatching.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 24, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .onTapGesture {
                    onSegmentTap(.watching)
                }
                .animation(.easeInOut(duration: 1.2).delay(0.3), value: animationProgress)
            
            VStack(spacing: 6) {
                Text("Total")
                    .font(.bodyMedium)
                    .foregroundColor(.textSecondary)
                    .opacity(animationProgress)
                
                Text("\(viewModel.totalSeriesCount)")
                    .font(.titleLarge)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.bold)
                    .scaleEffect(0.8 + 0.2 * animationProgress)
            }
            .animation(.easeInOut(duration: 0.8).delay(0.6), value: animationProgress)
        }
        .onAppear {
            withAnimation {
                animationProgress = 1.0
            }
        }
    }
}

struct StatCard: View {
    @ObservedObject var viewModel: SeriesViewModel
    let title: String
    let value: String
    let color: Color
    let icon: String
    let subtitle: String
    @State private var isVisible = false
    
    var percentage: Int {
        guard viewModel.totalSeriesCount > 0 else { return 0 }
        return Int(Double(value)! * 100 / Double(viewModel.totalSeriesCount))
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 44, height: 44)
                    .scaleEffect(isVisible ? 1.0 : 0.8)
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
                    .scaleEffect(isVisible ? 1.0 : 0.8)
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isVisible)
            
            VStack(spacing: 6) {
                Text(value)
                    .font(.titleMedium)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.bold)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 10)
                
                Text("\(percentage)%")
                    .font(.bodyMedium)
                    .foregroundColor(color)
                    .fontWeight(.medium)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 10)
                
                VStack(spacing: 2) {
                    Text(title)
                        .font(Font.poppinsRegular(11))
                        .foregroundColor(.textPrimary)
                        .fontWeight(.medium)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 10)
                    
                    Text(subtitle)
                        .font(.captionSmall)
                        .foregroundColor(.textSecondary)
                        .multilineTextAlignment(.center)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(y: isVisible ? 0 : 10)
                }
            }
            .animation(.easeInOut(duration: 0.8).delay(0.2), value: isVisible)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
    }
}

struct CompactSeriesCard: View {
    let series: Series
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(series.status == .watching ? Color.statusWatching.opacity(0.1) : Color.statusWaiting.opacity(0.1))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: series.status == .watching ? "play.circle.fill" : "clock.fill")
                        .font(.system(size: 20))
                        .foregroundColor(series.status == .watching ? .statusWatching : .statusWaiting)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(series.title)
                        .font(.titleSmall)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 8) {
                        Text(series.category.displayName)
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                        
                        Text("•")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                        
                        Text(series.status.displayName)
                            .font(.bodyMedium)
                            .foregroundColor(series.status == .watching ? .statusWatching : .statusWaiting)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.textSecondary)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategoryCard: View {
    let category: SeriesCategory
    let customCategory: CustomCategory?
    let count: Int
    let totalCount: Int
    @State private var isVisible = false
    
    var categoryName: String {
        if let customCategory = customCategory {
            return customCategory.name
        }
        return category.displayName
    }
    
    var categoryColor: Color {
        switch category {
        case .drama:
            return .accentRed
        case .comedy:
            return .accentOrange
        case .sciFi:
            return .primaryBlue
        case .other:
            return .statusWaiting
        case .custom:
            return .accentGreen
        }
    }
    
    var categoryIcon: String {
        switch category {
        case .drama:
            return "theatermasks.fill"
        case .comedy:
            return "face.smiling.fill"
        case .sciFi:
            return "atom"
        case .other:
            return "questionmark.circle.fill"
        case .custom:
            return "star.fill"
        }
    }
    
    var percentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(count) / Double(totalCount)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(categoryColor.opacity(0.1))
                        .frame(width: 32, height: 32)
                        .scaleEffect(isVisible ? 1.0 : 0.8)
                    
                    Image(systemName: categoryIcon)
                        .font(.system(size: 16))
                        .foregroundColor(categoryColor)
                        .scaleEffect(isVisible ? 1.0 : 0.8)
                }
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isVisible)
                
                Spacer()
                
                Text("\(count)")
                    .font(.titleSmall)
                    .foregroundColor(.textPrimary)
                    .fontWeight(.bold)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(x: isVisible ? 0 : 20)
            }
            .animation(.easeInOut(duration: 0.8).delay(0.1), value: isVisible)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(categoryName)
                    .font(.bodyMedium)
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 10)
                
                Text("\(Int(percentage * 100))%")
                    .font(.captionMedium)
                    .foregroundColor(.textSecondary)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .animation(.easeInOut(duration: 0.8).delay(0.2), value: isVisible)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(categoryColor.opacity(0.2), lineWidth: 1)
        )
        .scaleEffect(isVisible ? 1.0 : 0.95)
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
    }
}

struct RecentSeriesCard: View {
    let series: Series
    let onTap: () -> Void
    @State private var isVisible = false
    
    private var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: series.dateAdded, relativeTo: Date())
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(series.status == .watching ? Color.statusWatching.opacity(0.1) : Color.statusWaiting.opacity(0.1))
                        .frame(width: 40, height: 40)
                        .scaleEffect(isVisible ? 1.0 : 0.8)
                    
                    Image(systemName: series.status == .watching ? "play.circle.fill" : "clock.fill")
                        .font(.system(size: 18))
                        .foregroundColor(series.status == .watching ? .statusWatching : .statusWaiting)
                        .scaleEffect(isVisible ? 1.0 : 0.8)
                }
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isVisible)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(series.title)
                        .font(.bodyLarge)
                        .foregroundColor(.textPrimary)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(x: isVisible ? 0 : -20)
                    
                        Text(series.category.displayName)
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(x: isVisible ? 0 : -20)
                        
                    HStack(spacing: 8) {
                        Text("•")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .opacity(isVisible ? 1.0 : 0.0)
                        
                        Text(timeAgo)
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .opacity(isVisible ? 1.0 : 0.0)
                            .offset(x: isVisible ? 0 : -20)
                    }
                }
                .animation(.easeInOut(duration: 0.8).delay(0.1), value: isVisible)
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(x: isVisible ? 0 : 20)
                    
                    Text(series.status.displayName)
                        .font(.captionSmall)
                        .foregroundColor(series.status == .watching ? .statusWatching : .statusWaiting)
                        .opacity(isVisible ? 1.0 : 0.0)
                        .offset(x: isVisible ? 0 : 20)
                }
                .animation(.easeInOut(duration: 0.8).delay(0.2), value: isVisible)
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
            .scaleEffect(isVisible ? 1.0 : 0.95)
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
    }
}

struct Achievement {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
    let progress: Double
}

func generateAchievements(for viewModel: SeriesViewModel) -> [Achievement] {
    let totalSeries = viewModel.totalSeriesCount
    let watchingCount = viewModel.watchingCount
    let waitingCount = viewModel.waitingCount
    let categories = viewModel.getAllCategories()
    
    return [
        Achievement(
            title: "First Steps",
            description: "Add your first series",
            icon: "plus.circle.fill",
            color: .accentGreen,
            isUnlocked: totalSeries >= 1,
            progress: min(Double(totalSeries), 1.0)
        ),
        Achievement(
            title: "Series Collector",
            description: "Add 5 series",
            icon: "tv.fill",
            color: .primaryBlue,
            isUnlocked: totalSeries >= 5,
            progress: min(Double(totalSeries) / 5.0, 1.0)
        ),
        Achievement(
            title: "Binge Watcher",
            description: "Have 3+ watching series",
            icon: "play.circle.fill",
            color: .statusWatching,
            isUnlocked: watchingCount >= 3,
            progress: min(Double(watchingCount) / 3.0, 1.0)
        ),
        Achievement(
            title: "Patient Viewer",
            description: "Have 3+ waiting series",
            icon: "clock.fill",
            color: .statusWaiting,
            isUnlocked: waitingCount >= 3,
            progress: min(Double(waitingCount) / 3.0, 1.0)
        ),
        Achievement(
            title: "Category Explorer",
            description: "Use 3+ categories",
            icon: "folder.fill",
            color: .accentOrange,
            isUnlocked: categories.count >= 3,
            progress: min(Double(categories.count) / 3.0, 1.0)
        ),
        Achievement(
            title: "Series Master",
            description: "Add 10+ series",
            icon: "star.fill",
            color: .accentRed,
            isUnlocked: totalSeries >= 10,
            progress: min(Double(totalSeries) / 10.0, 1.0)
        )
    ]
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? achievement.color.opacity(0.1) : Color.gray.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 18))
                    .foregroundColor(achievement.isUnlocked ? achievement.color : .gray)
            }
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(.bodyMedium)
                    .foregroundColor(achievement.isUnlocked ? .textPrimary : .gray)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                
                Text(achievement.description)
                    .font(.captionSmall)
                    .foregroundColor(achievement.isUnlocked ? .textSecondary : .gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if !achievement.isUnlocked {
                    ProgressView(value: achievement.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: achievement.color))
                        .scaleEffect(y: 0.5)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(achievement.isUnlocked ? Color.white : Color.gray.opacity(0.05))
        .cornerRadius(16)
        .shadow(color: achievement.isUnlocked ? Color.black.opacity(0.05) : Color.clear, radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(achievement.isUnlocked ? achievement.color.opacity(0.3) : Color.gray.opacity(0.2), lineWidth: 1)
        )
        .scaleEffect(achievement.isUnlocked ? 1.0 : 0.95)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: achievement.isUnlocked)
    }
}
