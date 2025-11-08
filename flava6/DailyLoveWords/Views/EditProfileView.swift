import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @ObservedObject var profileStore: ProfileStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var selectedImage: UIImage?
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 30) {
                        avatarSection
                        
                        nameSection
                        
                        actionButtons
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppColors.secondaryText)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                    .foregroundColor(AppColors.primaryBlue)
                }
            }
        }
        .onAppear {
            name = profileStore.profile.name
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Select Photo"),
                buttons: [
                    .default(Text("Camera")) {
                        imagePickerSourceType = .camera
                        showingImagePicker = true
                    },
                    .default(Text("Photo Library")) {
                        imagePickerSourceType = .photoLibrary
                        showingImagePicker = true
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showingImagePicker) {
            if imagePickerSourceType == .photoLibrary {
                PhotoPicker(selectedImage: $selectedImage)
            } else {
                ImagePicker(selectedImage: $selectedImage, sourceType: imagePickerSourceType)
            }
        }
        .onChange(of: selectedImage) { image in
            if let image = image {
                profileStore.updateAvatar(image)
            }
        }
    }
    
    private var avatarSection: some View {
        PixelCard {
            VStack(spacing: 20) {
                Text("Profile Photo")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.primaryText)
                
                EditableAvatarView(
                    image: profileStore.profile.avatar,
                    size: 120,
                    onTap: { showingActionSheet = true }
                )
                
                VStack(spacing: 8) {
                    Button("Change Photo") {
                        showingActionSheet = true
                    }
                    .font(FontManager.body)
                    .foregroundColor(AppColors.primaryBlue)
                    
                    if profileStore.profile.avatar != nil {
                        Button("Remove Photo") {
                            profileStore.updateAvatar(nil)
                        }
                        .font(FontManager.caption)
                        .foregroundColor(AppColors.error)
                    }
                }
            }
            .padding(.vertical, 10)
        }
    }
    
    private var nameSection: some View {
        PixelCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Display Name")
                    .font(FontManager.title2)
                    .foregroundColor(AppColors.primaryText)
                
                TextField("Enter your name", text: $name)
                    .font(FontManager.body)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.words)
                    .disableAutocorrection(false)
                
                Text("This name will be displayed in your profile")
                    .font(FontManager.caption)
                    .foregroundColor(AppColors.secondaryText)
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            PixelButton(
                title: "Save Changes",
                action: { saveProfile() },
                color: AppColors.primaryBlue
            )
            
            Button("Reset Profile") {
                profileStore.resetProfile()
                name = profileStore.profile.name
            }
            .font(FontManager.body)
            .foregroundColor(AppColors.error)
        }
    }
    
    private func saveProfile() {
        profileStore.updateName(name)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditProfileView(profileStore: ProfileStore())
}
