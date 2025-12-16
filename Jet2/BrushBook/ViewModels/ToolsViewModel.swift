import Foundation
import SwiftUI
import Combine

class ToolsViewModel: ObservableObject {
    @Published var tools: [Tool] = []
    @Published var searchText = ""
    @Published var selectedCategory: ToolCategory? = nil
    @Published var selectedCondition: ToolCondition? = nil
    
    private let userDefaults = UserDefaults.standard
    private let toolsKey = "SavedTools"
    
    init() {
        loadTools()
    }
    
    var filteredTools: [Tool] {
        var filtered = tools
        
        if !searchText.isEmpty {
            filtered = filtered.filter { tool in
                tool.name.localizedCaseInsensitiveContains(searchText) ||
                tool.category.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if let condition = selectedCondition {
            filtered = filtered.filter { $0.actualCondition == condition }
        }
        
        return filtered
    }
    
    var toolsInGoodCondition: [Tool] {
        tools.filter { $0.actualCondition == .good }
    }
    
    var toolsNeedingReplacement: [Tool] {
        tools.filter { $0.actualCondition == .needsReplacement }
    }
    
    var toolsSortedByDate: [Tool] {
        tools.sorted { $0.purchaseDate < $1.purchaseDate }
    }
    
    func addTool(_ tool: Tool) {
        tools.append(tool)
        saveTools()
    }
    
    func updateTool(_ tool: Tool) {
        if let index = tools.firstIndex(where: { $0.id == tool.id }) {
            tools[index] = tool
            saveTools()
        }
    }
    
    func deleteTool(_ tool: Tool) {
        tools.removeAll { $0.id == tool.id }
        saveTools()
    }
    
    func deleteTool(at indexSet: IndexSet) {
        tools.remove(atOffsets: indexSet)
        saveTools()
    }
    
    private func saveTools() {
        if let encoded = try? JSONEncoder().encode(tools) {
            userDefaults.set(encoded, forKey: toolsKey)
        }
    }
    
    private func loadTools() {
        if let data = userDefaults.data(forKey: toolsKey),
           let decoded = try? JSONDecoder().decode([Tool].self, from: data) {
            tools = decoded
        }
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        selectedCondition = nil
    }
    
    func setFilter(category: ToolCategory?) {
        selectedCategory = category
        selectedCondition = nil
    }
    
    func setFilter(condition: ToolCondition?) {
        selectedCondition = condition
        selectedCategory = nil
    }
}
