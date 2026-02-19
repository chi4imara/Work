import SwiftUI

struct HabitDetailView: View {
    let habitId: UUID
    @ObservedObject var viewModel: HabitsViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    private var habit: Habit? {
        viewModel.habit(by: habitId)
    }
    
    var body: some View {
        Group {
            if let habit = habit {
                habitDetailContent(habit: habit)
            } else {
                habitNotFoundView
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if habit != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingEditSheet = true }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        Button(role: .destructive, action: { showingDeleteAlert = true }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(AppColors.iconAccent)
                    }
                }
            }
        }
        .alert("Delete Habit?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteHabit(id: habitId)
                dismiss()
            }
        } message: {
            Text("This habit will be permanently removed.")
        }
        .sheet(isPresented: $showingEditSheet) {
            if let habit = habit {
                EditHabitView(habitId: habitId, viewModel: viewModel, initialHabit: habit)
            }
        }
    }
    
    private func habitDetailContent(habit: Habit) -> some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    headerCard(habit: habit)
                    
                    streakCard(habit: habit)
                    
                    completionHistoryCard(habit: habit)
                    
                    if !habit.description.isEmpty {
                        notesCard(habit: habit)
                    }
                    
                    markCompleteButton(habit: habit)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.sm)
            }
        }
    }
    
    private func headerCard(habit: Habit) -> some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                Circle()
                    .fill(habit.category.color.opacity(0.2))
                    .frame(width: 56, height: 56)
                
                Image(systemName: habit.icon)
                    .font(.system(size: 24))
                    .foregroundColor(AppColors.iconPrimary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(AppFonts.title3())
                    .foregroundColor(AppColors.textPrimary)
                
                Text(habit.category.rawValue)
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.textSecondary)
                
                Text(habit.frequency.rawValue)
                    .font(AppFonts.caption())
                    .foregroundColor(AppColors.textTertiary)
            }
            
            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
    
    private func streakCard(habit: Habit) -> some View {
        HStack {
            Image(systemName: "flame")
                .foregroundColor(AppColors.iconAccent)
            
            Text("\(habit.currentStreak) day streak")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
    
    private func completionHistoryCard(habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Completion History")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
            
            if habit.completedDates.isEmpty {
                Text("No completions yet. Mark a day complete to start your streak.")
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.vertical, AppSpacing.sm)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: AppSpacing.xs), count: 7), spacing: AppSpacing.xs) {
                    ForEach(habit.completedDates.suffix(28).reversed(), id: \.self) { date in
                        Text("\(Calendar.current.component(.day, from: date))")
                            .font(AppFonts.caption2())
                            .foregroundColor(AppColors.textSecondary)
                            .frame(width: 28, height: 28)
                            .background(AppColors.iconAccent.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
            }
        }
        .padding(AppSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
    
    private func notesCard(habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Notes")
                .font(AppFonts.headline())
                .foregroundColor(AppColors.textPrimary)
            
            Text(habit.description)
                .font(AppFonts.body())
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
    
    private func markCompleteButton(habit: Habit) -> some View {
        let isCompletedToday = viewModel.isHabitCompletedToday(id: habitId)
        
        return Button(action: {
            viewModel.toggleHabitCompletion(id: habitId)
        }) {
            HStack {
                Image(systemName: isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isCompletedToday ? AppColors.lightGreen : AppColors.iconAccent)
                
                Text(isCompletedToday ? "Completed today" : "Mark as done today")
                    .font(AppFonts.headline())
                    .foregroundColor(AppColors.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(isCompletedToday ? AppColors.lightGreen.opacity(0.2) : AppColors.iconAccent.opacity(0.2))
            .cornerRadius(AppCornerRadius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                        .stroke(isCompletedToday ? AppColors.lightGreen : AppColors.iconAccent, lineWidth: 1)
            )
        }
        .disabled(isCompletedToday)
    }
    
    private var habitNotFoundView: some View {
        VStack(spacing: AppSpacing.lg) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 48))
                .foregroundColor(AppColors.textTertiary)
            
            Text("Habit not found")
                .font(AppFonts.title3())
                .foregroundColor(AppColors.textPrimary)
            
            Text("It may have been deleted.")
                .font(AppFonts.body())
                .foregroundColor(AppColors.textSecondary)
            
            Button("Go Back") {
                dismiss()
            }
            .font(AppFonts.headline())
                    .foregroundColor(AppColors.iconAccent)
            .padding(.top, AppSpacing.md)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColors.backgroundGradient.ignoresSafeArea())
    }
}

struct EditHabitView: View {
    let habitId: UUID
    @ObservedObject var viewModel: HabitsViewModel
    let initialHabit: Habit
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedCategory: HabitCategory = .selfCare
    @State private var selectedFrequency: HabitFrequency = .daily
    @State private var selectedIcon: String = "star"
    @State private var description: String = ""
    
    private let availableIcons = [
        "star", "heart", "leaf", "flame", "drop", "moon", "sun.max",
        "figure.walk", "dumbbell", "book", "paintbrush", "music.note",
        "camera", "gamecontroller", "cup.and.saucer", "fork.knife"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.md) {
                        EntryCard(title: "Habit Name", icon: "pencil") {
                            TextField("Enter habit name", text: $name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        EntryCard(title: "Category", icon: "folder") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: AppSpacing.sm) {
                                ForEach(HabitCategory.allCases, id: \.self) { category in
                                    Button(action: { selectedCategory = category }) {
                                        VStack(spacing: AppSpacing.xs) {
                                            Image(systemName: category.icon)
                                            Text(category.rawValue)
                                                .font(AppFonts.caption())
                                        }
                                            .foregroundColor(selectedCategory == category ? AppColors.iconSecondary : AppColors.textPrimary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, AppSpacing.sm)
                                        .background(selectedCategory == category ? AppColors.iconAccent : AppColors.cardBackground)
                                        .cornerRadius(AppCornerRadius.sm)
                                    }
                                }
                            }
                        }
                        
                        EntryCard(title: "Icon", icon: "star") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: AppSpacing.sm) {
                                ForEach(availableIcons, id: \.self) { icon in
                                    Button(action: { selectedIcon = icon }) {
                                        Image(systemName: icon)
                                            .font(.system(size: 20))
                                            .foregroundColor(selectedIcon == icon ? AppColors.iconSecondary : AppColors.textPrimary)
                                            .frame(width: 40, height: 40)
                                                .background(selectedIcon == icon ? AppColors.iconAccent : AppColors.cardBackground)
                                            .cornerRadius(AppCornerRadius.sm)
                                    }
                                }
                            }
                        }
                        
                        EntryCard(title: "Frequency", icon: "calendar") {
                            HStack(spacing: AppSpacing.sm) {
                                ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                                    Button(action: { selectedFrequency = frequency }) {
                                        Text(frequency.rawValue)
                                            .font(AppFonts.callout())
                                            .foregroundColor(selectedFrequency == frequency ? AppColors.iconSecondary : AppColors.textPrimary)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, AppSpacing.sm)
                                                .background(selectedFrequency == frequency ? AppColors.iconAccent : AppColors.cardBackground)
                                            .cornerRadius(AppCornerRadius.sm)
                                    }
                                }
                            }
                        }
                        
                        EntryCard(title: "Why is this important? (Optional)", icon: "text.quote") {
                            TextField("Enter description", text: $description, axis: .vertical)
                                .textFieldStyle(CustomTextFieldStyle())
                                .lineLimit(3...6)
                        }
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
            }
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(AppColors.textPrimary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let updated = Habit(
                            id: initialHabit.id,
                            name: name,
                            category: selectedCategory,
                            frequency: selectedFrequency,
                            icon: selectedIcon,
                            description: description,
                            createdDate: initialHabit.createdDate,
                            completedDates: initialHabit.completedDates,
                            isActive: initialHabit.isActive
                        )
                        viewModel.updateHabit(updated)
                        dismiss()
                    }
                    .foregroundColor(AppColors.iconAccent)
                    .disabled(name.isEmpty)
                }
            }
        }
        .onAppear {
            name = initialHabit.name
            selectedCategory = initialHabit.category
            selectedFrequency = initialHabit.frequency
            selectedIcon = initialHabit.icon
            description = initialHabit.description
        }
    }
}
