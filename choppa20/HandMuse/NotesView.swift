import SwiftUI

struct NotesView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var showingAddNote = false
    @State private var selectedNoteId: UUID?
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.sortedNotes.isEmpty {
                    emptyStateView
                } else {
                    notesListView
                }
            }
        }
        .sheet(isPresented: $showingAddNote) {
            CreateNoteView(viewModel: viewModel)
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
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddNote = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(Color.theme.primaryYellow)
                    .background(
                        Circle()
                            .fill(Color.theme.primaryText)
                            .frame(width: 32, height: 32)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.primaryPurple.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No notes yet")
                    .font(.playfairDisplay(24, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("Add ideas, sketches or reminders for future projects.")
                    .font(.playfairDisplay(16))
                    .foregroundColor(Color.theme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                showingAddNote = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                    Text("New Note")
                }
                .font(.playfairDisplay(18, weight: .semibold))
                .foregroundColor(Color.theme.buttonText)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.theme.buttonBackground)
                        .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
                )
            }
            
            Spacer()
        }
    }
    
    private var notesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.sortedNotes) { note in
                    NoteCardView(note: note) {
                        selectedNoteId = note.id
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

struct NoteCardView: View {
    let note: Note
    let onTap: () -> Void
    let onDelete: () -> Void
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    Text(note.title)
                        .font(.playfairDisplay(18, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Text(dateFormatter.string(from: note.dateModified))
                        .font(.playfairDisplay(12))
                        .foregroundColor(Color.theme.secondaryText.opacity(0.7))
                }
                
                if !note.content.isEmpty {
                    Text(note.preview)
                        .font(.playfairDisplay(14))
                        .foregroundColor(Color.theme.secondaryText)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.theme.cardBackground)
                    .shadow(color: Color.theme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: onDelete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    NotesView()
}
