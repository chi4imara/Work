import Foundation
import SwiftUI
import Combine
import PhotosUI

class OutfitViewModel: ObservableObject {
    @Published var outfits: [Outfit] = []
    @Published var selectedImage: UIImage?
    @Published var showingImagePicker = false
    @Published var showingCamera = false
    
    private let dataService = DataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        dataService.$outfits
            .assign(to: \.outfits, on: self)
            .store(in: &cancellables)
    }
    
    func addOutfit(name: String, description: String, category: OutfitCategory, isFavorite: Bool, image: UIImage?) {
        let imageData = image?.jpegData(compressionQuality: 0.8)
        let outfit = Outfit(
            name: name,
            description: description,
            category: category,
            isFavorite: isFavorite,
            imageData: imageData
        )
        dataService.addOutfit(outfit)
    }
    
    func updateOutfit(_ outfit: Outfit) {
        dataService.updateOutfit(outfit)
    }
    
    func deleteOutfit(_ outfit: Outfit) {
        dataService.deleteOutfit(outfit)
    }
    
    func getOutfitsByCategory(_ category: OutfitCategory) -> [Outfit] {
        return dataService.getOutfitsByCategory(category)
    }
    
    func getFavoriteOutfits() -> [Outfit] {
        return dataService.getFavoriteOutfits()
    }
    
    func getCategoryCount(_ category: OutfitCategory) -> Int {
        return getOutfitsByCategory(category).count
    }
    
    func getOutfit(by id: UUID) -> Outfit? {
        return outfits.first { $0.id == id }
    }
    
    var totalOutfitsCount: Int {
        return outfits.count
    }
    
    var favoriteOutfitsCount: Int {
        return getFavoriteOutfits().count
    }
}