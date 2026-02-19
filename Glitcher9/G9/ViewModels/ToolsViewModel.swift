import Foundation
import SwiftUI
import Combine

class ToolsViewModel: ObservableObject {
    @Published var tools: [Tool] = []
    @Published var selectedTool: Tool?
    
    private let userDefaults = UserDefaults.standard
    private let toolsKey = "SavedTools"
    
    init() {
        loadTools()
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
        
    var toolTypes: [ToolType] {
        let groupedTools = Dictionary(grouping: tools) { $0.type }
        return groupedTools.map { ToolType(name: $0.key, tools: $0.value) }
            .sorted { $0.name < $1.name }
    }
    
    func tools(for type: String) -> [Tool] {
        tools.filter { $0.type == type }
    }
        
    private func saveTools() {
        if let encoded = try? JSONEncoder().encode(tools) {
            userDefaults.set(encoded, forKey: toolsKey)
        }
    }
    
    private func loadTools() {
        if let data = userDefaults.data(forKey: toolsKey),
           let decodedTools = try? JSONDecoder().decode([Tool].self, from: data) {
            tools = decodedTools
        }
    }
        
    var isEmpty: Bool {
        tools.isEmpty
    }
    
    var totalToolsCount: Int {
        tools.count
    }
    
    func searchTools(query: String) -> [Tool] {
        if query.isEmpty {
            return tools
        }
        return tools.filter { tool in
            tool.name.localizedCaseInsensitiveContains(query) ||
            tool.type.localizedCaseInsensitiveContains(query) ||
            tool.condition.localizedCaseInsensitiveContains(query)
        }
    }
}
