import SwiftUI
import UIKit

struct ProfileView: View {
    @EnvironmentObject private var userViewModel: UserViewModel
    @State private var isEditing = false
    @State private var showingImageSourceActionSheet = false
    @State private var showingImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var avatarImage: UIImage?
    @State private var showingBrandEditor = false
    @State private var showingSizeEditor = false
    @State private var showingStyleEditor = false
    
    var body: some View {
        ZStack {
            backgroundView
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Profile")
                        .font(.ubuntu(32, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                    
                    Spacer()
                    
                    Button(isEditing ? "Cancel" : "Edit") {
                        isEditing.toggle()
                    }
                    .font(.ubuntu(24, weight: .semibold))
                    .foregroundColor(Color.theme.accentYellow)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        profileHeaderSection
                        
                        userInfoSection
                        
                        preferencesSection
                        
                        styleGoalsSection
                        
                        notificationSettingsSection
                        
                        if isEditing {
                            saveButtonSection
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .onAppear {
            if userViewModel.user.avatar != nil {
                avatarImage = AvatarStorage.loadAvatarImage()
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(
                sourceType: imagePickerSourceType,
                onImagePicked: { image in
                    if AvatarStorage.saveAvatarImage(image) {
                        var updatedUser = userViewModel.user
                        updatedUser.avatar = "profile_avatar"
                        userViewModel.updateUser(updatedUser)
                        avatarImage = image
                    }
                    showingImagePicker = false
                },
                onCancel: {
                    showingImagePicker = false
                }
            )
        }
        .sheet(isPresented: $showingBrandEditor) {
            BrandEditorView(
                initialBrands: userViewModel.user.favoriteBrands,
                onSave: { newBrands in
                    var updatedUser = userViewModel.user
                    updatedUser.favoriteBrands = newBrands
                    userViewModel.updateUser(updatedUser)
                    showingBrandEditor = false
                },
                onCancel: { showingBrandEditor = false }
            )
        }
        .sheet(isPresented: $showingSizeEditor) {
            SizeEditorView(
                initialSizes: userViewModel.user.preferredSizes,
                onSave: { newSizes in
                    var updatedUser = userViewModel.user
                    updatedUser.preferredSizes = newSizes
                    userViewModel.updateUser(updatedUser)
                    showingSizeEditor = false
                },
                onCancel: { showingSizeEditor = false }
            )
        }
        .sheet(isPresented: $showingStyleEditor) {
            StyleEditorView(
                initialStyles: userViewModel.user.preferredStyles,
                onSave: { newStyles in
                    var updatedUser = userViewModel.user
                    updatedUser.preferredStyles = newStyles
                    userViewModel.updateUser(updatedUser)
                    showingStyleEditor = false
                },
                onCancel: { showingStyleEditor = false }
            )
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            LinearGradient(
                colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            GridPattern()
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        }
    }
    
    private var profileHeaderSection: some View {
        VStack(spacing: 16) {
            Button(action: {
                if isEditing {
                    showingImageSourceActionSheet = true
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color.theme.cardBackground)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Circle()
                                .stroke(Color.theme.cardBorder, lineWidth: 2)
                        )
                    
                    if let image = avatarImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(Color.theme.accentYellow)
                    }
                    
                    if isEditing {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(Color.theme.primaryButton)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.theme.primaryText)
                                    )
                                    .offset(x: 10, y: 10)
                            }
                        }
                        .confirmationDialog("Add Photo", isPresented: $showingImageSourceActionSheet, titleVisibility: .visible) {
                            Button("Photo Library") {
                                imagePickerSourceType = .photoLibrary
                                showingImagePicker = true
                            }
                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                Button("Camera") {
                                    imagePickerSourceType = .camera
                                    showingImagePicker = true
                                }
                            }
                            Button("Cancel", role: .cancel) {}
                        } message: {
                            Text("Choose a photo from your library or take a new one")
                        }
                    }
                }
            }
            .disabled(!isEditing)
            
            VStack(spacing: 8) {
                if isEditing {
                    TextField("Name", text: Binding(
                        get: { userViewModel.user.name },
                        set: { newValue in
                            var updatedUser = userViewModel.user
                            updatedUser.name = newValue
                            userViewModel.updateUser(updatedUser)
                        }
                    ))
                    .font(.ubuntu(20, weight: .bold))
                    .foregroundColor(Color.black)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    Text(userViewModel.user.name)
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                }
                
                if isEditing {
                    TextField("Email", text: Binding(
                        get: { userViewModel.user.email },
                        set: { newValue in
                            var updatedUser = userViewModel.user
                            updatedUser.email = newValue
                            userViewModel.updateUser(updatedUser)
                        }
                    ))
                    .font(.ubuntu(16))
                    .foregroundColor(Color.black)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    Text(userViewModel.user.email)
                        .font(.ubuntu(16))
                        .foregroundColor(Color.theme.secondaryText)
                }
            }
        }
    }
    
    private var userInfoSection: some View {
        ProfileSectionCard(title: "Personal Information") {
            VStack(spacing: 16) {
                ProfileInfoRow(
                    title: "Favorite Brands",
                    value: userViewModel.user.favoriteBrands.isEmpty ? "None selected" : Array(userViewModel.user.favoriteBrands).joined(separator: ", "),
                    isEditing: isEditing,
                    onEdit: { showingBrandEditor = true }
                )
                
                ProfileInfoRow(
                    title: "Preferred Sizes",
                    value: userViewModel.user.preferredSizes.isEmpty ? "None selected" : userViewModel.user.preferredSizes.map { $0.rawValue }.joined(separator: ", "),
                    isEditing: isEditing,
                    onEdit: { showingSizeEditor = true }
                )
                
                ProfileInfoRow(
                    title: "Preferred Styles",
                    value: userViewModel.user.preferredStyles.isEmpty ? "None selected" : userViewModel.user.preferredStyles.map { $0.rawValue }.joined(separator: ", "),
                    isEditing: isEditing,
                    onEdit: { showingStyleEditor = true }
                )
            }
        }
    }
    
    private var preferencesSection: some View {
        ProfileSectionCard(title: "Bag Preferences") {
            VStack(spacing: 12) {
                if isEditing {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Preferred Sizes")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(BagSize.allCases, id: \.self) { size in
                                PreferenceChip(
                                    title: size.rawValue,
                                    isSelected: userViewModel.user.preferredSizes.contains(size)
                                ) {
                                    var updatedUser = userViewModel.user
                                    if updatedUser.preferredSizes.contains(size) {
                                        updatedUser.preferredSizes.remove(size)
                                    } else {
                                        updatedUser.preferredSizes.insert(size)
                                    }
                                    userViewModel.updateUser(updatedUser)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Preferred Styles")
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 8) {
                            ForEach(BagStyle.allCases, id: \.self) { style in
                                PreferenceChip(
                                    title: style.rawValue,
                                    isSelected: userViewModel.user.preferredStyles.contains(style)
                                ) {
                                    var updatedUser = userViewModel.user
                                    if updatedUser.preferredStyles.contains(style) {
                                        updatedUser.preferredStyles.remove(style)
                                    } else {
                                        updatedUser.preferredStyles.insert(style)
                                    }
                                    userViewModel.updateUser(updatedUser)
                                }
                            }
                        }
                    }
                } else {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Sizes:")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Spacer()
                            
                            Text(userViewModel.user.preferredSizes.map { $0.rawValue }.joined(separator: ", "))
                                .font(.ubuntu(14))
                                .foregroundColor(Color.theme.secondaryText)
                        }
                        
                        HStack {
                            Text("Styles:")
                                .font(.ubuntu(14, weight: .medium))
                                .foregroundColor(Color.theme.primaryText)
                            
                            Spacer()
                            
                            Text(userViewModel.user.preferredStyles.map { $0.rawValue }.joined(separator: ", "))
                                .font(.ubuntu(14))
                                .foregroundColor(Color.theme.secondaryText)
                        }
                    }
                }
            }
        }
    }
    
    private var styleGoalsSection: some View {
        ProfileSectionCard(title: "Style Goals") {
            VStack(spacing: 12) {
                if isEditing {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(StyleGoal.allCases, id: \.self) { goal in
                            PreferenceChip(
                                title: goal.rawValue,
                                isSelected: userViewModel.user.styleGoals.contains(goal)
                            ) {
                                var updatedUser = userViewModel.user
                                if updatedUser.styleGoals.contains(goal) {
                                    updatedUser.styleGoals.remove(goal)
                                } else {
                                    updatedUser.styleGoals.insert(goal)
                                }
                                userViewModel.updateUser(updatedUser)
                            }
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(userViewModel.user.styleGoals), id: \.self) { goal in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color.theme.accentYellow)
                                
                                Text(goal.rawValue)
                                    .font(.ubuntu(14))
                                    .foregroundColor(Color.theme.primaryText)
                                
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var notificationSettingsSection: some View {
        ProfileSectionCard(title: "Notifications") {
            VStack(spacing: 16) {
                NotificationToggle(
                    title: "New Models",
                    description: "Get notified about new bag releases",
                    isOn: Binding(
                        get: { userViewModel.user.notificationSettings.newModels },
                        set: { newValue in
                            var settings = userViewModel.user.notificationSettings
                            settings.newModels = newValue
                            userViewModel.updateNotificationSettings(settings)
                        }
                    )
                )
                
                NotificationToggle(
                    title: "Discounts",
                    description: "Receive alerts about sales and discounts",
                    isOn: Binding(
                        get: { userViewModel.user.notificationSettings.discounts },
                        set: { newValue in
                            var settings = userViewModel.user.notificationSettings
                            settings.discounts = newValue
                            userViewModel.updateNotificationSettings(settings)
                        }
                    )
                )
                
                NotificationToggle(
                    title: "Stylist Recommendations",
                    description: "Get personalized style recommendations",
                    isOn: Binding(
                        get: { userViewModel.user.notificationSettings.stylistRecommendations },
                        set: { newValue in
                            var settings = userViewModel.user.notificationSettings
                            settings.stylistRecommendations = newValue
                            userViewModel.updateNotificationSettings(settings)
                        }
                    )
                )
                
                NotificationToggle(
                    title: "Collection Updates",
                    description: "Updates about your saved bags",
                    isOn: Binding(
                        get: { userViewModel.user.notificationSettings.collectionUpdates },
                        set: { newValue in
                            var settings = userViewModel.user.notificationSettings
                            settings.collectionUpdates = newValue
                            userViewModel.updateNotificationSettings(settings)
                        }
                    )
                )
            }
        }
    }
    
    private var saveButtonSection: some View {
        Button(action: {
            isEditing = false
        }) {
            Text("Save Changes")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.theme.primaryButton)
                .cornerRadius(25)
        }
    }
}

struct BrandEditorView: View {
    let initialBrands: Set<String>
    let onSave: (Set<String>) -> Void
    let onCancel: () -> Void
    
    @State private var brands: Set<String> = []
    @State private var newBrandText = ""
    
    private let suggestedBrands = ["Gucci", "Louis Vuitton", "Chanel", "Prada", "Hermès", "Burberry", "Coach", "Michael Kors", "Saint Laurent", "Bottega Veneta"]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        addBrandSection
                        
                        if !brands.isEmpty {
                            yourBrandsSection
                        }
                        
                        suggestedSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Favorite Brands")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .foregroundColor(Color.theme.primaryText)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onSave(brands)
                    }
                    .foregroundColor(Color.theme.accentYellow)
                    .fontWeight(.semibold)
                }
            }
            .preferredColorScheme(.dark)
            .onAppear {
                brands = initialBrands
            }
        }
    }
    
    private var addBrandSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Add brand")
                .font(.ubuntu(14, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            HStack(spacing: 12) {
                TextField("Brand name", text: $newBrandText)
                    .font(.ubuntu(16))
                    .foregroundColor(Color.theme.primaryText)
                    .padding(12)
                    .background(Color.theme.cardBackground)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.theme.cardBorder, lineWidth: 1)
                    )
                    .autocapitalization(.words)
                
                Button(action: addCurrentBrand) {
                    Text("Add")
                        .font(.ubuntu(16, weight: .bold))
                        .foregroundColor(Color.theme.primaryText)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.theme.primaryButton)
                        .cornerRadius(10)
                }
                .disabled(newBrandText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
    
    private var yourBrandsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your brands")
                .font(.ubuntu(14, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 8) {
                ForEach(Array(brands).sorted(), id: \.self) { brand in
                    HStack(spacing: 4) {
                        Text(brand)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                            .lineLimit(1)
                        
                        Spacer(minLength: 0)
                        
                        Button(action: { brands.remove(brand) }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color.theme.secondaryText)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.theme.cardBackground)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.theme.cardBorder, lineWidth: 1)
                    )
                }
            }
        }
    }
    
    private var suggestedSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Suggested")
                .font(.ubuntu(14, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))], spacing: 8) {
                ForEach(suggestedBrands.filter { !brands.contains($0) }, id: \.self) { brand in
                    Button(action: { brands.insert(brand) }) {
                        Text(brand)
                            .font(.ubuntu(14, weight: .medium))
                            .foregroundColor(Color.theme.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.theme.cardBorder, lineWidth: 1)
                            )
                    }
                }
            }
        }
    }
    
    private func addCurrentBrand() {
        let trimmed = newBrandText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        brands.insert(trimmed)
        newBrandText = ""
    }
}

struct SizeEditorView: View {
    let initialSizes: Set<BagSize>
    let onSave: (Set<BagSize>) -> Void
    let onCancel: () -> Void
    
    @State private var selectedSizes: Set<BagSize> = []
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Tap to select your preferred bag sizes")
                            .font(.ubuntu(14))
                            .foregroundColor(Color.theme.secondaryText)
                            .padding(.bottom, 8)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(BagSize.allCases, id: \.self) { size in
                                Button(action: {
                                    if selectedSizes.contains(size) {
                                        selectedSizes.remove(size)
                                    } else {
                                        selectedSizes.insert(size)
                                    }
                                }) {
                                    Text(size.rawValue)
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(selectedSizes.contains(size) ? Color.theme.primaryText : Color.theme.secondaryText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(selectedSizes.contains(size) ? Color.theme.primaryButton : Color.theme.cardBackground)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedSizes.contains(size) ? Color.theme.accentYellow : Color.theme.cardBorder, lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Preferred Sizes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { onCancel() }
                        .foregroundColor(Color.theme.primaryText)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { onSave(selectedSizes) }
                        .foregroundColor(Color.theme.accentYellow)
                        .fontWeight(.semibold)
                }
            }
            .preferredColorScheme(.dark)
            .onAppear { selectedSizes = initialSizes }
        }
    }
}

struct StyleEditorView: View {
    let initialStyles: Set<BagStyle>
    let onSave: (Set<BagStyle>) -> Void
    let onCancel: () -> Void
    
    @State private var selectedStyles: Set<BagStyle> = []
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.theme.gradientStart, Color.theme.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Tap to select your preferred bag styles")
                            .font(.ubuntu(14))
                            .foregroundColor(Color.theme.secondaryText)
                            .padding(.bottom, 8)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(BagStyle.allCases, id: \.self) { style in
                                Button(action: {
                                    if selectedStyles.contains(style) {
                                        selectedStyles.remove(style)
                                    } else {
                                        selectedStyles.insert(style)
                                    }
                                }) {
                                    Text(style.rawValue)
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(selectedStyles.contains(style) ? Color.theme.primaryText : Color.theme.secondaryText)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(selectedStyles.contains(style) ? Color.theme.primaryButton : Color.theme.cardBackground)
                                        .cornerRadius(12)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedStyles.contains(style) ? Color.theme.accentYellow : Color.theme.cardBorder, lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .navigationTitle("Preferred Styles")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { onCancel() }
                        .foregroundColor(Color.theme.primaryText)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { onSave(selectedStyles) }
                        .foregroundColor(Color.theme.accentYellow)
                        .fontWeight(.semibold)
                }
            }
            .preferredColorScheme(.dark)
            .onAppear { selectedStyles = initialStyles }
        }
    }
}

struct ProfileSectionCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(Color.theme.primaryText)
            
            content
        }
        .padding(16)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.theme.cardBorder, lineWidth: 1)
        )
    }
}

struct ProfileInfoRow: View {
    let title: String
    let value: String
    let isEditing: Bool
    let onEdit: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                Text(value)
                    .font(.ubuntu(12))
                    .foregroundColor(Color.theme.secondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if isEditing {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(Color.theme.accentYellow)
                }
            }
        }
    }
}

struct PreferenceChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(isSelected ? Color.theme.primaryText : Color.theme.secondaryText)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.theme.accentYellow : Color.theme.cardBackground)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? Color.theme.accentYellow : Color.theme.cardBorder, lineWidth: 1)
                )
        }
    }
}

struct NotificationToggle: View {
    let title: String
    let description: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(Color.theme.primaryText)
                
                Text(description)
                    .font(.ubuntu(12))
                    .foregroundColor(Color.theme.secondaryText)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(Color.theme.accentYellow)
        }
    }
}

#Preview {
    NavigationView {
        ProfileView()
            .environmentObject(UserViewModel())
    }
}
