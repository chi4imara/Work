import SwiftUI

struct TodayView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingAddWorkout = false
    @State private var showingAddMeal = false
    @State private var showingAddGoal = false
    @State private var animateProgress = false
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    greetingSection
                    
                    progressStrip
                    
                    workoutSection
                    
                    nutritionSection
                    
                    goalsSection
                    
                    challengeSection
                    
                    progressSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 120)
            }
        }
        .onAppear {
            appState.updateDayProgress()
            withAnimation(.easeInOut(duration: 1.0)) {
                animateProgress = true
            }
        }
    }
    
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(appState.greetingText())
                        .font(.ubuntu(26, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Text("What's in your plan today?")
                        .font(.ubuntu(15, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                waterPill
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardBackground.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.accent.opacity(0.25), lineWidth: 1)
                )
        )
        .padding(.top, 16)
    }
    
    private var waterPill: some View {
        HStack(spacing: 6) {
            Image(systemName: "drop.fill")
                .font(.system(size: 14))
                .foregroundColor(AppColors.info)
            
            Text("\(appState.waterIntake)/\(appState.targetWaterIntake)")
                .font(.ubuntu(13, weight: .bold))
                .foregroundColor(AppColors.text)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(AppColors.info.opacity(0.2))
        )
        .onTapGesture {
            if appState.waterIntake < appState.targetWaterIntake {
                appState.waterIntake += 1
            }
        }
    }
    
    @ViewBuilder
    private var progressStrip: some View {
        if let progress = appState.getTodayProgress() {
            HStack(spacing: 12) {
                ForEach([
                    ("dumbbell", progress.workoutsCompleted > 0),
                    ("fork.knife", progress.mealsCompleted >= 3),
                    ("target", progress.goalsProgress > 0.5),
                    ("star.fill", progress.challengeCompleted)
                ], id: \.0) { item in
                    Image(systemName: item.0)
                        .font(.system(size: 14))
                        .foregroundColor(item.1 ? AppColors.success : AppColors.textSecondary.opacity(0.5))
                        .frame(width: 28, height: 28)
                }
                Spacer()
                Text("\(Int(progress.overallProgress * 100))%")
                    .font(.ubuntu(14, weight: .bold))
                    .foregroundColor(AppColors.accent)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground.opacity(0.4))
            )
        } else {
            EmptyView()
        }
    }
    
    private var workoutSection: some View {
        todaySection(
            title: "Today's Workout",
            icon: "dumbbell",
            isEmpty: todayWorkouts.isEmpty,
            emptyIcon: "dumbbell",
            emptyTitle: "No workouts planned",
            emptySubtitle: "Start with one exercise - that's already progress",
            onAdd: { showingAddWorkout = true }
        ) {
            LazyVStack(spacing: 10) {
                ForEach(todayWorkouts) { workout in
                    WorkoutCardView(workout: workout)
                }
            }
        }
        .sheet(isPresented: $showingAddWorkout) {
            AddWorkoutView()
        }
    }
    
    private var nutritionSection: some View {
        todaySection(
            title: "Nutrition",
            icon: "fork.knife",
            isEmpty: todayMeals.isEmpty,
            emptyIcon: "fork.knife",
            emptyTitle: "No meals logged",
            emptySubtitle: "Track your nutrition to reach your goals",
            onAdd: { showingAddMeal = true }
        ) {
            VStack(spacing: 12) {
                ForEach(MealType.allCases, id: \.self) { mealType in
                    if let meal = todayMeals.first(where: { $0.mealType == mealType }) {
                        MealCardView(meal: meal)
                    } else {
                        EmptyMealCardView(mealType: mealType) {
                            showingAddMeal = true
                        }
                    }
                }
                if !todayMeals.isEmpty {
                    CaloriesSummaryView(meals: todayMeals)
                }
            }
        }
        .sheet(isPresented: $showingAddMeal) {
            AddMealView()
        }
    }
    
    private var goalsSection: some View {
        todaySection(
            title: "Active Goals",
            icon: "target",
            isEmpty: appState.goals.isEmpty,
            emptyIcon: "target",
            emptyTitle: "No goals set",
            emptySubtitle: "Set a goal and start your fitness journey",
            onAdd: { showingAddGoal = true }
        ) {
            LazyVStack(spacing: 10) {
                ForEach(appState.goals.prefix(3)) { goal in
                    GoalCardView(goal: goal)
                }
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView()
        }
    }
    
    private var challengeSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "Daily Challenge", icon: "star.fill")
            
            if let challenge = todayChallenge {
                ChallengeCardView(challenge: challenge)
            } else {
                emptyStateView(
                    icon: "star.fill",
                    title: "No challenge today",
                    subtitle: "Check back tomorrow for a new challenge",
                    action: nil
                )
                .padding(.vertical, 20)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(AppColors.accent.opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    private var progressSection: some View {
        VStack(spacing: 14) {
            sectionHeader(title: "Today's Progress", icon: "chart.pie.fill")
            
            DayProgressView(progress: appState.getTodayProgress() ?? DayProgress(date: Date()))
                .scaleEffect(animateProgress ? 1.0 : 0.92)
                .opacity(animateProgress ? 1.0 : 0.0)
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: animateProgress)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(AppColors.accent.opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppColors.accent)
                .frame(width: 32, height: 32)
                .background(Circle().fill(AppColors.accent.opacity(0.15)))
            
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(AppColors.text)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func todaySection<Content: View>(
        title: String,
        icon: String,
        isEmpty: Bool,
        emptyIcon: String,
        emptyTitle: String,
        emptySubtitle: String,
        onAdd: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                sectionHeader(title: title, icon: icon)
                
                Spacer()
                
                Button(action: onAdd) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(AppColors.accentGradient)
                }
            }
            
            if isEmpty {
                emptyStateView(
                    icon: emptyIcon,
                    title: emptyTitle,
                    subtitle: emptySubtitle,
                    action: onAdd
                )
                .padding(.vertical, 20)
            } else {
                content()
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(AppColors.accent.opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    private func emptyStateView(icon: String, title: String, subtitle: String, action: (() -> Void)?) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundColor(AppColors.textSecondary.opacity(0.8))
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.text)
                
                Text(subtitle)
                    .font(.ubuntu(13, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let action = action {
                Button(action: action) {
                    Text("Add Now")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.accent)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var todayWorkouts: [Workout] {
        appState.workouts.filter { Calendar.current.isDate($0.date, inSameDayAs: Date()) }
    }
    
    private var todayMeals: [Meal] {
        appState.meals.filter { Calendar.current.isDate($0.date, inSameDayAs: Date()) }
    }
    
    private var todayChallenge: Challenge? {
        appState.dailyChallenges.first { Calendar.current.isDate($0.date, inSameDayAs: Date()) }
    }
}

#Preview {
    TodayView()
        .environmentObject(AppState())
}
