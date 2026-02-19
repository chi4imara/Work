import SwiftUI

struct HabitDetailIdentifier: Identifiable {
    let id: UUID
}

struct HabitsView: View {
    @StateObject private var viewModel = HabitsViewModel()
    @State private var showingAddHabit = false
    @State private var selectedHabitId: HabitDetailIdentifier?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Habits & Mini-challenges")
                        .font(Theme.Fonts.playfairBold(size: 24))
                        .foregroundColor(Theme.Colors.text)
                    
                    Spacer()
                    
                    Button(action: { showingAddHabit = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Theme.Colors.primary)
                            .font(.title)
                    }
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.lg)
                
                if viewModel.habits.isEmpty {
                    EmptyHabitsView(showingAddHabit: $showingAddHabit)
                } else {
                    HabitsListView(viewModel: viewModel, selectedHabitId: $selectedHabitId)
                }
            }
        }
        .sheet(isPresented: $showingAddHabit) {
            AddEditHabitView(viewModel: viewModel)
        }
        .sheet(item: $selectedHabitId) { identifier in
            HabitDetailView(habitId: identifier.id, viewModel: viewModel)
        }
        .onAppear {
            viewModel.reloadHabits()
        }
    }
}

struct EmptyHabitsView: View {
    @Binding var showingAddHabit: Bool
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.Colors.primary.opacity(0.1),
                                Theme.Colors.primary.opacity(0.05)
                            ],
                            center: .center,
                            startRadius: 50,
                            endRadius: 150
                        )
                    )
                    .frame(width: 200, height: 200)
                
                Image(systemName: "star.circle")
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(Theme.Colors.primary)
            }
            
            VStack(spacing: Theme.Spacing.md) {
                Text("Add your first habit and start enjoying yourself")
                    .font(Theme.Fonts.playfairSemiBold(size: 20))
                    .foregroundColor(Theme.Colors.text)
                    .multilineTextAlignment(.center)
                
                Text("Create positive habits that bring joy to your daily routine")
                    .font(Theme.Fonts.playfairRegular(size: 16))
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, Theme.Spacing.lg)
            
            Button(action: { showingAddHabit = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add First Habit")
                }
                .font(Theme.Fonts.playfairSemiBold(size: 18))
                .foregroundColor(.white)
                .padding(.horizontal, Theme.Spacing.xl)
                .padding(.vertical, Theme.Spacing.md)
                .background(
                    RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                        .fill(
                            LinearGradient(
                                colors: [Theme.Colors.primary, Theme.Colors.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
            }
            
            Spacer()
        }
        .padding(.horizontal, Theme.Spacing.md)
    }
}

struct HabitsListView: View {
    @ObservedObject var viewModel: HabitsViewModel
    @Binding var selectedHabitId: HabitDetailIdentifier?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.Spacing.md) {
                ForEach(viewModel.habits) { habit in
                    HabitCard(habit: habit, onTap: {
                        selectedHabitId = HabitDetailIdentifier(id: habit.id)
                    }, onToggle: {
                        viewModel.toggleHabit(habit)
                    })
                }
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.top, Theme.Spacing.lg)
            .padding(.bottom, 120)
        }
    }
}

struct HabitCard: View {
    let habit: Habit
    let onTap: () -> Void
    let onToggle: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            ZStack {
                Circle()
                    .fill(habit.category.icon == "heart.fill" ? Theme.Colors.accent.opacity(0.2) : Theme.Colors.primary.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: habit.icon)
                    .foregroundColor(habit.category.icon == "heart.fill" ? Theme.Colors.accent : Theme.Colors.primary)
                    .font(.title2)
            }
            
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text(habit.name)
                        .font(Theme.Fonts.playfairSemiBold(size: 16))
                        .foregroundColor(Theme.Colors.text)
                        .lineLimit(1)
                    
                    HStack {
                        Text(habit.category.rawValue)
                            .font(Theme.Fonts.playfairRegular(size: 12))
                            .foregroundColor(Theme.Colors.textSecondary)
                        
                        Spacer()
                        
                        Text(habit.frequency.rawValue)
                            .font(Theme.Fonts.playfairRegular(size: 12))
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    
                    if habit.currentStreak > 0 {
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(Theme.Colors.accent)
                                .font(.caption)
                            
                            Text("\(habit.currentStreak) day streak")
                                .font(Theme.Fonts.playfairMedium(size: 12))
                                .foregroundColor(Theme.Colors.accent)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            Button(action: onToggle) {
                VStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(habit.isCompletedToday ? Theme.Colors.success : Theme.Colors.textSecondary)
                        .font(.title2)
                    
                    if habit.isCompletedToday {
                        Text("Done")
                            .font(Theme.Fonts.playfairRegular(size: 10))
                            .foregroundColor(Theme.Colors.success)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
                .shadow(color: Theme.Colors.primary.opacity(0.1), radius: isPressed ? 2 : 5, x: 0, y: isPressed ? 1 : 3)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(Theme.Animation.quick, value: isPressed)
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {
            onTap()
        }
    }
}

struct AddEditHabitView: View {
    @ObservedObject var viewModel: HabitsViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let habitToEdit: Habit?
    private let onSaveEdit: (() -> Void)?
    
    @State private var name = ""
    @State private var selectedCategory = HabitCategory.body
    @State private var selectedIcon = "star.fill"
    @State private var selectedFrequency = HabitFrequency.daily
    @State private var whyImportant = ""
    
    private var isEditing: Bool { habitToEdit != nil }
    
    init(viewModel: HabitsViewModel, habitToEdit: Habit? = nil, onSaveEdit: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.habitToEdit = habitToEdit
        self.onSaveEdit = onSaveEdit
        
        if let habit = habitToEdit {
            _name = State(initialValue: habit.name)
            _selectedCategory = State(initialValue: habit.category)
            _selectedIcon = State(initialValue: habit.icon)
            _selectedFrequency = State(initialValue: habit.frequency)
            _whyImportant = State(initialValue: habit.whyImportant)
        } else {
            _name = State(initialValue: "")
            _selectedCategory = State(initialValue: HabitCategory.body)
            _selectedIcon = State(initialValue: "star.fill")
            _selectedFrequency = State(initialValue: HabitFrequency.daily)
            _whyImportant = State(initialValue: "")
        }
    }
    
    private let availableIcons = [
        "star.fill", "heart.fill", "leaf.fill", "flame.fill", "bolt.fill",
        "figure.walk", "figure.run", "bed.double.fill", "book.fill", "paintbrush.fill",
        "music.note", "camera.fill", "phone.fill", "message.fill", "envelope.fill"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: Theme.Spacing.lg) {
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Habit Name")
                                .font(Theme.Fonts.playfairSemiBold(size: 16))
                                .foregroundColor(Theme.Colors.text)
                            
                            TextField("Enter habit name", text: $name)
                                .font(Theme.Fonts.playfairRegular(size: 14))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Category")
                                .font(Theme.Fonts.playfairSemiBold(size: 16))
                                .foregroundColor(Theme.Colors.text)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: Theme.Spacing.sm) {
                                ForEach(HabitCategory.allCases, id: \.self) { category in
                                    Button(action: { selectedCategory = category }) {
                                        VStack(spacing: Theme.Spacing.xs) {
                                            Image(systemName: category.icon)
                                                .font(.title2)
                                                .foregroundColor(selectedCategory == category ? .white : Theme.Colors.primary)
                                            
                                            Text(category.rawValue)
                                                .font(Theme.Fonts.playfairRegular(size: 12))
                                                .foregroundColor(selectedCategory == category ? .white : Theme.Colors.text)
                                        }
                                        .frame(height: 60)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                                                .fill(selectedCategory == category ? Theme.Colors.primary : Theme.Colors.background.opacity(0.5))
                                        )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Choose Icon")
                                .font(Theme.Fonts.playfairSemiBold(size: 16))
                                .foregroundColor(Theme.Colors.text)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: Theme.Spacing.sm) {
                                ForEach(availableIcons, id: \.self) { icon in
                                    Button(action: { selectedIcon = icon }) {
                                        Image(systemName: icon)
                                            .font(.title2)
                                            .foregroundColor(selectedIcon == icon ? .white : Theme.Colors.primary)
                                            .frame(width: 40, height: 40)
                                            .background(
                                                RoundedRectangle(cornerRadius: Theme.CornerRadius.sm)
                                                    .fill(selectedIcon == icon ? Theme.Colors.primary : Theme.Colors.background.opacity(0.5))
                                            )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Frequency")
                                .font(Theme.Fonts.playfairSemiBold(size: 16))
                                .foregroundColor(Theme.Colors.text)
                            
                            VStack(spacing: Theme.Spacing.xs) {
                                ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                                    Button(action: { selectedFrequency = frequency }) {
                                        HStack {
                                            Image(systemName: selectedFrequency == frequency ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(selectedFrequency == frequency ? Theme.Colors.primary : Theme.Colors.textSecondary)
                                            
                                            Text(frequency.rawValue)
                                                .font(Theme.Fonts.playfairRegular(size: 14))
                                                .foregroundColor(Theme.Colors.text)
                                            
                                            Spacer()
                                        }
                                        .padding(.vertical, Theme.Spacing.sm)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Why is this important? (Optional)")
                                .font(Theme.Fonts.playfairSemiBold(size: 16))
                                .foregroundColor(Theme.Colors.text)
                            
                            TextField("Your motivation...", text: $whyImportant, axis: .vertical)
                                .font(Theme.Fonts.playfairRegular(size: 14))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(3)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.bottom, Theme.Spacing.xl)
                }
            }
            .navigationTitle(isEditing ? "Edit Habit" : "New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Theme.Colors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let existing = habitToEdit {
                            var updatedHabit = existing
                            updatedHabit.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                            updatedHabit.category = selectedCategory
                            updatedHabit.icon = selectedIcon
                            updatedHabit.frequency = selectedFrequency
                            updatedHabit.whyImportant = whyImportant
                            viewModel.updateHabit(updatedHabit)
                            onSaveEdit?()
                            dismiss()
                        } else {
                            let habit = Habit(
                                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                                category: selectedCategory,
                                icon: selectedIcon,
                                frequency: selectedFrequency,
                                whyImportant: whyImportant
                            )
                            viewModel.addHabit(habit)
                            dismiss()
                        }
                    }
                    .foregroundColor(Theme.Colors.primary)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

struct HabitDetailView: View {
    let habitId: UUID
    @ObservedObject var viewModel: HabitsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    
    private var habit: Habit? {
        viewModel.habits.first { $0.id == habitId }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if let habit = habit {
                    habitDetailContent(habit: habit)
                } else {
                    habitNotFoundContent
                }
            }
            .navigationTitle("Habit Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Theme.Colors.textSecondary)
                }
                
                if habit != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Edit", systemImage: "pencil") {
                                showingEditSheet = true
                            }
                            
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                showingDeleteAlert = true
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(Theme.Colors.primary)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            if let habit = habit {
                AddEditHabitView(viewModel: viewModel, habitToEdit: habit, onSaveEdit: {
                    dismiss()
                })
            }
        }
        .alert("Delete Habit", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let habit = habit {
                    viewModel.deleteHabit(habit)
                    dismiss()
                }
            }
        } message: {
            Text("Are you sure you want to delete this habit? This action cannot be undone.")
        }
    }
    
    private func habitDetailContent(habit: Habit) -> some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: Theme.Spacing.lg) {
                    VStack(spacing: Theme.Spacing.md) {
                        ZStack {
                            Circle()
                                .fill(Theme.Colors.primary.opacity(0.2))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: habit.icon)
                                .foregroundColor(Theme.Colors.primary)
                                .font(.system(size: 30))
                        }
                        
                        Text(habit.name)
                            .font(Theme.Fonts.playfairBold(size: 24))
                            .foregroundColor(Theme.Colors.text)
                            .multilineTextAlignment(.center)
                        
                        Text(habit.category.rawValue)
                            .font(Theme.Fonts.playfairRegular(size: 16))
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    
                    HStack(spacing: Theme.Spacing.lg) {
                        StatCard(title: "Current Streak", value: "\(habit.currentStreak)", subtitle: "days")
                        StatCard(title: "Total Days", value: "\(habit.completedDates.count)", subtitle: "completed")
                    }
                    
                    if !habit.whyImportant.isEmpty {
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Why This Matters")
                                .font(Theme.Fonts.playfairSemiBold(size: 18))
                                .foregroundColor(Theme.Colors.text)
                            
                            Text(habit.whyImportant)
                                .font(Theme.Fonts.playfairRegular(size: 14))
                                .foregroundColor(Theme.Colors.textSecondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                                .fill(Theme.Colors.background.opacity(0.8))
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        Text("Recent Activity")
                            .font(Theme.Fonts.playfairSemiBold(size: 18))
                            .foregroundColor(Theme.Colors.text)
                        
                        let last7Days = (0..<7).map { Calendar.current.date(byAdding: .day, value: -$0, to: Date())! }
                        
                        HStack {
                            ForEach(last7Days.reversed(), id: \.self) { date in
                                VStack(spacing: Theme.Spacing.xs) {
                                    Text(DateFormatter.dayOfWeek.string(from: date))
                                        .font(Theme.Fonts.playfairRegular(size: 10))
                                        .foregroundColor(Theme.Colors.textSecondary)
                                    
                                    Circle()
                                        .fill(habit.completedDates.contains { Calendar.current.isDate($0, inSameDayAs: date) } ? Theme.Colors.success : Theme.Colors.textSecondary.opacity(0.3))
                                        .frame(width: 20, height: 20)
                                    
                                    Text(DateFormatter.dayNumber.string(from: date))
                                        .font(Theme.Fonts.playfairRegular(size: 10))
                                        .foregroundColor(Theme.Colors.textSecondary)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                            .fill(Theme.Colors.background.opacity(0.8))
                    )
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.bottom, Theme.Spacing.xl)
            }
        }
    }
    
    private var habitNotFoundContent: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: Theme.Spacing.lg) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 60))
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Text("Habit not found")
                    .font(Theme.Fonts.playfairSemiBold(size: 18))
                    .foregroundColor(Theme.Colors.text)
                
                Text("It may have been deleted.")
                    .font(Theme.Fonts.playfairRegular(size: 14))
                    .foregroundColor(Theme.Colors.textSecondary)
                
                Button("Close") {
                    dismiss()
                }
                .font(Theme.Fonts.playfairSemiBold(size: 16))
                .foregroundColor(Theme.Colors.primary)
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Text(value)
                .font(Theme.Fonts.playfairBold(size: 24))
                .foregroundColor(Theme.Colors.primary)
            
            Text(subtitle)
                .font(Theme.Fonts.playfairRegular(size: 12))
                .foregroundColor(Theme.Colors.textSecondary)
            
            Text(title)
                .font(Theme.Fonts.playfairMedium(size: 14))
                .foregroundColor(Theme.Colors.text)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
}

extension DateFormatter {
    static let dayOfWeek: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter
    }()
    
    static let dayNumber: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
}

#Preview {
    HabitsView()
}
