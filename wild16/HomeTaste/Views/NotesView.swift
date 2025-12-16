import SwiftUI

enum NotesSheetItem: Identifiable {
    case noteDetail(UUID)
    
    var id: String {
        switch self {
        case .noteDetail(let id):
            return "noteDetail-\(id.uuidString)"
        }
    }
}

struct NotesView: View {
    @EnvironmentObject var noteStore: NoteStore
    @State private var newNoteText = ""
    @State private var sheetItem: NotesSheetItem?
    @State private var showingDeleteAlert = false
    @State private var noteToDelete: Note?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        HStack {
                            Text("Recipe Notes")
                                .font(FontManager.title1)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ZStack(alignment: .topLeading) {
                                if newNoteText.isEmpty {
                                    Text("What can be improved or tried differently?")
                                        .font(FontManager.body)
                                        .foregroundColor(AppColors.textSecondary.opacity(0.7))
                                        .padding(16)
                                }
                                
                                TextEditor(text: $newNoteText)
                                    .font(FontManager.body)
                                    .foregroundColor(AppColors.textPrimary)
                                    .padding(12)
                                    .background(Color.clear)
                                    .scrollContentBackground(.hidden)
                            }
                            .frame(minHeight: 80)
                            .background(AppColors.cardGradient)
                            .cornerRadius(12)
                            
                            Button(action: saveNewNote) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Save Note")
                                        .font(FontManager.callout)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(newNoteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                                           AppColors.textSecondary.opacity(0.5) : AppColors.primaryBlue)
                                .cornerRadius(22)
                            }
                            .disabled(newNoteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            .padding(.bottom, 5)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 10)
                    
                    if noteStore.sortedNotes.isEmpty {
                        EmptyNotesView()
                    } else {
                        NotesList(
                            notes: noteStore.sortedNotes,
                            onNoteTap: { note in
                                sheetItem = .noteDetail(note.id)
                            },
                            onNoteDelete: { note in
                                noteToDelete = note
                                showingDeleteAlert = true
                            }
                        )
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(item: $sheetItem) { item in
            switch item {
            case .noteDetail(let noteId):
                NoteDetailView(noteId: noteId)
                    .environmentObject(noteStore)
            }
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                noteToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let note = noteToDelete {
                    noteStore.deleteNote(note)
                }
                noteToDelete = nil
            }
        } message: {
            Text("Are you sure you want to delete this note?")
        }
    }
    
    private func saveNewNote() {
        let trimmedText = newNoteText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let note = Note(content: trimmedText)
        noteStore.addNote(note)
        newNoteText = ""
    }
}

struct EmptyNotesView: View {
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 100, height: 100)
                
                VStack(spacing: 8) {
                    Image(systemName: "note.text")
                        .font(.system(size: 35, weight: .light))
                        .foregroundColor(AppColors.primaryBlue)
                    
                    Image(systemName: "pencil")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(AppColors.primaryYellow)
                }
            }
            
            VStack(spacing: 12) {
                Text("No notes yet")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Add short comments — this makes recipes come alive.")
                    .font(FontManager.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

struct NotesList: View {
    let notes: [Note]
    let onNoteTap: (Note) -> Void
    let onNoteDelete: (Note) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(notes) { note in
                    NoteCard(
                        note: note,
                        onTap: { onNoteTap(note) },
                        onDelete: { onNoteDelete(note) }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

struct NoteCard: View {
    let note: Note
    let onTap: () -> Void
    let onDelete: () -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dateFormatter.string(from: note.dateCreated))
                            .font(FontManager.caption1)
                            .foregroundColor(AppColors.textSecondary)
                        
                        if let recipeName = note.recipeName {
                            HStack(spacing: 4) {
                                Image(systemName: "link")
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.primaryBlue)
                                
                                Text("For recipe: \(recipeName)")
                                    .font(FontManager.caption2)
                                    .foregroundColor(AppColors.primaryBlue)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Text(note.previewText)
                    .font(FontManager.body)
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct NoteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var noteStore: NoteStore
    
    let noteId: UUID
    
    @State private var editedContent: String
    @State private var isEditing = false
    @State private var showingDeleteAlert = false
    
    private var note: Note? {
        noteStore.getNote(by: noteId)
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    init(noteId: UUID) {
        self.noteId = noteId
        self._editedContent = State(initialValue: "")
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                if let note = note {
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Created: \(dateFormatter.string(from: note.dateCreated))")
                                    .font(FontManager.caption1)
                                    .foregroundColor(AppColors.textSecondary)
                                
                                if let recipeName = note.recipeName {
                                    HStack(spacing: 8) {
                                        Image(systemName: "link.circle.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(AppColors.primaryBlue)
                                        
                                        Text("Linked to recipe: \(recipeName)")
                                            .font(FontManager.callout)
                                            .foregroundColor(AppColors.primaryBlue)
                                    }
                                    .padding(12)
                                    .background(AppColors.primaryBlue.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Note Content")
                                    .font(FontManager.headline)
                                    .foregroundColor(AppColors.textPrimary)
                                
                                if isEditing {
                                    TextEditor(text: $editedContent)
                                        .font(FontManager.body)
                                        .foregroundColor(AppColors.textPrimary)
                                        .padding(12)
                                        .frame(minHeight: 150)
                                        .background(AppColors.cardGradient)
                                        .cornerRadius(12)
                                        .scrollContentBackground(.hidden)
                                } else {
                                    Text(note.content)
                                        .font(FontManager.body)
                                        .foregroundColor(AppColors.textPrimary)
                                        .padding(16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(AppColors.cardGradient)
                                        .cornerRadius(12)
                                }
                            }
                            
                            VStack(spacing: 12) {
                                if isEditing {
                                    Button(action: saveChanges) {
                                        HStack {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 16, weight: .medium))
                                            Text("Save Changes")
                                                .font(FontManager.callout)
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .background(AppColors.success)
                                        .cornerRadius(22)
                                    }
                                    
                                    Button(action: {
                                        editedContent = note.content
                                        isEditing = false
                                    }) {
                                        Text("Cancel")
                                            .font(FontManager.callout)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                } else {
                                    Button(action: {
                                        editedContent = note.content
                                        isEditing = true
                                    }) {
                                        HStack {
                                            Image(systemName: "pencil")
                                                .font(.system(size: 16, weight: .medium))
                                            Text("Edit")
                                                .font(FontManager.callout)
                                        }
                                        .foregroundColor(AppColors.primaryBlue)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .background(AppColors.cardGradient)
                                        .cornerRadius(22)
                                    }
                                    
                                    Button(action: {
                                        showingDeleteAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "trash")
                                                .font(.system(size: 16, weight: .medium))
                                            Text("Delete")
                                                .font(FontManager.callout)
                                        }
                                        .foregroundColor(AppColors.warning)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .background(AppColors.cardGradient)
                                        .cornerRadius(22)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                    }
                    .onAppear {
                        if editedContent.isEmpty {
                            editedContent = note.content
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        Text("This note is unavailable")
                            .font(FontManager.title2)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text("It may have been deleted.")
                            .font(FontManager.body)
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Back to List")
                                .font(FontManager.callout)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(AppColors.primaryBlue)
                                .cornerRadius(20)
                        }
                    }
                }
            }
            .navigationTitle("Note Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .medium))
                            Text("Back")
                        }
                        .foregroundColor(AppColors.primaryBlue)
                    }
                }
            }
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let note = note {
                    noteStore.deleteNote(note)
                }
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this note?")
        }
    }
    
    private func saveChanges() {
        let trimmedContent = editedContent.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else { return }
        
        guard var updatedNote = note else { return }
        updatedNote.content = trimmedContent
        noteStore.updateNote(updatedNote)
        isEditing = false
    }
}
