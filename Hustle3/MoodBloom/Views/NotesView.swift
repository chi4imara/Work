import SwiftUI

struct NotesView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    @State private var showingAddNote = false
    @State private var selectedNote: Note?
    @State private var showingNoteDetail = false
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                headerView
                
                if notesViewModel.notes.isEmpty {
                    emptyStateView
                } else {
                    notesListView
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView(notesViewModel: notesViewModel)
        }
        .sheet(item: $selectedNote) { note in
            NoteDetailView(note: note, notesViewModel: notesViewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Notes")
                .font(FontManager.title)
                .foregroundColor(Color.textPrimary)
            
            Spacer()
            
            HStack(spacing: 12) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        notesViewModel.toggleSortOrder()
                    }
                }) {
                    Image(systemName: notesViewModel.sortOrder == .newestFirst ? "arrow.down.circle" : "arrow.up.circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color.primaryBlue)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color.lightBlue.opacity(0.2))
                        )
                }
                
                Button(action: {
                    showingAddNote = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color.primaryBlue)
                        )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 20)
    }
    
    private var notesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(notesViewModel.notes) { note in
                    NoteCard(note: note) {
                        selectedNote = note
                        showingNoteDetail = true
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "note.text")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.primaryBlue.opacity(0.6))
            
            Text("No notes yet")
                .font(FontManager.headline)
                .foregroundColor(Color.textPrimary)
            
            Text("Create your first note to capture thoughts and reflections")
                .font(FontManager.body)
                .foregroundColor(Color.textSecondary)
                .multilineTextAlignment(.center)
            
            Button("Add Note") {
                showingAddNote = true
            }
            .font(FontManager.body)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.primaryBlue)
            )
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.backgroundWhite)
                .shadow(color: Color.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 20)
    }
}

struct NoteCard: View {
    let note: Note
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(note.title.isEmpty ? "Untitled" : note.title)
                        .font(FontManager.subheadline)
                        .foregroundColor(Color.textPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(formatDate(note.createdAt))
                        .font(FontManager.caption)
                        .foregroundColor(Color.textSecondary)
                }
                
                if !note.content.isEmpty {
                    Text(note.preview)
                        .font(FontManager.body)
                        .foregroundColor(Color.textSecondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                } else {
                    Text("No content")
                        .font(FontManager.body)
                        .foregroundColor(Color.textSecondary.opacity(0.7))
                        .italic()
                }
                
                HStack {
                    if note.updatedAt != note.createdAt {
                        Text("Updated \(formatDate(note.updatedAt))")
                            .font(FontManager.small)
                            .foregroundColor(Color.textSecondary.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.textSecondary)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.backgroundWhite)
                    .shadow(color: Color.primaryBlue.opacity(0.08), radius: 8, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.timeStyle = .short
            return "Today, \(formatter.string(from: date))"
        } else if Calendar.current.isDateInYesterday(date) {
            formatter.timeStyle = .short
            return "Yesterday, \(formatter.string(from: date))"
        } else {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
}

struct AddNoteView: View {
    @ObservedObject var notesViewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var showingDiscardAlert = false
    
    private let characterLimit = 500
    
    private var hasChanges: Bool {
        !title.isEmpty || !content.isEmpty
    }
    
    private var canSave: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && content.count <= characterLimit
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title (optional)")
                            .font(FontManager.subheadline)
                            .foregroundColor(Color.textPrimary)
                        
                        TextField("Enter title...", text: $title)
                            .font(FontManager.body)
                            .foregroundColor(Color.textPrimary)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.backgroundWhite)
                                    .shadow(color: Color.primaryBlue.opacity(0.05), radius: 5)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Content")
                                .font(FontManager.subheadline)
                                .foregroundColor(Color.textPrimary)
                            
                            Spacer()
                            
                            Text("\(content.count)/\(characterLimit)")
                                .font(FontManager.caption)
                                .foregroundColor(content.count > characterLimit ? Color.accentRed : Color.textSecondary)
                        }
                        
                        TextEditor(text: $content)
                            .font(FontManager.body)
                            .foregroundColor(Color.textPrimary)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.backgroundWhite)
                                    .shadow(color: Color.primaryBlue.opacity(0.05), radius: 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(content.count > characterLimit ? Color.accentRed : Color.clear, lineWidth: 1)
                                    )
                            )
                            .frame(minHeight: 200)
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if hasChanges {
                            showingDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }
                    .foregroundColor(Color.textSecondary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                    }
                    .foregroundColor(canSave ? Color.primaryBlue : Color.textSecondary.opacity(0.5))
                    .fontWeight(.semibold)
                    .disabled(!canSave)
                }
            }
        }
        .alert("Discard Note?", isPresented: $showingDiscardAlert) {
            Button("Discard", role: .destructive) {
                dismiss()
            }
            Button("Keep Editing", role: .cancel) { }
        } message: {
            Text("Your note will be lost if you don't save it.")
        }
    }
    
    private func saveNote() {
        let noteTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let noteContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let finalTitle = noteTitle.isEmpty ? String(noteContent.prefix(30)) : noteTitle
        
        notesViewModel.addNote(title: finalTitle, content: noteContent)
        dismiss()
    }
}

#Preview {
    NotesView(notesViewModel: NotesViewModel())
}
