import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel
    @State private var showingAddNote = false
    @State private var selectedNoteId: UUID?
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.notes.isEmpty {
                    emptyStateView
                } else {
                    notesListView
                }
            }
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView(viewModel: viewModel)
        }
        .sheet(isPresented: Binding(
            get: { selectedNoteId != nil },
            set: { if !$0 { selectedNoteId = nil } }
        )) {
            if let id = selectedNoteId {
                NoteDetailView(noteId: id, viewModel: viewModel)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("My Notes")
                .font(AppFonts.largeTitle)
                .foregroundColor(AppColors.darkGray)
            
            Spacer()
            
            Button(action: {
                showingAddNote = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.purpleGradientStart)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 80))
                .foregroundColor(AppColors.purpleGradientStart.opacity(0.6))
            
            VStack(spacing: 12) {
                Text("No notes")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.darkGray)
                
                Text("Add ideas or descriptions of aromas you want to try.")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                showingAddNote = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("New Note")
                }
                .font(AppFonts.headline)
                .foregroundColor(.white)
                .frame(width: 160, height: 50)
                .background(AppColors.buttonGradient)
                .cornerRadius(25)
                .shadow(color: AppColors.purpleGradientStart.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Spacer()
        }
    }
    
    private var notesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.sortedNotes) { note in
                    NoteCardView(note: note) {
                        selectedNoteId = note.id
                    }
                    .contextMenu {
                        Button(action: {
                            selectedNoteId = note.id
                        }) {
                            Label("View Note", systemImage: "eye")
                        }
                        
                        Button(action: {
                            viewModel.deleteNote(note)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100) 
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
                        .font(AppFonts.headline)
                        .foregroundColor(AppColors.darkGray)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Text(DateFormatter.shortFormatter.string(from: note.dateCreated))
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.darkGray.opacity(0.6))
                }
                
                if !note.content.isEmpty {
                    Text(note.preview)
                        .font(AppFonts.subheadline)
                        .foregroundColor(AppColors.darkGray.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                }
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

extension DateFormatter {
    static let shortFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

#Preview {
    NotesView(viewModel: NotesViewModel())
}
