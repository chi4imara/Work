import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var showSplashScreen = true
    @Published var showOnboarding = false
    @Published var selectedTab = 0
    
    @Published var tasks: [PartyTask] = []
    @Published var themes: [PartyTheme] = []
    @Published var favorites: [FavoriteItem] = []
    @Published var statistics = AppStatistics()
    
    @Published var currentTask: PartyTask?
    @Published var currentTheme: PartyTheme?
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadData()
        checkFirstLaunch()
    }
    
    private func checkFirstLaunch() {
        let hasLaunchedBefore = userDefaults.bool(forKey: "hasLaunchedBefore")
        if !hasLaunchedBefore {
            showOnboarding = true
            userDefaults.set(true, forKey: "hasLaunchedBefore")
        }
    }
    
    private func loadData() {
        loadTasks()
        loadThemes()
        loadFavorites()
        loadStatistics()
    }
    
    private func loadTasks() {
        if let data = userDefaults.data(forKey: "tasks"),
           let decodedTasks = try? JSONDecoder().decode([PartyTask].self, from: data) {
            tasks = decodedTasks
        } else {
            tasks = PartyTask.defaultTasks
            saveTasks()
        }
    }
    
    private func loadThemes() {
        themes = PartyTheme.defaultThemes
        if let randomTheme = themes.randomElement() {
            currentTheme = randomTheme
        }
    }
    
    private func loadFavorites() {
        if let data = userDefaults.data(forKey: "favorites"),
           let decodedFavorites = try? JSONDecoder().decode([FavoriteItem].self, from: data) {
            favorites = decodedFavorites
        }
    }
    
    private func loadStatistics() {
        if let data = userDefaults.data(forKey: "statistics"),
           let decodedStats = try? JSONDecoder().decode(AppStatistics.self, from: data) {
            statistics = decodedStats
        }
    }
    
    func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            userDefaults.set(encoded, forKey: "tasks")
        }
    }
    
    func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            userDefaults.set(encoded, forKey: "favorites")
        }
    }
    
    func saveStatistics() {
        if let encoded = try? JSONEncoder().encode(statistics) {
            userDefaults.set(encoded, forKey: "statistics")
        }
    }
    
    func addTask(_ text: String) {
        let newTask = PartyTask(text: text)
        tasks.append(newTask)
        saveTasks()
    }
    
    func removeTask(_ task: PartyTask) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }
    
    func updateTask(_ task: PartyTask, newText: String) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].text = newText
            saveTasks()
        }
    }
    
    func spinWheel() {
        guard !tasks.isEmpty else { return }
        
        currentTask = tasks.randomElement()
        statistics.wheelSpins += 1
        saveStatistics()
    }
    
    func generateNewTheme() {
        currentTheme = themes.randomElement()
        statistics.themesGenerated += 1
        saveStatistics()
    }
    
    func addToFavorites(text: String, type: FavoriteType) -> Bool {
        if favorites.contains(where: { $0.text == text && $0.type == type }) {
            return false
        }
        
        let newFavorite = FavoriteItem(text: text, type: type)
        favorites.insert(newFavorite, at: 0)
        statistics.favoritesAdded += 1
        
        saveFavorites()
        saveStatistics()
        return true
    }
    
    func removeFavorite(_ favorite: FavoriteItem) {
        withAnimation(.easeInOut(duration: 0.3)) {
            favorites.removeAll { $0.id == favorite.id }
        }
        saveFavorites()
    }
    
    func completeSplashScreen() {
        withAnimation(.easeInOut(duration: 0.5)) {
            showSplashScreen = false
        }
    }
    
    func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.5)) {
            showOnboarding = false
        }
    }
}
