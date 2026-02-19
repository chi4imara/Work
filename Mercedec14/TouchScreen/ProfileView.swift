import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppStateManager
    @StateObject private var viewModel = ProfileViewModel(user: User())
    @State private var showingImagePicker = false
    @State private var showingStressLevelPicker = false
    @State private var selectedImage: UIImage?
    
    var body: some View {
        ZStack {
            Color.clear
            
            ScrollView {
                VStack(spacing: 24) {
                    profileHeaderSection
                    
                    personalInfoSection
                    
                    preferencesSection
                    
                    notificationsSection
                    
                    if viewModel.isEditing {
                        saveButtonSection
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
        .onAppear {
            viewModel.setUser(appState.currentUser)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePickerView(image: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            guard let image = newImage else { return }
            if let path = saveImageToDocuments(image) {
                viewModel.setAvatarPath(path)
            }
        }
    }
    
    private func saveImageToDocuments(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        let fileName = "avatar_\(UUID().uuidString).jpg"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
            return fileURL.path
        } catch {
            return nil
        }
    }
    
    private var profileHeaderSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Profile")
                    .font(.ubuntu(24, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Spacer()
                
                Button(viewModel.isEditing ? "Cancel" : "Edit") {
                    if viewModel.isEditing {
                        viewModel.cancelEditing()
                    } else {
                        viewModel.startEditing()
                    }
                }
                .font(.ubuntu(16, weight: .medium))
                .foregroundColor(ColorTheme.primaryBlue)
            }
            
            VStack(spacing: 12) {
                Button(action: {
                    if viewModel.isEditing {
                        showingImagePicker = true
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [ColorTheme.primaryBlue, ColorTheme.primaryYellow],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 100, height: 100)
                        
                        avatarImageContent
                        
                        if viewModel.isEditing {
                            Circle()
                                .fill(Color.black.opacity(0.3))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .disabled(!viewModel.isEditing)
                
                VStack(spacing: 4) {
                    Text(viewModel.isEditing ? viewModel.tempUser.name : viewModel.user.name)
                        .font(.ubuntu(20, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    Text(viewModel.isEditing ? viewModel.tempUser.email : viewModel.user.email)
                        .font(.ubuntu(14, weight: .regular))
                        .foregroundColor(ColorTheme.textSecondary)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    @ViewBuilder
    private var avatarImageContent: some View {
        let avatarPath = viewModel.isEditing ? viewModel.tempUser.avatar : viewModel.user.avatar
        let name = viewModel.isEditing ? viewModel.tempUser.name : viewModel.user.name
        
        if let path = avatarPath, !path.isEmpty {
            if path.hasPrefix("http") {
                AsyncImage(url: URL(string: path)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Text(String(name.prefix(1)))
                        .font(.ubuntu(36, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            } else if let uiImage = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Text(String(name.prefix(1)))
                    .font(.ubuntu(36, weight: .bold))
                    .foregroundColor(.white)
            }
        } else {
            Text(String(name.prefix(1)))
                .font(.ubuntu(36, weight: .bold))
                .foregroundColor(.white)
        }
    }
    
    private var personalInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personal Information")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(spacing: 16) {
                ProfileField(
                    title: "Full Name",
                    value: viewModel.isEditing ? $viewModel.tempUser.name : .constant(viewModel.user.name),
                    isEditing: viewModel.isEditing
                )
                
                ProfileField(
                    title: "Email Address",
                    value: viewModel.isEditing ? $viewModel.tempUser.email : .constant(viewModel.user.email),
                    isEditing: viewModel.isEditing
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Stress Level")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    HStack {
                        Text("\(viewModel.isEditing ? viewModel.tempUser.stressLevel : viewModel.user.stressLevel)/10")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(ColorTheme.primaryBlue)
                        
                        if viewModel.isEditing {
                            Spacer()
                            
                            Slider(
                                value: Binding(
                                    get: { Double(viewModel.tempUser.stressLevel) },
                                    set: { viewModel.tempUser.stressLevel = Int($0) }
                                ),
                                in: 1...10,
                                step: 1
                            )
                            .accentColor(ColorTheme.primaryBlue)
                            .frame(width: 150)
                        } else {
                            Spacer()
                            
                            Text(stressLevelDescription(viewModel.user.stressLevel))
                                .font(.ubuntu(12, weight: .regular))
                                .foregroundColor(ColorTheme.textSecondary)
                        }
                    }
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Massage Preferences")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Preferred Types")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(MassageType.allCases, id: \.self) { type in
                            PreferenceToggle(
                                title: type.rawValue,
                                icon: type.icon,
                                color: type.color,
                                isSelected: viewModel.isEditing ?
                                viewModel.tempUser.preferences.preferredTypes.contains(type) :
                                    viewModel.user.preferences.preferredTypes.contains(type),
                                isEditing: viewModel.isEditing
                            ) {
                                if viewModel.isEditing {
                                    viewModel.updatePreference(type: type, isSelected: !viewModel.tempUser.preferences.preferredTypes.contains(type))
                                }
                            }
                        }
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Maximum Price per Session")
                        .font(.ubuntu(14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    HStack {
                        Text("$\(Int(viewModel.isEditing ? viewModel.tempUser.preferences.maxPrice : viewModel.user.preferences.maxPrice))")
                            .font(.ubuntu(16, weight: .bold))
                            .foregroundColor(ColorTheme.primaryBlue)
                        
                        if viewModel.isEditing {
                            Spacer()
                            
                            Slider(
                                value: $viewModel.tempUser.preferences.maxPrice,
                                in: 50...300,
                                step: 10
                            )
                            .accentColor(ColorTheme.primaryBlue)
                            .frame(width: 150)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Notification Settings")
                .font(.ubuntu(18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            VStack(spacing: 16) {
                NotificationToggle(
                    title: "Session Reminders",
                    description: "Get notified before your scheduled sessions",
                    isOn: viewModel.isEditing ?
                    $viewModel.tempUser.notificationSettings.sessionReminders :
                            .constant(viewModel.user.notificationSettings.sessionReminders),
                    isEditing: viewModel.isEditing
                )
                
                NotificationToggle(
                    title: "Promotions & Offers",
                    description: "Receive updates about special deals",
                    isOn: viewModel.isEditing ?
                    $viewModel.tempUser.notificationSettings.promotions :
                            .constant(viewModel.user.notificationSettings.promotions),
                    isEditing: viewModel.isEditing
                )
                
                NotificationToggle(
                    title: "Master Recommendations",
                    description: "Get suggestions for new massage therapists",
                    isOn: viewModel.isEditing ?
                    $viewModel.tempUser.notificationSettings.masterRecommendations :
                            .constant(viewModel.user.notificationSettings.masterRecommendations),
                    isEditing: viewModel.isEditing
                )
                
                NotificationToggle(
                    title: "Progress Updates",
                    description: "Weekly summaries of your wellness journey",
                    isOn: viewModel.isEditing ?
                    $viewModel.tempUser.notificationSettings.progressUpdates :
                            .constant(viewModel.user.notificationSettings.progressUpdates),
                    isEditing: viewModel.isEditing
                )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(ColorTheme.cardGradient)
                    .shadow(color: ColorTheme.shadowColor, radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var saveButtonSection: some View {
        Button(action: {
            viewModel.saveChanges()
            appState.currentUser = viewModel.user
            appState.saveCurrentUser()
        }) {
            Text("Save Changes")
                .font(.ubuntu(16, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(ColorTheme.buttonGradient)
                )
                .shadow(color: ColorTheme.shadowColor, radius: 10, x: 0, y: 5)
        }
    }
    
    private func stressLevelDescription(_ level: Int) -> String {
        switch level {
        case 1...2: return "Very Low"
        case 3...4: return "Low"
        case 5...6: return "Moderate"
        case 7...8: return "High"
        case 9...10: return "Very High"
        default: return "Moderate"
        }
    }
}

struct ProfileField: View {
    let title: String
    @Binding var value: String
    let isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(ColorTheme.textSecondary)
            
            if isEditing {
                TextField(title, text: $value)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorTheme.backgroundWhite)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(ColorTheme.primaryBlue.opacity(0.3), lineWidth: 1)
                            )
                    )
            } else {
                Text(value)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct PreferenceToggle: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let isEditing: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : color)
                
                Text(title)
                    .font(.ubuntu(12, weight: .medium))
                    .foregroundColor(isSelected ? .white : ColorTheme.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? color : ColorTheme.backgroundWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(color.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .disabled(!isEditing)
        .animation(.spring(response: 0.3), value: isSelected)
    }
}

struct NotificationToggle: View {
    let title: String
    let description: String
    @Binding var isOn: Bool
    let isEditing: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.ubuntu(14, weight: .medium))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text(description)
                    .font(.ubuntu(12, weight: .regular))
                    .foregroundColor(ColorTheme.textSecondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(ColorTheme.primaryBlue)
                .disabled(!isEditing)
        }
    }
}

#Preview {
    ProfileView()
}
