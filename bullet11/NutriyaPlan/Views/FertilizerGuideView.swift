import SwiftUI

struct FertilizerGuideView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var showingAddNote = false
    @State private var editingNote: UserNote?
    @Binding var showingSidebar: Bool
    
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                UniversalHeaderView(
                    title: "Fertilizer Guide",
                    onMenuTap: { showingSidebar = true }
                )
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            GuideSectionView(
                                title: "Mineral Fertilizers",
                                content: "Synthetic fertilizers that provide specific nutrients quickly. Use NPK ratios like 10-10-10 for balanced feeding. Apply every 2-4 weeks during growing season. Always dilute to half strength to prevent root burn."
                            )
                            
                            GuideSectionView(
                                title: "Organic Fertilizers",
                                content: "Natural fertilizers like compost, worm castings, or fish emulsion. Release nutrients slowly and improve soil structure. Apply monthly during growing season. Great for long-term plant health."
                            )
                            
                            GuideSectionView(
                                title: "Complex Fertilizers",
                                content: "All-in-one fertilizers containing macro and micronutrients. Perfect for beginners. Follow package instructions carefully. Usually applied every 2-3 weeks during active growth."
                            )
                            
                            GuideSectionView(
                                title: "Common Mistakes",
                                content: "Over-fertilizing causes salt buildup and root damage. Under-fertilizing leads to pale leaves and poor growth. Always water before and after fertilizing. Never fertilize dry soil or dormant plants."
                            )
                        }
                        
                        MyNotesSection(
                            notes: appViewModel.sortedNotes(),
                            onAddNote: { showingAddNote = true },
                            onEditNote: { note in editingNote = note },
                            onDeleteNote: { note in appViewModel.deleteNote(note) }
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView(appViewModel: appViewModel, note: nil) {
                showingAddNote = false
            }
        }
        .sheet(item: $editingNote) { note in
            AddNoteView(appViewModel: appViewModel, note: note) {
                editingNote = nil
            }
        }
    }
}


struct GuideSectionView: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.cardTitle)
                .foregroundColor(AppTheme.darkBlue)
            
            Text(content)
                .font(.appBody)
                .foregroundColor(AppTheme.darkBlue.opacity(0.8))
                .lineSpacing(2)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardGradient)
        .cornerRadius(16)
        .shadow(color: AppTheme.shadowColor, radius: 8, x: 0, y: 4)
    }
}

struct MyNotesSection: View {
    let notes: [UserNote]
    let onAddNote: () -> Void
    let onEditNote: (UserNote) -> Void
    let onDeleteNote: (UserNote) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("My Notes")
                    .font(.cardTitle)
                    .foregroundColor(AppTheme.primaryWhite)
                
                Spacer()
                
                Button("Add Note", action: onAddNote)
                    .font(.appCaption)
                    .foregroundColor(AppTheme.primaryYellow)
            }
            
            if notes.isEmpty {
                EmptyNotesView(onAddNote: onAddNote)
            } else {
                VStack(spacing: 12) {
                    ForEach(notes) { note in
                        NoteCardView(
                            note: note,
                            onEdit: { onEditNote(note) },
                            onDelete: { onDeleteNote(note) }
                        )
                    }
                }
            }
        }
    }
}

struct EmptyNotesView: View {
    let onAddNote: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "note.text")
                .font(.system(size: 40))
                .foregroundColor(AppTheme.primaryWhite.opacity(0.5))
            
            Text("You haven't added any notes yet")
                .font(.appBody)
                .foregroundColor(AppTheme.primaryWhite.opacity(0.7))
            
            Button {
                onAddNote()
            } label: {
                Text("Add First Note")
                    .font(.buttonSmall)
                    .foregroundColor(AppTheme.darkBlue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(AppTheme.primaryYellow)
                    .cornerRadius(16)
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.primaryWhite.opacity(0.1))
        )
    }
}

struct NoteCardView: View {
    let note: UserNote
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(note.title)
                    .font(.appBodyBold)
                    .foregroundColor(AppTheme.darkBlue)
                    .lineLimit(2)
                
                Spacer()
                
                Menu {
                    Button(action: onEdit) {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button(action: { showingDeleteConfirmation = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.darkBlue.opacity(0.6))
                }
            }
            
            if !note.content.isEmpty {
                Text(note.content)
                    .font(.appBody)
                    .foregroundColor(AppTheme.darkBlue.opacity(0.8))
                    .lineLimit(4)
            }
            
            HStack {
                Text("Modified: \(note.dateModified.formatted(date: .abbreviated, time: .omitted))")
                    .font(.appSmall)
                    .foregroundColor(AppTheme.darkBlue.opacity(0.6))
                
                Spacer()
            }
        }
        .padding(16)
        .background(AppTheme.cardGradient)
        .cornerRadius(12)
        .shadow(color: AppTheme.shadowColor, radius: 4, x: 0, y: 2)
        .onTapGesture {
            onEdit()
        }
        .alert("Delete Note", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this note?")
        }
    }
}

struct AddNoteView: View {
    @ObservedObject var appViewModel: AppViewModel
    let note: UserNote?
    let onComplete: () -> Void
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    @Environment(\.dismiss) private var dismiss
    
    private var isEditing: Bool {
        note != nil
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundGradient
                    .ignoresSafeArea()
                
                GridBackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title *")
                            .font(.appBodyBold)
                            .foregroundColor(AppTheme.primaryWhite)
                        
                        TextField("Enter note title", text: $title)
                            .textFieldStyle(CustomTextFieldStyle())
                            .overlay(alignment: .topLeading) {
                                if title.isEmpty {
                                    Text("Enter note title")
                                        .font(.appBody)
                                        .foregroundColor(.gray.opacity(0.6))
                                        .allowsHitTesting(false)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                }
                            }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Content")
                            .font(.appBodyBold)
                            .foregroundColor(AppTheme.primaryWhite)
                        
                        TextField("Enter note content (optional)", text: $content, axis: .vertical)
                            .textFieldStyle(CustomTextFieldStyle())
                            .lineLimit(5...10)
                            .overlay(alignment: .topLeading) {
                                if content.isEmpty {
                                    Text("Enter note content (optional)")
                                        .font(.appBody)
                                        .foregroundColor(.gray.opacity(0.6))
                                        .allowsHitTesting(false)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                }
                            }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle(isEditing ? "Edit Note" : "Add Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onComplete()
                    }
                    .foregroundColor(AppTheme.primaryWhite)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                    }
                    .foregroundColor(AppTheme.primaryYellow)
                    .fontWeight(.semibold)
                }
            }
            .preferredColorScheme(.dark)
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
        .onAppear {
            if let note = note {
                loadNoteData(note)
            }
        }
    }
    
    private func loadNoteData(_ note: UserNote) {
        title = note.title
        content = note.content
    }
    
    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            showError("Please enter a title for the note")
            return
        }
        
        guard trimmedTitle.count >= 3 else {
            showError("Title must be at least 3 characters long")
            return
        }
        
        if let existingNote = note {
            var updatedNote = existingNote
            updatedNote.update(
                title: trimmedTitle,
                content: content.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            appViewModel.updateNote(updatedNote)
        } else {
            let newNote = UserNote(
                title: trimmedTitle,
                content: content.trimmingCharacters(in: .whitespacesAndNewlines)
            )
            appViewModel.addNote(newNote)
        }
        
        onComplete()
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
}

