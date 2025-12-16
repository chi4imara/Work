import SwiftUI

struct NotesView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var showingCreateNote = false
    @State private var selectedNoteID: NoteID?
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchBar
                
                if viewModel.filteredNotes.isEmpty {
                    emptyStateView
                } else {
                    notesList
                }
            }
        }
        .sheet(isPresented: $showingCreateNote) {
            NoteCreationView(viewModel: viewModel)
        }
        .sheet(item: $selectedNoteID) { noteID in
            NoteDetailsView(noteID: noteID.id, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("My Notes")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Text("Inspiration, scenarios and tips")
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Spacer()
                
                Button(action: {
                    showingCreateNote = true
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(Color.theme.purpleGradient)
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.theme.secondaryText)
            
            TextField("Search notes...", text: $viewModel.searchText)
                .font(.playfairDisplay(16))
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.theme.primaryWhite)
                .shadow(color: Color.theme.shadowColor, radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
        .padding(.top, 15)
        .padding(.bottom, 8)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(Color.theme.secondaryText.opacity(0.6))
            
            VStack(spacing: 8) {
                Text("No notes")
                    .font(.playfairDisplay(22, weight: .semibold))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Add inspiration, scenarios or tips for future posts.")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                showingCreateNote = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("New Note")
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.theme.purpleGradient)
                )
            }
            .padding(.top, 10)
            
            Spacer()
        }
    }
    
    private var notesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.filteredNotes) { note in
                    NoteCard(note: note) {
                        selectedNoteID = NoteID(id: note.id)
                    } onPin: {
                        viewModel.togglePin(note)
                    } onDelete: {
                        viewModel.deleteNote(note)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
            .padding(.bottom, 100)
        }
    }
}

struct NoteCard: View {
    let note: Note
    let onTap: () -> Void
    let onPin: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    HStack(spacing: 8) {
                        if note.isPinned {
                            Image(systemName: "pin.fill")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color.theme.primaryYellow)
                        }
                        
                        Text(note.title)
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(Color.theme.primaryText)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Text(note.createdDate, style: .date)
                        .font(.playfairDisplay(12, weight: .regular))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                if !note.content.isEmpty {
                    Text(note.preview)
                        .font(.playfairDisplay(14, weight: .regular))
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(note.isPinned ? 
                          LinearGradient(colors: [Color.theme.lightYellow, Color.theme.primaryWhite], startPoint: .topLeading, endPoint: .bottomTrailing) :
                          Color.theme.cardGradient)
                    .shadow(color: Color.theme.shadowColor, radius: note.isPinned ? 10 : 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(note.isPinned ? Color.theme.primaryYellow.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: onPin) {
                Label(note.isPinned ? "Unpin" : "Pin", systemImage: note.isPinned ? "pin.slash" : "pin")
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                Label("Delete", systemImage: "trash")
            }
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("Delete") {
                showingDeleteAlert = true
            }
            .tint(.red)
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete \"\(note.title)\"?")
        }
    }
}

struct NoteDetailsView: View {
    let noteID: UUID
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditView = false
    
    private var note: Note? {
        viewModel.getNote(by: noteID)
    }
    
    var body: some View {
        Group {
            if let note = note {
                NavigationView {
                    ZStack {
                        Color.theme.primaryGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        if note.isPinned {
                                            Image(systemName: "pin.fill")
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(Color.theme.primaryYellow)
                                        }
                                        
                                        Text(note.title)
                                            .font(.playfairDisplay(24, weight: .bold))
                                            .foregroundColor(Color.theme.primaryText)
                                        
                                        Spacer()
                                    }
                                    
                                    Text("Created \(note.createdDate, style: .date)")
                                        .font(.playfairDisplay(14, weight: .regular))
                                        .foregroundColor(Color.theme.secondaryText)
                                }
                                
                                Text(note.content)
                                    .font(.playfairDisplay(16, weight: .regular))
                                    .foregroundColor(Color.theme.primaryText)
                                    .lineSpacing(4)
                                
                                Spacer(minLength: 50)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                dismiss()
                            }
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(Color.theme.accentText)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                Button(action: {
                                    viewModel.togglePin(note)
                                }) {
                                    Label(note.isPinned ? "Unpin" : "Pin", systemImage: note.isPinned ? "pin.slash" : "pin")
                                }
                                
                                Button(action: {
                                    showingEditView = true
                                }) {
                                    Label("Edit", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive, action: {
                                    viewModel.deleteNote(note)
                                    dismiss()
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color.theme.accentText)
                            }
                        }
                    }
                }
                .sheet(isPresented: $showingEditView) {
                    NoteCreationView(viewModel: viewModel, editingNote: note)
                }
            } else {
                EmptyView()
            }
        }
    }
}

#Preview {
    NotesView()
}
