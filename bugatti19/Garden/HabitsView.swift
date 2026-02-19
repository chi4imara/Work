import SwiftUI

struct HabitsView: View {
    @ObservedObject var viewModel: HabitsViewModel
    @State private var showingNewHabit = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                categoryFilter
                
                if viewModel.filteredHabits.isEmpty {
                    emptyStateView
                } else {
                    habitsListView
                }
            }
        }
        .sheet(isPresented: $showingNewHabit) {
            NewHabitView { habit in
                viewModel.addHabit(habit)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Habits")
                    .font(AppFonts.title2())
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Build healthy routines")
                    .font(AppFonts.callout())
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: { showingNewHabit = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.iconSecondary)
                    .frame(width: 44, height: 44)
                    .background(AppColors.iconAccent)
                    .cornerRadius(22)
                    .shadow(color: AppShadows.medium, radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.top, AppSpacing.sm)
    }
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                CategoryFilterButton(
                    title: "All",
                    isSelected: viewModel.selectedCategory == nil,
                    action: { viewModel.selectedCategory = nil }
                )
                
                ForEach(HabitCategory.allCases, id: \.self) { category in
                    CategoryFilterButton(
                        title: category.rawValue,
                        isSelected: viewModel.selectedCategory == category,
                        action: { viewModel.selectedCategory = category }
                    )
                }
            }
            .padding(.horizontal, AppSpacing.md)
        }
        .padding(.vertical, AppSpacing.sm)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            Image(systemName: "star.circle")
                .font(.system(size: 64))
                .foregroundColor(AppColors.iconAccent.opacity(0.8))
            
            VStack(spacing: AppSpacing.sm) {
                Text("No habits yet")
                    .font(AppFonts.title3())
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Add your first habit and start taking care of yourself")
                    .font(AppFonts.body())
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingNewHabit = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add First Habit")
                }
                .font(AppFonts.headline())
                .foregroundColor(AppColors.iconSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.primaryYellow)
                .cornerRadius(AppCornerRadius.lg)
            }
            .padding(.horizontal, AppSpacing.xl)
            
            Spacer()
        }
    }
    
    private var habitsListView: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(viewModel.filteredHabits) { habit in
                    HabitCardView(habit: habit, viewModel: viewModel) {
                        viewModel.toggleHabitCompletion(id: habit.id)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.bottom, AppSpacing.lg)
            .padding(.bottom, 100)
        }
        .navigationDestination(for: UUID.self) { habitId in
            HabitDetailView(habitId: habitId, viewModel: viewModel)
        }
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFonts.callout())
                .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    isSelected ? AppColors.primaryYellow : AppColors.cardBackground
                )
                .cornerRadius(AppCornerRadius.lg)
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.lg)
                        .stroke(
                            isSelected ? AppColors.primaryYellow : AppColors.cardBorder,
                            lineWidth: 1
                        )
                )
        }
    }
}

struct HabitCardView: View {
    let habit: Habit
    @ObservedObject var viewModel: HabitsViewModel
    let onToggle: () -> Void
    @State private var isAnimating = false
    
    private var isCompletedToday: Bool {
        viewModel.isHabitCompletedToday(id: habit.id)
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            NavigationLink(value: habit.id) {
                VStack(alignment: .leading, spacing: AppSpacing.md) {
                    HStack(spacing: AppSpacing.sm) {
                        ZStack {
                            Circle()
                                .fill(habit.category.color.opacity(0.2))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: habit.icon)
                                .font(.system(size: 20))
                                .foregroundColor(AppColors.iconPrimary)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(habit.name)
                                .font(AppFonts.headline())
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text(habit.category.rawValue)
                                .font(AppFonts.caption())
                                .foregroundColor(AppColors.textSecondary)
                        }
                        
                        Spacer(minLength: 40)
                    }
                    
                    HStack {
                        if habit.currentStreak > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "flame")
                                    .foregroundColor(AppColors.iconAccent)
                                Text("\(habit.currentStreak) day streak")
                                    .font(AppFonts.caption())
                                    .foregroundColor(AppColors.textSecondary)
                            }
                        }
                        
                        Spacer()
                        
                        Text(habit.frequency.rawValue)
                            .font(AppFonts.caption())
                            .foregroundColor(AppColors.textTertiary)
                            .padding(.horizontal, AppSpacing.sm)
                            .padding(.vertical, AppSpacing.xs)
                            .background(AppColors.cardBackground)
                            .cornerRadius(AppCornerRadius.sm)
                    }
                }
                .padding(AppSpacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isAnimating = true
                    onToggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isAnimating = false
                }
            }) {
                Image(systemName: isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isCompletedToday ? AppColors.lightGreen : AppColors.iconAccent)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
            }
            .padding(.trailing, AppSpacing.md)
            .padding(.top, AppSpacing.md)
        }
        .background(AppColors.cardBackground)
        .cornerRadius(AppCornerRadius.md)
        .overlay(
            RoundedRectangle(cornerRadius: AppCornerRadius.md)
                .stroke(AppColors.cardBorder, lineWidth: 1)
        )
    }
}

struct NewHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var selectedCategory: HabitCategory = .selfCare
    @State private var selectedFrequency: HabitFrequency = .daily
    @State private var selectedIcon = "star"
    @State private var description = ""
    
    let onSave: (Habit) -> Void
    
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
                    VStack(spacing: AppSpacing.lg) {
                        VStack(spacing: AppSpacing.sm) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 48))
                                .foregroundColor(AppColors.iconAccent)
                            
                            Text("New Habit")
                                .font(AppFonts.title2())
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("Create a new healthy routine")
                                .font(AppFonts.callout())
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .padding(.top, AppSpacing.lg)
                        
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
                                                    .font(.system(size: 20))
                                                Text(category.rawValue)
                                                    .font(AppFonts.caption())
                                            }
                                            .foregroundColor(selectedCategory == category ? AppColors.iconSecondary : AppColors.textPrimary)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, AppSpacing.sm)
                                            .background(
                                                selectedCategory == category ? 
                                                AppColors.primaryYellow : 
                                                AppColors.cardBackground
                                            )
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
                                                .background(
                                                    selectedIcon == icon ? 
                                                    AppColors.iconAccent : 
                                                    AppColors.cardBackground
                                                )
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
                                                .background(
                                                    selectedFrequency == frequency ? 
                                                    AppColors.iconAccent : 
                                                    AppColors.cardBackground
                                                )
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
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        var habit = Habit(
                            name: name,
                            category: selectedCategory,
                            frequency: selectedFrequency,
                            icon: selectedIcon
                        )
                        habit.description = description
                        onSave(habit)
                        dismiss()
                    }
                    .foregroundColor(AppColors.iconSecondary)
                    .fontWeight(.medium)
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview("Habits View") {
    HabitsView(viewModel: HabitsViewModel())
}

#Preview("New Habit") {
    NewHabitView { _ in }
}
