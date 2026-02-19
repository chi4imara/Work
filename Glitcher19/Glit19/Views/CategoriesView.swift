import SwiftUI

struct CategoriesView: View {
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                categoriesListView
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Categories")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var categoriesListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                if viewModel.categories.filter({ $0.notesCount > 0 }).isEmpty {
                    emptyStateView
                } else {
                    ForEach(viewModel.categories.filter { $0.notesCount > 0 }, id: \.id) { category in
                        NavigationLink(destination: CategoryNotesView(category: category, viewModel: viewModel)) {
                            CategoryCardView(category: category)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 120)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "folder")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.secondaryText)
            
            Text("Categories will appear after adding notes.")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
    }
}

struct CategoryCardView: View {
    let category: Category
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(Color.theme.primaryText)
                
                Text("\(category.notesCount) \(category.notesCount == 1 ? "note" : "notes")")
                    .font(.ubuntu(14))
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16))
                .foregroundColor(Color.theme.secondaryText)
        }
        .padding(16)
        .background(Color.theme.cardGradient)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct CategoryNotesView: View {
    let category: Category
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    private var categoryNotes: [Note] {
        viewModel.notesForCategory(category.name)
    }
    
    var body: some View {
        ZStack {
            Color.theme.primaryGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if categoryNotes.isEmpty {
                            emptyStateView
                        } else {
                            ForEach(categoryNotes) { note in
                                NavigationLink(destination: NoteDetailView(noteId: note.id, viewModel: viewModel)) {
                                    NoteCardView(note: note)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Back") {
                    dismiss()
                }
                .foregroundColor(Color.theme.accentYellow)
                .font(.ubuntu(16, weight: .medium))
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(Color.theme.secondaryText)
            
            Text("No notes in this category yet.")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(Color.theme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
    }
}

#Preview {
    CategoriesView(viewModel: NotesViewModel())
}
