import SwiftUI

struct AddEditWordView: View {
    @ObservedObject var wordStore: WordStore
    @Environment(\.presentationMode) var presentationMode
    
    let editingWord: Word?
    let selectedDate: Date?
    
    @State private var word: String = ""
    @State private var translation: String = ""
    @State private var comment: String = ""
    @State private var showingCancelAlert = false
    
    private var isEditing: Bool {
        editingWord != nil
    }
    
    private var canSave: Bool {
        !word.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 25) {
                        headerInfo
                        
                        formFields
                        
                        actionButtons
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Word" : "New Word")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if hasChanges {
                            showingCancelAlert = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .foregroundColor(AppColors.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveWord()
                    }
                    .foregroundColor(canSave ? AppColors.primaryBlue : AppColors.secondaryText)
                    .disabled(!canSave)
                }
            }
        }
        .onAppear {
            setupInitialValues()
        }
        .alert("Discard Changes", isPresented: $showingCancelAlert) {
            Button("Keep Editing", role: .cancel) { }
            Button("Discard", role: .destructive) {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to discard your changes?")
        }
    }
    
    private var headerInfo: some View {
        PixelCard {
            VStack(spacing: 12) {
                Image(systemName: isEditing ? "pencil.circle.fill" : "plus.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(AppColors.primaryBlue)
                
                Text(isEditing ? "Edit your word" : "Add a new word")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.primaryText)
                
                Text("Date: \(currentDateString)")
                    .font(FontManager.subheadline)
                    .foregroundColor(AppColors.secondaryText)
            }
            .padding(.vertical, 10)
        }
    }
    
    private var formFields: some View {
        VStack(spacing: 20) {
            PixelCard {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Word")
                            .font(FontManager.headline)
                            .foregroundColor(AppColors.primaryText)
                        
                        Text("*")
                            .font(FontManager.headline)
                            .foregroundColor(AppColors.error)
                    }
                    
                    TextField("Enter word", text: $word)
                        .font(FontManager.body)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
            
            PixelCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Translation")
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    TextField("Enter translation (optional)", text: $translation)
                        .font(FontManager.body)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            
            PixelCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Comment")
                        .font(FontManager.headline)
                        .foregroundColor(AppColors.primaryText)
                    
                    TextField("Add notes or context (optional)", text: $comment, axis: .vertical)
                        .font(FontManager.body)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                }
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 15) {
            PixelButton(
                title: "Save Word",
                action: { saveWord() },
                color: canSave ? AppColors.primaryBlue : AppColors.secondaryText
            )
            .disabled(!canSave)
            
            Button("Cancel") {
                if hasChanges {
                    showingCancelAlert = true
                } else {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .font(FontManager.body)
            .foregroundColor(AppColors.secondaryText)
        }
    }
    
    private var hasChanges: Bool {
        if let editingWord = editingWord {
            return word != editingWord.word ||
                   translation != (editingWord.translation ?? "") ||
                   comment != (editingWord.comment ?? "")
        } else {
            return !word.isEmpty || !translation.isEmpty || !comment.isEmpty
        }
    }
    
    private var currentDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        
        if let editingWord = editingWord {
            return formatter.string(from: editingWord.dateAdded)
        } else {
            return formatter.string(from: selectedDate ?? Date())
        }
    }
    
    private func setupInitialValues() {
        if let editingWord = editingWord {
            word = editingWord.word
            translation = editingWord.translation ?? ""
            comment = editingWord.comment ?? ""
        }
    }
    
    private func saveWord() {
        let trimmedWord = word.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTranslation = translation.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedComment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedWord.isEmpty else { return }
        
        if isEditing, let editingWord = editingWord {
            print("✏️ Editing word: \(editingWord.word) -> \(trimmedWord)")
            let updatedWord = Word(
                id: editingWord.id, 
                word: trimmedWord,
                translation: trimmedTranslation.isEmpty ? nil : trimmedTranslation,
                comment: trimmedComment.isEmpty ? nil : trimmedComment,
                dateAdded: editingWord.dateAdded
            )
            
            wordStore.updateWord(updatedWord)
        } else {
            print("➕ Creating new word: \(trimmedWord)")
            let targetDate = selectedDate ?? Date()
            
            if let existingWord = wordStore.wordForDate(targetDate) {
                print("🔄 Replacing existing word for date: \(targetDate)")
                wordStore.deleteWord(existingWord)
            }
            
            let newWord = Word(
                word: trimmedWord,
                translation: trimmedTranslation.isEmpty ? nil : trimmedTranslation,
                comment: trimmedComment.isEmpty ? nil : trimmedComment,
                dateAdded: targetDate
            )
            wordStore.addWord(newWord)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddEditWordView(wordStore: WordStore(), editingWord: nil, selectedDate: nil)
}
