import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var isEditing = false
    @State private var editedUser: User
    @State private var showImageSourceSheet = false
    @State private var showImagePicker = false
    @State private var imagePickerSourceType: ImagePickerView.SourceType = .photoLibrary
    @State private var pickedImage: UIImage?
    
    init() {
        _editedUser = State(initialValue: User.defaultUser)
    }
    
    private var displayUser: User {
        isEditing ? editedUser : appState.currentUser
    }
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridPatternView()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    
                    profileInfoSection
                    
                    preferencesSection
                    
                    goalsSection
                    
                    actionButtonsSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .onAppear {
            editedUser = appState.currentUser
        }
        .onChange(of: pickedImage) { newImage in
            guard let image = newImage else { return }
            if let oldFilename = editedUser.avatarPhotoFileName {
                AvatarStorage.deleteAvatarImage(filename: oldFilename)
            }
            if let newFilename = AvatarStorage.saveAvatarImage(image) {
                editedUser.avatarPhotoFileName = newFilename
            }
            pickedImage = nil
        }
        .confirmationDialog("Profile Photo", isPresented: $showImageSourceSheet, titleVisibility: .visible) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Take Photo") {
                    imagePickerSourceType = .camera
                    showImagePicker = true
                }
            }
            Button("Choose from Library") {
                imagePickerSourceType = .photoLibrary
                showImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Select a photo from your library or take a new one.")
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: imagePickerSourceType, image: $pickedImage)
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Profile")
                    .font(.playfairDisplay(28, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text("Manage your preferences")
                    .font(.playfairDisplay(16, weight: .medium))
                    .foregroundColor(ColorTheme.secondaryText)
            }
            
            Spacer()
            
            Button(isEditing ? "Save" : "Edit") {
                if isEditing {
                    appState.currentUser = editedUser
                    appState.saveUser()
                }
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isEditing.toggle()
                }
            }
            .font(.playfairDisplay(16, weight: .semibold))
            .foregroundColor(isEditing ? ColorTheme.whiteText : ColorTheme.primaryBlue)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isEditing ? ColorTheme.primaryBlue : ColorTheme.backgroundWhite)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 5)
            )
        }
        .padding(.top, 20)
    }
    
    private var profileInfoSection: some View {
        VStack(spacing: 20) {
            Button(action: {
                if isEditing {
                    showImageSourceSheet = true
                }
            }) {
                ZStack {
                    Circle()
                        .fill(ColorTheme.primaryBlue.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    if let photo = AvatarStorage.loadAvatarImage(filename: displayUser.avatarPhotoFileName) {
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: displayUser.avatarImageName)
                            .font(.system(size: 40, weight: .medium))
                            .foregroundColor(ColorTheme.primaryBlue)
                    }
                    
                    if isEditing {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(ColorTheme.whiteText)
                                    .padding(6)
                                    .background(
                                        Circle()
                                            .fill(ColorTheme.primaryYellow)
                                    )
                            }
                        }
                        .frame(width: 100, height: 100)
                    }
                }
            }
            .disabled(!isEditing)
            
            VStack(spacing: 12) {
                if isEditing {
                    TextField("Name", text: $editedUser.name)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryText)
                        .textFieldStyle(CustomTextFieldStyle())
                    
                    TextField("Email", text: $editedUser.email)
                        .font(.playfairDisplay(14))
                        .foregroundColor(ColorTheme.secondaryText)
                        .textFieldStyle(CustomTextFieldStyle())
                } else {
                    Text(appState.currentUser.name)
                        .font(.playfairDisplay(18, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text(appState.currentUser.email)
                        .font(.playfairDisplay(14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.08), radius: 8)
        )
    }
    
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Preferences")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 16) {
                PreferenceCard(
                    title: "Favorite Styles",
                    items: isEditing ? editedUser.favoriteStyles.map { $0.rawValue } : appState.currentUser.favoriteStyles.map { $0.rawValue },
                    isEditing: isEditing,
                    allOptions: JewelryStyle.allCases.map { $0.rawValue }
                ) { newItems in
                    editedUser.favoriteStyles = newItems.compactMap { JewelryStyle(rawValue: $0) }
                }
                
                PreferenceCard(
                    title: "Favorite Materials",
                    items: isEditing ? editedUser.favoriteMaterials : appState.currentUser.favoriteMaterials,
                    isEditing: isEditing,
                    allOptions: ["Gold", "Silver", "Platinum", "Rose Gold", "Sterling Silver", "White Gold"]
                ) { newItems in
                    editedUser.favoriteMaterials = newItems
                }
                
                PreferenceCard(
                    title: "Favorite Stones",
                    items: isEditing ? editedUser.favoriteStones : appState.currentUser.favoriteStones,
                    isEditing: isEditing,
                    allOptions: ["Diamond", "Pearl", "Ruby", "Emerald", "Sapphire", "Amethyst", "Topaz"]
                ) { newItems in
                    editedUser.favoriteStones = newItems
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Budget Range")
                        .font(.playfairDisplay(16, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    if isEditing {
                        VStack(spacing: 8) {
                            HStack {
                                Text("$0")
                                    .font(.playfairDisplay(12))
                                    .foregroundColor(ColorTheme.secondaryText)
                                
                                Spacer()
                                
                                Text("$\(Int(editedUser.budget))")
                                    .font(.playfairDisplay(14, weight: .semibold))
                                    .foregroundColor(ColorTheme.primaryText)
                                
                                Spacer()
                                
                                Text("$5000")
                                    .font(.playfairDisplay(12))
                                    .foregroundColor(ColorTheme.secondaryText)
                            }
                            
                            Slider(value: $editedUser.budget, in: 0...5000, step: 100)
                                .accentColor(ColorTheme.primaryBlue)
                        }
                    } else {
                        Text("Up to $\(Int(appState.currentUser.budget))")
                            .font(.playfairDisplay(14))
                            .foregroundColor(ColorTheme.secondaryText)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTheme.backgroundWhite)
                        .shadow(color: ColorTheme.primaryBlue.opacity(0.05), radius: 3)
                )
            }
        }
    }
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Style Goals")
                .font(.playfairDisplay(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                GoalCard(
                    title: "Daily Elegance",
                    description: "Find jewelry for everyday sophistication",
                    icon: "sun.max.fill",
                    color: ColorTheme.primaryYellow
                )
                
                GoalCard(
                    title: "Evening Glamour",
                    description: "Discover statement pieces for special occasions",
                    icon: "moon.stars.fill",
                    color: ColorTheme.accentPurple
                )
                
                GoalCard(
                    title: "Professional Polish",
                    description: "Build a collection for business settings",
                    icon: "briefcase.fill",
                    color: ColorTheme.primaryBlue
                )
            }
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            Button("View Collection") {
                appState.selectedTab = 1
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Button("Check Progress") {
                appState.selectedTab = 2
            }
            .buttonStyle(SecondaryButtonStyle())
        }
    }
}

struct PreferenceCard: View {
    let title: String
    let items: [String]
    let isEditing: Bool
    let allOptions: [String]
    let onUpdate: ([String]) -> Void
    
    @State private var selectedItems: Set<String> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.playfairDisplay(16, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            if isEditing {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(allOptions, id: \.self) { option in
                        Button {
                            if selectedItems.contains(option) {
                                selectedItems.remove(option)
                            } else {
                                selectedItems.insert(option)
                            }
                            onUpdate(Array(selectedItems))
                        } label: {
                            Text(option)
                                .font(.playfairDisplay(12, weight: .medium))
                                .foregroundColor(selectedItems.contains(option) ? ColorTheme.whiteText : ColorTheme.primaryText)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedItems.contains(option) ? ColorTheme.primaryBlue : ColorTheme.lightGray)
                                )
                        }
                    }
                }
                .onAppear {
                    selectedItems = Set(items)
                }
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 8) {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                            .font(.playfairDisplay(12, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(ColorTheme.primaryBlue.opacity(0.1))
                            )
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.05), radius: 3)
        )
    }
}

struct GoalCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.playfairDisplay(14, weight: .semibold))
                    .foregroundColor(ColorTheme.primaryText)
                
                Text(description)
                    .font(.playfairDisplay(12))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTheme.backgroundWhite)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.05), radius: 3)
        )
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(ColorTheme.lightGray)
            )
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.playfairDisplay(16, weight: .semibold))
            .foregroundColor(ColorTheme.whiteText)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(ColorTheme.primaryBlue)
                    .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.3), radius: 10)
            )
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.playfairDisplay(16, weight: .semibold))
            .foregroundColor(ColorTheme.primaryBlue)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(ColorTheme.backgroundWhite)
                    .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                    .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 5)
            )
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
