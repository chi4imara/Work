import SwiftUI
import StoreKit

struct HabitDetailView: View {
    @ObservedObject var habitStore: HabitStore
    @Environment(\.dismiss) private var dismiss
    
    let habit: Habit
    @State private var showingEditHabit = false
    @State private var showingDeleteAlert = false
    @State private var showingResetAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        headerView
                        
                        statsView
                        
                        controlSectionView
                        
                        achievementsSectionView
                        
                        actionButtonsView
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEditHabit) {
            EditHabitView(habitStore: habitStore, habit: habit)
        }
        .alert("Delete Habit", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                habitStore.deleteHabit(habit)
                dismiss()
            }
        } message: {
            Text("This will permanently delete the habit and all its data. This action cannot be undone.")
        }
        .alert("Reset Streak", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                habitStore.resetHabitStreak(habit.id)
            }
        } message: {
            Text("Are you sure you want to reset your streak? This action cannot be undone.")
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                }
                
                Spacer()
                
                Text("Habit Details")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.textWhite)
                
                Spacer()
                
                Button(action: {
                    showingEditHabit = true
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                }
            }
            .padding(.top, 20)
            
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(habit.category.color.opacity(0.2))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: habit.category.icon)
                        .font(.system(size: 35, weight: .medium))
                        .foregroundColor(habit.category.color)
                }
                
                Text(habit.name)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.textWhite)
                    .multilineTextAlignment(.center)
                
                Text(habit.category.rawValue)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(habit.category.color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(habit.category.color.opacity(0.2))
                    .cornerRadius(10)
            }
        }
    }
    
    private var statsView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 5) {
                Text("\(habit.currentStreak)")
                    .font(.ubuntu(48, weight: .bold))
                    .foregroundColor(AppColors.accentYellow)
                
                Text("Current Streak")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.textWhite.opacity(0.8))
            }
            
            HStack(spacing: 20) {
                statCardView(
                    title: "Max Streak",
                    value: "\(habit.maxStreak)",
                    subtitle: "days"
                )
                
                statCardView(
                    title: "Started",
                    value: habit.startDate.formatted(.dateTime.day().month(.abbreviated)),
                    subtitle: habit.startDate.formatted(.dateTime.year())
                )
                
                statCardView(
                    title: "Total Days",
                    value: "\(habit.checkedDates.count)",
                    subtitle: "checked"
                )
            }
        }
    }
    
    private func statCardView(title: String, value: String, subtitle: String) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(AppColors.textWhite.opacity(0.7))
            
            Text(value)
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.textWhite)
            
            Text(subtitle)
                .font(.ubuntu(10, weight: .regular))
                .foregroundColor(AppColors.textWhite.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(AppColors.textWhite.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var controlSectionView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Streak Control")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.textWhite)
            
            VStack(spacing: 12) {
                Button(action: {
                    habitStore.checkHabitToday(habit.id)
                }) {
                    HStack {
                        Image(systemName: habit.canCheckToday ? "checkmark.circle" : "checkmark.circle.fill")
                            .font(.system(size: 20, weight: .medium))
                        
                        Text(habit.canCheckToday ? "Mark Today Complete" : "Already Checked Today")
                            .font(.ubuntu(16, weight: .medium))
                        
                        Spacer()
                    }
                    .foregroundColor(habit.canCheckToday ? AppColors.primaryPurple : AppColors.successGreen)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(habit.canCheckToday ? AppColors.accentYellow : AppColors.successGreen.opacity(0.2))
                    .cornerRadius(25)
                }
                .disabled(!habit.canCheckToday)
                
                Button(action: {
                    showingResetAlert = true
                }) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 18, weight: .medium))
                        
                        Text("Reset Streak")
                            .font(.ubuntu(16, weight: .medium))
                        
                        Spacer()
                    }
                    .foregroundColor(AppColors.warningRed)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.warningRed.opacity(0.2))
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(AppColors.warningRed.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
    }
    
    private var achievementsSectionView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Achievements")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.textWhite)
            
            let milestones = [7, 14, 30, 60, 100, 365]
            
            VStack(spacing: 10) {
                ForEach(milestones, id: \.self) { milestone in
                    achievementRowView(milestone: milestone)
                }
            }
        }
    }
    
    private func achievementRowView(milestone: Int) -> some View {
        let isAchieved = habit.maxStreak >= milestone
        let isNext = !isAchieved && milestone == habit.nextMilestone
        
        return HStack(spacing: 15) {
            Image(systemName: isAchieved ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(isAchieved ? AppColors.successGreen : AppColors.neutralGray)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(milestone) Days")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.textWhite)
                
                Text(achievementDescription(for: milestone))
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(AppColors.textWhite.opacity(0.7))
            }
            
            Spacer()
            
            if isNext {
                Text("Next Goal")
                    .font(.ubuntu(10, weight: .bold))
                    .foregroundColor(AppColors.accentYellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.accentYellow.opacity(0.2))
                    .cornerRadius(8)
            } else if isAchieved {
                Text("Achieved")
                    .font(.ubuntu(10, weight: .bold))
                    .foregroundColor(AppColors.successGreen)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.successGreen.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding(15)
        .background(isNext ? AnyShapeStyle(AppColors.accentYellow.opacity(0.1)) : AnyShapeStyle(AppColors.cardGradient))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(
                    isNext ? AppColors.accentYellow.opacity(0.3) : AppColors.textWhite.opacity(0.1),
                    lineWidth: 1
                )
        )
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 15) {
            if habit.shouldBeInTrophies && !habit.isInTrophies {
                Button(action: {
                    habitStore.addToTrophies(habit)
                }) {
                    HStack {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 18, weight: .medium))
                        
                        Text("Add to Trophies")
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(AppColors.primaryPurple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.accentYellow)
                    .cornerRadius(25)
                }
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("Delete Habit")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(AppColors.warningRed)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.warningRed.opacity(0.2))
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.warningRed.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
    
    private func achievementDescription(for milestone: Int) -> String {
        switch milestone {
        case 7:
            return "Complete your first week"
        case 14:
            return "Two weeks of dedication"
        case 30:
            return "A full month of success"
        case 60:
            return "Two months of commitment"
        case 100:
            return "Join the century club"
        case 365:
            return "A full year of achievement"
        default:
            return "Keep up the great work"
        }
    }
}

struct EditHabitView: View {
    @ObservedObject var habitStore: HabitStore
    @Environment(\.dismiss) private var dismiss
    
    let habit: Habit
    @State private var habitName: String
    @State private var selectedCategory: HabitCategory
    @State private var habitComment: String
    @State private var startDate: Date
    
    init(habitStore: HabitStore, habit: Habit) {
        self.habitStore = habitStore
        self.habit = habit
        self._habitName = State(initialValue: habit.name)
        self._selectedCategory = State(initialValue: habit.category)
        self._habitComment = State(initialValue: habit.comment)
        self._startDate = State(initialValue: habit.startDate)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.textWhite)
                        
                        Spacer()
                        
                        Text("Edit Habit")
                            .font(.ubuntu(20, weight: .bold))
                            .foregroundColor(AppColors.textWhite)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveChanges()
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                        .disabled(!canSave)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    ScrollView {
                        VStack(spacing: 25) {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Habit Name")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.textWhite)
                                
                                TextField("Enter habit name", text: $habitName)
                                    .font(.ubuntu(16, weight: .regular))
                                    .foregroundColor(AppColors.textWhite)
                                    .padding(15)
                                    .background(AppColors.cardGradient)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(AppColors.textWhite.opacity(0.2), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Category")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.textWhite)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                                    ForEach(HabitCategory.allCases) { category in
                                        categoryButton(category: category)
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Comment (Optional)")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.textWhite)
                                
                                TextField("Why do you want to break this habit?", text: $habitComment, axis: .vertical)
                                    .font(.ubuntu(16, weight: .regular))
                                    .foregroundColor(AppColors.textWhite)
                                    .padding(15)
                                    .background(AppColors.cardGradient)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(AppColors.textWhite.opacity(0.2), lineWidth: 1)
                                    )
                                    .frame(minHeight: 80)
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Start Date")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(AppColors.textWhite)
                                
                                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .padding(15)
                                    .background(AppColors.cardGradient)
                                    .cornerRadius(15)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(AppColors.textWhite.opacity(0.2), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
    }
    
    private func categoryButton(category: HabitCategory) -> some View {
        Button(action: {
            selectedCategory = category
        }) {
            VStack(spacing: 10) {
                Image(systemName: category.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(selectedCategory == category ? AppColors.primaryPurple : category.color)
                
                Text(category.rawValue)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.textWhite)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                selectedCategory == category ?
                AnyShapeStyle(AppColors.accentYellow) : AnyShapeStyle(AppColors.cardGradient)
            )
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        selectedCategory == category ?
                        AppColors.accentYellow : AppColors.textWhite.opacity(0.2),
                        lineWidth: selectedCategory == category ? 2 : 1
                    )
            )
        }
        .scaleEffect(selectedCategory == category ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: selectedCategory)
    }
    
    private var canSave: Bool {
        !habitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveChanges() {
        var updatedHabit = habit
        updatedHabit.name = habitName.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedHabit.category = selectedCategory
        updatedHabit.comment = habitComment.trimmingCharacters(in: .whitespacesAndNewlines)
        updatedHabit.startDate = startDate
        
        habitStore.updateHabit(updatedHabit)
        dismiss()
    }
}

#Preview {
    HabitDetailView(
        habitStore: HabitStore(),
        habit: Habit(name: "Social Media", category: .technology, comment: "Want more time for reading")
    )
}
