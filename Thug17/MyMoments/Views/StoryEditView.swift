import SwiftUI

struct StoryEditView: View {
    @ObservedObject var viewModel: StoriesViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let story: Story?
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedTags: Set<String> = []
    @State private var newTagText: String = ""
    @State private var showingValidationErrors = false
    
    private let popularTags = Constants.PopularTags.list
    
    private var isEditing: Bool {
        story != nil
    }
    
    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.cardTitle)
                                .foregroundColor(.textPrimary)
                            
                            TextField("Enter title...", text: $title)
                                .font(.bodyText)
                                .padding(12)
                                .background(Color.cardBackground)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(
                                            showingValidationErrors && title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
                                            ? Color.red : Color.borderColor, 
                                            lineWidth: 1
                                        )
                                )
                            
                            if showingValidationErrors && title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text("Please fill in the title")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Story")
                                .font(.cardTitle)
                                .foregroundColor(.textPrimary)
                            
                            ZStack(alignment: .topLeading) {
                                if content.isEmpty {
                                    Text("Write your story...")
                                        .font(.bodyText)
                                        .foregroundColor(.textSecondary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 12)
                                }
                                
                                TextEditor(text: $content)
                                    .font(.bodyText)
                                    .padding(8)
                                    .background(Color.cardBackground)
                                    .cornerRadius(8)
                                    .frame(minHeight: 150)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(
                                                showingValidationErrors && content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
                                                ? Color.red : Color.borderColor, 
                                                lineWidth: 1
                                            )
                                    )
                            }
                            
                            if showingValidationErrors && content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text("Please fill in the story")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Tags")
                                .font(.cardTitle)
                                .foregroundColor(.textPrimary)
                            
                            Text("Popular tags:")
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                                ForEach(popularTags, id: \.self) { tag in
                                    TagView(
                                        tag: tag,
                                        size: .medium,
                                        isSelected: selectedTags.contains(tag)
                                    ) {
                                        toggleTag(tag)
                                    }
                                }
                            }
                            
                            HStack {
                                TextField("Add custom tag...", text: $newTagText)
                                    .font(.bodyText)
                                    .padding(12)
                                    .background(Color.cardBackground)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.borderColor, lineWidth: 1)
                                    )
                                    .onSubmit {
                                        addCustomTag()
                                    }
                                
                                Button("Add") {
                                    addCustomTag()
                                }
                                .font(.buttonText)
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.primaryBlue)
                                .cornerRadius(8)
                                .disabled(newTagText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            }
                            
                            if !selectedTags.isEmpty {
                                Text("Selected tags:")
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                    ForEach(Array(selectedTags), id: \.self) { tag in
                                        EditableTagView(tag: tag) {
                                            selectedTags.remove(tag)
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle(isEditing ? "Edit Story" : "New Story")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.primaryBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveStory()
                    }
                    .foregroundColor(canSave ? .primaryBlue : .textSecondary)
                    .disabled(!canSave)
                }
            }
        }
        .onAppear {
            setupInitialData()
        }
    }
    
    private func setupInitialData() {
        if let story = story {
            title = story.title
            content = story.content
            selectedTags = Set(story.tags)
        }
    }
    
    private func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
    
    private func addCustomTag() {
        let trimmedTag = newTagText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTag.isEmpty && !selectedTags.contains(trimmedTag) {
            selectedTags.insert(trimmedTag)
            newTagText = ""
        }
    }
    
    private func saveStory() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty && !trimmedContent.isEmpty else {
            showingValidationErrors = true
            return
        }
        
        if let existingStory = story {
            var updatedStory = existingStory
            updatedStory.updateContent(
                title: trimmedTitle,
                content: trimmedContent,
                tags: Array(selectedTags)
            )
            viewModel.updateStory(updatedStory)
        } else {
            let newStory = Story(
                title: trimmedTitle,
                content: trimmedContent,
                tags: Array(selectedTags)
            )
            viewModel.addStory(newStory)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    StoryEditView(viewModel: StoriesViewModel(), story: nil)
}
