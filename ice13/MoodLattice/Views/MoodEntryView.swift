import SwiftUI

struct MoodEntryView: View {
    @ObservedObject var dataManager: MoodDataManager
    let selectedDate: Date
    let entryToEdit: MoodEntry?
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedMood: MoodType?
    @State private var noteText = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    private var isEditing: Bool {
        entryToEdit != nil
    }
    
    private var canSave: Bool {
        selectedMood != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GradientBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        dateHeaderView
                        
                        moodSelectionView
                        
                        noteInputView
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Mood" : "New Mood")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveMoodEntry()
                }
                .disabled(!canSave)
                .foregroundColor(canSave ? AppColors.accent : AppColors.secondaryText)
            )
        }
        .alert(isPresented: $showingError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            setupInitialValues()
        }
    }
    
    private var dateHeaderView: some View {
        VStack(spacing: 10) {
            Text("Entry for")
                .font(FontManager.ubuntu(size: 16, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
            
            Text(formatDate(selectedDate))
                .font(FontManager.ubuntu(size: 24, weight: .bold))
                .foregroundColor(AppColors.primaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 5)
        )
    }
    
    private var moodSelectionView: some View {
        VStack(spacing: 20) {
            Text("How was your day?")
                .font(FontManager.ubuntu(size: 20, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 15) {
                ForEach(MoodType.allCases, id: \.self) { mood in
                    MoodSelectionButton(
                        mood: mood,
                        isSelected: selectedMood == mood
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedMood = mood
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 5)
        )
    }
    
    private var noteInputView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Add a note (optional)")
                .font(FontManager.ubuntu(size: 18, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.secondaryText.opacity(0.3), lineWidth: 1)
                    }
                
                if noteText.isEmpty {
                    Text("Describe the key moment of your day, 1-2 sentences...")
                        .font(FontManager.ubuntu(size: 16, weight: .regular))
                        .foregroundColor(AppColors.secondaryText.opacity(0.7))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .allowsHitTesting(false)
                }
                
                TextEditor(text: $noteText)
                    .font(FontManager.ubuntu(size: 16, weight: .regular))
                    .foregroundColor(AppColors.primaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.clear)
            }
            .frame(height: 120)
            
            Text("Describe the key moment of your day, 1-2 phrases.")
                .font(FontManager.ubuntu(size: 14, weight: .regular))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 5)
        )
    }
    
    private func setupInitialValues() {
        if let entry = entryToEdit {
            selectedMood = entry.mood
            noteText = entry.note
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    private func saveMoodEntry() {
        guard let mood = selectedMood else {
            errorMessage = "Choose a mood for the day"
            showingError = true
            return
        }
        
        let newEntry = MoodEntry(
            date: selectedDate,
            mood: mood,
            note: noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        dataManager.addEntry(newEntry)
        presentationMode.wrappedValue.dismiss()
    }
}

struct MoodSelectionButton: View {
    let mood: MoodType
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
        }) {
            VStack(spacing: 8) {
                Text(mood.rawValue)
                    .font(.system(size: 40))
                
                Text(mood.name)
                    .font(FontManager.ubuntu(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : AppColors.primaryText)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? AppColors.accent : Color.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(
                                isSelected ? AppColors.accent : AppColors.secondaryText.opacity(0.3),
                                lineWidth: isSelected ? 2 : 1
                            )
                    }
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(color: AppColors.shadowColor, radius: isSelected ? 8 : 3)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    MoodEntryView(
        dataManager: MoodDataManager(),
        selectedDate: Date(),
        entryToEdit: nil
    )
}
