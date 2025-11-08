import SwiftUI

struct StatisticsView: View {
    @StateObject private var dataManager = MoodDataManager.shared
    @State private var selectedDate: Date?
    @State private var showColorSelection = false
    @State private var animateContent = false
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if dataManager.moodEntries.isEmpty {
                    emptyStateView
                } else {
                    statisticsContent
                }
            }
        }
        .sheet(isPresented: $showColorSelection) {
            if let date = selectedDate {
                ColorSelectionView(selectedDate: date, isPresented: $showColorSelection)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateContent = true
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Statistics")
                .font(AppTheme.Fonts.largeTitle)
                .foregroundColor(AppTheme.Colors.primaryText)
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(y: animateContent ? 0 : -30)
            
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.accentYellow.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .scaleEffect(pulseScale)
                
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(AppTheme.Colors.accentYellow)
                    .rotationEffect(.degrees(rotationAngle))
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .scaleEffect(animateContent ? 1.0 : 0.5)
        }
        .padding(.horizontal, AppTheme.Spacing.lg)
        .padding(.top, AppTheme.Spacing.md + 8)
        .opacity(animateContent ? 1.0 : 0.0)
        .offset(y: animateContent ? 0 : -20)
    }
    
    private var statisticsContent: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.xl) {
                generalStatsSection
                
                colorDistributionSection
                
                activitySection
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.lg)
            .padding(.bottom, 80)
        }
    }
    
    private var generalStatsSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            HStack {
                Text("Overview")
                    .font(AppTheme.Fonts.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            
            VStack(spacing: AppTheme.Spacing.md) {
                StatCard(
                    title: "Total Days Tracked",
                    value: "\(dataManager.getTotalDaysCount())",
                    icon: "calendar",
                    color: AppTheme.Colors.accentYellow
                )
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(x: animateContent ? 0 : -50)
                .animation(.easeOut(duration: 0.6).delay(max(0, 0.1)), value: animateContent)
                
                StatCard(
                    title: "Favorite Days",
                    value: "\(dataManager.getFavoritesCount())",
                    icon: "star.fill",
                    color: AppTheme.Colors.accentYellow
                )
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(x: animateContent ? 0 : -50)
                .animation(.easeOut(duration: 0.6).delay(max(0, 0.2)), value: animateContent)
                
                if let lastDate = dataManager.getLastEntryDate() {
                    StatCard(
                        title: "Last Entry",
                        value: dateFormatter.string(from: lastDate),
                        icon: "clock",
                        color: AppTheme.Colors.accentYellow
                    )
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(x: animateContent ? 0 : -50)
                    .animation(.easeOut(duration: 0.6).delay(max(0, 0.3)), value: animateContent)
                }
            }
        }
    }
    
    private var colorDistributionSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            HStack {
                Text("Color Distribution")
                    .font(AppTheme.Fonts.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(0.4), value: animateContent)
            
            let colorDistribution = dataManager.getColorDistribution()
            
            if !colorDistribution.isEmpty {
                VStack(spacing: AppTheme.Spacing.md) {
                    ForEach(Array(colorDistribution.enumerated()), id: \.offset) { index, item in
                        ColorDistributionRow(
                            color: item.0,
                            count: item.1,
                            totalCount: dataManager.getTotalDaysCount()
                        )
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(x: animateContent ? 0 : 50)
                        .animation(.easeOut(duration: 0.6).delay(max(0, 0.5 + Double(index) * 0.1)), value: animateContent)
                    }
                }
            }
        }
    }
    
    private var activitySection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            HStack {
                Text("Activity")
                    .font(AppTheme.Fonts.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Spacer()
            }
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(0.8), value: animateContent)
            
            VStack(spacing: AppTheme.Spacing.md) {
                StatCard(
                    title: "Current Streak",
                    value: "\(dataManager.getCurrentStreak()) days",
                    icon: "flame.fill",
                    color: AppTheme.Colors.warning
                )
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(x: animateContent ? 0 : -50)
                .animation(.easeOut(duration: 0.6).delay(max(0, 0.9)), value: animateContent)
                
                StatCard(
                    title: "Best Streak",
                    value: "\(dataManager.getMaxStreak()) days",
                    icon: "trophy.fill",
                    color: AppTheme.Colors.accentYellow
                )
                .opacity(animateContent ? 1.0 : 0.0)
                .offset(x: animateContent ? 0 : -50)
                .animation(.easeOut(duration: 0.6).delay(max(0, 1.0)), value: animateContent)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            Spacer()
            
            Image(systemName: "chart.bar")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppTheme.Colors.accentYellow)
                .opacity(animateContent ? 1.0 : 0.0)
                .scaleEffect(animateContent ? 1.0 : 0.8)
            
            VStack(spacing: AppTheme.Spacing.md) {
                Text("No data for statistics yet")
                    .font(AppTheme.Fonts.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
                
                Text("Start tracking your mood to see insights")
                    .font(AppTheme.Fonts.body)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .offset(y: animateContent ? 0 : 20)
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            
            Button(action: {
                selectedDate = Date()
                showColorSelection = true
            }) {
                Text("Add Mood")
                    .font(AppTheme.Fonts.buttonFont)
                    .foregroundColor(AppTheme.Colors.backgroundBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppTheme.Colors.accentYellow)
                    .cornerRadius(AppTheme.CornerRadius.large)
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .opacity(animateContent ? 1.0 : 0.0)
            .offset(y: animateContent ? 0 : 20)
            
            Spacer()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(title)
                    .font(AppTheme.Fonts.subheadline)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                Text(value)
                    .font(AppTheme.Fonts.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(AppTheme.Colors.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct ColorDistributionRow: View {
    let color: MoodColor
    let count: Int
    let totalCount: Int
    
    private var percentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(count) / Double(totalCount)
    }
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Circle()
                .fill(color.color)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(color.displayName)
                    .font(AppTheme.Fonts.callout)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text(color.emotion)
                    .font(AppTheme.Fonts.caption1)
                    .foregroundColor(AppTheme.Colors.tertiaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs) {
                Text("\(count)")
                    .font(AppTheme.Fonts.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 60, height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.color)
                        .frame(width: 60 * percentage, height: 8)
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    StatisticsView()
}
