import Foundation
import Combine

class ExperimentViewModel: ObservableObject {
    @Published var experiments: [Experiment] = []
    @Published var searchText: String = ""
    
    private let userDefaults = UserDefaults.standard
    private let experimentsKey = "SavedExperiments"
    
    init() {
        loadExperiments()
    }
    
    var filteredExperiments: [Experiment] {
        if searchText.isEmpty {
            return experiments
        } else {
            return experiments.filter { $0.contains(searchText) }
        }
    }
    
    func addExperiment(tried: String, changed: String, result: String) {
        let newExperiment = Experiment(tried: tried, changed: changed, result: result)
        experiments.append(newExperiment)
        saveExperiments()
    }
    
    func updateExperiment(_ experiment: Experiment, tried: String, changed: String, result: String) {
        if let index = experiments.firstIndex(where: { $0.id == experiment.id }) {
            experiments[index].update(tried: tried, changed: changed, result: result)
            saveExperiments()
        }
    }
    
    func deleteExperiment(_ experiment: Experiment) {
        experiments.removeAll { $0.id == experiment.id }
        saveExperiments()
    }
    
    func deleteExperiment(byId id: UUID) {
        experiments.removeAll { $0.id == id }
        saveExperiments()
    }
    
    func experiment(byId id: UUID) -> Experiment? {
        experiments.first { $0.id == id }
    }
    
    func loadSampleData() {
        experiments.append(contentsOf: SampleData.experiments)
        saveExperiments()
    }
    
    private func saveExperiments() {
        if let encoded = try? JSONEncoder().encode(experiments) {
            userDefaults.set(encoded, forKey: experimentsKey)
        }
    }
    
    private func loadExperiments() {
        if let data = userDefaults.data(forKey: experimentsKey),
           let decoded = try? JSONDecoder().decode([Experiment].self, from: data) {
            experiments = decoded
        }
    }
}