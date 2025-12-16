import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: BeautyDiaryViewModel
    @State private var showingClearAlert = false
    @State private var selectedEntry: BeautyEntry?
    
    var body: some View {
        ZStack {
            Color.theme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.allNotes.isEmpty {
                    emptyStateView
                } else {
                    notesListView
                }
            }
        }
        .alert("Clear All Notes", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.clearAllNotes()
            }
        } message: {
            Text("This will remove all notes from your entries. The entries themselves will remain.")
        }
        .sheet(item: $selectedEntry) { entry in
            EntryDetailView(viewModel: viewModel, entry: entry)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                Text("My Notes")
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Spacer()
                
                if !viewModel.allNotes.isEmpty {
                    Button(action: {
                        showingClearAlert = true
                    }) {
                        Text("Clear")
                            .font(.playfairDisplay(14, weight: .semibold))
                            .foregroundColor(Color.theme.accentPink)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .padding(.bottom, 16)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.lightGray)
            
            Text("No notes yet")
                .font(.playfairDisplay(24, weight: .semibold))
                .foregroundColor(Color.theme.primaryText)
            
            Text("Here will be your observations about procedures. Add at least one entry in diary.")
                .font(.playfairDisplay(16))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var notesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(notesWithEntries, id: \.entry.id) { noteData in
                    NoteCardView(
                        procedureName: noteData.entry.procedureName,
                        note: noteData.entry.notes,
                        date: noteData.entry.formattedDate
                    ) {
                        selectedEntry = noteData.entry
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
    
    private var notesWithEntries: [(entry: BeautyEntry, note: String)] {
        return viewModel.entries
            .filter { $0.hasNotes }
            .sorted { $0.date > $1.date }
            .map { (entry: $0, note: $0.notes) }
    }
}

struct NoteCardView: View {
    let procedureName: String
    let note: String
    let date: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(procedureName)
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Text(date)
                        .font(.playfairDisplay(12))
                        .foregroundColor(Color.theme.secondaryText)
                }
                
                Text("\(note)")
                    .font(.playfairDisplay(14))
                    .foregroundColor(Color.theme.accentText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .background(Color.theme.cardBackground)
            .cornerRadius(12)
            .shadow(color: Color.theme.cardShadow, radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NotesView(viewModel: BeautyDiaryViewModel())
}
