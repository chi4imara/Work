import Foundation
import Combine

class StorageMonitor: ObservableObject {
    @Published var storageInfo: StorageInfo = StorageInfo()
    
    private let fileStorage = FileStorageManager.shared
    
    func updateStorageInfo() {
        let (totalSize, fileCount) = fileStorage.getStorageInfo()
        storageInfo = StorageInfo(
            totalSize: totalSize,
            fileCount: fileCount,
            lastUpdated: Date()
        )
    }
    
    var formattedSize: String {
        formatBytes(storageInfo.totalSize)
    }
    
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

struct StorageInfo {
    let totalSize: Int64
    let fileCount: Int
    let lastUpdated: Date
    
    init(totalSize: Int64 = 0, fileCount: Int = 0, lastUpdated: Date = Date()) {
        self.totalSize = totalSize
        self.fileCount = fileCount
        self.lastUpdated = lastUpdated
    }
}
