import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: TaskViewModel
    @State private var showingAddNote = false
    @State private var selectedNote: Note?
    @State private var showingNoteDetail = false
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                headerView
                
                if viewModel.notes.isEmpty {
                    emptyStateView
                } else {
                    notesList
                }
            }
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView(viewModel: viewModel)
        }
        .sheet(item: $selectedNote) { note in
            NoteDetailView(note: note, viewModel: viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Notes")
                .font(AppTypography.largeTitle)
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: { showingAddNote = true }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(AppColors.lightBlue)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText)
            
            Text("No notes. Create your first one")
                .font(AppTypography.headline)
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
            
            Button {
                showingAddNote = true
            } label: {
                Text("New Note")
                    .primaryButtonStyle()
            }
            
            Spacer()
        }
        .padding(.horizontal, AppSpacing.lg)
    }
    
    private var notesList: some View {
        ScrollView {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(viewModel.notes.sorted(by: { $0.createdAt > $1.createdAt })) { note in
                    NoteRowView(
                        note: note,
                        onTap: {
                            selectedNote = note
                            showingNoteDetail = true
                        }
                    )
                }
            }
            .padding(.horizontal, AppSpacing.lg)
            .padding(.bottom, AppSpacing.xl)
        }
    }
}

struct NoteRowView: View {
    let note: Note
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(note.preview)
                    .font(AppTypography.body)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                HStack {
                    Text(note.formattedDate)
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
            .padding(AppSpacing.md)
            .cardStyle()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddNoteView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: AppSpacing.lg) {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Text("Note Content")
                            .font(AppTypography.headline)
                            .foregroundColor(AppColors.primaryText)
                        
                        TextField("Write your note here...", text: $content, axis: .vertical)
                            .font(AppTypography.body)
                            .foregroundColor(AppColors.primaryText)
                            .padding(AppSpacing.md)
                            .background(AppColors.cardBackground)
                            .cornerRadius(AppRadius.medium)
                            .lineLimit(10...20)
                    }
                    
                    Button {
                        saveNote()
                    } label: {
                        Text("Save Note")
                            .primaryButtonStyle(isEnabled: !content.isEmpty)
                    }
                    .disabled(content.isEmpty)
                    
                    Spacer()
                }
                .padding(.horizontal, AppSpacing.lg)
                .padding(.top, AppSpacing.md)
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.accentText)
            )
        }
    }
    
    private func saveNote() {
        let newNote = Note(content: content)
        viewModel.addNote(newNote)
        presentationMode.wrappedValue.dismiss()
    }
}

struct NoteDetailView: View {
    let note: Note
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppSpacing.lg) {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            Text("Note")
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.secondaryText)
                                .textCase(.uppercase)
                            
                            Text(note.content)
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.primaryText)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppSpacing.lg)
                        .cardStyle()
                        
                        VStack(spacing: AppSpacing.md) {
                            HStack {
                                Text("Created")
                                    .font(AppTypography.headline)
                                    .foregroundColor(AppColors.primaryText)
                                
                                Spacer()
                                
                                Text(note.formattedDate)
                                    .font(AppTypography.body)
                                    .foregroundColor(AppColors.secondaryText)
                            }
                        }
                        .padding(AppSpacing.lg)
                        .cardStyle()
                        
                        Button {
                            showingDeleteAlert = true
                        } label: {
                            Text("Delete Note")
                                .font(AppTypography.headline)
                                .foregroundColor(AppColors.error)
                                .padding(.horizontal, AppSpacing.lg)
                                .padding(.vertical, AppSpacing.md)
                                .frame(maxWidth: .infinity)
                                .background(AppColors.cardBackground)
                                .cornerRadius(AppRadius.medium)
                                .overlay(
                                    RoundedRectangle(cornerRadius: AppRadius.medium)
                                        .stroke(AppColors.error, lineWidth: 1)
                                )
                                .padding(.top, AppSpacing.lg)
                        }
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .padding(.top, AppSpacing.md)
                }
            }
            .navigationTitle("Note Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(AppColors.accentText)
            )
        }
        .alert("Delete Note", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteNote(note)
                presentationMode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this note? This action cannot be undone.")
        }
    }
}

#Preview {
    NotesView(viewModel: TaskViewModel())
}
