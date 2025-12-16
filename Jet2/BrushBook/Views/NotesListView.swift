import SwiftUI

struct NotesListView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @State private var showingAddNote = false
    @State private var selectedNoteId: UUID?
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            if viewModel.notes.isEmpty {
                emptyStateView
            } else {
                notesListView
            }
        }
        .background(ColorManager.backgroundGradient)
        .sheet(isPresented: $showingAddNote) {
            AddNoteView()
                .environmentObject(viewModel)
        }
        .sheet(isPresented: Binding(
            get: { selectedNoteId != nil },
            set: { if !$0 { selectedNoteId = nil } }
        )) {
            if let noteId = selectedNoteId {
                NoteDetailView(noteId: noteId)
                    .environmentObject(viewModel)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Notes")
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("\(viewModel.notes.count) notes")
                    .font(.playfairDisplay(14))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Spacer()
            
            Button(action: { showingAddNote = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(ColorManager.primaryButton)
                    .clipShape(Circle())
                    .shadow(color: ColorManager.cardShadow, radius: 8, x: 0, y: 4)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(ColorManager.secondaryText.opacity(0.5))
            
            VStack(spacing: 8) {
                Text("No notes yet")
                    .font(.playfairDisplay(20, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Add care tips or collection update plans")
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingAddNote = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("New Note")
                        .font(.playfairDisplay(16, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(ColorManager.primaryButton)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var notesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.sortedNotes) { note in
                    NoteCardView(note: note) {
                        selectedNoteId = note.id
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 120)
        }
    }
}

struct NoteCardView: View {
    let note: Note
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(note.title)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(ColorManager.primaryText)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text(note.createdDate, formatter: DateFormatter.shortDate)
                        .font(.playfairDisplay(12))
                        .foregroundColor(ColorManager.secondaryText)
                }
                
                if !note.content.isEmpty {
                    Text(note.preview)
                        .font(.playfairDisplay(14))
                        .foregroundColor(ColorManager.secondaryText)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorManager.cardGradient)
                    .shadow(color: ColorManager.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddNoteView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var content = ""
    
    let noteToEdit: Note?
    
    init(noteToEdit: Note? = nil) {
        self.noteToEdit = noteToEdit
    }
    
    var isEditing: Bool {
        noteToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        headerView
                        
                        formView
                        
                        saveButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if let note = noteToEdit {
                    loadNoteData(note)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.white.opacity(0.8)))
            }
            
            Spacer()
            
            Text(isEditing ? "Edit Note" : "New Note")
                .font(.playfairDisplay(24, weight: .bold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.top, 10)
    }
    
    private var formView: some View {
        VStack(spacing: 20) {
            FormField(title: "Title") {
                TextField("e.g., Brush Cleaning Tips", text: $title)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorManager.primaryText.opacity(0.2), lineWidth: 1)
                            )
                    )
            }
            
            FormField(title: "Content") {
                TextField("Write your note here...", text: $content, axis: .vertical)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.primaryText)
                    .lineLimit(8...15)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorManager.primaryText.opacity(0.2), lineWidth: 1)
                            )
                    )
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveNote) {
            Text(isEditing ? "Update Note" : "Save Note")
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(title.isEmpty ? AnyShapeStyle(ColorManager.secondaryText) : AnyShapeStyle(ColorManager.primaryButton))
                )
                .shadow(color: ColorManager.cardShadow, radius: 8, x: 0, y: 4)
        }
        .disabled(title.isEmpty)
        .padding(.top, 20)
    }
    
    private func loadNoteData(_ note: Note) {
        title = note.title
        content = note.content
    }
    
    private func saveNote() {
        if let existingNote = noteToEdit {
            let updatedNote = Note(
                id: existingNote.id,
                title: title,
                content: content,
                createdDate: existingNote.createdDate
            )
            viewModel.updateNote(updatedNote)
        } else {
            let note = Note(title: title, content: content)
            viewModel.addNote(note)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct NoteDetailView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let noteId: UUID
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    private var note: Note? {
        viewModel.notes.first { $0.id == noteId }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorManager.backgroundGradient
                    .ignoresSafeArea()
                
                if let note = note {
                    ScrollView {
                        VStack(spacing: 24) {
                            headerView
                            
                            noteContentView(note: note)
                            
                            actionButtons(note: note)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                } else {
                    VStack {
                        Text("Note not found")
                            .font(.playfairDisplay(18))
                            .foregroundColor(ColorManager.secondaryText)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditSheet) {
                if let note = note {
                    AddNoteView(noteToEdit: note)
                        .environmentObject(viewModel)
                }
            }
            .alert("Delete Note", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let note = note {
                        viewModel.deleteNote(note)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } message: {
                Text("Are you sure you want to delete this note? This action cannot be undone.")
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.white.opacity(0.8)))
            }
            
            Spacer()
            
            Text("Note")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            Menu {
                Button(action: { showingEditSheet = true }) {
                    Label("Edit", systemImage: "pencil")
                }
                
                Button(role: .destructive, action: { showingDeleteAlert = true }) {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorManager.primaryText)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.white.opacity(0.8)))
            }
        }
        .padding(.top, 10)
    }
    
    private func noteContentView(note: Note) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(note.title)
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Created: \(note.createdDate, formatter: DateFormatter.longDate)")
                    .font(.playfairDisplay(14))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            if !note.content.isEmpty {
                Text(note.content)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.primaryText)
                    .lineSpacing(4)
            } else {
                Text("No content")
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.secondaryText)
                    .italic()
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorManager.cardGradient)
                .shadow(color: ColorManager.shadowColor, radius: 15, x: 0, y: 8)
        )
    }
    
    private func actionButtons(note: Note) -> some View {
        VStack(spacing: 12) {
            Button(action: { showingEditSheet = true }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Edit Note")
                        .font(.playfairDisplay(16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(ColorManager.primaryButton)
                .cornerRadius(26)
                .shadow(color: ColorManager.cardShadow, radius: 8, x: 0, y: 4)
            }
            
            Button(action: { showingDeleteAlert = true }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Delete Note")
                        .font(.playfairDisplay(16, weight: .semibold))
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color.white.opacity(0.8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 26)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                )
            }
        }
        .padding(.top, 20)
    }
}
