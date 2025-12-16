import SwiftUI

struct AddNoteView: View {
    @ObservedObject var noteStore: NoteStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @FocusState private var isContentFocused: Bool
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    VStack(spacing: 20) {
                        titleField
                        
                        contentField
                        
                        Spacer()
                        
                        saveButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isContentFocused = true
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.textLight)
            }
            
            Spacer()
            
            Text("New Note")
                .font(.playfairDisplay(size: 24, weight: .bold))
                .foregroundColor(AppColors.textPrimary)
            
            Spacer()
            
            Button(action: saveNote) {
                Text("Save")
                    .font(.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(isFormValid ? AppColors.primaryPurple : AppColors.textLight)
            }
            .disabled(!isFormValid)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var titleField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title")
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
            
            TextField("Note title (optional)", text: $title)
                .font(.playfairDisplay(size: 16))
                .foregroundColor(AppColors.textPrimary)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppColors.borderColor, lineWidth: 1)
                        )
                )
        }
    }
    
    private var contentField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Content")
                .font(.playfairDisplay(size: 16, weight: .semibold))
                .foregroundColor(AppColors.textPrimary)
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $content)
                    .font(.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.textPrimary)
                    .focused($isContentFocused)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.cardBackground)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColors.borderColor, lineWidth: 1)
                            )
                    )
                    .frame(minHeight: 200)
                
                if content.isEmpty {
                    Text("Start writing your note here...")
                        .font(.playfairDisplay(size: 16))
                        .foregroundColor(AppColors.textLight)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .allowsHitTesting(false)
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveNote) {
            HStack {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .semibold))
                Text("Save Note")
                    .font(.playfairDisplay(size: 18, weight: .semibold))
            }
            .foregroundColor(AppColors.buttonText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(isFormValid ? AppColors.buttonPrimary : AppColors.textLight)
                    .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
        .disabled(!isFormValid)
    }
    
    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty || !trimmedContent.isEmpty else { return }
        
        let note = Note(
            title: trimmedTitle.isEmpty ? "Untitled Note" : trimmedTitle,
            content: trimmedContent
        )
        
        noteStore.addNote(note)
        dismiss()
    }
}

#Preview {
    AddNoteView(noteStore: NoteStore())
}
