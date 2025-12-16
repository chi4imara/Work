import SwiftUI

struct CategoriesView: View {
    @ObservedObject var habitStore: HabitStore
    @State private var selectedCategory: HabitCategory?
    @State private var showingCreateHabit = false
    @State private var showingDeleteAlert = false
    @State private var habitToDelete: Habit?
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                if selectedCategory == nil {
                    categoriesOverviewView
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                } else {
                    categoryDetailView
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedCategory)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingCreateHabit) {
            CreateHabitView(habitStore: habitStore)
        }
        .alert("Delete Habit", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let habit = habitToDelete {
                    habitStore.deleteHabit(habit)
                }
            }
        } message: {
            Text("This will permanently delete the habit and all its data. This action cannot be undone.")
        }
    }
    
    private var categoriesOverviewView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 10) {
                Text("Categories")
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(AppColors.textWhite)
                
                Text("Organize your habits by theme")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textWhite.opacity(0.8))
            }
            .padding(.top, 60)
            .padding(.bottom, 30)
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                    ForEach(HabitCategory.allCases) { category in
                        categoryCardView(category: category)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    private func categoryCardView(category: HabitCategory) -> some View {
        let habitsInCategory = habitStore.habitsForCategory(category)
        
        return Button(action: {
            selectedCategory = category
        }) {
            VStack(spacing: 20) {
                Image(systemName: category.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(category.color)
                
                Text(category.rawValue)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.textWhite)
                
                VStack(spacing: 5) {
                    Text("\(habitsInCategory.count)")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.accentYellow)
                    
                    Text(habitsInCategory.count == 1 ? "habit" : "habits")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.textWhite.opacity(0.7))
                }
                
                if !habitsInCategory.isEmpty {
                    let activeStreaks = habitsInCategory.filter { $0.currentStreak > 0 }.count
                    if activeStreaks > 0 {
                        Text("\(activeStreaks) active")
                            .font(.ubuntu(12, weight: .medium))
                            .foregroundColor(AppColors.successGreen)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(AppColors.successGreen.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .padding(20)
            .background(AppColors.cardGradient)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(category.color.opacity(0.3), lineWidth: 1)
            )
        }
        .scaleEffect(habitsInCategory.isEmpty ? 0.95 : 1.0)
        .opacity(habitsInCategory.isEmpty ? 0.7 : 1.0)
    }
    
    private var categoryDetailView: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    selectedCategory = nil
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                }
                
                Spacer()
                
                VStack(spacing: 5) {
                    if let category = selectedCategory {
                        Image(systemName: category.icon)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(category.color)
                        
                        Text(category.rawValue)
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(AppColors.textWhite)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    showingCreateHabit = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            if let category = selectedCategory {
                let habitsInCategory = habitStore.habitsForCategory(category)
                
                if habitsInCategory.isEmpty {
                    emptyStateView(for: category)
                } else {
                    habitsList(habits: habitsInCategory)
                }
            }
            
            Spacer()
        }
    }
    
    private func emptyStateView(for category: HabitCategory) -> some View {
        VStack(spacing: 30) {
            Image(systemName: category.icon)
                .font(.system(size: 60, weight: .light))
                .foregroundColor(category.color.opacity(0.6))
            
            Text("No habits yet")
                .font(.ubuntu(20, weight: .bold))
                .foregroundColor(AppColors.textWhite)
            
            Text("Add your first \(category.rawValue.lowercased()) habit to get started")
                .font(.ubuntu(14, weight: .regular))
                .foregroundColor(AppColors.textWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                showingCreateHabit = true
            }) {
                Text("Add Habit")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryPurple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.accentYellow)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 40)
        }
        .frame(maxHeight: .infinity)
    }
    
    private func habitsList(habits: [Habit]) -> some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(habits) { habit in
                    habitRowView(habit: habit)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private func habitRowView(habit: Habit) -> some View {
        HStack(spacing: 15) {
            Image(systemName: habit.category.icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(habit.category.color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(AppColors.textWhite)
                
                HStack(spacing: 10) {
                    Text("Current: \(habit.currentStreak) days")
                        .font(.ubuntu(12, weight: .medium))
                        .foregroundColor(AppColors.accentYellow)
                    
                    Text("•")
                        .foregroundColor(AppColors.textWhite.opacity(0.5))
                    
                    Text("Since \(habit.startDate, formatter: dateFormatter)")
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(AppColors.textWhite.opacity(0.7))
                }
                
                if !habit.comment.isEmpty {
                    Text(habit.comment)
                        .font(.ubuntu(12, weight: .regular))
                        .foregroundColor(AppColors.textWhite.opacity(0.6))
                        .italic()
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text("\(habit.currentStreak)")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(habit.currentStreak > 0 ? AppColors.successGreen : AppColors.neutralGray)
                
                Text("days")
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(AppColors.textWhite.opacity(0.6))
            }
            
            Button(action: {
                habitToDelete = habit
                showingDeleteAlert = true
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.warningRed)
                    .frame(width: 30, height: 30)
            }
        }
        .padding(20)
        .background(AppColors.cardGradient)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(AppColors.textWhite.opacity(0.1), lineWidth: 1)
        )
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

#Preview {
    CategoriesView(habitStore: HabitStore())
}
