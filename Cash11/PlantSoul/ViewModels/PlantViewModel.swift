import Foundation
import SwiftUI

class PlantViewModel: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: PlantCategory? = nil
    @Published var showingAddPlant = false
    
    private let dataManager = DataManager.shared
    
    var filteredPlants: [Plant] {
        var filtered = plants.filter { !$0.isArchived }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { plant in
                plant.name.localizedCaseInsensitiveContains(searchText) ||
                plant.category.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        return filtered.sorted { $0.name < $1.name }
    }
    
    var favoritePlants: [Plant] {
        return plants.filter { $0.isFavorite && !$0.isArchived }
    }
    
    init() {
        loadPlants()
    }
    
    func addPlant(_ plant: Plant) {
        plants.append(plant)
        savePlants()
    }
    
    func updatePlant(_ plant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index] = plant
            savePlants()
        }
    }
    
    func deletePlant(_ plant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index].isArchived = true
            savePlants()
        }
    }
    
    func permanentDeletePlant(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        savePlants()
    }
    
    func toggleFavorite(_ plant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index].isFavorite.toggle()
            savePlants()
        }
    }
    
    func restorePlant(_ plant: Plant) {
        if let index = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[index].isArchived = false
            savePlants()
        }
    }
    
    private func savePlants() {
        dataManager.savePlants(plants)
    }
    
    private func loadPlants() {
        let savedPlants = dataManager.loadPlants()
        
        if savedPlants.isEmpty {
            loadSampleData()
        } else {
            plants = savedPlants
        }
    }
    
    private func loadSampleData() {
        plants = [
            Plant(name: "Monstera Deliciosa", category: .indoor, notes: "Loves bright, indirect light"),
            Plant(name: "Snake Plant", category: .indoor, notes: "Very low maintenance"),
            Plant(name: "Rose Bush", category: .outdoor, notes: "Needs regular pruning"),
            Plant(name: "Water Lily", category: .aquatic, notes: "Aquatic plant for pond")
        ]
        savePlants()
    }
}

