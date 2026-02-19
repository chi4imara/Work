import SwiftUI

struct ProgressView: View {
    @ObservedObject var appViewModel: AppViewModel
    @StateObject private var viewModel: ProgressViewModel
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
        self._viewModel = StateObject(wrappedValue: ProgressViewModel(appViewModel: appViewModel))
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Progress & Impact")
                        .font(.playfair(32, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 24) {
                        statsOverview
                        activityChart
                        moodChart
                        achievementsSection
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $viewModel.showingMoodEntry) {
            MoodEntryView { mood in
                viewModel.addMoodEntry(mood)
            }
        }
    }
    
    private var statsOverview: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCard(
                title: "Activities Completed",
                value: "\(viewModel.completedEventsCount)",
                icon: "checkmark.circle.fill",
                color: ColorTheme.accentGreen
            )
            
            StatCard(
                title: "Current Streak",
                value: "\(viewModel.currentStreak) days",
                icon: "flame.fill",
                color: ColorTheme.accentOrange
            )
            
            StatCard(
                title: "This Week",
                value: "\(viewModel.weeklyActivityData.map { Int($0.value) }.reduce(0, +))",
                icon: "calendar.badge.clock",
                color: ColorTheme.primaryBlue
            )
            
            StatCard(
                title: "Average Mood",
                value: averageMoodText,
                icon: "face.smiling",
                color: ColorTheme.accentPink
            )
        }
    }
    
    private var activityChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Activity Regularity")
                    .font(.playfair(20, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Picker("Time Range", selection: $viewModel.selectedTimeRange) {
                    ForEach(TimeRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(maxWidth: .infinity)
            }
            
            if viewModel.weeklyActivityData.isEmpty {
                emptyChartView("No activity data available")
            } else {
                SimpleBarChart(data: viewModel.weeklyActivityData, color: ColorTheme.primaryBlue)
                    .frame(height: 200)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var moodChart: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Mood & Well-being")
                    .font(.playfair(20, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
                
                Button {
                    viewModel.showingMoodEntry = true
                } label: {
                    Text("Add Mood")
                        .font(.playfair(14))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(ColorTheme.buttonGradient)
                        .foregroundColor(ColorTheme.primaryText)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            if viewModel.moodData.isEmpty {
                emptyChartView("No mood data available")
            } else {
                SimpleLineChart(data: viewModel.moodData, color: ColorTheme.accentPink)
                    .frame(height: 150)
            }
            
            HStack(spacing: 0) {
                ForEach(MoodLevel.allCases.reversed(), id: \.self) { mood in
                    HStack(spacing: 4) {
                        Text(mood.emoji)
                            .font(.system(size: 12))
                        Text("\(mood.value)")
                            .font(.playfair(10))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var achievementsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Achievements")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            if viewModel.unlockedAchievements.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "trophy")
                        .font(.system(size: 40))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Text("No achievements yet")
                        .font(.playfair(16))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Text("Complete activities to unlock achievements!")
                        .font(.playfair(14))
                        .foregroundColor(ColorTheme.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(viewModel.unlockedAchievements) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var shareSection: some View {
        VStack(spacing: 16) {
            Text("Share Your Progress")
                .font(.playfair(18, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            HStack(spacing: 16) {
                shareButton("Share Stats", icon: "square.and.arrow.up") {
                    shareProgress()
                }
                
                shareButton("Social Media", icon: "person.2") {
                    shareToSocial()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var averageMoodText: String {
        let average = viewModel.moodData.map { $0.value }.reduce(0, +) / Double(max(viewModel.moodData.count, 1))
        let mood = MoodLevel.allCases.first { $0.value == Int(average.rounded()) } ?? .neutral
        return mood.emoji
    }
    
    private func emptyChartView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.bar")
                .font(.system(size: 30))
                .foregroundColor(ColorTheme.secondaryText)
            
            Text(message)
                .font(.playfair(14))
                .foregroundColor(ColorTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
    }
    
    private func shareButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .font(.playfair(14, weight: .medium))
            .foregroundColor(ColorTheme.primaryText)
            .frame(maxWidth: .infinity)
            .padding()
            .background(ColorTheme.buttonGradient)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private func shareProgress() {
        let text = "I've completed \(viewModel.completedEventsCount) leisure activities and maintained a \(viewModel.currentStreak)-day streak! 🎉"
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func shareToSocial() {
        shareProgress()
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
                
                Spacer()
            }
            
            Text(value)
                .font(.playfair(24, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Text(title)
                .font(.playfair(12))
                .foregroundColor(ColorTheme.secondaryText)
                .lineLimit(2)
        }
        .padding()
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.cardGradient)
                .shadow(color: color.opacity(0.2), radius: 4, x: 0, y: 2)
        )
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: achievement.icon)
                .font(.system(size: 24))
                .foregroundColor(ColorTheme.primaryYellow)
            
            Text(achievement.title)
                .font(.playfair(14, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
                .multilineTextAlignment(.center)
            
            Text(achievement.description)
                .font(.playfair(10))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.primaryYellow.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(ColorTheme.primaryYellow.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

struct SimpleBarChart: View {
    let data: [ChartDataPoint]
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.map { $0.value }.max() ?? 1
            let barWidth = (geometry.size.width - CGFloat(data.count - 1) * 4) / CGFloat(data.count)
            
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(data.indices, id: \.self) { index in
                    VStack(spacing: 4) {
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(color)
                            .frame(
                                width: barWidth,
                                height: max(4, (data[index].value / maxValue) * (geometry.size.height - 30))
                            )
                        
                        Text(data[index].label)
                            .font(.playfair(10))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                }
            }
        }
    }
}

struct SimpleLineChart: View {
    let data: [ChartDataPoint]
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.map { $0.value }.max() ?? 5
            let minValue = data.map { $0.value }.min() ?? 1
            let range = maxValue - minValue
            
            ZStack {
                ForEach(1...5, id: \.self) { line in
                    Path { path in
                        let y = geometry.size.height * (1 - CGFloat(line) / 5)
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                    .stroke(ColorTheme.lightBlue.opacity(0.3), lineWidth: 1)
                }
                
                if data.count > 1 {
                    Path { path in
                        for (index, point) in data.enumerated() {
                            let x = CGFloat(index) * (geometry.size.width / CGFloat(data.count - 1))
                            let y = geometry.size.height * (1 - (point.value - minValue) / range)
                            
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                    .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                    
                    ForEach(data.indices, id: \.self) { index in
                        let x = CGFloat(index) * (geometry.size.width / CGFloat(data.count - 1))
                        let y = geometry.size.height * (1 - (data[index].value - minValue) / range)
                        
                        Circle()
                            .fill(color)
                            .frame(width: 8, height: 8)
                            .position(x: x, y: y)
                    }
                }
            }
        }
    }
}

struct MoodEntryView: View {
    let onSave: (MoodLevel) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMood: MoodLevel = .neutral
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 32) {
                    Text("How are you feeling today?")
                        .font(.playfair(24, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryText)
                        .multilineTextAlignment(.center)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        ForEach(MoodLevel.allCases, id: \.self) { mood in
                            MoodButton(
                                mood: mood,
                                isSelected: selectedMood == mood
                            ) {
                                selectedMood = mood
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        onSave(selectedMood)
                        dismiss()
                    } label: {
                        Text("Save Mood")
                            .font(.playfair(18, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(ColorTheme.buttonGradient)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding()
            }
            .navigationTitle("Mood Check-in")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTheme.primaryBlue)
                }
            }
        }
    }
}

struct MoodButton: View {
    let mood: MoodLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(mood.emoji)
                    .font(.system(size: 40))
                
                Text(mood.rawValue)
                    .font(.playfair(14, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.secondaryText)
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? AnyShapeStyle(ColorTheme.lightBlue) : AnyShapeStyle(ColorTheme.cardGradient))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? ColorTheme.primaryBlue : Color.clear, lineWidth: 2)
                    )
            )
        }
    }
}

#Preview {
    ProgressView(appViewModel: AppViewModel())
}
