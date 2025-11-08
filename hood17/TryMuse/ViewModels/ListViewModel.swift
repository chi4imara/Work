import Foundation
import SwiftUI
import Combine

class ListViewModel: ObservableObject {
    @Published var lists: [ListModel] = []
    @Published var listItems: [ListItemModel] = []
    
    private let listsKey = "SavedLists"
    private let itemsKey = "SavedListItems"
    
    init() {
        loadData()
    }
    
    func addList(_ list: ListModel) {
        lists.append(list)
        saveData()
    }
    
    func updateList(_ list: ListModel) {
        if let index = lists.firstIndex(where: { $0.id == list.id }) {
            var updatedList = list
            updatedList.updatedAt = Date()
            lists[index] = updatedList
            saveData()
        }
    }
    
    func deleteList(_ list: ListModel) {
        lists.removeAll { $0.id == list.id }
        listItems.removeAll { $0.listId == list.id }
        saveData()
    }
    
    func getList(by id: UUID) -> ListModel? {
        return lists.first { $0.id == id }
    }
    
    func addItem(_ item: ListItemModel) {
        listItems.append(item)
        saveData()
    }
    
    func updateItem(_ item: ListItemModel) {
        if let index = listItems.firstIndex(where: { $0.id == item.id }) {
            var updatedItem = item
            updatedItem.updatedAt = Date()
            listItems[index] = updatedItem
            saveData()
        }
    }
    
    func deleteItem(_ item: ListItemModel) {
        listItems.removeAll { $0.id == item.id }
        saveData()
    }
    
    func toggleItemCompletion(_ item: ListItemModel) {
        if let index = listItems.firstIndex(where: { $0.id == item.id }) {
            listItems[index].isCompleted.toggle()
            listItems[index].updatedAt = Date()
            
            if listItems[index].isCompleted {
                listItems[index].completedAt = Date()
            } else {
                listItems[index].completedAt = nil
            }
            
            saveData()
        }
    }
    
    func getItems(for listId: UUID) -> [ListItemModel] {
        return listItems
            .filter { $0.listId == listId }
            .sorted { first, second in
                if first.isCompleted != second.isCompleted {
                    return !first.isCompleted
                }
                return first.createdAt > second.createdAt
            }
    }
    
    func getCompletedItems() -> [ListItemModel] {
        return listItems
            .filter { $0.isCompleted }
            .sorted { $0.completedAt ?? Date() > $1.completedAt ?? Date() }
    }
    
    func getProgress(for listId: UUID) -> (completed: Int, total: Int) {
        let items = listItems.filter { $0.listId == listId }
        let completed = items.filter { $0.isCompleted }.count
        return (completed: completed, total: items.count)
    }
    
    private func saveData() {
        if let listsData = try? JSONEncoder().encode(lists) {
            UserDefaults.standard.set(listsData, forKey: listsKey)
        }
        
        if let itemsData = try? JSONEncoder().encode(listItems) {
            UserDefaults.standard.set(itemsData, forKey: itemsKey)
        }
    }
    
    private func loadData() {
        if let listsData = UserDefaults.standard.data(forKey: listsKey),
           let decodedLists = try? JSONDecoder().decode([ListModel].self, from: listsData) {
            lists = decodedLists
        }
        
        if let itemsData = UserDefaults.standard.data(forKey: itemsKey),
           let decodedItems = try? JSONDecoder().decode([ListItemModel].self, from: itemsData) {
            listItems = decodedItems
        }
    }
}
