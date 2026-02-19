import SwiftUI

struct HabitDetailSheetItem: Identifiable {
    let id: UUID
}

struct HabitsListView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var showingAddHabit = false
    @State private var selectedHabitId: HabitDetailSheetItem?
    
    var body: some View {
        ZStack {
            AnimatedBackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Habits")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(DesignConstants.Colors.white)
                    
                    Spacer()
                    
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(DesignConstants.Colors.primaryYellow)
                    }
                }
                .padding(.horizontal, DesignConstants.Spacing.lg)
                .padding(.vertical, DesignConstants.Spacing.md)
                
                if appViewModel.appState.habits.isEmpty {
                    Spacer()
                    EmptyHabitsView {
                        showingAddHabit = true
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: DesignConstants.Spacing.md) {
                            ForEach(appViewModel.appState.habits) { habit in
                                HabitCardView(habit: habit) {
                                    selectedHabitId = HabitDetailSheetItem(id: habit.id)
                                } onToggle: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        appViewModel.toggleHabitCompletion(habit.id)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, DesignConstants.Spacing.lg)
                        .padding(.top, DesignConstants.Spacing.lg)
                        .padding(.bottom, 120) 
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView { habit in
                appViewModel.addHabit(habit)
            }
        }
        .sheet(item: $selectedHabitId) { item in
            HabitDetailView(
                habitId: item.id,
                getHabit: { appViewModel.appState.habits.first(where: { $0.id == item.id }) },
                onSave: { appViewModel.updateHabit($0) },
                onDelete: {
                    appViewModel.deleteHabit(item.id)
                    selectedHabitId = nil
                }
            )
        }
    }
}

struct EmptyHabitsView: View {
    let onAddHabit: () -> Void
    
    var body: some View {
        VStack(spacing: DesignConstants.Spacing.lg) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 60))
                .foregroundColor(DesignConstants.Colors.white.opacity(0.5))
            
            VStack(spacing: DesignConstants.Spacing.sm) {
                Text("No habits yet")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(DesignConstants.Colors.white)
                
                Text("Add your first habit and start taking care of yourself")
                    .font(.ubuntu(16))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            Button(action: onAddHabit) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Add Habit")
                        .font(.ubuntu(16, weight: .medium))
                }
                .foregroundColor(DesignConstants.Colors.primaryBlue)
                .padding(.horizontal, DesignConstants.Spacing.lg)
                .padding(.vertical, DesignConstants.Spacing.md)
                .background(DesignConstants.Colors.primaryYellow)
                .cornerRadius(DesignConstants.CornerRadius.large)
            }
        }
        .padding(.horizontal, DesignConstants.Spacing.xl)
    }
}

struct HabitCardView: View {
    let habit: Habit
    let onTap: () -> Void
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: DesignConstants.Spacing.md) {
                HStack(spacing: DesignConstants.Spacing.md) {
                    Button(action: onToggle) {
                        Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 28))
                            .foregroundColor(habit.isCompleted ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.5))
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.title)
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(DesignConstants.Colors.white)
                            .strikethrough(habit.isCompleted)
                            .multilineTextAlignment(.leading)
                        
                        HStack {
                            if let category = AppConstants.habitCategories.first(where: { $0.id == habit.category }) {
                                Image(systemName: category.icon)
                                    .font(.system(size: 12))
                                    .foregroundColor(DesignConstants.Colors.white.opacity(0.6))
                                
                                Text(category.name)
                                    .font(.ubuntu(12))
                                    .foregroundColor(DesignConstants.Colors.white.opacity(0.6))
                            }
                            
                            Text("• \(habit.frequency.displayName)")
                                .font(.ubuntu(12))
                                .foregroundColor(DesignConstants.Colors.white.opacity(0.6))
                        }
                    }
                    
                    Spacer()
                    
                    if habit.currentStreak > 0 {
                        VStack(spacing: 2) {
                            Text("\(habit.currentStreak)")
                                .font(.ubuntu(20, weight: .bold))
                                .foregroundColor(DesignConstants.Colors.primaryYellow)
                            
                            Text("day\(habit.currentStreak == 1 ? "" : "s")")
                                .font(.ubuntu(10))
                                .foregroundColor(DesignConstants.Colors.primaryYellow.opacity(0.8))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(DesignConstants.Colors.primaryYellow.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                
                ProgressBar(
                    progress: habit.isCompleted ? 1.0 : 0.0,
                    color: habit.isCompleted ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.3)
                )
            }
            .padding(DesignConstants.Spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.large)
                    .fill(DesignConstants.Colors.white.opacity(0.1))
                    .background(
                        RoundedRectangle(cornerRadius: DesignConstants.CornerRadius.large)
                            .stroke(DesignConstants.Colors.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(habit.isCompleted ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: habit.isCompleted)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ProgressBar: View {
    let progress: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(DesignConstants.Colors.white.opacity(0.2))
                    .frame(height: 4)
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: geometry.size.width * progress, height: 4)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 4)
    }
}

struct HabitDetailView: View {
    let habitId: UUID
    let getHabit: () -> Habit?
    let onSave: (Habit) -> Void
    let onDelete: () -> Void
    
    @State private var isEditing = false
    @Environment(\.dismiss) private var dismiss
    
    private var habit: Habit? {
        getHabit()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                if let habit = habit {
                    ScrollView {
                        VStack(spacing: DesignConstants.Spacing.lg) {
                            VStack(spacing: DesignConstants.Spacing.md) {
                                Image(systemName: habit.icon)
                                    .font(.system(size: 60))
                                    .foregroundColor(DesignConstants.Colors.primaryYellow)
                                
                                Text(habit.title)
                                    .font(.ubuntu(24, weight: .bold))
                                    .foregroundColor(DesignConstants.Colors.white)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, DesignConstants.Spacing.lg)
                            
                            HStack(spacing: DesignConstants.Spacing.lg) {
                                StatView(
                                    title: "Current Streak",
                                    value: "\(habit.currentStreak)",
                                    subtitle: "days"
                                )
                                
                                StatView(
                                    title: "Frequency",
                                    value: habit.frequency.displayName,
                                    subtitle: ""
                                )
                                
                                StatView(
                                    title: "Total Days",
                                    value: "\(habit.completedDates.count)",
                                    subtitle: "completed"
                                )
                            }
                            
                            if !habit.note.isEmpty {
                                VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                                    Text("Why this matters")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(DesignConstants.Colors.white)
                                    
                                    Text(habit.note)
                                        .font(.ubuntu(16))
                                        .foregroundColor(DesignConstants.Colors.white.opacity(0.8))
                                        .padding()
                                        .background(DesignConstants.Colors.white.opacity(0.1))
                                        .cornerRadius(DesignConstants.CornerRadius.medium)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                                Text("Recent Activity")
                                    .font(.ubuntu(16, weight: .medium))
                                    .foregroundColor(DesignConstants.Colors.white)
                                
                                HabitCalendarView(completedDates: habit.completedDates)
                            }
                        }
                        .padding(DesignConstants.Spacing.lg)
                    }
                } else {
                    VStack(spacing: DesignConstants.Spacing.lg) {
                        Text("Habit not found")
                            .font(.ubuntu(18))
                            .foregroundColor(DesignConstants.Colors.white.opacity(0.8))
                        
                        Button("Close") {
                            dismiss()
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(DesignConstants.Colors.primaryYellow)
                    }
                }
            }
            .navigationTitle("Habit Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(DesignConstants.Colors.white)
                }
                
                if habit != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Edit") {
                                isEditing = true
                            }
                            
                            Button("Delete", role: .destructive) {
                                onDelete()
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(DesignConstants.Colors.white)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            if let habit = habit {
                EditHabitView(habit: habit, onSave: { updatedHabit in
                    onSave(updatedHabit)
                })
            }
        }
    }
}

struct StatView: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.ubuntu(12))
                .foregroundColor(DesignConstants.Colors.white.opacity(0.7))
            
            Text(value)
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(DesignConstants.Colors.primaryYellow)
            
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.ubuntu(10))
                    .foregroundColor(DesignConstants.Colors.white.opacity(0.6))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .background(DesignConstants.Colors.white.opacity(0.1))
        .cornerRadius(DesignConstants.CornerRadius.medium)
    }
}

struct HabitCalendarView: View {
    let completedDates: [Date]
    @State private var currentMonth = Date()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(DesignConstants.Colors.white)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(DesignConstants.Colors.white)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(DesignConstants.Colors.white)
                }
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 4) {
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { _, date in
                    if let date = date {
                        CalendarDayView(
                            date: date,
                            isCompleted: isDateCompleted(date),
                            isToday: Calendar.current.isDateInToday(date)
                        )
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                            .frame(height: 32)
                    }
                }
            }
        }
        .padding()
        .background(DesignConstants.Colors.white.opacity(0.1))
        .cornerRadius(DesignConstants.CornerRadius.medium)
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private var daysInMonth: [Date?] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? currentMonth
        let range = calendar.range(of: .day, in: .month, for: currentMonth) ?? 1..<32
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        let numberOfDays = range.count
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in 1...numberOfDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func isDateCompleted(_ date: Date) -> Bool {
        completedDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
    }
    
    private func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
    
    private func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
}

struct CalendarDayView: View {
    let date: Date
    let isCompleted: Bool
    let isToday: Bool
    
    var body: some View {
        Text("\(Calendar.current.component(.day, from: date))")
            .font(.ubuntu(14, weight: isToday ? .bold : .regular))
            .foregroundColor(
                isCompleted ? DesignConstants.Colors.primaryBlue :
                isToday ? DesignConstants.Colors.primaryYellow :
                DesignConstants.Colors.white.opacity(0.7)
            )
            .frame(width: 32, height: 32)
            .background(
                Circle()
                    .fill(
                        isCompleted ? DesignConstants.Colors.primaryYellow :
                        isToday ? DesignConstants.Colors.primaryYellow.opacity(0.2) :
                        Color.clear
                    )
            )
    }
}

struct EditHabitView: View {
    private let habit: Habit
    @State private var title: String
    @State private var note: String
    @State private var selectedCategory: HabitCategory
    @State private var selectedIcon: String
    @State private var selectedFrequency: HabitFrequency
    @Environment(\.dismiss) private var dismiss
    let onSave: (Habit) -> Void
    
    init(habit: Habit, onSave: @escaping (Habit) -> Void) {
        self.habit = habit
        self._title = State(initialValue: habit.title)
        self._note = State(initialValue: habit.note)
        self._selectedCategory = State(initialValue: AppConstants.habitCategories.first { $0.id == habit.category } ?? AppConstants.habitCategories[0])
        self._selectedIcon = State(initialValue: habit.icon)
        self._selectedFrequency = State(initialValue: habit.frequency)
        self.onSave = onSave
    }
    
    var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackgroundView()
                
                ScrollView {
                    VStack(spacing: DesignConstants.Spacing.lg) {
                        VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                            Text("Habit Name")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(DesignConstants.Colors.white)
                            
                            TextField("Enter habit name", text: $title)
                                .font(.ubuntu(16))
                                .foregroundColor(DesignConstants.Colors.white)
                                .padding()
                                .background(DesignConstants.Colors.white.opacity(0.1))
                                .cornerRadius(DesignConstants.CornerRadius.medium)
                        }
                        
                        VStack(alignment: .leading, spacing: DesignConstants.Spacing.sm) {
                            Text("Why is this important?")
                                .font(.ubuntu(16, weight: .medium))
                                .foregroundColor(DesignConstants.Colors.white)
                            
                            TextField("Add a note...", text: $note, axis: .vertical)
                                .font(.ubuntu(16))
                                .foregroundColor(DesignConstants.Colors.white)
                                .padding()
                                .background(DesignConstants.Colors.white.opacity(0.1))
                                .cornerRadius(DesignConstants.CornerRadius.medium)
                                .lineLimit(3...6)
                        }
                    }
                    .padding(DesignConstants.Spacing.lg)
                }
            }
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(DesignConstants.Colors.white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let updatedHabit = Habit(
                            id: habit.id,
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            category: selectedCategory.id,
                            icon: selectedIcon,
                            frequency: selectedFrequency,
                            note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                            createdDate: habit.createdDate,
                            completedDates: habit.completedDates
                        )
                        onSave(updatedHabit)
                        dismiss()
                    }
                    .foregroundColor(canSave ? DesignConstants.Colors.primaryYellow : DesignConstants.Colors.white.opacity(0.5))
                    .disabled(!canSave)
                }
            }
        }
    }
}

#Preview {
    HabitsListView()
        .environmentObject(AppViewModel())
}
