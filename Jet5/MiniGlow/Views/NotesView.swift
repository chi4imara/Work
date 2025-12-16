import SwiftUI

struct NotesView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var showingAddNote = false
    @State private var selectedNoteId: UUID?
    
    private var sortedNotes: [Note] {
        appViewModel.notes.sorted { $0.dateModified > $1.dateModified }
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                HStack {
                    Text("My Notes")
                        .font(.titleLarge)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddNote = true
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.textPrimary)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(Color.buttonSecondary)
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                if sortedNotes.isEmpty {
                    EmptyStateView(
                        title: "No notes yet",
                        subtitle: "Add ideas for new sets or products you need to buy.",
                        buttonTitle: "New Note",
                        buttonAction: {
                            showingAddNote = true
                        }
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(sortedNotes) { note in
                                NoteCardView(note: note) {
                                    selectedNoteId = note.id
                                } onDelete: {
                                    appViewModel.deleteNote(note)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddNote) {
            CreateNoteView(appViewModel: appViewModel)
        }
        .sheet(item: Binding(
            get: { selectedNoteId.map { NoteIdentifier(id: $0) } },
            set: { selectedNoteId = $0?.id }
        )) { identifier in
            NoteDetailView(noteId: identifier.id, appViewModel: appViewModel)
        }
    }
}

struct NoteIdentifier: Identifiable {
    let id: UUID
}

struct NoteCardView: View {
    let note: Note
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: note.dateModified)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(note.title)
                        .font(.titleSmall)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Text(formattedDate)
                        .font(.caption)
                        .foregroundColor(.textSecondary)
                }
                
                if !note.previewText.isEmpty {
                    Text(note.previewText)
                        .font(.bodySmall)
                        .foregroundColor(.textSecondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                showingDeleteAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                withAnimation(.spring(response: 0.3)) {
                    onDelete()
                }
            }
        } message: {
            Text("Are you sure you want to delete this note?")
        }
    }
}

struct NoteDetailView: View {
    let noteId: UUID
    @ObservedObject var appViewModel: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditNote = false
    
    private var note: Note? {
        appViewModel.notes.first { $0.id == noteId }
    }
    
    private var formattedDate: String {
        guard let note = note else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: note.dateModified)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                if let note = note {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text(note.title)
                                .font(.titleMedium)
                                .foregroundColor(.textPrimary)
                                .multilineTextAlignment(.leading)
                            
                            Text("Modified: \(formattedDate)")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            Text(note.content)
                                .font(.bodyMedium)
                                .foregroundColor(.textPrimary)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(4)
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                } else {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 60, weight: .light))
                            .foregroundColor(.textSecondary)
                        
                        Text("Note Not Found")
                            .font(.titleMedium)
                            .foregroundColor(.textPrimary)
                        
                        Text("This note may have been deleted.")
                            .font(.bodyMedium)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Go Back") {
                            dismiss()
                        }
                        .font(.buttonMedium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.buttonPrimary)
                        )
                        
                        Spacer()
                    }
                    .padding(.horizontal, 40)
                }
            }
            .navigationTitle("Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.textPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditNote = true
                    }
                    .foregroundColor(.primaryPurple)
                    .disabled(note == nil)
                }
            }
        }
        .sheet(isPresented: $showingEditNote) {
            if let note = note {
                CreateNoteView(appViewModel: appViewModel, editingNote: note)
            }
        }
    }
}

#Preview {
    NotesView(appViewModel: AppViewModel())
}
