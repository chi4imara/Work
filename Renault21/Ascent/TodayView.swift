import SwiftUI

struct TodayView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var viewModel = TodayViewModel()
    @State private var showingAddWorkout = false
    @State private var showingAddNutrition = false
    @State private var showingAddTask = false
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                greetingSection
                
                dailyProgressSection
                
                workoutSection
                
                nutritionSection
                
                productivitySection
                
                dailyChallengeSection
                
                waterIntakeSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
        .primaryBackground()
        .sheet(isPresented: $showingAddWorkout) {
            AddWorkoutView { workout in
                dataManager.addWorkout(workout)
            }
        }
        .sheet(isPresented: $showingAddNutrition) {
            AddNutritionView { nutrition in
                dataManager.addNutrition(nutrition)
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView { task in
                dataManager.addTask(task)
            }
        }
        .onAppear {
            dataManager.refreshTodayProgress(challengesCompleted: viewModel.dailyProgress.challengesCompleted, waterIntake: viewModel.waterIntake)
        }
    }
    
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.greetingText)
                        .font(FontManager.playfairBold(size: 28))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("What's in your plan today?")
                        .font(FontManager.playfairRegular(size: 16))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                
                Spacer()
                
                VStack {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 20))
                        .foregroundColor(ColorTheme.primaryAccent)
                    
                    Text("7")
                        .font(FontManager.playfairBold(size: 16))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("days")
                        .font(FontManager.playfairRegular(size: 12))
                        .foregroundColor(ColorTheme.secondaryText)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .cardBackground()
                .cornerRadius(16)
            }
        }
        .padding(.top, 20)
    }
    
    private var dailyProgressSection: some View {
        let progress = dataManager.getDailyProgress(for: Date()) ?? DailyProgress(date: Date())
        return VStack(spacing: 16) {
            Text("Daily Progress")
                .font(FontManager.playfairSemiBold(size: 20))
                .foregroundColor(ColorTheme.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            ZStack {
                Circle()
                    .stroke(ColorTheme.primaryAccent.opacity(0.2), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: progress.totalProgress)
                    .stroke(ColorTheme.accentGradient, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: progress.totalProgress)
                
                VStack {
                    Text("\(Int(progress.totalProgress * 100))%")
                        .font(FontManager.playfairBold(size: 24))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text("Complete")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .cardBackground()
        .cornerRadius(20)
    }
    
    private var workoutSection: some View {
        SectionView(
            title: "Today's Workout",
            icon: "dumbbell.fill",
            showAddButton: true,
            onAddTapped: { showingAddWorkout = true }
        ) {
            if dataManager.workouts.isEmpty {
                EmptyStateView(
                    icon: "figure.strengthtraining.functional",
                    title: "No workouts planned",
                    subtitle: "Add your first workout to start your fitness journey"
                )
            } else {
                    ForEach(dataManager.workouts.prefix(3)) { workout in
                        WorkoutCardView(workout: workout) {
                            var updatedWorkout = workout
                            updatedWorkout.isCompleted.toggle()
                            updatedWorkout.completedDate = updatedWorkout.isCompleted ? Date() : nil
                            dataManager.updateWorkout(updatedWorkout)
                            dataManager.refreshTodayProgress(challengesCompleted: viewModel.dailyProgress.challengesCompleted, waterIntake: viewModel.waterIntake)
                        }
                    }
            }
        }
    }
    
    private var nutritionSection: some View {
        SectionView(
            title: "Nutrition",
            icon: "leaf.fill",
            showAddButton: true,
            onAddTapped: { showingAddNutrition = true }
        ) {
            if dataManager.nutritionItems.isEmpty {
                EmptyStateView(
                    icon: "fork.knife",
                    title: "No meals planned",
                    subtitle: "Track your nutrition to fuel your goals"
                )
            } else {
                    ForEach(dataManager.nutritionItems.prefix(3)) { nutrition in
                        NutritionCardView(nutrition: nutrition) {
                            var updatedNutrition = nutrition
                            updatedNutrition.isCompleted.toggle()
                            updatedNutrition.completedDate = updatedNutrition.isCompleted ? Date() : nil
                            dataManager.updateNutrition(updatedNutrition)
                            dataManager.refreshTodayProgress(challengesCompleted: viewModel.dailyProgress.challengesCompleted, waterIntake: viewModel.waterIntake)
                        }
                    }
            }
        }
    }
    
    private var productivitySection: some View {
        SectionView(
            title: "Productivity",
            icon: "checkmark.circle.fill",
            showAddButton: true,
            onAddTapped: { showingAddTask = true }
        ) {
            if dataManager.tasks.isEmpty {
                EmptyStateView(
                    icon: "list.bullet.clipboard",
                    title: "No tasks added",
                    subtitle: "Add tasks to boost your productivity"
                )
            } else {
                    ForEach(dataManager.tasks.prefix(3)) { task in
                        TaskCardView(task: task) {
                            var updatedTask = task
                            updatedTask.isCompleted.toggle()
                            updatedTask.completedDate = updatedTask.isCompleted ? Date() : nil
                            dataManager.updateTask(updatedTask)
                            dataManager.refreshTodayProgress(challengesCompleted: viewModel.dailyProgress.challengesCompleted, waterIntake: viewModel.waterIntake)
                        }
                    }
            }
        }
    }
    
    private var dailyChallengeSection: some View {
        SectionView(
            title: "Daily Challenge",
            icon: "trophy.fill",
            showAddButton: false
        ) {
            if let challenge = viewModel.dailyChallenge {
                ChallengeCardView(challenge: challenge) {
                    viewModel.completeDailyChallenge()
                }
            } else {
                EmptyStateView(
                    icon: "target",
                    title: "No challenge today",
                    subtitle: "Check back tomorrow for a new challenge"
                )
            }
        }
    }
    
    private var waterIntakeSection: some View {
        SectionView(
            title: "Water Intake",
            icon: "drop.fill",
            showAddButton: false
        ) {
            WaterIntakeCardView(waterIntake: viewModel.waterIntake) { amount in
                viewModel.addWater(amount: amount)
            }
        }
    }
}

struct SectionView<Content: View>: View {
    let title: String
    let icon: String
    let showAddButton: Bool
    let onAddTapped: (() -> Void)?
    @ViewBuilder let content: Content
    
    init(
        title: String,
        icon: String,
        showAddButton: Bool = false,
        onAddTapped: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.showAddButton = showAddButton
        self.onAddTapped = onAddTapped
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryAccent)
                    
                    Text(title)
                        .font(FontManager.playfairSemiBold(size: 18))
                        .foregroundColor(ColorTheme.primaryText)
                }
                
                Spacer()
                
                if showAddButton {
                    Button(action: { onAddTapped?() }) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(ColorTheme.primaryAccent)
                            .frame(width: 32, height: 32)
                            .background(ColorTheme.primaryAccent.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            
            content
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .cardBackground()
        .cornerRadius(20)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(ColorTheme.primaryAccent.opacity(0.6))
            
            Text(title)
                .font(FontManager.playfairMedium(size: 16))
                .foregroundColor(ColorTheme.primaryText)
            
            Text(subtitle)
                .font(FontManager.playfairRegular(size: 14))
                .foregroundColor(ColorTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    TodayView()
}
