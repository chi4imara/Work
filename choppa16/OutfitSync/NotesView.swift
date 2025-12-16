import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel
    @State private var showingAddNote = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppGradients.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    searchBarView
                    
                    if viewModel.filteredNotes.isEmpty {
                        emptyStateView
                        
                        Spacer()
                    } else {
                        notesListView
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddNote) {
            CreateNoteView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Notes")
                    .font(FontManager.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                
                if !viewModel.notes.isEmpty {
                    Text("\(viewModel.notes.count) note\(viewModel.notes.count == 1 ? "" : "s")")
                        .font(FontManager.playfairDisplay(size: 16, weight: .medium))
                        .foregroundColor(.primaryPurple)
                }
            }
            
            Spacer()
            
            Button(action: { showingAddNote = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.textOnDark)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(Color.primaryPurple)
                            .shadow(color: AppShadows.buttonShadow, radius: 4, x: 0, y: 2)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBarView: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.textSecondary)
            
            TextField("Search notes...", text: $viewModel.searchText)
                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                .foregroundColor(.textPrimary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.cardBackground)
                .shadow(color: AppShadows.cardShadow, radius: 2, x: 0, y: 1)
        )
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(.textSecondary.opacity(0.5))
            
            Text(viewModel.searchText.isEmpty ? "No notes yet" : "No matching notes")
                .font(FontManager.playfairDisplay(size: 20, weight: .semibold))
                .foregroundColor(.textPrimary)
            
            Text(viewModel.searchText.isEmpty ? 
                 "Add care tips or style ideas for your wardrobe." : 
                 "Try a different search term.")
                .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
            
            if viewModel.searchText.isEmpty {
                Button(action: { showingAddNote = true }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("New Note")
                    }
                    .font(FontManager.playfairDisplay(size: 16, weight: .semibold))
                    .foregroundColor(.textOnDark)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.primaryPurple)
                    )
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var notesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredNotes) { note in
                    NavigationLink(destination: NoteDetailView(note: note, viewModel: viewModel)) {
                        NoteCard(note: note)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

struct NoteCard: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(note.title)
                    .font(FontManager.playfairDisplay(size: 18, weight: .semibold))
                    .foregroundColor(.textPrimary)
                    .lineLimit(1)
                
                Spacer()
                
                Text(formatDate(note.dateCreated))
                    .font(FontManager.playfairDisplay(size: 12, weight: .medium))
                    .foregroundColor(.textSecondary)
            }
            
            if !note.content.isEmpty {
                Text(note.content)
                    .font(FontManager.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(.textSecondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cardBackground)
                .shadow(color: AppShadows.cardShadow, radius: 4, x: 0, y: 2)
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct NoteDetailView: View {
    let note: Note
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            AppGradients.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(note.title)
                            .font(FontManager.playfairDisplay(size: 24, weight: .bold))
                            .foregroundColor(.textPrimary)
                        
                        Text("Created \(formatDate(note.dateCreated))")
                            .font(FontManager.playfairDisplay(size: 14, weight: .medium))
                            .foregroundColor(.textSecondary)
                    }
                    
                    Text(note.content)
                        .font(FontManager.playfairDisplay(size: 16, weight: .regular))
                        .foregroundColor(.textPrimary)
                        .lineSpacing(6)
                    
                    Spacer(minLength: 100)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationTitle("Note")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: HStack {
                Button("Edit") {
                    showingEditView = true
                }
                
                Button("Delete") {
                    showingDeleteAlert = true
                }
                .foregroundColor(.accentOrange)
            }
        )
        .sheet(isPresented: $showingEditView) {
            CreateNoteView(viewModel: viewModel, editingNote: note)
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteNote(note)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
