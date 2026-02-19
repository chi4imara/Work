import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel
    @State private var showingAddNote = false
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                searchAndFilterView
                
                notesListView
            }
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView(viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Notes")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
            
            Button(action: { showingAddNote = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(Color.theme.accentYellow)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var searchAndFilterView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.theme.secondaryText)
                
                TextField("Search by text", text: $viewModel.searchText)
                    .font(.ubuntu(16))
                    .foregroundColor(Color.theme.primaryText)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color.theme.secondaryText)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.theme.cardBackground)
            .cornerRadius(12)
            
            HStack {
                Text("Category:")
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                Picker("Category", selection: $viewModel.selectedCategory) {
                    ForEach(viewModel.availableCategories, id: \.self) { category in
                        Text(category)
                            .font(.ubuntu(13))
                            .tag(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(Color.theme.accentYellow)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.theme.cardBackground)
            .cornerRadius(12)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 10)
    }
    
    private var notesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if viewModel.filteredNotes.isEmpty {
                    emptyStateView
                } else {
                    ForEach(viewModel.filteredNotes) { note in
                        NavigationLink(destination: NoteDetailView(noteId: note.id, viewModel: viewModel)) {
                            NoteCardView(note: note)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 120)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.secondaryText)
            
            Text("No notes. Add your first thought.")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
    }
}

struct NoteCardView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(note.firstLine)
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                    .lineLimit(2)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            HStack {
                Text(note.category)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(Color.theme.accentYellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.theme.accentYellow.opacity(0.2))
                    .cornerRadius(8)
                
                Spacer()
                
                Text(note.formattedDate)
                    .font(.ubuntu(12))
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
        .padding(16)
        .background(Color.theme.cardGradient)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    NotesView(viewModel: NotesViewModel())
}
