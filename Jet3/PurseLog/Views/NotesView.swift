import SwiftUI

struct NoteDetailItem: Identifiable {
    let id: UUID
}

struct NotesView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var showingAddNote = false
    @State private var selectedNoteId: UUID?
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.notes.isEmpty {
                    emptyStateView
                    
                    Spacer()
                } else {
                    notesListView
                }
            }
        }
        .sheet(isPresented: $showingAddNote) {
            AddEditNoteView(viewModel: viewModel)
        }
        .sheet(item: Binding(
            get: { selectedNoteId.map { NoteDetailItem(id: $0) } },
            set: { selectedNoteId = $0?.id }
        )) { item in
            NoteDetailView(noteId: item.id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Notes")
                .font(FontManager.ubuntu(.bold, size: 28))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: { showingAddNote = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.primaryYellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var notesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.notes) { note in
                    NoteCard(note: note, onTap: {
                        selectedNoteId = note.id
                    }, onDelete: {
                        viewModel.deleteNote(note)
                    })
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 120)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No notes yet")
                    .font(FontManager.ubuntu(.bold, size: 24))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add ideas for new outfits or bag collections.")
                    .font(FontManager.ubuntu(.regular, size: 16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 40)
            
            Button("New Note") {
                showingAddNote = true
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, 60)
            
            Spacer()
        }
    }
}

struct NoteCard: View {
    let note: Note
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteConfirmation = false
    
    private var deleteThreshold: CGFloat = -100
    
    init(note: Note, onTap: @escaping () -> Void, onDelete: @escaping () -> Void) {
        self.note = note
        self.onTap = onTap
        self.onDelete = onDelete
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            if offset.width < 0 {
                HStack {
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("Delete")
                            .font(FontManager.ubuntu(.bold, size: 14))
                            .foregroundColor(.white)
                    }
                    .frame(width: 80)
                    .opacity(min(abs(offset.width) / 100.0, 1.0))
                }
                .padding(.trailing, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.error)
                )
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(note.title)
                        .font(FontManager.ubuntu(.bold, size: 18))
                        .foregroundColor(AppColors.darkText)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text(DateFormatter.shortDate.string(from: note.dateCreated))
                        .font(FontManager.ubuntu(.regular, size: 12))
                        .foregroundColor(AppColors.darkText.opacity(0.6))
                }
                
                Text(note.preview)
                    .font(FontManager.ubuntu(.regular, size: 14))
                    .foregroundColor(AppColors.darkText.opacity(0.8))
                    .lineLimit(3)
                    .lineSpacing(2)
                
                HStack {
                    Spacer()
                    
                    Image(systemName: "note.text")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.primaryYellow.opacity(0.7))
                }
            }
            .padding(16)
            .cardStyle()
            .offset(x: offset.width, y: 0)
        }
        .onTapGesture {
            onTap()
        }
        .highPriorityGesture(
            DragGesture(minimumDistance: 25)
                .onChanged { value in
                    if value.translation.width < 0 {
                        withAnimation(.interactiveSpring()) {
                            offset = value.translation
                        }
                    }
                }
                .onEnded { value in
                    if value.translation.width < deleteThreshold {
                        showingDeleteConfirmation = true
                    }
                    withAnimation(.spring()) {
                        offset = .zero
                    }
                }
        )
        .alert("Delete Note", isPresented: $showingDeleteConfirmation) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this note?")
        }
    }
}

struct AddEditNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    let editingNote: Note?
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    init(viewModel: NotesViewModel, editingNote: Note? = nil) {
        self.viewModel = viewModel
        self.editingNote = editingNote
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(AppColors.primaryYellow.opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "note.text")
                            .font(.system(size: 32))
                            .foregroundColor(AppColors.primaryYellow)
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 20) {
                        FormField(
                            title: "Title",
                            text: $title,
                            placeholder: "e.g., Summer outfit ideas"
                        )
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Content")
                                .font(FontManager.ubuntu(.medium, size: 16))
                                .foregroundColor(AppColors.primaryText)
                            
                            TextEditor(text: $content)
                                .font(FontManager.ubuntu(.regular, size: 16))
                                .foregroundColor(AppColors.darkText)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 200)
                                .padding(12)
                                .background(AppColors.cardBackground)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(AppColors.primaryYellow.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Button(action: saveNote) {
                        Text(editingNote == nil ? "Save Note" : "Update Note")
                            .font(FontManager.ubuntu(.medium, size: 18))
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppColors.buttonPrimary)
                            .cornerRadius(28)
                    }
                    .disabled(!isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.6)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle(editingNote == nil ? "New Note" : "Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            loadNoteData()
        }
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func loadNoteData() {
        if let note = editingNote {
            title = note.title
            content = note.content
        }
    }
    
    private func saveNote() {
        if let editingNote = editingNote {
            var updatedNote = editingNote
            updatedNote.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            updatedNote.content = content.trimmingCharacters(in: .whitespacesAndNewlines)
            viewModel.updateNote(updatedNote)
        } else {
            let note = Note(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                content: content.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            viewModel.addNote(note)
        }
        
        dismiss()
    }
}

struct NoteDetailView: View {
    let noteId: UUID
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var note: Note? {
        viewModel.notes.first { $0.id == noteId }
    }
    
    var body: some View {
        Group {
            if let currentNote = note {
                NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(currentNote.title)
                                .font(FontManager.ubuntu(.bold, size: 24))
                                .foregroundColor(AppColors.primaryText)
                            
                            Text("Created: \(DateFormatter.longDate.string(from: currentNote.dateCreated))")
                                .font(FontManager.ubuntu(.regular, size: 14))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.top, 20)
                        
                        Text(currentNote.content)
                            .font(FontManager.ubuntu(.regular, size: 16))
                            .foregroundColor(AppColors.primaryText)
                            .lineSpacing(6)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                    Menu {
                        Button("Edit") {
                            showingEditView = true
                        }
                        
                        Button("Delete", role: .destructive) {
                            showingDeleteAlert = true
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(AppColors.primaryYellow)
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
        .sheet(isPresented: $showingEditView) {
            AddEditNoteView(viewModel: viewModel, editingNote: currentNote)
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteNote(currentNote)
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
            } else {
                NavigationView {
                    ZStack {
                        BackgroundView()
                        VStack {
                            Text("Note not found")
                                .font(FontManager.ubuntu(.bold, size: 20))
                                .foregroundColor(AppColors.primaryText)
                            Button("Close") {
                                dismiss()
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                    }
                    .navigationTitle("Error")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                dismiss()
                            }
                            .foregroundColor(AppColors.primaryText)
                        }
                    }
                }
            }
        }
    }
}

extension DateFormatter {
    static let longDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter
    }()
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
