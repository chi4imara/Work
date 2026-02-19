import Foundation
import SwiftUI
import Combine

class ToolsViewModel: ObservableObject {
    @Published var tools: [Tool] = []
    @Published var usages: [Usage] = []
    @Published var searchText = ""
    @Published var selectedCategory: ToolCategory? = nil
    
    private let toolsKey = "SavedTools"
    private let usagesKey = "SavedUsages"
    
    init() {
        loadData()
    }
    
    var filteredTools: [Tool] {
        var filtered = tools
        
        if !searchText.isEmpty {
            filtered = filtered.filter { tool in
                tool.name.localizedCaseInsensitiveContains(searchText) ||
                tool.storageLocation.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        return filtered.sorted { $0.name < $1.name }
    }
    
    var statistics: StatisticsData {
        return StatisticsData(tools: tools, usages: usages)
    }
    
    var groupedUsages: [Date: [Usage]] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: usages.sorted { $0.date > $1.date }) { usage in
            calendar.startOfDay(for: usage.date)
        }
        return grouped
    }
    
    func addTool(_ tool: Tool) {
        tools.append(tool)
        saveData()
    }
    
    func updateTool(_ tool: Tool) {
        if let index = tools.firstIndex(where: { $0.id == tool.id }) {
            tools[index] = tool
            saveData()
        }
    }
    
    func deleteTool(_ tool: Tool) {
        tools.removeAll { $0.id == tool.id }
        usages.removeAll { $0.toolId == tool.id }
        saveData()
    }
    
    func markToolAsUsedToday(_ tool: Tool) {
        var updatedTool = tool
        updatedTool.lastUsedDate = Date()
        updateTool(updatedTool)
        
        let usage = Usage(toolId: tool.id, toolName: tool.name)
        usages.append(usage)
        saveData()
    }
    
    func getUsageCount(for period: StatisticsPeriod) -> [Date: Int] {
        let calendar = Calendar.current
        let now = Date()
        
        let startDate: Date
        switch period {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        case .all:
            startDate = usages.min(by: { $0.date < $1.date })?.date ?? now
        }
        
        let filteredUsages = usages.filter { $0.date >= startDate }
        let grouped = Dictionary(grouping: filteredUsages) { usage in
            calendar.startOfDay(for: usage.date)
        }
        
        return grouped.mapValues { $0.count }
    }
    
    private func saveData() {
        if let toolsData = try? JSONEncoder().encode(tools) {
            UserDefaults.standard.set(toolsData, forKey: toolsKey)
        }
        
        if let usagesData = try? JSONEncoder().encode(usages) {
            UserDefaults.standard.set(usagesData, forKey: usagesKey)
        }
    }
    
    private func loadData() {
        if let toolsData = UserDefaults.standard.data(forKey: toolsKey),
           let decodedTools = try? JSONDecoder().decode([Tool].self, from: toolsData) {
            self.tools = decodedTools
        }
        
        if let usagesData = UserDefaults.standard.data(forKey: usagesKey),
           let decodedUsages = try? JSONDecoder().decode([Usage].self, from: usagesData) {
            self.usages = decodedUsages
        }
    }
}

enum StatisticsPeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case all = "All"
}
