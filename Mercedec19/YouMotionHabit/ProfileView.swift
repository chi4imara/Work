import SwiftUI
import PhotosUI

struct ProfileView: View {
    @EnvironmentObject var userProfileVM: UserProfileViewModel
    @State private var isEditing = false
    @State private var tempProfile = UserProfile()
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showCamera = false
    @State private var showPhotoSourceSheet = false
    
    private var displayedPhotoFileName: String? {
        isEditing ? tempProfile.avatarPhotoFileName : userProfileVM.profile.avatarPhotoFileName
    }
    
    private var displayedAvatarIcon: String? {
        isEditing ? tempProfile.avatarImageName : userProfileVM.profile.avatarImageName
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()

            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Profile")
                            .font(.ubuntu(24, weight: .bold))
                            .foregroundColor(ColorTheme.textPrimary)
                        
                        Text("Manage your personal data and preferences")
                            .font(.ubuntu(14, weight: .regular))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(isEditing ? "Cancel" : "Edit") {
                        if isEditing {
                            tempProfile = userProfileVM.profile
                        } else {
                            tempProfile = userProfileVM.profile
                        }
                        isEditing.toggle()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(isEditing ? ColorTheme.textSecondary : ColorTheme.primaryYellow)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(ColorTheme.primaryYellow.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                
                                if let fileName = displayedPhotoFileName,
                                   let image = AvatarPhotoStorage.loadImage(fileName: fileName) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } else if let iconName = displayedAvatarIcon {
                                    Image(systemName: iconName)
                                        .font(.system(size: 40, weight: .medium))
                                        .foregroundColor(ColorTheme.primaryYellow)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40, weight: .medium))
                                        .foregroundColor(ColorTheme.primaryYellow)
                                }
                                
                                if isEditing {
                                    Button(action: { showPhotoSourceSheet = true }) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(ColorTheme.primaryBlue)
                                            .padding(8)
                                            .background(ColorTheme.primaryYellow)
                                            .clipShape(Circle())
                                    }
                                    .offset(x: 35, y: 35)
                                }
                            }
                        }
                        
                        ProfileSection(title: "Personal Information") {
                            VStack(spacing: 16) {
                                ProfileField(
                                    title: "Name",
                                    value: isEditing ? $tempProfile.name : .constant(userProfileVM.profile.name),
                                    isEditing: isEditing,
                                    placeholder: "Enter your name"
                                )
                                
                                ProfileField(
                                    title: "Email",
                                    value: isEditing ? $tempProfile.email : .constant(userProfileVM.profile.email),
                                    isEditing: isEditing,
                                    placeholder: "Enter your email"
                                )
                            }
                        }
                        
                        ProfileSection(title: "Fitness Preferences") {
                            VStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Fitness Level")
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(ColorTheme.textPrimary)
                                    
                                    if isEditing {
                                        Menu {
                                            ForEach(FitnessLevel.allCases, id: \.self) { level in
                                                Button(level.rawValue) {
                                                    tempProfile.fitnessLevel = level
                                                }
                                            }
                                        } label: {
                                            HStack {
                                                Text(tempProfile.fitnessLevel.rawValue)
                                                    .font(.ubuntu(16, weight: .regular))
                                                    .foregroundColor(ColorTheme.textPrimary)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "chevron.down")
                                                    .font(.system(size: 12, weight: .medium))
                                                    .foregroundColor(ColorTheme.textSecondary)
                                            }
                                            .padding(12)
                                            .background(ColorTheme.cardBackground)
                                            .cornerRadius(8)
                                        }
                                    } else {
                                        Text(userProfileVM.profile.fitnessLevel.rawValue)
                                            .font(.ubuntu(16, weight: .regular))
                                            .foregroundColor(ColorTheme.textPrimary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(12)
                                            .background(ColorTheme.cardBackground)
                                            .cornerRadius(8)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Fitness Goals")
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(ColorTheme.textPrimary)
                                    
                                    if isEditing {
                                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                            ForEach(FitnessGoal.allCases, id: \.self) { goal in
                                                GoalToggleButton(
                                                    goal: goal,
                                                    isSelected: tempProfile.goals.contains(goal)
                                                ) {
                                                    if tempProfile.goals.contains(goal) {
                                                        tempProfile.goals.removeAll { $0 == goal }
                                                    } else {
                                                        tempProfile.goals.append(goal)
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        if userProfileVM.profile.goals.isEmpty {
                                            Text("No goals selected")
                                                .font(.ubuntu(14, weight: .regular))
                                                .foregroundColor(ColorTheme.textSecondary)
                                        } else {
                                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                                ForEach(userProfileVM.profile.goals, id: \.self) { goal in
                                                    Text(goal.rawValue)
                                                        .font(.ubuntu(12, weight: .medium))
                                                        .foregroundColor(ColorTheme.textPrimary)
                                                        .padding(.horizontal, 12)
                                                        .padding(.vertical, 6)
                                                        .frame(maxWidth: .infinity)
                                                        .background(ColorTheme.primaryYellow.opacity(0.3))
                                                        .cornerRadius(12)
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Preferred Workouts")
                                        .font(.ubuntu(14, weight: .medium))
                                        .foregroundColor(ColorTheme.textPrimary)
                                    
                                    if isEditing {
                                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                            ForEach(WorkoutType.allCases, id: \.self) { type in
                                                WorkoutToggleButton(
                                                    type: type,
                                                    isSelected: tempProfile.preferredWorkouts.contains(type)
                                                ) {
                                                    if tempProfile.preferredWorkouts.contains(type) {
                                                        tempProfile.preferredWorkouts.removeAll { $0 == type }
                                                    } else {
                                                        tempProfile.preferredWorkouts.append(type)
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        if userProfileVM.profile.preferredWorkouts.isEmpty {
                                            Text("No preferences selected")
                                                .font(.ubuntu(14, weight: .regular))
                                                .foregroundColor(ColorTheme.textSecondary)
                                        } else {
                                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                                ForEach(userProfileVM.profile.preferredWorkouts, id: \.self) { type in
                                                    Text(type.rawValue)
                                                        .font(.ubuntu(12, weight: .medium))
                                                        .foregroundColor(ColorTheme.textPrimary)
                                                        .padding(.horizontal, 12)
                                                        .padding(.vertical, 6)
                                                        .frame(maxWidth: .infinity)
                                                        .background(ColorTheme.accentPurple.opacity(0.3))
                                                        .cornerRadius(12)
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        
                        ProfileSection(title: "Settings") {
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Push Notifications")
                                        .font(.ubuntu(16, weight: .medium))
                                        .foregroundColor(ColorTheme.textPrimary)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: isEditing ? $tempProfile.notificationsEnabled : .constant(userProfileVM.profile.notificationsEnabled))
                                        .toggleStyle(SwitchToggleStyle(tint: ColorTheme.primaryYellow))
                                        .disabled(!isEditing)
                                }
                            }
                        }
                        
                        if isEditing {
                            Button {
                                userProfileVM.profile = tempProfile
                                userProfileVM.saveProfile()
                                isEditing = false
                            } label: {
                                Text("Save Changes")
                                    .font(.ubuntu(16, weight: .bold))
                                    .foregroundColor(ColorTheme.primaryBlue)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(ColorTheme.primaryYellow)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 120)
                }
            }
        }
        .onAppear {
            tempProfile = userProfileVM.profile
        }
        .onChange(of: selectedPhotoItem) { newItem in
            Task {
                guard let item = newItem,
                      let data = try? await item.loadTransferable(type: Data.self),
                      let uiImage = UIImage(data: data) else { return }
                await MainActor.run {
                    if AvatarPhotoStorage.saveImage(uiImage) != nil {
                        tempProfile.avatarPhotoFileName = AvatarPhotoStorage.fileName
                        tempProfile.avatarImageName = nil
                    }
                    selectedPhotoItem = nil
                    showPhotoSourceSheet = false
                }
            }
        }
        .sheet(isPresented: $showPhotoSourceSheet) {
            PhotoSourceSheet(
                selectedPhotoItem: $selectedPhotoItem,
                onCameraTap: {
                    showPhotoSourceSheet = false
                    showCamera = true
                },
                onDismiss: { showPhotoSourceSheet = false }
            )
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraImagePicker { image in
                if let image = image, AvatarPhotoStorage.saveImage(image) != nil {
                    tempProfile.avatarPhotoFileName = AvatarPhotoStorage.fileName
                    tempProfile.avatarImageName = nil
                }
                showCamera = false
            }
        }
    }
}

struct PhotoSourceSheet: View {
    @Binding var selectedPhotoItem: PhotosPickerItem?
    let onCameraTap: () -> Void
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AnimatedBackground()
                
                VStack(spacing: 24) {
                    PhotosPicker(
                        selection: $selectedPhotoItem,
                        matching: .images
                    ) {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 22, weight: .medium))
                            Text("Photo Library")
                                .font(.ubuntu(18, weight: .medium))
                        }
                        .foregroundColor(ColorTheme.primaryWhite)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(ColorTheme.primaryYellow)
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                        Button(action: onCameraTap) {
                            HStack {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 22, weight: .medium))
                                Text("Camera")
                                    .font(.ubuntu(18, weight: .medium))
                            }
                            .foregroundColor(ColorTheme.primaryWhite)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(ColorTheme.cardBorder, lineWidth: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 40)
            }
            .navigationTitle("Change Photo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        onDismiss()
                    }
                    .font(.ubuntu(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryYellow)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct CameraImagePicker: UIViewControllerRepresentable {
    let onImagePicked: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraImagePicker
        
        init(_ parent: CameraImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            let image = info[.originalImage] as? UIImage
            parent.onImagePicked(image)
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onImagePicked(nil)
            picker.dismiss(animated: true)
        }
    }
}

struct ProfileSection<Content: View>: View {
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
                .foregroundColor(ColorTheme.textPrimary)
            
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(ColorTheme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(ColorTheme.cardBorder, lineWidth: 1)
        )
    }
}

struct ProfileField: View {
    let title: String
    @Binding var value: String
    let isEditing: Bool
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.ubuntu(14, weight: .medium))
                .foregroundColor(ColorTheme.textPrimary)
            
            if isEditing {
                TextField(placeholder, text: $value)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.textPrimary)
                    .padding(12)
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(ColorTheme.cardBorder, lineWidth: 1)
                    )
            } else {
                Text(value.isEmpty ? "Not set" : value)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(value.isEmpty ? ColorTheme.textSecondary : ColorTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(8)
            }
        }
    }
}

struct GoalToggleButton: View {
    let goal: FitnessGoal
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            Text(goal.rawValue)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(isSelected ? ColorTheme.primaryBlue : ColorTheme.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? ColorTheme.primaryYellow : ColorTheme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    isSelected ? ColorTheme.primaryYellow : ColorTheme.cardBorder,
                                    lineWidth: 1
                                )
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WorkoutToggleButton: View {
    let type: WorkoutType
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            Text(type.rawValue)
                .font(.ubuntu(12, weight: .medium))
                .foregroundColor(isSelected ? ColorTheme.primaryWhite : ColorTheme.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? ColorTheme.accentPurple.opacity(0.3) : ColorTheme.cardBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    isSelected ? ColorTheme.accentPurple : ColorTheme.cardBorder,
                                    lineWidth: 1
                                )
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
