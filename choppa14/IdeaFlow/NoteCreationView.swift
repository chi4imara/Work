import SwiftUI

struct NoteCreationView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var editingNote: Note?
    
    init(viewModel: NotesViewModel, editingNote: Note? = nil) {
        self.viewModel = viewModel
        self.editingNote = editingNote
        
        if let note = editingNote {
            _title = State(initialValue: note.title)
            _content = State(initialValue: note.content)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.primaryGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    titleSection
                    
                    contentSection
                }
            }
            .navigationTitle(editingNote != nil ? "Edit Note" : "New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(Color.theme.accentText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryBlue)
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Title")
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(Color.theme.primaryText)
            
            TextField("December post topics", text: $title)
                .font(.playfairDisplay(18, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.theme.primaryWhite)
                        .shadow(color: Color.theme.shadowColor, radius: 3, x: 0, y: 2)
                )
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Content")
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(Color.theme.primaryText)
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.theme.primaryWhite)
                    .shadow(color: Color.theme.shadowColor, radius: 3, x: 0, y: 2)
                
                TextEditor(text: $content)
                    .font(.playfairDisplay(16, weight: .regular))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                
                if content.isEmpty {
                    Text("Gift reviews, New Year backgrounds, photoshoot backstage...")
                        .font(.playfairDisplay(16, weight: .regular))
                        .foregroundColor(Color.theme.secondaryText.opacity(0.6))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 24)
                        .allowsHitTesting(false)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .frame(maxHeight: .infinity)
    }
    
    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            alertMessage = "Please enter a title for your note."
            showingAlert = true
            return
        }
        
        if let existingNote = editingNote {
            let updatedNote = Note(
                id: existingNote.id,
                title: trimmedTitle,
                content: trimmedContent,
                createdDate: existingNote.createdDate,
                isPinned: existingNote.isPinned
            )
            
            viewModel.updateNote(updatedNote)
        } else {
            let newNote = Note(
                title: trimmedTitle,
                content: trimmedContent
            )
            
            viewModel.addNote(newNote)
        }
        
        dismiss()
    }
}

#Preview {
    NoteCreationView(viewModel: NotesViewModel())
}
