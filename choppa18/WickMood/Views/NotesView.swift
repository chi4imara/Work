import SwiftUI

struct NotesView: View {
    @ObservedObject var noteStore: NoteStore
    @State private var showingAddNote = false
    @State private var showingNoteDetail: Note?
    @State private var searchText = ""
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return noteStore.sortedNotes
        } else {
            return noteStore.sortedNotes.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if !noteStore.notes.isEmpty {
                        searchBar
                    }
                    
                    if filteredNotes.isEmpty {
                        emptyStateView
                    } else {
                        notesList
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView(noteStore: noteStore)
        }
        .sheet(item: $showingNoteDetail) { note in
            NoteDetailView(note: note, noteStore: noteStore)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Notes")
                    .font(.playfairDisplay(size: 28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text("\(noteStore.notes.count) notes saved")
                    .font(.playfairDisplay(size: 14, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Button(action: {
                showingAddNote = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.primaryYellow)
                    .background(
                        Circle()
                            .fill(AppColors.primaryWhite)
                            .frame(width: 32, height: 32)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textLight)
            
            TextField("Search notes...", text: $searchText)
                .font(.playfairDisplay(size: 16))
                .foregroundColor(AppColors.textPrimary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(AppColors.cardBackground)
                .shadow(color: AppColors.shadowColor, radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }
    
    private var notesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredNotes) { note in
                    NoteCard(note: note) {
                        showingNoteDetail = note
                    } onDelete: {
                        noteStore.deleteNote(note)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.textLight)
            
            VStack(spacing: 12) {
                Text(noteStore.notes.isEmpty ? "No notes yet" : "No matching notes")
                    .font(.playfairDisplay(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.textPrimary)
                
                Text(noteStore.notes.isEmpty ? 
                     "Add ideas, scent combinations or shopping plans." :
                     "Try adjusting your search terms.")
                    .font(.playfairDisplay(size: 16))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
            .padding(.horizontal, 40)
            
            if noteStore.notes.isEmpty {
                Button(action: {
                    showingAddNote = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                        Text("New Note")
                            .font(.playfairDisplay(size: 16, weight: .semibold))
                    }
                    .foregroundColor(AppColors.buttonText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColors.buttonPrimary)
                            .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
                    )
                }
            }
            
            Spacer()
        }
        .padding(.bottom, 100)
    }
}

struct NoteCard: View {
    let note: Note
    let onTap: () -> Void
    let onDelete: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(AppColors.accentPink)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.trailing, 20)
                .opacity(offset.width < -50 ? 1 : 0)
            }
            
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(note.title.isEmpty ? "Untitled Note" : note.title)
                            .font(.playfairDisplay(size: 18, weight: .semibold))
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        Text(DateFormatter.shortDate.string(from: note.dateCreated))
                            .font(.playfairDisplay(size: 12, weight: .regular))
                            .foregroundColor(AppColors.textLight)
                    }
                    
                    if !note.content.isEmpty {
                        Text(note.preview)
                            .font(.playfairDisplay(size: 14, weight: .regular))
                            .foregroundColor(AppColors.textSecondary)
                            .lineLimit(3)
                            .lineSpacing(2)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColors.cardBackground)
                        .shadow(color: AppColors.shadowColor, radius: 6, x: 0, y: 3)
                )
            }
            .buttonStyle(PlainButtonStyle())
            .offset(x: offset.width, y: 0)
            .highPriorityGesture(
                DragGesture(minimumDistance: 25)
                    .onChanged { value in
                        if value.translation.width < 0 {
                            offset = value.translation
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if value.translation.width < -100 {
                                offset = CGSize(width: -80, height: 0)
                            } else {
                                offset = .zero
                            }
                        }
                    }
            )
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
    }
}

#Preview {
    NotesView(noteStore: NoteStore())
}
