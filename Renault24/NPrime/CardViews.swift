import SwiftUI

struct WorkoutCardView: View {
    @EnvironmentObject var appState: AppState
    let workout: Workout
    @State private var showingDetail = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: workout.category.icon)
                .font(.title2)
                .foregroundColor(AppColors.secondary)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.text)
                
                Text("\(workout.duration) min • \(workout.exercises.count) exercises")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring()) {
                    appState.toggleWorkoutCompletion(workout)
                }
            }) {
                Image(systemName: workout.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(workout.isCompleted ? AppColors.success : AppColors.textSecondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.cardBackground.opacity(0.5))
        .cornerRadius(AppStyles.smallCornerRadius)
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            WorkoutDetailView(workoutId: workout.id)
        }
    }
}

struct MealCardView: View {
    @EnvironmentObject var appState: AppState
    let meal: Meal
    @State private var showingDetail = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: meal.mealType.icon)
                .font(.title2)
                .foregroundColor(AppColors.secondary)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.text)
                
                Text("\(meal.calories) cal • P: \(Int(meal.protein))g C: \(Int(meal.carbs))g F: \(Int(meal.fat))g")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring()) {
                    appState.toggleMealCompletion(meal)
                }
            }) {
                Image(systemName: meal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(meal.isCompleted ? AppColors.success : AppColors.textSecondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.cardBackground.opacity(0.5))
        .cornerRadius(AppStyles.smallCornerRadius)
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            MealDetailView(mealId: meal.id)
        }
    }
}

struct EmptyMealCardView: View {
    let mealType: MealType
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: mealType.icon)
                .font(.title2)
                .foregroundColor(AppColors.textSecondary)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(mealType.rawValue)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                Text("Not logged")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary.opacity(0.7))
            }
            
            Spacer()
            
            Button(action: action) {
                Image(systemName: "plus.circle")
                    .font(.title2)
                    .foregroundColor(AppColors.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.cardBackground.opacity(0.3))
        .cornerRadius(AppStyles.smallCornerRadius)
    }
}

struct GoalCardView: View {
    let goal: Goal
    @State private var showingDetail = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: goal.category.icon)
                .font(.title2)
                .foregroundColor(AppColors.secondary)
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.text)
                
                Text("\(Int(goal.currentValue))/\(Int(goal.targetValue)) \(goal.unit)")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            CircularProgressView(
                progress: goal.currentValue / goal.targetValue,
                size: 32,
                lineWidth: 3
            )
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.cardBackground.opacity(0.5))
        .cornerRadius(AppStyles.smallCornerRadius)
        .onTapGesture {
            showingDetail = true
        }
        .sheet(isPresented: $showingDetail) {
            GoalDetailView(goalId: goal.id)
        }
    }
}

struct ChallengeCardView: View {
    @EnvironmentObject var appState: AppState
    let challenge: Challenge
    @State private var showingProgressUpdate = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.title)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Text(challenge.description)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                if challenge.isCompleted {
                    Image(systemName: "star.fill")
                        .font(.title)
                        .foregroundColor(AppColors.warning)
                }
            }
            
            ProgressView(value: challenge.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: AppColors.secondary))
                .scaleEffect(x: 1, y: 2, anchor: .center)
            
            HStack {
                Text("\(challenge.currentValue)/\(challenge.targetValue)")
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                
                Spacer()
                
                if !challenge.isCompleted {
                    Button(action: {
                        showingProgressUpdate = true
                    }) {
                        Text("Update Progress")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(AppColors.secondary)
                    }
                }
            }
            
            if !challenge.isCompleted {
                Button(action: {
                    withAnimation(.spring()) {
                        appState.completeDailyChallenge()
                    }
                }) {
                    Text("I Did It!")
                        .frame(maxWidth: .infinity)
                        .secondaryButtonStyle()
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .background(AppColors.cardBackground.opacity(0.5))
        .cornerRadius(AppStyles.smallCornerRadius)
        .alert("Update Progress", isPresented: $showingProgressUpdate) {
            Button("Cancel") { }
            Button("Complete") {
                appState.completeDailyChallenge()
            }
        } message: {
            Text("Mark this challenge as completed?")
        }
    }
}

struct CaloriesSummaryView: View {
    let meals: [Meal]
    
    private var totalCalories: Int {
        meals.reduce(0) { $0 + $1.calories }
    }
    
    private var totalProtein: Double {
        meals.reduce(0) { $0 + $1.protein }
    }
    
    private var totalCarbs: Double {
        meals.reduce(0) { $0 + $1.carbs }
    }
    
    private var totalFat: Double {
        meals.reduce(0) { $0 + $1.fat }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Daily Totals")
                .font(.ubuntu(14, weight: .bold))
                .foregroundColor(AppColors.text)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 20) {
                MacroView(title: "Calories", value: "\(totalCalories)", color: AppColors.secondary)
                MacroView(title: "Protein", value: "\(Int(totalProtein))g", color: AppColors.success)
                MacroView(title: "Carbs", value: "\(Int(totalCarbs))g", color: AppColors.warning)
                MacroView(title: "Fat", value: "\(Int(totalFat))g", color: AppColors.error)
            }
        }
        .padding(.top, 8)
    }
}

struct MacroView: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(color)
            
            Text(title)
                .font(.ubuntu(10, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DayProgressView: View {
    let progress: DayProgress
    @State private var animateProgress = false
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(AppColors.textSecondary.opacity(0.3), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: animateProgress ? progress.overallProgress : 0)
                    .stroke(
                        LinearGradient(
                            colors: [AppColors.secondary, AppColors.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.5), value: animateProgress)
                    .animation(.easeInOut(duration: 0.5), value: progress.overallProgress)
                
                VStack(spacing: 2) {
                    Text("\(Int(progress.overallProgress * 100))%")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Text("Complete")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            HStack(spacing: 20) {
                ProgressItemView(
                    icon: "dumbbell",
                    title: "Workouts",
                    value: progress.workoutsCompleted,
                    isCompleted: progress.workoutsCompleted > 0
                )
                
                ProgressItemView(
                    icon: "fork.knife",
                    title: "Meals",
                    value: progress.mealsCompleted,
                    isCompleted: progress.mealsCompleted >= 3
                )
                
                ProgressItemView(
                    icon: "target",
                    title: "Goals",
                    value: Int(progress.goalsProgress * 100),
                    isCompleted: progress.goalsProgress > 0.5,
                    suffix: "%"
                )
                
                ProgressItemView(
                    icon: "star.fill",
                    title: "Challenge",
                    value: progress.challengeCompleted ? 1 : 0,
                    isCompleted: progress.challengeCompleted
                )
            }
            
            if progress.overallProgress >= 1.0 {
                Text("🎉 You're super in shape!")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(AppColors.success)
                    .multilineTextAlignment(.center)
            } else if progress.overallProgress > 0 {
                Text("You're on your way to your goal!")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).delay(0.2)) {
                animateProgress = true
            }
        }
    }
}

struct ProgressItemView: View {
    let icon: String
    let title: String
    let value: Int
    let isCompleted: Bool
    let suffix: String
    
    init(icon: String, title: String, value: Int, isCompleted: Bool, suffix: String = "") {
        self.icon = icon
        self.title = title
        self.value = value
        self.isCompleted = isCompleted
        self.suffix = suffix
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(isCompleted ? AppColors.success : AppColors.textSecondary)
            
            Text("\(value)\(suffix)")
                .font(.ubuntu(12, weight: .bold))
                .foregroundColor(AppColors.text)
            
            Text(title)
                .font(.ubuntu(8, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CircularProgressView: View {
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat
    @State private var animateProgress = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.textSecondary.opacity(0.3), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            Circle()
                .trim(from: 0, to: animateProgress ? min(progress, 1.0) : 0)
                .stroke(AppColors.secondary, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: animateProgress)
        }
        .onAppear {
            animateProgress = true
        }
    }
}
