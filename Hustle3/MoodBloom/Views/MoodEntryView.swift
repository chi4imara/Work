import SwiftUI

struct MoodEntryView: View {
    @ObservedObject var moodViewModel: MoodViewModel
    @ObservedObject var settings: AppSettings
    let selectedDate: Date
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedMood: MoodType?
    @State private var comment: String = ""
    @State private var photoIds: [String] = []
    @State private var hasChanges = false
    @State private var showingDeleteAlert = false
    @State private var showingDiscardAlert = false
    @State private var showingFutureDateAlert = false
    @State private var showingMoodRequiredAlert = false
    
    private var existingEntry: MoodEntry? {
        moodViewModel.getMoodEntry(for: selectedDate)
    }
    
    private var isNewEntry: Bool {
        existingEntry == nil
    }
    
    private var availableMoods: [MoodType] {
        settings.useExtendedMoods ? MoodType.extendedMoods : MoodType.basicMoods
    }
    
    private var characterLimit: Int {
        settings.commentLimit.rawValue
    }
    
    private var isCommentValid: Bool {
        comment.count <= characterLimit
    }
    
    private var canSave: Bool {
        selectedMood != nil && isCommentValid && moodViewModel.canAddEntry(for: selectedDate)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        dateHeaderView
                        
                        moodSelectionView
                        
                        commentSectionView
                        
                        photoSectionView
                        
                        if !isNewEntry {
                            miniChartView
                        }
                        
                        actionButtonsView
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle(isNewEntry ? "New Entry" : "Entry Details")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if hasChanges {
                            showingDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }
                    .foregroundColor(Color.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEntry()
                    }
                    .foregroundColor(canSave ? Color.primaryBlue : Color.textSecondary.opacity(0.5))
                    .fontWeight(.semibold)
                    .disabled(!canSave)
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
        .onChange(of: selectedMood) { _ in checkForChanges() }
        .onChange(of: comment) { _ in checkForChanges() }
        .onChange(of: photoIds) { _ in checkForChanges() }
        .alert("Delete Entry?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteEntry()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
        .alert("Discard Changes?", isPresented: $showingDiscardAlert) {
            Button("Discard", role: .destructive) {
                dismiss()
            }
            Button("Keep Editing", role: .cancel) { }
        } message: {
            Text("You have unsaved changes. Are you sure you want to discard them?")
        }
        .alert("Future Date", isPresented: $showingFutureDateAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You cannot record mood for future dates.")
        }
        .alert("Select Mood", isPresented: $showingMoodRequiredAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please select a mood before saving.")
        }
    }
    
    private var dateHeaderView: some View {
        VStack(spacing: 8) {
            Text(dateString(from: selectedDate))
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            Text(dayString(from: selectedDate))
                .font(FontManager.body)
                .foregroundColor(Color.textSecondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var moodSelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("How are you feeling?")
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                ForEach(availableMoods, id: \.self) { mood in
                    MoodButton(
                        mood: mood,
                        isSelected: selectedMood == mood,
                        useExtended: settings.useExtendedMoods
                    ) {
                        selectedMood = mood
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var commentSectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Add a note (optional)")
                    .font(FontManager.headline)
                    .foregroundColor(Color.textPrimary)
                
                Spacer()
                
                Text("\(comment.count)/\(characterLimit)")
                    .font(FontManager.caption)
                    .foregroundColor(isCommentValid ? Color.textSecondary : Color.accentRed)
            }
            
            TextEditor(text: $comment)
                .font(FontManager.body)
                .foregroundColor(Color.textPrimary)
                .scrollContentBackground(.hidden)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.backgroundGray.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isCommentValid ? Color.clear : Color.accentRed, lineWidth: 1)
                        )
                )
                .frame(minHeight: 100)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var miniChartView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("7-Day Mood Trend")
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            MiniMoodChart(
                entries: moodViewModel.getEntriesForPeriod(.week, from: selectedDate),
                selectedDate: selectedDate,
                selectedMood: selectedMood
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var photoSectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            PhotoGalleryView(photoIds: $photoIds)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 16) {
            if !isNewEntry {
                Button("Delete Entry") {
                    showingDeleteAlert = true
                }
                .font(FontManager.subheadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.accentRed)
                )
            }
        }
    }
    
    private func setupInitialValues() {
        if let entry = existingEntry {
            selectedMood = entry.mood
            comment = entry.comment
            photoIds = entry.photoIds
        }
    }
    
    private func checkForChanges() {
        if let entry = existingEntry {
            hasChanges = selectedMood != entry.mood || comment != entry.comment || photoIds != entry.photoIds
        } else {
            hasChanges = selectedMood != nil || !comment.isEmpty || !photoIds.isEmpty
        }
    }
    
    private func saveEntry() {
        guard let mood = selectedMood else {
            showingMoodRequiredAlert = true
            return
        }
        
        guard moodViewModel.canAddEntry(for: selectedDate) else {
            showingFutureDateAlert = true
            return
        }
        
        guard isCommentValid else {
            return
        }
        
        moodViewModel.addOrUpdateMoodEntry(for: selectedDate, mood: mood, comment: comment, photoIds: photoIds)
        dismiss()
    }
    
    private func deleteEntry() {
        moodViewModel.deleteMoodEntry(for: selectedDate)
        dismiss()
    }
    
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
}

struct MoodButton: View {
    let mood: MoodType
    let isSelected: Bool
    let useExtended: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(useExtended ? mood.extendedEmoji : mood.emoji)
                    .font(.system(size: 32))
                
                Text(mood.description)
                    .font(FontManager.caption)
                    .foregroundColor(isSelected ? Color.primaryBlue : Color.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.lightBlue.opacity(0.2) : Color.backgroundGray.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.primaryBlue : Color.clear, lineWidth: 2)
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MoodEntryView(
        moodViewModel: MoodViewModel(),
        settings: AppSettings(),
        selectedDate: Date()
    )
}
