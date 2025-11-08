import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var isShowingSplash = true
    @Published var hasCompletedOnboarding = false
    @Published var selectedTab: TabItem = .plants
    
    @Published var plantViewModel = PlantViewModel()
    @Published var taskViewModel = TaskViewModel()
    @Published var instructionViewModel = InstructionViewModel()
    
    private let dataManager = DataManager.shared
    
    init() {
        hasCompletedOnboarding = dataManager.loadOnboardingStatus()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isShowingSplash = false
            }
        }
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        dataManager.saveOnboardingStatus(true)
    }
    
    func selectTab(_ tab: TabItem) {
        selectedTab = tab
    }
    
    var archivedPlants: [Plant] {
        return plantViewModel.plants.filter { $0.isArchived }
    }
    
    var archivedTasks: [Task] {
        return taskViewModel.tasks.filter { $0.isArchived }
    }
    
    var archivedInstructions: [Instruction] {
        return instructionViewModel.instructions.filter { $0.isArchived }
    }
    
    var allFavorites: (plants: [Plant], instructions: [Instruction]) {
        return (
            plants: plantViewModel.plants.filter { $0.isFavorite && !$0.isArchived },
            instructions: instructionViewModel.instructions.filter { $0.isFavorite && !$0.isArchived }
        )
    }
    
    func clearAllData() {
        dataManager.clearAllData()
        plantViewModel = PlantViewModel()
        taskViewModel = TaskViewModel()
        instructionViewModel = InstructionViewModel()
    }
    
    func hasStoredData() -> Bool {
        return dataManager.hasStoredData()
    }
    
    func exportData() -> String? {
        let exportData = [
            "plants": plantViewModel.plants,
            "tasks": taskViewModel.tasks,
            "instructions": instructionViewModel.instructions,
            "exportDate": Date()
        ] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Ошибка при экспорте данных: \(error)")
            return nil
        }
    }
    
    func createBackup() -> DataBackupInfo? {
        return DataBackup.createBackup()
    }
    
    func restoreFromBackup(_ backupInfo: DataBackupInfo) -> Bool {
        let success = DataBackup.restoreFromBackup(backupInfo)
        if success {
            plantViewModel = PlantViewModel()
            taskViewModel = TaskViewModel()
            instructionViewModel = InstructionViewModel()
            hasCompletedOnboarding = dataManager.loadOnboardingStatus()
        }
        return success
    }
    
    func saveBackupToFile(_ backupInfo: DataBackupInfo, fileName: String) -> URL? {
        return DataBackup.saveBackupToFile(backupInfo, fileName: fileName)
    }
    
    func loadBackupFromFile(_ url: URL) -> DataBackupInfo? {
        return DataBackup.loadBackupFromFile(url)
    }
    
    func getAvailableBackups() -> [URL] {
        return DataBackup.getAvailableBackups()
    }
}

enum TabItem: String, CaseIterable {
    case plants = "Plants"
    case instructions = "Instructions"
    case favorites = "Favorites"
    case calendar = "Calendar"
    case archive = "Archive"
    case settings = "Settings"
    
    var icon: String {
        switch self {
        case .calendar:
            return "calendar"
        case .plants:
            return "leaf.fill"
        case .instructions:
            return "book.fill"
        case .archive:
            return "archivebox.fill"
        case .favorites:
            return "heart.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
    
    var title: String {
        return rawValue
    }
}

