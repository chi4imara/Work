import SwiftUI

struct AddEditIdeaView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: MakeupIdeaViewModel
    
    let ideaToEdit: MakeupIdea?
    let onSave: (MakeupIdea) -> Void
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedTag: MakeupTag = .daily
    @State private var comment = ""
    @State private var showingValidationAlert = false
    
    private var isEditing: Bool {
        ideaToEdit != nil
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundGradient()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Idea Name")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            TextField("Enter idea name", text: $title)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.primaryText)
                                .padding(16)
                                .background(CardBackground())
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            TextEditor(text: $description)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.primaryText)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 100)
                                .padding(16)
                                .background(CardBackground())
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            VStack(spacing: 12) {
                                ForEach(MakeupTag.allCases, id: \.self) { tag in
                                    TagSelectionRow(
                                        tag: tag,
                                        isSelected: selectedTag == tag
                                    ) {
                                        selectedTag = tag
                                    }
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Comment (Optional)")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primaryText)
                            
                            TextEditor(text: $comment)
                                .font(AppFonts.body)
                                .foregroundColor(AppColors.primaryText)
                                .scrollContentBackground(.hidden)
                                .frame(minHeight: 80)
                                .padding(16)
                                .background(CardBackground())
                                .cornerRadius(12)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Idea" : "New Idea")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .font(AppFonts.body)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Save Changes" : "Save") {
                        saveIdea()
                    }
                    .foregroundColor(AppColors.primaryYellow)
                    .font(AppFonts.headline)
                }
            }
            .toolbarBackground(AppColors.cardBackground, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .onAppear {
            loadIdeaData()
        }
        .alert("Validation Error", isPresented: $showingValidationAlert) {
            Button("OK") { }
        } message: {
            Text("Please provide at least an idea name to save.")
        }
    }
    
    private func loadIdeaData() {
        if let idea = ideaToEdit {
            title = idea.title
            description = idea.description
            selectedTag = idea.tag
            comment = idea.comment
        }
    }
    
    private func saveIdea() {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showingValidationAlert = true
            return
        }
        
        let idea: MakeupIdea
        
        if let existingIdea = ideaToEdit {
            idea = MakeupIdea(
                id: existingIdea.id,
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                tag: selectedTag,
                comment: comment.trimmingCharacters(in: .whitespacesAndNewlines),
                dateCreated: existingIdea.dateCreated
            )
        } else {
            idea = MakeupIdea(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                tag: selectedTag,
                comment: comment.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        }
        
        onSave(idea)
        dismiss()
    }
}

struct TagSelectionRow: View {
    let tag: MakeupTag
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: tag.icon)
                    .font(.system(size: 20))
                    .foregroundColor(AppColors.primaryYellow)
                    .frame(width: 24)
                
                Text(tag.displayName)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppColors.primaryYellow : AppColors.secondaryText)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppColors.primaryYellow.opacity(0.1) : AppColors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? AppColors.primaryYellow.opacity(0.3) : Color.clear, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct IdeaDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    let idea: MakeupIdea
    let onUpdate: (MakeupIdea) -> Void
    let onDelete: (MakeupIdea) -> Void
    let onEdit: (MakeupIdea) -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundGradient()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text(idea.title)
                                    .font(AppFonts.title)
                                    .foregroundColor(AppColors.primaryText)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Image(systemName: idea.tag.icon)
                                        .font(.system(size: 20))
                                        .foregroundColor(AppColors.primaryYellow)
                                    
                                    Text(idea.tag.displayName)
                                        .font(AppFonts.caption)
                                        .foregroundColor(AppColors.accentText)
                                }
                            }
                            
                            Divider()
                                .background(Color.white.opacity(0.3))
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Description")
                                    .font(AppFonts.headline)
                                    .foregroundColor(AppColors.primaryText)
                                
                                Text(idea.description.isEmpty ? "No description provided" : idea.description)
                                    .font(AppFonts.body)
                                    .foregroundColor(idea.description.isEmpty ? AppColors.secondaryText : AppColors.primaryText)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            if !idea.comment.isEmpty {
                                Divider()
                                    .background(Color.white.opacity(0.3))
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Comment")
                                        .font(AppFonts.headline)
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Text(idea.comment)
                                        .font(AppFonts.body)
                                        .foregroundColor(AppColors.primaryText)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            
                            Divider()
                                .background(Color.white.opacity(0.3))
                            
                            Text("Created: \(idea.dateCreated.formatted(date: .abbreviated, time: .shortened))")
                                .font(AppFonts.caption)
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(20)
                        .background(CardBackground())
                        .cornerRadius(16)
                        
                        VStack(spacing: 16) {
                            Button(action: {
                                onEdit(idea)
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Edit Idea")
                                        .font(AppFonts.headline)
                                }
                                .foregroundColor(AppColors.buttonText)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.buttonBackground)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Delete Idea")
                                        .font(AppFonts.headline)
                                }
                                .foregroundColor(Color.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(AppColors.errorRed)
                                .cornerRadius(12)
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Idea Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryText)
                    .font(AppFonts.body)
                }
            }
            .toolbarBackground(AppColors.cardBackground, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .alert("Delete Idea", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete(idea)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this makeup idea? This action cannot be undone.")
        }
    }
}
