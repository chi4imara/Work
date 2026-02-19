import SwiftUI

struct WorkoutsView: View {
    @EnvironmentObject var workoutsVM: WorkoutsViewModel
    @EnvironmentObject var userProfile: UserProfileViewModel
    @State private var showFilters = false
    @State private var showAddWorkout = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your workouts today")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(ColorTheme.textPrimary)
                            
                            Text("Choose the right workout for your level and goals")
                                .font(.ubuntu(14, weight: .regular))
                                .foregroundColor(ColorTheme.textSecondary)
                        }
                        
                        Spacer()
                        
                        Button(action: { showAddWorkout = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(ColorTheme.primaryYellow)
                                .padding(10)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                        }
                        
                        Button(action: { showFilters.toggle() }) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(ColorTheme.primaryYellow)
                                .padding(10)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(12)
                        }
                    }
                    
                    if hasActiveFilters {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(activeFilters, id: \.self) { filter in
                                    FilterChip(text: filter) {
                                        removeFilter(filter)
                                    }
                                }
                                
                                Button("Clear All") {
                                    workoutsVM.clearFilters()
                                }
                                .font(.ubuntu(12, weight: .medium))
                                .foregroundColor(ColorTheme.primaryYellow)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(15)
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if workoutsVM.availableWorkouts.isEmpty {
                            EmptyLibraryView {
                                showAddWorkout = true
                            }
                        } else if workoutsVM.filteredWorkouts.isEmpty {
                            EmptyWorkoutsView {
                                workoutsVM.clearFilters()
                            }
                        } else {
                            ForEach(workoutsVM.filteredWorkouts) { workout in
                                WorkoutCard(workout: workout) {
                                    startWorkout(workout)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .sheet(isPresented: $showFilters) {
            FilterView()
                .environmentObject(workoutsVM)
        }
        .sheet(isPresented: $showAddWorkout) {
            AddWorkoutView()
                .environmentObject(workoutsVM)
        }
    }
    
    private var hasActiveFilters: Bool {
        workoutsVM.selectedGoal != nil ||
        workoutsVM.selectedLevel != nil ||
        workoutsVM.selectedType != nil ||
        workoutsVM.selectedDuration != nil
    }
    
    private var activeFilters: [String] {
        var filters: [String] = []
        
        if let goal = workoutsVM.selectedGoal {
            filters.append(goal.rawValue)
        }
        if let level = workoutsVM.selectedLevel {
            filters.append(level.rawValue)
        }
        if let type = workoutsVM.selectedType {
            filters.append(type.rawValue)
        }
        if let duration = workoutsVM.selectedDuration {
            filters.append("\(duration) min")
        }
        
        return filters
    }
    
    private func removeFilter(_ filter: String) {
        if let goal = FitnessGoal.allCases.first(where: { $0.rawValue == filter }) {
            workoutsVM.selectedGoal = workoutsVM.selectedGoal == goal ? nil : workoutsVM.selectedGoal
        }
        if let level = FitnessLevel.allCases.first(where: { $0.rawValue == filter }) {
            workoutsVM.selectedLevel = workoutsVM.selectedLevel == level ? nil : workoutsVM.selectedLevel
        }
        if let type = WorkoutType.allCases.first(where: { $0.rawValue == filter }) {
            workoutsVM.selectedType = workoutsVM.selectedType == type ? nil : workoutsVM.selectedType
        }
        if filter.contains("min") {
            workoutsVM.selectedDuration = nil
        }
        
        workoutsVM.applyFilters()
    }
    
    private func startWorkout(_ workout: Workout) {
        workoutsVM.scheduleWorkout(workout, for: Date())
    }
    
    private func refreshWorkouts() {
        workoutsVM.applyFilters()
    }
}

struct WorkoutCard: View {
    let workout: Workout
    let onStart: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(ColorTheme.primaryYellow.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: workout.imageName)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(ColorTheme.primaryYellow)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.name)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    HStack(spacing: 12) {
                        Label(workout.type.rawValue, systemImage: "tag")
                        Label("\(workout.duration) min", systemImage: "clock")
                        Label(workout.difficulty.rawValue, systemImage: "speedometer")
                    }
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                }
                
                Spacer()
            }
            
            Text(workout.description)
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(ColorTheme.textSecondary)
                .lineLimit(2)
            
            HStack {
                Spacer()
                
                Button {
                    onStart()
                } label: {
                    Text("Start")
                        .font(.ubuntu(14, weight: .bold))
                        .foregroundColor(ColorTheme.primaryBlue)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(ColorTheme.primaryYellow)
                        .cornerRadius(20)
                }
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct FilterChip: View {
    let text: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            Text(text)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(ColorTheme.textPrimary)
            
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(ColorTheme.textSecondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(ColorTheme.primaryYellow.opacity(0.3))
        .cornerRadius(15)
    }
}

struct EmptyLibraryView: View {
    let onAddWorkout: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "plus.circle")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(ColorTheme.textSecondary)
            
            VStack(spacing: 8) {
                Text("You have no workouts yet")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("Add your first workout to get started. You can then schedule it and track your progress.")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                onAddWorkout()
            } label: {
                Text("Add Workout")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(ColorTheme.primaryYellow)
                    .cornerRadius(25)
            }
        }
        .padding(40)
    }
}

struct EmptyWorkoutsView: View {
    let onClearFilters: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50, weight: .light))
                .foregroundColor(ColorTheme.textSecondary)
            
            VStack(spacing: 8) {
                Text("No suitable workouts found")
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("Try adjusting your filters or explore different workout types")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                onClearFilters()
            } label: {
                Text("Reset Filters")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryBlue)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(ColorTheme.primaryYellow)
                    .cornerRadius(25)
            }
            
            VStack(spacing: 8) {
                Text("Tip")
                    .font(.ubuntu(14, weight: .bold))
                    .foregroundColor(ColorTheme.primaryYellow)
                
                Text("Try yoga in the morning for energy and focus")
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(16)
            .background(ColorTheme.cardBackground)
            .cornerRadius(12)
        }
        .padding(40)
    }
}
