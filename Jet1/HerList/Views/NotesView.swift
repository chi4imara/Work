import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel
    @State private var showingAddNote = false
    @State private var selectedNoteId: UUID?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("My Notes")
                    .font(FontManager.ubuntu(28, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                Button(action: {
                    showingAddNote = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.theme.primaryText)
                        .frame(width: 36, height: 36)
                        .background(Color.theme.buttonPrimary)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            if viewModel.sortedNotes.isEmpty {
                EmptyNotesView {
                    showingAddNote = true
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.sortedNotes) { note in
                            NoteCard(note: note) {
                                selectedNoteId = note.id
                            } onDelete: {
                                viewModel.deleteNote(note)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .padding(.bottom, 104)
                }
            }
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView(viewModel: viewModel, isPresented: $showingAddNote)
        }
        .sheet(item: Binding(
            get: { selectedNoteId.map { NoteID(id: $0) } },
            set: { selectedNoteId = $0?.id }
        )) { noteId in
            NoteDetailView(noteId: noteId.id, viewModel: viewModel)
        }
    }
}

struct NoteCard: View {
    let note: Note
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(note.title)
                    .font(FontManager.ubuntu(16, weight: .bold))
                    .foregroundColor(Color.theme.darkText)
                    .lineLimit(1)
                
                Spacer()
                
                Text(note.formattedDate)
                    .font(FontManager.ubuntu(12))
                    .foregroundColor(Color.theme.grayText)
            }
            
            Text(note.contentPreview)
                .font(FontManager.ubuntu(14))
                .foregroundColor(Color.theme.darkText.opacity(0.8))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .padding(16)
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .offset(x: offset.width, y: 0)
        .highPriorityGesture(
            DragGesture(minimumDistance: 25)
                .onChanged { value in
                    if value.translation.width < 0 {
                        offset = value.translation
                    }
                }
                .onEnded { value in
                    if value.translation.width < -100 {
                        withAnimation(.spring()) {
                            offset = CGSize(width: -80, height: 0)
                        }
                    } else {
                        withAnimation(.spring()) {
                            offset = .zero
                        }
                    }
                }
        )
        .overlay(
            HStack {
                Spacer()
                
                if offset.width < -50 {
                    Button(action: {
                        showingDeleteConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 60, height: 60)
                            .background(Color.theme.buttonDestructive)
                            .cornerRadius(12)
                    }
                    .transition(.move(edge: .trailing))
                }
            }
            .padding(.trailing, 16)
        )
        .onTapGesture {
            if offset == .zero {
                onTap()
            } else {
                withAnimation(.spring()) {
                    offset = .zero
                }
            }
        }
        .alert("Delete Note", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {
                withAnimation(.spring()) {
                    offset = .zero
                }
            }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
    }
}

struct EmptyNotesView: View {
    let onAddNote: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.primaryText.opacity(0.6))
            
            Text("No notes. Add thoughts or phrases that inspire you.")
                .font(FontManager.ubuntu(16))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: onAddNote) {
                HStack {
                    Image(systemName: "plus")
                    Text("New Note")
                }
                .font(FontManager.ubuntu(16, weight: .medium))
                .foregroundColor(Color.theme.primaryText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.theme.buttonPrimary)
                .cornerRadius(12)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NotesView(viewModel: NotesViewModel())
}
