import Foundation
import SwiftUI
import Combine

class DeviceViewModel: ObservableObject {
    @Published var devices: [Device] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: DeviceCategory? = nil
    @Published var selectedImprovementFilter: ImprovementStatus? = nil
    
    private let userDefaults = UserDefaults.standard
    private let devicesKey = "SavedDevices"
    
    init() {
        loadDevices()
    }
    
    func addDevice(_ device: Device) {
        devices.append(device)
        saveDevices()
    }
    
    func updateDevice(_ device: Device) {
        if let index = devices.firstIndex(where: { $0.id == device.id }) {
            devices[index] = device
            saveDevices()
        }
    }
    
    func deleteDevice(_ device: Device) {
        devices.removeAll { $0.id == device.id }
        saveDevices()
    }
    
    func addImprovement(_ improvement: Improvement, to deviceId: UUID) {
        if let deviceIndex = devices.firstIndex(where: { $0.id == deviceId }) {
            var updatedImprovement = improvement
            updatedImprovement.deviceId = deviceId
            devices[deviceIndex].improvements.append(updatedImprovement)
            saveDevices()
        }
    }
    
    func updateImprovement(_ improvement: Improvement) {
        for deviceIndex in devices.indices {
            if let improvementIndex = devices[deviceIndex].improvements.firstIndex(where: { $0.id == improvement.id }) {
                devices[deviceIndex].improvements[improvementIndex] = improvement
                saveDevices()
                return
            }
        }
    }
    
    func deleteImprovement(_ improvement: Improvement) {
        for deviceIndex in devices.indices {
            devices[deviceIndex].improvements.removeAll { $0.id == improvement.id }
        }
        saveDevices()
    }
    
    var filteredDevices: [Device] {
        var result = devices
        
        if let selectedCategory = selectedCategory {
            result = result.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            result = result.filter { device in
                device.name.localizedCaseInsensitiveContains(searchText) ||
                device.description.localizedCaseInsensitiveContains(searchText) ||
                device.subcategory.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return result
    }
    
    var allImprovements: [Improvement] {
        devices.flatMap { $0.improvements }
    }
    
    var filteredImprovements: [Improvement] {
        var result = allImprovements
        
        if let selectedFilter = selectedImprovementFilter {
            result = result.filter { $0.status == selectedFilter }
        }
        
        return result.sorted { $0.createdAt > $1.createdAt }
    }
    
    func deviceCount(for category: DeviceCategory) -> Int {
        devices.filter { $0.category == category }.count
    }
    
    func getDevice(by id: UUID) -> Device? {
        devices.first { $0.id == id }
    }
    
    func getDeviceName(for improvementDeviceId: UUID) -> String {
        devices.first { $0.id == improvementDeviceId }?.name ?? "Unknown Device"
    }
    
    func getImprovement(by id: UUID) -> Improvement? {
        for device in devices {
            if let improvement = device.improvements.first(where: { $0.id == id }) {
                return improvement
            }
        }
        return nil
    }
    
    private func saveDevices() {
        if let encoded = try? JSONEncoder().encode(devices) {
            userDefaults.set(encoded, forKey: devicesKey)
        }
    }
    
    private func loadDevices() {
        if let data = userDefaults.data(forKey: devicesKey),
           let decoded = try? JSONDecoder().decode([Device].self, from: data) {
            devices = decoded
        }
    }
    
    func resetToSampleData() {
        devices = Device.sampleDevices
        saveDevices()
    }
}
