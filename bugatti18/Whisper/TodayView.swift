import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel = TodayViewModel()
    @State private var showingAddHabit = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            ScrollView {
                VStack(spacing: Theme.Spacing.lg) {
                    GreetingSection(viewModel: viewModel)
                    
                    MoodSelectionSection(viewModel: viewModel)
                    
                    GratitudeJournalSection(viewModel: viewModel)
                    
                    HabitsSection(viewModel: viewModel, showingAddHabit: $showingAddHabit)
                    
                    DailyQuestionSection(viewModel: viewModel)
                    
                    ProgressSection(viewModel: viewModel)
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.bottom, 100)
            }
            
            if viewModel.showingCelebration {
                CelebrationOverlay()
            }
            
            if viewModel.showingMoodSelection {
                VStack {
                    Spacer()
                    Text("Thank you for sharing!")
                        .font(Theme.Fonts.playfairMedium(size: 16))
                        .foregroundColor(Theme.Colors.success)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                                .fill(Theme.Colors.background.opacity(0.9))
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    Spacer()
                        .frame(height: 150)
                }
                .animation(Theme.Animation.bounce, value: viewModel.showingMoodSelection)
            }
        }
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView { habit in
                viewModel.addHabit(habit)
            }
        }
        .onAppear {
            viewModel.reloadHabits()
        }
    }
}

struct GreetingSection: View {
    @ObservedObject var viewModel: TodayViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text(viewModel.greeting)
                        .font(Theme.Fonts.playfairBold(size: 24))
                        .foregroundColor(Theme.Colors.text)
                    
                    Text("How are you feeling today?")
                        .font(Theme.Fonts.playfairRegular(size: 16))
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                Spacer()
            }
        }
        .padding(.top, Theme.Spacing.lg)
    }
}

struct MoodSelectionSection: View {
    @ObservedObject var viewModel: TodayViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Select your mood (up to 3)")
                .font(Theme.Fonts.playfairSemiBold(size: 18))
                .foregroundColor(Theme.Colors.text)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: Theme.Spacing.md) {
                ForEach(Mood.defaultMoods) { mood in
                    MoodButton(
                        mood: mood,
                        isSelected: viewModel.dailyEntry.selectedMoods.contains { $0.id == mood.id },
                        action: { viewModel.selectMood(mood) }
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
}

struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: Theme.Spacing.xs) {
                Text(mood.emoji)
                    .font(.system(size: 30))
                
                Text(mood.name)
                    .font(Theme.Fonts.playfairRegular(size: 12))
                    .foregroundColor(isSelected ? .white : Theme.Colors.text)
            }
            .frame(width: 70, height: 70)
            .background(
                RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                    .fill(isSelected ? Theme.Colors.primary : Theme.Colors.background.opacity(0.5))
            )
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(Theme.Animation.bounce, value: isSelected)
        }
    }
}

struct GratitudeJournalSection: View {
    @ObservedObject var viewModel: TodayViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Gratitude Journal")
                .font(Theme.Fonts.playfairSemiBold(size: 18))
                .foregroundColor(Theme.Colors.text)
            
            ForEach(viewModel.dailyEntry.gratitudeEntries) { entry in
                HStack {
                    Image(systemName: "heart.fill")
                        .foregroundColor(Theme.Colors.accent)
                    
                    Text(entry.text)
                        .font(Theme.Fonts.playfairRegular(size: 14))
                        .foregroundColor(Theme.Colors.text)
                    
                    Spacer()
                }
                .padding(.vertical, Theme.Spacing.xs)
            }
            
            VStack(spacing: Theme.Spacing.sm) {
                TextField("What are you grateful for today?", text: $viewModel.newGratitudeText, axis: .vertical)
                    .font(Theme.Fonts.playfairRegular(size: 14))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3)
                
                Button {
                    viewModel.addGratitudeEntry()
                } label: {
                    Text("Save")
                        .font(Theme.Fonts.playfairSemiBold(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, Theme.Spacing.lg)
                        .padding(.vertical, Theme.Spacing.sm)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                                .fill(Theme.Colors.secondary)
                        )
                }
                .disabled(viewModel.newGratitudeText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            
            if viewModel.dailyEntry.gratitudeEntries.isEmpty {
                Text("Start with one item - that's already success!")
                    .font(Theme.Fonts.playfairItalic(size: 12))
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
}

struct HabitsSection: View {
    @ObservedObject var viewModel: TodayViewModel
    @Binding var showingAddHabit: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Text("Mini-challenges & Habits")
                    .font(Theme.Fonts.playfairSemiBold(size: 18))
                    .foregroundColor(Theme.Colors.text)
                
                Spacer()
                
                Button(action: { showingAddHabit = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Theme.Colors.primary)
                        .font(.title2)
                }
            }
            
            if viewModel.habits.isEmpty {
                Text("Add your first habit and start enjoying yourself")
                    .font(Theme.Fonts.playfairItalic(size: 14))
                    .foregroundColor(Theme.Colors.textSecondary)
                    .padding()
            } else {
                ForEach(viewModel.habits) { habit in
                    HabitRow(habit: habit) {
                        viewModel.toggleHabit(habit)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
}

struct HabitRow: View {
    let habit: Habit
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(habit.isCompletedToday ? Theme.Colors.success : Theme.Colors.textSecondary)
                    .font(.title2)
            }
            
            Image(systemName: habit.icon)
                .foregroundColor(Theme.Colors.accent)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.name)
                    .font(Theme.Fonts.playfairMedium(size: 14))
                    .foregroundColor(Theme.Colors.text)
                
                if habit.currentStreak > 0 {
                    Text("\(habit.currentStreak) day streak")
                        .font(Theme.Fonts.playfairRegular(size: 12))
                        .foregroundColor(Theme.Colors.success)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, Theme.Spacing.xs)
    }
}

struct DailyQuestionSection: View {
    @ObservedObject var viewModel: TodayViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Question of the Day")
                .font(Theme.Fonts.playfairSemiBold(size: 18))
                .foregroundColor(Theme.Colors.text)
            
            if let question = viewModel.dailyEntry.dailyQuestion {
                Text(question.question)
                    .font(Theme.Fonts.playfairMedium(size: 16))
                    .foregroundColor(Theme.Colors.primary)
                
                TextField("Your answer...", text: $viewModel.dailyQuestionAnswer, axis: .vertical)
                    .font(Theme.Fonts.playfairRegular(size: 14))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(4)
                    .onChange(of: viewModel.dailyQuestionAnswer) { _ in
                        viewModel.saveDailyQuestionAnswer()
                    }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
}

struct ProgressSection: View {
    @ObservedObject var viewModel: TodayViewModel
    
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            Text("Today's Progress")
                .font(Theme.Fonts.playfairSemiBold(size: 18))
                .foregroundColor(Theme.Colors.text)
            
            ZStack {
                Circle()
                    .stroke(Theme.Colors.primary.opacity(0.2), lineWidth: 8)
                    .frame(width: 120, height: 120)
                
                Circle()
                    .trim(from: 0, to: viewModel.todayProgress)
                    .stroke(
                        LinearGradient(
                            colors: [Theme.Colors.primary, Theme.Colors.secondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(Theme.Animation.medium, value: viewModel.todayProgress)
                
                Text("\(Int(viewModel.todayProgress * 100))%")
                    .font(Theme.Fonts.playfairBold(size: 24))
                    .foregroundColor(Theme.Colors.text)
            }
            
            if viewModel.todayProgress >= 1.0 {
                Text("You're amazing!")
                    .font(Theme.Fonts.playfairSemiBold(size: 16))
                    .foregroundColor(Theme.Colors.success)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: Theme.CornerRadius.lg)
                .fill(Theme.Colors.background.opacity(0.8))
        )
    }
}

struct CelebrationOverlay: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack {
                Text("🎉")
                    .font(.system(size: 60))
                    .scaleEffect(isAnimating ? 1.5 : 0.5)
                    .animation(Theme.Animation.bounce, value: isAnimating)
                
                Text("You're wonderful!")
                    .font(Theme.Fonts.playfairBold(size: 24))
                    .foregroundColor(.white)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(Theme.Animation.medium.delay(0.3), value: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct AddHabitView: View {
    let onSave: (Habit) -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var selectedCategory = HabitCategory.body
    @State private var selectedIcon = "star.fill"
    @State private var selectedFrequency = HabitFrequency.daily
    @State private var whyImportant = ""
    
    private let availableIcons = [
        "star.fill", "heart.fill", "leaf.fill", "flame.fill", "bolt.fill",
        "figure.walk", "figure.run", "bed.double.fill", "book.fill", "paintbrush.fill",
        "music.note", "camera.fill", "phone.fill", "message.fill", "envelope.fill"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: Theme.Spacing.lg) {
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Habit Name")
                                .font(Theme.Fonts.playfairSemiBold(size: 16))
                                .foregroundColor(Theme.Colors.text)
                            
                            TextField("Enter habit name", text: $name)
                                .font(Theme.Fonts.playfairRegular(size: 14))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Category")
                                .font(Theme.Fonts.playfairSemiBold(size: 16))
                                .foregroundColor(Theme.Colors.text)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: Theme.Spacing.sm) {
                                ForEach(HabitCategory.allCases, id: \.self) { category in
                                    Button(action: { selectedCategory = category }) {
                                        VStack(spacing: Theme.Spacing.xs) {
                                            Image(systemName: category.icon)
                                                .font(.title2)
                                                .foregroundColor(selectedCategory == category ? .white : Theme.Colors.primary)
                                            
                                            Text(category.rawValue)
                                                .font(Theme.Fonts.playfairRegular(size: 12))
                                                .foregroundColor(selectedCategory == category ? .white : Theme.Colors.text)
                                        }
                                        .frame(height: 60)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            RoundedRectangle(cornerRadius: Theme.CornerRadius.md)
                                                .fill(selectedCategory == category ? Theme.Colors.primary : Theme.Colors.background.opacity(0.5))
                                        )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Choose Icon")
                                .font(Theme.Fonts.playfairSemiBold(size: 16))
                                .foregroundColor(Theme.Colors.text)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: Theme.Spacing.sm) {
                                ForEach(availableIcons, id: \.self) { icon in
                                    Button(action: { selectedIcon = icon }) {
                                        Image(systemName: icon)
                                            .font(.title2)
                                            .foregroundColor(selectedIcon == icon ? .white : Theme.Colors.primary)
                                            .frame(width: 40, height: 40)
                                            .background(
                                                RoundedRectangle(cornerRadius: Theme.CornerRadius.sm)
                                                    .fill(selectedIcon == icon ? Theme.Colors.primary : Theme.Colors.background.opacity(0.5))
                                            )
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Frequency")
                                .font(Theme.Fonts.playfairSemiBold(size: 16))
                                .foregroundColor(Theme.Colors.text)
                            
                            VStack(spacing: Theme.Spacing.xs) {
                                ForEach(HabitFrequency.allCases, id: \.self) { frequency in
                                    Button(action: { selectedFrequency = frequency }) {
                                        HStack {
                                            Image(systemName: selectedFrequency == frequency ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(selectedFrequency == frequency ? Theme.Colors.primary : Theme.Colors.textSecondary)
                                            
                                            Text(frequency.rawValue)
                                                .font(Theme.Fonts.playfairRegular(size: 14))
                                                .foregroundColor(Theme.Colors.text)
                                            
                                            Spacer()
                                        }
                                        .padding(.vertical, Theme.Spacing.sm)
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                            Text("Why is this important? (Optional)")
                                .font(Theme.Fonts.playfairSemiBold(size: 16))
                                .foregroundColor(Theme.Colors.text)
                            
                            TextField("Your motivation...", text: $whyImportant, axis: .vertical)
                                .font(Theme.Fonts.playfairRegular(size: 14))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(3)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.bottom, Theme.Spacing.xl)
                }
            }
            .navigationTitle("Add Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Theme.Colors.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let habit = Habit(
                            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                            category: selectedCategory,
                            icon: selectedIcon,
                            frequency: selectedFrequency,
                            whyImportant: whyImportant
                        )
                        onSave(habit)
                        dismiss()
                    }
                    .foregroundColor(Theme.Colors.primary)
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    TodayView()
}
