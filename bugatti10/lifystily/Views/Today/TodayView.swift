import SwiftUI

struct TodayView: View {
    @EnvironmentObject var diaryViewModel: DiaryViewModel
    @State private var selectedMood: MoodType?
    @State private var quickNote: String = ""
    @State private var showingThankYou = false
    @State private var showingNewEntry = false
    
    private let todaysQuestion = DailyQuestion.forDate(Date())
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Hello. How are you today?")
                            .font(.ubuntuTitle())
                            .foregroundColor(ColorTheme.primaryText)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    MoodSelectionView(selectedMood: $selectedMood)
                    
                    DailyQuestionCard(
                        question: todaysQuestion.text,
                        quickNote: $quickNote
                    )
                    
                    SaveThoughtButton(
                        selectedMood: selectedMood,
                        quickNote: quickNote,
                        showingThankYou: $showingThankYou,
                        diaryViewModel: diaryViewModel,
                        onSave: {
                            selectedMood = nil
                            quickNote = ""
                        }
                    )
                    
                    if !diaryViewModel.recentEntries.isEmpty {
                        RecentEntriesSection(entries: diaryViewModel.recentEntries)
                    }
                    
                    OpenDiaryButton(showingNewEntry: $showingNewEntry)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
            }
        }
        .overlay(
            ThankYouOverlay(isShowing: $showingThankYou)
        )
        .sheet(isPresented: $showingNewEntry) {
            NewEntryView(diaryViewModel: diaryViewModel)
        }
    }
}

struct MoodSelectionView: View {
    @Binding var selectedMood: MoodType?
    
    private let mainMoods: [MoodType] = [.happy, .sad, .calm, .anxious, .excited, .tired]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How are you feeling?")
                .font(.ubuntuHeadline())
                .foregroundColor(ColorTheme.accentText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(mainMoods, id: \.self) { mood in
                    MoodButton(
                        mood: mood,
                        isSelected: selectedMood == mood,
                        action: {
                            selectedMood = selectedMood == mood ? nil : mood
                        }
                    )
                }
            }
        }
        .padding(20)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct MoodButton: View {
    let mood: MoodType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: mood.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : mood.color)
                
                Text(mood.displayName)
                    .font(.ubuntuCaption())
                    .foregroundColor(isSelected ? .white : ColorTheme.primaryText)
            }
            .frame(height: 70)
            .frame(maxWidth: .infinity)
            .background(isSelected ? mood.color : Color.clear)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(mood.color, lineWidth: isSelected ? 0 : 1)
            )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

struct DailyQuestionCard: View {
    let question: String
    @Binding var quickNote: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(question)
                .font(.ubuntuHeadline())
                .foregroundColor(ColorTheme.accentText)
            
            TextField("Your thoughts...", text: $quickNote, axis: .vertical)
                .font(.ubuntuBody())
                .padding(16)
                .background(Color.white.opacity(0.5))
                .cornerRadius(12)
                .lineLimit(3...6)
        }
        .padding(20)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct SaveThoughtButton: View {
    let selectedMood: MoodType?
    let quickNote: String
    @Binding var showingThankYou: Bool
    let diaryViewModel: DiaryViewModel
    let onSave: () -> Void
    
    var body: some View {
        Button(action: saveThought) {
            Text("Save Thought")
                .font(.ubuntuHeadline())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [ColorTheme.primaryBlue, ColorTheme.primaryYellow],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(28)
        }
        .disabled(selectedMood == nil && quickNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        .opacity(selectedMood == nil && quickNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
    }
    
    private func saveThought() {
        let entry = DiaryEntry(
            mood: selectedMood,
            text: quickNote,
            emotions: selectedMood != nil ? [selectedMood!] : []
        )
        
        diaryViewModel.addEntry(entry)
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showingThankYou = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingThankYou = false
            }
        }
        
        onSave()
    }
}

struct RecentEntriesSection: View {
    let entries: [DiaryEntry]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Recent Thoughts")
                .font(.ubuntuHeadline())
                .foregroundColor(ColorTheme.accentText)
            
            VStack(spacing: 12) {
                ForEach(entries.prefix(3)) { entry in
                    RecentEntryCard(entry: entry)
                }
            }
        }
        .padding(20)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: ColorTheme.cardShadow, radius: 8, x: 0, y: 4)
    }
}

struct RecentEntryCard: View {
    let entry: DiaryEntry
    
    var body: some View {
        HStack(spacing: 12) {
            if let mood = entry.mood {
                Image(systemName: mood.icon)
                    .font(.title3)
                    .foregroundColor(mood.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.shortDate)
                    .font(.ubuntuCaption())
                    .foregroundColor(ColorTheme.secondaryText)
                
                Text(entry.preview)
                    .font(.ubuntuBody())
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if entry.isFavorite {
                Image(systemName: "heart.fill")
                    .font(.caption)
                    .foregroundColor(ColorTheme.softPink)
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.5))
        .cornerRadius(12)
    }
}

struct OpenDiaryButton: View {
    @Binding var showingNewEntry: Bool
    
    var body: some View {
        Button(action: { showingNewEntry = true }) {
            Text("Open Diary")
                .font(.ubuntuHeadline())
                .foregroundColor(ColorTheme.accentText)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.white.opacity(0.8))
                .cornerRadius(28)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(ColorTheme.primaryBlue, lineWidth: 2)
                )
        }
    }
}

struct ThankYouOverlay: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        if isShowing {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 50))
                        .foregroundColor(ColorTheme.primaryYellow)
                    
                    Text("Thank you for sharing")
                        .font(.ubuntuHeadline())
                        .foregroundColor(ColorTheme.primaryText)
                }
                .padding(40)
                .background(ColorTheme.cardBackground)
                .cornerRadius(20)
                .shadow(color: ColorTheme.cardShadow, radius: 20, x: 0, y: 10)
            }
            .transition(.opacity)
        }
    }
}

#Preview {
    TodayView()
        .environmentObject(DiaryViewModel())
}
