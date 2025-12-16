import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel = NotesViewModel()
    @EnvironmentObject var dataManager: DataManager
    @State private var showingAddNote = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.mainBackgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        HStack {
                            Text("My Notes")
                                .font(.ubuntu(32, weight: .bold))
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Button(action: { showingAddNote = true }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(AppColors.primaryPurple)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(AppColors.primaryYellow)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    if viewModel.notes.isEmpty {
                        EmptyStateView(
                            icon: "note.text",
                            title: "No Notes",
                            description: "Add ideas, combinations or shopping plans for new outfits."
                        )
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.notes) { note in
                                    NavigationLink(destination: NoteDetailView(note: note)) {
                                        NoteCard(note: note, viewModel: viewModel)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 120)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddNote) {
            AddEditNoteView()
        }
    }
}

struct NoteCard: View {
    let note: Note
    let viewModel: NotesViewModel
    @State private var showingDeleteAlert = false
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: note.dateModified)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(note.title)
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(2)
                
                Spacer()
                
                Text(formattedDate)
                    .font(.ubuntu(12))
                    .foregroundColor(AppColors.secondaryText)
            }
            
            if !note.content.isEmpty {
                Text(note.preview)
                    .font(.ubuntu(14))
                    .foregroundColor(AppColors.secondaryText)
                    .lineLimit(3)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .contextMenu {
            Button(action: { showingDeleteAlert = true }) {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteNote(note)
            }
        } message: {
            Text("Are you sure you want to delete this note?")
        }
    }
}

struct AddEditNoteView: View {
    @StateObject private var viewModel = AddEditNoteViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let editingNote: Note?
    
    init(editingNote: Note? = nil) {
        self.editingNote = editingNote
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Note Title")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    TextField("e.g., Capsule wardrobe ideas", text: $viewModel.title)
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Content")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.primaryText)
                    
                    TextField("Add white blazer and beige trousers...", text: $viewModel.content, axis: .vertical)
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(minHeight: 120, alignment: .topLeading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardBackground)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .background(AppColors.mainBackgroundGradient.ignoresSafeArea())
            .navigationTitle(viewModel.isEditing ? "Edit Note" : "New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.save()
                        dismiss()
                    }
                    .foregroundColor(viewModel.canSave ? AppColors.primaryYellow : AppColors.secondaryText)
                    .disabled(!viewModel.canSave)
                }
            }
        }
        .onAppear {
            if let note = editingNote {
                viewModel.setEditingNote(note)
            }
        }
    }
}

struct NoteDetailView: View {
    @State var note: Note
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    
    private var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: note.dateCreated)
    }
    
    private var formattedModifiedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: note.dateModified)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(note.title)
                        .font(.ubuntu(28, weight: .bold))
                        .foregroundColor(AppColors.primaryText)
                        .lineLimit(nil)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Created: \(formattedCreatedDate)")
                            .font(.ubuntu(12))
                            .foregroundColor(AppColors.secondaryText)
                        
                        if note.dateModified != note.dateCreated {
                            Text("Modified: \(formattedModifiedDate)")
                                .font(.ubuntu(12))
                                .foregroundColor(AppColors.secondaryText)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(AppColors.cardBackground)
                )
                
                if !note.content.isEmpty {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Content")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(AppColors.primaryText)
                        
                        Text(note.content)
                            .font(.ubuntu(16))
                            .foregroundColor(AppColors.secondaryText)
                            .lineLimit(nil)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColors.cardBackground)
                    )
                }
                
                VStack(spacing: 16) {
                    Button(action: { showingEditSheet = true }) {
                        HStack {
                            Image(systemName: "pencil")
                                .font(.system(size: 16, weight: .medium))
                            Text("Edit Note")
                                .font(.ubuntu(16, weight: .medium))
                        }
                        .foregroundColor(AppColors.buttonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.buttonBackground)
                        )
                    }
                    
                    Button(action: { showingDeleteAlert = true }) {
                        HStack {
                            Image(systemName: "trash")
                                .font(.system(size: 16, weight: .medium))
                            Text("Delete Note")
                                .font(.ubuntu(16, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.errorRed)
                        )
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .background(AppColors.mainBackgroundGradient.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEditSheet) {
            AddEditNoteView(editingNote: note)
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                dataManager.deleteNote(note)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
        .onReceive(dataManager.$notes) { notes in
            if let updatedNote = notes.first(where: { $0.id == note.id }) {
                self.note = updatedNote
            }
        }
    }
}

#Preview {
    NotesListView()
        .environmentObject(DataManager.shared)
}
