import SwiftUI

struct CreateNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var showingAlert = false
    
    var isEditing: Bool = false
    var editingNote: Note?
    
    init(viewModel: NotesViewModel, editingNote: Note? = nil) {
        self.viewModel = viewModel
        self.editingNote = editingNote
        self.isEditing = editingNote != nil
        
        if let note = editingNote {
            _title = State(initialValue: note.title)
            _content = State(initialValue: note.content)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            TextField("Enter note title", text: $title)
                                .font(FontManager.playfairDisplay(size: 18, weight: .medium))
                                .foregroundColor(.textPrimary)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.cardBackground)
                                        .shadow(color: AppShadows.cardShadow, radius: 2, x: 0, y: 1)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Content")
                                .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                                .foregroundColor(.textPrimary)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.cardBackground)
                                    .shadow(color: AppShadows.cardShadow, radius: 2, x: 0, y: 1)
                                
                                if content.isEmpty {
                                    Text("Write your note here...")
                                        .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                        .foregroundColor(.textSecondary.opacity(0.6))
                                        .padding(.horizontal, 20)
                                        .padding(.top, 16)
                                }
                                
                                TextEditor(text: $content)
                                    .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                                    .foregroundColor(.textPrimary)
                                    .scrollContentBackground(.hidden)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.clear)
                            }
                            .frame(minHeight: 200)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle(isEditing ? "Edit Note" : "New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                    .foregroundColor(.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                    }
                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .textSecondary : .primaryPurple)
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .alert("Title Required", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text("Please enter a title for the note.")
        }
    }
    
    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            showingAlert = true
            return
        }
        
        if isEditing, let editingNote = editingNote {
            var updatedNote = editingNote
            updatedNote.title = trimmedTitle
            updatedNote.content = trimmedContent
            viewModel.updateNote(updatedNote)
        } else {
            let newNote = Note(title: trimmedTitle, content: trimmedContent)
            viewModel.addNote(newNote)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}
