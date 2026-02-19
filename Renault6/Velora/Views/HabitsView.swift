import SwiftUI

struct HabitsView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var showAddHabit = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Habits")
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        showAddHabit = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(AppColors.primaryAccent)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.habits.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Image(systemName: "heart.fill")
                            .font(.system(size: 60))
                            .foregroundColor(AppColors.primaryText.opacity(0.6))
                        
                        VStack(spacing: 12) {
                            Text("Add your first habit")
                                .font(.ubuntu(24, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Self-care starts with small steps")
                                .font(.ubuntu(16, weight: .light))
                                .foregroundColor(AppColors.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        
                        Button {
                            showAddHabit = true
                        } label: {
                            Text("Add Habit")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(AppColors.accentText)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(AppColors.primaryAccent)
                                .cornerRadius(25)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.habits) { habit in
                                HabitCardView(
                                    habit: habit,
                                    onToggle: {
                                        viewModel.toggleHabit(habit)
                                    },
                                    onDelete: {
                                        viewModel.deleteHabit(habit)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddHabit) {
            AddHabitView(viewModel: viewModel)
        }
    }
}

struct HabitCardView: View {
    let habit: Habit
    let onToggle: () -> Void
    let onDelete: () -> Void
    @State private var showDeleteAlert = false
    
    var body: some View {
        CardView {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: habit.category.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primaryText)
                        .frame(width: 40, height: 40)
                        .background(AppColors.softGradient)
                        .cornerRadius(20)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.name)
                            .font(.ubuntu(18, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text(habit.category.rawValue)
                            .font(.ubuntu(14, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    
                    Spacer()
                    
                    Menu {
                        Button("Delete", role: .destructive) {
                            showDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.primaryText.opacity(0.6))
                            .frame(width: 30, height: 30)
                    }
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current Streak")
                            .font(.ubuntu(12, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text("\(habit.currentStreak) days")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Frequency")
                            .font(.ubuntu(12, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(habit.frequency.rawValue)
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                    }
                }
                
                Button(action: onToggle) {
                    HStack {
                        Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 20))
                        
                        Text(habit.isCompletedToday ? "Completed Today" : "Mark as Done")
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(habit.isCompletedToday ? Color.white : AppColors.accentText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        habit.isCompletedToday 
                        ? AnyShapeStyle(AppColors.success.opacity(0.2))
                        : AnyShapeStyle(AppColors.buttonGradient)
                    )
                    .cornerRadius(22)
                }
                
                if !habit.whyImportant.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Why it's important:")
                            .font(.ubuntu(12, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(habit.whyImportant)
                            .font(.ubuntu(14, weight: .light))
                            .foregroundColor(AppColors.primaryText.opacity(0.8))
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(20)
        }
        .alert("Delete Habit", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this habit? This action cannot be undone.")
        }
    }
}

#Preview {
    HabitsView(viewModel: AppViewModel())
}
