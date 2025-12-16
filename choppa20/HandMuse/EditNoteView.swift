import SwiftUI

struct EditNoteView: View {
    let note: Note
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String
    @State private var content: String
    
    init(note: Note, viewModel: NotesViewModel) {
        self.note = note
        self.viewModel = viewModel
        
        _title = State(initialValue: note.title)
        _content = State(initialValue: note.content)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        TextField("Ideas for winter projects", text: $title)
                            .font(.playfairDisplay(18))
                            .foregroundColor(Color.theme.primaryText)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.theme.cardBackground)
                                    .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Content")
                            .font(.playfairDisplay(16, weight: .semibold))
                            .foregroundColor(Color.theme.primaryText)
                        
                        ZStack(alignment: .topLeading) {
                            if content.isEmpty {
                                Text("Knit mittens with pattern, try new embroidery technique...")
                                    .font(.playfairDisplay(16))
                                    .foregroundColor(Color.theme.secondaryText.opacity(0.5))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                            }
                            
                            TextEditor(text: $content)
                                .font(.playfairDisplay(16))
                                .foregroundColor(Color.theme.primaryText)
                                .frame(minHeight: 200)
                                .scrollContentBackground(.hidden)
                                .padding(8)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.theme.cardBackground)
                                .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                        )
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .font(.playfairDisplay(16, weight: .semibold))
                    .foregroundColor(Color.theme.primaryYellow)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveChanges() {
        let updatedNote = Note(
            id: note.id,
            title: title,
            content: content,
            dateCreated: note.dateCreated,
            dateModified: Date()
        )
        
        viewModel.updateNote(updatedNote)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    let sampleNote = Note(
        title: "Ideas for winter projects",
        content: "Knit mittens with pattern, try new embroidery technique."
    )
    
    EditNoteView(note: sampleNote, viewModel: NotesViewModel())
}
