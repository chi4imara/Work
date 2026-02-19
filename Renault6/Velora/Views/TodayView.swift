import SwiftUI

struct TodayView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selectedMoods: Set<String> = []
    @State private var showMeditationTimer = false
    @State private var showAddHabit = false
    @State private var animateProgress = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text(viewModel.greetingText)
                            .font(.ubuntu(32, weight: .bold))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("How are you feeling today?")
                            .font(.ubuntu(16, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                    }
                    .padding(.top, 20)
                    
                    DailyProgressView(progress: viewModel.todayProgress?.completionPercentage ?? 0.0)
                        .scaleEffect(animateProgress ? 1.0 : 0.8)
                        .onAppear {
                            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                                animateProgress = true
                            }
                        }
                    
                    MoodSelectionView(
                        selectedMoods: $selectedMoods,
                        onMoodSelected: { moods in
                            let moodObjects = Mood.allMoods.filter { moods.contains($0.emoji) }
                            viewModel.selectMoods(moodObjects)
                        }
                    )
                    
                    MiniMeditationView(
                        isCompleted: viewModel.meditationCompleted,
                        onStart: {
                            showMeditationTimer = true
                        }
                    )
                    
                    if let challenge = viewModel.todayChallenge {
                        DailyChallengeView(
                            challenge: challenge,
                            onComplete: {
                                viewModel.completeChallenge()
                            }
                        )
                    }
                    
                    HabitsBlockView(
                        habits: viewModel.activeHabits,
                        onToggle: { habit in
                            viewModel.toggleHabit(habit)
                        },
                        onAddHabit: {
                            showAddHabit = true
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
        .sheet(isPresented: $showMeditationTimer) {
            MeditationTimerView(onComplete: {
                viewModel.completeMeditation()
                showMeditationTimer = false
            })
        }
        .sheet(isPresented: $showAddHabit) {
            AddHabitView(viewModel: viewModel)
        }
        .onAppear {
            selectedMoods = Set(viewModel.selectedMoods.map { $0.emoji })
        }
        .onChange(of: viewModel.selectedMoods.map { $0.emoji }.sorted().joined(separator: ",")) { _ in
            selectedMoods = Set(viewModel.selectedMoods.map { $0.emoji })
        }
    }
}

struct DailyProgressView: View {
    let progress: Double
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(AppColors.primaryAccent.opacity(0.3), lineWidth: 8)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(AppColors.primaryAccent, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(progress * 100))%")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
            }
            
            Text("Today's Progress")
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { newValue in
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedProgress = newValue
            }
        }
    }
}

struct MoodSelectionView: View {
    @Binding var selectedMoods: Set<String>
    let onMoodSelected: (Set<String>) -> Void
    @State private var showThankYou = false
    
    var body: some View {
        CardView {
            VStack(spacing: 16) {
                Text("Mood")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                    ForEach(Mood.allMoods.prefix(7), id: \.id) { mood in
                        Button(action: {
                            if selectedMoods.contains(mood.emoji) {
                                selectedMoods.remove(mood.emoji)
                            } else if selectedMoods.count < 3 {
                                selectedMoods.insert(mood.emoji)
                            }
                            
                            if !selectedMoods.isEmpty {
                                onMoodSelected(selectedMoods)
                                showThankYou = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showThankYou = false
                                }
                            }
                        }) {
                            Text(mood.emoji)
                                .font(.system(size: 30))
                                .frame(width: 50, height: 50)
                                .background(
                                    selectedMoods.contains(mood.emoji) 
                                    ? AppColors.primaryAccent.opacity(0.3)
                                    : Color.clear
                                )
                                .cornerRadius(25)
                                .scaleEffect(selectedMoods.contains(mood.emoji) ? 1.1 : 1.0)
                        }
                    }
                }
                
                if showThankYou {
                    Text("Thank you for noting your state")
                        .font(.ubuntu(14, weight: .light))
                        .foregroundColor(AppColors.secondaryText)
                        .transition(.opacity)
                }
            }
            .padding(20)
        }
    }
}

struct MiniMeditationView: View {
    let isCompleted: Bool
    let onStart: () -> Void
    
    var body: some View {
        CardView {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Mini-Meditation")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                
                Text("Short practice: 3-5 minutes of breathing, relaxation or focus")
                    .font(.ubuntu(14, weight: .light))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.leading)
                
                Button(action: onStart) {
                    HStack {
                        Image(systemName: isCompleted ? "checkmark.circle.fill" : "play.circle.fill")
                            .font(.system(size: 20))
                        
                        Text(isCompleted ? "Completed" : "Start")
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(isCompleted ? Color.white : AppColors.accentText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        isCompleted 
                        ? AnyShapeStyle(AppColors.success.opacity(0.2))
                        : AnyShapeStyle(AppColors.buttonGradient)
                    )
                    .cornerRadius(22)
                }
                .disabled(isCompleted)
                
                if isCompleted {
                    Text("Good work. Give yourself this moment")
                        .font(.ubuntu(12, weight: .light))
                        .foregroundColor(AppColors.secondaryText)
                        .transition(.opacity)
                }
            }
            .padding(20)
        }
    }
}

struct DailyChallengeView: View {
    let challenge: Challenge
    let onComplete: () -> Void
    
    var body: some View {
        CardView {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: challenge.category.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("Daily Challenge")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(challenge.title)
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text(challenge.description)
                        .font(.ubuntu(14, weight: .light))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Button(action: onComplete) {
                    HStack {
                        Image(systemName: challenge.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 20))
                        
                        Text(challenge.isCompleted ? "Completed" : "I Did It")
                            .font(.ubuntu(16, weight: .medium))
                    }
                    .foregroundColor(challenge.isCompleted ? Color.white : AppColors.accentText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(
                        challenge.isCompleted 
                        ? AnyShapeStyle(AppColors.success.opacity(0.2))
                        : AnyShapeStyle(AppColors.buttonGradient)
                    )
                    .cornerRadius(22)
                }
                .disabled(challenge.isCompleted)
            }
            .padding(20)
        }
    }
}

struct HabitsBlockView: View {
    let habits: [Habit]
    let onToggle: (Habit) -> Void
    var onAddHabit: () -> Void = {}
    
    var body: some View {
        CardView {
            VStack(spacing: 16) {
                HStack {
                    Text("Habits")
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: onAddHabit) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.primaryAccent)
                    }
                }
                
                if habits.isEmpty {
                    VStack(spacing: 12) {
                        Text("You can start with one step - that's enough")
                            .font(.ubuntu(14, weight: .light))
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.center)
                        
                        Button(action: onAddHabit) {
                            Text("Add Habit")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(AppColors.accentText)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 8)
                                .background(AppColors.buttonGradient)
                                .cornerRadius(16)
                        }
                    }
                    .padding(.vertical, 20)
                } else {
                    ForEach(habits) { habit in
                        HabitRowView(habit: habit, onToggle: { onToggle(habit) })
                    }
                }
            }
            .padding(20)
        }
    }
}

struct HabitRowView: View {
    let habit: Habit
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(habit.isCompletedToday ? AppColors.success : AppColors.primaryAccent.opacity(0.8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                if habit.currentStreak > 0 {
                    Text("\(habit.currentStreak) day streak")
                        .font(.ubuntu(12, weight: .light))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            Image(systemName: habit.category.iconName)
                .font(.system(size: 16))
                .foregroundColor(AppColors.primaryAccent)
        }
        .padding(.vertical, 8)
    }
}

struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .background(AppColors.cardBackground)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    TodayView(viewModel: AppViewModel())
}
