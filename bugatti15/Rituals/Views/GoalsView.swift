import SwiftUI

struct GoalsView: View {
    @StateObject private var viewModel = GoalsViewModel()
    @State private var showingAddGoal = false
    @State private var selectedGoal: Goal?
    @State private var showingGoalDetail = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HeaderView(
                    title: "My Pleasures",
                    subtitle: "\(viewModel.goals.count) goals created",
                    onAddTapped: {
                        showingAddGoal = true
                    }
                )
                
                if viewModel.goals.isEmpty {
                    EmptyStateView {
                        showingAddGoal = true
                    }
                } else {
                    GoalsListView(
                        goals: viewModel.goals,
                        onGoalTapped: { goal in
                            selectedGoal = goal
                            showingGoalDetail = true
                        },
                        onGoalToggle: { goal in
                            viewModel.updateGoal(goal)
                        }
                    )
                }
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView { goal in
                viewModel.addGoal(goal)
            }
        }
        .sheet(item: $selectedGoal) { goal in
            GoalDetailView(
                goal: goal,
                onUpdate: { updatedGoal in
                    viewModel.updateGoal(updatedGoal)
                },
                onDelete: {
                    viewModel.deleteGoal(goal)
                    showingGoalDetail = false
                }
            )
        }
        .onAppear {
            viewModel.loadGoals()
        }
    }
}

struct HeaderView: View {
    let title: String
    let subtitle: String
    let onAddTapped: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(subtitle)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: onAddTapped) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(AppColors.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

struct EmptyStateView: View {
    let onAddTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.secondary.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "heart")
                    .font(.system(size: 50))
                    .foregroundColor(AppColors.secondary)
            }
            
            VStack(spacing: 12) {
                Text("No pleasures yet")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Add your first pleasure and start delighting yourself.")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: onAddTapped) {
                HStack {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("Add First Goal")
                        .font(.ubuntu(18, weight: .medium))
                }
                .foregroundColor(AppColors.primary)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(AppColors.secondary)
                .cornerRadius(25)
                .shadow(color: AppColors.shadow, radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
    }
}

struct GoalsListView: View {
    let goals: [Goal]
    let onGoalTapped: (Goal) -> Void
    let onGoalToggle: (Goal) -> Void
    
    var groupedGoals: [GoalCategory: [Goal]] {
        Dictionary(grouping: goals) { $0.category }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(GoalCategory.allCases, id: \.self) { category in
                    if let categoryGoals = groupedGoals[category], !categoryGoals.isEmpty {
                        GoalCategorySection(
                            category: category,
                            goals: categoryGoals,
                            onGoalTapped: onGoalTapped,
                            onGoalToggle: onGoalToggle
                        )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct GoalCategorySection: View {
    let category: GoalCategory
    let goals: [Goal]
    let onGoalTapped: (Goal) -> Void
    let onGoalToggle: (Goal) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.secondary)
                
                Text(category.name)
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Text("\(goals.count)")
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.cardBackground)
                    .cornerRadius(8)
            }
            
            LazyVStack(spacing: 12) {
                ForEach(goals, id: \.id) { goal in
                    GoalCardView(
                        goal: goal,
                        onTap: {
                            onGoalTapped(goal)
                        },
                        onToggle: {
                            var updatedGoal = goal
                            updatedGoal.isCompleted.toggle()
                            if updatedGoal.isCompleted {
                                updatedGoal.markCompleted()
                            } else {
                                updatedGoal.markIncomplete()
                            }
                            onGoalToggle(updatedGoal)
                        }
                    )
                }
            }
        }
        .padding(20)
        .background(AppGradients.primaryCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct GoalCardView: View {
    let goal: Goal
    let onTap: () -> Void
    let onToggle: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Button(action: {
                    onToggle()
                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                    impactFeedback.impactOccurred()
                }) {
                    Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundColor(goal.isCompleted ? AppColors.success : AppColors.textSecondary)
                }
                .buttonStyle(PlainButtonStyle())
                
                Image(systemName: goal.icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.secondary)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(goal.isCompleted ? AppColors.textSecondary : AppColors.textPrimary)
                        .strikethrough(goal.isCompleted)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(goal.frequency.name)
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.textSecondary)
                        
                        if goal.streak > 0 {
                            Spacer()
                            
                            HStack(spacing: 2) {
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppColors.warning)
                                
                                Text("\(goal.streak) day\(goal.streak == 1 ? "" : "s")")
                                    .font(.ubuntu(10, weight: .bold))
                                    .foregroundColor(AppColors.warning)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.vertical, 8)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    GoalsView()
}
