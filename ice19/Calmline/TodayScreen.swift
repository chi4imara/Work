import SwiftUI

struct TodayScreen: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var todayEntry: DayEntry
    @State private var showingNoteScreen = false
    @State private var isFirstTime = true
    
    @Binding var selectedTab: Int
    
    init(selectedTab: Binding<Int> = .constant(0)) {
        _todayEntry = State(initialValue: DataManager.shared.getTodayEntry())
        _selectedTab = selectedTab
    }
    
    var body: some View {
        ZStack {
            ColorManager.shared.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    motivationWidget
                    
                    if isFirstTime && !todayEntry.hasAnyChecked {
                        firstTimeView
                    } else {
                        habitsListSection
                        
                        if todayEntry.hasAnyChecked {
                            daySummarySection
                        } else {
                            emptyStateSection
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
        }
        .onAppear {
            todayEntry = dataManager.getTodayEntry()
            checkFirstTime()
        }
        .onReceive(dataManager.$dayEntries) { _ in
            todayEntry = dataManager.getTodayEntry()
            checkFirstTime()
        }
        .sheet(isPresented: $showingNoteScreen, onDismiss: {
            todayEntry = dataManager.getTodayEntry()
            checkFirstTime()
        }) {
            NoteScreen(entry: $todayEntry)
                .environmentObject(dataManager)
        }
    }
    
    private var motivationWidget: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 16))
                    .foregroundColor(ColorManager.shared.primaryYellow)
                
                Text("Daily Inspiration")
                    .font(.ubuntu(14, weight: .bold))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                
                Spacer()
            }
            
            Text(dataManager.getRandomInspirationalPhrase())
                .font(.ubuntu(15, weight: .medium))
                .foregroundColor(ColorManager.shared.darkGray)
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    ColorManager.shared.primaryYellow.opacity(0.15),
                    ColorManager.shared.primaryPurple.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    LinearGradient(
                        colors: [
                            ColorManager.shared.primaryYellow.opacity(0.3),
                            ColorManager.shared.primaryPurple.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Today")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(ColorManager.shared.primaryBlue)
                    
                    Text(DateFormatter.dayFormatter.string(from: Date()))
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorManager.shared.darkGray)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: {
                        withAnimation {
                            selectedTab = 1
                        }
                    }) {
                        Image(systemName: "book.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(ColorManager.shared.primaryPurple)
                    }
                    
                    Button(action: {
                        withAnimation {
                            selectedTab = 2
                        }
                    }) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 28))
                            .foregroundColor(ColorManager.shared.primaryPurple)
                    }
                }
            }
            
            Text("What wasn't there today?")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(ColorManager.shared.primaryBlue.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var firstTimeView: some View {
        VStack(spacing: 30) {
            Image(systemName: "leaf.circle")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorManager.shared.softGreen)
            
            VStack(spacing: 16) {
                Text("Every day is a chance to be a little calmer.")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                    .multilineTextAlignment(.center)
                
                Text("Start small — mark what wasn't there today.")
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorManager.shared.darkGray)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isFirstTime = false
                }
            } label: {
                Text("Make First Mark")
                    .font(.ubuntu(16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(ColorManager.shared.purpleGradient)
                    .cornerRadius(25)
                    .shadow(color: ColorManager.shared.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
    }
    
    private var habitsListSection: some View {
        LazyVStack(spacing: 12) {
            ForEach(Habit.defaultHabits) { habit in
                HabitCard(
                    habit: habit,
                    isChecked: todayEntry.checkedHabits.contains(habit.title),
                    onToggle: {
                        toggleHabit(habit.title)
                    }
                )
            }
        }
    }
    
    private var emptyStateSection: some View {
        VStack(spacing: 16) {
            Text("Still empty. What did you manage to avoid today?")
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorManager.shared.darkGray.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .padding(.vertical, 30)
    }
    
    private var daySummarySection: some View {
        VStack(spacing: 20) {
            VStack(spacing: 16) {
                Text("Day Summary")
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(ColorManager.shared.primaryBlue)
                
                let checkedHabitsText = Array(todayEntry.checkedHabits)
                    .map { $0.lowercased().replacingOccurrences(of: "didn't ", with: "") }
                    .joined(separator: ", ")
                
                Text("Today without: \(checkedHabitsText).")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorManager.shared.darkGray)
                    .multilineTextAlignment(.center)
                
                Text("Good day, write down how you managed it.")
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorManager.shared.darkGray.opacity(0.7))
                    .multilineTextAlignment(.center)
                
                Button {
                    showingNoteScreen = true
                } label: {
                    Text("Add Note")
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(ColorManager.shared.primaryYellow)
                        .cornerRadius(20)
                        .shadow(color: ColorManager.shared.primaryYellow.opacity(0.3), radius: 6, x: 0, y: 3)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(ColorManager.shared.cardGradient)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
    
    private func toggleHabit(_ habitTitle: String) {
        if todayEntry.checkedHabits.contains(habitTitle) {
            todayEntry.checkedHabits.remove(habitTitle)
        } else {
            todayEntry.checkedHabits.insert(habitTitle)
        }
        
        dataManager.updateTodayEntry(todayEntry)
    }
    
    private func checkFirstTime() {
        isFirstTime = dataManager.dayEntries.filter { $0.hasAnyChecked }.isEmpty
    }
}

struct HabitCard: View {
    let habit: Habit
    let isChecked: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.title)
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(ColorManager.shared.primaryBlue)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(habit.description)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(ColorManager.shared.darkGray.opacity(0.8))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 24))
                    .foregroundColor(isChecked ? ColorManager.shared.softGreen : ColorManager.shared.lightGray)
                    .scaleEffect(isChecked ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isChecked)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(ColorManager.shared.cardGradient)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isChecked ? ColorManager.shared.softGreen.opacity(0.3) : Color.clear,
                        lineWidth: 2
                    )
            )
            .scaleEffect(isChecked ? 1.02 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isChecked)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension DateFormatter {
    static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter
    }()
}

