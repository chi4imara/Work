import Foundation
import SwiftUI
import Combine
import PhotosUI

class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile = UserProfile()
    @Published var showingImagePicker = false
    @Published var showingCamera = false
    @Published var selectedImage: UIImage?
    @Published var isEditing = false
    @Published var tempName = ""
    
    private let profileKey = "UserProfile"
    
    init() {
        loadProfile()
    }
    
    func startEditing() {
        tempName = userProfile.name
        isEditing = true
    }
    
    func saveChanges() {
        userProfile.updateName(tempName)
        saveProfile()
        isEditing = false
    }
    
    func cancelEditing() {
        tempName = userProfile.name
        isEditing = false
    }
    
    func updateAvatar(_ image: UIImage) {
        userProfile.updateAvatar(image)
        saveProfile()
    }
    
    func removeAvatar() {
        userProfile.avatarData = nil
        saveProfile()
    }
    
    func showImagePicker() {
        showingImagePicker = true
    }
    
    func showCamera() {
        showingCamera = true
    }
    
    func handleSelectedImage(_ image: UIImage) {
        selectedImage = image
        updateAvatar(image)
    }
    
    func resetImageSelection() {
        selectedImage = nil
    }
    
    func dismissImagePicker() {
        showingImagePicker = false
        showingCamera = false
    }
    
    private func saveProfile() {
        if let encoded = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(encoded, forKey: profileKey)
        }
    }
    
    private func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: profileKey),
           let decodedProfile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = decodedProfile
        }
    }
}
