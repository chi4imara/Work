import SwiftUI

struct NoteDetailView: View {
    let noteId: UUID
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    
    private var note: Note? {
        viewModel.notes.first(where: { $0.id == noteId })
    }
    
    var body: some View {
        Group {
            if let note = note {
                NavigationView {
                    ZStack {
                        AppColors.backgroundGradient
                            .ignoresSafeArea()
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                headerCard(note: note)
                                
                                contentCard(note: note)
                                
                                actionsSection(note: note)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 30)
                        }
                    }
                    .navigationTitle("Note Details")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(
                        leading: Button("Close") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(AppColors.blueText)
                    )
                }
                .sheet(isPresented: $showingEditView) {
                    AddNoteView(viewModel: viewModel, existingNote: note)
                }
                .alert("Delete Note", isPresented: $showingDeleteAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Delete", role: .destructive) {
                        viewModel.deleteNote(note)
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Are you sure you want to delete this note? This action cannot be undone.")
                }
            }
        }
    }
    
    private func headerCard(note: Note) -> some View {
        VStack(spacing: 16) {
            Text(note.title)
                .font(AppFonts.title)
                .foregroundColor(AppColors.darkGray)
                .multilineTextAlignment(.center)
            
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.blueText)
                
                Text("Created \(DateFormatter.displayFormatter.string(from: note.dateCreated))")
                    .font(AppFonts.callout)
                    .foregroundColor(AppColors.blueText)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(AppColors.cardGradient)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private func contentCard(note: Note) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "text.bubble")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.blueText)
                
                Text("Content")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.darkGray)
                
                Spacer()
            }
            
            if note.content.isEmpty {
                Text("No content added.")
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray.opacity(0.6))
                    .italic()
            } else {
                Text(note.content)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.darkGray)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.8))
        .cornerRadius(16)
    }
    
    private func actionsSection(note: Note) -> some View {
        VStack(spacing: 12) {
            Button(action: {
                showingEditView = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Note")
                }
                .font(AppFonts.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(AppColors.buttonGradient)
                .cornerRadius(25)
                .shadow(color: AppColors.purpleGradientStart.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            Button(action: {
                showingDeleteAlert = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Note")
                }
                .font(AppFonts.headline)
                .foregroundColor(AppColors.warningRed)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.white.opacity(0.8))
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(AppColors.warningRed, lineWidth: 1)
                )
            }
        }
    }
}

#Preview {
    let viewModel = NotesViewModel()
    let note = Note(
        title: "Autumn Aromas",
        content: "Add cinnamon and mandarin candles to the collection. Perfect for creating a warm atmosphere during cold evenings."
    )
    viewModel.addNote(note)
    return NoteDetailView(
        noteId: note.id,
        viewModel: viewModel
    )
}
