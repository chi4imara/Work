import SwiftUI
import PhotosUI
import AVFoundation
import StoreKit

struct ProfileView: View {
    @StateObject private var profileManager = ProfileManager.shared
    @StateObject private var appColors = AppColors.shared
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingActionSheet = false
    @State private var showingRateAlert = false
    @State private var showingEditName = false
    @State private var tempName = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                appColors.backgroundGradient
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        HStack {
                            Text("Profile")
                                .font(.builderSans(.bold, size: 28))
                                .foregroundColor(appColors.textPrimary)
                            
                            Spacer()
                        }
                        .padding()
                        
                        profileHeader
                        
                        personalizationSection
                        
                        appSettingsSection
                        
                        legalSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
        }
        .onAppear {
            tempName = profileManager.userName
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $profileManager.avatarImage)
        }
        .sheet(isPresented: $showingCamera) {
            CameraView(selectedImage: $profileManager.avatarImage)
        }
        .alert("Edit Name", isPresented: $showingEditName) {
            TextField("Enter your name", text: $tempName)
            Button("Save") {
                profileManager.userName = tempName
            }
            Button("Cancel", role: .cancel) {
                tempName = profileManager.userName
            }
        } message: {
            Text("Enter your name to personalize your experience")
        }
        .alert("Rate MoodfulSkies", isPresented: $showingRateAlert) {
            Button("Not Now", role: .cancel) { }
            Button("Rate App") {
                requestReview()
            }
        } message: {
            Text("If you enjoy using MoodfulSkies, would you mind taking a moment to rate it?")
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(appColors.cardGradient)
                    .frame(width: 120, height: 120)
                    .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.2), radius: 20, x: 0, y: 10)
                
                if let avatarImage = profileManager.avatarImage {
                    Image(uiImage: avatarImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(appColors.primaryBlue)
                }
                
                Button(action: {
                    showingActionSheet = true
                }) {
                    ZStack {
                        Circle()
                            .fill(appColors.primaryOrange)
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "camera.fill")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .offset(x: 40, y: 40)
            }
            .confirmationDialog("Select Photo", isPresented: $showingActionSheet) {
                Button("Camera") {
                    checkCameraPermission()
                }
                Button("Photo Library") {
                    showingImagePicker = true
                }
                Button("Cancel", role: .cancel) { }
            }
            
            VStack(spacing: 8) {
                Text(profileManager.userName.isEmpty ? "Your Name" : profileManager.userName)
                    .font(.builderSans(.bold, size: 24))
                    .foregroundColor(appColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Button(action: {
                    showingEditName = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "pencil")
                            .font(.system(size: 12))
                        Text("Edit Name")
                            .font(.builderSans(.medium, size: 14))
                    }
                    .foregroundColor(appColors.primaryBlue)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(appColors.cardGradient)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: 1)
                }
                .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 15, x: 0, y: 8)
        )
    }
    
    private var personalizationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personalization")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
                .padding(.horizontal, 20)
            
            Divider()
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 0) {
                NavigationLink(destination: ThemeSettingsView()) {
                    ProfileRowFirst(
                        icon: "paintbrush.fill",
                        title: "Theme",
                        subtitle: "Customize your app appearance",
                        iconColor: appColors.accentPurple
                    )
                }
                
                Divider()
                    .padding(.leading, 50)
                
                NavigationLink(destination: NotificationSettingsView()) {
                    ProfileRowFirst(
                        icon: "bell.fill",
                        title: "Notifications",
                        subtitle: "Daily mood reminders",
                        iconColor: appColors.accentGreen
                    )
                }
                
                Divider()
                    .padding(.leading, 50)
                
                NavigationLink(destination: GoalsSettingsView()) {
                    ProfileRowFirst(
                        icon: "chart.line.uptrend.xyaxis",
                        title: "Goals",
                        subtitle: "Set your mood tracking goals",
                        iconColor: appColors.primaryOrange
                    ) 
                }
            }
        }
        .padding(.top, 20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private var appSettingsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("App Settings")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                ProfileRow(
                    icon: "star.fill",
                    title: "Rate the App",
                    subtitle: "Help us improve",
                    iconColor: appColors.accentPink
                ) {
                    showingRateAlert = true
                    
                    Divider()
                        .padding(.leading, 50)
                    
                    ProfileRow(
                        icon: "square.and.arrow.up",
                        title: "Share App",
                        subtitle: "Tell your friends",
                        iconColor: appColors.accentGreen
                    ) {
                        shareApp()
                    }
                    
                    Divider()
                        .padding(.leading, 50)
                    
                    ProfileRow(
                        icon: "trash.fill",
                        title: "Clear Data",
                        subtitle: "Reset all entries",
                        iconColor: .red
                    ) {
                        clearAllData()
                    }
                }
            }
            .background(appColors.cardGradient)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.gray, lineWidth: 1)
            }
            .cornerRadius(16)
            .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    private var legalSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Legal & Support")
                .font(.builderSans(.semiBold, size: 20))
                .foregroundColor(appColors.textPrimary)
                .padding(.horizontal, 20)
            
            Divider()
                .frame(maxWidth: .infinity)
            
            VStack(spacing: 0) {
                ProfileRow(
                    icon: "doc.text",
                    title: "Terms of Use",
                    subtitle: "App terms and conditions",
                    iconColor: appColors.primaryBlue
                ) {
                    openURL("https://www.privacypolicies.com/live/cc7186d0-7155-4266-9f4f-8301d2a4704c")
                }
                
                Divider()
                    .padding(.leading, 50)
                
                ProfileRow(
                    icon: "hand.raised",
                    title: "Privacy Policy",
                    subtitle: "How we protect your data",
                    iconColor: appColors.accentGreen
                ) {
                    openURL("https://www.privacypolicies.com/live/fef8d3a3-8757-4324-b8b3-0ad312120abb")
                }
                
                Divider()
                    .padding(.leading, 50)
                
                ProfileRow(
                    icon: "envelope",
                    title: "Contact Us",
                    subtitle: "Get help and support",
                    iconColor: appColors.primaryOrange
                ) {
                    openURL("https://www.privacypolicies.com/live/fef8d3a3-8757-4324-b8b3-0ad312120abb")
                }
            }
        }
        .padding(.top, 20)
        .background(appColors.cardGradient)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 1)
        }
        .cornerRadius(16)
        .shadow(color: Color(red: 0.4, green: 0.7, blue: 1.0, opacity: 0.1), radius: 10, x: 0, y: 5)
    }
    
    private func checkCameraPermission() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showCameraUnavailableAlert()
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showingCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        showingCamera = true
                    } else {
                        showCameraPermissionAlert()
                    }
                }
            }
        case .denied, .restricted:
            showCameraPermissionAlert()
        @unknown default:
            break
        }
    }
    
    private func showCameraUnavailableAlert() {
        let alert = UIAlertController(
            title: "Camera Unavailable",
            message: "Camera is not available on this device.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(alert, animated: true)
        }
    }
    
    private func showCameraPermissionAlert() {
        let alert = UIAlertController(
            title: "Camera Access Required",
            message: "MoodfulSkies needs access to your camera to take profile photos. Please enable camera access in Settings.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl)
            }
        })
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(alert, animated: true)
        }
    }
    
    private func shareApp() {
        let activityViewController = UIActivityViewController(
            activityItems: ["Check out MoodfulSkies - Track your mood and weather!"],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityViewController, animated: true)
        }
    }
    
    private func clearAllData() {
        DataManager.shared.entries.removeAll()
        DataManager.shared.saveEntries()
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

struct ProfileRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let action: () -> Void
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.builderSans(.medium, size: 16))
                        .foregroundColor(appColors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(subtitle)
                        .font(.builderSans(.regular, size: 14))
                        .foregroundColor(appColors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.cameraDevice = .rear
        picker.cameraCaptureMode = .photo
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
                print("Failed to get image from camera")
                DispatchQueue.main.async {
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
                return
            }
            
            parent.selectedImage = image
            DispatchQueue.main.async {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            DispatchQueue.main.async {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct ProfileRowFirst: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.builderSans(.medium, size: 16))
                        .foregroundColor(appColors.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(subtitle)
                        .font(.builderSans(.regular, size: 14))
                        .foregroundColor(appColors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
    }
}
