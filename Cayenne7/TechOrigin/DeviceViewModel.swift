import Foundation
import SwiftUI
import Combine

class DeviceViewModel: ObservableObject {
    @Published var devices: [Device] = []
    @Published var selectedFilter: FilterCategory = .all
    @Published var showOnboarding: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let devicesKey = "SavedDevices"
    private let onboardingKey = "HasSeenOnboarding"
    
    init() {
        loadDevices()
        loadOnboardingStatus()
    }
    
    var filteredDevices: [Device] {
        if selectedFilter == .all {
            return devices
        }
        
        guard let category = selectedFilter.deviceCategory else {
            return devices
        }
        
        return devices.filter { $0.category == category }
    }
    
    var devicesByCategory: [DeviceCategory: [Device]] {
        Dictionary(grouping: devices) { $0.category }
    }
    
    var categoryCounts: [DeviceCategory: Int] {
        devicesByCategory.mapValues { $0.count }
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
    
    func completeOnboarding() {
        showOnboarding = false
        userDefaults.set(true, forKey: onboardingKey)
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
    
    private func loadOnboardingStatus() {
        showOnboarding = !userDefaults.bool(forKey: onboardingKey)
    }
}
