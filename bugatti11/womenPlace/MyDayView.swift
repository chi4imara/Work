import SwiftUI

struct MyDayView: View {
    @EnvironmentObject var viewModel: DailyEntryViewModel
    @State private var showingAddTask = false
    @State private var dailyAnswer = ""
    @State private var showTaskCompletion = false
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 8) {
                        Text(viewModel.greeting)
                            .font(AppFonts.playfairSemiBold(size: 24))
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    MoodSelectorView(selectedMood: viewModel.currentEntry.mood) { mood in
                        viewModel.setMood(mood)
                    }
                    
                    TaskSectionView(
                        title: "Tasks for Today",
                        tasks: viewModel.currentEntry.tasks,
                        onToggle: { task in
                            withAnimation(.spring(response: 0.3)) {
                                viewModel.toggleTaskCompletion(task)
                                if task.isCompleted {
                                    showTaskCompletion = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showTaskCompletion = false
                                    }
                                }
                            }
                        },
                        onAdd: {
                            showingAddTask = true
                        }
                    )
                    
                    if !viewModel.habits.isEmpty {
                        TaskSectionView(
                            title: "Daily Habits",
                            tasks: viewModel.habits,
                            onToggle: { habit in
                                withAnimation(.spring(response: 0.3)) {
                                    viewModel.toggleTaskCompletion(habit)
                                }
                            },
                            showAddButton: false
                        )
                    }
                    
                    DailyQuestionView(
                        question: viewModel.currentEntry.dailyQuestion,
                        answer: $dailyAnswer
                    )
                    .onChange(of: dailyAnswer) { newValue in
                        viewModel.updateDailyAnswer(newValue)
                    }
                    
                    ProgressIndicatorView(progress: viewModel.currentEntry.progressPercentage)
                }
                .padding(.horizontal, 20)
            }
            
            if showTaskCompletion {
                TaskCompletionOverlay()
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .sheet(isPresented: $showingAddTask) {
            AddTaskView { task in
                viewModel.addTask(task)
            }
        }
        .onAppear {
            dailyAnswer = viewModel.currentEntry.dailyAnswer
        }
    }
}

struct MoodSelectorView: View {
    let selectedMood: Mood?
    let onMoodSelected: (Mood) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("How are you feeling?")
                .font(AppFonts.playfairMedium(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            HStack(spacing: 20) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    Button(action: {
                        onMoodSelected(mood)
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: mood.rawValue)
                                .font(.system(size: 24))
                                .foregroundColor(selectedMood == mood ? AppColors.accentYellow : AppColors.secondaryText)
                                .scaleEffect(selectedMood == mood ? 1.2 : 1.0)
                            
                            Text(mood.displayName)
                                .font(AppFonts.playfairRegular(size: 12))
                                .foregroundColor(selectedMood == mood ? AppColors.accentYellow : AppColors.secondaryText)
                        }
                    }
                    .animation(.spring(response: 0.3), value: selectedMood)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
    }
}

struct TaskSectionView: View {
    let title: String
    let tasks: [TaskG]
    let onToggle: (TaskG) -> Void
    let onAdd: (() -> Void)?
    let showAddButton: Bool
    
    init(title: String, tasks: [TaskG], onToggle: @escaping (TaskG) -> Void, onAdd: (() -> Void)? = nil, showAddButton: Bool = true) {
        self.title = title
        self.tasks = tasks
        self.onToggle = onToggle
        self.onAdd = onAdd
        self.showAddButton = showAddButton
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(title)
                    .font(AppFonts.playfairMedium(size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                if showAddButton, let onAdd = onAdd {
                    Button(action: onAdd) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(AppColors.accentYellow)
                    }
                }
            }
            
            if tasks.isEmpty {
                Text("No tasks yet. Add your first task!")
                    .font(AppFonts.playfairRegular(size: 14))
                    .foregroundColor(AppColors.secondaryText)
                    .italic()
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    ForEach(tasks) { task in
                        TaskRowView(task: task, onToggle: onToggle)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
    }
}

struct TaskRowView: View {
    let task: TaskG
    let onToggle: (TaskG) -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                onToggle(task)
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(task.isCompleted ? AppColors.lightGreen : AppColors.secondaryText)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(AppFonts.playfairRegular(size: 16))
                    .foregroundColor(task.isCompleted ? AppColors.secondaryText : AppColors.primaryText)
                    .strikethrough(task.isCompleted)
                
                if task.isHabit && task.streak > 0 {
                    Text("\(task.streak) day streak")
                        .font(AppFonts.playfairRegular(size: 12))
                        .foregroundColor(AppColors.accentYellow)
                }
            }
            
            Spacer()
            
            Image(systemName: task.icon)
                .font(.system(size: 16))
                .foregroundColor(AppColors.accentYellow)
        }
        .padding(.vertical, 8)
    }
}

struct DailyQuestionView: View {
    let question: String
    @Binding var answer: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Daily Reflection")
                .font(AppFonts.playfairMedium(size: 18))
                .foregroundColor(AppColors.primaryText)
            
            Text(question)
                .font(AppFonts.playfairRegular(size: 16))
                .foregroundColor(AppColors.secondaryText)
            
            TextField("Your thoughts...", text: $answer, axis: .vertical)
                .font(AppFonts.playfairRegular(size: 14))
                .foregroundColor(AppColors.primaryText)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                )
                .lineLimit(3...6)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
    }
}

struct ProgressIndicatorView: View {
    let progress: Double
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Today's Progress")
                    .font(AppFonts.playfairMedium(size: 18))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(AppFonts.playfairSemiBold(size: 18))
                    .foregroundColor(AppColors.accentYellow)
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: AppColors.accentYellow))
                .scaleEffect(y: 2)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .backdrop(blur: 10)
        )
    }
}

struct TaskCompletionOverlay: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(AppColors.lightGreen)
            
            Text("Another step completed!")
                .font(AppFonts.playfairMedium(size: 18))
                .foregroundColor(AppColors.primaryText)
                .multilineTextAlignment(.center)
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.8))
                .backdrop(blur: 20)
        )
        .shadow(radius: 20)
    }
}

extension View {
    func backdrop(blur radius: CGFloat) -> some View {
        self.background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .blur(radius: radius / 2)
        )
    }
}
