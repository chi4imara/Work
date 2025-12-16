import SwiftUI

struct NewDreamView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var content = ""
    @State private var selectedTags: Set<String> = []
    @State private var newTagName = ""
    @State private var showingNewTagAlert = false
    @State private var showingTagLengthError = false
    @State private var availableTags: [String] = []
    
    @Binding var selectedTab: TabItem
    
    private let dataManager = DataManager.shared
    private let maxTagLength = 20
    let dreamToEdit: DreamModel?
    
    init(selectedTab: Binding<TabItem>, dreamToEdit: DreamModel? = nil) {
        self._selectedTab = selectedTab
        self.dreamToEdit = dreamToEdit
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                HStack {
                    Text("New Dream")
                        .font(.builderSans(.bold, size: 28))
                        .foregroundColor(Color.app.textPrimary)
                    
                    Spacer()
                    
                    Button("Save") {
                        withAnimation {
                            saveDream()
                            
                            selectedTab = .dreams
                        }
                    }
                    .foregroundColor(isFormValid ? Color.white : Color.white.opacity(0))
                    .disabled(!isFormValid)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dream Title")
                                .font(.builderSans(.semiBold, size: 16))
                                .foregroundColor(Color.app.textPrimary)
                            
                            TextField("Enter dream title...", text: $title)
                                .font(.builderSans(.regular, size: 16))
                                .foregroundColor(Color.app.textPrimary)
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.app.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.app.cardBorder, lineWidth: 1)
                                        )
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dream Description")
                                .font(.builderSans(.semiBold, size: 16))
                                .foregroundColor(Color.app.textPrimary)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.app.cardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.app.cardBorder, lineWidth: 1)
                                    )
                                    .frame(minHeight: 120)
                                
                                if content.isEmpty {
                                    Text("Describe your dream in detail...")
                                        .font(.builderSans(.regular, size: 16))
                                        .foregroundColor(Color.app.textTertiary)
                                        .padding(16)
                                }
                                
                                TextEditor(text: $content)
                                    .font(.builderSans(.regular, size: 16))
                                    .foregroundColor(Color.app.textPrimary)
                                    .padding(12)
                                    .background(Color.clear)
                                    .scrollContentBackground(.hidden)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Tags")
                                    .font(.builderSans(.semiBold, size: 16))
                                    .foregroundColor(Color.app.textPrimary)
                                
                                Spacer()
                                
                                Button(action: {
                                    showingNewTagAlert = true
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(Color.app.primaryPurple)
                                        .font(.system(size: 20))
                                }
                            }
                            
                            if !selectedTags.isEmpty {
                                LazyVGrid(columns: [
                                    GridItem(.adaptive(minimum: 100))
                                ], spacing: 8) {
                                    ForEach(Array(selectedTags), id: \.self) { tag in
                                        TagBadge(text: tag, color: Color.yellow)
                                            .onTapGesture {
                                                selectedTags.remove(tag)
                                            }
                                    }
                                }
                            }
                            
                            if !availableTags.isEmpty {
                                Text("Available Tags")
                                    .font(.builderSans(.medium, size: 14))
                                    .foregroundColor(Color.app.textSecondary)
                                
                                LazyVGrid(columns: [
                                    GridItem(.adaptive(minimum: 100))
                                ], spacing: 8) {
                                    ForEach(availableTags.filter { !selectedTags.contains($0) }, id: \.self) { tag in
                                        TagBadge(text: tag, color: Color.app.textSecondary)
                                            .onTapGesture {
                                                selectedTags.insert(tag)
                                            }
                                    }
                                }
                            }
                        }
                        
                        if let dream = dreamToEdit {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Created: \(dream.createdAt, formatter: dateFormatter)")
                                    .font(.builderSans(.light, size: 12))
                                    .foregroundColor(Color.app.textTertiary)
                                
                                Text("Updated: \(dream.updatedAt, formatter: dateFormatter)")
                                    .font(.builderSans(.light, size: 12))
                                    .foregroundColor(Color.app.textTertiary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            Text("Will be saved with current date and time")
                                .font(.builderSans(.light, size: 12))
                                .foregroundColor(Color.app.textTertiary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(20)
                    .padding(.bottom, 80)
                }
            }
        }
        .alert("Add New Tag", isPresented: $showingNewTagAlert) {
            TextField("Tag name (max \(maxTagLength) chars)", text: $newTagName)
                .onChange(of: newTagName) { newValue in
                    if newValue.count > maxTagLength {
                        newTagName = String(newValue.prefix(maxTagLength))
                        showingTagLengthError = true
                    }
                }
            Button("Add") {
                addNewTag()
            }
            .disabled(newTagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            Button("Cancel", role: .cancel) {
                newTagName = ""
            }
        } message: {
            Text("Enter a name for the new tag (max \(maxTagLength) characters)")
        }
        .alert("Tag Name Too Long", isPresented: $showingTagLengthError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Tag name cannot exceed \(maxTagLength) characters")
        }
        .onAppear {
            loadData()
            fetchAvailableTags()
        }
    }
    
    private func loadData() {
        if let dream = dreamToEdit {
            title = dream.title
            content = dream.content
            selectedTags = Set(dream.tags)
        }
    }
    
    private func fetchAvailableTags() {
        availableTags = dataManager.getTagNames()
    }
    
    private func addNewTag() {
        let trimmedName = newTagName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard !trimmedName.isEmpty else {
            newTagName = ""
            return
        }
        
        guard trimmedName.count <= maxTagLength else {
            showingTagLengthError = true
            return
        }
        
        guard !availableTags.contains(trimmedName) else {
            newTagName = ""
            return
        }
        
        let newTag = TagModel(name: trimmedName)
        if dataManager.addTag(newTag) {
            availableTags.append(trimmedName)
            availableTags.sort()
            selectedTags.insert(trimmedName)
        }
        
        newTagName = ""
    }
    
    private func saveDream() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        let tagsArray = Array(selectedTags)
        
        if let existingDream = dreamToEdit {
            var updatedDream = existingDream
            updatedDream.update(title: trimmedTitle, content: trimmedContent, tags: tagsArray)
            dataManager.updateDream(updatedDream)
        } else {
            let newDream = DreamModel(title: trimmedTitle, content: trimmedContent, tags: tagsArray)
            dataManager.addDream(newDream)
        }
        
        dismiss()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

