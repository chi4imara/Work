import Foundation
import SwiftUI

enum CollectionSortOption: String, CaseIterable {
    case alphabetical = "Alphabetical"
    case itemCount = "Item Count"
    case dateCreated = "Date Created"
}

enum ItemSortOption: String, CaseIterable {
    case alphabetical = "Alphabetical"
    case dateAdded = "Date Added"
    case status = "Status"
}

enum FavoriteSortOption: String, CaseIterable {
    case collection = "By Collection"
    case dateAdded = "Date Added"
    case alphabetical = "Alphabetical"
}

class CollectionStore: ObservableObject {
    @Published var collections: [Collection] = []
    @Published var collectionSortOption: CollectionSortOption = .alphabetical
    @Published var itemSortOption: ItemSortOption = .alphabetical
    @Published var favoriteSortOption: FavoriteSortOption = .dateAdded
    @Published var showToast = false
    @Published var toastMessage = ""
    @Published var selectedItem: Item?
    
    
    
    private let userDefaults = UserDefaults.standard
    private let collectionsKey = "SavedCollections"
    
    init() {
        loadCollections()
    }
    
    func addCollection(_ collection: Collection) {
        collections.append(collection)
        saveCollections()
        showToast(message: "Collection created")
    }
    
    func updateCollection(_ collection: Collection) {
        if let index = collections.firstIndex(where: { $0.id == collection.id }) {
            collections[index] = collection
            saveCollections()
            showToast(message: "Collection updated")
        }
    }
    
    func deleteCollection(_ collection: Collection) {
        collections.removeAll { $0.id == collection.id }
        saveCollections()
        showToast(message: "Collection deleted")
    }
    
    func getCollection(by id: UUID) -> Collection? {
        return collections.first { $0.id == id }
    }
    
    func addItem(_ item: Item, to collectionId: UUID) {
        if let index = collections.firstIndex(where: { $0.id == collectionId }) {
            collections[index].items.append(item)
            saveCollections()
            showToast(message: "Item added")
        }
    }
    
    func updateItem(_ item: Item, in collectionId: UUID) {
        if let collectionIndex = collections.firstIndex(where: { $0.id == collectionId }),
           let itemIndex = collections[collectionIndex].items.firstIndex(where: { $0.id == item.id }) {
            collections[collectionIndex].items[itemIndex] = item
            saveCollections()
            showToast(message: "Item updated")
        }
    }
    
    func deleteItem(_ item: Item, from collectionId: UUID) {
        if let collectionIndex = collections.firstIndex(where: { $0.id == collectionId }) {
            collections[collectionIndex].items.removeAll { $0.id == item.id }
            saveCollections()
            showToast(message: "Item deleted")
        }
    }
    
    func toggleItemFavorite(_ item: Item, in collectionId: UUID) {
        if let collectionIndex = collections.firstIndex(where: { $0.id == collectionId }),
           let itemIndex = collections[collectionIndex].items.firstIndex(where: { $0.id == item.id }) {
            collections[collectionIndex].items[itemIndex].isFavorite.toggle()
            saveCollections()
            let message = collections[collectionIndex].items[itemIndex].isFavorite ? "Added to favorites" : "Removed from favorites"
            showToast(message: message)
        }
    }
    
    var sortedCollections: [Collection] {
        switch collectionSortOption {
        case .alphabetical:
            return collections.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .itemCount:
            return collections.sorted { $0.itemCount > $1.itemCount }
        case .dateCreated:
            return collections.sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    func sortedItems(for collection: Collection) -> [Item] {
        switch itemSortOption {
        case .alphabetical:
            return collection.items.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .dateAdded:
            return collection.items.sorted { $0.addedAt > $1.addedAt }
        case .status:
            return collection.items.sorted { $0.status.rawValue < $1.status.rawValue }
        }
    }
    
    var favoriteItems: [Item] {
        let allFavorites = collections.flatMap { collection in
            collection.items.filter { $0.isFavorite }.map { item in
                var itemWithCollection = item
                return itemWithCollection
            }
        }
        
        switch favoriteSortOption {
        case .collection:
            return allFavorites.sorted { item1, item2 in
                let collection1 = getCollectionName(for: item1)
                let collection2 = getCollectionName(for: item2)
                return collection1.localizedCaseInsensitiveCompare(collection2) == .orderedAscending
            }
        case .dateAdded:
            return allFavorites.sorted { $0.addedAt > $1.addedAt }
        case .alphabetical:
            return allFavorites.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }
    
    func getCollectionName(for item: Item) -> String {
        for collection in collections {
            if collection.items.contains(where: { $0.id == item.id }) {
                return collection.name
            }
        }
        return ""
    }
    
    func getCollectionId(for item: Item) -> UUID? {
        for collection in collections {
            if collection.items.contains(where: { $0.id == item.id }) {
                return collection.id
            }
        }
        return nil
    }
    
    func clearFavorites() {
        for collectionIndex in collections.indices {
            for itemIndex in collections[collectionIndex].items.indices {
                collections[collectionIndex].items[itemIndex].isFavorite = false
            }
        }
        saveCollections()
        showToast(message: "Favorites cleared")
    }
    
    private func saveCollections() {
        if let encoded = try? JSONEncoder().encode(collections) {
            userDefaults.set(encoded, forKey: collectionsKey)
        }
    }
    
    private func loadCollections() {
        if let data = userDefaults.data(forKey: collectionsKey),
           let decoded = try? JSONDecoder().decode([Collection].self, from: data) {
            collections = decoded
        }
    }
    
    private func showToast(message: String) {
        toastMessage = message
        showToast = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showToast = false
        }
    }
}
