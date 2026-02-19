import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel = TodayViewModel()
    @State private var showingEnergySelection = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: AppConstants.largeSpacing) {
                GreetingSection(viewModel: viewModel)
                
                EnergyAssessmentSection(
                    viewModel: viewModel,
                    showingSelection: $showingEnergySelection
                )
                
                TasksSection(viewModel: viewModel)
                
                MiniChallengeSection(viewModel: viewModel)
                
                DiarySection(viewModel: viewModel)
                
                ProgressIndicatorSection(viewModel: viewModel)
            }
            .padding(.horizontal, AppConstants.mediumSpacing)
            .padding(.top, AppConstants.mediumSpacing)
            .padding(.bottom, 120)
        }
        .background(AppColors.backgroundGradient.ignoresSafeArea())
        .sheet(isPresented: $showingEnergySelection) {
            EnergySelectionSheet(viewModel: viewModel, isPresented: $showingEnergySelection)
        }
        .sheet(isPresented: $viewModel.showingAddTask) {
            AddTaskView(
                isPresented: $viewModel.showingAddTask,
                taskType: .task,
                onSave: { viewModel.addTask($0) }
            )
        }
        .sheet(isPresented: $viewModel.showingAddChallenge) {
            AddTaskView(
                isPresented: $viewModel.showingAddChallenge,
                taskType: .challenge,
                onSave: { viewModel.addChallenge($0) }
            )
        }
    }
}

struct GreetingSection: View {
    @ObservedObject var viewModel: TodayViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.greetingText)
                .font(.ubuntu(.bold, size: AppConstants.headerFontSize))
                .foregroundColor(AppColors.primaryText)
            
            Text("How's your energy today?")
                .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                .foregroundColor(AppColors.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct EnergyAssessmentSection: View {
    @ObservedObject var viewModel: TodayViewModel
    @Binding var showingSelection: Bool
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: AppConstants.mediumSpacing) {
                HStack {
                    Text("Energy & Focus Assessment")
                        .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button("Edit") {
                        showingSelection = true
                    }
                    .font(.ubuntu(.medium, size: AppConstants.smallFontSize))
                    .foregroundColor(AppColors.primaryOrange)
                }
                
                if viewModel.selectedEnergyLevels.isEmpty {
                    Button {
                        showingSelection = true
                    } label: {
                        Text("Select your energy levels")
                            .font(.ubuntu(.medium, size: AppConstants.mediumFontSize))
                            .foregroundColor(AppColors.primaryOrange)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(AppColors.primaryOrange.opacity(0.1))
                            .cornerRadius(AppConstants.smallCornerRadius)
                    }
                } else {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                        ForEach(viewModel.selectedEnergyLevels, id: \.self) { energyType in
                            EnergyLevelCard(energyType: energyType, isSelected: true)
                        }
                    }
                    
                    Text("Assessment saved")
                        .font(.ubuntu(.medium, size: AppConstants.smallFontSize))
                        .foregroundColor(AppColors.success)
                        .padding(.top, 8)
                }
            }
        }
    }
}

struct TasksSection: View {
    @ObservedObject var viewModel: TodayViewModel
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: AppConstants.mediumSpacing) {
                HStack {
                    Text("Today's Tasks")
                        .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.showingAddTask = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.primaryOrange)
                    }
                }
                
                if viewModel.todayTasks.isEmpty {
                    Text("No tasks for today. Add your first task!")
                        .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                        .foregroundColor(AppColors.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                } else {
                    ForEach(viewModel.todayTasks) { task in
                        TaskRowView(task: task) {
                            viewModel.toggleTaskCompletion(task)
                        }
                    }
                }
            }
        }
    }
}

struct MiniChallengeSection: View {
    @ObservedObject var viewModel: TodayViewModel
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: AppConstants.mediumSpacing) {
                Text("Mini-Challenge of the Day")
                    .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                    .foregroundColor(AppColors.primaryText)
                
                if let challenge = viewModel.dailyChallenge {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(challenge.title)
                                .font(.ubuntu(.medium, size: AppConstants.mediumFontSize))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Daily challenge")
                                .font(.ubuntu(.regular, size: AppConstants.smallFontSize))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.toggleChallengeCompletion(challenge)
                        } label: {
                            Text(challenge.isCompleted ? "Done!" : "Mark Done")
                                .font(.ubuntu(.medium, size: AppConstants.smallFontSize))
                                .foregroundColor(challenge.isCompleted ? AppColors.success : AppColors.primaryOrange)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    (challenge.isCompleted ? AppColors.success : AppColors.primaryOrange)
                                        .opacity(0.1)
                                )
                                .cornerRadius(AppConstants.smallCornerRadius)
                        }
                    }
                } else {
                    Text("No challenge available today")
                        .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
    }
}

struct DiarySection: View {
    @ObservedObject var viewModel: TodayViewModel
    
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: AppConstants.mediumSpacing) {
                Text("Daily Journal")
                    .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                    .foregroundColor(AppColors.primaryText)
                
                VStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Thoughts & Notes")
                            .font(.ubuntu(.medium, size: AppConstants.smallFontSize))
                            .foregroundColor(AppColors.secondaryText)
                        
                        TextField("What's on your mind?", text: $viewModel.diaryThoughts, axis: .vertical)
                            .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                            .foregroundColor(AppColors.primaryText)
                            .padding(12)
                            .background(AppColors.cardBackground)
                            .cornerRadius(AppConstants.smallCornerRadius)
                            .lineLimit(3...6)
                            .onChange(of: viewModel.diaryThoughts) { _ in
                                viewModel.saveDiaryEntry()
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today's Achievements")
                            .font(.ubuntu(.medium, size: AppConstants.smallFontSize))
                            .foregroundColor(AppColors.secondaryText)
                        
                        TextField("What did you accomplish?", text: $viewModel.diaryAchievements, axis: .vertical)
                            .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                            .foregroundColor(AppColors.primaryText)
                            .padding(12)
                            .background(AppColors.cardBackground)
                            .cornerRadius(AppConstants.smallCornerRadius)
                            .lineLimit(3...6)
                            .onChange(of: viewModel.diaryAchievements) { _ in
                                viewModel.saveDiaryEntry()
                            }
                    }
                }
            }
        }
    }
}

struct ProgressIndicatorSection: View {
    @ObservedObject var viewModel: TodayViewModel
    
    var body: some View {
        CardView {
            VStack(spacing: AppConstants.mediumSpacing) {
                Text("Today's Progress")
                    .font(.ubuntu(.semiBold, size: AppConstants.largeFontSize))
                    .foregroundColor(AppColors.primaryText)
                
                let progress = viewModel.todayProgress.progressPercentage
                
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .stroke(AppColors.separatorColor, lineWidth: 8)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(AppColors.primaryOrange, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                            .animation(.easeInOut(duration: 0.5), value: progress)
                        
                        Text("\(Int(progress * 100))%")
                            .font(.ubuntu(.bold, size: 18))
                            .foregroundColor(AppColors.primaryText)
                    }
                    
                    if viewModel.todayProgress.isFullyCompleted {
                        Text("Excellent work!")
                            .font(.ubuntu(.semiBold, size: AppConstants.mediumFontSize))
                            .foregroundColor(AppColors.success)
                    } else if progress > 0 {
                        Text("Keep going, you're doing great!")
                            .font(.ubuntu(.medium, size: AppConstants.mediumFontSize))
                            .foregroundColor(AppColors.primaryOrange)
                    } else {
                        Text("Start with one block - that's already progress")
                            .font(.ubuntu(.regular, size: AppConstants.mediumFontSize))
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
        }
    }
}

#Preview {
    TodayView()
}
