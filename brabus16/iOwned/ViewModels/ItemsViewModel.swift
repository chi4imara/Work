import Foundation
import Combine

class ItemsViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var searchText = ""
    @Published var filteredItems: [Item] = []
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        dataManager.$items
            .assign(to: \.items, on: self)
            .store(in: &cancellables)
        
        Publishers.CombineLatest($items, $searchText)
            .map { items, searchText in
                if searchText.isEmpty {
                    return items
                } else {
                    return self.dataManager.searchItems(query: searchText)
                }
            }
            .assign(to: \.filteredItems, on: self)
            .store(in: &cancellables)
    }
    
    func addItem(name: String, category: ItemCategory, characteristics: String, notes: String) {
        let newItem = Item(name: name, category: category, characteristics: characteristics, notes: notes)
        dataManager.addItem(newItem)
    }
    
    func updateItem(_ item: Item, name: String, category: ItemCategory, characteristics: String, notes: String) {
        var updatedItem = item
        updatedItem.update(name: name, category: category, characteristics: characteristics, notes: notes)
        dataManager.updateItem(updatedItem)
    }
    
    func deleteItem(_ item: Item) {
        dataManager.deleteItem(item)
    }
    
    func deleteItems(at indexSet: IndexSet) {
        dataManager.deleteItem(at: indexSet)
    }
}
