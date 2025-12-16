import SwiftUI

struct NotesView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var colorTheme = ColorTheme.shared
    @State private var showingAddNote = false
    @State private var selectedNote: Note?
    @State private var showingNoteDetail: IdentifiableID<Note.ID>?
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if dataManager.notes.isEmpty {
                        emptyStateView
                    } else {
                        notesListView
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddNote) {
                AddNoteView()
            }
            .sheet(item: $showingNoteDetail) { identifiableId in
                if let note = dataManager.notes.first(where: { $0.id == identifiableId.wrappedId }) {
                    NoteDetailView(note: note)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Notes")
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(colorTheme.primaryWhite)
            
            Spacer()
            
            Button(action: {
                showingAddNote = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(colorTheme.primaryWhite)
                    .frame(width: 44, height: 44)
                    .background(colorTheme.primaryPurple.opacity(0.3))
                    .clipShape(Circle())
            }
        }
        .padding()
    }
    
    private var notesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(dataManager.notes) { note in
                    NoteCard(note: note) {
                        showingNoteDetail = IdentifiableID(note.id)
                    }
                }
            }
            .padding()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "pencil")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(colorTheme.primaryWhite.opacity(0.6))
            
            Text("It's quiet here. Add your first note.")
                .font(.playfairDisplay(18, weight: .medium))
                .foregroundColor(colorTheme.primaryWhite.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                showingAddNote = true
            }) {
                Text("Add Note")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(colorTheme.primaryPurple)
                    .frame(width: 120, height: 44)
                    .background(colorTheme.primaryWhite)
                    .cornerRadius(22)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
            }
            
            Spacer()
        }
    }
}

struct NoteCard: View {
    let note: Note
    let onTap: () -> Void
    @StateObject private var colorTheme = ColorTheme.shared
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(note.title)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(colorTheme.primaryWhite)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(colorTheme.primaryWhite.opacity(0.5))
                }
                
                Text(note.content)
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(colorTheme.primaryWhite.opacity(0.8))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(formatDate(note.createdAt))
                    .font(.playfairDisplay(12, weight: .light))
                    .foregroundColor(colorTheme.primaryWhite.opacity(0.6))
            }
            .padding()
            .background(colorTheme.primaryWhite.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(colorTheme.primaryWhite.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct AddNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var colorTheme = ColorTheme.shared
    @State private var noteContent = ""
    @State private var showingSaveConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 20) {
                    Text("Add Note")
                        .font(.playfairDisplay(24, weight: .bold))
                        .foregroundColor(colorTheme.primaryWhite)
                        .padding(.top)
                    
                    TextEditor(text: $noteContent)
                        .font(.playfairDisplay(16))
                        .padding(15)
                        .background(colorTheme.primaryWhite.opacity(0.9))
                        .cornerRadius(12)
                        .frame(minHeight: 200)
                        .scrollContentBackground(.hidden)
                    
                    Button(action: saveNote) {
                        Text("Save Note")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(canSave ? colorTheme.primaryPurple : colorTheme.mediumGray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(canSave ? colorTheme.primaryWhite : colorTheme.lightGray)
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .disabled(!canSave)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
            .alert("Note Saved", isPresented: $showingSaveConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your note has been saved!")
            }
        }
    }
    
    private var canSave: Bool {
        !noteContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveNote() {
        guard !noteContent.isEmpty else { return }
        
        let note = Note(content: noteContent)
        dataManager.addNote(note)
        showingSaveConfirmation = true
    }
}

struct NoteDetailView: View {
    let note: Note
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var colorTheme = ColorTheme.shared
    @State private var showingEditView = false
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(note.content)
                            .font(.playfairDisplay(16, weight: .regular))
                            .foregroundColor(colorTheme.primaryWhite)
                            .padding()
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Created: \(formatDate(note.createdAt))")
                                .font(.playfairDisplay(14, weight: .light))
                                .foregroundColor(colorTheme.primaryWhite.opacity(0.7))
                            
                            if note.updatedAt != note.createdAt {
                                Text("Updated: \(formatDate(note.updatedAt))")
                                    .font(.playfairDisplay(14, weight: .light))
                                    .foregroundColor(colorTheme.primaryWhite.opacity(0.7))
                            }
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            Button(action: {
                                showingEditView = true
                            }) {
                                Text("Edit")
                                    .font(.playfairDisplay(16, weight: .medium))
                                    .foregroundColor(colorTheme.primaryPurple)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(colorTheme.primaryWhite)
                                    .cornerRadius(22)
                            }
                            
                            Button(action: {
                                showingDeleteConfirmation = true
                            }) {
                                Text("Delete")
                                    .font(.playfairDisplay(16, weight: .medium))
                                    .foregroundColor(colorTheme.errorRed)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(colorTheme.primaryWhite.opacity(0.2))
                                    .cornerRadius(22)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22)
                                            .stroke(colorTheme.errorRed.opacity(0.5), lineWidth: 1)
                                    )
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Note")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Close") {
                    dismiss()
                }
            )
            .sheet(isPresented: $showingEditView) {
                EditNoteView(note: note)
            }
            .alert("Delete Note", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    dataManager.deleteNote(note)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this note?")
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct EditNoteView: View {
    let note: Note
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var colorTheme = ColorTheme.shared
    @State private var noteContent = ""
    @State private var showingSaveConfirmation = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 20) {
                    Text("Edit Note")
                        .font(.playfairDisplay(24, weight: .bold))
                        .foregroundColor(colorTheme.primaryWhite)
                        .padding(.top)
                    
                    TextEditor(text: $noteContent)
                        .font(.playfairDisplay(16))
                        .padding(15)
                        .background(colorTheme.primaryWhite.opacity(0.9))
                        .cornerRadius(12)
                        .frame(minHeight: 200)
                        .scrollContentBackground(.hidden)
                    
                    Button(action: saveNote) {
                        Text("Save Changes")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(canSave ? colorTheme.primaryPurple : colorTheme.mediumGray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(canSave ? colorTheme.primaryWhite : colorTheme.lightGray)
                            .cornerRadius(25)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .disabled(!canSave)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
            .onAppear {
                noteContent = note.content
            }
            .alert("Note Updated", isPresented: $showingSaveConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your note has been updated!")
            }
        }
    }
    
    private var canSave: Bool {
        !noteContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveNote() {
        guard !noteContent.isEmpty else { return }
        
        let updatedNote = note.updated(content: noteContent)
        dataManager.updateNote(updatedNote)
        showingSaveConfirmation = true
    }
}

#Preview {
    NotesView()
}
