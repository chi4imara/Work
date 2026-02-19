import SwiftUI

struct TodayView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedWellnessStates: [WellnessType: Int] = [:]
    @State private var completedChallenges: Set<String> = []
    @State private var showingPracticeTimer = false
    @State private var selectedPractice: DailyPractice?
    @State private var showingAddPractice = false
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    greetingSection
                    
                    wellnessSection
                    
                    dailyPracticeSection
                    
                    dailyChallengeSection
                    
                    careHabitsSection
                    
                    careLevelSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .sheet(item: $selectedPractice) { practice in
            PracticeTimerView(practice: practice) {
                showingPracticeTimer = false
                selectedPractice = nil
                dismiss()
            }
        }
        .sheet(isPresented: $showingAddPractice) {
            AddPracticeView()
        }
        .onAppear {
            syncTodayStateFromDataManager()
        }
        .onChange(of: dataManager.todayEntry.id) { _ in
            syncTodayStateFromDataManager()
        }
    }
    
    private func syncTodayStateFromDataManager() {
        selectedWellnessStates = dataManager.todayEntry.wellnessStates
        completedChallenges = Set(dataManager.todayEntry.completedChallenges)
    }
    
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(dataManager.getGreeting())
                        .font(.playfair(28, weight: .bold))
                        .foregroundColor(ColorTheme.textColor)
                    
                    Text("How does your body feel today?")
                        .font(.playfair(16))
                        .foregroundColor(ColorTheme.secondaryColor)
                }
                
                Spacer()
                
                Image(systemName: "heart.fill")
                    .font(.system(size: 24))
                    .foregroundColor(ColorTheme.accentColor)
            }
        }
        .padding(.top, 60)
    }
    
    private var wellnessSection: some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Wellness Check")
                    .font(.playfair(20, weight: .semibold))
                    .foregroundColor(ColorTheme.textColor)
                
                VStack(spacing: 12) {
                    ForEach(WellnessType.allCases, id: \.self) { type in
                        WellnessRow(
                            type: type,
                            selectedLevel: selectedWellnessStates[type] ?? 0
                        ) { level in
                            selectedWellnessStates[type] = level
                            dataManager.updateWellnessState(type, level: level)
                        }
                    }
                }
                
                if !selectedWellnessStates.isEmpty {
                    Text("Thank you for noting your state")
                        .font(.playfair(14))
                        .foregroundColor(ColorTheme.accentColor)
                        .padding(.top, 8)
                }
            }
        }
    }
    
    private var dailyPracticeSection: some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Practice of the Day")
                    .font(.playfair(20, weight: .semibold))
                    .foregroundColor(ColorTheme.textColor)
                
                let todayPractice = DailyPractice.practices.randomElement() ?? DailyPractice.practices[0]
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: todayPractice.type.icon)
                            .font(.system(size: 20))
                            .foregroundColor(ColorTheme.accentColor)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(todayPractice.title)
                                .font(.playfair(16, weight: .medium))
                                .foregroundColor(ColorTheme.textColor)
                            
                            Text(todayPractice.description)
                                .font(.playfair(14))
                                .foregroundColor(ColorTheme.secondaryColor)
                        }
                        
                        Spacer()
                        
                        Text(todayPractice.duration)
                            .font(.playfair(12, weight: .medium))
                            .foregroundColor(ColorTheme.accentColor)
                    }
                    
                    Button(action: {
                        selectedPractice = todayPractice
                        showingPracticeTimer = true
                    }) {
                        Text("Start")
                            .font(.playfair(16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(ColorTheme.accentColor)
                            .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    private var dailyChallengeSection: some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Mini Challenge")
                    .font(.playfair(20, weight: .semibold))
                    .foregroundColor(ColorTheme.textColor)
                
                let todayChallenge = DailyChallenge.challenges.randomElement() ?? DailyChallenge.challenges[0]
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(todayChallenge.title)
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.textColor)
                    
                    Text(todayChallenge.description)
                        .font(.playfair(14))
                        .foregroundColor(ColorTheme.secondaryColor)
                    
                    Button(action: {
                        completedChallenges.insert(todayChallenge.title)
                        dataManager.completeChallenge(todayChallenge.title)
                    }) {
                        HStack {
                            Image(systemName: completedChallenges.contains(todayChallenge.title) ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(completedChallenges.contains(todayChallenge.title) ? ColorTheme.accentColor : ColorTheme.secondaryColor)
                            
                            Text("Done")
                                .font(.playfair(16, weight: .medium))
                                .foregroundColor(completedChallenges.contains(todayChallenge.title) ? ColorTheme.accentColor : ColorTheme.textColor)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            completedChallenges.contains(todayChallenge.title) ?
                            ColorTheme.accentColor.opacity(0.1) :
                                ColorTheme.cardBackground
                        )
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(ColorTheme.accentColor.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .disabled(completedChallenges.contains(todayChallenge.title))
                }
            }
        }
    }
    
    private var careHabitsSection: some View {
        CardView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Care Habits")
                        .font(.playfair(20, weight: .semibold))
                        .foregroundColor(ColorTheme.textColor)
                    
                    Spacer()
                    
                    Button(action: { showingAddPractice = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(ColorTheme.accentColor)
                    }
                }
                
                if dataManager.practices.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle")
                            .font(.system(size: 40))
                            .foregroundColor(ColorTheme.secondaryColor)
                        
                        Text("Add your first body care practice")
                            .font(.playfair(16))
                            .foregroundColor(ColorTheme.secondaryColor)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                } else {
                    LazyVStack(spacing: 8) {
                        ForEach(dataManager.practices.prefix(3)) { practice in
                            HabitRow(practice: practice)
                        }
                    }
                }
            }
        }
    }
    
    private var careLevelSection: some View {
        VStack(spacing: 16) {
            Text("Today's Care Level")
                .font(.playfair(18, weight: .medium))
                .foregroundColor(ColorTheme.textColor)
            
            ZStack {
                Circle()
                    .stroke(ColorTheme.secondaryColor.opacity(0.3), lineWidth: 8)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: dataManager.todayEntry.careLevel)
                    .stroke(ColorTheme.accentColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: dataManager.todayEntry.careLevel)
                
                Text("\(Int(dataManager.todayEntry.careLevel * 100))%")
                    .font(.playfair(20, weight: .bold))
                    .foregroundColor(ColorTheme.textColor)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(ColorTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
    }
}

struct WellnessRow: View {
    let type: WellnessType
    let selectedLevel: Int
    let onLevelSelected: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(type.rawValue)
                .font(.playfair(16, weight: .medium))
                .foregroundColor(ColorTheme.textColor)
            
            HStack(spacing: 12) {
                ForEach(1...5, id: \.self) { level in
                    Button(action: {
                        onLevelSelected(level)
                    }) {
                        Circle()
                            .fill(level <= selectedLevel ? ColorTheme.accentColor : ColorTheme.secondaryColor.opacity(0.3))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text("\(level)")
                                    .font(.playfair(12, weight: .medium))
                                    .foregroundColor(level <= selectedLevel ? .white : ColorTheme.secondaryColor)
                            )
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct HabitRow: View {
    @EnvironmentObject var dataManager: DataManager
    let practice: Practice
    
    var body: some View {
        HStack {
            Image(systemName: practice.type.icon)
                .font(.system(size: 16))
                .foregroundColor(ColorTheme.accentColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(practice.name)
                    .font(.playfair(14, weight: .medium))
                    .foregroundColor(ColorTheme.textColor)
                
                Text("\(practice.streak) day streak")
                    .font(.playfair(12))
                    .foregroundColor(ColorTheme.secondaryColor)
            }
            
            Spacer()
            
            Button(action: {
                dataManager.completePractice(practice)
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(ColorTheme.accentColor)
            }
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
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(ColorTheme.cardGradient)
            .cornerRadius(16)
            .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
    }
}

#Preview {
    TodayView()
        .environmentObject(DataManager.shared)
}
