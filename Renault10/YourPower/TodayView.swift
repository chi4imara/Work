import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel = TodayViewModel()
    @State private var showEnergySelection = false
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    
                    progressView
                    
                    energyAssessmentView
                    
                    miniRitualView
                    
                    dailyChallengeView
                    
                    habitsView
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
        .onAppear {
            viewModel.refreshFromStorage()
        }
        .overlay(
            VStack {
                if viewModel.showRitualComplete {
                    completionMessage("You've charged yourself with energy and confidence!")
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                if viewModel.showChallengeComplete {
                    completionMessage("Great job completing today's challenge!")
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                Spacer()
            }
                .animation(.spring(), value: viewModel.showRitualComplete)
                .animation(.spring(), value: viewModel.showChallengeComplete)
        )
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.greeting)
                .font(FontManager.bold(size: 28))
                .foregroundColor(ColorManager.primaryBlue)
            
            Text("How are you feeling today?")
                .font(FontManager.regular(size: 18))
                .foregroundColor(ColorManager.darkGray.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var progressView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Today's Progress")
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(ColorManager.darkGray)
                
                Spacer()
                
                Text("\(Int(viewModel.progressPercentage * 100))%")
                    .font(FontManager.bold(size: 16))
                    .foregroundColor(ColorManager.primaryBlue)
            }
            
            ProgressView(value: viewModel.progressPercentage)
                .progressViewStyle(CustomProgressViewStyle())
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var energyAssessmentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Energy Assessment")
                .font(FontManager.medium(size: 18))
                .foregroundColor(ColorManager.darkGray)
            
            if viewModel.selectedEnergyLevels.isEmpty {
                Button(action: { showEnergySelection = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(ColorManager.primaryBlue)
                        
                        Text("Rate your energy level")
                            .font(FontManager.regular(size: 16))
                            .foregroundColor(ColorManager.darkGray)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(ColorManager.lightGray)
                    }
                    .padding(16)
                    .background(ColorManager.lightBlue)
                    .cornerRadius(12)
                }
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Selected levels:")
                            .font(FontManager.regular(size: 14))
                            .foregroundColor(ColorManager.darkGray.opacity(0.7))
                        
                        Spacer()
                        
                        Button("Change") {
                            showEnergySelection = true
                        }
                        .font(FontManager.regular(size: 14))
                        .foregroundColor(ColorManager.primaryBlue)
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                        ForEach(viewModel.selectedEnergyLevels, id: \.self) { level in
                            VStack(spacing: 4) {
                                Image(systemName: level.icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(level.color)
                                
                                Text(level.title)
                                    .font(FontManager.regular(size: 12))
                                    .foregroundColor(ColorManager.darkGray)
                            }
                            .padding(8)
                            .background(level.color.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    
                    Text("Thank you for noting your state")
                        .font(FontManager.italic(size: 14))
                        .foregroundColor(ColorManager.success)
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .sheet(isPresented: $showEnergySelection) {
            EnergySelectionView(viewModel: viewModel)
        }
    }
    
    private var miniRitualView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mini Ritual")
                .font(FontManager.medium(size: 18))
                .foregroundColor(ColorManager.darkGray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if viewModel.todayEntry.completedRitual {
                completedStateView(
                    title: "Ritual Completed",
                    description: "You've completed today's ritual",
                    icon: "checkmark.circle.fill",
                    color: ColorManager.success
                )
            } else if viewModel.isRitualActive {
                activeRitualView
            } else {
                ritualSelectionView
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var activeRitualView: some View {
        VStack(spacing: 16) {
            if let ritual = viewModel.currentRitual {
                Text(ritual.title)
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(ColorManager.primaryBlue)
                
                Text(ritual.description)
                    .font(FontManager.regular(size: 14))
                    .foregroundColor(ColorManager.darkGray.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Text(timeString(from: viewModel.ritualTimeRemaining))
                    .font(FontManager.bold(size: 24))
                    .foregroundColor(ColorManager.primaryYellow)
                    .padding()
                    .background(ColorManager.primaryYellow.opacity(0.1))
                    .cornerRadius(12)
                
                Button("Complete Early") {
                    viewModel.completeRitual()
                }
                .font(FontManager.medium(size: 16))
                .foregroundColor(ColorManager.primaryBlue)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var ritualSelectionView: some View {
        VStack(spacing: 12) {
            Text("Choose your ritual for today")
                .font(FontManager.regular(size: 16))
                .foregroundColor(ColorManager.darkGray)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 16) {
                Button(action: { viewModel.startMorningRitual() }) {
                    VStack(spacing: 8) {
                        Image(systemName: "sunrise.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                        
                        Text("Morning")
                            .font(FontManager.medium(size: 14))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(ColorManager.yellowButtonGradient)
                    .cornerRadius(12)
                }
                
                Button(action: { viewModel.startEveningRitual() }) {
                    VStack(spacing: 8) {
                        Image(systemName: "moon.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                        
                        Text("Evening")
                            .font(FontManager.medium(size: 14))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(ColorManager.buttonGradient)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    private var dailyChallengeView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Daily Challenge")
                .font(FontManager.medium(size: 18))
                .foregroundColor(ColorManager.darkGray)
            
            if viewModel.todayEntry.completedChallenge {
                completedStateView(
                    title: "Challenge Completed",
                    description: "Great job on today's challenge!",
                    icon: "star.fill",
                    color: ColorManager.primaryYellow
                )
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text(viewModel.todayChallenge.title)
                        .font(FontManager.medium(size: 16))
                        .foregroundColor(ColorManager.primaryBlue)
                    
                    Text(viewModel.todayChallenge.description)
                        .font(FontManager.regular(size: 14))
                        .foregroundColor(ColorManager.darkGray.opacity(0.8))
                    
                    Button(action: { viewModel.completeChallenge() }) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                            
                            Text("I did it!")
                                .font(FontManager.medium(size: 16))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(ColorManager.success)
                        .cornerRadius(10)
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var habitsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Confidence Habits")
                    .font(FontManager.medium(size: 18))
                    .foregroundColor(ColorManager.darkGray)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(ColorManager.primaryBlue)
                }
            }
            
            if viewModel.habits.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "heart.circle")
                        .font(.system(size: 40))
                        .foregroundColor(ColorManager.lightGray)
                    
                    Text("Add your first habit and start taking care of yourself")
                        .font(FontManager.regular(size: 16))
                        .foregroundColor(ColorManager.darkGray.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.habits) { habit in
                        HabitRowView(habit: habit) {
                            viewModel.toggleHabit(habit)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private func completedStateView(title: String, description: String, icon: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(FontManager.medium(size: 16))
                    .foregroundColor(color)
                
                Text(description)
                    .font(FontManager.regular(size: 14))
                    .foregroundColor(ColorManager.darkGray.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(16)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func completionMessage(_ text: String) -> some View {
        Text(text)
            .font(FontManager.medium(size: 16))
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(ColorManager.success)
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            .padding(.horizontal, 20)
            .padding(.top, 10)
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

struct HabitRowView: View {
    let habit: Habit
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: onToggle) {
                Image(systemName: habit.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(habit.isCompleted ? ColorManager.success : ColorManager.lightGray)
            }
            
            HStack(spacing: 12) {
                Image(systemName: habit.icon)
                    .font(.system(size: 16))
                    .foregroundColor(ColorManager.primaryBlue)
                    .frame(width: 20)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(habit.name)
                        .font(FontManager.medium(size: 16))
                        .foregroundColor(ColorManager.darkGray)
                        .strikethrough(habit.isCompleted)
                    
                    if habit.streakDays > 0 {
                        Text("\(habit.streakDays) day streak")
                            .font(FontManager.regular(size: 12))
                            .foregroundColor(ColorManager.primaryBlue)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 8)
    }
}

struct CustomProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(ColorManager.lightGray)
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(ColorManager.buttonGradient)
                    .frame(
                        width: max(0, geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0)),
                        height: 8
                    )
                    .animation(.easeInOut(duration: 0.3), value: configuration.fractionCompleted)
            }
        }
        .frame(height: 8)
    }
}

#Preview {
    TodayView()
}
