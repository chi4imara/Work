import SwiftUI

struct AddEditSectionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GameDetailViewModel
    
    let section: GameSection?
    let gameId: UUID
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var showingDeleteAlert = false
    @State private var showingDiscardAlert = false
    
    private var isEditing: Bool { section != nil }
    private var hasChanges: Bool {
        if let section = section {
            return title != section.title || content != section.content
        } else {
            return !title.isEmpty || !content.isEmpty
        }
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        content.count <= 2000
    }
    
    init(section: GameSection? = nil, gameId: UUID, viewModel: GameDetailViewModel) {
        self.section = section
        self.gameId = gameId
        self.viewModel = viewModel
        
        if let section = section {
            _title = State(initialValue: section.title)
            _content = State(initialValue: section.content)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Section Title *")
                                    .font(AppFonts.bodyMedium)
                                    .foregroundColor(AppColors.primaryText)
                                
                                TextField("e.g., Setup", text: $title)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                                            )
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Rules Content *")
                                        .font(AppFonts.bodyMedium)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Text("\(content.count)/2000")
                                        .font(AppFonts.caption1)
                                        .foregroundColor(content.count > 2000 ? AppColors.error : AppColors.secondaryText)
                                }
                                
                                TextField("Enter the rules for this section...", text: $content, axis: .vertical)
                                    .font(AppFonts.body)
                                    .foregroundColor(AppColors.primaryText)
                                    .lineLimit(8...20)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(AppColors.cardBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(AppColors.cardBorder, lineWidth: 1)
                                            )
                                    )
                            }
                        }
                        
                        if isEditing {
                            Button {
                                showingDeleteAlert = true
                            } label: {
                                Text("Delete Section")
                                    .font(AppFonts.buttonMedium)
                                    .foregroundColor(AppColors.error)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(AppColors.buttonBackground)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(AppColors.error, lineWidth: 1)
                                            )
                                    )
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Section" : "New Section")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if hasChanges {
                            showingDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }
                    .foregroundColor(AppColors.primaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveSection()
                    }
                    .foregroundColor(canSave ? AppColors.accent : AppColors.secondaryText)
                    .disabled(!canSave)
                }
            }
            .alert("Delete Section", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    if let section = section {
                        viewModel.deleteSection(withId: section.id)
                    }
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this section? This action cannot be undone.")
            }
            .alert("Discard Changes", isPresented: $showingDiscardAlert) {
                Button("Save", role: .cancel) {
                    saveSection()
                }
                Button("Don't Save") {
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("You have unsaved changes. What would you like to do?")
            }
        }
    }
    
    private func saveSection() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let section = section,
           let index = viewModel.sections.firstIndex(where: { $0.id == section.id }) {
            var updatedSection = section
            updatedSection.updateTitle(trimmedTitle)
            updatedSection.updateContent(trimmedContent)
            viewModel.updateSection(at: index, with: updatedSection)
        } else {
            let newSection = GameSection(title: trimmedTitle, content: trimmedContent)
            viewModel.addSection(newSection)
        }
        
        dismiss()
    }
}

#Preview {
    AddEditSectionView(
        gameId: UUID(),
        viewModel: GameDetailViewModel(
            game: Game(name: "Test Game", category: .other),
            gamesViewModel: GamesViewModel()
        )
    )
}
