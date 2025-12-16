import SwiftUI
import Combine

struct NotesView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var showAddNote = false
    @State private var selectedNote: PersonalNote?
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Notes")
                        .font(.playfairDisplay(24, weight: .bold))
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    Button(action: { showAddNote.toggle() }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.textPrimary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                if viewModel.notes.isEmpty {
                    EmptyNotesState {
                        showAddNote = true
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.notes) { note in
                                NoteCard(note: note) {
                                    selectedNote = note
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadNotes()
        }
        .sheet(isPresented: $showAddNote) {
            AddNoteView { note in
                viewModel.saveNote(note)
            }
        }
        .sheet(item: $selectedNote) { note in
            NoteDetailView(note: note) { updatedNote in
                viewModel.updateNote(updatedNote)
                selectedNote = nil
            } onDelete: {
                viewModel.deleteNote(note)
                selectedNote = nil
            }
        }
    }
}

struct NoteCard: View {
    let note: PersonalNote
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(note.title)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(AppColors.textPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if note.isFromRandomQuestion {
                        Text("Random")
                            .font(.playfairDisplay(10, weight: .medium))
                            .foregroundColor(AppColors.primaryYellow)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppColors.primaryYellow.opacity(0.2))
                            )
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Text(note.preview)
                    .font(.playfairDisplay(14, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Text(formatDate(note.createdAt))
                    .font(.playfairDisplay(12, weight: .regular))
                    .foregroundColor(AppColors.textLight)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppGradients.cardGradient)
                    .shadow(color: AppColors.primaryBlue.opacity(0.1), radius: 5, x: 0, y: 2)
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

struct EmptyNotesState: View {
    let onAddNote: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "square.and.pencil")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryBlue)
            
            VStack(spacing: 16) {
                Text("Your personal thoughts will be here")
                    .font(.playfairDisplay(20, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text("Create notes to capture your reflections and insights")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                
                Button(action: onAddNote) {
                    Text("Add First Note")
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 14)
                        .background(AppGradients.buttonGradient)
                        .cornerRadius(20)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct AddNoteView: View {
    let onSave: (PersonalNote) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var noteText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 20) {
                    TextEditor(text: $noteText)
                        .font(.playfairDisplay(16, weight: .regular))
                        .foregroundColor(AppColors.textPrimary)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .overlay(
                            Group {
                                if noteText.isEmpty {
                                    VStack {
                                        HStack {
                                            Text("Write what you want to remember...")
                                                .font(.playfairDisplay(16, weight: .regular))
                                                .foregroundColor(AppColors.textLight)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                    .padding(.top, 8)
                                    .padding(.leading, 5)
                                }
                            }
                        )
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.8))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                }
                        )
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let note = PersonalNote(
                            content: noteText,
                            createdAt: Date(),
                            updatedAt: Date(),
                            isFromRandomQuestion: false
                        )
                        onSave(note)
                        dismiss()
                    }
                    .disabled(noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

struct NoteDetailView: View {
    let note: PersonalNote
    let onSave: (PersonalNote) -> Void
    let onDelete: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var isEditing = false
    @State private var editedText: String
    @State private var showDeleteAlert = false
    
    init(note: PersonalNote, onSave: @escaping (PersonalNote) -> Void, onDelete: @escaping () -> Void) {
        self.note = note
        self.onSave = onSave
        self.onDelete = onDelete
        self._editedText = State(initialValue: note.content)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Created: \(formatDate(note.createdAt))")
                                    .font(.playfairDisplay(14, weight: .regular))
                                    .foregroundColor(AppColors.textSecondary)
                                
                                Spacer()
                                
                                if note.isFromRandomQuestion {
                                    Text("From Random Questions")
                                        .font(.playfairDisplay(12, weight: .medium))
                                        .foregroundColor(AppColors.primaryYellow)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(AppColors.primaryYellow.opacity(0.2))
                                        )
                                }
                            }
                            
                            if note.updatedAt != note.createdAt {
                                Text("Last edited: \(formatDate(note.updatedAt))")
                                    .font(.playfairDisplay(12, weight: .regular))
                                    .foregroundColor(AppColors.textLight)
                            }
                        }
                        
                        Divider()
                            .background(AppColors.textLight)
                        
                        if isEditing {
                            TextEditor(text: $editedText)
                                .font(.playfairDisplay(16, weight: .regular))
                                .foregroundColor(AppColors.textPrimary)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .frame(minHeight: 200)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.white.opacity(0.8))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(AppColors.primaryBlue.opacity(0.2), lineWidth: 1)
                                        }
                                )
                        } else {
                            Text(note.content)
                                .font(.playfairDisplay(16, weight: .regular))
                                .foregroundColor(AppColors.textPrimary)
                                .lineSpacing(4)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding(20)
                }
            }
            .navigationTitle(isEditing ? "Edit Note" : "Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditing ? "Cancel" : "Close") {
                        if isEditing {
                            editedText = note.content
                            isEditing = false
                        } else {
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        if isEditing {
                            Button("Save") {
                                let updatedNote = PersonalNote(
                                    id: note.id,
                                    content: editedText,
                                    createdAt: note.createdAt,
                                    updatedAt: Date(),
                                    isFromRandomQuestion: note.isFromRandomQuestion
                                )
                                onSave(updatedNote)
                                isEditing = false
                            }
                            .disabled(editedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        } else {
                            Button("Edit") {
                                isEditing = true
                            }
                            
                            Button("Delete") {
                                showDeleteAlert = true
                            }
                            .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .alert("Delete Note", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

@MainActor
class NotesViewModel: ObservableObject {
    @Published var notes: [PersonalNote] = []
    
    private let dataManager = DataManager.shared
    
    func loadNotes() {
        notes = dataManager.getPersonalNotes()
    }
    
    func saveNote(_ note: PersonalNote) {
        dataManager.savePersonalNote(note)
        loadNotes()
    }
    
    func updateNote(_ note: PersonalNote) {
        dataManager.savePersonalNote(note)
        loadNotes()
    }
    
    func deleteNote(_ note: PersonalNote) {
        dataManager.deletePersonalNote(note)
        loadNotes()
    }
}

#Preview {
    NotesView()
}
