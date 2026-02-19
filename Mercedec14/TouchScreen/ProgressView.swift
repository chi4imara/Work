import SwiftUI

struct ProgressView: View {
    @EnvironmentObject var appState: AppStateManager
    @EnvironmentObject var bookingsViewModel: BookingsViewModel
    @StateObject private var viewModel = ProgressViewModel()
    @State private var selectedTab = 0
    @State private var showingAddStressLevel = false
    @State private var newStressLevel = 5
    @State private var newStressDate = Date()
    
    var body: some View {
        ZStack {
            Color.clear
            
            VStack(spacing: 0) {
                headerSection
                
                tabSelector
                
                ScrollView {
                    VStack(spacing: 20) {
                        switch selectedTab {
                        case 0:
                            stressLevelSection
                            addStressLevelSection
                            sessionTypesSection
                        case 1:
                            achievementsSection
                        case 2:
                            weeklyProgressSection
                        default:
                            stressLevelSection
                            addStressLevelSection
                            sessionTypesSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            viewModel.updateFromCompletedSessions(bookingsViewModel.completedSessions)
        }
        .onChange(of: appState.sampleDataLoadedTrigger) { _ in
            viewModel.reloadFromStorage()
        }
        .onChange(of: bookingsViewModel.bookedSessions.count) { _ in
            viewModel.updateFromCompletedSessions(bookingsViewModel.completedSessions)
        }
        .sheet(isPresented: $showingAddStressLevel) {
            addStressLevelSheet
        }
    }
    
    private var addStressLevelSheet: some View {
        ZStack {
            AnimatedBackground().ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    Button("Cancel") { showingAddStressLevel = false }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryBlue)
                    Spacer()
                    Text("Add Level")
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    Spacer()
                    Color.clear.frame(width: 60, height: 44)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                VStack(spacing: 24) {
                    Text("Level: \(newStressLevel)/10")
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    Slider(value: Binding(get: { Double(newStressLevel) }, set: { newStressLevel = Int($0.rounded()) }), in: 1...10, step: 1)
                        .accentColor(ColorTheme.primaryBlue)
                    DatePicker("Date", selection: $newStressDate, displayedComponents: .date)
                        .accentColor(ColorTheme.primaryBlue)
                    Button {
                        viewModel.addStressLevel(newStressLevel, date: newStressDate)
                        showingAddStressLevel = false
                    } label: {
                        Text("Add Level")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(RoundedRectangle(cornerRadius: 25).fill(ColorTheme.buttonGradient))
                    }
                }
                .padding(24)
                Spacer()
            }
        }
    }
    
    private var addStressLevelSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Record Level")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            Button(action: { showingAddStressLevel = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Level Entry")
                        .font(.ubuntu(14, weight: .medium))
                }
                .foregroundColor(ColorTheme.primaryBlue)
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.primaryBlue.opacity(0.1))
                )
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Statistics & Effects")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Text("Track your wellness journey and achievements")
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                
                Spacer()
                
                Menu {
                    ForEach(ProgressViewModel.TimeRange.allCases, id: \.self) { range in
                        Button(range.rawValue) {
                            viewModel.selectedTimeRange = range
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(viewModel.selectedTimeRange.rawValue)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorTheme.primaryBlue)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(ColorTheme.primaryBlue)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(ColorTheme.primaryBlue.opacity(0.1))
                    )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(["Analytics", "Achievements", "Weekly"], id: \.self) { tab in
                let index = ["Analytics", "Achievements", "Weekly"].firstIndex(of: tab) ?? 0
                
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = index
                    }
                }) {
                    Text(tab)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(selectedTab == index ? ColorTheme.primaryBlue : ColorTheme.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            Rectangle()
                                .fill(selectedTab == index ? ColorTheme.primaryBlue.opacity(0.1) : Color.clear)
                        )
                        .overlay(
                            Rectangle()
                                .fill(selectedTab == index ? ColorTheme.primaryBlue : Color.clear)
                                .frame(height: 2),
                            alignment: .bottom
                        )
                }
            }
        }
        .padding(.top, 16)
    }
    
    private var stressLevelSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Level Trend")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current Level")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                        
                        Text("\(viewModel.displayedStressLevels.last?.level ?? viewModel.progressData.stressLevels.last?.level ?? 0)/10")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(ColorTheme.primaryBlue)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Improvement")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                        
                        let improvement = calculateImprovement()
                        Text("\(improvement > 0 ? "+" : "")\(improvement)")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(improvement > 0 ? ColorTheme.successGreen : ColorTheme.errorRed)
                    }
                }
                
                stressLevelChart
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var stressLevelChart: some View {
        VStack(spacing: 8) {
            if viewModel.displayedStressLevels.isEmpty && viewModel.progressData.stressLevels.isEmpty {
                Text("No level data yet. Add entries above.")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .frame(height: 80)
            } else {
                let levels = viewModel.displayedStressLevels
                HStack(alignment: .bottom, spacing: 4) {
                    ForEach(Array(levels.enumerated()), id: \.offset) { index, dataPoint in
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(
                                    LinearGradient(
                                        colors: [ColorTheme.primaryBlue, ColorTheme.primaryYellow],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .frame(width: max(12, 200 / CGFloat(max(1, levels.count))), height: CGFloat(dataPoint.level) * 8)
                            
                            Text("\(index + 1)")
                                .font(.ubuntu(8, weight: .regular))
                                .foregroundColor(ColorTheme.textSecondary)
                        }
                    }
                }
                .frame(height: 100)
                
                HStack {
                    Text("First")
                        .font(.ubuntu(10, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    Spacer()
                    
                    Text("Latest")
                        .font(.ubuntu(10, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary)
                }
            }
        }
    }
    
    private var sessionTypesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Session Types Distribution")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            if viewModel.progressData.sessionCounts.isEmpty {
                Text("No data for analysis. Complete sessions and mark them as completed in My Bookings.")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorTheme.cardBackground)
                    )
            } else {
            VStack(spacing: 12) {
                ForEach(viewModel.progressData.sessionCounts) { sessionCount in
                    HStack {
                        HStack(spacing: 8) {
                            Image(systemName: sessionCount.type.icon)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(sessionCount.type.color)
                                .frame(width: 20)
                            
                            Text(sessionCount.type.rawValue)
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(ColorTheme.textPrimary)
                        }
                        
                        Spacer()
                        
                        Text("\(sessionCount.count)")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(ColorTheme.primaryBlue)
                    }
                    .padding(.vertical, 8)
                    
                    if sessionCount.id != viewModel.progressData.sessionCounts.last?.id {
                        Divider()
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
            )
            }
        }
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Achievements")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 12) {
                ForEach(viewModel.achievements) { achievement in
                    AchievementCard(achievement: achievement)
                }
            }
        }
    }
    
    private var weeklyProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Activity")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            if viewModel.progressData.weeklyProgress.isEmpty {
                Text("No weekly data yet. Complete sessions to see activity.")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(ColorTheme.cardBackground)
                    )
            } else {
            VStack(spacing: 12) {
                ForEach(viewModel.progressData.weeklyProgress) { week in
                    HStack {
                        Text(week.week)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(ColorTheme.textPrimary)
                            .frame(width: 80, alignment: .leading)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(ColorTheme.primaryBlue.opacity(0.2))
                                    .frame(height: 8)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(ColorTheme.primaryBlue)
                                    .frame(
                                        width: geometry.size.width * (CGFloat(week.sessionsCount) / 5.0),
                                        height: 8
                                    )
                            }
                        }
                        .frame(height: 8)
                        
                        Text("\(week.sessionsCount)")
                            .font(.ubuntu(14, weight: .bold))
                            .foregroundColor(ColorTheme.primaryBlue)
                            .frame(width: 30, alignment: .trailing)
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
            )
            }
        }
    }
    
    private func calculateImprovement() -> Int {
        let levels = viewModel.displayedStressLevels
        guard levels.count >= 2 else { return 0 }
        
        let current = levels.last?.level ?? 0
        let previous = levels[levels.count - 2].level
        return previous - current
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? ColorTheme.primaryYellow.opacity(0.2) : ColorTheme.textSecondary.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(achievement.isUnlocked ? ColorTheme.primaryYellow : ColorTheme.textSecondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(achievement.isUnlocked ? ColorTheme.textPrimary : ColorTheme.textSecondary)
                
                Text(achievement.description)
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .lineLimit(2)
                
                if !achievement.isUnlocked {
                    VStack(alignment: .leading, spacing: 4) {
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(ColorTheme.textSecondary.opacity(0.2))
                                    .frame(height: 6)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(ColorTheme.primaryBlue)
                                    .frame(
                                        width: geometry.size.width * achievement.progress,
                                        height: 6
                                    )
                            }
                        }
                        .frame(height: 6)
                        
                        Text("\(achievement.currentCount)/\(achievement.requiredCount)")
                            .font(.ubuntu(10, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(ColorTheme.successGreen)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
                .shadow(color: ColorTheme.shadowColor, radius: achievement.isUnlocked ? 8 : 4, x: 0, y: 2)
        )
        .opacity(achievement.isUnlocked ? 1.0 : 0.8)
    }
}

#Preview {
    ProgressView()
}
