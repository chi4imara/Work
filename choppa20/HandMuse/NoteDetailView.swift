import SwiftUI

struct NoteDetailItem: Identifiable {
    let id: UUID
}

struct NoteDetailView: View {
    let noteId: UUID
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var note: Note? {
        viewModel.notes.first { $0.id == noteId }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
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
                                    Text("Created")
                                        .font(.playfairDisplay(14, weight: .semibold))
                                        .foregroundColor(Color.theme.secondaryText)
                                    
                                    Text(dateFormatter.string(from: note.dateCreated))
                                        .font(.playfairDisplay(14))
                                        .foregroundColor(Color.theme.secondaryText.opacity(0.8))
                                    
                                    if note.dateModified != note.dateCreated {
                                        Text("Modified")
                                            .font(.playfairDisplay(14, weight: .semibold))
                                            .foregroundColor(Color.theme.secondaryText)
                                            .padding(.top, 8)
                                        
                                        Text(dateFormatter.string(from: note.dateModified))
                                            .font(.playfairDisplay(14))
                                            .foregroundColor(Color.theme.secondaryText.opacity(0.8))
                                    }
                                }
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Content")
                                        .font(.playfairDisplay(20, weight: .bold))
                                        .foregroundColor(Color.theme.primaryText)
                                    
                                    if note.content.isEmpty {
                                        Text("No content")
                                            .font(.playfairDisplay(16))
                                            .foregroundColor(Color.theme.secondaryText.opacity(0.7))
                                            .italic()
                                    } else {
                                        Text(note.content)
                                            .font(.playfairDisplay(16))
                                            .foregroundColor(Color.theme.secondaryText)
                                    }
                                }
                                .padding(16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.theme.cardBackground)
                                        .shadow(color: Color.theme.shadowColor, radius: 4, x: 0, y: 2)
                                )
                                
                                VStack(spacing: 16) {
                                    Button(action: {
                                        showingEditView = true
                                    }) {
                                        HStack {
                                            Image(systemName: "pencil")
                                            Text("Edit Note")
                                        }
                                        .font(.playfairDisplay(18, weight: .semibold))
                                        .foregroundColor(Color.theme.buttonText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(Color.theme.buttonBackground)
                                                .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
                                        )
                                    }
                                    
                                    Button(action: {
                                        showingDeleteAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                            Text("Delete Note")
                                        }
                                        .font(.playfairDisplay(18, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 25)
                                                .fill(Color.red)
                                                .shadow(color: Color.red.opacity(0.3), radius: 8, x: 0, y: 4)
                                        )
                                    }
                                }
                                
                                Spacer(minLength: 100)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                    .navigationTitle(note.title)
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color.theme.primaryBlue)
                            }
                        }
                    }
                    .alert("Delete Note", isPresented: $showingDeleteAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Delete", role: .destructive) {
                            if let note = self.note {
                                viewModel.deleteNote(note)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } message: {
                        Text("Are you sure you want to delete this note? This action cannot be undone.")
                    }
                    .sheet(isPresented: $showingEditView) {
                        if let note = self.note {
                            EditNoteView(note: note, viewModel: viewModel)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let sampleNote = Note(
        title: "Ideas for winter projects",
        content: "Knit mittens with pattern, try new embroidery technique. Maybe create some holiday decorations with felt and beads."
    )
    
    NoteDetailView(noteId: sampleNote.id, viewModel: NotesViewModel())
}
