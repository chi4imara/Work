import SwiftUI

struct TodayView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @State private var showingMoodSelector = false
    @State private var showingNewRitual = false
    @State private var sheetSelectedMood: Mood?
    @State private var sheetMoodNote = ""
    @State private var celebrationScale: CGFloat = 1.0
    @State private var showCelebration = false
    
    private var todayMood: Mood? { viewModel.getTodayEntry()?.selectedMood }
    private var todayNote: String { viewModel.getTodayEntry()?.note ?? "" }
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            FloatingBubblesView()
                .opacity(0.3)
            
            ScrollView {
                VStack(spacing: 24) {
                    headerView
                    moodSection
                    ritualsSection
                    challengeSection
                    progressSection
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            
            if showCelebration {
                celebrationOverlay
            }
        }
        .sheet(isPresented: $showingMoodSelector) {
            MoodSelectorSheet(
                selectedMood: $sheetSelectedMood,
                moodNote: $sheetMoodNote,
                viewModel: viewModel
            )
        }
        .sheet(isPresented: $showingNewRitual) {
            AddRitualView(viewModel: viewModel)
        }
        .onChange(of: showingMoodSelector) { newValue in
            if newValue, let entry = viewModel.getTodayEntry() {
                sheetSelectedMood = entry.selectedMood
                sheetMoodNote = entry.note
            }
        }
        .task {
            viewModel.ensureTodayEntry()
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.getGreeting())
                        .font(.playfairDisplay(24, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                    Text("How are you feeling today?")
                        .font(.playfairDisplay(16, weight: .regular))
                        .foregroundColor(AppColors.textSecondary)
                }
                Spacer()
                if let mood = todayMood {
                    VStack {
                        Image(systemName: mood.emotion.systemImage)
                            .font(.system(size: 24))
                            .foregroundColor(mood.emotion.color)
                        Text(mood.emotion.displayName)
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
        }
    }
    
    private var moodSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mood")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
            Button(action: { showingMoodSelector = true }) {
                HStack {
                    Image(systemName: todayMood?.emotion.systemImage ?? "plus.circle")
                        .font(.system(size: 24))
                        .foregroundColor(todayMood?.emotion.color ?? AppColors.primaryBlue)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(todayMood?.emotion.displayName ?? "Select your mood")
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(AppColors.textDark)
                        if let mood = todayMood, !mood.note.isEmpty {
                            Text(mood.note)
                                .font(.playfairDisplay(14, weight: .regular))
                                .foregroundColor(AppColors.textSecondary)
                                .lineLimit(2)
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                        .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var ritualsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Mini Rituals")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
                Button(action: { showingNewRitual = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryBlue)
                }
            }
            LazyVStack(spacing: 12) {
                ForEach(viewModel.rituals) { ritual in
                    RitualCardView(ritual: ritual, viewModel: viewModel)
                }
            }
        }
    }
    
    private var challengeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Mini Challenge of the Day")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
            let challenge = viewModel.currentDailyChallenge
            VStack(alignment: .leading, spacing: 12) {
                Text(challenge.description)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.textDark)
                Button(action: {
                    viewModel.completeDailyChallenge()
                    showCelebrationAnimation()
                }) {
                    HStack {
                        Image(systemName: challenge.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 20))
                            .foregroundColor(challenge.isCompleted ? AppColors.lightGreen : AppColors.primaryBlue)
                        Text(challenge.isCompleted ? "Completed!" : "I did it!")
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(challenge.isCompleted ? AppColors.lightGreen : AppColors.primaryBlue)
                    }
                }
                .disabled(challenge.isCompleted)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: AppColors.primaryYellow.opacity(0.2), radius: 8, x: 0, y: 4)
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today's Progress")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
            let progress = viewModel.getTodayProgressPercentage()
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 8)
                        .frame(width: 80, height: 80)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [AppColors.primaryBlue, AppColors.primaryYellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 1.0), value: progress)
                    Text("\(Int(progress * 100))%")
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                }
                Text(progressMessage(for: progress))
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var celebrationOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text("🎉")
                    .font(.system(size: 60))
                    .scaleEffect(celebrationScale)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: celebrationScale)
                Text("Great job!")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(.white)
                Text("You're taking care of yourself!")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.primaryBlue)
                    .shadow(radius: 20)
            )
        }
        .onTapGesture { hideCelebration() }
    }
    
    private func progressMessage(for progress: Double) -> String {
        switch progress {
        case 0: return "Start with one step - it's already important"
        case 0.33: return "Great start! Keep going"
        case 0.66: return "You're doing amazing!"
        case 1.0: return "Perfect day! You're taking great care of yourself"
        default: return "Every step counts"
        }
    }
    
    private func showCelebrationAnimation() {
        showCelebration = true
        celebrationScale = 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { hideCelebration() }
    }
    
    private func hideCelebration() {
        withAnimation(.easeOut(duration: 0.3)) {
            showCelebration = false
            celebrationScale = 1.0
        }
    }
}

struct RitualCardView: View {
    let ritual: Ritual
    @ObservedObject var viewModel: MoodViewModel
    @State private var isCompleted = false
    
    var body: some View {
        HStack {
            Button(action: {
                if !isCompleted {
                    viewModel.toggleRitualCompletion(ritual)
                    withAnimation(.spring()) { isCompleted = true }
                }
            }) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isCompleted ? AppColors.lightGreen : AppColors.primaryBlue)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(ritual.name)
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(AppColors.textDark)
                Text(ritual.category.displayName)
                    .font(.playfairDisplay(12, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
            }
            Spacer()
            Image(systemName: ritual.category.systemImage)
                .font(.system(size: 16))
                .foregroundColor(ritual.category.color)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: ritual.category.color.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .onAppear { isCompleted = ritual.isCompleted }
    }
}

#Preview {
    TodayView()
        .environmentObject(MoodViewModel())
}
