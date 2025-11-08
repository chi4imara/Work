import Foundation

struct DataBackup {
    
    static func createBackup() -> DataBackupInfo? {
        let dataManager = DataManager.shared
        
        let plants = dataManager.loadPlants()
        let tasks = dataManager.loadTasks()
        let instructions = dataManager.loadInstructions()
        let onboardingStatus = dataManager.loadOnboardingStatus()
        
        let backupData = BackupData(
            plants: plants,
            tasks: tasks,
            instructions: instructions,
            hasCompletedOnboarding: onboardingStatus,
            backupDate: Date(),
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        )
        
        do {
            let data = try JSONEncoder().encode(backupData)
            return DataBackupInfo(data: data, date: Date())
        } catch {
            print("Ошибка при создании резервной копии: \(error)")
            return nil
        }
    }
    
    static func restoreFromBackup(_ backupInfo: DataBackupInfo) -> Bool {
        do {
            let backupData = try JSONDecoder().decode(BackupData.self, from: backupInfo.data)
            let dataManager = DataManager.shared
            
            dataManager.savePlants(backupData.plants)
            dataManager.saveTasks(backupData.tasks)
            dataManager.saveInstructions(backupData.instructions)
            dataManager.saveOnboardingStatus(backupData.hasCompletedOnboarding)
            
            return true
        } catch {
            print("Ошибка при восстановлении из резервной копии: \(error)")
            return false
        }
    }
    
    static func saveBackupToFile(_ backupInfo: DataBackupInfo, fileName: String) -> URL? {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let backupURL = documentsPath.appendingPathComponent("\(fileName).backup")
        
        do {
            try backupInfo.data.write(to: backupURL)
            return backupURL
        } catch {
            print("Ошибка при сохранении резервной копии в файл: \(error)")
            return nil
        }
    }
    
    static func loadBackupFromFile(_ url: URL) -> DataBackupInfo? {
        do {
            let data = try Data(contentsOf: url)
            return DataBackupInfo(data: data, date: Date())
        } catch {
            print("Ошибка при загрузке резервной копии из файла: \(error)")
            return nil
        }
    }
    
    static func getAvailableBackups() -> [URL] {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            return files.filter { $0.pathExtension == "backup" }
        } catch {
            print("Ошибка при получении списка резервных копий: \(error)")
            return []
        }
    }
}

struct DataBackupInfo {
    let data: Data
    let date: Date
    
    var size: Int {
        return data.count
    }
    
    var sizeFormatted: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(size))
    }
}

private struct BackupData: Codable {
    let plants: [Plant]
    let tasks: [Task]
    let instructions: [Instruction]
    let hasCompletedOnboarding: Bool
    let backupDate: Date
    let appVersion: String
}
