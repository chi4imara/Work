import SwiftUI

struct NotesView: View {
    @ObservedObject var viewModel: NotesViewModel
    @State private var showingAddNote = false
    @State private var selectedNote: Note?
    
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
            AddNoteView { note in
                viewModel.addNote(note)
            }
        }
        .sheet(item: $selectedNote) { note in
            NoteDetailView(note: note) {
                viewModel.deleteNote(note)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Notes")
                .font(.playfairDisplay(32, weight: .bold))
                .foregroundColor(AppColors.primaryText)
            
            Spacer()
            
            Button(action: { showingAddNote = true }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("New Note")
                        .font(.playfairDisplay(16, weight: .semibold))
                }
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(AppColors.buttonGradient)
                .cornerRadius(20)
                .shadow(color: AppColors.shadowColor, radius: 5, x: 0, y: 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.cardGradient)
                    .frame(width: 120, height: 120)
                    .shadow(color: AppColors.shadowColor, radius: 15, x: 0, y: 8)
                
                Image(systemName: "note.text")
                    .font(.system(size: 50, weight: .light))
                    .foregroundColor(AppColors.lightBlue)
            }
            
            VStack(spacing: 15) {
                Text("No notes. Create your first")
                    .font(.playfairDisplay(24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text("Keep track of important information, shopping lists, or reminders related to your inventory")
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: { showingAddNote = true }) {
                HStack(spacing: 10) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                    Text("New Note")
                        .font(.playfairDisplay(18, weight: .semibold))
                }
                .foregroundColor(AppColors.primaryText)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
                .background(AppColors.orangeGradient)
                .cornerRadius(25)
                .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 5)
            }
            
            Spacer()
        }
    }
    
    private var notesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.notes) { note in
                    NoteCard(note: note) {
                        selectedNote = note
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 20)
        }
    }
}

struct NoteCard: View {
    let note: Note
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(formatDate(note.dateCreated))
                        .font(.playfairDisplay(14, weight: .medium))
                        .foregroundColor(AppColors.accentText)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText)
                }
                
                Text(note.preview)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(AppColors.primaryText)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
            .padding(16)
            .background(AppColors.cardGradient)
            .cornerRadius(15)
            .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct AddNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var content = ""
    @FocusState private var isTextFieldFocused: Bool
    
    let onSave: (Note) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    TextField("Write your note here...", text: $content, axis: .vertical)
                        .font(.playfairDisplay(16, weight: .regular))
                        .foregroundColor(AppColors.primaryText)
                        .padding(16)
                        .background(AppColors.cardGradient)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(AppColors.borderColor, lineWidth: 1)
                        )
                        .focused($isTextFieldFocused)
                    
                    Button(action: saveNote) {
                        Text("Save")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(AppColors.primaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(isFormValid ? AnyShapeStyle(AppColors.buttonGradient) : AnyShapeStyle(AppColors.borderColor))
                            .cornerRadius(25)
                            .shadow(color: AppColors.shadowColor, radius: isFormValid ? 10 : 0, x: 0, y: isFormValid ? 5 : 0)
                    }
                    .disabled(!isFormValid)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accentText)
                }
            }
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }
    
    private var isFormValid: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func saveNote() {
        let note = Note(content: content.trimmingCharacters(in: .whitespacesAndNewlines))
        onSave(note)
        dismiss()
    }
}

struct NoteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    
    let note: Note
    let onDelete: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(formatDate(note.dateCreated))
                            .font(.playfairDisplay(16, weight: .medium))
                            .foregroundColor(AppColors.accentText)
                        
                        Text(note.content)
                            .font(.playfairDisplay(16, weight: .regular))
                            .foregroundColor(AppColors.primaryText)
                            .lineLimit(nil)
                        
                        Spacer(minLength: 50)
                        
                        Button(action: { showingDeleteAlert = true }) {
                            HStack(spacing: 10) {
                                Image(systemName: "trash")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Delete Note")
                                    .font(.playfairDisplay(18, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.brokenStatus, AppColors.brokenStatus.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                            .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Note")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.accentText)
                }
            }
        }
        .alert("Delete Note?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                onDelete()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
