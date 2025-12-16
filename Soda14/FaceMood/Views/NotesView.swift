import SwiftUI

enum NotesEditMode: Identifiable {
    case edit(MakeupIdea)
    
    var id: String {
        switch self {
        case .edit(let idea): return idea.id.uuidString
        }
    }
}

struct NotesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: MakeupIdeaViewModel
    @State private var ideaToView: MakeupIdea?
    @State private var editMode: NotesEditMode?
    @State private var showingClearAlert = false
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Notes")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        if !viewModel.notesWithComments.isEmpty {
                            Button(action: {
                                showingClearAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .font(.system(size: 20))
                                    .foregroundColor(AppColors.errorRed)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(FilterType.allCases, id: \.self) { filter in
                                FilterButton(
                                    title: filter.rawValue,
                                    isSelected: viewModel.selectedFilter == filter
                                ) {
                                    viewModel.setFilter(filter)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                if viewModel.filteredNotes.isEmpty {
                    NotesEmptyStateView()
                } else {
                    NotesListView(
                        notes: viewModel.filteredNotes,
                        onNoteTapped: { idea in
                            ideaToView = idea
                        }
                    )
                }
            }
        }
        .sheet(item: $ideaToView) { idea in
            IdeaDetailView(idea: idea) { updatedIdea in
                viewModel.updateIdea(updatedIdea)
            } onDelete: { ideaToDelete in
                viewModel.deleteIdea(ideaToDelete)
            } onEdit: { ideaToEdit in
                ideaToView = nil
                editMode = .edit(ideaToEdit)
            }
            .environmentObject(viewModel)
        }
        .sheet(item: $editMode) { mode in
            switch mode {
            case .edit(let idea):
                AddEditIdeaView(ideaToEdit: idea) { updatedIdea in
                    viewModel.updateIdea(updatedIdea)
                }
                .environmentObject(viewModel)
            }
        }
        .alert("Clear All Notes", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                viewModel.clearAllNotes()
            }
        } message: {
            Text("Are you sure you want to clear all notes? The ideas will remain, but all comments will be removed.")
        }
    }
}

struct NotesEmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(AppColors.primaryYellow)
            
            Text("No notes yet")
                .font(AppFonts.title2)
                .foregroundColor(AppColors.primaryText)
            
            Text("Add a comment to any idea — it will appear here.")
                .font(AppFonts.body)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct NotesListView: View {
    let notes: [MakeupIdea]
    let onNoteTapped: (MakeupIdea) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(notes) { idea in
                    NoteCardView(
                        idea: idea,
                        onTap: {
                            onNoteTapped(idea)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

struct NoteCardView: View {
    let idea: MakeupIdea
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(idea.title)
                            .font(AppFonts.headline)
                            .foregroundColor(AppColors.primaryText)
                            .multilineTextAlignment(.leading)
                        
                        HStack(spacing: 8) {
                            Image(systemName: idea.tag.icon)
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.primaryYellow)
                            
                            Text(idea.tag.displayName)
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.accentText)
                        }
                    }
                    
                    Spacer()
                    
                    Text(idea.dateCreated.formatted(date: .abbreviated, time: .omitted))
                        .font(AppFonts.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "quote.opening")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.primaryYellow)
                        
                        Text("Note")
                            .font(AppFonts.subheadline)
                            .foregroundColor(AppColors.primaryYellow)
                        
                        Spacer()
                    }
                    
                    Text(idea.comment)
                        .font(AppFonts.body)
                        .foregroundColor(AppColors.primaryText)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 20)
                }
                
                if !idea.description.isEmpty {
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Idea Description")
                            .font(AppFonts.caption)
                            .foregroundColor(AppColors.secondaryText)
                        
                        Text(idea.description)
                            .font(AppFonts.subheadline)
                            .foregroundColor(AppColors.secondaryText)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(CardBackground())
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
