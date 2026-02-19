import SwiftUI

struct TagsView: View {
    @ObservedObject var viewModel: OutfitViewModel
    @State private var newTagName = ""
    @State private var editingTag: Tag?
    @State private var editTagName = ""
    @State private var showingDeleteAlert = false
    @State private var tagToDelete: Tag?
    
    var body: some View {
        ZStack {
            ColorManager.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Text("Tags")
                        .font(.playfairDisplay(28, weight: .bold))
                        .foregroundColor(ColorManager.primaryText)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                addTagSection
                
                if viewModel.tags.isEmpty {
                    emptyStateView
                } else {
                    tagsListView
                }
            }
        }
        
        .alert("Delete Tag", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) {
                tagToDelete = nil
            }
            Button("Delete", role: .destructive) {
                if let tag = tagToDelete {
                    viewModel.deleteTag(tag.name)
                }
                tagToDelete = nil
            }
        } message: {
            if let tag = tagToDelete {
                Text("Are you sure you want to delete '\(tag.name)'? This will remove it from all outfits.")
            }
        }
        .alert("Edit Tag", isPresented: .constant(editingTag != nil)) {
            TextField("Tag name", text: $editTagName)
            Button("Cancel", role: .cancel) {
                editingTag = nil
                editTagName = ""
            }
            Button("Save") {
                if let tag = editingTag {
                    viewModel.updateTag(oldName: tag.name, newName: editTagName)
                }
                editingTag = nil
                editTagName = ""
            }
        } message: {
            Text("Enter the new name for this tag")
        }
    }
    
    private var addTagSection: some View {
        VStack(spacing: 16) {
            HStack {
                TextField("Enter new tag name", text: $newTagName)
                    .font(.playfairDisplay(16))
                    .foregroundColor(ColorManager.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(ColorManager.cardBackground)
                    .cornerRadius(12)
                
                Button("Add Tag") {
                    addNewTag()
                }
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(newTagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?
                            AnyShapeStyle(ColorManager.neutralGray) : AnyShapeStyle(ColorManager.purpleGradient))
                .cornerRadius(12)
                .disabled(newTagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            
            if !newTagName.isEmpty {
                Text("Preview: \(newTagName)")
                    .font(.playfairDisplay(14))
                    .foregroundColor(ColorManager.secondaryText)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(ColorManager.accentYellow.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "tag")
                .font(.system(size: 60, weight: .light))
                .foregroundColor(ColorManager.secondaryText)
            
            Text("No Tags Yet")
                .font(.playfairDisplay(24, weight: .semibold))
                .foregroundColor(ColorManager.primaryText)
            
            Text("No tags yet. They will appear automatically after adding your first outfits, or you can create them manually above.")
                .font(.playfairDisplay(16))
                .foregroundColor(ColorManager.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
    
    private var tagsListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.sortedTags, id: \.name) { tag in
                    TagRowView(
                        tag: tag,
                        onEdit: {
                            editingTag = tag
                            editTagName = tag.name
                        },
                        onDelete: {
                            tagToDelete = tag
                            showingDeleteAlert = true
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
        }
    }
    
    private func addNewTag() {
        let trimmedName = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        viewModel.addTag(trimmedName)
        newTagName = ""
    }
}

struct TagRowView: View {
    let tag: Tag
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(tag.name)
                    .font(.playfairDisplay(18, weight: .semibold))
                    .foregroundColor(ColorManager.primaryText)
                
                Text("Used \(tag.usageCount) \(tag.usageCount == 1 ? "time" : "times")")
                    .font(.playfairDisplay(14, weight: .medium))
                    .foregroundColor(ColorManager.secondaryText)
            }
            
            Spacer()
            
            Text("\(tag.usageCount)")
                .font(.playfairDisplay(16, weight: .bold))
                .foregroundColor(ColorManager.accentYellow)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(ColorManager.accentYellow.opacity(0.2))
                .cornerRadius(8)
            
            HStack(spacing: 12) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.primaryText)
                        .padding(8)
                        .background(ColorManager.cardBackground)
                        .cornerRadius(8)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(ColorManager.warningRed)
                        .padding(8)
                        .background(ColorManager.warningRed.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(ColorManager.cardGradient)
        .cornerRadius(16)
        .shadow(color: ColorManager.purpleDark.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    TagsView(viewModel: OutfitViewModel())
}

