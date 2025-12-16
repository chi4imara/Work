import SwiftUI

struct MyStreakView: View {
    @ObservedObject var habitStore: HabitStore
    @State private var showingCreateHabit = false
    @State private var showingResetAlert = false
    @State private var showingDeleteAlert = false
    @State private var selectedHabit: Habit?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            if habitStore.activeHabits.isEmpty {
                emptyStateView
            } else {
                mainContentView
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingCreateHabit) {
            CreateHabitView(habitStore: habitStore)
        }
        .alert("Reset Streak", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                if let habit = selectedHabit {
                    habitStore.resetHabitStreak(habit.id)
                }
            }
        } message: {
            Text("Are you sure you want to reset your streak? This action cannot be undone.")
        }
        .alert("Delete Habit", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let habit = selectedHabit {
                    habitStore.deleteHabit(habit)
                }
            }
        } message: {
            Text("This will permanently delete the habit and all its data. This action cannot be undone.")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Image(systemName: "target")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.accentYellow)
            
            Text("No Active Streaks")
                .font(.ubuntu(24, weight: .bold))
                .foregroundColor(AppColors.textWhite)
            
            Text("Create your first habit to start tracking your progress")
                .font(.ubuntu(16, weight: .regular))
                .foregroundColor(AppColors.textWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                showingCreateHabit = true
            }) {
                Text("Create First Habit")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(AppColors.primaryPurple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.accentYellow)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 40)
        }
    }
    
    private var mainContentView: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Text("Today Without...")
                        .font(.ubuntu(20, weight: .medium))
                        .foregroundColor(AppColors.textWhite.opacity(0.8))
                    
                    if let currentHabit = habitStore.activeHabits.first {
                        Text(currentHabit.name)
                            .font(.ubuntu(28, weight: .bold))
                            .foregroundColor(AppColors.textWhite)
                    }
                }
                .padding(.top, 60)
                
                if let currentHabit = habitStore.activeHabits.first {
                    streakCounterView(for: currentHabit)
                }
                
                LazyVStack(spacing: 15) {
                    ForEach(habitStore.activeHabits) { habit in
                        habitCardView(habit: habit)
                    }
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    showingCreateHabit = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Habit")
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.textWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.cardGradient)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(AppColors.textWhite.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private func streakCounterView(for habit: Habit) -> some View {
        VStack(spacing: 20) {
            VStack(spacing: 5) {
                Text("\(habit.currentStreak)")
                    .font(.ubuntu(72, weight: .bold))
                    .foregroundColor(AppColors.accentYellow)
                
                Text(habit.currentStreak == 1 ? "day in a row" : "days in a row")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(AppColors.textWhite.opacity(0.8))
            }
            
            VStack(spacing: 10) {
                HStack {
                    Text("Next goal: \(habit.nextMilestone) days")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.textWhite.opacity(0.7))
                    Spacer()
                    Text("\(habit.currentStreak)/\(habit.nextMilestone)")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                }
                
                ProgressView(value: habit.progressToNextMilestone)
                    .progressViewStyle(LinearProgressViewStyle(tint: AppColors.accentYellow))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
            .padding(.horizontal, 40)
        }
    }
    
    private func habitCardView(habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: habit.category.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(habit.category.color)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.name)
                        .font(.ubuntu(18, weight: .bold))
                        .foregroundColor(AppColors.textWhite)
                    
                    Text("since \(habit.startDate, formatter: dateFormatter)")
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(AppColors.textWhite.opacity(0.6))
                }
                
                Spacer()
                
                Text("\(habit.currentStreak)")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.accentYellow)
            }
            
            if !habit.comment.isEmpty {
                Text(habit.comment)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(AppColors.textWhite.opacity(0.8))
                    .italic()
            }
            
            HStack(spacing: 15) {
                Button(action: {
                    habitStore.checkHabitToday(habit.id)
                }) {
                    HStack {
                        Image(systemName: habit.canCheckToday ? "checkmark.circle" : "checkmark.circle.fill")
                        Text(habit.canCheckToday ? "Mark Today" : "Checked Today")
                    }
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(habit.canCheckToday ? AppColors.primaryPurple : AppColors.successGreen)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(habit.canCheckToday ? AppColors.accentYellow : AppColors.successGreen.opacity(0.2))
                    .cornerRadius(20)
                }
                .disabled(!habit.canCheckToday)
                
                Button(action: {
                    selectedHabit = habit
                    showingResetAlert = true
                }) {
                    Text("Reset")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(AppColors.warningRed)
                        .frame(width: 70, height: 40)
                        .background(AppColors.warningRed.opacity(0.2))
                        .cornerRadius(20)
                }
                
                Button(action: {
                    selectedHabit = habit
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.warningRed)
                        .frame(width: 40, height: 40)
                        .background(AppColors.warningRed.opacity(0.2))
                        .cornerRadius(20)
                }
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColors.textWhite.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}

#Preview {
    MyStreakView(habitStore: HabitStore())
}
