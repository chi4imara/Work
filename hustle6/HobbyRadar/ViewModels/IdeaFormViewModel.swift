import Foundation
import Combine

class IdeaFormViewModel: ObservableObject {
    @Published var title = ""
    @Published var selectedCategory: Category?
    @Published var description = ""
    @Published var source = ""
    @Published var showingCategoryCreation = false
    @Published var newCategoryName = ""
    @Published var errorMessage = ""
    @Published var hasUnsavedChanges = false
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    private let originalIdea: Idea?
    
    var isEditing: Bool {
        return originalIdea != nil
    }
    
    var availableCategories: [Category] {
        return dataManager.categories
    }
    
    var canSave: Bool {
        return !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               selectedCategory != nil &&
               description.count <= 300
    }
    
    init(idea: Idea? = nil) {
        self.originalIdea = idea
        
        if let idea = idea {
            self.title = idea.title
            self.selectedCategory = idea.category
            self.description = idea.description ?? ""
            self.source = idea.source ?? ""
        } else {
            self.selectedCategory = dataManager.categories.first
        }
        
        setupBindings()
    }
    
    private func setupBindings() {
        Publishers.CombineLatest4(
            $title,
            $description,
            $source,
            $selectedCategory
        )
        .dropFirst() 
        .sink { [weak self] _, _, _, _ in
            self?.checkForUnsavedChanges()
        }
        .store(in: &cancellables)
    }
    
    private func checkForUnsavedChanges() {
        if let original = originalIdea {
            hasUnsavedChanges = title != original.title ||
                              description != (original.description ?? "") ||
                              source != (original.source ?? "") ||
                              selectedCategory?.name != original.category.name
        } else {
            hasUnsavedChanges = !title.isEmpty || 
                              !description.isEmpty || 
                              !source.isEmpty
        }
    }
    
    func validateTitle() -> Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTitle.isEmpty {
            errorMessage = "Please enter an idea title"
            return false
        }
        errorMessage = ""
        return true
    }
    
    func createNewCategory() -> Bool {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            errorMessage = "Category name cannot be empty"
            return false
        }
        
        if dataManager.categoryExists(name: trimmedName) {
            errorMessage = "A category with this name already exists"
            return false
        }
        
        let newCategory = Category(name: trimmedName, isSystem: false)
        dataManager.addCategory(newCategory)
        selectedCategory = newCategory
        newCategoryName = ""
        errorMessage = ""
        showingCategoryCreation = false
        
        return true
    }
    
    func saveIdea() -> Bool {
        guard validateTitle(),
              let category = selectedCategory else {
            return false
        }
        
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedSource = source.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let originalIdea = originalIdea {
            let updatedIdea = Idea(
                id: originalIdea.id,
                title: trimmedTitle,
                category: category,
                description: trimmedDescription.isEmpty ? nil : trimmedDescription,
                source: trimmedSource.isEmpty ? nil : trimmedSource,
                dateAdded: originalIdea.dateAdded,
                isSystem: originalIdea.isSystem
            )
            
            dataManager.updateIdea(updatedIdea)
        } else {
            let newIdea = Idea(
                title: trimmedTitle,
                category: category,
                description: trimmedDescription.isEmpty ? nil : trimmedDescription,
                source: trimmedSource.isEmpty ? nil : trimmedSource,
                isSystem: false
            )
            
            dataManager.addIdea(newIdea)
        }
        
        hasUnsavedChanges = false
        return true
    }
    
    func deleteIdea() -> Bool {
        guard let idea = originalIdea else { return false }
        dataManager.deleteIdea(withId: idea.id)
        return true
    }
    
    func resetForm() {
        title = ""
        description = ""
        source = ""
        selectedCategory = dataManager.categories.first
        errorMessage = ""
        hasUnsavedChanges = false
    }
    
    func checkForDuplicateTitle() -> Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let original = originalIdea, original.title == trimmedTitle {
            return false
        }
        
        return dataManager.ideas.contains { $0.title.lowercased() == trimmedTitle.lowercased() }
    }
}
