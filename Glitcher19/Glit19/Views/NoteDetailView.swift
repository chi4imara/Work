import SwiftUI

struct NoteDetailView: View {
    let noteId: UUID
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var note: Note? {
        viewModel.getNote(by: noteId)
    }
    
    var body: some View {
        Group {
            if let note = note {
                noteDetailContent(note: note)
            } else {
                Text("Note not found")
                    .foregroundColor(Color.theme.primaryText)
            }
        }
    }
    
    private func noteDetailContent(note: Note) -> some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            viewModel.toggleFavorite(note)
                        }) {
                            Image(systemName: note.isFavorite ? "star.fill" : "star")
                                .font(.system(size: 28))
                                .foregroundColor(note.isFavorite ? Color.theme.accentYellow : Color.theme.secondaryText)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(note.text)
                            .font(.ubuntu(18))
                            .foregroundColor(Color.theme.primaryText)
                            .lineSpacing(4)
                        
                        Divider()
                            .background(Color.theme.secondaryText.opacity(0.3))
                        
                        HStack {
                            Text("Category:")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(Color.theme.secondaryText)
                            
                            Text(note.category)
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(Color.theme.accentYellow)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.theme.accentYellow.opacity(0.2))
                                .cornerRadius(8)
                        }
                        
                        HStack {
                            Text("Created:")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(Color.theme.secondaryText)
                            
                            Text(note.formattedDate)
                                .font(.ubuntu(14))
                                .foregroundColor(Color.theme.primaryText)
                        }
                    }
                    .padding(20)
                    .background(Color.theme.cardGradient)
                    .cornerRadius(16)
                    
                    VStack(spacing: 12) {
                        Button(action: { showingEditView = true }) {
                            Text("Edit")
                                .font(.ubuntu(18, weight: .bold))
                                .foregroundColor(Color.theme.darkPink)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.theme.accentYellow)
                                .cornerRadius(12)
                        }
                        
                        Button(action: { showingDeleteAlert = true }) {
                            Text("Delete")
                                .font(.ubuntu(18, weight: .bold))
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.theme.errorRed)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(note.firstLine)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
                }
                .foregroundColor(Color.theme.accentYellow)
                .font(.ubuntu(16, weight: .medium))
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingEditView) {
            EditNoteView(noteId: noteId, viewModel: viewModel)
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteNote(note)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
    }
}

#Preview {
    let sampleNote = Note(text: "This is a sample note with some longer text to show how it looks in the detail view.", category: "Ideas", isFavorite: true)
    return NavigationView {
        NoteDetailView(
            noteId: sampleNote.id,
            viewModel: NotesViewModel()
        )
    }
}
