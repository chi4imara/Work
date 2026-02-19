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
    
    func updateTool(_ updatedTool: Tool) {
        if let index = tools.firstIndex(where: { $0.id == updatedTool.id }) {
            tools[index] = updatedTool
            saveTools()
        }
    }
    
    func deleteTool(withId id: UUID) {
        tools.removeAll { $0.id == id }
        saveTools()
    }
    
    func addUsageDate(to toolId: UUID, date: Date) {
        if let index = tools.firstIndex(where: { $0.id == toolId }) {
            tools[index].addUsageDate(date)
            saveTools()
        }
    }
    
    func removeUsageDate(from toolId: UUID, usageDateId: UUID) {
        if let index = tools.firstIndex(where: { $0.id == toolId }) {
            tools[index].removeUsageDate(withId: usageDateId)
            saveTools()
        }
    }
    
    func getToolsWithUsage() -> [Tool] {
        return tools.filter { !$0.usageDates.isEmpty }
            .sorted { $0.usageCount > $1.usageCount }
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
}
