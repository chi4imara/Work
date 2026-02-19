import Foundation
import SwiftUI
import Combine

class ToolViewModel: ObservableObject {
    @Published var tools: [Tool] = []
    @Published var searchText: String = ""
    @Published var selectedSortOption: SortOption = .alphabetical
    @Published var showingAddTool = false
    @Published var selectedToolId: UUID?
    
    func getTool(by id: UUID) -> Tool? {
        tools.first { $0.id == id }
    }
    
    var filteredTools: [Tool] {
        let filtered = searchText.isEmpty ? tools : tools.filter { tool in
            tool.name.localizedCaseInsensitiveContains(searchText) ||
            tool.type.rawValue.localizedCaseInsensitiveContains(searchText) ||
            tool.size.localizedCaseInsensitiveContains(searchText) ||
            tool.brand.localizedCaseInsensitiveContains(searchText) ||
            tool.storageLocation.localizedCaseInsensitiveContains(searchText)
        }
        
        return sortedTools(filtered)
    }
    
    var toolsByType: [ToolType: [Tool]] {
        Dictionary(grouping: tools) { $0.type }
    }
    
    var toolsByStorageLocation: [String: [Tool]] {
        let nonEmptyStorageTools = tools.filter { !$0.storageLocation.isEmpty }
        return Dictionary(grouping: nonEmptyStorageTools) { $0.storageLocation }
    }
    
    var toolTypes: [(type: ToolType, count: Int)] {
        toolsByType.map { (type: $0.key, count: $0.value.count) }
            .sorted { $0.type.rawValue < $1.type.rawValue }
    }
    
    var storageLocations: [(location: String, count: Int)] {
        toolsByStorageLocation.map { (location: $0.key, count: $0.value.count) }
            .sorted { $0.location < $1.location }
    }
    
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
    
    func toolsOfType(_ type: ToolType) -> [Tool] {
        tools.filter { $0.type == type }
    }
    
    func toolsInStorageLocation(_ location: String) -> [Tool] {
        tools.filter { $0.storageLocation == location }
    }
    
    private func sortedTools(_ tools: [Tool]) -> [Tool] {
        switch selectedSortOption {
        case .alphabetical:
            return tools.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .type:
            return tools.sorted { $0.type.rawValue.localizedCaseInsensitiveCompare($1.type.rawValue) == .orderedAscending }
        case .brand:
            return tools.sorted { $0.brand.localizedCaseInsensitiveCompare($1.brand) == .orderedAscending }
        case .size:
            return tools.sorted { $0.size.localizedCaseInsensitiveCompare($1.size) == .orderedAscending }
        }
    }
    
    private func saveTools() {
        if let encoded = try? JSONEncoder().encode(tools) {
            UserDefaults.standard.set(encoded, forKey: "SavedTools")
        }
    }
    
    private func loadTools() {
        if let data = UserDefaults.standard.data(forKey: "SavedTools"),
           let decodedTools = try? JSONDecoder().decode([Tool].self, from: data) {
            self.tools = decodedTools
        }
    }
    
    func loadSampleData() {
        let sampleTools = [
            Tool(name: "Adjustable Wrench 10\"", type: .wrench, size: "10 inches", brand: "Stanley", storageLocation: "Garage Toolbox", description: "Heavy-duty adjustable wrench for general use"),
            Tool(name: "Phillips Screwdriver", type: .screwdriver, size: "PH2", brand: "Klein Tools", storageLocation: "Home Workshop", description: "Professional grade screwdriver"),
            Tool(name: "Claw Hammer", type: .hammer, size: "16 oz", brand: "Estwing", storageLocation: "Garage Toolbox", description: "Classic claw hammer with steel handle"),
            Tool(name: "Cordless Drill", type: .powerTool, size: "18V", brand: "DeWalt", storageLocation: "Charging Station", description: "Lithium-ion cordless drill with LED light"),
            Tool(name: "Needle Nose Pliers", type: .pliers, size: "6 inches", brand: "Knipex", storageLocation: "Tool Case", description: "Precision pliers for detailed work")
        ]
        
        tools = sampleTools
        saveTools()
    }
}
