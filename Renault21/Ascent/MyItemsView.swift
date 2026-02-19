import SwiftUI

struct MyItemsView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var selectedTab = 0
    @State private var showingAddWorkout = false
    @State private var showingAddNutrition = false
    @State private var showingAddTask = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My Items")
                    .font(FontManager.playfairBold(size: 26))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            
            customTabPicker
            
            TabView(selection: $selectedTab) {
                workoutsTab
                    .tag(0)
                
                nutritionTab
                    .tag(1)
                
                tasksTab
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
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
    }
    
    private var customTabPicker: some View {
        HStack(spacing: 0) {
            TabPickerButton(
                title: "Workouts",
                icon: "dumbbell.fill",
                isSelected: selectedTab == 0
            ) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = 0
                }
            }
            
            TabPickerButton(
                title: "Nutrition",
                icon: "leaf.fill",
                isSelected: selectedTab == 1
            ) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = 1
                }
            }
            
            TabPickerButton(
                title: "Tasks",
                icon: "checkmark.circle.fill",
                isSelected: selectedTab == 2
            ) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedTab = 2
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .cardBackground()
        .cornerRadius(16)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var workoutsTab: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                addButton(
                    title: "Add New Workout",
                    icon: "plus.circle.fill",
                    action: { showingAddWorkout = true }
                )
                
                if dataManager.workouts.isEmpty {
                    EmptyStateView(
                        icon: "dumbbell.fill",
                        title: "No workouts yet",
                        subtitle: "Add your first workout and start planning your fitness journey"
                    )
                    .padding(.top, 60)
                } else {
                    ForEach(dataManager.workouts) { workout in
                        NavigationLink(destination: WorkoutDetailView(workoutId: workout.id)) {
                            WorkoutListCardView(workout: workout)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .id("\(workout.id)-\(workout.name)-\(workout.duration)-\(workout.repetitions ?? 0)")
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
        .id(dataManager.itemsVersion)
    }
    
    private var nutritionTab: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                addButton(
                    title: "Add Nutrition Item",
                    icon: "plus.circle.fill",
                    action: { showingAddNutrition = true }
                )
                
                if dataManager.nutritionItems.isEmpty {
                    EmptyStateView(
                        icon: "leaf.fill",
                        title: "No nutrition items yet",
                        subtitle: "Track your meals and nutrition to fuel your goals"
                    )
                    .padding(.top, 60)
                } else {
                    ForEach(dataManager.nutritionItems) { nutrition in
                        NavigationLink(destination: NutritionDetailView(nutritionId: nutrition.id)) {
                            NutritionListCardView(nutrition: nutrition)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .id("\(nutrition.id)-\(nutrition.name)-\(nutrition.calories)-\(nutrition.mealType.rawValue)")
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
        .id(dataManager.itemsVersion)
    }
    
    private var tasksTab: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                addButton(
                    title: "Add New Task",
                    icon: "plus.circle.fill",
                    action: { showingAddTask = true }
                )
                
                if dataManager.tasks.isEmpty {
                    EmptyStateView(
                        icon: "list.bullet.clipboard",
                        title: "No tasks yet",
                        subtitle: "Add tasks to boost your productivity and stay organized"
                    )
                    .padding(.top, 60)
                } else {
                    ForEach(dataManager.tasks) { task in
                        NavigationLink(destination: TaskDetailView(taskId: task.id)) {
                            TaskListCardView(task: task)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .id("\(task.id)-\(task.name)-\(task.category.rawValue)-\(task.priority.rawValue)")
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
        .id(dataManager.itemsVersion)
    }
    
    private func addButton(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(title)
                    .font(FontManager.playfairSemiBold(size: 18))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .padding(.horizontal, 20)
            .background(ColorTheme.accentGradient)
            .cornerRadius(16)
            .shadow(color: ColorTheme.primaryAccent.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .padding(.top, 20)
    }
}

struct TabPickerButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.primaryAccent)
                
                Text(title)
                    .font(FontManager.playfairMedium(size: 14))
                    .foregroundColor(isSelected ? ColorTheme.primaryText : ColorTheme.primaryAccent)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(isSelected ? ColorTheme.primaryAccent : Color.clear)
            .cornerRadius(12)
        }
    }
}

struct WorkoutListCardView: View {
    let workout: Workout
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: workout.category.icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(ColorTheme.primaryAccent)
                .frame(width: 50, height: 50)
                .background(ColorTheme.primaryAccent.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(workout.name)
                    .font(FontManager.playfairSemiBold(size: 18))
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(2)
                
                HStack(spacing: 16) {
                    Label("\(workout.duration) min", systemImage: "clock")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    if let reps = workout.repetitions {
                        Label("\(reps) reps", systemImage: "repeat")
                            .font(FontManager.playfairRegular(size: 14))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                }
                
                Text(workout.category.rawValue)
                    .font(FontManager.playfairRegular(size: 12))
                    .foregroundColor(ColorTheme.primaryAccent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ColorTheme.primaryAccent.opacity(0.1))
                    .cornerRadius(6)
            }
            
            Spacer()
            
            if workout.isFavorite {
                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundColor(ColorTheme.error)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .cardBackground()
        .cornerRadius(16)
    }
}

struct NutritionListCardView: View {
    let nutrition: Nutrition
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: nutrition.mealType.icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(ColorTheme.primaryAccent)
                .frame(width: 50, height: 50)
                .background(ColorTheme.primaryAccent.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(nutrition.name)
                    .font(FontManager.playfairSemiBold(size: 18))
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(2)
                
                HStack(spacing: 16) {
                    Label("\(nutrition.calories) cal", systemImage: "flame")
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Text(nutrition.mealType.rawValue)
                        .font(FontManager.playfairRegular(size: 12))
                        .foregroundColor(ColorTheme.primaryAccent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(ColorTheme.primaryAccent.opacity(0.1))
                        .cornerRadius(6)
                }
            }
            
            Spacer()
            
            if nutrition.isFavorite {
                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundColor(ColorTheme.error)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .cardBackground()
        .cornerRadius(16)
    }
}

struct TaskListCardView: View {
    let task: ProductivityTask
    
    var priorityColor: Color {
        switch task.priority {
        case .low: return ColorTheme.success
        case .medium: return ColorTheme.warning
        case .high: return ColorTheme.error
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: task.category.icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(ColorTheme.primaryAccent)
                .frame(width: 50, height: 50)
                .background(ColorTheme.primaryAccent.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(task.name)
                    .font(FontManager.playfairSemiBold(size: 18))
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    Text(task.category.rawValue)
                        .font(FontManager.playfairRegular(size: 14))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(priorityColor)
                            .frame(width: 8, height: 8)
                        
                        Text(task.priority.rawValue)
                            .font(FontManager.playfairRegular(size: 12))
                            .foregroundColor(priorityColor)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(priorityColor.opacity(0.1))
                    .cornerRadius(6)
                }
            }
            
            Spacer()
            
            if task.isFavorite {
                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundColor(ColorTheme.error)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .cardBackground()
        .cornerRadius(16)
    }
}

#Preview {
    MyItemsView()
}
