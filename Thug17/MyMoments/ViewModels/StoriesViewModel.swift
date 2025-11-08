import Foundation
import Combine

class StoriesViewModel: ObservableObject {
    @Published var stories: [Story] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .newestFirst
    @Published var isSearching: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let storiesKey = Constants.UserDefaults.storiesKey
    private let sortOptionKey = Constants.UserDefaults.sortOptionKey
    
    init() {
        loadStories()
        loadSortOption()
    }
    
    var filteredStories: [Story] {
        let filtered = searchText.isEmpty ? stories : stories.filter { story in
            story.title.localizedCaseInsensitiveContains(searchText) ||
            story.content.localizedCaseInsensitiveContains(searchText) ||
            story.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
        }
        return sortOption.sort(filtered)
    }
    
    var allTags: [String: Int] {
        var tagCounts: [String: Int] = [:]
        for story in stories {
            for tag in story.tags {
                tagCounts[tag, default: 0] += 1
            }
        }
        return tagCounts
    }
    
    var sortedTags: [(tag: String, count: Int)] {
        allTags.sorted { first, second in
            if first.value == second.value {
                return first.key < second.key
            }
            return first.value > second.value
        }.map { (tag: $0.key, count: $0.value) }
    }
    
    func addStory(_ story: Story) {
        stories.append(story)
        saveStories()
    }
    
    func updateStory(_ story: Story) {
        if let index = stories.firstIndex(where: { $0.id == story.id }) {
            stories[index] = story
            saveStories()
        }
    }
    
    func deleteStory(_ story: Story) {
        stories.removeAll { $0.id == story.id }
        saveStories()
    }
    
    func incrementViewCount(for story: Story) {
        if let index = stories.firstIndex(where: { $0.id == story.id }) {
            stories[index].incrementViewCount()
            saveStories()
        }
    }
    
    func setSortOption(_ option: SortOption) {
        sortOption = option
        saveSortOption()
    }
    
    func storiesWithTag(_ tag: String) -> [Story] {
        return stories.filter { $0.tags.contains(tag) }
    }
    
    private func saveStories() {
        if let encoded = try? JSONEncoder().encode(stories) {
            userDefaults.set(encoded, forKey: storiesKey)
        }
    }
    
    private func loadStories() {
        if let data = userDefaults.data(forKey: storiesKey),
           let decoded = try? JSONDecoder().decode([Story].self, from: data) {
            stories = decoded
        }
    }
    
    private func saveSortOption() {
        userDefaults.set(sortOption.rawValue, forKey: sortOptionKey)
    }
    
    private func loadSortOption() {
        if let savedOption = userDefaults.string(forKey: sortOptionKey),
           let option = SortOption(rawValue: savedOption) {
            sortOption = option
        }
    }
}
