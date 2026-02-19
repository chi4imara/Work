import SwiftUI

struct NotesView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @State private var showingAddNote = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.primaryBackground
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
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView()
                .environmentObject(viewModel)
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Notes")
                .font(.ubuntu(28, weight: .bold))
                .foregroundColor(ColorTheme.primaryText)
            
            Spacer()
            
            Button(action: {
                showingAddNote = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                    .frame(width: 40, height: 40)
                    .background(ColorTheme.primaryButton)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "note.text")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorTheme.secondaryText)
            
            Text("No notes. Create your first one")
                .font(.ubuntu(18, weight: .medium))
                .foregroundColor(ColorTheme.secondaryText)
            
            Button(action: {
                showingAddNote = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("New Note")
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorTheme.primaryText)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(ColorTheme.primaryButton)
                .cornerRadius(25)
            }
            
            Spacer()
        }
    }
    
    private var notesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.notes) { note in
                    NavigationLink(destination: NoteDetailView(note: note).environmentObject(viewModel)) {
                        NoteCardView(note: note)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 20)
        }
    }
}

struct NoteCardView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(note.title.isEmpty ? "Untitled" : note.title)
                    .font(.ubuntu(18, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                    .lineLimit(1)
                
                Spacer()
                
                Text(formattedDate(note.createdDate))
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            if !note.content.isEmpty {
                Text(note.preview)
                    .font(.ubuntu(14, weight: .regular))
                    .foregroundColor(ColorTheme.secondaryText)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(12)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct AddNoteView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorTheme.primaryBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        TextField("Enter note title", text: $title)
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(12)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Content")
                            .font(.ubuntu(16, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        TextField("Write your note here...", text: $content, axis: .vertical)
                            .font(.ubuntu(16, weight: .regular))
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(12)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(8)
                            .lineLimit(10...20)
                    }
                    
                    Spacer()
                }
                .padding(20)
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(ColorTheme.secondaryText),
                
                trailing: Button("Save") {
                    saveNote()
                }
                .foregroundColor(ColorTheme.primaryButton)
                .disabled(content.isEmpty)
            )
        }
        .accentColor(ColorTheme.primaryButton)
    }
    
    private func saveNote() {
        let newNote = Note(title: title, content: content)
        viewModel.addNote(newNote)
        presentationMode.wrappedValue.dismiss()
    }
}

struct NoteDetailView: View {
    @EnvironmentObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let note: Note
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ZStack {
            ColorTheme.primaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(note.title.isEmpty ? "Untitled" : note.title)
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(ColorTheme.primaryText)
                        
                        Text("Created: \(formattedDate(note.createdDate))")
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                    
                    Text(note.content)
                        .font(.ubuntu(16, weight: .regular))
                        .foregroundColor(ColorTheme.primaryText)
                        .lineSpacing(4)
                    
                    Spacer(minLength: 20)
                    
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete Note")
                        }
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(ColorTheme.destructiveButton)
                        .cornerRadius(25)
                    }
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(ColorTheme.primaryButton)
            }
        )
        .alert("Delete Note?", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.deleteNote(note)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    NotesView()
        .environmentObject(NotesViewModel())
}
