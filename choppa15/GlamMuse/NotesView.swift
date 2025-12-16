import SwiftUI

struct NotesView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var showingCreateNote = false
    @State private var selectedNote: Note?
    @State private var noteToEdit: Note?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchView
                
                if viewModel.filteredNotes.isEmpty {
                    emptyStateView
                } else {
                    notesListView
                }
            }
        }
        .sheet(isPresented: $showingCreateNote) {
            CreateEditNoteView(viewModel: viewModel, noteToEdit: noteToEdit)
        }
        .onChange(of: showingCreateNote) { isShowing in
            if !isShowing {
                noteToEdit = nil
            }
        }
        .sheet(item: $selectedNote) { note in
            NoteDetailView(noteId: note.id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("My Notes")
                .font(.ubuntu(32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Text("Ideas and inspirations")
                .font(.ubuntu(16))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    private var searchView: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.secondaryText)
                
                TextField("Search notes...", text: $viewModel.searchText)
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.primaryText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(AppColors.cardBackground.opacity(0.2))
            .cornerRadius(12)
            
            Button(action: { showingCreateNote = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("New Note")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(AppColors.buttonPrimary)
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            VStack(spacing: 8) {
                Text("No notes")
                    .font(.ubuntu(20, weight: .medium))
                    .foregroundColor(AppColors.primaryText)
                
                Text("Add tips or inspirations for future looks")
                    .font(.ubuntu(16))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: { showingCreateNote = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("New Note")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(AppColors.primaryText)
                .frame(width: 200, height: 44)
                .background(AppColors.buttonPrimary)
                .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding(.horizontal, 40)
    }
    
    private var notesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredNotes) { note in
                    NoteCard(note: note) {
                        selectedNote = note
                    } onPin: {
                        viewModel.togglePin(note)
                    } onDelete: {
                        viewModel.deleteNote(note)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 120)
        }
    }
}

struct NoteCard: View {
    let note: Note
    let onTap: () -> Void
    let onPin: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var cardHeight: CGFloat = 0
    
    private let actionWidth: CGFloat = 120
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .trailing) {
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.spring()) {
                            offset = 0
                        }
                        onPin()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: note.isPinned ? "pin.slash" : "pin")
                                .font(.system(size: 20, weight: .medium))
                            Text(note.isPinned ? "Unpin" : "Pin")
                                .font(.ubuntu(12, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(width: actionWidth / 2)
                        .frame(maxHeight: .infinity)
                        .background(note.isPinned ? Color.orange : Color.blue)
                    }
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            offset = 0
                        }
                        onDelete()
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "trash")
                                .font(.system(size: 20, weight: .medium))
                            Text("Delete")
                                .font(.ubuntu(12, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(width: actionWidth / 2)
                        .frame(maxHeight: .infinity)
                        .background(Color.red)
                    }
                }
                .frame(height: cardHeight > 0 ? cardHeight : nil)
                .cornerRadius(12)
                .opacity(offset < 0 ? 1 : 0)
                
                Button(action: {
                    if offset == 0 {
                        onTap()
                    } else {
                        withAnimation(.spring()) {
                            offset = 0
                        }
                    }
                }) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            HStack(spacing: 8) {
                                if note.isPinned {
                                    Image(systemName: "pin.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(AppColors.warning)
                                }
                                
                                Text(note.title.isEmpty ? "Untitled" : note.title)
                                    .font(.ubuntu(18, weight: .medium))
                                    .foregroundColor(AppColors.darkText)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Text(DateFormatter.shortDate.string(from: note.dateCreated))
                                .font(.ubuntu(12))
                                .foregroundColor(AppColors.darkText.opacity(0.6))
                        }
                        
                        if !note.content.isEmpty {
                            Text(note.content)
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.darkText.opacity(0.8))
                                .lineLimit(3)
                        } else {
                            Text("No content")
                                .font(.ubuntu(14))
                                .foregroundColor(AppColors.darkText.opacity(0.5))
                                .italic()
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppColors.cardBackground)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(note.isPinned ? AppColors.warning.opacity(0.3) : Color.clear, lineWidth: 2)
                    )
                    .background(
                        GeometryReader { cardGeometry in
                            Color.clear
                                .onAppear {
                                    cardHeight = cardGeometry.size.height
                                }
                                .onChange(of: cardGeometry.size.height) { newHeight in
                                    cardHeight = newHeight
                                }
                        }
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(height: cardHeight > 0 ? cardHeight : nil)
    }
}

#Preview {
    NotesView()
}
