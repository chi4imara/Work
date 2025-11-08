import SwiftUI
import StoreKit

struct ProfileView: View {
    @ObservedObject var recipeViewModel: RecipeViewModel
    @StateObject private var userProfile = UserProfile()
    @State private var showingEditProfile = false
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    private var allIngredients: [String] {
        let recipeIngredients = recipeViewModel.recipes.flatMap { $0.ingredients }
        let allIngredients = recipeIngredients
        let uniqueIngredients = Array(Set(allIngredients))
        return uniqueIngredients.sorted()
    }

    var body: some View {
        NavigationView {
            ZStack {
                BackgroundView()
                
                ScrollView {
                    VStack(spacing: 32) {
                        profileHeaderView
                        
                        statsView
                        
                        settingsView
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(userProfile: userProfile)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: Binding(
                get: { userProfile.avatarImage },
                set: { newImage in
                    if let image = newImage {
                        userProfile.updateAvatar(image)
                    }
                }
            ), sourceType: imagePickerSourceType)
        }
    }
    
    private var profileHeaderView: some View {
        VStack(spacing: 16) {
            Button(action: {
                showingActionSheet = true
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.primaryPurple, Color.primaryBlue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    if let avatarImage = userProfile.avatarImage {
                        Image(uiImage: avatarImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Circle()
                                .fill(Color.black.opacity(0.6))
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    .frame(width: 100, height: 100)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .confirmationDialog("Change Avatar", isPresented: $showingActionSheet, titleVisibility: .visible) {
                Button("Camera") {
                    imagePickerSourceType = .camera
                    showingImagePicker = true
                }
                Button("Photo Library") {
                    imagePickerSourceType = .photoLibrary
                    showingImagePicker = true
                }
                if userProfile.avatarImage != nil {
                    Button("Remove Avatar", role: .destructive) {
                        userProfile.removeAvatar()
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
            
            VStack(spacing: 8) {
                Text(userProfile.name)
                    .font(.ubuntuTitle)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(userProfile.bio)
                    .font(.ubuntuBody)
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            Button(action: {
                showingEditProfile = true
            }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 14))
                    Text("Edit Profile")
                        .font(.ubuntuCaption)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.primaryPurple.opacity(0.4))
                .cornerRadius(20)
            }
        }
    }
    
    private var statsView: some View {
        VStack(spacing: 16) {
            Text("Your Stats")
                .font(.ubuntuHeadline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                StatCard(
                    title: "Recipes",
                    value: "\(recipeViewModel.recipes.count)",
                    icon: "book.closed"
                )
                
                StatCard(
                    title: "Favorites",
                    value: "\(recipeViewModel.recipes.filter(\.isFavorite).count)",
                    icon: "heart.fill"
                )
                
                StatCard(
                    title: "Ingredients",
                    value: "\(allIngredients.count)",
                    icon: "list.bullet"
                )
            }
        }
    }
    
    private var settingsView: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.ubuntuHeadline)
                .foregroundColor(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "star",
                    title: "Rate App",
                    subtitle: "Help us improve"
                ) {
                    requestReview()
                }
                
                SettingsRow(
                    icon: "envelope",
                    title: "Contact Us",
                    subtitle: "Get in touch"
                ) {
                    openURL("https://forms.gle/QNcxcDqdpeHe5LiE9")
                }
                
                SettingsRow(
                    icon: "doc.text",
                    title: "Terms of Use",
                    subtitle: "Legal information"
                ) {
                    openURL("https://docs.google.com/document/d/1ctt5N6fzDx81XMYBnwScc9IvNtUmxUkG9e647K4gbz8/edit?usp=sharing")
                }
                
                SettingsRow(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    subtitle: "Data protection"
                ) {
                    openURL("https://docs.google.com/document/d/1vQ1RUlzeiMnMJsDNZ64wFCLkM-mTST0RZiwAmE1tZMU/edit?usp=sharing")
                }
            }
        }
    }
    
    private var uniqueCategories: Set<RecipeCategory> {
        Set(recipeViewModel.recipes.map { $0.category })
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func openURL(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.primaryPurple)
            
            Text(value)
                .font(.ubuntuHeadline)
                .foregroundColor(.textPrimary)
            
            Text(title)
                .font(Font.ubuntu(13, weight: .regular))
                .foregroundColor(.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.cardBorder, lineWidth: 1)
        )
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.primaryPurple)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.ubuntuSubheadline)
                        .foregroundColor(.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(subtitle)
                        .font(.ubuntuCaption)
                        .foregroundColor(.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.textTertiary)
            }
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.cardBorder, lineWidth: 1)
            )
        }
    }
}


