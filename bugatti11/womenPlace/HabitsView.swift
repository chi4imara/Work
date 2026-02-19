import SwiftUI

struct HabitsView: View {
    @EnvironmentObject var viewModel: DailyEntryViewModel
    @State private var showingAddHabit = false
    @State private var selectedHabitId: UUID?
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 8) {
                        Text("Daily Habits")
                            .font(AppFonts.playfairBold(size: 28))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("Small steps, big changes")
                            .font(AppFonts.playfairRegular(size: 16))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    if !viewModel.habits.isEmpty {
                        OverallStreakView(habits: viewModel.habits)
                    }
                    
                    Button(action: {
                        showingAddHabit = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            Text("New Habit")
                                .font(AppFonts.playfairSemiBold(size: 16))
                                .foregroundColor(AppColors.primaryBlue)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.accentYellow)
                        .cornerRadius(25)
                    }
                    .padding(.horizontal, 20)
                    
                    if viewModel.habits.isEmpty {
                        EmptyHabitsView()
                    } else {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.habits) { habit in
                                HabitCardView(habit: habit) { habit in
                                    withAnimation(.spring(response: 0.3)) {
                                        viewModel.toggleTaskCompletion(habit)
                                    }
                                } onTap: { habit in
                                    selectedHabitId = habit.id
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView { habit in
                viewModel.addTask(habit)
            }
        }
        .sheet(isPresented: Binding(
            get: { selectedHabitId != nil },
            set: { if !$0 { selectedHabitId = nil } }
        )) {
            if let habitId = selectedHabitId {
                HabitDetailView(viewModel: viewModel, habitId: habitId)
            } else {
                EmptyView()
            }
        }
    }
}

struct OverallStreakView: View {
    let habits: [TaskG]
    
    private var totalActiveStreaks: Int {
        habits.filter { $0.streak > 0 }.count
    }
    
    private var longestStreak: Int {
        habits.map { $0.streak }.max() ?? 0
    }
    
    var body: some View {
        HStack(spacing: 30) {
            StreakStatView(
                title: "Active Habits",
                value: "\(totalActiveStreaks)",
                icon: "flame.fill"
            )
            
            StreakStatView(
                title: "Longest Streak",
                value: "\(longestStreak)",
                icon: "star.fill"
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
        .padding(.horizontal, 20)
    }
}

struct StreakStatView: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(AppColors.accentYellow)
            
            Text(value)
                .font(AppFonts.playfairBold(size: 24))
                .foregroundColor(AppColors.primaryText)
            
            Text(title)
                .font(AppFonts.playfairRegular(size: 12))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct HabitCardView: View {
    let habit: TaskG
    let onToggle: (TaskG) -> Void
    let onTap: (TaskG) -> Void
    
    var body: some View {
        Button(action: {
            onTap(habit)
        }) {
            HStack(spacing: 15) {
                Button(action: {
                    onToggle(habit)
                }) {
                    Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(habit.isCompleted ? AppColors.lightGreen : AppColors.secondaryText)
                }
                .buttonStyle(PlainButtonStyle())
                
                Image(systemName: habit.icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.accentYellow)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.title)
                        .font(AppFonts.playfairMedium(size: 16))
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    if habit.streak > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.accentYellow)
                            
                            Text("\(habit.streak) day streak")
                                .font(AppFonts.playfairRegular(size: 12))
                                .foregroundColor(AppColors.accentYellow)
                        }
                    } else {
                        Text("Start your streak today!")
                            .font(AppFonts.playfairRegular(size: 12))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
                
                Spacer()
                
                StreakVisualizationView(streak: habit.streak)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.1))
                    .backdrop(blur: 10)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StreakVisualizationView: View {
    let streak: Int
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<min(streak, 7), id: \.self) { _ in
                Circle()
                    .fill(AppColors.accentYellow)
                    .frame(width: 6, height: 6)
            }
            
            if streak > 7 {
                Text("+\(streak - 7)")
                    .font(AppFonts.playfairRegular(size: 10))
                    .foregroundColor(AppColors.accentYellow)
            }
        }
    }
}

struct EmptyHabitsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "leaf.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.accentYellow.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("Start Small, Dream Big")
                    .font(AppFonts.playfairSemiBold(size: 20))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add your first habit and begin your journey to positive change.")
                    .font(AppFonts.playfairRegular(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
        .padding(.horizontal, 20)
    }
}

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var habitTitle = ""
    @State private var selectedIcon = "leaf"
    
    let onSave: (TaskG) -> Void
    
    private let habitIcons = [
        "leaf", "drop.fill", "flame.fill", "heart.fill", "star.fill",
        "book.fill", "pencil", "music.note", "camera.fill", "gamecontroller.fill",
        "dumbbell.fill", "figure.walk", "bed.double.fill", "cup.and.saucer.fill"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AppBackgroundView()
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Habit Name")
                                .font(AppFonts.playfairMedium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter habit name", text: $habitTitle)
                                .font(AppFonts.playfairRegular(size: 16))
                                .foregroundColor(AppColors.primaryText)
                                .padding(15)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.1))
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Choose Icon")
                                .font(AppFonts.playfairMedium(size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 15) {
                                ForEach(habitIcons, id: \.self) { icon in
                                    Button(action: {
                                        selectedIcon = icon
                                    }) {
                                        Image(systemName: icon)
                                            .font(.system(size: 20))
                                            .foregroundColor(selectedIcon == icon ? AppColors.primaryBlue : AppColors.primaryText)
                                            .frame(width: 50, height: 50)
                                            .background(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(selectedIcon == icon ? AppColors.accentYellow : Color.white.opacity(0.1))
                                            )
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveHabit()
                    }
                    .foregroundColor(habitTitle.isEmpty ? AppColors.secondaryText : AppColors.accentYellow)
                    .disabled(habitTitle.isEmpty)
                }
            }
        }
    }
    
    private func saveHabit() {
        let habit = TaskG(
            title: habitTitle,
            isHabit: true,
            icon: selectedIcon,
            repeatDaily: true
        )
        
        onSave(habit)
        dismiss()
    }
}

struct HabitDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: DailyEntryViewModel
    let habitId: UUID
    
    private var habit: TaskG? {
        viewModel.habits.first { $0.id == habitId }
    }
    
    var body: some View {
        Group {
            if let habit = habit {
                habitDetailContent(habit: habit)
            } else {
                habitNotFoundContent
            }
        }
        .navigationTitle("Habit Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(AppColors.primaryText)
            }
            
            if habit != nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Delete") {
                        if let h = viewModel.habits.first(where: { $0.id == habitId }) {
                            viewModel.deleteTask(h)
                        }
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
    
    private func habitDetailContent(habit: TaskG) -> some View {
        NavigationView {
            ZStack {
                AppBackgroundView()
                
                ScrollView {
                    VStack(spacing: 25) {
                        VStack(spacing: 15) {
                            Image(systemName: habit.icon)
                                .font(.system(size: 50))
                                .foregroundColor(AppColors.accentYellow)
                            
                            Text(habit.title)
                                .font(AppFonts.playfairBold(size: 24))
                                .foregroundColor(AppColors.primaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 15) {
                            Text("Current Streak")
                                .font(AppFonts.playfairMedium(size: 18))
                                .foregroundColor(AppColors.primaryText)
                            
                            HStack {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(AppColors.accentYellow)
                                
                                Text("\(habit.streak)")
                                    .font(AppFonts.playfairBold(size: 36))
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text("days")
                                    .font(AppFonts.playfairRegular(size: 18))
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.1))
                                .backdrop(blur: 10)
                        )
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Recent Activity")
                                .font(AppFonts.playfairMedium(size: 18))
                                .foregroundColor(AppColors.primaryText)
                            
                            RecentActivityView(completedDates: habit.completedDates)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.1))
                                .backdrop(blur: 10)
                        )
                        
                        Spacer(minLength: 50)
                    }
                    .padding(20)
                }
            }
        }
    }
    
    private var habitNotFoundContent: some View {
        NavigationView {
            ZStack {
                AppBackgroundView()
                VStack(spacing: 20) {
                    Text("Habit not found")
                        .font(AppFonts.playfairMedium(size: 18))
                        .foregroundColor(AppColors.primaryText)
                    Button("Done") { dismiss() }
                        .foregroundColor(AppColors.accentYellow)
                }
            }
        }
    }
}

struct RecentActivityView: View {
    let completedDates: [Date]
    private let calendar = Calendar.current
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            ForEach(0..<14, id: \.self) { dayOffset in
                let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) ?? Date()
                let isCompleted = completedDates.contains { calendar.isDate($0, inSameDayAs: date) }
                
                VStack(spacing: 4) {
                    Text("\(calendar.component(.day, from: date))")
                        .font(AppFonts.playfairRegular(size: 12))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Circle()
                        .fill(isCompleted ? AppColors.accentYellow : Color.white.opacity(0.2))
                        .frame(width: 20, height: 20)
                }
            }
        }
    }
}
