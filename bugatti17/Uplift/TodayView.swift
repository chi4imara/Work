import SwiftUI

struct TodayView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var showingAddHabit = false
    @State private var showingAddChallenge = false
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            ScrollView {
                LazyVStack(spacing: DesignConstants.Spacing.lg) {
                    GreetingSection()
                    
                    MoodSelectionSection(appViewModel: appViewModel)
                    
                    MiniChallengesSection(
                        appViewModel: appViewModel,
                        showingAddChallenge: $showingAddChallenge
                    )
                    
                    HabitsSection(
                        appViewModel: appViewModel,
                        showingAddHabit: $showingAddHabit
                    )
                    
                    DailyQuestionSection(appViewModel: appViewModel)
                    
                    ProgressSection(appViewModel: appViewModel)
                }
                .padding(.horizontal, DesignConstants.Spacing.md)
                .padding(.top, DesignConstants.Spacing.md)
                .padding(.bottom, 120)
            }
        }
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView { habit in
                appViewModel.addHabit(habit)
            }
        }
        .sheet(isPresented: $showingAddChallenge) {
            AddChallengeView { challenge in
                appViewModel.addChallenge(challenge)
            }
        }
    }
}

struct GreetingSection: View {
    @State private var animateGreeting = false
    
    var body: some View {
        VStack(spacing: DesignConstants.Spacing.sm) {
            Text(getGreeting())
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(DesignConstants.Colors.white)
                .scaleEffect(animateGreeting ? 1.0 : 0.8)
                .opacity(animateGreeting ? 1.0 : 0.0)
            
            Text("How are you feeling today?")
                .font(.ubuntu(18))
                .foregroundColor(DesignConstants.Colors.white.opacity(0.8))
                .opacity(animateGreeting ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateGreeting = true
            }
        }
    }
    
    private func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<17:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
}

struct MoodSelectionSection: View {
    @ObservedObject var appViewModel: AppViewModel
    
    private var selectedMoods: [String] {
        appViewModel.appState.todayEntry.selectedMoods
    }
    
    private var showThankYouMessage: Bool {
        !selectedMoods.isEmpty
    }
    
    private func isMoodSelected(_ moodId: String) -> Bool {
        selectedMoods.contains(moodId)
    }
    
    private func toggleMood(_ moodId: String) {
        var next = selectedMoods
        if next.contains(moodId) {
            next.removeAll { $0 == moodId }
        } else if next.count < 3 {
            next.append(moodId)
        }
        appViewModel.setTodayMoods(next)
    }
    
    var body: some View {
        CardView {
            VStack(spacing: DesignConstants.Spacing.md) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: DesignConstants.Spacing.sm) {
                    ForEach(AppConstants.moodOptions, id: \.id) { mood in
                        MoodOptionView(
                            mood: mood,
                            isSelected: isMoodSelected(mood.id)
                        ) {
                            toggleMood(mood.id)
                        }
                    }
                }
                
                if showThankYouMessage {
                    Text("Thank you for sharing!")
                        .font(.ubuntu(14))
                        .foregroundColor(DesignConstants.Colors.primaryYellow)
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
    }
}

struct MoodOptionView: View {
    let mood: MoodOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: mood.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? DesignConstants.Colors.primaryBlue : DesignConstants.Colors.white)
                
                Text(mood.name)
                    .font(.ubuntu(12))
                    .foregroundColor(isSelected ? DesignConstants.Colors.primaryBlue : DesignConstants.Colors.white.opacity(0.7))
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.medium)
                    .fill(isSelected ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.1))
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
}

struct MiniChallengesSection: View {
    @ObservedObject var appViewModel: AppViewModel
    @Binding var showingAddChallenge: Bool
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: DesignConstants.Spacing.md) {
                HStack {
                    Text("Today's Mini Challenges")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(DesignConstants.Colors.white)
                    
                    Spacer()
                    
                    Button(action: { showingAddChallenge = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(DesignConstants.Colors.primaryYellow)
                    }
                }
                
                if appViewModel.appState.miniChallenges.isEmpty {
                    EmptyStateView(
                        icon: "target",
                        title: "No challenges yet",
                        description: "Add your first mini challenge to get started!"
                    )
                } else {
                    ForEach(appViewModel.appState.miniChallenges) { challenge in
                        ChallengeItemView(challenge: challenge) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                appViewModel.toggleChallengeCompletion(challenge.id)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ChallengeItemView: View {
    let challenge: MiniChallenge
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: DesignConstants.Spacing.md) {
            Button(action: onToggle) {
                Image(systemName: challenge.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(challenge.isCompleted ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.5))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(challenge.title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(DesignConstants.Colors.white)
                    .strikethrough(challenge.isCompleted)
                
                Text(challenge.description)
                    .font(.ubuntu(14))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.7))
            }
            
            Spacer()
            
            if challenge.isCompleted {
                Text("Done!")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(DesignConstants.Colors.primaryYellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(DesignConstants.Colors.primaryYellow.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
        .scaleEffect(challenge.isCompleted ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: challenge.isCompleted)
    }
}

struct HabitsSection: View {
    @ObservedObject var appViewModel: AppViewModel
    @Binding var showingAddHabit: Bool
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: DesignConstants.Spacing.md) {
                HStack {
                    Text("My Habits")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(DesignConstants.Colors.white)
                    
                    Spacer()
                    
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(DesignConstants.Colors.primaryYellow)
                    }
                }
                
                if appViewModel.appState.habits.isEmpty {
                    EmptyStateView(
                        icon: "checkmark.circle",
                        title: "No habits yet",
                        description: "Add your first habit and start taking care of yourself!"
                    )
                } else {
                    ForEach(appViewModel.appState.habits) { habit in
                        HabitItemView(habit: habit) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                appViewModel.toggleHabitCompletion(habit.id)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct HabitItemView: View {
    let habit: Habit
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: DesignConstants.Spacing.md) {
            Button(action: onToggle) {
                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(habit.isCompleted ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.5))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(DesignConstants.Colors.white)
                    .strikethrough(habit.isCompleted)
                
                HStack {
                    Text(habit.frequency.displayName)
                        .font(.ubuntu(12))
                        .foregroundColor(DesignConstants.Colors.white.opacity(0.6))
                    
                    if habit.currentStreak > 0 {
                        Text("• \(habit.currentStreak) day streak")
                            .font(.ubuntu(12))
                            .foregroundColor(DesignConstants.Colors.primaryYellow)
                    }
                }
            }
            
            Spacer()
            
            if habit.isCompleted {
                Text("Done!")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(DesignConstants.Colors.primaryYellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(DesignConstants.Colors.primaryYellow.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
        .scaleEffect(habit.isCompleted ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: habit.isCompleted)
    }
}

struct DailyQuestionSection: View {
    @ObservedObject var appViewModel: AppViewModel
    
    private var dailyQuestion: String {
        appViewModel.appState.todayEntry.dailyQuestion.isEmpty
            ? appViewModel.getDailyQuestion()
            : appViewModel.appState.todayEntry.dailyQuestion
    }
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: DesignConstants.Spacing.md) {
                Text("Question of the Day")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(DesignConstants.Colors.white)
                
                Text(dailyQuestion)
                    .font(.ubuntu(16))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.8))
                
                TextField("Your answer...", text: Binding(
                    get: { appViewModel.appState.todayEntry.dailyQuestionAnswer },
                    set: { appViewModel.setTodayDailyQuestionAnswer($0) }
                ), axis: .vertical)
                    .font(.ubuntu(16))
                    .foregroundColor(DesignConstants.Colors.white)
                    .padding()
                    .background(DesignConstants.Colors.white.opacity(0.1))
                    .cornerRadius(DesignConstants.CornerRadius.medium)
                    .lineLimit(3...6)
            }
        }
    }
}

struct ProgressSection: View {
    @ObservedObject var appViewModel: AppViewModel
    
    private func calculateProgress() -> Double {
        let totalTasks = appViewModel.appState.habits.count + appViewModel.appState.miniChallenges.count
        guard totalTasks > 0 else { return 0 }
        let completedHabits = appViewModel.appState.habits.filter { $0.isCompleted }.count
        let completedChallenges = appViewModel.appState.miniChallenges.filter { $0.isCompleted }.count
        return Double(completedHabits + completedChallenges) / Double(totalTasks)
    }
    
    var body: some View {
        CardView {
            VStack(spacing: DesignConstants.Spacing.md) {
                Text("Today's Progress")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(DesignConstants.Colors.white)
                
                ProgressRingView(progress: calculateProgress())
                
                if calculateProgress() >= 1.0 {
                    VStack(spacing: 8) {
                        Text("🎉")
                            .font(.system(size: 32))
                        
                        Text("Amazing! You completed everything today!")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(DesignConstants.Colors.primaryYellow)
                            .multilineTextAlignment(.center)
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }
}

struct ProgressRingView: View {
    let progress: Double
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(DesignConstants.Colors.white.opacity(0.2), lineWidth: 8)
                .frame(width: 120, height: 120)
            
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            DesignConstants.Colors.primaryYellow,
                            DesignConstants.Colors.lightGreen
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(animatedProgress * 100))%")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(DesignConstants.Colors.white)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newProgress in
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedProgress = newProgress
            }
        }
    }
}

struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(DesignConstants.Spacing.lg)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.large)
                    .fill(DesignConstants.Colors.white.opacity(0.1))
                    .background(
                        RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.large)
                            .stroke(DesignConstants.Colors.white.opacity(0.2), lineWidth: 1)
                    )
            )
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: DesignConstants.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(DesignConstants.Colors.white.opacity(0.5))
            
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(DesignConstants.Colors.white.opacity(0.7))
            
            Text(description)
                .font(.ubuntu(14))
                .foregroundColor(DesignConstants.Colors.white.opacity(0.5))
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, DesignConstants.Spacing.lg)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    TodayView()
        .environmentObject(AppViewModel())
}
