import SwiftUI

struct HabitDetailView: View {
    let habitId: UUID
    @ObservedObject var viewModel: HabitsViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    @State private var showingEditView = false
    
    private var habit: Habit? {
        viewModel.habit(byId: habitId)
    }
    
    var body: some View {
        NavigationView {
            Group {
                if let habit = habit {
                    ScrollView {
                        VStack(spacing: 24) {
                            headerView(habit: habit)
                            statsView(habit: habit)
                            historyView(habit: habit)
                            if !habit.whyImportant.isEmpty {
                                notesView(habit: habit)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                } else {
                    VStack(spacing: 20) {
                        Text("Habit not found")
                            .font(FontManager.medium(size: 18))
                            .foregroundColor(ColorManager.darkGray)
                        Button("Close") { dismiss() }
                            .font(FontManager.medium(size: 16))
                            .foregroundColor(ColorManager.primaryBlue)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(ColorManager.backgroundGradient.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(FontManager.regular(size: 16))
                    .foregroundColor(ColorManager.primaryBlue)
                }
                
                if habit != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Edit") {
                                showingEditView = true
                            }
                            Button("Delete", role: .destructive) {
                                showingDeleteAlert = true
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.system(size: 20))
                                .foregroundColor(ColorManager.primaryBlue)
                        }
                    }
                }
            }
            .alert("Delete Habit", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    viewModel.deleteHabit(id: habitId)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this habit? This action cannot be undone.")
            }
            .sheet(isPresented: $showingEditView) {
                if let habit = habit {
                    EditHabitView(habit: habit) { updatedHabit in
                        viewModel.updateHabit(updatedHabit)
                    }
                }
            }
        }
    }
    
    private func headerView(habit: Habit) -> some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(ColorManager.primaryBlue.opacity(0.1))
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: habit.icon)
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(ColorManager.primaryBlue)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(habit.name)
                        .font(FontManager.bold(size: 24))
                        .foregroundColor(ColorManager.darkGray)
                        .lineLimit(nil)
                    
                    HStack(spacing: 16) {
                        Label(habit.category.title, systemImage: habit.category.icon)
                            .font(FontManager.regular(size: 14))
                            .foregroundColor(ColorManager.primaryBlue)
                        
                        Label(habit.frequency.title, systemImage: "calendar")
                            .font(FontManager.regular(size: 14))
                            .foregroundColor(ColorManager.darkGray.opacity(0.7))
                    }
                }
                
                Spacer()
            }
            
            HStack {
                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(habit.isCompleted ? ColorManager.success : ColorManager.lightGray)
                
                Text(habit.isCompleted ? "Completed today" : "Not completed today")
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(habit.isCompleted ? ColorManager.success : ColorManager.darkGray.opacity(0.7))
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(habit.isCompleted ? ColorManager.success.opacity(0.1) : ColorManager.lightGray.opacity(0.5))
            )
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private func statsView(habit: Habit) -> some View {
        HStack(spacing: 16) {
            StatCard(
                title: "Current Streak",
                value: "\(habit.streakDays)",
                subtitle: "days",
                icon: "flame.fill",
                color: ColorManager.primaryYellow
            )
            
            StatCard(
                title: "Total Completed",
                value: "\(habit.completedDates.count)",
                subtitle: "times",
                icon: "checkmark.circle.fill",
                color: ColorManager.success
            )
        }
    }
    
    private func historyView(habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(FontManager.medium(size: 18))
                .foregroundColor(ColorManager.darkGray)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(last30Days(), id: \.self) { date in
                    DayCell(
                        date: date,
                        isCompleted: habit.completedDates.contains { Calendar.current.isDate($0, inSameDayAs: date) },
                        isToday: Calendar.current.isDateInToday(date)
                    )
                }
            }
            
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Circle()
                        .fill(ColorManager.success)
                        .frame(width: 8, height: 8)
                    
                    Text("Completed")
                        .font(FontManager.regular(size: 12))
                        .foregroundColor(ColorManager.darkGray.opacity(0.7))
                }
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(ColorManager.lightGray)
                        .frame(width: 8, height: 8)
                    
                    Text("Not completed")
                        .font(FontManager.regular(size: 12))
                        .foregroundColor(ColorManager.darkGray.opacity(0.7))
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private func notesView(habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Why this matters")
                .font(FontManager.medium(size: 18))
                .foregroundColor(ColorManager.darkGray)
            
            Text(habit.whyImportant)
                .font(FontManager.regular(size: 16))
                .foregroundColor(ColorManager.darkGray.opacity(0.8))
                .lineLimit(nil)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private func last30Days() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<30).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: today)
        }.reversed()
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(FontManager.bold(size: 24))
                    .foregroundColor(ColorManager.darkGray)
                
                Text(subtitle)
                    .font(FontManager.regular(size: 12))
                    .foregroundColor(ColorManager.darkGray.opacity(0.7))
            }
            
            Text(title)
                .font(FontManager.medium(size: 14))
                .foregroundColor(ColorManager.darkGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct DayCell: View {
    let date: Date
    let isCompleted: Bool
    let isToday: Bool
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(dayNumber)
                .font(FontManager.regular(size: 12))
                .foregroundColor(isToday ? .white : ColorManager.darkGray)
            
            Circle()
                .fill(isCompleted ? ColorManager.success : ColorManager.lightGray)
                .frame(width: 8, height: 8)
        }
        .frame(width: 32, height: 40)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isToday ? ColorManager.primaryBlue : Color.clear)
        )
    }
}

struct EditHabitView: View {
    private let initialHabit: Habit
    private let onSave: (Habit) -> Void
    
    @State private var name: String = ""
    @State private var selectedCategory: HabitCategory = .morningRituals
    @State private var selectedFrequency: HabitFrequency = .daily
    @State private var selectedIcon: String = "heart.fill"
    @State private var whyImportant: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    private let availableIcons = [
        "heart.fill", "star.fill", "sun.max.fill", "moon.fill",
        "leaf.fill", "flame.fill", "drop.fill", "bolt.fill",
        "book.fill", "pencil", "target", "checkmark.circle.fill"
    ]
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    init(habit: Habit, onSave: @escaping (Habit) -> Void) {
        self.initialHabit = habit
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text("Edit Habit")
                            .font(FontManager.bold(size: 24))
                            .foregroundColor(ColorManager.primaryBlue)
                        
                        Text("Change the details of your habit")
                            .font(FontManager.regular(size: 16))
                            .foregroundColor(ColorManager.darkGray.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Habit Name")
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(ColorManager.darkGray)
                            
                            TextField("Enter habit name", text: $name)
                                .font(FontManager.regular(size: 16))
                                .padding(16)
                                .background(ColorManager.lightBlue)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Category")
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(ColorManager.darkGray)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                                ForEach(HabitCategory.allCases, id: \.self) { category in
                                    CategoryCard(
                                        category: category,
                                        isSelected: selectedCategory == category
                                    ) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Icon")
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(ColorManager.darkGray)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 12) {
                                ForEach(availableIcons, id: \.self) { icon in
                                    IconButton(
                                        icon: icon,
                                        isSelected: selectedIcon == icon
                                    ) {
                                        selectedIcon = icon
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Frequency")
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(ColorManager.darkGray)
                            
                            HStack(spacing: 12) {
                                ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                                    FrequencyButton(
                                        frequency: frequency,
                                        isSelected: selectedFrequency == frequency
                                    ) {
                                        selectedFrequency = frequency
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Why is this important? (Optional)")
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(ColorManager.darkGray)
                            
                            TextField("This will help me...", text: $whyImportant, axis: .vertical)
                                .font(FontManager.regular(size: 16))
                                .lineLimit(3...6)
                                .padding(16)
                                .background(ColorManager.lightBlue)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 20)
                }
            }
            .background(ColorManager.backgroundGradient.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(FontManager.regular(size: 16))
                    .foregroundColor(ColorManager.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveAndDismiss()
                    }
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(canSave ? ColorManager.primaryBlue : ColorManager.lightGray)
                    .disabled(!canSave)
                }
            }
            .onAppear {
                name = initialHabit.name
                selectedCategory = initialHabit.category
                selectedFrequency = initialHabit.frequency
                selectedIcon = initialHabit.icon
                whyImportant = initialHabit.whyImportant
            }
        }
    }
    
    private func saveAndDismiss() {
        var updated = Habit(
            name: name.trimmingCharacters(in: .whitespaces),
            category: selectedCategory,
            frequency: selectedFrequency,
            icon: selectedIcon,
            whyImportant: whyImportant.trimmingCharacters(in: .whitespaces)
        )
        updated.id = initialHabit.id
        updated.createdDate = initialHabit.createdDate
        updated.completedDates = initialHabit.completedDates
        onSave(updated)
        dismiss()
    }
}

#Preview {
    let vm = HabitsViewModel()
    let habit = Habit(name: "Morning Meditation", category: .breathing, frequency: .daily, icon: "leaf.fill")
    vm.addHabit(habit)
    return HabitDetailView(habitId: habit.id, viewModel: vm)
}
