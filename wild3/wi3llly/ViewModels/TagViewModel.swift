import Foundation
import SwiftUI
import Combine

class TagViewModel: ObservableObject {
    @Published var tags: [TagModel] = []
    
    private let dataManager = DataManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        dataManager.$tags
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tags in
                self?.tags = tags
            }
            .store(in: &cancellables)
        
        tags = dataManager.tags
    }
    
    func addTag(name: String) -> Bool {
        let newTag = TagModel(name: name)
        return dataManager.addTag(newTag)
    }
    
    func deleteTag(_ tag: TagModel) {
        dataManager.deleteTag(withName: tag.name)
    }
    
    func getDreamCount(for tag: TagModel) -> Int {
        return dataManager.getDreamCount(for: tag.name)
    }
}
