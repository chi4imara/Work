import SwiftUI

struct NoteDetailView: View {
    let noteId: UUID
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var note: Note? {
        viewModel.getNote(byId: noteId)
    }
    
    var body: some View {
        Group {
            if let note = note {
                NavigationView {
                    ZStack {
                        Color.theme.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 24) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(note.title)
                                        .font(FontManager.ubuntu(24, weight: .bold))
                                        .foregroundColor(Color.theme.primaryText)
                                    
                                    Text(note.formattedDate)
                                        .font(FontManager.ubuntu(14))
                                        .foregroundColor(Color.theme.secondaryText)
                                }
                                
                                Text(note.content)
                                    .font(FontManager.ubuntu(16))
                                    .foregroundColor(Color.theme.primaryText)
                                    .lineSpacing(6)
                                
                                VStack(spacing: 16) {
                                    Button(action: {
                                        showingEditView = true
                                    }) {
                                        HStack {
                                            Image(systemName: "pencil")
                                            Text("Edit Note")
                                        }
                                        .font(FontManager.ubuntu(16, weight: .medium))
                                        .foregroundColor(Color.theme.primaryText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(Color.theme.buttonPrimary)
                                        .cornerRadius(12)
                                    }
                                    
                                    Button(action: {
                                        showingDeleteAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                            Text("Delete Note")
                                        }
                                        .font(FontManager.ubuntu(16, weight: .medium))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(Color.theme.buttonDestructive)
                                        .cornerRadius(12)
                                    }
                                }
                                .padding(.top, 20)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                    .navigationTitle("Note")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                dismiss()
                            }
                            .foregroundColor(Color.theme.primaryText)
                        }
                    }
                    .preferredColorScheme(.dark)
                }
                .sheet(isPresented: $showingEditView) {
                    AddNoteView(
                        viewModel: viewModel,
                        isPresented: $showingEditView,
                        existingNote: note
                    )
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
            } else {
                Text("Note not found")
                    .foregroundColor(Color.theme.primaryText)
            }
        }
    }
}

#Preview {
    let viewModel = NotesViewModel()
    let note = Note(
        title: "About style and character",
        content: "Reading Chanel's interviews — her confidence in simplicity inspires me. The way she revolutionized fashion by making it more comfortable and practical while maintaining elegance is remarkable."
    )
    viewModel.addNote(note)
    return NoteDetailView(
        noteId: note.id,
        viewModel: viewModel
    )
}
