import SwiftUI

struct AddMood: View {
    @ObservedObject var dataManager: MoodDataManager
    @State private var selectedDate: Date
    let entryToEdit: MoodEntry?
    let onSave: (() -> Void)?
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedMood: MoodType?
    @State private var noteText = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var showingDatePicker = false
    
    init(dataManager: MoodDataManager, selectedDate: Date, entryToEdit: MoodEntry?, onSave: (() -> Void)? = nil) {
        self.dataManager = dataManager
        self._selectedDate = State(initialValue: selectedDate)
        self.entryToEdit = entryToEdit
        self.onSave = onSave
    }
    
    private var isEditing: Bool {
        entryToEdit != nil
    }
    
    private var canSave: Bool {
        selectedMood != nil
    }
    
    var body: some View {
        ZStack {
            GradientBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("New Mood")
                        .font(FontManager.ubuntu(size: 28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        datePickerView
                        
                        moodSelectionView
                        
                        noteInputView
                        
                        saveButtonView
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
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
    
    private var datePickerView: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Select Date")
                    .font(FontManager.ubuntu(size: 18, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
            }
            
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    showingDatePicker.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.accent)
                    
                    Text(formatDate(selectedDate))
                        .font(FontManager.ubuntu(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    Image(systemName: showingDatePicker ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.accent.opacity(0.3), lineWidth: 1)
                        }
                )
            }
            
            if showingDatePicker {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .accentColor(AppColors.accent)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.accent.opacity(0.3), lineWidth: 1)
                        }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 5)
        )
    }
    
    private var saveButtonView: some View {
        Button(action: {
            saveMoodEntry()
        }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                
                Text("Save")
                    .font(FontManager.ubuntu(size: 18, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: canSave ? [AppColors.accent, AppColors.accent.opacity(0.8)] : [AppColors.secondaryText.opacity(0.5), AppColors.secondaryText.opacity(0.3)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: canSave ? AppColors.accent.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
        }
        .disabled(!canSave)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
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
        
        if let onSave = onSave {
            onSave()
        } else {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
