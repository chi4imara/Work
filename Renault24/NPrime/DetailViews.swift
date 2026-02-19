import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    let workoutId: UUID
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false
    
    private var workout: Workout? { appState.workout(byId: workoutId) }
    
    var body: some View {
        if let workout = workout {
            workoutDetailContent(workout: workout)
        } else {
            NavigationView {
                ZStack {
                    AppColors.background.ignoresSafeArea()
                    VStack(spacing: 16) {
                        Text("Workout not found")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        Button("Done") { presentationMode.wrappedValue.dismiss() }
                            .foregroundColor(AppColors.secondary)
                    }
                }
                .navigationTitle("Workout Details")
                .navigationBarTitleDisplayMode(.inline)
                .preferredColorScheme(.dark)
            }
        }
    }
    
    private func workoutDetailContent(workout: Workout) -> some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        workoutHeaderCard(workout: workout)
                        
                        if !workout.exercises.isEmpty {
                            exercisesSection(workout: workout)
                        }
                        
                        if !workout.notes.isEmpty {
                            notesSection(workout: workout)
                        }
                        
                        actionsSection(workout: workout)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Workout Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingEdit) {
                EditWorkoutView(workoutId: workoutId)
            }
            .alert("Delete Workout", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    appState.deleteWorkout(workout)
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this workout? This action cannot be undone.")
            }
        }
    }
    
    private func workoutHeaderCard(workout: Workout) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .fill(AppColors.accent.opacity(0.2))
                        .frame(width: 52, height: 52)
                    Image(systemName: workout.category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.accent)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(workout.name)
                        .font(.ubuntu(22, weight: .bold))
                        .foregroundColor(AppColors.text)
                    Text(workout.category.rawValue)
                        .font(.ubuntu(15, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                        Text("\(workout.duration) min")
                        Text("•")
                        Text("\(workout.exercises.count) exercises")
                    }
                    .font(.ubuntu(13, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Button(action: {
                    var updated = workout
                    updated.isFavorite.toggle()
                    appState.updateWorkout(updated)
                }) {
                    Image(systemName: workout.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 22))
                        .foregroundColor(workout.isFavorite ? AppColors.error : AppColors.textSecondary)
                }
            }
            
            if workout.isCompleted {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppColors.success)
                    Text("Completed")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.success)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.accent.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func exercisesSection(workout: Workout) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "list.bullet")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(AppColors.accent.opacity(0.15)))
                Text("Exercises")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.text)
            }
            
            VStack(spacing: 10) {
                ForEach(Array(workout.exercises.enumerated()), id: \.element.id) { index, exercise in
                    HStack(spacing: 14) {
                        Text("\(index + 1)")
                            .font(.ubuntu(14, weight: .bold))
                            .foregroundColor(AppColors.accent)
                            .frame(width: 28, height: 28)
                            .background(Circle().fill(AppColors.accent.opacity(0.15)))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(exercise.name)
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(AppColors.text)
                            HStack(spacing: 12) {
                                Text("\(exercise.sets) sets")
                                Text("\(exercise.reps) reps")
                                if let w = exercise.weight {
                                    Text("\(Int(w)) kg")
                                }
                            }
                            .font(.ubuntu(13, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: exercise.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundColor(exercise.isCompleted ? AppColors.success : AppColors.textSecondary.opacity(0.6))
                    }
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.cardBackground.opacity(0.4))
                    )
                }
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
    
    private func notesSection(workout: Workout) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "note.text")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(AppColors.accent.opacity(0.15)))
                Text("Notes")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.text)
            }
            Text(workout.notes)
                .font(.ubuntu(15, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private func actionsSection(workout: Workout) -> some View {
        VStack(spacing: 12) {
            if !workout.isCompleted {
                Button(action: {
                    appState.toggleWorkoutCompletion(workout)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Mark as Completed")
                    }
                    .frame(maxWidth: .infinity)
                    .primaryButtonStyle()
                }
            }
            
            Button(action: { showingEdit = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                    Text("Edit Workout")
                }
                .frame(maxWidth: .infinity)
                .secondaryButtonStyle()
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                    Text("Delete Workout")
                }
                .frame(maxWidth: .infinity)
                .frame(height: AppStyles.buttonHeight)
                .background(AppColors.error.opacity(0.15))
                .foregroundColor(AppColors.error)
                .cornerRadius(AppStyles.cornerRadius)
                .font(.ubuntu(16, weight: .medium))
            }
        }
    }
}

struct ExerciseDetailView: View {
    @State var exercise: Exercise
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.text)
                
                HStack(spacing: 16) {
                    Text("\(exercise.sets) sets")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("\(exercise.reps) reps")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    
                    if let weight = exercise.weight {
                        Text("\(Int(weight))kg")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                exercise.isCompleted.toggle()
            }) {
                Image(systemName: exercise.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(exercise.isCompleted ? AppColors.success : AppColors.textSecondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.cardBackground.opacity(0.3))
        .cornerRadius(AppStyles.smallCornerRadius)
    }
}

struct MealDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    let mealId: UUID
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false
    
    private var meal: Meal? { appState.meal(byId: mealId) }
    
    var body: some View {
        if let meal = meal {
            mealDetailContent(meal: meal)
        } else {
            NavigationView {
                ZStack {
                    AppColors.background.ignoresSafeArea()
                    VStack(spacing: 16) {
                        Text("Meal not found")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        Button("Done") { presentationMode.wrappedValue.dismiss() }
                            .foregroundColor(AppColors.secondary)
                    }
                }
                .navigationTitle("Meal Details")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    private func mealDetailContent(meal: Meal) -> some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        mealHeaderCard(meal: meal)
                        mealNutritionSection(meal: meal)
                        if !meal.notes.isEmpty {
                            notesSection(notes: meal.notes)
                        }
                        mealActionsSection(meal: meal)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Meal Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingEdit) {
                EditMealView(mealId: mealId)
            }
            .alert("Delete Meal", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    appState.deleteMeal(meal)
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this meal? This action cannot be undone.")
            }
        }
    }
    
    private func mealHeaderCard(meal: Meal) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .fill(AppColors.accent.opacity(0.2))
                        .frame(width: 52, height: 52)
                    Image(systemName: meal.mealType.icon)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.accent)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(meal.name)
                        .font(.ubuntu(22, weight: .bold))
                        .foregroundColor(AppColors.text)
                    Text(meal.mealType.rawValue)
                        .font(.ubuntu(15, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                        Text("\(meal.calories) cal")
                        Text("•")
                        Text("P: \(Int(meal.protein)) C: \(Int(meal.carbs)) F: \(Int(meal.fat)) g")
                    }
                    .font(.ubuntu(13, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
            }
            
            if meal.isCompleted {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppColors.success)
                    Text("Completed")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.success)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.accent.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func mealNutritionSection(meal: Meal) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "chart.pie.fill")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(AppColors.accent.opacity(0.15)))
                Text("Nutrition")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.text)
            }
            
            VStack(spacing: 10) {
                NutritionRowView(title: "Calories", value: "\(meal.calories)", unit: "cal", color: AppColors.accent)
                NutritionRowView(title: "Protein", value: "\(Int(meal.protein))", unit: "g", color: AppColors.success)
                NutritionRowView(title: "Carbohydrates", value: "\(Int(meal.carbs))", unit: "g", color: AppColors.warning)
                NutritionRowView(title: "Fat", value: "\(Int(meal.fat))", unit: "g", color: AppColors.error)
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
    
    private func notesSection(notes: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "note.text")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(AppColors.accent.opacity(0.15)))
                Text("Notes")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.text)
            }
            Text(notes)
                .font(.ubuntu(15, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private func mealActionsSection(meal: Meal) -> some View {
        VStack(spacing: 12) {
            if !meal.isCompleted {
                Button(action: {
                    appState.toggleMealCompletion(meal)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Mark as Completed")
                    }
                    .frame(maxWidth: .infinity)
                    .primaryButtonStyle()
                }
            }
            Button(action: { showingEdit = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                    Text("Edit Meal")
                }
                .frame(maxWidth: .infinity)
                .secondaryButtonStyle()
            }
            Button(action: { showingDeleteAlert = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                    Text("Delete Meal")
                }
                .frame(maxWidth: .infinity)
                .frame(height: AppStyles.buttonHeight)
                .background(AppColors.error.opacity(0.15))
                .foregroundColor(AppColors.error)
                .cornerRadius(AppStyles.cornerRadius)
                .font(.ubuntu(16, weight: .medium))
            }
        }
    }
}

struct GoalDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    let goalId: UUID
    @State private var showingEdit = false
    @State private var showingDeleteAlert = false
    @State private var showingProgressUpdate = false
    @State private var newProgressValue = ""
    
    private var goal: Goal? { appState.goal(byId: goalId) }
    
    var body: some View {
        if let goal = goal {
            goalDetailContent(goal: goal)
        } else {
            NavigationView {
                ZStack {
                    AppColors.background.ignoresSafeArea()
                    VStack(spacing: 16) {
                        Text("Goal not found")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                        Button("Done") { presentationMode.wrappedValue.dismiss() }
                            .foregroundColor(AppColors.secondary)
                    }
                }
                .navigationTitle("Goal Details")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
    
    private func goalDetailContent(goal: Goal) -> some View {
        let progressValue = goal.targetValue > 0 ? goal.currentValue / goal.targetValue : 0
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: goal.deadline).day ?? 0
        
        return NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        goalHeaderCard(goal: goal)
                        goalProgressSection(goal: goal, progressValue: progressValue)
                        goalDeadlineSection(goal: goal, daysLeft: daysLeft)
                        if !goal.notes.isEmpty {
                            goalNotesSection(notes: goal.notes)
                        }
                        goalActionsSection(goal: goal)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Goal Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                }
            }
            .preferredColorScheme(.dark)
            .sheet(isPresented: $showingEdit) {
                EditGoalView(goalId: goalId)
            }
            .alert("Update Progress", isPresented: $showingProgressUpdate) {
                TextField("New value", text: $newProgressValue)
                    .keyboardType(.decimalPad)
                Button("Cancel", role: .cancel) {
                    newProgressValue = ""
                }
                Button("Update") {
                    if let value = Double(newProgressValue), let g = appState.goal(byId: goalId) {
                        var updatedGoal = g
                        updatedGoal.currentValue = min(value, g.targetValue)
                        appState.updateGoal(updatedGoal)
                    }
                    newProgressValue = ""
                }
            } message: {
                Text("Enter your current progress value:")
            }
            .alert("Delete Goal", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    appState.deleteGoal(goal)
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this goal? This action cannot be undone.")
            }
        }
    }
    
    private func goalHeaderCard(goal: Goal) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .fill(AppColors.accent.opacity(0.2))
                        .frame(width: 52, height: 52)
                    Image(systemName: goal.category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.accent)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(goal.title)
                        .font(.ubuntu(22, weight: .bold))
                        .foregroundColor(AppColors.text)
                    Text(goal.category.rawValue)
                        .font(.ubuntu(15, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                    HStack(spacing: 4) {
                        Image(systemName: "target")
                            .font(.system(size: 12))
                        Text("\(Int(goal.currentValue))/\(Int(goal.targetValue)) \(goal.unit)")
                        Text("•")
                        Text("\(Int((goal.targetValue > 0 ? goal.currentValue / goal.targetValue : 0) * 100))%")
                    }
                    .font(.ubuntu(13, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                Button(action: {
                    var updatedGoal = goal
                    updatedGoal.isFavorite.toggle()
                    appState.updateGoal(updatedGoal)
                }) {
                    Image(systemName: goal.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 22))
                        .foregroundColor(goal.isFavorite ? AppColors.error : AppColors.textSecondary)
                }
            }
            
            if !goal.description.isEmpty {
                Text(goal.description)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            if goal.currentValue >= goal.targetValue && goal.targetValue > 0 {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppColors.success)
                    Text("Completed")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.success)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColors.accent.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func goalProgressSection(goal: Goal, progressValue: Double) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(AppColors.accent.opacity(0.15)))
                Text("Progress")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.text)
            }
            
            VStack(spacing: 16) {
                ZStack {
                    CircularProgressView(progress: progressValue, size: 120, lineWidth: 12)
                    VStack(spacing: 2) {
                        Text("\(Int(progressValue * 100))%")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(AppColors.text)
                        Text("complete")
                            .font(.ubuntu(11, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                Text("\(Int(goal.currentValue))/\(Int(goal.targetValue)) \(goal.unit)")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(AppColors.text)
                Button(action: { showingProgressUpdate = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                        Text("Update Progress")
                    }
                    .frame(maxWidth: .infinity)
                    .secondaryButtonStyle()
                }
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
    
    private func goalDeadlineSection(goal: Goal, daysLeft: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "calendar")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(AppColors.accent.opacity(0.15)))
                Text("Deadline")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.text)
            }
            HStack {
                Text(goal.deadline, style: .date)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
                Text("\(daysLeft) days left")
                    .font(.ubuntu(14, weight: .semibold))
                    .foregroundColor(daysLeft > 0 ? AppColors.success : AppColors.error)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground.opacity(0.4))
            )
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
    
    private func goalNotesSection(notes: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "note.text")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(AppColors.accent.opacity(0.15)))
                Text("Notes")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(AppColors.text)
            }
            Text(notes)
                .font(.ubuntu(15, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
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
    
    private func goalActionsSection(goal: Goal) -> some View {
        VStack(spacing: 12) {
            Button(action: { showingEdit = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                    Text("Edit Goal")
                }
                .frame(maxWidth: .infinity)
                .secondaryButtonStyle()
            }
            Button(action: { showingDeleteAlert = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                    Text("Delete Goal")
                }
                .frame(maxWidth: .infinity)
                .frame(height: AppStyles.buttonHeight)
                .background(AppColors.error.opacity(0.15))
                .foregroundColor(AppColors.error)
                .cornerRadius(AppStyles.cornerRadius)
                .font(.ubuntu(16, weight: .medium))
            }
        }
    }
}

struct NutritionRowView: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.text)
            
            Spacer()
            
            Text("\(value) \(unit)")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(color)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(AppColors.cardBackground.opacity(0.3))
        .cornerRadius(AppStyles.smallCornerRadius)
    }
}

struct NutritionPill: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
            Text("\(value) \(unit)")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(color.opacity(0.15))
        .cornerRadius(AppStyles.smallCornerRadius)
    }
}

private struct EditFormSection<Content: View>: View {
    let icon: String
    let title: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
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
            content()
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
}

struct EditWorkoutView: View {
    @EnvironmentObject var appState: AppState
    let workoutId: UUID
    @Environment(\.presentationMode) var presentationMode
    
    private var workout: Workout? { appState.workout(byId: workoutId) }
    
    var body: some View {
        Group {
            if let w = workout {
                EditWorkoutFormView(workout: w)
            } else {
                Text("Workout not found")
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .navigationTitle("Edit Workout")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.textSecondary)
            }
        }
    }
}

private struct EditWorkoutFormView: View {
    let workout: Workout
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String
    @State private var selectedCategory: WorkoutCategory
    @State private var duration: Int
    @State private var exercises: [Exercise]
    @State private var notes: String
    @State private var showingAddExercise = false
    
    init(workout: Workout) {
        self.workout = workout
        _name = State(initialValue: workout.name)
        _selectedCategory = State(initialValue: workout.category)
        _duration = State(initialValue: workout.duration)
        _exercises = State(initialValue: workout.exercises)
        _notes = State(initialValue: workout.notes)
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    EditFormSection(icon: "dumbbell", title: "Workout") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Name")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                            TextField("Enter workout name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                            Text("Category")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.top, 4)
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(WorkoutCategory.allCases, id: \.self) { category in
                                    Text(category.rawValue).tag(category)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            Text("Duration (minutes)")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.top, 4)
                            Stepper(value: $duration, in: 5...180, step: 5) {
                                Text("\(duration) min")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.text)
                            }
                        }
                    }
                    EditFormSection(icon: "list.bullet", title: "Exercises") {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Spacer()
                                Button(action: { showingAddExercise = true }) {
                                    HStack(spacing: 6) {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add")
                                    }
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.accent)
                                }
                            }
                            if exercises.isEmpty {
                                Text("No exercises added")
                                    .font(.ubuntu(14, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                            } else {
                                VStack(spacing: 10) {
                                    ForEach(exercises) { exercise in
                                        ExerciseRowView(exercise: exercise) {
                                            exercises.removeAll { $0.id == exercise.id }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    EditFormSection(icon: "note.text", title: "Notes (Optional)") {
                        TextField("Add any notes...", text: $notes, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    VStack(spacing: 12) {
                        Button(action: { saveWorkout() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Save")
                            }
                            .frame(maxWidth: .infinity)
                            .primaryButtonStyle()
                        }
                        .disabled(name.isEmpty)
                        .opacity(name.isEmpty ? 0.6 : 1)
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "xmark.circle")
                                Text("Cancel")
                            }
                            .frame(maxWidth: .infinity)
                            .secondaryButtonStyle()
                        }
                    }
                    .padding(.top, 8)
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveWorkout()
                }
                .foregroundColor(AppColors.accent)
                .disabled(name.isEmpty)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingAddExercise) {
            AddExerciseView { exercise in
                exercises.append(exercise)
            }
        }
    }
    
    private func saveWorkout() {
        var updated = workout
        updated.name = name
        updated.category = selectedCategory
        updated.duration = duration
        updated.exercises = exercises
        updated.notes = notes
        appState.updateWorkout(updated)
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditMealView: View {
    @EnvironmentObject var appState: AppState
    let mealId: UUID
    @Environment(\.presentationMode) var presentationMode
    
    private var meal: Meal? { appState.meal(byId: mealId) }
    
    var body: some View {
        Group {
            if let m = meal {
                EditMealFormView(meal: m)
            } else {
                Text("Meal not found")
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .navigationTitle("Edit Meal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.textSecondary)
            }
        }
    }
}

private struct EditMealFormView: View {
    let meal: Meal
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String
    @State private var selectedMealType: MealType
    @State private var calories: String
    @State private var protein: String
    @State private var carbs: String
    @State private var fat: String
    @State private var notes: String
    
    init(meal: Meal) {
        self.meal = meal
        _name = State(initialValue: meal.name)
        _selectedMealType = State(initialValue: meal.mealType)
        _calories = State(initialValue: "\(meal.calories)")
        _protein = State(initialValue: "\(Int(meal.protein))")
        _carbs = State(initialValue: "\(Int(meal.carbs))")
        _fat = State(initialValue: "\(Int(meal.fat))")
        _notes = State(initialValue: meal.notes)
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    EditFormSection(icon: "sunrise.fill", title: "Meal") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Name")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                            TextField("Enter meal name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                            Text("Meal Type")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.top, 4)
                            Picker("Meal Type", selection: $selectedMealType) {
                                ForEach(MealType.allCases, id: \.self) { mealType in
                                    Text(mealType.rawValue).tag(mealType)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    EditFormSection(icon: "chart.pie.fill", title: "Nutrition") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Calories")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                            TextField("Enter calories", text: $calories)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.numberPad)
                            Text("Macronutrients (g)")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.top, 4)
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Protein").font(.ubuntu(12, weight: .medium)).foregroundColor(AppColors.textSecondary)
                                    TextField("0", text: $protein).textFieldStyle(CustomTextFieldStyle()).keyboardType(.decimalPad)
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Carbs").font(.ubuntu(12, weight: .medium)).foregroundColor(AppColors.textSecondary)
                                    TextField("0", text: $carbs).textFieldStyle(CustomTextFieldStyle()).keyboardType(.decimalPad)
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Fat").font(.ubuntu(12, weight: .medium)).foregroundColor(AppColors.textSecondary)
                                    TextField("0", text: $fat).textFieldStyle(CustomTextFieldStyle()).keyboardType(.decimalPad)
                                }
                            }
                        }
                    }
                    EditFormSection(icon: "note.text", title: "Notes (Optional)") {
                        TextField("Add any notes...", text: $notes, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    VStack(spacing: 12) {
                        Button(action: { saveMeal() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Save")
                            }
                            .frame(maxWidth: .infinity)
                            .primaryButtonStyle()
                        }
                        .disabled(name.isEmpty || calories.isEmpty)
                        .opacity((name.isEmpty || calories.isEmpty) ? 0.6 : 1)
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "xmark.circle")
                                Text("Cancel")
                            }
                            .frame(maxWidth: .infinity)
                            .secondaryButtonStyle()
                        }
                    }
                    .padding(.top, 8)
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveMeal()
                }
                .foregroundColor(AppColors.accent)
                .disabled(name.isEmpty || calories.isEmpty)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func saveMeal() {
        var updated = meal
        updated.name = name
        updated.mealType = selectedMealType
        updated.calories = Int(calories) ?? 0
        updated.protein = Double(protein) ?? 0
        updated.carbs = Double(carbs) ?? 0
        updated.fat = Double(fat) ?? 0
        updated.notes = notes
        appState.updateMeal(updated)
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditGoalView: View {
    @EnvironmentObject var appState: AppState
    let goalId: UUID
    @Environment(\.presentationMode) var presentationMode
    
    private var goal: Goal? { appState.goal(byId: goalId) }
    
    var body: some View {
        Group {
            if let g = goal {
                EditGoalFormView(goal: g)
            } else {
                Text("Goal not found")
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .navigationTitle("Edit Goal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.textSecondary)
            }
        }
    }
}

private struct EditGoalFormView: View {
    let goal: Goal
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String
    @State private var description: String
    @State private var targetValue: String
    @State private var currentValue: String
    @State private var unit: String
    @State private var selectedCategory: GoalCategory
    @State private var deadline: Date
    @State private var notes: String
    
    init(goal: Goal) {
        self.goal = goal
        _title = State(initialValue: goal.title)
        _description = State(initialValue: goal.description)
        _targetValue = State(initialValue: "\(goal.targetValue)")
        _currentValue = State(initialValue: "\(goal.currentValue)")
        _unit = State(initialValue: goal.unit)
        _selectedCategory = State(initialValue: goal.category)
        _deadline = State(initialValue: goal.deadline)
        _notes = State(initialValue: goal.notes)
    }
    
    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    EditFormSection(icon: "target", title: "Goal") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Title")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                            TextField("Enter goal title", text: $title)
                                .textFieldStyle(CustomTextFieldStyle())
                            Text("Description")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.top, 4)
                            TextField("Describe your goal", text: $description, axis: .vertical)
                                .textFieldStyle(CustomTextFieldStyle())
                                .lineLimit(2...4)
                            Text("Category")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.top, 4)
                            Picker("Category", selection: $selectedCategory) {
                                ForEach(GoalCategory.allCases, id: \.self) { category in
                                    Text(category.rawValue).tag(category)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    EditFormSection(icon: "chart.line.uptrend.xyaxis", title: "Progress") {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Target").font(.ubuntu(12, weight: .medium)).foregroundColor(AppColors.textSecondary)
                                    TextField("100", text: $targetValue).textFieldStyle(CustomTextFieldStyle()).keyboardType(.decimalPad)
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Current").font(.ubuntu(12, weight: .medium)).foregroundColor(AppColors.textSecondary)
                                    TextField("0", text: $currentValue).textFieldStyle(CustomTextFieldStyle()).keyboardType(.decimalPad)
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Unit").font(.ubuntu(12, weight: .medium)).foregroundColor(AppColors.textSecondary)
                                    TextField("kg", text: $unit).textFieldStyle(CustomTextFieldStyle())
                                }
                            }
                            Text("Deadline")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.textSecondary)
                                .padding(.top, 4)
                            DatePicker("", selection: $deadline, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                        }
                    }
                    EditFormSection(icon: "note.text", title: "Notes (Optional)") {
                        TextField("Add any notes...", text: $notes, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    VStack(spacing: 12) {
                        Button(action: { saveGoal() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Save")
                            }
                            .frame(maxWidth: .infinity)
                            .primaryButtonStyle()
                        }
                        .disabled(title.isEmpty)
                        .opacity(title.isEmpty ? 0.6 : 1)
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            HStack(spacing: 8) {
                                Image(systemName: "xmark.circle")
                                Text("Cancel")
                            }
                            .frame(maxWidth: .infinity)
                            .secondaryButtonStyle()
                        }
                    }
                    .padding(.top, 8)
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveGoal()
                }
                .foregroundColor(AppColors.accent)
                .disabled(title.isEmpty)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func saveGoal() {
        var updated = goal
        updated.title = title
        updated.description = description
        updated.targetValue = Double(targetValue) ?? 0
        updated.currentValue = Double(currentValue) ?? 0
        updated.unit = unit
        updated.category = selectedCategory
        updated.deadline = deadline
        updated.notes = notes
        appState.updateGoal(updated)
        presentationMode.wrappedValue.dismiss()
    }
}

struct MyItemsView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    @State private var showingAddWorkout = false
    @State private var showingAddMeal = false
    @State private var showingAddGoal = false
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                HStack {
                    Text("My Items")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Spacer()
                    
                    Button(action: {
                        switch selectedTab {
                        case 0: showingAddWorkout = true
                        case 1: showingAddMeal = true
                        case 2: showingAddGoal = true
                        default: break
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(AppColors.accentGradient)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                HStack(spacing: 0) {
                    TabButton(title: "Workouts", icon: "dumbbell", isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }
                    TabButton(title: "Meals", icon: "fork.knife", isSelected: selectedTab == 1) {
                        selectedTab = 1
                    }
                    TabButton(title: "Goals", icon: "target", isSelected: selectedTab == 2) {
                        selectedTab = 2
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(AppColors.cardGradient)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(AppColors.accent.opacity(0.15), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                TabView(selection: $selectedTab) {
                    WorkoutsListView(showingAdd: $showingAddWorkout)
                        .tag(0)
                    
                    MealsListView(showingAdd: $showingAddMeal)
                        .tag(1)
                    
                    GoalsListView(showingAdd: $showingAddGoal)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .sheet(isPresented: $showingAddWorkout) {
            AddWorkoutView()
        }
        .sheet(isPresented: $showingAddMeal) {
            AddMealView()
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView()
        }
    }
}

struct TabButton: View {
    let title: String
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(isSelected ? AppColors.accent : AppColors.textSecondary)
                }
                Text(title)
                    .font(.ubuntu(14, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? AppColors.accent : AppColors.textSecondary)
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(isSelected ? AppColors.accent : Color.clear)
                    .frame(height: 2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.accent.opacity(0.12) : Color.clear)
            )
        }
    }
}

struct WorkoutsListView: View {
    @EnvironmentObject var appState: AppState
    @Binding var showingAdd: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    TodayStyleSectionHeader(title: "Workouts", icon: "dumbbell")
                    Spacer()
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(AppColors.accentGradient)
                    }
                }
                
                if appState.workouts.isEmpty {
                    EmptyStateView(
                        icon: "dumbbell",
                        title: "No workouts yet",
                        subtitle: "Add your first workout and start your fitness journey",
                        buttonTitle: "Add Now",
                        action: { showingAdd = true }
                    )
                    .padding(.vertical, 24)
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(appState.workouts) { workout in
                            WorkoutCardView(workout: workout)
                        }
                    }
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
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
    }
}

struct MealsListView: View {
    @EnvironmentObject var appState: AppState
    @Binding var showingAdd: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    TodayStyleSectionHeader(title: "Meals", icon: "fork.knife")
                    Spacer()
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(AppColors.accentGradient)
                    }
                }
                
                if appState.meals.isEmpty {
                    EmptyStateView(
                        icon: "fork.knife",
                        title: "No meals logged",
                        subtitle: "Start tracking your nutrition to reach your goals",
                        buttonTitle: "Add Now",
                        action: { showingAdd = true }
                    )
                    .padding(.vertical, 24)
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(appState.meals) { meal in
                            MealCardView(meal: meal)
                        }
                    }
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
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
    }
}

struct GoalsListView: View {
    @EnvironmentObject var appState: AppState
    @Binding var showingAdd: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    TodayStyleSectionHeader(title: "Goals", icon: "target")
                    Spacer()
                    Button(action: { showingAdd = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(AppColors.accentGradient)
                    }
                }
                
                if appState.goals.isEmpty {
                    EmptyStateView(
                        icon: "target",
                        title: "No goals set",
                        subtitle: "Set your first goal and start achieving greatness",
                        buttonTitle: "Add Now",
                        action: { showingAdd = true }
                    )
                    .padding(.vertical, 24)
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(appState.goals) { goal in
                            GoalCardView(goal: goal)
                        }
                    }
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
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
    }
}

struct TodayStyleSectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
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
}

struct HistoryView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedDate = Date()
    @State private var showingCalendar = false
    
    private var dayWorkouts: [Workout] { getWorkouts(for: selectedDate) }
    private var dayMeals: [Meal] { getMeals(for: selectedDate) }
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("History")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        datePickerCard
                        
                        if let dayProgress = getDayProgress(for: selectedDate) {
                            historySection(title: "Daily Progress", icon: "chart.pie.fill") {
                                DayProgressView(progress: dayProgress)
                            }
                        }
                        
                        if !dayWorkouts.isEmpty {
                            historySection(title: "Workouts", icon: "dumbbell") {
                                LazyVStack(spacing: 10) {
                                    ForEach(dayWorkouts) { workout in
                                        WorkoutCardView(workout: workout)
                                    }
                                }
                            }
                        }
                        
                        if !dayMeals.isEmpty {
                            historySection(title: "Meals", icon: "fork.knife") {
                                VStack(spacing: 10) {
                                    ForEach(dayMeals) { meal in
                                        MealCardView(meal: meal)
                                    }
                                    CaloriesSummaryView(meals: dayMeals)
                                }
                            }
                        }
                        
                        if dayWorkouts.isEmpty && dayMeals.isEmpty && getDayProgress(for: selectedDate) == nil {
                            EmptyStateView(
                                icon: "calendar.badge.exclamationmark",
                                title: "No activity recorded",
                                subtitle: "Complete your first task to start tracking progress",
                                buttonTitle: nil,
                                action: nil
                            )
                            .padding(.vertical, 40)
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
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $showingCalendar) {
            CalendarPickerView(selectedDate: $selectedDate)
        }
    }
    
    private var datePickerCard: some View {
        HStack {
            Button(action: { showingCalendar = true }) {
                HStack(spacing: 10) {
                    Image(systemName: "calendar")
                        .font(.system(size: 18))
                        .foregroundColor(AppColors.accent)
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(AppColors.accent.opacity(0.15)))
                    
                    Text(selectedDate, style: .date)
                        .font(.ubuntu(18, weight: .medium))
                        .foregroundColor(AppColors.text)
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(AppColors.accent)
                        .font(.system(size: 12))
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(AppColors.accentGradient)
                }
                
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                }) {
                    Image(systemName: "chevron.right.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(AppColors.accentGradient)
                }
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
    
    private func historySection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            TodayStyleSectionHeader(title: title, icon: icon)
            content()
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(AppColors.cardGradient)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(AppColors.accent.opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    private func getDayProgress(for date: Date) -> DayProgress? {
        appState.progress.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    private func getWorkouts(for date: Date) -> [Workout] {
        appState.workouts.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    private func getMeals(for date: Date) -> [Meal] {
        appState.meals.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
}

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingRateAlert = false
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Settings")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.text)
                    
                    Spacer()
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        VStack(spacing: 14) {
                            Image(systemName: "figure.strengthtraining.functional")
                                .font(.system(size: 52))
                                .foregroundColor(AppColors.accent)
                            
                            VStack(spacing: 4) {
                                Text("FitMaster")
                                    .font(.ubuntu(26, weight: .bold))
                                    .foregroundColor(AppColors.text)
                                
                                Text("Your Personal Fitness Coach")
                                    .font(.ubuntu(15, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(AppColors.cardGradient)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(AppColors.accent.opacity(0.15), lineWidth: 1)
                                )
                        )
                        .padding(.top, 8)
                        
                        VStack(spacing: 0) {
                            SettingsRow(
                                icon: "envelope.fill",
                                title: "Contact Us",
                                action: { openURL("https://forms.gle/fGrPxNQ2yaSdVPpz9") }
                            )
                            
                            Divider()
                                .background(AppColors.textSecondary.opacity(0.3))
                                .padding(.leading, 56)
                            
                            SettingsRow(
                                icon: "star.fill",
                                title: "Rate App",
                                action: {
                                    showingRateAlert = true
                                    appState.requestReview()
                                }
                            )
                            
                            Divider()
                                .background(AppColors.textSecondary.opacity(0.3))
                                .padding(.leading, 56)
                            
                            SettingsRow(
                                icon: "doc.text.fill",
                                title: "Privacy Policy",
                                action: { openURL("https://doc-hosting.flycricket.io/ironprime-vector-privacy-policy/a9e80d72-e62e-4fb7-b5fe-5c0b28a3999a/privacy") }
                            )
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
                    .padding(.horizontal, 20)
                    .padding(.bottom, 120)
                }
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.accent)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(AppColors.accent.opacity(0.15)))
                
                Text(title)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.text)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.vertical, 14)
        }
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let buttonTitle: String?
    let action: (() -> Void)?
    
    var body: some View {
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
            
            if let buttonTitle = buttonTitle, let action = action {
                Button(action: action) {
                    Text(buttonTitle)
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.accent)
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
    }
}

struct CalendarPickerView: View {
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack(spacing: 10) {
                            Image(systemName: "calendar")
                                .font(.system(size: 20))
                                .foregroundColor(AppColors.accent)
                                .frame(width: 40, height: 40)
                                .background(Circle().fill(AppColors.accent.opacity(0.15)))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Choose Date")
                                    .font(.ubuntu(20, weight: .bold))
                                    .foregroundColor(AppColors.text)
                                Text("View workouts and meals for this day")
                                    .font(.ubuntu(13, weight: .medium))
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .tint(AppColors.accent)
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(AppColors.cardGradient)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(AppColors.accent.opacity(0.2), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 20)
                        
                        Text(selectedDate, style: .date)
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.accent)
                    }
                }
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.accent)
                    .font(.ubuntu(16, weight: .medium))
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    private let tabs = [
        TabItem(icon: "house.fill", title: "Today", tag: 0),
        TabItem(icon: "list.bullet", title: "My Items", tag: 1),
        TabItem(icon: "chart.bar.fill", title: "Statistics", tag: 2),
        TabItem(icon: "calendar", title: "History", tag: 3),
        TabItem(icon: "gearshape.fill", title: "Settings", tag: 4)
    ]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.tag) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab.tag,
                    action: {
                        selectedTab = tab.tag
                    }
                )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(AppColors.cardGradient)
                .shadow(
                    color: AppColors.shadowColor,
                    radius: 12,
                    x: 0,
                    y: -4
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(AppColors.accent.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}

struct TabItem {
    let icon: String
    let title: String
    let tag: Int
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(AppColors.accent.opacity(0.2))
                            .frame(width: 40, height: 40)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(.system(size: isSelected ? 20 : 18, weight: .medium))
                        .foregroundColor(isSelected ? AppColors.accent : AppColors.text)
                        .opacity(isSelected ? 1 : 0.85)
                }
                
                Text(tab.title)
                    .font(.ubuntu(12, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? AppColors.accent : AppColors.text)
                    .opacity(isSelected ? 1 : 0.85)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    TodayView()
                case 1:
                    MyItemsView()
                case 2:
                    StatisticsView()
                case 3:
                    HistoryView()
                case 4:
                    SettingsView()
                default:
                    TodayView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack {
                Spacer()
                
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
