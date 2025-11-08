import Foundation
import Combine

class TagViewModel: ObservableObject {
    static let shared = TagViewModel()
    
    @Published var tags: [Tag] = []
    @Published var searchText: String = ""
    @Published var filteredTags: [Tag] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showingAddTagAlert: Bool = false
    @Published var showingEditTagAlert: Bool = false
    @Published var showingDeleteTagAlert: Bool = false
    @Published var newTagName: String = ""
    @Published var editingTag: Tag? = nil
    @Published var tagToDelete: Tag? = nil
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        print("🚀 TagViewModel: Initializing...")
        setupBindings()
        loadTags()
        print("✅ TagViewModel: Initialized with \(tags.count) tags")
    }
    
    private func setupBindings() {
        dataManager.$tags
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tags in
                print("🔄 TagViewModel: Received \(tags.count) tags from DataManager")
                self?.tags = tags
                self?.applySearchFilter()
            }
            .store(in: &cancellables)
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.applySearchFilter()
            }
            .store(in: &cancellables)
    }
    
    func loadTags() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isLoading = false
        }
    }
    
    func addTag() {
        let trimmedName = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print("🏷️ TagViewModel: Attempting to add tag '\(trimmedName)'")
        
        guard !trimmedName.isEmpty else {
            errorMessage = "Tag name cannot be empty"
            print("❌ TagViewModel: Tag name is empty")
            return
        }
        
        guard trimmedName.count <= 24 else {
            errorMessage = "Tag name must be 24 characters or less"
            print("❌ TagViewModel: Tag name too long (\(trimmedName.count) characters)")
            return
        }
        
        if dataManager.addTag(trimmedName) {
            print("✅ TagViewModel: Successfully added tag '\(trimmedName)'")
            newTagName = ""
            showingAddTagAlert = false
            errorMessage = nil
        } else {
            print("❌ TagViewModel: Failed to add tag '\(trimmedName)' - already exists or invalid")
            errorMessage = "Tag already exists or is invalid"
        }
    }
    
    func updateTag() {
        guard let tag = editingTag else { return }
        
        let trimmedName = newTagName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            errorMessage = "Tag name cannot be empty"
            return
        }
        
        guard trimmedName.count <= 24 else {
            errorMessage = "Tag name must be 24 characters or less"
            return
        }
        
        if dataManager.updateTag(tag, newName: trimmedName) {
            newTagName = ""
            editingTag = nil
            showingEditTagAlert = false
            errorMessage = nil
        } else {
            errorMessage = "Tag name already exists or is invalid"
        }
    }
    
    func deleteTag() {
        guard let tag = tagToDelete else { return }
        
        dataManager.deleteTag(tag)
        tagToDelete = nil
        showingDeleteTagAlert = false
    }
    
    func getRecipesWithTag(_ tag: Tag) -> [Recipe] {
        return dataManager.getRecipesWithTag(tag.name)
    }
    
    func getTagUsageCount(_ tag: Tag) -> Int {
        return dataManager.getTagUsageCount(tag.name)
    }
    
    func presentAddTagAlert() {
        newTagName = ""
        errorMessage = nil
        showingAddTagAlert = true
    }
    
    func presentEditTagAlert(for tag: Tag) {
        editingTag = tag
        newTagName = tag.name
        errorMessage = nil
        showingEditTagAlert = true
    }
    
    func presentDeleteTagAlert(for tag: Tag) {
        tagToDelete = tag
        showingDeleteTagAlert = true
    }
    
    func dismissAlerts() {
        showingAddTagAlert = false
        showingEditTagAlert = false
        showingDeleteTagAlert = false
        newTagName = ""
        editingTag = nil
        tagToDelete = nil
        errorMessage = nil
    }
    
    private func applySearchFilter() {
        if searchText.isEmpty {
            filteredTags = tags
        } else {
            let lowercaseSearch = searchText.lowercased()
            filteredTags = tags.filter { tag in
                tag.name.lowercased().contains(lowercaseSearch)
            }
        }
    }
    
    var isEmpty: Bool {
        return filteredTags.isEmpty
    }
    
    var isEmptyState: Bool {
        return tags.isEmpty
    }
    
    var hasSearchResults: Bool {
        return !searchText.isEmpty && !filteredTags.isEmpty
    }
    
    var noSearchResults: Bool {
        return !searchText.isEmpty && filteredTags.isEmpty
    }
}
