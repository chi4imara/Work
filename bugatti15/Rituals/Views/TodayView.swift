import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel = TodayViewModel()
    @State private var showingAddGoal = false
    @State private var animateProgress = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                HeaderSection(greeting: viewModel.getGreeting())
                
                MoodSelectionSection(
                    selectedMoods: $viewModel.selectedMoods,
                    onMoodSelected: { mood in
                        viewModel.addMood(mood)
                    },
                    onMoodRemoved: { mood in
                        viewModel.removeMood(mood)
                    }
                )
                
                DailyGoalsSection(
                    goals: viewModel.dailyGoals,
                    onGoalToggle: { goal in
                        viewModel.toggleGoalCompletion(goal)
                    },
                    onAddGoal: {
                        showingAddGoal = true
                    }
                )
                
                DailyQuestionSection(
                    question: viewModel.dailyQuestion,
                    answer: $viewModel.dailyAnswer,
                    onAnswerSaved: { answer in
                        viewModel.saveDailyAnswer(answer)
                    }
                )
                
                ProgressSection(
                    progress: viewModel.progressPercentage,
                    animateProgress: $animateProgress
                )
                
                MotivationalTipSection(tip: viewModel.getRandomTip())
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView { goal in
                DataManager.shared.saveGoal(goal)
                viewModel.dailyGoals.append(goal)
            }
        }
        .onAppear {
            viewModel.refresh()
            withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
                animateProgress = true
            }
        }
    }
}

struct HeaderSection: View {
    let greeting: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(greeting)
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
            }
        }
    }
}

struct MoodSelectionSection: View {
    @Binding var selectedMoods: [MoodType]
    let onMoodSelected: (MoodType) -> Void
    let onMoodRemoved: (MoodType) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How are you feeling today?")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                ForEach(MoodType.allCases, id: \.self) { mood in
                    MoodButton(
                        mood: mood,
                        isSelected: selectedMoods.contains(mood),
                        onTap: {
                            if selectedMoods.contains(mood) {
                                onMoodRemoved(mood)
                            } else {
                                onMoodSelected(mood)
                            }
                        }
                    )
                }
            }
            
            if !selectedMoods.isEmpty {
                Text("Thank you for sharing!")
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.success)
                    .transition(.opacity)
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

struct MoodButton: View {
    let mood: MoodType
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            onTap()
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }) {
            VStack(spacing: 4) {
                Text(mood.rawValue)
                    .font(.system(size: 24))
                
                Text(mood.name)
                    .font(.ubuntu(10, weight: .medium))
                    .foregroundColor(isSelected ? AppColors.textPrimary : AppColors.textSecondary)
            }
            .frame(width: 60, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.secondary.opacity(0.3) : AppColors.white.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? AppColors.secondary : AppColors.white.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
    }
}

struct DailyGoalsSection: View {
    let goals: [Goal]
    let onGoalToggle: (Goal) -> Void
    let onAddGoal: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Small pleasures for today")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
                
                Button(action: onAddGoal) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.secondary)
                }
            }
            
            if goals.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "heart")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("Add your first pleasure and start delighting yourself.")
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(goals, id: \.id) { goal in
                        GoalRowView(
                            goal: goal,
                            onToggle: {
                                onGoalToggle(goal)
                            }
                        )
                    }
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

struct GoalRowView: View {
    let goal: Goal
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                onToggle()
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }) {
                Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(goal.isCompleted ? AppColors.success : AppColors.textSecondary)
            }
            
            Image(systemName: goal.icon)
                .font(.system(size: 16))
                .foregroundColor(AppColors.secondary)
                .frame(width: 20)
            
            Text(goal.title)
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(goal.isCompleted ? AppColors.textSecondary : AppColors.textPrimary)
                .strikethrough(goal.isCompleted)
            
            Spacer()
            
            if goal.streak > 0 {
                HStack(spacing: 2) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.warning)
                    
                    Text("\(goal.streak)")
                        .font(.ubuntu(12, weight: .bold))
                        .foregroundColor(AppColors.warning)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(AppColors.warning.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding(.vertical, 4)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: goal.isCompleted)
    }
}

struct DailyQuestionSection: View {
    let question: String
    @Binding var answer: String
    let onAnswerSaved: (String) -> Void
    
    @State private var isEditing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Question of the day")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
            
            Text(question)
                .font(.ubuntu(16))
                .foregroundColor(AppColors.textSecondary)
                .italic()
            
            VStack(alignment: .leading, spacing: 8) {
                TextField("Your answer...", text: $answer, axis: .vertical)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.textPrimary)
                    .padding(12)
                    .background(AppColors.white.opacity(0.1))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
                    )
                    .onSubmit {
                        onAnswerSaved(answer)
                    }
                
                if !answer.isEmpty {
                    Text("Saved automatically")
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.success)
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

struct ProgressSection: View {
    let progress: Double
    @Binding var animateProgress: Bool
    
    private var clampedProgress: Double {
        min(max(progress, 0), 1)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Today's Progress")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(AppColors.textPrimary)
            
            ZStack {
                Circle()
                    .stroke(AppColors.white.opacity(0.2), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0.0, to: animateProgress ? clampedProgress : 0.0)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [AppColors.secondary, AppColors.success]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: animateProgress)
                
                VStack {
                    Text("\(Int(clampedProgress * 100))%")
                        .font(.ubuntu(24, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Text("Complete")
                        .font(.ubuntu(12))
                        .foregroundColor(AppColors.textSecondary)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppGradients.primaryCard)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppColors.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct MotivationalTipSection: View {
    let tip: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 20))
                .foregroundColor(AppColors.secondary)
            
            Text(tip)
                .font(.ubuntu(14))
                .foregroundColor(AppColors.textSecondary)
                .italic()
            
            Spacer()
        }
        .padding(16)
        .background(AppColors.secondary.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColors.secondary.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    TodayView()
}
