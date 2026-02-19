import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @State private var showingImageSourceDialog = false
    @State private var showingImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    init(appViewModel: AppViewModel) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(appViewModel: appViewModel))
    }
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack {
                HStack {
                    Text("Profile")
                        .font(.playfair(32, weight: .bold))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Spacer()
                    
                    Button(viewModel.isEditing ? "Cancel" : "Edit") {
                        if viewModel.isEditing {
                            viewModel.cancelEditing()
                        } else {
                            viewModel.startEditing()
                        }
                    }
                    .font(.playfair(24, weight: .bold))
                    .foregroundColor(ColorTheme.primaryBlue)
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 24) {
                        profileHeader
                        personalInfoSection
                        interestsSection
                        goalsSection
                        fatigueSection
                        notificationsSection
                        saveButton
                    }
                    .padding()
                }
            }
        }
        .fullScreenCover(isPresented: $showingImagePicker) {
            ImagePicker(sourceType: imagePickerSourceType) { image in
                if let path = AvatarStorage.save(image) {
                    viewModel.tempProfile.avatar = path
                }
                showingImagePicker = false
            }
            .ignoresSafeArea()
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [ColorTheme.primaryBlue, ColorTheme.lightBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                if viewModel.tempProfile.avatar.isEmpty {
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                } else {
                    AvatarImageView(path: viewModel.tempProfile.avatar)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
                
                if viewModel.isEditing {
                    Button(action: { showingImageSourceDialog = true }) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(ColorTheme.primaryBlue)
                            .clipShape(Circle())
                    }
                    .offset(x: 35, y: 35)
                    .confirmationDialog("Choose Photo", isPresented: $showingImageSourceDialog) {
                        Button("Photo Library") {
                            imagePickerSourceType = .photoLibrary
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                showingImagePicker = true
                            }
                        }
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            Button("Take Photo") {
                                imagePickerSourceType = .camera
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                    showingImagePicker = true
                                }
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Select a photo for your avatar")
                    }
                }
            }
            
            if viewModel.isEditing {
                TextField("Name", text: $viewModel.tempProfile.name)
                    .font(.playfair(20, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(viewModel.tempProfile.name.isEmpty ? "User" : viewModel.tempProfile.name)
                    .font(.playfair(24, weight: .bold))
                    .foregroundColor(ColorTheme.primaryText)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(ColorTheme.cardGradient)
                .shadow(color: ColorTheme.primaryBlue.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var personalInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personal Information")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            VStack(spacing: 12) {
                profileField("Email", value: $viewModel.tempProfile.email, isEditing: viewModel.isEditing)
                
                HStack {
                    Text("Preferred Duration")
                        .font(.playfair(16))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    Spacer()
                    
                    if viewModel.isEditing {
                        Stepper(
                            "\(viewModel.tempProfile.preferredDuration) min",
                            value: $viewModel.tempProfile.preferredDuration,
                            in: 15...180,
                            step: 15
                        )
                        .font(.playfair(16, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                    } else {
                        Text("\(viewModel.tempProfile.preferredDuration) minutes")
                            .font(.playfair(16, weight: .medium))
                            .foregroundColor(ColorTheme.primaryText)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var interestsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interests")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(ActivityType.allCases, id: \.self) { interest in
                    InterestChip(
                        interest: interest,
                        isSelected: viewModel.tempProfile.interests.contains(interest),
                        isEditing: viewModel.isEditing
                    ) {
                        if viewModel.isEditing {
                            if viewModel.tempProfile.interests.contains(interest) {
                                viewModel.tempProfile.interests.removeAll { $0 == interest }
                            } else {
                                viewModel.tempProfile.interests.append(interest)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Leisure Goals")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(ActivityGoal.allCases, id: \.self) { goal in
                    GoalChip(
                        goal: goal,
                        isSelected: viewModel.tempProfile.goals.contains(goal),
                        isEditing: viewModel.isEditing
                    ) {
                        if viewModel.isEditing {
                            if viewModel.tempProfile.goals.contains(goal) {
                                viewModel.tempProfile.goals.removeAll { $0 == goal }
                            } else {
                                viewModel.tempProfile.goals.append(goal)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var fatigueSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Current Fatigue Level")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            if viewModel.isEditing {
                Picker("Fatigue Level", selection: $viewModel.tempProfile.fatigueLevel) {
                    ForEach(FatigueLevel.allCases, id: \.self) { level in
                        VStack(alignment: .leading) {
                            Text(level.rawValue)
                                .font(.playfair(16, weight: .medium))
                            Text(level.description)
                                .font(.playfair(12))
                                .foregroundColor(ColorTheme.secondaryText)
                        }
                        .tag(level)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(height: 120)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.tempProfile.fatigueLevel.rawValue)
                        .font(.playfair(18, weight: .medium))
                        .foregroundColor(ColorTheme.primaryText)
                    
                    Text(viewModel.tempProfile.fatigueLevel.description)
                        .font(.playfair(14))
                        .foregroundColor(ColorTheme.secondaryText)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Notification Settings")
                .font(.playfair(20, weight: .semibold))
                .foregroundColor(ColorTheme.primaryText)
            
            Toggle("Enable Notifications", isOn: $viewModel.tempProfile.notificationsEnabled)
                .font(.playfair(16))
                .foregroundColor(ColorTheme.primaryText)
                .tint(ColorTheme.primaryBlue)
                .disabled(!viewModel.isEditing)
            
            if viewModel.tempProfile.notificationsEnabled {
                VStack(alignment: .leading, spacing: 8) {
                    Text("You'll receive reminders about:")
                        .font(.playfair(14))
                        .foregroundColor(ColorTheme.secondaryText)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        bulletPoint("Scheduled activities")
                        bulletPoint("Daily leisure recommendations")
                        bulletPoint("Weekly progress updates")
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorTheme.cardGradient)
        )
    }
    
    private var saveButton: some View {
        Group {
            if viewModel.isEditing {
                Button {
                    viewModel.saveChanges()
                } label: {
                    Text("Save Changes")
                        .font(.playfair(18, weight: .semibold))
                        .foregroundColor(ColorTheme.primaryText)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(ColorTheme.buttonGradient)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: ColorTheme.primaryYellow.opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
    }
    
    private func profileField(_ title: String, value: Binding<String>, isEditing: Bool) -> some View {
        HStack {
            Text(title)
                .font(.playfair(16))
                .foregroundColor(ColorTheme.secondaryText)
                .frame(width: 80, alignment: .leading)
            
            if isEditing {
                TextField(title, text: value)
                    .font(.playfair(16))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(value.wrappedValue.isEmpty ? "Not set" : value.wrappedValue)
                    .font(.playfair(16, weight: .medium))
                    .foregroundColor(ColorTheme.primaryText)
                
                Spacer()
            }
        }
    }
    
    private func bulletPoint(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.playfair(14))
                .foregroundColor(ColorTheme.primaryBlue)
            
            Text(text)
                .font(.playfair(14))
                .foregroundColor(ColorTheme.secondaryText)
            
            Spacer()
        }
    }
}

struct InterestChip: View {
    let interest: ActivityType
    let isSelected: Bool
    let isEditing: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: interest.icon)
                    .font(.system(size: 16))
                
                Text(interest.rawValue)
                    .font(.playfair(14, weight: .medium))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? ColorTheme.primaryBlue : ColorTheme.backgroundWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(ColorTheme.primaryBlue.opacity(0.3), lineWidth: 1)
                    )
            )
            .foregroundColor(isSelected ? .white : ColorTheme.primaryText)
        }
        .disabled(!isEditing)
        .opacity(isEditing ? 1.0 : (isSelected ? 1.0 : 0.6))
    }
}

struct GoalChip: View {
    let goal: ActivityGoal
    let isSelected: Bool
    let isEditing: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: "target")
                    .font(.system(size: 16))
                
                Text(goal.rawValue)
                    .font(.playfair(12, weight: .medium))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .frame(minHeight: 60)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? ColorTheme.primaryYellow.opacity(0.3) : ColorTheme.backgroundWhite)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? ColorTheme.primaryYellow : ColorTheme.lightBlue, lineWidth: 1)
                    )
            )
            .foregroundColor(ColorTheme.primaryText)
        }
        .disabled(!isEditing)
        .opacity(isEditing ? 1.0 : (isSelected ? 1.0 : 0.6))
    }
}

#Preview {
    ProfileView(appViewModel: AppViewModel())
}
