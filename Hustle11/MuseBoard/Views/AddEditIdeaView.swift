import SwiftUI

struct AddEditIdeaView: View {
    @EnvironmentObject var ideaStore: IdeaStore
    @Environment(\.presentationMode) var presentationMode
    
    let ideaToEdit: Idea?
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedCategory: Category = .other
    @State private var selectedTags: [Tag] = []
    @State private var notes = ""
    @State private var newTagName = ""
    @State private var showingNewTagField = false
    
    init(ideaToEdit: Idea? = nil) {
        self.ideaToEdit = ideaToEdit
    }
    
    var isEditing: Bool {
        ideaToEdit != nil
    }
    
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
            ZStack {
                AnimatedBackground()
                VStack {
                    HStack {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                        .font(.nunito(.medium, size: 16))
                        .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Text(isEditing ? "Edit Idea" : "New Idea")
                            .font(.nunito(.bold, size: 17))
                            .foregroundColor(AppColors.primaryText)
                        
                        Spacer()
                        
                        Button("Save") {
                            saveIdea()
                        }
                        .font(.nunito(.semiBold, size: 16))
                        .foregroundColor(isValid ? AppColors.primaryText : AppColors.primaryText.opacity(0.5))
                        .disabled(!isValid)
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 12)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Title")
                                    .font(.nunito(.semiBold, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                
                                TextField("Enter your idea title...", text: $title)
                                    .font(.nunito(.regular, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(AppColors.elementBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.elementBorder, lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.nunito(.semiBold, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                
                                TextEditor(text: $description)
                                    .font(.nunito(.regular, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: 100)
                                    .background(AppColors.elementBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.elementBorder, lineWidth: 1)
                                    )
                                    .scrollContentBackground(.hidden)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Category")
                                    .font(.nunito(.semiBold, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(Category.allCases, id: \.self) { category in
                                            CategoryButton(
                                                category: category,
                                                isSelected: selectedCategory == category,
                                                action: { selectedCategory = category }
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 1)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Tags")
                                        .font(.nunito(.semiBold, size: 16))
                                        .foregroundColor(AppColors.primaryText)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        showingNewTagField.toggle()
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(AppColors.primaryText)
                                    }
                                }
                                
                                if showingNewTagField {
                                    HStack {
                                        TextField("New tag name...", text: $newTagName)
                                            .font(.nunito(.regular, size: 14))
                                            .foregroundColor(AppColors.primaryText)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(AppColors.elementBackground)
                                            .cornerRadius(8)
                                        
                                        Button("Add") {
                                            addNewTag()
                                        }
                                        .font(.nunito(.semiBold, size: 14))
                                        .foregroundColor(AppColors.primaryBlue)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .disabled(newTagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                    }
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                }
                                
                                if !ideaStore.tags.isEmpty {
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                        ForEach(ideaStore.tags, id: \.id) { tag in
                                            TagButton(
                                                tag: tag,
                                                isSelected: selectedTags.contains(where: { $0.id == tag.id }),
                                                action: { toggleTag(tag) }
                                            )
                                        }
                                    }
                                }
                                
                                if !selectedTags.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Selected Tags")
                                            .font(.nunito(.medium, size: 14))
                                            .foregroundColor(AppColors.secondaryText)
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 8) {
                                                ForEach(selectedTags, id: \.id) { tag in
                                                    HStack(spacing: 4) {
                                                        Text(tag.name)
                                                            .font(.nunito(.medium, size: 12))
                                                            .foregroundColor(AppColors.primaryText)
                                                        
                                                        Button(action: { removeTag(tag) }) {
                                                            Image(systemName: "xmark")
                                                                .font(.system(size: 10, weight: .medium))
                                                                .foregroundColor(AppColors.primaryText)
                                                        }
                                                    }
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .fill(Color(hex: tag.color).opacity(0.3))
                                                    )
                                                }
                                            }
                                            .padding(.horizontal, 1)
                                        }
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes (Optional)")
                                    .font(.nunito(.semiBold, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                
                                TextEditor(text: $notes)
                                    .font(.nunito(.regular, size: 16))
                                    .foregroundColor(AppColors.primaryText)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: 80)
                                    .background(AppColors.elementBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(AppColors.elementBorder, lineWidth: 1)
                                    )
                                    .scrollContentBackground(.hidden)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        .onAppear {
            setupForEditing()
        }
    }
    
    private func setupForEditing() {
        if let idea = ideaToEdit {
            title = idea.title
            description = idea.description
            selectedCategory = idea.category
            selectedTags = idea.tags
            notes = idea.notes
        }
    }
    
    private func addNewTag() {
        let trimmedName = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        
        let newTag = Tag(name: trimmedName, color: AppColors.randomTagColor().toHex())
        ideaStore.addTag(newTag)
        selectedTags.append(newTag)
        newTagName = ""
        showingNewTagField = false
    }
    
    private func toggleTag(_ tag: Tag) {
        if let index = selectedTags.firstIndex(where: { $0.id == tag.id }) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
        }
    }
    
    private func removeTag(_ tag: Tag) {
        selectedTags.removeAll { $0.id == tag.id }
    }
    
    private func saveIdea() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        if let existingIdea = ideaToEdit {
            var updatedIdea = existingIdea
            updatedIdea.title = trimmedTitle
            updatedIdea.description = description
            updatedIdea.category = selectedCategory
            updatedIdea.tags = selectedTags
            updatedIdea.notes = notes
            ideaStore.updateIdea(updatedIdea)
        } else {
            let newIdea = Idea(
                title: trimmedTitle,
                description: description,
                category: selectedCategory,
                tags: selectedTags,
                notes: notes
            )
            ideaStore.addIdea(newIdea)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct CategoryButton: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.iconName)
                    .font(.system(size: 16, weight: .medium))
                
                Text(category.displayName)
                    .font(.nunito(.medium, size: 14))
            }
            .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.primaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.white : AppColors.elementBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? AppColors.primaryBlue : AppColors.elementBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TagButton: View {
    let tag: Tag
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(tag.name)
                    .font(.nunito(.medium, size: 14))
                    .foregroundColor(isSelected ? AppColors.primaryBlue : AppColors.primaryText)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppColors.primaryBlue)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.white : AppColors.elementBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? AppColors.primaryBlue : AppColors.elementBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AddEditIdeaView_Previews: PreviewProvider {
    static var previews: some View {
        AddEditIdeaView()
            .environmentObject(IdeaStore())
    }
}
