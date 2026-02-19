import SwiftUI

struct HabitIdItem: Identifiable {
    let id: UUID
}

struct HabitsView: View {
    @StateObject private var viewModel = HabitsViewModel()
    @State private var selectedHabitId: HabitIdItem?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("My Habits")
                        .font(FontManager.bold(size: 26))
                        .foregroundColor(ColorManager.darkGray)
                    
                    Spacer()
                    
                    Button(action: { viewModel.showingAddHabit = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(ColorManager.primaryBlue)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                if viewModel.habits.isEmpty {
                    emptyStateView
                } else {
                    habitsList
                }
            }
        }
        .sheet(isPresented: $viewModel.showingAddHabit) {
            AddHabitView { habit in
                viewModel.addHabit(habit)
            }
        }
        .sheet(item: $selectedHabitId) { item in
            HabitDetailView(habitId: item.id, viewModel: viewModel)
        }
        .onAppear {
            viewModel.refreshFromStorage()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorManager.lightBlue)
                    .frame(width: 120, height: 120)
                
                Image(systemName: "heart.circle")
                    .font(.system(size: 60))
                    .foregroundColor(ColorManager.primaryBlue)
            }
            
            VStack(spacing: 12) {
                Text("No habits yet")
                    .font(FontManager.bold(size: 24))
                    .foregroundColor(ColorManager.darkGray)
                
                Text("Add your first habit and start taking care of yourself")
                    .font(FontManager.regular(size: 16))
                    .foregroundColor(ColorManager.darkGray.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { viewModel.showingAddHabit = true }) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Add First Habit")
                        .font(FontManager.medium(size: 18))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(ColorManager.buttonGradient)
                .cornerRadius(28)
                .shadow(color: ColorManager.primaryBlue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
    
    private var habitsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.habits) { habit in
                    HabitCard(habit: habit) {
                        selectedHabitId = HabitIdItem(id: habit.id)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
}

struct HabitCard: View {
    let habit: Habit
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(ColorManager.primaryBlue.opacity(0.1))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: habit.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(ColorManager.primaryBlue)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.name)
                            .font(FontManager.medium(size: 18))
                            .foregroundColor(ColorManager.darkGray)
                            .lineLimit(2)
                        
                        Text(habit.category.title)
                            .font(FontManager.regular(size: 14))
                            .foregroundColor(ColorManager.primaryBlue)
                    }
                    
                    Spacer()
                    
                    Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(habit.isCompleted ? ColorManager.success : ColorManager.lightGray)
                }
                
                HStack(spacing: 24) {
                    StatItem(
                        icon: "flame.fill",
                        value: "\(habit.streakDays)",
                        label: "Day Streak",
                        color: ColorManager.primaryYellow
                    )
                    
                    StatItem(
                        icon: "calendar",
                        value: habit.frequency.title,
                        label: "Frequency",
                        color: ColorManager.primaryBlue
                    )
                    
                    Spacer()
                }
                
                if habit.frequency == .weekly {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("This week")
                            .font(FontManager.regular(size: 12))
                            .foregroundColor(ColorManager.darkGray.opacity(0.7))
                        
                        ProgressView(value: weeklyProgress(for: habit), total: 1.0)
                            .progressViewStyle(CustomProgressViewStyle())
                    }
                }
            }
            .padding(20)
            .background(ColorManager.cardGradient)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func weeklyProgress(for habit: Habit) -> Double {
        let calendar = Calendar.current
        let now = Date()
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        
        let completedThisWeek = habit.completedDates.filter { date in
            calendar.isDate(date, equalTo: startOfWeek, toGranularity: .weekOfYear)
        }.count
        
        return min(Double(completedThisWeek) / 7.0, 1.0)
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(ColorManager.darkGray)
                
                Text(label)
                    .font(FontManager.regular(size: 12))
                    .foregroundColor(ColorManager.darkGray.opacity(0.7))
            }
        }
    }
}

#Preview {
    HabitsView()
}
