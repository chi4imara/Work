import SwiftUI
import StoreKit

struct ProfileView: View {
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var showingPhotoOptions = false
    @State private var showingRateApp = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    ColorManager.backgroundGradientStart,
                    ColorManager.backgroundGradientEnd
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(ColorManager.orbColors[index % ColorManager.orbColors.count])
                    .frame(width: CGFloat.random(in: 30...60))
                    .position(
                        x: CGFloat.random(in: 50...(UIScreen.main.bounds.width - 50)),
                        y: CGFloat.random(in: 100...(UIScreen.main.bounds.height - 200))
                    )
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 4...7))
                            .repeatForever(autoreverses: true),
                        value: UUID()
                    )
            }
            
            VStack(spacing: 0) {
                headerView
                
                profileContentView
                
                Spacer()
            }
        }
        .sheet(isPresented: $profileViewModel.showingImagePicker) {
            ImagePickerView(selectedImage: $profileViewModel.selectedImage)
                .onDisappear {
                    if let image = profileViewModel.selectedImage {
                        profileViewModel.handleSelectedImage(image)
                    }
                    profileViewModel.dismissImagePicker()
                }
        }
        .sheet(isPresented: $profileViewModel.showingCamera) {
            CameraView(selectedImage: $profileViewModel.selectedImage)
                .onDisappear {
                    if let image = profileViewModel.selectedImage {
                        profileViewModel.handleSelectedImage(image)
                    }
                    profileViewModel.dismissImagePicker()
                }
        }
        .confirmationDialog("Select Photo", isPresented: $showingPhotoOptions) {
            Button("Camera") {
                profileViewModel.showCamera()
            }
            
            Button("Photo Library") {
                profileViewModel.showImagePicker()
            }
            
            Button("Remove Photo", role: .destructive) {
                profileViewModel.removeAvatar()
            }
            
            Button("Cancel", role: .cancel) { }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Profile")
                .font(FontManager.ubuntuBold(28))
                .foregroundColor(ColorManager.primaryText)
            
            Spacer()
            
            if profileViewModel.isEditing {
                HStack(spacing: 15) {
                    Button("Cancel") {
                        profileViewModel.cancelEditing()
                    }
                    .font(FontManager.ubuntuMedium(16))
                    .foregroundColor(ColorManager.primaryText)
                    
                    Button("Save") {
                        profileViewModel.saveChanges()
                    }
                    .font(FontManager.ubuntuMedium(16))
                    .foregroundColor(ColorManager.primaryBlue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(ColorManager.primaryYellow)
                    .cornerRadius(16)
                }
            } else {
                Button("Edit") {
                    profileViewModel.startEditing()
                }
                .font(FontManager.ubuntuMedium(16))
                .foregroundColor(ColorManager.primaryBlue)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(ColorManager.primaryYellow)
                .cornerRadius(16)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
    
    private var profileContentView: some View {
        ScrollView {
            VStack(spacing: 30) {
                profileAvatarSection
                
                nameSection
                
                additionalInfoSection
                
                settingsSection
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 200)
            .padding(.top, 10)
        }
        .padding(.bottom, -100)
    }
    
    private var profileAvatarSection: some View {
        VStack(spacing: 20) {
            Button(action: {
                showingPhotoOptions = true
            }) {
                ProfileAvatarView(
                    avatarImage: profileViewModel.userProfile.avatarImage,
                    size: 120,
                    showEditOverlay: true
                )
            }
            .concaveCard(cornerRadius: 60, depth: 4, color: ColorManager.primaryYellow.opacity(0.1))
            
            Text("Tap to change photo")
                .font(FontManager.ubuntu(14))
                .foregroundColor(ColorManager.secondaryText)
        }
    }
    
    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Name")
                .font(FontManager.ubuntuMedium(18))
                .foregroundColor(ColorManager.primaryText)
            
            if profileViewModel.isEditing {
                TextField("Enter your name", text: $profileViewModel.tempName)
                    .font(FontManager.ubuntu(16))
                    .foregroundColor(ColorManager.primaryBlue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .concaveCard(cornerRadius: 12, depth: 2, color: ColorManager.cardBackground)
            } else {
                HStack {
                    Text(profileViewModel.userProfile.name.isEmpty ? "Your Name" : profileViewModel.userProfile.name)
                        .font(FontManager.ubuntu(16))
                        .foregroundColor(profileViewModel.userProfile.name.isEmpty ? .gray.opacity(0.7) : ColorManager.primaryBlue)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .concaveCard(cornerRadius: 12, depth: 2, color: ColorManager.cardBackground)
            }
        }
    }
    
    private var additionalInfoSection: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Member since")
                        .font(FontManager.ubuntu(12))
                        .foregroundColor(ColorManager.primaryBlue.opacity(0.7))
                    
                    Text(profileViewModel.userProfile.dateCreated, style: .date)
                        .font(FontManager.ubuntuMedium(14))
                        .foregroundColor(ColorManager.primaryBlue)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Last updated")
                        .font(FontManager.ubuntu(12))
                        .foregroundColor(ColorManager.primaryBlue.opacity(0.7))
                    
                    Text(profileViewModel.userProfile.lastUpdated, style: .date)
                        .font(FontManager.ubuntuMedium(14))
                        .foregroundColor(ColorManager.primaryBlue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .concaveCard(cornerRadius: 12, depth: 2, color: ColorManager.cardBackground)
        }
    }
    
    private var settingsSection: some View {
        VStack(spacing: 15) {
            Text("App Settings")
                .font(FontManager.ubuntuBold(18))
                .foregroundColor(ColorManager.primaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                SettingsRowView(
                    title: "Rate Our App",
                    icon: "star.fill",
                    action: {
                        requestReview()
                    }
                )
                
                SettingsRowView(
                    title: "Terms of Use",
                    icon: "doc.text.fill",
                    action: {
                        openURL("https://www.privacypolicies.com/live/413549d0-9310-4c16-9064-7a2cdf2ed598")
                    }
                )
                
                SettingsRowView(
                    title: "Privacy Policy",
                    icon: "lock.shield.fill",
                    action: {
                        openURL("https://www.privacypolicies.com/live/a5b4654c-0433-4b7c-a62e-3b1242712c1f")
                    }
                )
                
                SettingsRowView(
                    title: "Contact Us",
                    icon: "envelope.fill",
                    action: {
                        openURL("https://www.privacypolicies.com/live/a5b4654c-0433-4b7c-a62e-3b1242712c1f")
                    }
                )
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

struct SettingsRowView: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(ColorManager.primaryBlue)
                    .frame(width: 30)
                
                Text(title)
                    .font(FontManager.ubuntuMedium(16))
                    .foregroundColor(ColorManager.primaryBlue)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorManager.primaryBlue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .concaveCard(cornerRadius: 12, depth: 2, color: ColorManager.cardBackground)
        }
    }
}

#Preview {
    ProfileView()
}
