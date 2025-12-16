import SwiftUI

struct AddNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    var existingNote: Note?
    
    init(viewModel: NotesViewModel, existingNote: Note? = nil) {
        self.viewModel = viewModel
        self.existingNote = existingNote
        
        if let note = existingNote {
            _title = State(initialValue: note.title)
            _content = State(initialValue: note.content)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.darkGray)
                            
                            TextField("Autumn aromas", text: $title)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.darkGray)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Content")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.darkGray)
                            
                            TextField("Add cinnamon and mandarin candles to the collection...", text: $content, axis: .vertical)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.darkGray)
                                .lineLimit(5...15)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    Button(action: saveNote) {
                        Text("Save")
                            .font(AppFonts.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                canSave ? AnyShapeStyle(AppColors.buttonGradient) : AnyShapeStyle(Color.gray.opacity(0.5))
                            )
                            .cornerRadius(25)
                            .shadow(
                                color: canSave ? AppColors.purpleGradientStart.opacity(0.3) : Color.clear,
                                radius: 8, x: 0, y: 4
                            )
                    }
                    .disabled(!canSave)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle(existingNote == nil ? "New Note" : "Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.blueText)
            )
        }
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existing = existingNote {
            var updatedNote = existing
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
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddNoteView(viewModel: NotesViewModel())
}
