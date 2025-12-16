import SwiftUI

struct CreateNoteView: View {
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    let editingNote: Note?
    
    @State private var title = ""
    @State private var content = ""
    
    init(appViewModel: AppViewModel, editingNote: Note? = nil) {
        self.appViewModel = appViewModel
        self.editingNote = editingNote
        
        if let note = editingNote {
            _title = State(initialValue: note.title)
            _content = State(initialValue: note.content)
        }
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                        
                        TextField("What to put in travel set", text: $title)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.cardBorder, lineWidth: 1)
                                    )
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Content")
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                        
                        TextField("Don't forget mini dry shampoo", text: $content, axis: .vertical)
                            .font(.bodyMedium)
                            .foregroundColor(.textPrimary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(minHeight: 200, alignment: .topLeading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.cardBorder, lineWidth: 1)
                                    )
                            )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle(editingNote == nil ? "New Note" : "Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                    }
                    .foregroundColor(isFormValid ? .primaryPurple : .textSecondary)
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let editingNote = editingNote {
            var updatedNote = editingNote
            updatedNote.title = trimmedTitle
            updatedNote.content = trimmedContent
            
            appViewModel.updateNote(updatedNote)
        } else {
            let newNote = Note(
                title: trimmedTitle,
                content: trimmedContent
            )
            
            appViewModel.addNote(newNote)
        }
        
        dismiss()
    }
}

#Preview {
    CreateNoteView(appViewModel: AppViewModel())
}
