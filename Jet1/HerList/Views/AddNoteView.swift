import SwiftUI

struct AddNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Binding var isPresented: Bool
    
    @State private var title = ""
    @State private var content = ""
    
    let existingNote: Note?
    
    init(viewModel: NotesViewModel, isPresented: Binding<Bool>, existingNote: Note? = nil) {
        self.viewModel = viewModel
        self._isPresented = isPresented
        self.existingNote = existingNote
        
        if let note = existingNote {
            self._title = State(initialValue: note.title)
            self._content = State(initialValue: note.content)
        }
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(FontManager.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                        
                        TextField("e.g., About style and character", text: $title)
                            .font(FontManager.ubuntu(16))
                            .foregroundColor(Color.theme.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.theme.cardBackground.opacity(0.2))
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Content")
                            .font(FontManager.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                        
                        ZStack(alignment: .topLeading) {
                            if content.isEmpty {
                                Text("Reading Chanel's interviews — her confidence in simplicity inspires me.")
                                    .font(FontManager.ubuntu(16))
                                    .foregroundColor(Color.theme.secondaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                            }
                            
                            TextEditor(text: $content)
                                .font(FontManager.ubuntu(16))
                                .foregroundColor(Color.theme.primaryText)
                                .scrollContentBackground(.hidden)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.clear)
                        }
                        .frame(minHeight: 200)
                        .background(Color.theme.cardBackground.opacity(0.2))
                        .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle(existingNote == nil ? "New Note" : "Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(Color.theme.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                    }
                    .foregroundColor(isFormValid ? Color.theme.primaryText : Color.theme.secondaryText)
                    .disabled(!isFormValid)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    private func saveNote() {
        if let existing = existingNote {
            var updatedNote = existing
            updatedNote.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedNote.content = content.trimmingCharacters(in: .whitespacesAndNewlines)
            viewModel.updateNote(updatedNote)
        } else {
            let note = Note(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                content: content.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            viewModel.addNote(note)
        }
        
        isPresented = false
    }
}

#Preview {
    AddNoteView(viewModel: NotesViewModel(), isPresented: .constant(true))
}
