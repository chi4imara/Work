import SwiftUI

struct NotesView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    @State private var selectedModal: ModalType?
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if notesViewModel.notes.isEmpty {
                    emptyStateView
                } else {
                    notesList
                }
            }
        }
        .sheet(item: $selectedModal) { modal in
            switch modal {
            case .createNote:
                CreateNoteView(notesViewModel: notesViewModel)
            case .noteDetail(let id):
                if let note = notesViewModel.notes.first(where: { $0.id == id }) {
                    NoteDetailView(note: note, notesViewModel: notesViewModel)
                } else {
                    EmptyView()
                }
            case .editNote(let id):
                if let note = notesViewModel.notes.first(where: { $0.id == id }) {
                    EditNoteView(note: note, notesViewModel: notesViewModel)
                } else {
                    EmptyView()
                }
            default:
                EmptyView()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Notes")
                .font(.builderSans(size: 24, weight: .bold))
                .foregroundColor(.primaryText)
            
            Spacer()
            
            Button(action: { selectedModal = .createNote }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(AppGradients.buttonGradient)
                    )
                    .shadow(color: Color.accentYellow.opacity(0.3), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    private var notesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                    ForEach(notesViewModel.notes) { note in
                        NoteCard(note: note) {
                            selectedModal = .noteDetail(note.id)
                        }
                    }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            VStack(spacing: 20) {
                Image(systemName: "pencil")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.lightOrange)
                
                VStack(spacing: 8) {
                    Text("It's quiet here.")
                        .font(.builderSans(size: 18, weight: .medium))
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                    
                    Text("Write your first note.")
                        .font(.builderSans(size: 16, weight: .regular))
                        .foregroundColor(.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
            
            Button(action: { selectedModal = .createNote }) {
                Text("Add Note")
                    .font(.builderSans(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppGradients.buttonGradient)
                    )
                    .shadow(color: Color.accentYellow.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct NoteCard: View {
    let note: Note
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: "note.text")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.lightOrange)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(note.title)
                        .font(.builderSans(size: 16, weight: .semibold))
                        .foregroundColor(.primaryText)
                        .lineLimit(1)
                    
                    if !note.shortText.isEmpty {
                        Text(note.shortText)
                            .font(.builderSans(size: 14, weight: .regular))
                            .foregroundColor(.secondaryText)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Text(note.dateString)
                        .font(.builderSans(size: 12, weight: .medium))
                        .foregroundColor(.secondaryText.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondaryText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppGradients.cardGradient)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CreateNoteView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var noteText = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("Write what you want to save...")
                        .font(.builderSans(size: 18, weight: .medium))
                        .foregroundColor(.primaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                    
                    TextEditor(text: $noteText)
                        .font(.builderSans(size: 16, weight: .regular))
                        .foregroundColor(.primaryText)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        )
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 300)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.primaryText.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button(action: saveNote) {
                        Text("Save Note")
                            .font(.builderSans(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(noteText.isEmpty ? AnyShapeStyle(Color.gray) : AnyShapeStyle(AppGradients.buttonGradient))
                            )
                            .shadow(
                                color: noteText.isEmpty ? Color.clear : Color.accentYellow.opacity(0.3),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                    }
                    .disabled(noteText.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryText)
                }
            }
        }
        .alert("Note Saved", isPresented: $showingConfirmation) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your note has been saved successfully.")
        }
    }
    
    private func saveNote() {
        guard !noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        notesViewModel.addNote(noteText.trimmingCharacters(in: .whitespacesAndNewlines))
        showingConfirmation = true
    }
}

struct NoteDetailView: View {
    let note: Note
    @ObservedObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedModal: ModalType?
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(note.dateString)
                            .font(.builderSans(size: 14, weight: .medium))
                            .foregroundColor(.secondaryText)
                        
                        Text(note.text)
                            .font(.builderSans(size: 16, weight: .regular))
                            .foregroundColor(.primaryText)
                            .lineSpacing(6)
                        
                        Spacer(minLength: 100)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                }
            }
            .navigationTitle("Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Edit") {
                            selectedModal = .editNote(note.id)
                        }
                        
                        Button("Delete", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.primaryText)
                    }
                }
            }
        }
        .sheet(item: $selectedModal) { modal in
            switch modal {
            case .editNote(let id):
                if let note = notesViewModel.notes.first(where: { $0.id == id }) {
                    EditNoteView(note: note, notesViewModel: notesViewModel)
                } else {
                    EmptyView()
                }
            default:
                EmptyView()
            }
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                notesViewModel.deleteNote(note)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
    }
}

struct EditNoteView: View {
    let note: Note
    @ObservedObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var noteText: String
    @State private var showingConfirmation = false
    
    init(note: Note, notesViewModel: NotesViewModel) {
        self.note = note
        self.notesViewModel = notesViewModel
        self._noteText = State(initialValue: note.text)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    TextEditor(text: $noteText)
                        .font(.builderSans(size: 16, weight: .regular))
                        .foregroundColor(.primaryText)
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.9))
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        )
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 300)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.primaryText.opacity(0.2), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button(action: saveNote) {
                        Text("Save Note")
                            .font(.builderSans(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(noteText.isEmpty ? AnyShapeStyle(Color.gray) : AnyShapeStyle(AppGradients.buttonGradient))
                            )
                            .shadow(
                                color: noteText.isEmpty ? Color.clear : Color.accentYellow.opacity(0.3),
                                radius: 8,
                                x: 0,
                                y: 4
                            )
                    }
                    .disabled(noteText.isEmpty)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.primaryText)
                }
            }
        }
        .alert("Note Saved", isPresented: $showingConfirmation) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your note has been updated successfully.")
        }
    }
    
    private func saveNote() {
        guard !noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        notesViewModel.updateNote(note, with: noteText.trimmingCharacters(in: .whitespacesAndNewlines))
        showingConfirmation = true
    }
}

#Preview {
    NotesView(notesViewModel: NotesViewModel())
}
