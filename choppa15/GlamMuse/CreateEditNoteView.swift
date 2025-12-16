import SwiftUI

struct CreateEditNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    let noteToEdit: Note?
    
    @State private var title = ""
    @State private var content = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(viewModel: NotesViewModel, noteToEdit: Note? = nil) {
        self.viewModel = viewModel
        self.noteToEdit = noteToEdit
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    FormSection(title: "Note Title") {
                        CustomTextField(
                            placeholder: "e.g., New Year makeup ideas",
                            text: $title
                        )
                    }
                    
                    FormSection(title: "Content") {
                        ZStack(alignment: .topLeading) {
                            if content.isEmpty {
                                Text("Try golden eyeshadow and burgundy gloss...")
                                    .font(.ubuntu(16))
                                    .foregroundColor(AppColors.darkText.opacity(0.5))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                            }
                            
                            TextEditor(text: $content)
                                .font(.ubuntu(16))
                                .foregroundColor(AppColors.darkText)
                                .scrollContentBackground(.hidden)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                        }
                        .frame(minHeight: 200)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            .navigationTitle(noteToEdit == nil ? "New Note" : "Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .fontWeight(.medium)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            loadNoteData()
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loadNoteData() {
        if let note = noteToEdit {
            title = note.title
            content = note.content
        }
    }
    
    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty || !trimmedContent.isEmpty else {
            alertMessage = "Please add a title or content"
            showingAlert = true
            return
        }
        
        if let existingNote = noteToEdit {
            var updatedNote = existingNote
            updatedNote.title = trimmedTitle
            updatedNote.content = trimmedContent
            
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
    CreateEditNoteView(viewModel: NotesViewModel())
}
