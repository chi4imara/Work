import Foundation
import SwiftUI
import Combine

class MeasurementStore: ObservableObject {
    @Published var measurements: [Measurement] = []
    @Published var isFirstLaunch: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let measurementsKey = "SavedMeasurements"
    private let firstLaunchKey = "IsFirstLaunch"
    
    init() {
        loadMeasurements()
        checkFirstLaunch()
    }
    
    private func loadMeasurements() {
        if let data = userDefaults.data(forKey: measurementsKey),
           let decodedMeasurements = try? JSONDecoder().decode([Measurement].self, from: data) {
            measurements = decodedMeasurements.sorted { $0.date > $1.date }
        }
    }
    
    private func saveMeasurements() {
        if let encoded = try? JSONEncoder().encode(measurements) {
            userDefaults.set(encoded, forKey: measurementsKey)
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: firstLaunchKey)
        isFirstLaunch = false
    }
    
    func addMeasurement(_ measurement: Measurement) {
        measurements.append(measurement)
        measurements.sort { $0.date > $1.date }
        saveMeasurements()
    }
    
    func updateMeasurement(_ measurement: Measurement) {
        if let index = measurements.firstIndex(where: { $0.id == measurement.id }) {
            measurements[index] = measurement
            measurements.sort { $0.date > $1.date }
            saveMeasurements()
        }
    }
    
    func deleteMeasurement(_ measurement: Measurement) {
        measurements.removeAll { $0.id == measurement.id }
        saveMeasurements()
    }
    
    var latestMeasurement: Measurement? {
        measurements.first
    }
    
    func getMeasurements(for zone: BodyZone) -> [(Date, Double)] {
        return measurements.map { measurement in
            (measurement.date, zone.getValue(from: measurement))
        }.sorted { $0.0 < $1.0 }
    }
    
    func getStatistics(for zone: BodyZone) -> (min: Double, max: Double, count: Int) {
        let values = measurements.map { zone.getValue(from: $0) }.filter { $0 > 0 }
        return (
            min: values.min() ?? 0,
            max: values.max() ?? 0,
            count: values.count
        )
    }
}
