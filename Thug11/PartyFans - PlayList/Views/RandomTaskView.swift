import SwiftUI

struct RandomTaskView: View {
    @ObservedObject var tasksViewModel: TasksViewModel
    @State private var showTaskList = false
    @State private var showAddTask = false
    @State private var cardRotation: Double = 0
    @State private var cardScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 30) {
                VStack(spacing: 8) {
                    Text("Random Task")
                        .font(.nunitoBold(size: 32))
                        .foregroundColor(Color.theme.primaryText)
                    
                    if !tasksViewModel.tasks.isEmpty {
                        Text("\(tasksViewModel.tasks.count) tasks available")
                            .font(.nunitoRegular(size: 16))
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                if let currentTask = tasksViewModel.currentRandomTask, 
                   !tasksViewModel.tasks.isEmpty,
                   !currentTask.text.isEmpty,
                   !currentTask.category.isEmpty {
                    TaskCard(task: currentTask)
                        .rotation3DEffect(.degrees(cardRotation), axis: (x: 0, y: 1, z: 0))
                        .scaleEffect(cardScale)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: cardRotation)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: cardScale)
                } else {
                    EmptyStateCard()
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    if !tasksViewModel.tasks.isEmpty {
                        Button(action: generateNewTask) {
                            HStack(spacing: 12) {
                                Image(systemName: "shuffle")
                                    .font(.system(size: 20, weight: .semibold))
                                Text("New Task")
                                    .font(.nunitoSemiBold(size: 18))
                            }
                            .foregroundColor(Color.theme.buttonText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.theme.buttonPrimary)
                            .cornerRadius(28)
                        }
                    }
                    
                    HStack(spacing: 16) {
                        Button(action: { showTaskList = true }) {
                            HStack(spacing: 8) {
                                Image(systemName: "list.bullet")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Task List")
                                    .font(.nunitoMedium(size: 16))
                            }
                            .foregroundColor(Color.theme.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.theme.buttonSecondary)
                            .cornerRadius(24)
                        }
                        
                        Button(action: { showAddTask = true }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .medium))
                                Text("Add")
                                    .font(.nunitoMedium(size: 16))
                            }
                            .foregroundColor(Color.theme.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.theme.buttonSecondary)
                            .cornerRadius(24)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
        .sheet(isPresented: $showTaskList) {
            TaskListView(tasksViewModel: tasksViewModel)
        }
        .sheet(isPresented: $showAddTask) {
            AddEditTaskView(tasksViewModel: tasksViewModel)
        }
    }
    
    private func generateNewTask() {
        guard !tasksViewModel.tasks.isEmpty else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            cardRotation = 90
            cardScale = 0.8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard !tasksViewModel.tasks.isEmpty else { return }
            
            tasksViewModel.generateRandomTask()
            
            withAnimation(.easeInOut(duration: 0.3)) {
                cardRotation = 0
                cardScale = 1.0
            }
        }
    }
}

struct TaskCard: View {
    let task: PartyTask
    
    var body: some View {
        VStack(spacing: 20) {
            Text(task.category)
                .font(.nunitoMedium(size: 14))
                .foregroundColor(Color.theme.accentOrange)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.theme.accentOrange.opacity(0.2))
                .cornerRadius(20)
            
            Text(task.text)
                .font(.nunitoSemiBold(size: 24))
                .foregroundColor(Color.theme.primaryText)
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 20)
            
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { _ in
                    Circle()
                        .fill(Color.theme.accentYellow.opacity(0.6))
                        .frame(width: 6, height: 6)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .padding(.horizontal, 30)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                )
        )
        .padding(.horizontal, 30)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct EmptyStateCard: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.secondaryText)
            
            VStack(spacing: 12) {
                Text("No Tasks Yet")
                    .font(.nunitoBold(size: 24))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Add your first task to get started with the fun!")
                    .font(.nunitoRegular(size: 16))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal, 30)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.theme.cardBorder, lineWidth: 1)
                )
        )
        .padding(.horizontal, 30)
    }
}

