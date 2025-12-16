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
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                headerView(note: note)
                                
                                contentView(note: note)
                                
                                actionButtonsView(note: note)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                        }
                    }
                    .navigationTitle("Note")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                dismiss()
                            }
                            .foregroundColor(AppColors.primaryText)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: { 
                                viewModel.togglePin(note)
                            }) {
                                Image(systemName: note.isPinned ? "pin.slash" : "pin")
                                    .foregroundColor(AppColors.primaryText)
                            }
                        }
                    }
                    .preferredColorScheme(.dark)
                }
                .sheet(isPresented: $showingEditView) {
                    CreateEditNoteView(viewModel: viewModel, noteToEdit: note)
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
                Color.clear
                    .onAppear {
                        dismiss()
                    }
            }
        }
    }
    
    private func headerView(note: Note) -> some View {
        VStack(spacing: 12) {
            HStack {
                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.warning)
                }
                
                Text(note.title.isEmpty ? "Untitled" : note.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
            }
            
            Text("Created on \(DateFormatter.longDate.string(from: note.dateCreated))")
                .font(.ubuntu(14))
                .foregroundColor(AppColors.secondaryText)
        }
    }
    
    private func contentView(note: Note) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            if !note.content.isEmpty {
                Text(note.content)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.darkText)
                    .lineSpacing(4)
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text("No content")
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.secondaryText)
                }
                .frame(maxWidth: .infinity)
                .padding(40)
                .background(AppColors.cardBackground.opacity(0.5))
                .cornerRadius(12)
            }
        }
    }
    
    private func actionButtonsView(note: Note) -> some View {
        VStack(spacing: 12) {
            Button(action: { showingEditView = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "pencil")
                    Text("Edit Note")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.buttonPrimary)
                .cornerRadius(12)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "trash")
                    Text("Delete Note")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.error)
                .cornerRadius(12)
            }
        }
        .padding(.top, 20)
    }
}

#Preview {
    let viewModel = NotesViewModel()
    let previewNote = Note(
        title: "New Year makeup ideas",
        content: "Try golden eyeshadow and burgundy gloss for a festive look. Don't forget to highlight the inner corners of the eyes."
    )
    viewModel.addNote(previewNote)
    return NoteDetailView(noteId: previewNote.id, viewModel: viewModel)
}
