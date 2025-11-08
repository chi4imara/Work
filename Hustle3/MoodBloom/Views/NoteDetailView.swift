import SwiftUI

struct NoteDetailView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditing = false
    @State private var editTitle: String
    @State private var editContent: String
    @State private var showingDeleteAlert = false
    @State private var showingDiscardAlert = false
    
    private let noteId: UUID
    private let characterLimit = 500
    
    private var note: Note? {
        notesViewModel.getNote(by: noteId)
    }
    
    init(note: Note, notesViewModel: NotesViewModel) {
        self.noteId = note.id
        self.notesViewModel = notesViewModel
        self._editTitle = State(initialValue: note.title)
        self._editContent = State(initialValue: note.content)
    }
    
    private var hasChanges: Bool {
        guard let note = note else { return false }
        return editTitle != note.title || editContent != note.content
    }
    
    private var canSave: Bool {
        !editContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && editContent.count <= characterLimit
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if let note = note {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            if isEditing {
                                editingView
                            } else {
                                readingView(note: note)
                            }
                        }
                        .padding(20)
                        .padding(.bottom, 50)
                    }
                } else {
                    VStack {
                        Text("Note not found")
                            .font(FontManager.headline)
                            .foregroundColor(Color.textPrimary)
                        
                        Button("Go Back") {
                            dismiss()
                        }
                        .font(FontManager.body)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.primaryBlue)
                        )
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Note" : "Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditing ? "Cancel" : "Done") {
                        if isEditing {
                            if hasChanges {
                                showingDiscardAlert = true
                            } else {
                                isEditing = false
                            }
                        } else {
                            dismiss()
                        }
                    }
                    .foregroundColor(Color.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        Button("Save") {
                            saveChanges()
                        }
                        .foregroundColor(canSave ? Color.primaryBlue : Color.textSecondary.opacity(0.5))
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                    } else {
                        Menu {
                            Button("Edit") {
                                isEditing = true
                            }
                            
                            Button("Delete", role: .destructive) {
                                showingDeleteAlert = true
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(Color.primaryBlue)
                        }
                    }
                }
            }
        }
        .alert("Delete Note?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let note = note {
                    notesViewModel.deleteNote(note)
                }
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
        .alert("Discard Changes?", isPresented: $showingDiscardAlert) {
            Button("Discard", role: .destructive) {
                if let note = note {
                    editTitle = note.title
                    editContent = note.content
                }
                isEditing = false
            }
            Button("Keep Editing", role: .cancel) { }
        } message: {
            Text("You have unsaved changes. Are you sure you want to discard them?")
        }
    }
    
    private func readingView(note: Note) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Title")
                    .font(FontManager.title)
                    .foregroundColor(Color.textPrimary)
                Spacer()
            }
            
            HStack {
                Text(note.title.isEmpty ? "Untitled" : note.title)
                    .font(FontManager.title)
                    .foregroundColor(Color.textPrimary)
                    .padding(16)
                            
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.backgroundWhite)
                    .shadow(color: Color.primaryBlue.opacity(0.05), radius: 5)
            )

            VStack(alignment: .leading, spacing: 4) {
                Text("Created: \(formatDate(note.createdAt))")
                    .font(FontManager.caption)
                    .foregroundColor(Color.textSecondary)
                
                if note.updatedAt != note.createdAt {
                    Text("Updated: \(formatDate(note.updatedAt))")
                        .font(FontManager.caption)
                        .foregroundColor(Color.textSecondary)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.backgroundGray.opacity(0.5))
            )
            
            if !note.content.isEmpty {
                Text("Content")
                    .font(FontManager.title)
                    .foregroundColor(Color.textPrimary)
                
                Text(note.content)
                    .font(FontManager.body)
                    .foregroundColor(Color.textPrimary)
                    .lineSpacing(4)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.backgroundWhite)
                            .shadow(color: Color.primaryBlue.opacity(0.05), radius: 5)
                    )
            } else {
                Text("No content")
                    .font(FontManager.body)
                    .foregroundColor(Color.textSecondary)
                    .italic()
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.backgroundGray.opacity(0.3))
                    )
            }
            
            Spacer()
        }
    }
    
    private var editingView: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Title (optional)")
                    .font(FontManager.subheadline)
                    .foregroundColor(Color.textPrimary)
                
                TextField("Enter title...", text: $editTitle)
                    .font(FontManager.body)
                    .foregroundColor(Color.textPrimary)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.backgroundWhite)
                            .shadow(color: Color.primaryBlue.opacity(0.05), radius: 5)
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Content")
                        .font(FontManager.subheadline)
                        .foregroundColor(Color.textPrimary)
                    
                    Spacer()
                    
                    Text("\(editContent.count)/\(characterLimit)")
                        .font(FontManager.caption)
                        .foregroundColor(editContent.count > characterLimit ? Color.accentRed : Color.textSecondary)
                }
                
                TextEditor(text: $editContent)
                    .font(FontManager.body)
                    .foregroundColor(Color.textPrimary)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.backgroundWhite)
                            .shadow(color: Color.primaryBlue.opacity(0.05), radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(editContent.count > characterLimit ? Color.accentRed : Color.clear, lineWidth: 1)
                            )
                    )
                    .frame(minHeight: 300)
            }
            
            Spacer()
        }
    }
    
    private func saveChanges() {
        guard let note = note else { return }
        
        let trimmedTitle = editTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = editContent.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let finalTitle = trimmedTitle.isEmpty ? String(trimmedContent.prefix(30)) : trimmedTitle
        
        notesViewModel.updateNote(note, title: finalTitle, content: trimmedContent)
        isEditing = false
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    NoteDetailView(
        note: Note(title: "Sample Note", content: "This is a sample note content."),
        notesViewModel: NotesViewModel()
    )
}
